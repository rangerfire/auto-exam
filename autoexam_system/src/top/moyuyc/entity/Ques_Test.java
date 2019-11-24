package top.moyuyc.entity;

import java.util.List;

/**
 * Created by Yc on 2015/9/20.
 */
public class Ques_Test {
    private String id;
    private int ques_score;
    private List<String> ques_content;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Ques_Test ques_test = (Ques_Test) o;

        return !(id != null ? !id.equals(ques_test.id) : ques_test.id != null);

    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    public Ques_Test(String id, int ques_score, List<String> ques_content) {

        this.id = id;
        this.ques_score = ques_score;
        this.ques_content = ques_content;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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
}
