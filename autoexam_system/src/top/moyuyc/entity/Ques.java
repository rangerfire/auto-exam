package top.moyuyc.entity;

import java.util.List;

/**
 * Created by Yc on 2015/9/16.
 */
public class Ques {
    private String id;
    private String ques_subject;
    private String ques_type;
    private int ques_score;
    private List<String> ques_content;
    private List<String> ques_answer;
    private String ques_analy;
    private int lev;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Ques ques = (Ques) o;

        return !(id != null ? !id.equals(ques.id) : ques.id != null);

    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    public Ques(String id, String ques_subject, String ques_type, int ques_score, List<String> ques_content, List<String> ques_answer, String ques_analy, int lev) {
        this.id = id;
        this.ques_subject = ques_subject;
        this.ques_type = ques_type;
        this.ques_score = ques_score;
        this.ques_content = ques_content;
        this.ques_answer = ques_answer;
        this.ques_analy = ques_analy;
        this.lev = lev;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getQues_subject() {
        return ques_subject;
    }

    public void setQues_subject(String ques_subject) {
        this.ques_subject = ques_subject;
    }

    public String getQues_type() {
        return ques_type;
    }

    public void setQues_type(String ques_type) {
        this.ques_type = ques_type;
    }

    public int getQues_score() {
        return ques_score;
    }

    public void setQues_score(int ques_score) {
        this.ques_score = ques_score;
    }

    public List<String> getQues_content() {
        return ques_content;
    }

    public void setQues_content(List<String> ques_content) {
        this.ques_content = ques_content;
    }

    public List<String> getQues_answer() {
        return ques_answer;
    }

    public void setQues_answer(List<String> ques_answer) {
        this.ques_answer = ques_answer;
    }

    public String getQues_analy() {
        return ques_analy;
    }

    public void setQues_analy(String ques_analy) {
        this.ques_analy = ques_analy;
    }

    public int getLev() {
        return lev;
    }

    public void setLev(int lev) {
        this.lev = lev;
    }
}
