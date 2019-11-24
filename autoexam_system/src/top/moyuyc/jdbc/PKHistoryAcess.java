package top.moyuyc.jdbc;

import top.moyuyc.entity.PKHistory;
import top.moyuyc.tools.Tools;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Yc on 2016/2/27 for autoexam_system.
 */
public class PKHistoryAcess extends DataBase{
    public static int getPKCountByName(String name){
        try {
            if(conn==null||conn.isClosed())
                conn = DataBase.getConnInstance();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM pk_history WHERE (user1 = ? OR user2 = ?) AND status > 0");
            ps.setString(1,name);
            ps.setString(2,name);
            rs = ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static int getUnAcceptPKCountByName(String name){
        try {
            if(conn==null||conn.isClosed())
                conn = DataBase.getConnInstance();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM pk_history WHERE user2 = ? AND status =-1");
            ps.setString(1,name);
            rs = ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            Close();
        }
    }

    private static PKHistory resultSetToPKHistory(ResultSet rs) throws SQLException {
        return new PKHistory(rs.getString(1),rs.getString(2),rs.getString(3),
                Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(4).getTime())),
                rs.getInt(5),rs.getString(6),rs.getInt(7),rs.getInt(8));
    }
    public static PKHistory getDonePKHistory(String user1,String user2,String paperID){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE (status = 1 OR status = 2) AND user1=? AND user2=? AND paper_id=?");
            ps.setString(1,user1);
            ps.setString(2,user2);
            ps.setString(3,paperID);
            rs = ps.executeQuery();
            if (rs.next())
                return resultSetToPKHistory(rs);
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<PKHistory> getDonePKHistorysByName(String name,int size,int page){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE (status = 1 OR status = 2) AND (user1=? OR user2=?) ORDER by pk_time DESC  limit ?,?");
            ps.setString(1,name);
            ps.setString(2,name);
            ps.setInt(3, (page - 1) * size);
            ps.setInt(4,size);
            rs = ps.executeQuery();
            List<PKHistory> list = new LinkedList<>();
            while (rs.next())
                list.add(resultSetToPKHistory(rs));
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<PKHistory> getAllDonePKHistorysByName(String name){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE (status = 1 OR status = 2) AND (user1=? OR user2=?) ORDER by pk_time DESC");
            ps.setString(1, name);
            ps.setString(2, name);
            rs = ps.executeQuery();
            List<PKHistory> list = new LinkedList<>();
            while (rs.next())
                list.add(resultSetToPKHistory(rs));
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static PKHistory getPKHistoryByName(String name, String paperID){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE (user1=? OR user2=?) AND paper_id=?");
            ps.setString(1,name);
            ps.setString(2, name);
            ps.setString(3, paperID);
            rs = ps.executeQuery();
            if (rs.next())
                return resultSetToPKHistory(rs);
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static boolean updateDoneDrawPKHistory(String name,String paperID,int incint,int decint){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE pk_history SET status=1,inc_point=?,dec_point=?,pk_time=NOW() WHERE (user1=? OR user2=?) AND paper_id=?");
            ps.setString(3,name);
            ps.setString(4, name);
            ps.setString(5, paperID);
            ps.setInt(1, incint);
            ps.setInt(2, decint);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean updateUnDoneDrawPKHistory(String user1,String paperID){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE pk_history SET status=0,pk_time=NOW() WHERE user1=? AND paper_id=?");
            ps.setString(1, user1);
            ps.setString(2, paperID);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean updateDoneNoDrawPKHistory(String name,String paperID,String winname,int incint,int decint){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE pk_history SET status=1,inc_point=?,dec_point=?,win_name=?,pk_time=NOW() WHERE (user1=? OR user2=?) AND paper_id=?");
            ps.setString(3,winname);
            ps.setString(4,name);
            ps.setString(5, name);
            ps.setString(6, paperID);
            ps.setInt(1, incint);
            ps.setInt(2, decint);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static boolean checkIsExistsByNamesPaper(String paperID,String user1,String user2){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE paper_id=? AND ((user1=? AND user2=?) OR (user1=? AND user2=?))");
            ps.setString(1,paperID);
            ps.setString(2, user1);
            ps.setString(3, user2);
            ps.setString(4, user2);
            ps.setString(5, user1);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static void main(String[] args) {
        System.out.println(checkIsExistsByNamesPaper("AO6018","moyumoyu","qqqqqq"));
    }
    public static boolean addUnAcceptPKHistory(String paperID,String user1,String user2){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO pk_history(paper_id,user1,user2,pk_time,status) VALUES(?,?,?,NOW(),-1)");
            ps.setString(1,paperID);
            ps.setString(2, user1);
            ps.setString(3, user2);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static List<PKHistory> getUnDonePKHistorysByName(String name,int size,int page){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE status = 0 AND (user1=? OR user2=?) ORDER by pk_time DESC  limit ?,?");
            ps.setString(1,name);
            ps.setString(2,name);
            ps.setInt(3, (page - 1) * size);
            ps.setInt(4,size);
            rs = ps.executeQuery();
            List<PKHistory> list = new LinkedList<>();
            while (rs.next())
                list.add(resultSetToPKHistory(rs));
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<PKHistory> getUnAcceptPKHistorysByName(String name,int size,int page){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM pk_history WHERE status = -1 AND (user1=? OR user2=?) ORDER by pk_time DESC  limit ?,?");
            ps.setString(1, name);
            ps.setString(2, name);
            ps.setInt(3, (page - 1) * size);
            ps.setInt(4, size);
            rs = ps.executeQuery();
            List<PKHistory> list = new LinkedList<>();
            while (rs.next())
                list.add(resultSetToPKHistory(rs));
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static boolean cancelUnAcceptPKHistorysByPaperName(String paperID,String user1,String user2){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM pk_history WHERE status = -1 AND user1=? AND paper_id=? AND user2=?");
            ps.setString(1, user1);
            ps.setString(2, paperID);
            ps.setString(3, user2);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

}
