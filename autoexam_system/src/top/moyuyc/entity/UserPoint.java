package top.moyuyc.entity;

/**
 * Created by Yc on 2016/2/27 for autoexam_system.
 */
public class UserPoint {
    private String user_name;
    private int point;

    public UserPoint(){}
    public UserPoint(String user_name, int point) {
        this.user_name = user_name;
        this.point = point;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserPoint)) return false;

        UserPoint userPoint = (UserPoint) o;

        return user_name.equals(userPoint.user_name);

    }

    @Override
    public int hashCode() {
        return user_name.hashCode();
    }

    public String getUser_name() {

        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }
}
