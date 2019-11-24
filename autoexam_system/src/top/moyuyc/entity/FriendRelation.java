package top.moyuyc.entity;

/**
 * Created by Yc on 2015/12/18.
 */
public class FriendRelation {
    protected String user1;
    protected String user2;
    protected String date;

    public FriendRelation(){}
    public FriendRelation(String user1, String user2, String date) {
        this.user1 = user1;
        this.user2 = user2;
        this.date = date;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FriendRelation)) return false;

        FriendRelation that = (FriendRelation) o;

        if (user1 != null ? !user1.equals(that.user1) : that.user1 != null) return false;
        return !(user2 != null ? !user2.equals(that.user2) : that.user2 != null);

    }

    @Override
    public int hashCode() {
        int result = user1 != null ? user1.hashCode() : 0;
        result = 31 * result + (user2 != null ? user2.hashCode() : 0);
        return result;
    }

    public String getUser1() {
        return user1;
    }

    public void setUser1(String user1) {
        this.user1 = user1;
    }

    public String getUser2() {
        return user2;
    }

    public void setUser2(String user2) {
        this.user2 = user2;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
