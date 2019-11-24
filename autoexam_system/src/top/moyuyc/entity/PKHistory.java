package top.moyuyc.entity;

/**
 * Created by Yc on 2016/2/27 for autoexam_system.
 */
public class PKHistory {
    private String paper_id;
    private String user1;
    private String user2;
    private String pktime;
    private int status;
    private String win_name;
    private int inc_point;
    private int dec_point;

    public PKHistory(){}
    public PKHistory(String paper_id, String user1, String user2, String pktime, int status, String win_name, int inc_point, int dec_point) {
        this.paper_id = paper_id;
        this.user1 = user1;
        this.user2 = user2;
        this.pktime = pktime;
        this.status = status;
        this.win_name = win_name;
        this.inc_point = inc_point;
        this.dec_point = dec_point;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PKHistory)) return false;

        PKHistory pkHistory = (PKHistory) o;

        if (!paper_id.equals(pkHistory.paper_id)) return false;
        if (!user1.equals(pkHistory.user1)) return false;
        return user2.equals(pkHistory.user2);

    }

    @Override
    public int hashCode() {
        int result = paper_id.hashCode();
        result = 31 * result + user1.hashCode();
        result = 31 * result + user2.hashCode();
        return result;
    }

    public String getPaper_id() {

        return paper_id;
    }

    public void setPaper_id(String paper_id) {
        this.paper_id = paper_id;
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

    public String getPktime() {
        return pktime;
    }

    public void setPktime(String pktime) {
        this.pktime = pktime;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getWin_name() {
        return win_name;
    }

    public void setWin_name(String win_name) {
        this.win_name = win_name;
    }

    public int getInc_point() {
        return inc_point;
    }

    public void setInc_point(int inc_point) {
        this.inc_point = inc_point;
    }

    public int getDec_point() {
        return dec_point;
    }

    public void setDec_point(int dec_point) {
        this.dec_point = dec_point;
    }
}
