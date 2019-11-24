package top.moyuyc.jdbc;

import top.moyuyc.entity.Ques;
import top.moyuyc.entity.Ques_Test;
import top.moyuyc.tools.Tools;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by Yc on 2015/9/16.
 */
public class QuesAcess extends DataBase{
    public static final String TYPE_SINGLECHOOSE = "single_choose";
    public static final String TYPE_MUTICHOOSE = "muti_choose";
    public static final String TYPE_JUDGE = "judgement";
    public static final String TYPE_SHORTAN = "short_answer";

    public static final String QUES_ID = "id";
    public static final String QUES_SUB = "ques_subject";
    public static final String QUES_TYPE = "ques_type";
    public static final String QUES_SCORE = "ques_score";
    public static final String QUES_CON = "ques_content";
    public static final String QUES_ANSWER = "ques_answer";
    public static final String QUES_ANALY = "ques_analy";
    /**
     *
     * @param id 题号
     * @param subject 所属科目
     * @param type TYPE_SINGLECHOOSE TYPE_MUTICHOOSE TYPE_JUDGE TYPE_SHORTAN
     * @param score 分值
     * @param content 内容，选择题以###为分隔符
     * @param answer 答案，部分简答题可能没有答案，为null
     * @param analy 题目解析，可为null
     * @return
     */
    public static boolean addQues(String id,String subject,String type,int score,String content,String answer,String analy,int lev){
        try {
            if(conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO `questions` VALUES(?,?,?,?,?,?,?,?)");
            ps.setString(1, id);
            ps.setString(2, subject);
            ps.setString(3, type);
            ps.setInt(4, score);
            ps.setString(5, content);
            ps.setString(6, answer);
            ps.setString(7, analy);
            ps.setString(8, String.valueOf(lev));
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }


    public static List<Ques_Test> getRandomQuesByLev(int num,String type,String subject,int lev){
        try {
            if(conn.isClosed())
                conn = getConnInstance();
            //MOYU
            ps = conn.prepareStatement("SELECT `id`,`ques_score`,`ques_content` FROM `questions` WHERE `ques_type`=? AND `ques_subject`=? AND `ques_lev`=? ORDER BY RAND() LIMIT ?");
            ps.setString(1, type);
            ps.setString(2, subject);
            ps.setString(3, String.valueOf(lev));
            ps.setInt(4, num);
            rs = ps.executeQuery();
            List<Ques_Test> set=new LinkedList<Ques_Test>();
            while (rs.next()) {
                set.add(new Ques_Test(
                        rs.getString(1),rs.getInt(2),
                        Tools.StringToList(rs.getString(3), "###")
                ));
            }
            return set;
        } catch (SQLException e) {
            e.printStackTrace();
            return new LinkedList<>();
        } finally {
            Close();
        }
    }

    /**
     * 出题策略时调用，显示所有学科，以供选择，或者自己新建学科
     * @return
     */
    public static List<String> getAllSubs(){
        try {
            if(conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `ques_subject` FROM `questions` GROUP BY `ques_subject`");
            rs = ps.executeQuery();
            List<String> set=new LinkedList<String>();
            while(rs.next()) {
                set.add(rs.getString(1));
            }
            return set.isEmpty()?null:set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<Ques> getAllQuess(int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `questions` ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<Ques> set = new LinkedList<Ques>();
            while (rs.next()) {
                set.add(new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5), "###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8))));
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
     * 下拉框输入查询科目时调用，产生预览效果
     * @param subject
     * @param page
     * @param pagesize
     * @param order
     * @param isAsc
     * @return
     */
    public static List<String> getSubjectsBySub(String subject,int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `ques_subject` FROM `questions` WHERE `ques_subject` LIKE '%" + Tools.likeStrFilter(subject) + "%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<String> set = new LinkedList<String>();
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
    public static List<String> getIdsById(String id,int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `id` FROM `questions` WHERE `id` LIKE '%"+Tools.likeStrFilter(id)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<String> set = new LinkedList<String>();
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


    public static List<Ques> getQuessBySubject(String subject,int page,int pagesize,String order,boolean isAsc,boolean isCertain){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =isCertain?conn.prepareStatement("SELECT * FROM `questions` WHERE `ques_subject`=? ORDER BY `" + order + "` " + t + " LIMIT ?,?")
                    :conn.prepareStatement("SELECT * FROM `questions` WHERE `ques_subject`LIKE '%"+Tools.likeStrFilter(subject)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            if(isCertain){
                ps.setString(1,subject);
                ps.setInt(2, (page - 1) * pagesize);
                ps.setInt(3, pagesize);
            }else {
                ps.setInt(1, (page - 1) * pagesize);
                ps.setInt(2, pagesize);
            }
            rs = ps.executeQuery();
            List<Ques> set = new LinkedList<Ques>();
            while (rs.next()) {
                set.add(new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5),"###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8))));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<Ques> getQuessByType(String type,int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `questions` WHERE `ques_type`=? ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<Ques> set = new LinkedList<Ques>();
            while (rs.next()) {
                set.add(new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5), "###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8))));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<Ques> getQuessById(String id,int page,int pagesize,String order,boolean isAsc,boolean isCertain){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =isCertain?conn.prepareStatement("SELECT * FROM `questions` WHERE `id`=? ORDER BY `" + order + "` " + t + " LIMIT ?,?")
                    :conn.prepareStatement("SELECT * FROM `questions` WHERE `id` LIKE '%"+Tools.likeStrFilter(id)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            if(isCertain) {
                ps.setString(1, id);
                ps.setInt(2, (page - 1) * pagesize);
                ps.setInt(3, pagesize);
            }else{
                ps.setInt(1, (page - 1) * pagesize);
                ps.setInt(2, pagesize);
            }
            rs = ps.executeQuery();
            List<Ques> set = new LinkedList<Ques>();
            while (rs.next()) {
                set.add(new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5), "###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8))));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<Ques> getQuessByContent(String content,int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `questions` WHERE `ques_content` LIKE '%"+Tools.likeStrFilter(content)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<Ques> set = new LinkedList<Ques>();
            while (rs.next()) {
                set.add(new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5), "###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8))));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<Ques> getQuessByAnaly(String analy,int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `questions` WHERE `ques_analy` LIKE '%"+Tools.likeStrFilter(analy)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<Ques> set = new LinkedList<Ques>();
            while (rs.next()) {
                set.add(new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5), "###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8))));
            }
            return set.isEmpty() ? null : set;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static boolean delQues(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `questions` WHERE `id`=?");
            ps.setString(1, id);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static boolean updateQuesById(String preid,String type,int score,String content,String answer,String analy,int lev){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `questions` SET `ques_type`=?,`ques_score`=?," +
                    "`ques_content`=?,`ques_answer`=?,`ques_analy`=?,`ques_lev`=? WHERE `id`=?");
            ps.setString(1, type);
            ps.setInt(2, score);
            ps.setString(3, content);
            ps.setString(4, answer);
            ps.setString(5, analy);
            ps.setString(6, String.valueOf(lev));
            ps.setString(7, preid);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static int getQuesScoreById(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `ques_score` FROM `questions` WHERE `id`=?");
            ps.setString(1, id);
            rs = ps.executeQuery();
            if(rs.next())
                return rs.getInt(1);
            return  0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static Map<String,Object> getQuesforCheck(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `ques_type`,`ques_score`,`ques_answer` FROM `questions` WHERE `id`=?");
            ps.setString(1, id);
            rs = ps.executeQuery();
            Map map=new HashMap<>();
            if(rs.next()){
                map.put("type",rs.getString(1));
                map.put("score",rs.getInt(2));
                map.put("answer",rs.getString(3));
            }
            return map;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static Ques_Test getQues_TestById(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            //MOYU
            ps = conn.prepareStatement("SELECT `ques_score`,`ques_content` FROM `questions` WHERE `id`=?");
            ps.setString(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Ques_Test(
                        id,rs.getInt(1),
                        Tools.StringToList(rs.getString(2), "###")
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
    public static Ques getQuesById(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `questions` WHERE `id`=?");
            ps.setString(1,id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Ques(
                        rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),
                        Tools.StringToList(rs.getString(5),"###"),Tools.StringToList(rs.getString(6), "###"),rs.getString(7),
                        Integer.parseInt(rs.getString(8)));
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static int getQuesCount() {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT COUNT(*) FROM `questions`");
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }

    public static boolean checkQuesIsExitById(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `questions` WHERE `id`=?");
            ps.setString(1, id);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }



    public static void main(String[] args) {
        System.out.println(getQuesById("AM697159486").getQues_content().get(3).replaceAll("\n",""));
    }
}
