package top.moyuyc.jdbc;

import top.moyuyc.entity.UserHead;
import top.moyuyc.tools.Tools;

import java.sql.Date;
import java.sql.SQLException;

/**
 * Created by Yc on 2015/12/20.
 */
public class HeadAcess extends DataBase{
    public static UserHead getHeadByName(String name){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `users_head` WHERE username = ?");
            ps.setString(1,name);
            rs = ps.executeQuery();
            if (rs.next())
                return new UserHead(rs.getString(1),rs.getString(2)
                        ,Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(3).getTime())));
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static boolean addHead(String name,String headPath){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("INSERT INTO `users_head` VALUES (?,?,NOW())");
            ps.setString(1,name);
            ps.setString(2,headPath);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean updateHead(String name,String headPath){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("UPDATE `users_head` SET headpath=?,updatetime=NOW() WHERE username = ?");
            ps.setString(1, headPath);
            ps.setString(2, name);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

}
