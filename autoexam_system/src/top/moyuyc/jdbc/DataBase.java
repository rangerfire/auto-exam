package top.moyuyc.jdbc;

import java.sql.*;

/**
 * Created by Yc on 2015/9/15.
 * Mysql数据库访问基类
 */
public class DataBase {

    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/auto_exam_system";
    private static final String USER = "root";
    private static final String PWD = "110114";
    protected static Connection conn;
    protected static Statement stmt;
    protected static PreparedStatement ps;
    protected static ResultSet rs;

    static {
        try {
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(URL,USER,PWD);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected static void Close() {
        try {
            if (ps != null) {
                ps.close();
                ps = null;
            }
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (stmt != null) {
                stmt.close();
                stmt = null;
            }
//            if (conn != null) {
//                conn.close();
//                conn = null;
//            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    protected static final Connection getConnInstance(){
        try {
            return DriverManager.getConnection(URL,USER,PWD);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    public static void main(String[] args) {
        System.out.println(3/0);
        System.out.println(3);
    }

}
