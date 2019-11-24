package top.moyuyc.entity;

import java.io.Serializable;

/**
 * Created by Yc on 2015/9/16.
 * 用户实体类
 */
public class User implements Serializable{
    private String user_name;
    private String user_pwd;
    private String user_email;
    private String create_time;

    public User(String user_name, String user_pwd, String user_email, String create_time) {
        this.user_name = user_name;
        this.user_pwd = user_pwd;
        this.user_email = user_email;
        this.create_time = create_time;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getUser_pwd() {
        return user_pwd;
    }

    public void setUser_pwd(String user_pwd) {
        this.user_pwd = user_pwd;
    }

    public String getUser_email() {
        return user_email;
    }

    public void setUser_email(String user_email) {
        this.user_email = user_email;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        User user = (User) o;

        if (user_name != null ? !user_name.equals(user.user_name) : user.user_name != null) return false;
        return !(user_email != null ? !user_email.equals(user.user_email) : user.user_email != null);

    }

    @Override
    public int hashCode() {
        int result = user_name != null ? user_name.hashCode() : 0;
        result = 31 * result + (user_email != null ? user_email.hashCode() : 0);
        return result;
    }
}
