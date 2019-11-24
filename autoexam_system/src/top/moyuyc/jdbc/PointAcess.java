package top.moyuyc.jdbc;

import top.moyuyc.entity.UserPoint;

import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Yc on 2016/2/27 for autoexam_system.
 */
public class PointAcess extends DataBase {

    public static boolean deltaPoint(String name,int deltaPoint){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE user_point SET point = point+? WHERE user_name=?");
            ps.setInt(1, deltaPoint);
            ps.setString(2, name);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static void main(String[] args) {
        System.out.println(getFriendTopList("qqqqqq", 10, 1));
    }

    public static int getBeforeCountAllByName(String username) {
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            List result = new LinkedList<>();
            String sql = "SELECT DISTINCT COUNT(*) FROM (SELECT b.* FROM user_point a,user_point b\n" +
                    " WHERE a.user_name=? AND b.`user_name`!=a.`user_name` AND (b.`point`>a.`point` OR (b.`point`=a.`point` AND b.`user_name`<=a.`user_name`))) AS tab";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            return -1;
        }
        catch(SQLException e) {
            e.printStackTrace();
            return -1;
        }
        finally {
            Close();
        }
    }

    public static boolean addPoint(String name,int point){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO user_point VALUES(?,?)");
            ps.setString(1,name);
            ps.setInt(2,point);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static int getPointByName(String name){
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT point FROM user_point WHERE user_name = ?");
            ps.setString(1, name);
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



    public static int getBeforeCountFriendByName(String username) {
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            List result = new LinkedList<>();
            String sql = "SELECT DISTINCT COUNT(*) FROM (SELECT b.`user2`,a.`point` FROM user_point a,friends b WHERE b.`user1`=? AND a.`user_name`=b.`user2` AND\n" +
                    " (a.`point`>(SELECT POINT FROM user_point WHERE user_point.`user_name`=b.`user1`) OR (a.`point`=(SELECT POINT FROM user_point WHERE user_point.`user_name`=b.`user1`) AND b.`user2`<=b.`user1`))\n" +
                    "UNION\n" +
                    "SELECT b.`user1`,a.`point` FROM user_point a,friends b WHERE b.`user2`=? AND a.user_name=b.`user1` AND\n" +
                    " (a.`point`>(SELECT POINT FROM user_point WHERE user_point.`user_name`=b.`user2`) OR (a.`point`=(SELECT POINT FROM user_point WHERE user_point.`user_name`=b.`user2`) AND b.`user1`<=b.`user2`)))AS tabe\n";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            rs = ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            return -1;
        }
        catch(SQLException e) {
            e.printStackTrace();
            return -1;
        }
        finally {
            Close();
        }
    }


    public static List<UserPoint> getFriendTopList(String username,int size,int index) {
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            List result = new LinkedList<>();
            String sql = "SELECT b.`user2` AS 'user_name',c.`point` FROM friends b,user_point c WHERE b.`user1`=? AND c.`user_name`=b.`user2`\n" +
                    "UNION\n" +
                    "SELECT b.`user1` AS 'user_name',c.`point` FROM friends b,user_point c  WHERE b.`user2`=? AND c.`user_name`=b.`user1`\n" +
                    "UNION\n" +
                    "SELECT * FROM user_point WHERE user_name=?\n" +
                    "ORDER BY POINT DESC,user_name LIMIT ?,?;";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, username);
            ps.setInt(4, size*(index-1));
            ps.setInt(5, size);
            rs = ps.executeQuery();
            while(rs.next())
                result.add(new UserPoint(rs.getString(1),rs.getInt(2)));
            return result.isEmpty()?null:result;
        }
        catch(SQLException e) {
            e.printStackTrace();
            return null;
        }
        finally {
            Close();
        }
    }

    //所有用户排名
    public static List<UserPoint> getAllUserTopList(int size,int index) {
        try {
            if(conn==null||conn.isClosed())
                conn = getConnInstance();
            List result = new LinkedList<>();
            String sql = "SELECT * FROM user_point ORDER BY point DESC,user_name limit ?,?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, size*(index-1));
            ps.setInt(2, size);
            rs = ps.executeQuery();
            while(rs.next())
                result.add(new UserPoint(rs.getString(1),rs.getInt(2)));
            return result.isEmpty()?null:result;
        }
        catch(SQLException e) {
            e.printStackTrace();
            return null;
        }
        finally {
            Close();
        }
    }

}
