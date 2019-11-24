package top.moyuyc.jdbc;

import top.moyuyc.entity.User;
import top.moyuyc.tools.Tools;

import java.sql.Date;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Yc on 2015/9/15.
 * 用户信息数据库操作
 */
public class UserAcess extends DataBase {
    /**
     * 按照什么排序
     *
     */
    public static final String USER_NAME = "user_name";
    public static final String USER_PWD = "user_pwd";
    public static final String USER_EMAIL = "user_email";
    public static final String CREATE_TIME = "create_time";

    /**
     * 检查用户是否存在，用于登录验证
     *
     * @param user_name 用户名
     * @param user_pwd  用户密码
     * @return true or false
     */
    public static boolean checkUser(String user_name, String user_pwd) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_name`=? AND `user_pwd`=?");
            ps.setString(1, user_name);
            ps.setString(2, user_pwd);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static boolean checkUserByEmail(String user_name, String email) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_name`=? AND `user_email`=?");
            ps.setString(1, user_name);
            ps.setString(2, email);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    /**
     * 根据用户名检查该用户是否存在
     *
     * @param user_name 用户名
     * @return 存在返回true, 反之false
     */
    public static boolean checkUserIsExistByName(String user_name) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            //stmt = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_name`=?");
            ps.setString(1, user_name);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    /**
     * 根据用户注册电子邮箱检查该用户是否存在
     *
     * @param user_email 用户邮箱(唯一凭证)
     * @return 存在返回true, 反之false
     */
    public static boolean checkUserIsExistByEmail(String user_email) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            //stmt = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_email`=?");
            ps.setString(1, user_email);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    /**
     * 添加新用户,调用了checkUserIsExistByName(String)
     *
     * @param user_name  用户名
     * @param user_pwd   用户密码
     * @param user_email 用户邮箱
     * @return true or false
     * @see UserAcess#checkUserIsExistByName(String)
     */
    public static boolean addUser(String user_name, String user_pwd, String user_email) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO `users` VALUES(?,?,?,now())");
            ps.setString(1, user_name);
            ps.setString(2, user_pwd);
            ps.setString(3, user_email);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static List<User> getUserByLikeName(String like_name, int page,int pagesize) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            like_name = Tools.likeStrFilter(like_name);
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_name` LIKE ? ESCAPE '*' LIMIT ?,?");
            ps.setString(1, '%'+like_name+'%');
            ps.setInt(2, (page - 1) * pagesize);
            ps.setInt(3, pagesize);
            rs = ps.executeQuery();
            List<User> users = new LinkedList<>();
            while (rs.next()){
                users.add(new User(
                        rs.getString(1),
                        rs.getString(2),
                        rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(4).getTime()))
                ));
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<User> getUserByLikeName(String byWho, String like_name, int page,int pagesize) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            like_name = Tools.likeStrFilter(like_name);
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_name` != ? AND `user_name` LIKE ? ESCAPE '*' LIMIT ?,?");
            ps.setString(1, byWho);
            ps.setString(2, '%'+like_name+'%');
            ps.setInt(3, (page - 1) * pagesize);
            ps.setInt(4, pagesize);
            rs = ps.executeQuery();
            List<User> users = new LinkedList<>();
            while (rs.next()){
                users.add(new User(
                        rs.getString(1),
                        rs.getString(2),
                        rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(4).getTime()))
                ));
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static int getUserNumByLikeName(String like_name) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            like_name = Tools.likeStrFilter(like_name);
            ps = conn.prepareStatement("SELECT COUNT(*) FROM `users` WHERE `user_name` LIKE ? ESCAPE '*'");
            ps.setString(1, '%' + like_name + '%');
            rs = ps.executeQuery();
            if(rs.next()){
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }
    public static int getUserNumByLikeName(String byWho,String like_name) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            like_name = Tools.likeStrFilter(like_name);
            ps = conn.prepareStatement("SELECT COUNT(*) FROM `users` WHERE `user_name`!=? AND `user_name` LIKE ? ESCAPE '*'");
            ps.setString(1, byWho);
            ps.setString(2, '%' + like_name + '%');
            rs = ps.executeQuery();
            if(rs.next()){
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }
    /**
     * 通过用户名获取用户
     *
     * @param user_name 用户名
     * @return 如果用户不存在返回null
     */
    public static User getUserByName(String user_name) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_name`=?");
            ps.setString(1, user_name);
            rs = ps.executeQuery();
            return rs.next() ? new User(
                    rs.getString(1),
                    rs.getString(2),
                    rs.getString(3),
                    Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(4).getTime()))
            ) : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static User getUserByEmail(String email) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `users` WHERE `user_email`=?");
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next() ? new User(
                    rs.getString(1),
                    rs.getString(2),
                    rs.getString(3),
                    Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(4).getTime()))
            ) : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    /**
     * 更新用户密码
     *
     * @param user_name 用户名
     * @param new_pwd   新的密码
     * @return true of false
     */
    public static boolean updateUserPwdbyName(String user_name, String new_pwd) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `users` set `user_pwd`=? WHERE `user_name`=?");
            ps.setString(1, new_pwd);
            ps.setString(2, user_name);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    /**
     * 更新用户注册邮箱
     *
     * @param user_name 用户名
     * @param new_email 新的邮箱
     * @return true of false
     */
    public static boolean updateUserEmailbyName(String user_name, String new_email) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `users` SET `user_email`=? WHERE `user_name`=?");
            ps.setString(1, new_email);
            ps.setString(2, user_name);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    /**
     * 通过用户名删除用户
     *
     * @param user_name 用户名
     * @return true or false
     */
    public static boolean delUserByName(String user_name) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `users` WHERE `user_name`=?");
            ps.setString(1, user_name);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static boolean delUserByEmail(String email) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `users` WHERE `user_email`=?");
            ps.setString(1, email);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    /**
     * 获取用户集合，用于管理员管理查看
     *
     * @param page     页索引，从1开始
     * @param pagesize 页面的大小
     * @param order    排序的凭证
     * @param isAsc    是否正序
     * @return List<User> or null
     */
    public static List<User> getAllUsers(int page, int pagesize, String order, boolean isAsc) {
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `users` ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<User> set = new LinkedList<User>();
            while (rs.next()) {
                set.add(new User(rs.getString(1), rs.getString(2), rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(4).getTime()))));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static void main(String[] args) {

    }
    /**
     * 寻找与用户名相近的用户名集合，用于输入时（setTimeOut）预览。
     * @param name 待搜素的用户名
     * @param page
     * @param pagesize
     * @param order
     * @param isAsc
     * @return
     */
    public static List<String> getNamesByName(String name,int page, int pagesize, String order, boolean isAsc) {
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `user_name` FROM `users` WHERE `user_name` LIKE '%"+Tools.likeStrFilter(name)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<String> set = new LinkedList<String>();
            while (rs.next()) {
                set.add(rs.getString(1));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    /**
     * 寻找与邮箱相近的用户名集合，用于输入时（setTimeOut）预览。
     * @param email 待搜素的邮箱
     * @param page
     * @param pagesize
     * @param order
     * @param isAsc
     * @return
     */
    public static List<String> getEmailsByEmail(String email,int page, int pagesize, String order, boolean isAsc) {
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `user_email` FROM `users` WHERE `user_email` LIKE '%"+Tools.likeStrFilter(email)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<String> set = new LinkedList<String>();
            while (rs.next()) {
                set.add(rs.getString(1));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static int getUserCount() {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT COUNT(*) FROM `users`");
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static boolean updateUserByName(String pre,String username,String email,String password) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `users` SET `user_email`=?,`user_name`=?,`user_pwd`=? WHERE `user_name`=?");
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, pre);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean updateUserByEmail(String pre,String username,String email,String password) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `users` SET `user_email`=?,`user_name`=?,`user_pwd`=? WHERE `user_email`=?");
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, pre);
            return ps.executeUpdate() != 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

}
