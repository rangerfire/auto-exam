package top.moyuyc.jdbc;

import top.moyuyc.entity.FriendRelation;
import top.moyuyc.tools.Tools;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Yc on 2015/12/18.
 */
public class FriendAcess extends DataBase {

    public static int getFriendCount(String user){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM friends WHERE user1=? OR user2=?");
            ps.setString(1, user);
            ps.setString(2, user);
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

    public static boolean addFriends(String user1,String user2){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO `friends` VALUES (?,?,CURRENT_DATE())");
            ps.setString(1, user1);
            ps.setString(2, user2);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static List<FriendRelation> getFriendsByName(String user1,String user2){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `friends` WHERE (user1=? AND user2=?) OR (user2=? AND user1=?)");
            ps.setString(1, user1);
            ps.setString(2, user2);
            ps.setString(1, user1);
            ps.setString(2, user2);
            rs = ps.executeQuery();
            List<FriendRelation> list = new LinkedList<>();
            while (rs.next()){
                list.add(new FriendRelation(
                        rs.getString(1),
                        rs.getString(2),
                        Tools.mySqlDateToWebDate2(rs.getDate(3))
                ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<FriendRelation> getFriends(String user,int pageIndex,int pageSize){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `friends` WHERE user1=? OR user2=? limit ?,?");
            ps.setString(1, user);
            ps.setString(2, user);
            ps.setInt(3, (pageIndex - 1) * pageSize);
            ps.setInt(4, pageSize);
            rs = ps.executeQuery();
            List<FriendRelation> list = new LinkedList<>();
            while (rs.next()){
                list.add(new FriendRelation(
                        rs.getString(1),
                        rs.getString(2),
                        Tools.mySqlDateToWebDate2(rs.getDate(3))
                        ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<FriendRelation> getAllFriends(String user){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `friends` WHERE user1=? OR user2=?");
            ps.setString(1, user);
            ps.setString(2, user);
            rs = ps.executeQuery();
            List<FriendRelation> list = new LinkedList<>();
            while (rs.next()){
                list.add(new FriendRelation(
                        rs.getString(1),
                        rs.getString(2),
                        Tools.mySqlDateToWebDate2(rs.getDate(3))
                ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static boolean checkFriendIsExists(String user1,String user2){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `friends` WHERE (user1=? AND user2=?)" +
                            " OR (user2=? AND user1=?)");
            ps.setString(1, user1);
            ps.setString(2, user2);
            ps.setString(3, user1);
            ps.setString(4, user2);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean delFriend(String user1,String user2){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `friends` WHERE (user1=? AND user2=?)" +
                             " OR (user2=? AND user1=?)");
            ps.setString(1, user1);
            ps.setString(2, user2);
            ps.setString(3, user1);
            ps.setString(4, user2);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static void main(String[] args) {
        addFriends("qqqqqq", "moyumoyu");
//        System.out.println(getFriendsByName("moyumoyu").get(0).getDate());
//        System.out.println(checkFriendIsExists("moyumoyu","qqqqqq"));
//        System.out.println(delFriend("moyumoyu","qqqqqq"));
    }
}
