package top.moyuyc.jdbc;

import java.sql.*;

/**
 * Created by Yc on 2016/3/7 for autoexam_system.
 */
public class Test {
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/auto_exam_system";
    private static final String USER = "root";
    private static final String PWD = "110114";
    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        Class.forName(DRIVER);
        Connection conn = DriverManager.getConnection(URL, USER, PWD);
        conn.setAutoCommit(false);


        Statement stat = conn.createStatement();
//        String sql = "select * from test";
        String sql = "insert into test VALUES(1,'xxxzxsssdxxxxxxs')";
//        ResultSet set =
        System.out.println(stat.execute(sql));
        conn.setSavepoint("");
//        ResultSetMetaData rsmd = set.getMetaData();
//        for (int i = 0; i < rsmd.getColumnCount(); i++) {
//            System.out.println(rsmd.getCatalogName(i+1));
//            System.out.println(rsmd.getColumnClassName(i+1));
//            System.out.println(rsmd.getColumnLabel(i+1));
//            System.out.println(rsmd.getColumnType(i+1));
//            System.out.println(rsmd.getColumnTypeName(i+1));
//            System.out.println(rsmd.getSchemaName(i+1));
//            System.out.println(rsmd.getTableName(i+1));
//        }
//        System.out.println(set.getInt(1));
        conn.rollback();
        conn.commit();

    }
}
