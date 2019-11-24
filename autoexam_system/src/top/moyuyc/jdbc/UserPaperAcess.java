package top.moyuyc.jdbc;

import top.moyuyc.entity.Exam;
import top.moyuyc.entity.Ques;
import top.moyuyc.entity.Ques_Test;
import top.moyuyc.tools.Tools;

import java.sql.Date;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by Yc on 2015/9/18.
 */
public class UserPaperAcess extends DataBase{
    public static final String PAPER_ID="paper_id";
    public static final String SUBJECT="subject";
    public static final String IS_OK="is_ok";
    public static final String START_TIME="start_time";
    public static final String SPEND_MIN="spend_min";
    private final static String delim="###";

    public static boolean addUserPaper(String paperid,String user_name,String subject,boolean isOk,int spendmin,
                                       int single_s,int single_s_sum,String singleanswer,int muti_s,int muti_s_sum,String mutianswer,
                                       int judge_s,int judge_s_sum,String judgeanswer,int sa_s,int sa_s_sum,String saanswer) {
        try {
            //id paperid subject username isok starttime spendmin singlescore singlescoresum singleanswer
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO `user_test` VALUES(NULL,?,?,?,?,NOW(),?,?,?,?,?,?,?,?,?,?,?,?,?)");
            ps.setString(1, paperid);
            ps.setString(2, subject);
            ps.setString(3, user_name);
            ps.setBoolean(4, isOk);
            ps.setInt(5, spendmin);
            ps.setInt(6, single_s);
            ps.setInt(7, single_s_sum);
            ps.setString(8, singleanswer);
            ps.setInt(9, muti_s);
            ps.setInt(10, muti_s_sum);
            ps.setString(11, mutianswer);
            ps.setInt(12, judge_s);
            ps.setInt(13, judge_s_sum);
            ps.setString(14, judgeanswer);
            ps.setInt(15, sa_s);
            ps.setInt(16, sa_s_sum);
            ps.setString(17, saanswer);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static int getTimesByUserName(String username){
        try {
            //id paperid username isok starttime spendmin singlescore singlescoresum singleanswer
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM `user_test` WHERE `user_name`=?");
            ps.setString(1,username);
            rs=ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            else
                return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static boolean getIs_OkByUserPaper(String username, String paperID){
        try {
            //id paperid username isok starttime spendmin singlescore singlescoresum singleanswer
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT is_ok" +
                    " FROM `user_test` WHERE `user_name`=? AND paper_id = ?");
            ps.setString(1,username);
            ps.setString(2,paperID);
            rs=ps.executeQuery();
            if(rs.next())
                return rs.getBoolean(1);
            else
                return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static int getOkAllScoreByUserPaper(String username,String paperID){
        try {
            //id paperid username isok starttime spendmin singlescore singlescoresum singleanswer
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT single_ques_score+muti_ques_score+judge_ques_score" +
                    " FROM `user_test` WHERE `user_name`=? AND paper_id = ? AND is_ok = TRUE ");
            ps.setString(1,username);
            ps.setString(2,paperID);
            rs=ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            else
                return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            Close();
        }
    }
    public static List<Exam> getExamsByUserName(String username,int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `user_test` WHERE `user_name`=? ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            ps.setString(1,username);
            ps.setInt(2, (page - 1) * pagesize);
            ps.setInt(3, pagesize);
            rs = ps.executeQuery();
            List<Exam> set = new LinkedList<Exam>();
            while (rs.next()) {
                set.add(new Exam(
                        rs.getInt(1),rs.getString(2),rs.getString(4),rs.getBoolean(5),rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(6).getTime())),rs.getInt(7),rs.getInt(8),rs.getInt(9),
                        Tools.StringToList(rs.getString(10), "###"),rs.getInt(11),rs.getInt(12),Tools.StringToList(rs.getString(13), "###"),
                        rs.getInt(14),rs.getInt(15),Tools.StringToList(rs.getString(16), "###"),
                        rs.getInt(17),rs.getInt(18),Tools.StringToList(rs.getString(19), "###")
                ));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static Exam getExamByUserPaper(String username,String paperID){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `user_test` WHERE `user_name`=? AND paper_id = ?");
            ps.setString(1,username);
            ps.setString(2,paperID);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Exam(
                        rs.getInt(1),rs.getString(2),rs.getString(4),rs.getBoolean(5),rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(6).getTime())),rs.getInt(7),rs.getInt(8),rs.getInt(9),
                        Tools.StringToList(rs.getString(10), "###"),rs.getInt(11),rs.getInt(12),Tools.StringToList(rs.getString(13), "###"),
                        rs.getInt(14),rs.getInt(15),Tools.StringToList(rs.getString(16), "###"),
                        rs.getInt(17),rs.getInt(18),Tools.StringToList(rs.getString(19), "###")
                );
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<Exam> getFinishExamsByUserName(String username,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `user_test` WHERE `user_name`=? AND is_ok=TRUE ORDER BY "+order+" "+t);
            ps.setString(1, username);
            rs = ps.executeQuery();
            List<Exam> set = new LinkedList<Exam>();
            while (rs.next()) {
                set.add(new Exam(
                        rs.getInt(1),rs.getString(2),rs.getString(4),rs.getBoolean(5),rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(6).getTime())),rs.getInt(7),rs.getInt(8),rs.getInt(9),
                        Tools.StringToList(rs.getString(10), "###"),rs.getInt(11),rs.getInt(12),Tools.StringToList(rs.getString(13), "###"),
                        rs.getInt(14),rs.getInt(15),Tools.StringToList(rs.getString(16), "###"),
                        rs.getInt(17),rs.getInt(18),Tools.StringToList(rs.getString(19), "###")
                ));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<Exam> getAllExamsByUserName(String username,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `user_test` WHERE `user_name`=? ORDER BY "+order+" "+t);
            ps.setString(1, username);
            rs = ps.executeQuery();
            List<Exam> set = new LinkedList<Exam>();
            while (rs.next()) {
                set.add(new Exam(
                        rs.getInt(1),rs.getString(2),rs.getString(4),rs.getBoolean(5),rs.getString(3),
                        Tools.mySqlDateToWebDate(new Date(rs.getTimestamp(6).getTime())),rs.getInt(7),rs.getInt(8),rs.getInt(9),
                        Tools.StringToList(rs.getString(10), "###"),rs.getInt(11),rs.getInt(12),Tools.StringToList(rs.getString(13), "###"),
                        rs.getInt(14),rs.getInt(15),Tools.StringToList(rs.getString(16), "###"),
                        rs.getInt(17),rs.getInt(18),Tools.StringToList(rs.getString(19), "###")
                ));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<String> getAllPaperIDsByUserName(String username){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT paper_id FROM `user_test` WHERE `user_name`=? ");
            ps.setString(1, username);
            rs = ps.executeQuery();
            List<String> set = new LinkedList<>();
            while (rs.next()) {
                set.add(rs.getString(1));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }


    /**
     * update
     */
    public static boolean paperSubmit(String paperid,String username,boolean isOk,int spendmin,
                                       int single_s,String singleanswer,int muti_s,String mutianswer,
                                       int judge_s,String judgeanswer,int sa_s,String saanswer) {
        try {
            //id paperid subject username isok starttime spendmin singlescore singlescoresum singleanswer
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `user_test` SET `is_ok`=?,`spend_min`=?," +
                    "`single_ques_score`=?,`user_single_answ`=?,`muti_ques_score`=?,`user_muti_answ`=?," +
                    "`judge_ques_score`=?,`user_judge_answ`=?,`sa_ques_score`=?,`user_sa_answ`=? WHERE `paper_id`=? AND `user_name`=?");
            System.err.println("!!!!!!!"+saanswer);
            ps.setBoolean(1, isOk);
            ps.setInt(2, spendmin);
            ps.setInt(3, single_s);
            ps.setString(4, singleanswer);
            ps.setInt(5, muti_s);
            ps.setString(6, mutianswer);
            ps.setInt(7, judge_s);
            ps.setString(8, judgeanswer);
            ps.setInt(9, sa_s);
            ps.setString(10, saanswer);
            ps.setString(11, paperid);
            ps.setString(12, username);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }



    public static Map<String,Object> getTestQuessByIdName(String username,String paperid,boolean isok){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `spend_min`,`user_single_answ`,`user_muti_answ`,`user_judge_answ`,`user_sa_answ` " +
                    "FROM `user_test` WHERE `user_name`=? AND `paper_id`=? AND `is_ok`=?");
            ps.setString(1,username);
            ps.setString(2, paperid);
            ps.setBoolean(3, isok);
            rs = ps.executeQuery();
            Map<String,Object> map = new HashMap<>();
            if (rs.next()) {
                map.put("spendmin",rs.getInt(1));
                map.put("singleanswer",Tools.StringToList(rs.getString(2),"###"));
                map.put("mutianswer",Tools.StringToList(rs.getString(3),"###"));
                map.put("judgeanswer",Tools.StringToList(rs.getString(4), "###"));
                map.put("saanswer",Tools.StringToList(rs.getString(5), "###"));
            }
            return map.isEmpty() ? null : map;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static int updateUserName(String pre_name,String new_name){
        try {
            //id paperid subject username isok starttime spendmin singlescore singlescoresum singleanswer
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `user_test` SET `user_name`=? WHERE `user_name`=?");
            ps.setString(1, new_name);
            ps.setString(2, pre_name);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static int delUserPaperByUserName(String username){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `user_test` WHERE `user_name`=?");
            ps.setString(1, username);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static int delUserPaperByPaper(String paperid){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `user_test` WHERE `paper_id`=?");
            ps.setString(1, paperid);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static boolean checkIsExistUserPaper(String user,String paperID){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM user_test WHERE paper_id=? AND user_name=?");
            ps.setString(1, paperID);
            ps.setString(2, user);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }


    public static int delUserPaperByU_P(String username,String paperid){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `user_test` WHERE `paper_id`=? AND `user_name`=?");
            ps.setString(1, paperid);
            ps.setString(2, username);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static boolean delSingleAwByPaperId(int delindex,int answernum,int score,String paperId){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `user_test` SET `single_ques_sum`=single_ques_sum-?" +
                    ",user_single_answ=CONCAT(SUBSTRING_INDEX(user_single_answ,?,?),?,SUBSTRING_INDEX(user_single_answ,?,?)) " +
                    " WHERE paper_id=? AND user_single_answ IS NOT NULL");
            ps.setInt(1, score);
            ps.setString(2, delim);
            ps.setInt(3, delindex);
            ps.setString(5,delim);
            if(delindex!=0 && delindex!=answernum-1)
                ps.setString(4, delim);
            else
                ps.setString(4, "");
            ps.setInt(6, delindex - answernum + 1);
            ps.setString(7, paperId);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean delMultiAwByPaperId(int delindex,int answernum,int score,String paperId){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `user_test` SET `muti_ques_sum`=muti_ques_sum-?" +
                    ",user_muti_answ=CONCAT(SUBSTRING_INDEX(user_muti_answ,?,?),?,SUBSTRING_INDEX(user_muti_answ,?,?)) " +
                    " WHERE paper_id=? AND user_muti_answ IS NOT NULL");
            ps.setInt(1, score);
            ps.setString(2, delim);
            ps.setInt(3, delindex);
            ps.setString(5, delim);
            if(delindex!=0 && delindex!=answernum-1)
                ps.setString(4, delim);
            else
                ps.setString(4, "");
            ps.setInt(6, delindex - answernum + 1);
            ps.setString(7,paperId);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean delJudgeAwByPaperId(int delindex,int answernum,int score,String paperId){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `user_test` SET `judge_ques_sum`=judge_ques_sum-?" +
                    ",user_judge_answ=CONCAT(SUBSTRING_INDEX(user_judge_answ,?,?),?,SUBSTRING_INDEX(user_judge_answ,?,?)) " +
                    " WHERE paper_id=? AND user_judge_answ IS NOT NULL");
            ps.setInt(1, score);
            ps.setString(2, delim);
            ps.setInt(3, delindex);
            if(delindex!=0 && delindex!=answernum-1)
                ps.setString(4, delim);
            else
                ps.setString(4, "");
            ps.setString(5, delim);
            ps.setInt(6, delindex - answernum + 1);
            ps.setString(7, paperId);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static boolean delSaAwByPaperId(int delindex,int answernum,int score,String paperId){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `user_test` A SET `sa_ques_sum`=sa_ques_sum-?" +
                    ",user_sa_answ=CONCAT(SUBSTRING_INDEX(user_sa_answ,?,?),?,SUBSTRING_INDEX(user_sa_answ,?,?)) " +
                    " WHERE paper_id=? AND user_sa_answ IS NOT NULL");
            ps.setInt(1, score);
            ps.setString(2, delim);
            ps.setInt(3, delindex);
            ps.setString(5,delim);
            if(delindex!=0 && delindex!=answernum-1)
                ps.setString(4, delim);
            else
                ps.setString(4, "");
            ps.setInt(6,delindex-answernum+1);
            ps.setString(7,paperId);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static void main(String[] args) {
        System.out.println(getExamByUserPaper("qqqqqq", "ey5326"));
    }
}
