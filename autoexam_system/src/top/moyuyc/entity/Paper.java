package top.moyuyc.entity;

import java.util.List;

/**
 * Created by Yc on 2015/9/16.
 */
public class Paper {
    private String id;
    private String paper_subject;
    private int single_ques_num;
    private List<String> single_ques_lists;
    private int single_ques_score;

    private int muti_ques_num;
    private List<String> muti_ques_lists;
    private int muti_ques_score;

    private int judge_ques_num;
    private List<String> judge_ques_lists;
    private int judge_ques_score;

    private int sa_ques_num;
    private List<String> sa_ques_lists;
    private int sa_ques_score;

    private int maxmin;

    private int paper_lev;

    public Paper(String id, String paper_subject, int single_ques_num, List<String> single_ques_lists, int single_ques_score, int muti_ques_num, List<String> muti_ques_lists, int muti_ques_score, int judge_ques_num, List<String> judge_ques_lists, int judge_ques_score, int sa_ques_num, List<String> sa_ques_lists, int sa_ques_score, int maxmin, int paper_lev) {
        this.id = id;
        this.paper_subject = paper_subject;
        this.single_ques_num = single_ques_num;
        this.single_ques_lists = single_ques_lists;
        this.single_ques_score = single_ques_score;
        this.muti_ques_num = muti_ques_num;
        this.muti_ques_lists = muti_ques_lists;
        this.muti_ques_score = muti_ques_score;
        this.judge_ques_num = judge_ques_num;
        this.judge_ques_lists = judge_ques_lists;
        this.judge_ques_score = judge_ques_score;
        this.sa_ques_num = sa_ques_num;
        this.sa_ques_lists = sa_ques_lists;
        this.sa_ques_score = sa_ques_score;
        this.maxmin = maxmin;
        this.paper_lev = paper_lev;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Paper paper = (Paper) o;

        return !(id != null ? !id.equals(paper.id) : paper.id != null);

    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPaper_subject() {
        return paper_subject;
    }

    public void setPaper_subject(String paper_subject) {
        this.paper_subject = paper_subject;
    }

    public int getSingle_ques_num() {
        return single_ques_num;
    }

    public void setSingle_ques_num(int single_ques_num) {
        this.single_ques_num = single_ques_num;
    }

    public List<String> getSingle_ques_lists() {
        return single_ques_lists;
    }

    public void setSingle_ques_lists(List<String> single_ques_lists) {
        this.single_ques_lists = single_ques_lists;
    }

    public int getSingle_ques_score() {
        return single_ques_score;
    }

    public void setSingle_ques_score(int single_ques_score) {
        this.single_ques_score = single_ques_score;
    }

    public int getMuti_ques_num() {
        return muti_ques_num;
    }

    public void setMuti_ques_num(int muti_ques_num) {
        this.muti_ques_num = muti_ques_num;
    }

    public List<String> getMuti_ques_lists() {
        return muti_ques_lists;
    }

    public void setMuti_ques_lists(List<String> muti_ques_lists) {
        this.muti_ques_lists = muti_ques_lists;
    }

    public int getMuti_ques_score() {
        return muti_ques_score;
    }

    public void setMuti_ques_score(int muti_ques_score) {
        this.muti_ques_score = muti_ques_score;
    }

    public int getJudge_ques_num() {
        return judge_ques_num;
    }

    public void setJudge_ques_num(int judge_ques_num) {
        this.judge_ques_num = judge_ques_num;
    }

    public List<String> getJudge_ques_lists() {
        return judge_ques_lists;
    }

    public void setJudge_ques_lists(List<String> judge_ques_lists) {
        this.judge_ques_lists = judge_ques_lists;
    }

    public int getJudge_ques_score() {
        return judge_ques_score;
    }

    public void setJudge_ques_score(int judge_ques_score) {
        this.judge_ques_score = judge_ques_score;
    }

    public int getSa_ques_num() {
        return sa_ques_num;
    }

    public void setSa_ques_num(int sa_ques_num) {
        this.sa_ques_num = sa_ques_num;
    }

    public List<String> getSa_ques_lists() {
        return sa_ques_lists;
    }

    public void setSa_ques_lists(List<String> sa_ques_lists) {
        this.sa_ques_lists = sa_ques_lists;
    }

    public int getSa_ques_score() {
        return sa_ques_score;
    }

    public void setSa_ques_score(int sa_ques_score) {
        this.sa_ques_score = sa_ques_score;
    }

    public int getMaxmin() {
        return maxmin;
    }

    public void setMaxmin(int maxmin) {
        this.maxmin = maxmin;
    }

    public int getPaper_lev() {
        return paper_lev;
    }

    public void setPaper_lev(int paper_lev) {
        this.paper_lev = paper_lev;
    }
}
