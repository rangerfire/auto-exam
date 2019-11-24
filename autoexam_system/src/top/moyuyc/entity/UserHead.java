package top.moyuyc.entity;

import java.io.InputStream;

/**
 * Created by Yc on 2015/12/17.
 */
public class UserHead {
    private String name;
    private String picPath;
    private String updateTime;

    public UserHead(){}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserHead)) return false;

        UserHead userHead = (UserHead) o;

        return !(name != null ? !name.equals(userHead.name) : userHead.name != null);

    }

    @Override
    public int hashCode() {
        return name != null ? name.hashCode() : 0;
    }

    public String getName() {

        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPicPath() {
        return picPath;
    }

    public void setPicPath(String picPath) {
        this.picPath = picPath;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

    public UserHead(String name, String picPath, String updateTime) {

        this.name = name;
        this.picPath = picPath;
        this.updateTime = updateTime;
    }
}
