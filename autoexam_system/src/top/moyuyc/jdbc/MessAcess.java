package top.moyuyc.jdbc;

import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Created by Yc on 2015/10/18.
 */
public class MessAcess extends DataBase{
    public static void addMess(String name,String phone,String email,String mess){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO `messages` VALUES (NULL,?,?,?,?,CURRENT_DATE())");
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, mess);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            Close();
        }
    }

    public static void main(String[] args) {
        addMess("1","2,","3","3");
    }


}
