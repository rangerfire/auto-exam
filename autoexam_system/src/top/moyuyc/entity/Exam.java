package top.moyuyc.entity;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.io.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Yc on 2015/9/16.
 */
public class Exam {
    private int id;
    private String paper_id;
    private String user_name;
    private boolean is_ok;
    private String subject;
    private String start_time;
    private int spend_min;
    private int single_quess_score;
    private int single_quess_sum;
    private List<String> single_answer;
    private int muti_quess_score;
    private int muti_quess_sum;
    private List<String> muti_answer;//, ###
    private int judge_quess_score;
    private int judge_quess_sum;
    private List<String> judge_answer;
    private int sa_quess_score;
    private int sa_quess_sum;
    private List<String> sa_answer;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Exam exam = (Exam) o;

        return id == exam.id;

    }

    @Override
    public int hashCode() {
        return id;
    }

    public int getId() {

        return id;
    }

    public List<String> getSingle_answer() {
        return single_answer;
    }

    public void setSingle_answer(List<String> single_answer) {
        this.single_answer = single_answer;
    }

    public List<String> getMuti_answer() {
        return muti_answer;
    }

    public void setMuti_answer(List<String> muti_answer) {
        this.muti_answer = muti_answer;
    }

    public List<String> getJudge_answer() {
        return judge_answer;
    }

    public void setJudge_answer(List<String> judge_answer) {
        this.judge_answer = judge_answer;
    }

    public List<String> getSa_answer() {
        return sa_answer;
    }

    public void setSa_answer(List<String> sa_answer) {
        this.sa_answer = sa_answer;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPaper_id() {
        return paper_id;
    }

    public void setPaper_id(String paper_id) {
        this.paper_id = paper_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public boolean is_ok() {
        return is_ok;
    }

    public void setIs_ok(boolean is_ok) {
        this.is_ok = is_ok;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public int getSpend_min() {
        return spend_min;
    }

    public void setSpend_min(int spend_min) {
        this.spend_min = spend_min;
    }

    public int getSingle_quess_score() {
        return single_quess_score;
    }

    public void setSingle_quess_score(int single_quess_score) {
        this.single_quess_score = single_quess_score;
    }

    public int getSingle_quess_sum() {
        return single_quess_sum;
    }

    public void setSingle_quess_sum(int single_quess_sum) {
        this.single_quess_sum = single_quess_sum;
    }

    public int getMuti_quess_score() {
        return muti_quess_score;
    }

    public void setMuti_quess_score(int muti_quess_score) {
        this.muti_quess_score = muti_quess_score;
    }

    public int getMuti_quess_sum() {
        return muti_quess_sum;
    }

    public void setMuti_quess_sum(int muti_quess_sum) {
        this.muti_quess_sum = muti_quess_sum;
    }

    public int getJudge_quess_score() {
        return judge_quess_score;
    }

    public void setJudge_quess_score(int judge_quess_score) {
        this.judge_quess_score = judge_quess_score;
    }

    public int getJudge_quess_sum() {
        return judge_quess_sum;
    }

    public void setJudge_quess_sum(int judge_quess_sum) {
        this.judge_quess_sum = judge_quess_sum;
    }

    public int getSa_quess_score() {
        return sa_quess_score;
    }

    public void setSa_quess_score(int sa_quess_score) {
        this.sa_quess_score = sa_quess_score;
    }

    public int getSa_quess_sum() {
        return sa_quess_sum;
    }

    public void setSa_quess_sum(int sa_quess_sum) {
        this.sa_quess_sum = sa_quess_sum;
    }

    public Exam(int id, String paper_id, String user_name, boolean is_ok, String subject, String start_time, int spend_min, int single_quess_score, int single_quess_sum, List<String> single_answer, int muti_quess_score, int muti_quess_sum, List<String> muti_answer, int judge_quess_score, int judge_quess_sum, List<String> judge_answer, int sa_quess_score, int sa_quess_sum, List<String> sa_answer) {
        this.id = id;
        this.paper_id = paper_id;
        this.user_name = user_name;
        this.is_ok = is_ok;
        this.subject = subject;
        this.start_time = start_time;
        this.spend_min = spend_min;
        this.single_quess_score = single_quess_score;
        this.single_quess_sum = single_quess_sum;
        this.single_answer = single_answer;
        this.muti_quess_score = muti_quess_score;
        this.muti_quess_sum = muti_quess_sum;
        this.muti_answer = muti_answer;
        this.judge_quess_score = judge_quess_score;
        this.judge_quess_sum = judge_quess_sum;
        this.judge_answer = judge_answer;
        this.sa_quess_score = sa_quess_score;
        this.sa_quess_sum = sa_quess_sum;
        this.sa_answer = sa_answer;
    }

    public String getSubject() {

        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }
}
