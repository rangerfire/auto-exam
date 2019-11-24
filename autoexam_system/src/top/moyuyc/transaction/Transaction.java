package top.moyuyc.transaction;


import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import top.moyuyc.entity.*;
import top.moyuyc.jdbc.*;
import top.moyuyc.tools.Tools;
import top.moyuyc.websocket.ChatServer;

import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Yc on 2015/9/16.
 * 网页事务类，包含各种事务，如用户登录，管理员登录，用户注册，出卷，交卷，暂停考试等等
 */
public class Transaction {
    public static boolean quesRight(String ques_id,String query_answer){
        Map map=QuesAcess.getQuesforCheck(ques_id);
        if(map==null) return false;
        String type=(String)map.get("type");
//        if(type.equals(QuesAcess.TYPE_SHORTAN)) return 0;
        if(query_answer==null) return false;
        if(type==null) return false;
        if(type.equals(QuesAcess.TYPE_MUTICHOOSE)) query_answer=query_answer.replaceAll("@@@","###");
        String answer=(String)map.get("answer");
        if(query_answer.equalsIgnoreCase(answer))
            return true;
        return false;
    }
    /* 用户相关事务 */
    public static JSONObject userFriends(String user,int pageSize,int pageIndex){
        List<FriendRelation> list = FriendAcess.getFriends(user, pageIndex, pageSize);
        JSONObject rlt = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        if(list!=null)
            for(FriendRelation fr : list){
                JSONObject jsonObject = new JSONObject();
                if(fr.getUser1().equals(user))
                    jsonObject.put("name",fr.getUser2());
                else
                    jsonObject.put("name", fr.getUser1());
                jsonObject.put("date",fr.getDate());
                jsonArray.add(jsonObject);
            }
        rlt.put("user",user);
        rlt.put("friends",jsonArray);
        return rlt;
    }

    public static JSONArray userSearchUsers(String like_name,int page,int pagesize){
        List<User> all = UserAcess.getUserByLikeName(like_name, page, pagesize);
        JSONArray jsonArray = new JSONArray();
        for(User u : all){
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("name",u.getUser_name());
            //headimg , 综合积分 ，评价
            jsonArray.add(jsonObject);
        }
        return jsonArray;
    }
    public static JSONArray userSearchUsers(String byWho,String like_name,int page,int pagesize){
        List<User> all = UserAcess.getUserByLikeName(byWho,like_name,page,pagesize);
        JSONArray jsonArray = new JSONArray();
        for(User u : all){
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("name",u.getUser_name());
            //headimg , 综合积分 ，评价
            jsonArray.add(jsonObject);
        }
        return jsonArray;
    }
    public static void main(String[] args) {
        System.out.println(getPointChart("qqqqqq"));
    }
    /**
     * 用户登录
     * @param user_name
     * @param user_pwd
     * @return -1该用户不存在 0密码错误 1正确
     */
    public static int userLogin(String user_name, String user_pwd) {
        if(!UserAcess.checkUserIsExistByName(user_name))
            return -1;
        if(!UserAcess.checkUser(user_name,user_pwd))
            return 0;
        return 1;
    }

    /**
     * 用户注册
     * @param user_name 用户名
     * @param user_pwd 用户密码
     * @param user_email 用户邮箱
     * @return -1：user_name已经存在；0：user_email已经存在；1：注册成功。
     */
    public static int userReg(String user_name,String user_pwd,String user_email){
        if(UserAcess.checkUserIsExistByName(user_name))
            return -1;
        if(UserAcess.checkUserIsExistByEmail(user_email))
            return 0;
        UserAcess.addUser(user_name,user_pwd,user_email);
        PointAcess.addPoint(user_name, 1000);
        return 1;
    }
    public static boolean userAgreeAddFriendQuery(String agree_name,String query_name){
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(agree_name);
        if(list!=null)
            list.remove(query_name);

        Set<String> l = ChatServer.pass_rev_sender.get(query_name);
        if(l==null) {
            l = new HashSet<>();
            l.add(agree_name);
            ChatServer.pass_rev_sender.put(query_name,l);
        }else {
            synchronized (l) {
                l.add(agree_name);
            }
        }
        return FriendAcess.addFriends(query_name, agree_name);
    }

    public static boolean accecptPk(String me,String user1,String papID){
        if(UserPaperAcess.checkIsExistUserPaper(me,papID))
            return false;
        if(!PKHistoryAcess.updateUnDoneDrawPKHistory(user1, papID))
            return false;
        Exam exam = UserPaperAcess.getExamByUserPaper(user1, papID);
        return UserPaperAcess.addUserPaper(papID, me, exam.getSubject(), false, 0, 0, exam.getSingle_quess_sum(),
                null, 0, exam.getMuti_quess_sum(), null, 0, exam.getJudge_quess_sum(), null,
                0, exam.getSa_quess_sum(), null);
    }

    public static void userAgreeAllAddFriendQuery(String agree_name){
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(agree_name);
        map.put(agree_name,null);
        if(list!=null)
            for (String str:list){
                Set<String> set = ChatServer.pass_rev_sender.get(str);
                if(set==null){
                    set = new HashSet<>();
                    set.add(agree_name);
                    ChatServer.pass_rev_sender.put(str,set);
                }else {
                    set.add(agree_name);
                }
                ChatServer.broadNotify(str);
                FriendAcess.addFriends(str,agree_name);
            }
    }

    public static void userRefuseAddFriendQuery(String refuse_name,String query_name){
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(refuse_name);
        if(list!=null)
            list.remove(query_name);

        Set<String> l = ChatServer.ignore_rev_sender.get(query_name);
        if(l==null) {
            l = new HashSet<>();
            l.add(refuse_name);
            ChatServer.ignore_rev_sender.put(query_name,l);
        }else {
            synchronized (l) {
                l.add(refuse_name);
            }
        }
    }

    public static void userRefuseAllAddFriendQuery(String refuse_name){
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(refuse_name);
        map.put(refuse_name, null);
        for(String str:list){
            Set<String> l = ChatServer.ignore_rev_sender.get(str);
            if(l==null) {
                l = new HashSet<>();
                l.add(refuse_name);
                ChatServer.ignore_rev_sender.put(str,l);
            }else
                synchronized (l) {
                    l.add(refuse_name);
                }
        }

    }

    public static void userHandleAllIgnoreQuery(String name){
        ChatServer.ignore_rev_sender.remove(name);
    }
    public static void userHandleAllPassQuery(String name){
        ChatServer.pass_rev_sender.remove(name);
    }
    /**
     *
     * @param name
     * @param friend
     * @return -2:已经为好友 -1:friend/name 不存在 0:已经申请  1:正确申请
     */
    public static int userAddFriendQuery(String name,String friend){
        if(FriendAcess.checkFriendIsExists(name,friend))
            return -2;
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(friend);
        if (list != null) {
            synchronized (list) {
                if (list.contains(name)) return 0;
                list.add(name);
            }
        } else {
            if (!UserAcess.checkUserIsExistByName(friend) || !UserAcess.checkUserIsExistByName(name))
                return -1;
            list = new HashSet<>();
            list.add(name);
            map.put(friend, list);
        }
        ChatServer.broadNotify(friend);

        return 1;

    }

    public static boolean isExistsAddFriendAccept(String me,String other){
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(me);
        if(list==null) return false;
        return list.contains(other);
    }

    public static boolean isExistsAddFriendQuery(String name,String friend){
        Map<String,Set<String>> map = ChatServer.rev_sender;
        Set<String> list = map.get(friend);
        if(list==null) return false;
        return list.contains(name);
    }

    /**
     * 根据name更新密码
     * @param name
     * @param newpwd
     * @return null表示该用户不存在，若存在返回新的密码
     */
    public static String updatePwd(String name,String newpwd){
        if(!UserAcess.updateUserPwdbyName(name, newpwd))
            return null;
        return newpwd;
    }

    public static boolean userUpdateHead(String name,String newheadPath){
        UserHead uh = HeadAcess.getHeadByName(name);

        return uh==null?HeadAcess.addHead(name,newheadPath):HeadAcess.updateHead(name, newheadPath);
    }


    /**
     * 根据name更新邮箱
     * @param name
     * @param newemail
     * @return null表示该用户不存在，若存在返回新的邮箱
     */
    public static String updateEmail(String name,String newemail){
        if(!UserAcess.updateUserEmailbyName(name, newemail))
            return null;
        return newemail;
    }
    /**
     * 获取用户密码
     * @param name
     * @return null表示该用户不存在，若存在返回密码
     */
    public static String getPwd(String name){
        User user=UserAcess.getUserByName(name);
        return user!=null?user.getUser_pwd():null;
    }

    public static ExamForChart transform(Exam exam){
        ExamForChart efc = new ExamForChart();
        efc.setId(exam.getPaper_id());
        if(exam.getSingle_quess_sum()==0)
            efc.setSinglePercent("-");
        else
            efc.setSinglePercent(String.format("%.0f",((exam.getSingle_quess_score()/(float)(exam.getSingle_quess_sum())))*100));
        if(exam.getMuti_quess_sum()==0)
            efc.setMultiPercent("-");
        else
            efc.setMultiPercent(String.format("%.0f", ((exam.getMuti_quess_score() / (float) (exam.getMuti_quess_sum()))) * 100));
        if(exam.getJudge_quess_sum()==0)
            efc.setJudgePercent("-");
        else
            efc.setJudgePercent(String.format("%.0f", ((exam.getJudge_quess_score() / (float) (exam.getJudge_quess_sum()))) * 100));
        return efc;
    }
    public static JSONObject getChartData(String user){
        String order = "start_time";
        List<Exam> list = UserPaperAcess.getFinishExamsByUserName(user, order,true);
        JSONObject rlt = new JSONObject();
        JSONArray xs = new JSONArray(), sp = new JSONArray(), mp = new JSONArray(), jp = new JSONArray();
        if(list==null) return rlt;
        for (int i = 0; i < list.size(); i++) {
            ExamForChart efs = transform(list.get(i));
            xs.add(efs.getId());
            sp.add(efs.getSinglePercent());
            mp.add(efs.getMultiPercent());
            jp.add(efs.getJudgePercent());
        }
        rlt.put("xAxis", xs);
        rlt.put("sp", sp);
        rlt.put("mp", mp);
        rlt.put("jp", jp);
        return rlt;
    }

    /**
     * 获取用户邮箱
     * @param name
     * @return null表示该用户不存在，若存在返回邮箱
     */
    public static String getEmail(String name){
        User user=UserAcess.getUserByName(name);
        return user!=null?user.getUser_email():null;
    }
    public static String searchQuesById(String id,boolean isCertain,String page,String pageSize,boolean isAsc){
        List<Ques> list=QuesAcess.getQuessById(id, Integer.parseInt(page), Integer.parseInt(pageSize), QuesAcess.QUES_SUB, isAsc, isCertain);
        Map m = new HashMap<>();
        m.put("data",list);
        m.put("content",id);
        if(list==null)  return "-1";
        return JSONObject.fromObject(m).toString();
    }
    public static String searchQuesByAnaly(String analy,String page,String pageSize,boolean isAsc){
        List<Ques> list=QuesAcess.getQuessByAnaly(analy, Integer.parseInt(page), Integer.parseInt(pageSize), QuesAcess.QUES_SUB, isAsc);
        Map m = new HashMap<>();
        m.put("data",list);
        m.put("content",analy);
        if(list==null)  return "-1";
        return JSONObject.fromObject(m).toString();
    }
    public static String searchQuesByContent(String content,String page,String pageSize,boolean isAsc){
        List<Ques> list=QuesAcess.getQuessByContent(content, Integer.parseInt(page), Integer.parseInt(pageSize), QuesAcess.QUES_SUB, isAsc);
        Map m = new HashMap<>();
        m.put("data",list);
        m.put("content",content);
        if(list==null)  return "-1";
        return JSONObject.fromObject(m).toString();
    }
    public static String searchQuesBySubject(String subject,boolean isCertain,String page,String pageSize,boolean isAsc){
        List<Ques> list=QuesAcess.getQuessBySubject(subject, Integer.parseInt(page), Integer.parseInt(pageSize), QuesAcess.QUES_SUB, isAsc, isCertain);
        Map m = new HashMap<>();
        m.put("data",list);
        m.put("content",subject);
        if(list==null)  return "-1";
        return JSONObject.fromObject(m).toString();
    }
    public static String autoTest(String subject,String singlenum,String mutinum,String judgenum,String sanum,String maxmin,String username,int lev,String levpath){
        int n1=Integer.parseInt(singlenum),n2=Integer.parseInt(mutinum),n3=Integer.parseInt(judgenum),n4=Integer.parseInt(sanum);
        if(n1==0&&n2==0&&n3==0&&n4==0)  return null;
        Properties pro=new Properties();
        String[] levArr=null;
        try {
            pro.load(new FileReader(levpath));
            if(lev==3)
                levArr=pro.getProperty("lev.easy").split("###");
            else if(lev==2)
                levArr=pro.getProperty("lev.mid").split("###");
            else
                levArr=pro.getProperty("lev.hard").split("###");
        } catch (IOException e) {
            e.printStackTrace();
        }
        int n1_hard=(int)(n1*Float.parseFloat(levArr[0])),n2_hard=(int)(n2*Float.parseFloat(levArr[0])),n3_hard=(int)(n3*Float.parseFloat(levArr[0])),n4_hard=(int)(n4*Float.parseFloat(levArr[0]));
        int n1_mid=(int)(n1*Float.parseFloat(levArr[1])),n2_mid=(int)(n2*Float.parseFloat(levArr[1])),n3_mid=(int)(n3*Float.parseFloat(levArr[1])),n4_mid=(int)(n4*Float.parseFloat(levArr[1]));
        int n1_easy=n1-n1_hard-n1_mid,n2_easy=n2-n2_hard-n2_mid,n3_easy=n3-n3_hard-n3_mid,n4_easy=n4-n4_hard-n4_mid;

        List<Ques_Test> l1= Tools.ListCombine(
                QuesAcess.getRandomQuesByLev(n1_hard, QuesAcess.TYPE_SINGLECHOOSE, subject, 0),
                QuesAcess.getRandomQuesByLev(n1_mid, QuesAcess.TYPE_SINGLECHOOSE, subject, 1),
                QuesAcess.getRandomQuesByLev(n1_easy, QuesAcess.TYPE_SINGLECHOOSE, subject, 2));
        List<Ques_Test> l2=Tools.ListCombine(
                QuesAcess.getRandomQuesByLev(n2_hard, QuesAcess.TYPE_MUTICHOOSE, subject, 0),
                QuesAcess.getRandomQuesByLev(n2_mid, QuesAcess.TYPE_MUTICHOOSE, subject, 1),
                QuesAcess.getRandomQuesByLev(n2_easy, QuesAcess.TYPE_MUTICHOOSE, subject, 2));
        List<Ques_Test> l3=Tools.ListCombine(
                QuesAcess.getRandomQuesByLev(n3_hard, QuesAcess.TYPE_JUDGE, subject, 0),
                QuesAcess.getRandomQuesByLev(n3_mid, QuesAcess.TYPE_JUDGE, subject, 1),
                QuesAcess.getRandomQuesByLev(n3_easy, QuesAcess.TYPE_JUDGE, subject, 2));
        List<Ques_Test> l4=Tools.ListCombine(
                QuesAcess.getRandomQuesByLev(n4_hard, QuesAcess.TYPE_SHORTAN, subject, 0),
                QuesAcess.getRandomQuesByLev(n4_mid, QuesAcess.TYPE_SHORTAN, subject, 1),
                QuesAcess.getRandomQuesByLev(n4_easy, QuesAcess.TYPE_SHORTAN, subject, 2));
        int s1=0,s2=0,s3=0,s4=0;
        Map<String,Object> out=new HashMap<>();
        out.put("single",l1);
        out.put("muti",l2);
        out.put("judge",l3);
        out.put("sa", l4);
        out.put("maxmin",maxmin);
        out.put("paper_lev",lev);
        out.put("subject", subject);
        List<String> q1=new LinkedList<>(),q2=new LinkedList<>(),q3=new LinkedList<>(),q4=new LinkedList<>();
        if(l1!=null)
            for(Ques_Test s : l1) {
                s1 += s.getQues_score();
                q1.add(s.getId());
            }
        if(l2!=null)
            for(Ques_Test s : l2) {
                s2 += s.getQues_score();
                q2.add(s.getId());
            }
        if(l3!=null)
            for(Ques_Test s : l3) {
                s3 += s.getQues_score();
                q3.add(s.getId());
            }
        if(l4!=null)
            for(Ques_Test s : l4) {
                s4 += s.getQues_score();
                q4.add(s.getId());
            }
        String id;
        while(PaperAcess.isExitById(id=Tools.randUpperStr(2, 4)))
            System.out.println(id);
        out.put("paper_id",id);

        PaperAcess.addPaper(id, subject, l1==null?0:l1.size(), q1, s1, l2==null?0:l2.size(), q2, s2, l3==null?0:l3.size(), q3, s3
                , l4==null?0:l4.size(), q4, s4,Integer.parseInt(maxmin),lev);
        UserPaperAcess.addUserPaper(id,username,subject,false,0,0,s1,null,0,s2,null,0,s3,null,0,s4,null);
        return JSONObject.fromObject(out).toString();
    }

    public static boolean testSubmitorSave(String username,String paper_id,boolean isok,int spendmin,
                                           List<String> singleids,List<String> singleans,
                                           List<String> mutiids,List<String> mutians,
                                           List<String> judgeids,List<String> judgeans,
                                           List<String> saids,List<String> saans)
    {
//        System.err.println(Tools.ListToString(saans,"###"));
        int s1=0,s2=0,s3=0;
        if(isok) {
            for (int i = 0; i < singleids.size(); i++)
                s1 += quesScore(singleids.get(i), singleans.get(i));
            for (int i = 0; i < mutiids.size(); i++)
                s2 += quesScore(mutiids.get(i), mutians.get(i));
            for (int i = 0; i < judgeids.size(); i++)
                s3 += quesScore(judgeids.get(i), judgeans.get(i));
//            for (int i = 0; i < saids.size(); i++)
//                s4 += quesScore(saids.get(i), saans.get(i));
        }
        if(isok) {
            PKHistory pk = PKHistoryAcess.getPKHistoryByName(username, paper_id);
            if(pk!=null) {
                String other = pk.getUser1().equals(username) ? pk.getUser2() : pk.getUser1();
                int score = UserPaperAcess.getOkAllScoreByUserPaper(other, paper_id);
                if (score != -1) {
                    int s = s1 + s2 + s3;
                    if (s == score) {
                        PKHistoryAcess.updateDoneDrawPKHistory(username, paper_id, 5, 5);
                        PointAcess.deltaPoint(username, 5);
                        PointAcess.deltaPoint(other, 5);
                    } else if (s > score) {
                        PKHistoryAcess.updateDoneNoDrawPKHistory(username, paper_id, username, 10, -5);
                        PointAcess.deltaPoint(username, 10);
                        PointAcess.deltaPoint(other, -5);
                    } else {
                        PKHistoryAcess.updateDoneNoDrawPKHistory(username, paper_id, other, 10, -5);
                        PointAcess.deltaPoint(other, 10);
                        PointAcess.deltaPoint(username, -5);
                    }
                }
            }
        }
        return UserPaperAcess.paperSubmit(paper_id,username,isok,spendmin,s1,Tools.ListToString(singleans,"###"),
                s2,Tools.ListToString(mutians,"###"),s3,Tools.ListToString(judgeans,"###"),
                0,Tools.ListToString(saans,"###"));
    }
    public static JSONObject getCompareChart(String user1,String user2,String paperID){
        PKHistory pk = PKHistoryAcess.getDonePKHistory(user1, user2, paperID);
        JSONObject object = new JSONObject();
        if(pk==null)
            return null;
        int lev = PaperAcess.getPaperLevById(paperID);
        Exam exam = UserPaperAcess.getExamByUserPaper(user1,paperID);
        object.put("subject",exam.getSubject());
        object.put("lev",lev==0?"困难":lev==1?"适中":"简单");
        object.put("user1",user1);
        object.put("user1MultiScore", exam.getMuti_quess_score());
        object.put("user1SingleScore", exam.getSingle_quess_score());
        object.put("user1JudgeScore", exam.getJudge_quess_score());
        object.put("user2",user2);
        exam = UserPaperAcess.getExamByUserPaper(user2,paperID);
        object.put("user2MultiScore", exam.getMuti_quess_score());
        object.put("user2SingleScore", exam.getSingle_quess_score());
        object.put("user2JudgeScore", exam.getJudge_quess_score());
        if(pk.getStatus()==1){
            object.put("status",1);
            object.put("winname",pk.getWin_name());
        }else{
            object.put("status",2);
        }
        return object;
    }

    public static JSONObject getPointChart(String name){
        List<PKHistory> list = PKHistoryAcess.getAllDonePKHistorysByName(name);
        SimpleDateFormat formatter = new SimpleDateFormat();
        if(list!=null&&!list.isEmpty()) {
            LinkedList ll = new LinkedList(),ll2 = new LinkedList();
            String prevDate = null;
            int curPoint = PointAcess.getPointByName(name),index=0;
            for (PKHistory pk : list) {
                String date = null;
                try {
                    date = timeStrToDateStr(pk.getPktime());
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                index++;
                if(date.equals(prevDate)) {
//                    if(index==list.size()){
//                        ll.addFirst(curPoint);
//                        ll2.addFirst(prevDate);
//                    }
                    curPoint = calcDonePrevPoint(name,curPoint,pk);
                }else{
                    prevDate = date;
                    ll.addFirst(curPoint);
                    ll2.addFirst(prevDate);
                    curPoint = calcDonePrevPoint(name,curPoint,pk);
                }
            }
            JSONObject object = new JSONObject();
            object.put("dates",ll2);
            object.put("points",ll);
            return object;
        }else
            return null;
    }

    private static String timeStrToDateStr(String str) throws ParseException {
        return new SimpleDateFormat("yyyy-MM-dd").format(
            new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(str)
        );
    }
    private static int calcDonePrevPoint(String name,int curpoint,PKHistory pkHistory){
        if(pkHistory.getStatus()==1)
            if(pkHistory.getWin_name().equals(name))
                curpoint-=pkHistory.getInc_point();
            else
                curpoint-=pkHistory.getDec_point();
        else{
            curpoint-=pkHistory.getInc_point();
        }
        return curpoint;
    }

    /**
     * 题目回答是否正确
     * @return 得分
     */
    private static int quesScore(String ques_id,String query_answer){
        Map map=QuesAcess.getQuesforCheck(ques_id);
        if(map==null) return 0;
        String type=(String)map.get("type");
        if(type==null) return 0;
        if(type.equals(QuesAcess.TYPE_SHORTAN)) return 0;
        if(type.equals(QuesAcess.TYPE_MUTICHOOSE)) query_answer=query_answer.replaceAll("@@@","###");
        int score=(int)map.get("score");
        String answer=(String)map.get("answer");
        if(query_answer.equalsIgnoreCase(answer))
            return score;
        return 0;
    }

    public static Map<String,Object> getContinueTest(String username,String paperid){
        Paper paper=PaperAcess.getPaperById(paperid, true);
        Map<String,Object> map=UserPaperAcess.getTestQuessByIdName(username, paperid,false);
        if(map==null) return null;
        List<Ques_Test> l1=new LinkedList<>(),l2=new LinkedList<>(),l3=new LinkedList<>(),l4=new LinkedList<>();
        for(String s: paper.getSingle_ques_lists())
            l1.add(QuesAcess.getQues_TestById(s));
        for(String s: paper.getMuti_ques_lists())
            l2.add(QuesAcess.getQues_TestById(s));
        for(String s: paper.getJudge_ques_lists())
            l3.add(QuesAcess.getQues_TestById(s));
        for(String s: paper.getSa_ques_lists())
            l4.add(QuesAcess.getQues_TestById(s));
        map.put("subject",paper.getPaper_subject());
        map.put("single",l1);
        map.put("muti",l2);
        map.put("judge",l3);
        map.put("sa",l4);
        map.put("maxmin",paper.getMaxmin());
        map.put("paper_id",paperid);
        map.put("paper_lev",PaperAcess.getPaperLevById(paperid));
        return map;
    }

    public static Map<String,Object> getTestShowAll(String username,String paperid){
        Paper paper=PaperAcess.getPaperById(paperid, true);
        Map<String,Object> map=UserPaperAcess.getTestQuessByIdName(username, paperid, true);
        int paperLev=PaperAcess.getPaperLevById(paperid);
        if(map==null) return null;
        List<Ques> l1=new LinkedList<>(),l2=new LinkedList<>(),l3=new LinkedList<>(),l4=new LinkedList<>();
        for(String s: paper.getSingle_ques_lists())
            l1.add(QuesAcess.getQuesById(s));
        for(String s: paper.getMuti_ques_lists())
            l2.add(QuesAcess.getQuesById(s));
        for(String s: paper.getJudge_ques_lists())
            l3.add(QuesAcess.getQuesById(s));
        for(String s: paper.getSa_ques_lists())
            l4.add(QuesAcess.getQuesById(s));
        map.put("subject",paper.getPaper_subject());
        map.put("single",l1);
        map.put("muti",l2);
        map.put("judge",l3);
        map.put("sa",l4);
        map.put("maxmin",paper.getMaxmin());
        map.put("paper_id",paperid);
        map.put("paper_lev",paperLev);
        return map;
    }


    /* 管理员相关事务 */

    /**
     * 管理员登陆
     * @param name
     * @param pwd
     * @param config_path 配置文件所在路径
     * @return boolean
     */
    public static boolean adminLogin(String name,String pwd,String config_path){
        Properties pro=new Properties();
        try {
            pro.load(new FileReader(config_path));
            String num1=pwd.substring(2,4);
            String num2=pwd.substring(6, 8);
            Integer.parseInt(num1);
            Integer.parseInt(num2);
            Pattern p = Pattern.compile("[\\D+]");
            Matcher m=p.matcher(pwd);
            String password="";
            while(m.find()){
                password+=m.group();
            }
            System.out.println(password);
            if(((String)pro.getProperty("admin.username")).equals(name) && ((String)pro.getProperty("admin.password")).equals(password))
                return true;
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void adminAddQues(String subject,String type,int score,String content,String answer,String analy,int lev){
        String id=null;
        while(QuesAcess.checkQuesIsExitById(id=Tools.randUpperStr(2,9)));
        QuesAcess.addQues(id,subject,type,score,content,answer,analy,lev);
    }

    public static boolean adminUpdateUserByName(String pre_name,String new_name,String new_pwd,String new_email){
        if(pre_name.equals(new_name))
            return UserAcess.updateUserByName(pre_name,new_name,new_email,new_pwd);
        else {
            UserPaperAcess.updateUserName(pre_name,new_name);
            return UserAcess.updateUserByName(pre_name,new_name,new_email,new_pwd);
        }
    }

    public static boolean adminDelUserByName(String name){
        boolean isExist = UserAcess.delUserByName(name);
        if(!isExist) return false;
        UserPaperAcess.delUserPaperByUserName(name);
        return true;
    }

    public static boolean adminDelUserByEmail(String email){
        User user = UserAcess.getUserByEmail(email);
        if(user==null) return false;
        boolean isExist = UserAcess.delUserByEmail(email);
        if(!isExist) return false;
        UserPaperAcess.delUserPaperByUserName(user.getUser_name());
        return true;
    }

    public static boolean adminDelPaper(String id){
        boolean isExist = PaperAcess.delPaperById(id);
        if(!isExist) return false;
        UserPaperAcess.delUserPaperByPaper(id);
        return true;
    }

    public static boolean adminDelUserPaper(String username,String paperid){
        return UserPaperAcess.delUserPaperByU_P(username,paperid)!=0;
    }

    public static boolean adminDelQues(String id){
        Ques ques = QuesAcess.getQuesById(id);
        if(ques==null) return false;
        List<Paper> papers = null;
        if(ques.getQues_type().equals(QuesAcess.TYPE_SINGLECHOOSE)){
            papers = PaperAcess.getPapersBySingleQues(id);
            if(papers!=null) {
                for (int i = 0; i < papers.size(); i++) {
                    List<String> lists = papers.get(i).getSingle_ques_lists();
                    for (int j = 0; j < lists.size(); j++) {
                        if (id.equals(lists.get(j))) {
                            UserPaperAcess.delSingleAwByPaperId(j, lists.size(), ques.getQues_score(), papers.get(i).getId());
                            break;
                        }
                    }
                }
                PaperAcess.delSingleQues(id, ques.getQues_score());
            }
        }else if(ques.getQues_type().equals(QuesAcess.TYPE_MUTICHOOSE)){
            papers = PaperAcess.getPapersByMultiQues(id);
            if(papers!=null) {
                for (int i = 0; i < papers.size(); i++) {
                    List<String> lists = papers.get(i).getMuti_ques_lists();
                    for (int j = 0; j < lists.size(); j++) {
                        if (id.equals(lists.get(j))) {
                            UserPaperAcess.delMultiAwByPaperId(j, lists.size(), ques.getQues_score(), papers.get(i).getId());
                            break;
                        }
                    }
                }
                PaperAcess.delMultiQues(id, ques.getQues_score());
            }
        }else if(ques.getQues_type().equals(QuesAcess.TYPE_JUDGE)){
            papers = PaperAcess.getPapersByJudgeQues(id);
            if(papers!=null) {
                for (int i = 0; i < papers.size(); i++) {
                    List<String> lists = papers.get(i).getJudge_ques_lists();
                    for (int j = 0; j < lists.size(); j++) {
                        if (id.equals(lists.get(j))) {
                            UserPaperAcess.delJudgeAwByPaperId(j, lists.size(), ques.getQues_score(), papers.get(i).getId());
                            break;
                        }
                    }
                }
                PaperAcess.delJudgeQues(id, ques.getQues_score());
            }
        }else {
            papers = PaperAcess.getPapersBySaQues(id);
            if(papers!=null) {
                for (int i = 0; i < papers.size(); i++) {
                    List<String> lists = papers.get(i).getSa_ques_lists();
                    for (int j = 0; j < lists.size(); j++) {
                        if (id.equals(lists.get(j))) {
                            UserPaperAcess.delSaAwByPaperId(j, lists.size(), ques.getQues_score(), papers.get(i).getId());
                            break;
                        }
                    }
                }
                PaperAcess.delSaQues(id, ques.getQues_score());
            }
        }
        return QuesAcess.delQues(id);
    }



}
