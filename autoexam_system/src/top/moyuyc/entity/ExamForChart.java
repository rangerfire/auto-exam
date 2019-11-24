package top.moyuyc.entity;

/**
 * Created by Yc on 2016/2/23 for autoexam_system.
 */
public class ExamForChart {

    private String id;
    private String singlePercent;
    private String multiPercent;
    private String judgePercent;

    public ExamForChart(){}
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ExamForChart)) return false;

        ExamForChart that = (ExamForChart) o;

        if (id != null ? !id.equals(that.id) : that.id != null) return false;
        if (singlePercent != null ? !singlePercent.equals(that.singlePercent) : that.singlePercent != null)
            return false;
        if (multiPercent != null ? !multiPercent.equals(that.multiPercent) : that.multiPercent != null) return false;
        return !(judgePercent != null ? !judgePercent.equals(that.judgePercent) : that.judgePercent != null);

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (singlePercent != null ? singlePercent.hashCode() : 0);
        result = 31 * result + (multiPercent != null ? multiPercent.hashCode() : 0);
        result = 31 * result + (judgePercent != null ? judgePercent.hashCode() : 0);
        return result;
    }

    public String getId() {

        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSinglePercent() {
        return singlePercent;
    }

    public void setSinglePercent(String singlePercent) {
        this.singlePercent = singlePercent;
    }

    public String getMultiPercent() {
        return multiPercent;
    }

    public void setMultiPercent(String multiPercent) {
        this.multiPercent = multiPercent;
    }

    public String getJudgePercent() {
        return judgePercent;
    }

    public void setJudgePercent(String judgePercent) {
        this.judgePercent = judgePercent;
    }

    public ExamForChart(String id, String singlePercent, String multiPercent, String judgePercent) {

        this.id = id;
        this.singlePercent = singlePercent;
        this.multiPercent = multiPercent;
        this.judgePercent = judgePercent;
    }
}
