package top.moyuyc.entity;

/**
 * Created by Yc on 2016/2/18 for autoexam_system.
 */
public class FriendRelationWithStatus extends FriendRelation{
    protected boolean isOnline;

    public FriendRelationWithStatus(){}

    public FriendRelationWithStatus(boolean isOnline) {
        this.isOnline = isOnline;
    }

    public FriendRelationWithStatus(String user1, String user2, String date, boolean isOnline) {
        super(user1, user2, date);
        this.isOnline = isOnline;
    }

    public FriendRelationWithStatus(FriendRelation friendRelation, boolean isOnline) {
        super(friendRelation.user1, friendRelation.user2, friendRelation.date);
        this.isOnline = isOnline;
    }

    public boolean isOnline() {
        return isOnline;
    }

    public void setIsOnline(boolean isOnline) {
        this.isOnline = isOnline;
    }
}
