package top.moyuyc.jdbc;

import top.moyuyc.entity.Paper;
import top.moyuyc.tools.Tools;
import top.moyuyc.transaction.Transaction;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by Yc on 2015/9/16.
 */
public class PaperAcess extends DataBase{
    private static final String delim = "###";



    public static boolean isExitById(String id){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps=conn.prepareStatement("SELECT * FROM `test_papers` WHERE `id`=?");
            ps.setString(1,id);
            rs=ps.executeQuery();
            return rs.next();
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }finally {
            Close();
        }
    }
    public static Map<String,Integer> getScoresById(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `single_ques_score`,`muti_ques_score`,`judge_ques_score`,`sa_ques_score`" +
                    "FROM `test_papers` WHERE `id`=?");
            ps.setString(1, id);
            rs = ps.executeQuery();
            Map<String,Integer> map = new HashMap<>();
            if (rs.next()) {
                map.put("single",rs.getInt(1));
                map.put("muti",rs.getInt(2));
                map.put("judge",rs.getInt(3));
                map.put("sa",rs.getInt(4));
            }
            return map.isEmpty() ? null : map;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static boolean addPaper(String id,String subject,int sqn,List<String>sql,int sqs,
                                   int mqn,List<String>mql,int mqs,int jqn,List<String>jql,int jqs,
                                   int saqn,List<String>saql,int saqs,int maxmin,int lev)
    {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("INSERT INTO `test_papers` VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            ps.setString(1, id);
            ps.setString(2, subject);
            ps.setInt(3, sqn);
            ps.setString(4, Tools.ListToString(sql, delim));
            ps.setInt(5, sqs);
            ps.setInt(6, mqn);
            ps.setString(7, Tools.ListToString(mql, delim));
            ps.setInt(8, mqs);
            ps.setInt(9, jqn);
            ps.setString(10, Tools.ListToString(jql, delim));
            ps.setInt(11, jqs);
            ps.setInt(12, saqn);
            ps.setString(13, Tools.ListToString(saql, delim));
            ps.setInt(14, saqs);
            ps.setInt(15,maxmin);
            ps.setString(16, String.valueOf(lev));
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public static boolean delPaperById(String id){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("DELETE FROM `test_papers` WHERE `id`=?");
            ps.setString(1, id);
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }
    public boolean updatePaperById(String preid,String subject,int sqn,List<String>sql,int sqs,
                                   int mqn,List<String>mql,int mqs,int jqn,List<String>jql,int jqs,
                                   int saqn,List<String>saql,int saqs,int maxmin,int lev)
    {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE `test_papers` SET `paper_subject`=?,`single_ques_num`=?,`single_ques_lists`=?,`single_ques_score`=?," +
                    "`muti_ques_num`=?,`muti_ques_lists`=?,`muti_ques_score`=?,`judge_ques_num`=?,`judge_ques_lists`=?,`judge_ques_score`=?," +
                    "`sa_ques_num`=?,`sa_ques_lists`=?,`sa_ques_score`=?,`maxmin`=?,`lev`=? WHERE `id`=?");
            ps.setString(15, preid);
            ps.setString(1, subject);
            ps.setInt(2, sqn);
            ps.setString(3, Tools.ListToString(sql, delim));
            ps.setInt(4, sqs);
            ps.setInt(5, mqn);
            ps.setString(6, Tools.ListToString(mql, delim));
            ps.setInt(7, mqs);
            ps.setInt(8, jqn);
            ps.setString(9, Tools.ListToString(jql, delim));
            ps.setInt(10, jqs);
            ps.setInt(11, saqn);
            ps.setString(12, Tools.ListToString(saql, delim));
            ps.setInt(13, saqs);
            ps.setInt(14,maxmin);
            ps.setString(15, String.valueOf(lev));
            return ps.executeUpdate()!=0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Close();
        }
    }

    public static Paper getPaperById(String id,boolean isCertain){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = isCertain?conn.prepareStatement("SELECT * FROM `test_papers` WHERE `id`=?"):conn.prepareStatement("SELECT * FROM `test_papers` WHERE `id` LIKE '%"+Tools.likeStrFilter(id)+"%' ESCAPE '*'");
            if(isCertain)
                ps.setString(1, id);
            rs = ps.executeQuery();
            return rs.next()?new Paper(
                    rs.getString(1),rs.getString(2),
                    rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                    rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                    rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                    rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                    rs.getInt(15),Integer.parseInt(rs.getString(16))
                    ):null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static List<Paper> getAllPapers(int page,int pagesize,String order,boolean isAsc){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT * FROM `test_papers` ORDER BY `" + order + "` " + t
                    + " LIMIT ?,?");
            ps.setInt(1, (page - 1) * pagesize);
            ps.setInt(2, pagesize);
            rs = ps.executeQuery();
            List<Paper> set = new LinkedList<Paper>();
            while (rs.next()) {
                set.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
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
    public static List<Paper> getPapersByQuesId(String id,int page,int pagesize,String order,boolean isAsc,boolean isCertain){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =isCertain?conn.prepareStatement("SELECT * FROM `test_papers` WHERE `single_ques_lists`=? OR `muti_ques_lists`=? OR `judge_ques_lists`=? OR `sa_ques_lists`=? ORDER BY `" + order + "` " + t + " LIMIT ?,?")
                    :conn.prepareStatement("SELECT * FROM `test_papers` WHERE `single_ques_lists` LIKE '%"+Tools.likeStrFilter(id)+"%' OR `muti_ques_lists` LIKE '%"+Tools.likeStrFilter(id)+"%' OR `judge_ques_lists` LIKE '" +Tools.likeStrFilter(id)+"'% "+
                                        "OR `sa_ques_lists` LIKE '%"+Tools.likeStrFilter(id)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            if(isCertain){
                ps.setString(1,id);
                ps.setString(2,id);
                ps.setString(3,id);
                ps.setString(4,id);
                ps.setInt(5, (page - 1) * pagesize);
                ps.setInt(6, pagesize);
            }else {
                ps.setInt(1, (page - 1) * pagesize);
                ps.setInt(2, pagesize);
            }
            rs = ps.executeQuery();
            List<Paper> set = new LinkedList<Paper>();
            while (rs.next()) {
                set.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
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
    public static List<Paper> getPapersBySubject(String subject,int page,int pagesize,String order,boolean isAsc,boolean isCertain){
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =isCertain?conn.prepareStatement("SELECT * FROM `test_papers` WHERE `paper_subject`=? ORDER BY `" + order + "` " + t + " LIMIT ?,?")
                    :conn.prepareStatement("SELECT * FROM `test_papers` WHERE "+"`paper_subject` LIKE '%"+Tools.likeStrFilter(subject)+"%' ESCAPE '*'"+
                    "ORDER BY `" + order + "` " + t + " LIMIT ?,?");
            if(isCertain){
                ps.setString(1,subject);
                ps.setInt(2, (page - 1) * pagesize);
                ps.setInt(3, pagesize);
            }else {
                ps.setInt(1, (page - 1) * pagesize);
                ps.setInt(2, pagesize);
            }
            rs = ps.executeQuery();
            List<Paper> set = new LinkedList<Paper>();
            while (rs.next()) {
                set.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
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
    public static List<String> getIdsById(String id,int page,int pagesize,String order,boolean isAsc)
    {
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `id` FROM `test_papers` WHERE `id` LIKE '%"+Tools.likeStrFilter(id)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
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
    public static List<String> getSubjectsBySub(String subject,int page,int pagesize,String order,boolean isAsc)
    {
        String t = isAsc ? "asc" : "desc";
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `paper_subject` FROM `test_papers` WHERE `paper_subject`LIKE '%"+Tools.likeStrFilter(subject)+"%' ESCAPE '*' ORDER BY `" + order + "` " + t + " LIMIT ?,?");
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

    public static int getMaxMinById(String paper_id) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT `maxmin` FROM `test_papers` WHERE `id`=?");
            ps.setString(1, paper_id);
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

    public static int getPaperCount() {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT COUNT(*) FROM `test_papers`");
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

    public static int getPaperLevById(String paperid) {
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT `paper_lev` FROM `test_papers` WHERE `id`=?");
            ps.setString(1, paperid);
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

    public static List<Paper> getPapersBySingleQues(String quesid){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `test_papers` WHERE `single_ques_lists` LIKE '%" + Tools.likeStrFilter(quesid) + "%' ESCAPE '*'");
            rs = ps.executeQuery();
            List<Paper> list = new LinkedList<>();
            while (rs.next()) {
                list.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
                ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<Paper> getPapersByMultiQues(String quesid){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `test_papers` WHERE `muti_ques_lists` LIKE '%" + Tools.likeStrFilter(quesid) + "%' ESCAPE '*'");
            rs = ps.executeQuery();
            List<Paper> list = new LinkedList<>();
            while (rs.next()) {
                list.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
                ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<Paper> getPapersByJudgeQues(String quesid){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `test_papers` WHERE `judge_ques_lists` LIKE '%" + Tools.likeStrFilter(quesid) + "%' ESCAPE '*'");
            rs = ps.executeQuery();
            List<Paper> list = new LinkedList<>();
            while (rs.next()) {
                list.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
                ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static List<Paper> getPapersBySaQues(String quesid){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps =conn.prepareStatement("SELECT * FROM `test_papers` WHERE `sa_ques_lists` LIKE '%" + Tools.likeStrFilter(quesid) + "%' ESCAPE '*'");
            rs = ps.executeQuery();
            List<Paper> list = new LinkedList<>();
            while (rs.next()) {
                list.add(new Paper(
                        rs.getString(1),rs.getString(2),
                        rs.getInt(3),Tools.StringToList(rs.getString(4), delim),rs.getInt(5),
                        rs.getInt(6),Tools.StringToList(rs.getString(7), delim),rs.getInt(8),
                        rs.getInt(9),Tools.StringToList(rs.getString(10), delim),rs.getInt(11),
                        rs.getInt(12),Tools.StringToList(rs.getString(13), delim),rs.getInt(14),
                        rs.getInt(15),Integer.parseInt(rs.getString(16))
                ));
            }
            return list.isEmpty()?null:list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }

    public static int[] delSaQues(String quesId,int score){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "sa_ques_lists=REPLACE(sa_ques_lists,?,''),sa_ques_num=sa_ques_num-1,sa_ques_score=sa_ques_score-?" +
                    " WHERE sa_ques_lists like '%"+quesId+"%';");
            ps.setString(1, quesId+delim);
            ps.setInt(2, score);
            ps.addBatch();
            ps.setString(1, quesId);
            ps.setInt(2, score);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    public static int[] delMultiQues(String quesId,int score){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "muti_ques_lists=REPLACE(muti_ques_lists,?,''),muti_ques_num=muti_ques_num-1,muti_ques_score=muti_ques_score-?" +
                    " WHERE muti_ques_lists like '%"+quesId+"%';");
            ps.setString(1, quesId+delim);
            ps.setInt(2, score);
            ps.addBatch();
            ps.setString(1,quesId);
            ps.setInt(2, score);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    public static int[] delSingleQuesByPaperId(String quesId,int score,String paperId){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "single_ques_lists=REPLACE(single_ques_lists,?,''),single_ques_num=single_ques_num-1,single_ques_score=single_ques_score-?" +
                    " WHERE id=? AND single_ques_lists LIKE '%"+Tools.likeStrFilter(quesId)+"%' ESCAPE '*'");
            ps.setString(1, quesId + delim);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            ps.setString(1, quesId);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    public static int[] delJudgeQuesByPaperId(String quesId,int score,String paperId){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "judge_ques_lists=REPLACE(judge_ques_lists,?,''),judge_ques_num=judge_ques_num-1,judge_ques_score=judge_ques_score-?" +
                    " WHERE id=? AND judge_ques_lists LIKE '%"+Tools.likeStrFilter(quesId)+"%' ESCAPE '*'");
            ps.setString(1, quesId + delim);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            ps.setString(1, quesId);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    public static int[] delMultiQuesByPaperId(String quesId,int score,String paperId){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "muti_ques_lists=REPLACE(muti_ques_lists,?,''),muti_ques_num=muti_ques_num-1,muti_ques_score=muti_ques_score-?" +
                    " WHERE id=? AND muti_ques_lists LIKE '%"+Tools.likeStrFilter(quesId)+"%' ESCAPE '*'");
            ps.setString(1, quesId + delim);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            ps.setString(1, quesId);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    public static int[] delSaQuesByPaperId(String quesId,int score,String paperId){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "sa_ques_lists=REPLACE(sa_ques_lists,?,''),sa_ques_num=sa_ques_num-1,sa_ques_score=sa_ques_score-?" +
                    " WHERE id=? AND sa_ques_lists LIKE '%"+Tools.likeStrFilter(quesId)+"%' ESCAPE '*'");
            ps.setString(1, quesId+delim);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            ps.setString(1,quesId);
            ps.setInt(2, score);
            ps.setString(3, paperId);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }

    public static int[] delSingleQues(String quesId,int score){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "single_ques_lists=REPLACE(single_ques_lists,?,''),single_ques_num=single_ques_num-1,single_ques_score=single_ques_score-?" +
                    " WHERE single_ques_lists like '%"+quesId+"%';");
            ps.setString(1, quesId+delim);
            ps.setInt(2, score);
            ps.addBatch();
            ps.setString(1, quesId);
            ps.setInt(2, score);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    public static int[] delJudgeQues(String quesId,int score){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "judge_ques_lists=REPLACE(judge_ques_lists,?,''),judge_ques_num=judge_ques_num-1,judge_ques_score=judge_ques_score-?" +
                    " WHERE judge_ques_lists like '%"+quesId+"%';");
            ps.setString(1, quesId+delim);
            ps.setInt(2, score);
            ps.addBatch();
            ps.setString(1, quesId);
            ps.setInt(2, score);
            ps.addBatch();
            int[] arr = ps.executeBatch();
            conn.commit();
            return arr;
        }catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
    /*
薛文满
 */
    public static int getNumByPaperId(String paperid){
        try {
            if (conn == null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT single_ques_lists FROM `test_papers`WHERE id=?");
            ps.setString(1, paperid);
            rs = ps.executeQuery();
            List<String> single_num =new LinkedList<>();
            while (rs.next()) {
                single_num = Tools.StringToList(rs.getString(1), "###");
            }
            int max_num = single_num.size();

            ps = conn.prepareStatement("SELECT muti_ques_lists FROM `test_papers`WHERE id=?");
            ps.setString(1, paperid);
            rs = ps.executeQuery();
            List<String> multi_num =new LinkedList<>();
            while (rs.next()) {
                multi_num = Tools.StringToList(rs.getString(1), "###");
            }
            max_num = max_num>=multi_num.size()?max_num:multi_num.size();

            ps = conn.prepareStatement("SELECT judge_ques_lists FROM `test_papers`WHERE id=?");
            ps.setString(1, paperid);
            rs = ps.executeQuery();
            List<String> judge_num =new LinkedList<>();
            while (rs.next()) {
                judge_num = Tools.StringToList(rs.getString(1), "###");
            }
            max_num = max_num>=judge_num.size()?max_num:judge_num.size();

            ps = conn.prepareStatement("SELECT sa_ques_lists FROM `test_papers`WHERE id=?");
            ps.setString(1, paperid);
            rs = ps.executeQuery();
            List<String> sa_num =new LinkedList<>();
            while (rs.next()) {
                sa_num = Tools.StringToList(rs.getString(1), "###");
            }
            max_num = max_num>=sa_num.size()?max_num:sa_num.size();

            return max_num;
        }catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            Close();
        }
    }
    /*
    薛文满
     */
    public static List<Integer> getListByRight(String name,String paperid,String ques_type){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT "+ques_type+" FROM `test_papers` WHERE id=?");
            ps.setString(1, paperid);
            rs = ps.executeQuery();
            List<String> ques_num =new LinkedList<>();
            while(rs.next()) {
                ques_num = Tools.StringToList(rs.getString(1), "###");
            }
            switch(ques_type) {
                case "single_ques_lists":ques_type="user_single_answ";
                    break;
                case "muti_ques_lists":ques_type="user_muti_answ";
                    break;
                case "judge_ques_lists":ques_type="user_judge_answ";
                    break;
                case "sa_ques_lists":ques_type="user_sa_answ";
                    break;
            }
            ps = conn.prepareStatement("SELECT "+ques_type+" FROM `user_test` WHERE paper_id=? AND user_name=?");
            ps.setString(1, paperid);
            ps.setString(2, name);
            rs = ps.executeQuery();
            List<String> ques_answ =new LinkedList<>();
            if(rs.next()){
                ques_answ = Tools.StringToList(rs.getString(1), "###");
            }
            List<Integer> result =new LinkedList<>();
            for(int i=0;i<ques_answ.size();i++){
                if(Transaction.quesRight(ques_num.get(i), ques_answ.get(i)))
                    result.add(i+1);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    /*
    薛文满
     */
    public static List<Integer> getListByQuest(String paperid,String ques_type,String ques_lev){
        try {
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("SELECT "+ques_type+" FROM `test_papers`WHERE id=?");
//            ps.setString(1, ques_type);
            ps.setString(1, paperid);
            rs = ps.executeQuery();
            List<String> ques_num =null;
            while(rs.next()) {
                ques_num = Tools.StringToList(rs.getString(1), "###");
            }
            List<Integer> result =new LinkedList<>();
            for(int i=0;i<ques_num.size();i++){
                ps = conn.prepareStatement("SELECT * FROM `questions` WHERE id=? AND ques_lev=?");
                ps.setString(1, ques_num.get(i));
                ps.setString(2, ques_lev);
                rs = ps.executeQuery();
                if(rs.next())
                    result.add(i+1);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    public static boolean updateSingleQuesByPaperId(String paperId,String oldquesId,int oldscore,String newquesId,int newscore){
        try{
            if(conn==null || conn.isClosed())
                conn = getConnInstance();
            ps = conn.prepareStatement("UPDATE test_papers SET " +
                    "single_ques_lists=REPLACE(single_ques_lists,?,?),muti_ques_score=muti_ques_score-?+?" +
                    " WHERE id=?");
            ps.setString(1, oldquesId);
            ps.setString(2, newquesId);
            ps.setInt(3, oldscore);
            ps.setInt(4, newscore);
            ps.setString(5, paperId);
            return ps.executeUpdate()!=0;
        }catch (SQLException e){
            e.printStackTrace();
            return false;
        }
    }
}
