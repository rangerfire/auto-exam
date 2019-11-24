<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.entity.PKHistory" %>

<%@ page import="top.moyuyc.entity.Paper" %>
<%@ page import="top.moyuyc.entity.SimpleTimeShow" %>
<%@ page import="top.moyuyc.jdbc.*" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="top.moyuyc.transaction.SendMail" %>
<%@ page import="top.moyuyc.transaction.Transaction" %>
<%@ page import="top.moyuyc.websocket.ChatServer" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/16
  Time: 22:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
//    out.print(request.getParameter("[0][id]"));
    String act = (request.getParameter("act"));
    Object s_user=session.getAttribute("username");

    if (act.equals("userlogin")) {
        String username = (request.getParameter("username"));
        String password = (request.getParameter("password"));
        boolean isRem = Boolean.parseBoolean(request.getParameter("isRem"));
        int v = Transaction.userLogin(username, password);
        if (v == 1) {
            session.setAttribute("username", username);
            if(isRem) {
                response.addCookie(Tools.getCookie("USER_NAME", URLEncoder.encode(username, "utf-8"), 7 * 24 * 3600, false));
                response.addCookie(Tools.getCookie("USER_PWD", URLEncoder.encode(password, "utf-8"), 7 * 24 * 3600, false));
            }else{
                response.addCookie(Tools.getCookie("USER_NAME", URLEncoder.encode(username, "utf-8"), 0, false));
                response.addCookie(Tools.getCookie("USER_PWD", URLEncoder.encode(password, "utf-8"), 0, false));
            }
            out.print(1);
        } else
            out.print(v);
    } else if (act.equals("userExit")) {
        List<ChatServer> l=ChatServer.connections.get(s_user);
        if(l!=null) {
            for (ChatServer cs : l)
                if(cs.httpSession.equals(session))
                    cs.session.close();
        }
        session.removeAttribute("username");
    } else if (act.equals("userForget")) {
        final String username = Tools.ParToStr(request.getParameter("username"));
        Object email_newpwd=session.getAttribute("email_newpwd");
        if (email_newpwd != null && ((String) email_newpwd).equals(username)) {
            out.print(-1);
            return;
        }
        final String email = Transaction.getEmail(username);
        if (email == null) {
            out.print(0);
            return;
        }
        session.setAttribute("email_newpwd", username);
        Thread th = new Thread() {
            @Override
            public void run() {
                SendMail.SendNewPw(username, email, getServletConfig().getServletContext().getRealPath("/WEB-INF/config/mail.properties"));
            }
        };
        final HttpSession httpSession=session;
        Thread th1=new Thread(){
            @Override
            public void run() {
                try {
                    Thread.sleep(1000*60*5);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                synchronized (httpSession) {
                    httpSession.removeAttribute("email_newpwd");
                }
            }
        };
        th.start();
        th1.start();
        out.print(1);
    } else if (act.equals("userReg")) {
        final String username = (request.getParameter("username"));
        String password = (request.getParameter("password"));
        final String email = Tools.ParToStr(request.getParameter("email"));
        int v=0;
        out.print(v=Transaction.userReg(username, password, email));
        if(v==1) {
            Thread th = new Thread() {
                @Override
                public void run() {
                    SendMail.SendWelCome(username, email, getServletConfig().getServletContext().getRealPath("/WEB-INF/config/mail.properties"));
                }
            };
            th.start();
        }
    } else if (act.equals("userSearch")) {
        if(s_user==null)  return;
        boolean isCertain = Boolean.parseBoolean(Tools.ParToStr(request.getParameter("isCertain")));
        String con = Tools.ParToStr(request.getParameter("searchCon"));
        String content = Tools.ParToStr(request.getParameter("content"));
        String pag =Tools.ParToStr(request.getParameter("page"));
        String pageSize = Tools.ParToStr(request.getParameter("pageSize"));
        boolean isAsc = Boolean.parseBoolean(Tools.ParToStr(request.getParameter("isAsc")));
        if (con.equals("ques_Id")) {
            out.print(Transaction.searchQuesById(content, isCertain, pag, pageSize, isAsc));
        } else if (con.equals("ques_Content")) {
            out.print(Transaction.searchQuesByContent(content, pag, pageSize, isAsc));
        } else if (con.equals("ques_Subject")) {
            out.print(Transaction.searchQuesBySubject(content, isCertain, pag, pageSize, isAsc));
        } else {//Analysis
            out.print(Transaction.searchQuesByAnaly(content, pag, pageSize, isAsc));
        }
    }else {
        if (act.equals("userTest")) {
            if (s_user == null) return;
            String subject = Tools.ParToStr(request.getParameter("subject"));
            String singlenum = (request.getParameter("singlenum"));
            String mutinum = (request.getParameter("mutinum"));
            String judgenum = (request.getParameter("judgenum"));
            String sanum = (request.getParameter("sanum"));
            String maxmin = (request.getParameter("maxmin"));
            int lev = Integer.parseInt(request.getParameter("lev"));
            String result = Transaction.autoTest(subject, singlenum, mutinum, judgenum, sanum, maxmin, s_user.toString()
                    , lev, getServletConfig().getServletContext().getRealPath("/WEB-INF/config/lev.properties"));
            out.print(result == null ? -1 : result);

            // add cookie
            StringBuffer sb = new StringBuffer(s_user.toString());
            sb.append("&" + subject).append("&" + singlenum).append("&" + mutinum)
                    .append("&" + judgenum).append("&" + sanum).append("&" + maxmin).append("&" + lev);
            response.addCookie(Tools.getCookie("examstra",URLEncoder.encode(sb.toString(),"utf-8"),Integer.MAX_VALUE,false));
        } else if (act.equals("userPwdChange")) {
            if (s_user == null) return;
            String oldPwd = (request.getParameter("oldPwd"));
            String newPwd = (request.getParameter("newPwd"));
            if (!UserAcess.checkUser(s_user.toString(), oldPwd) ||
                    null == Transaction.updatePwd(s_user.toString(), newPwd)) {
                out.print(-1);
                return;
            }
            out.print(1);
        } else if (act.equals("userEmailChange")) {
            if (s_user == null) return;
            String newEmail = Tools.ParToStr(request.getParameter("newEmail"));
            if (Transaction.updateEmail(s_user.toString(), newEmail) == null) {
                out.print(-1);
                return;
            }
            out.print(1);
        } else if (act.equals("testOp")) {
            if (s_user == null) return;
            int singlenum = Integer.parseInt(request.getParameter("sn"));
            int mutinum = Integer.parseInt(request.getParameter("mn"));
            int judgenum = Integer.parseInt(request.getParameter("jn"));
            int sanum = Integer.parseInt(request.getParameter("san"));
            String paperid = request.getParameter("pi");
            int spendtime = Integer.parseInt(request.getParameter("st"));
            boolean isok = Boolean.parseBoolean(request.getParameter("isok"));
            List<String> ids1 = new LinkedList<String>();
            List<String> ans1 = new LinkedList<String>();
            List<String> ids2 = new LinkedList<String>();
            List<String> ans2 = new LinkedList<String>();
            List<String> ids3 = new LinkedList<String>();
            List<String> ans3 = new LinkedList<String>();
            List<String> ids4 = new LinkedList<String>();
            List<String> ans4 = new LinkedList<String>();
            for (int i = 0; i < singlenum; i++) {
                String quesid = Tools.ParToStr(request.getParameter("s[" + i + "][id]"));
                String answer = (request.getParameter("s[" + i + "][aw]"));
                ids1.add(quesid);
                ans1.add(answer);
            }
            for (int i = 0; i < mutinum; i++) {
                String quesid = (request.getParameter("m[" + i + "][id]"));
                String answer = (request.getParameter("m[" + i + "][aw]"));
                ids2.add(quesid);
                ans2.add(answer);
            }
            for (int i = 0; i < judgenum; i++) {
                String quesid = (request.getParameter("j[" + i + "][id]"));
                String answer = (request.getParameter("j[" + i + "][aw]"));
                ids3.add(quesid);
                ans3.add(answer);
            }
            for (int i = 0; i < sanum; i++) {
                String quesid = request.getParameter("sa[" + i + "][id]");
                String answer = request.getParameter("sa[" + i + "][aw]");
                ids4.add(quesid);
                ans4.add(answer);
            }
            Transaction.testSubmitorSave(s_user.toString(), paperid, isok, spendtime,
                    ids1, ans1, ids2, ans2, ids3, ans3, ids4, ans4);
        } else if (act.equals("testContinue")) {
            if (s_user == null) return;
            String paperid = Tools.ParToStr(request.getParameter("paperid"));
            String username = s_user.toString();
            Map map = Transaction.getContinueTest(username, paperid);
            if (map != null)
                out.print(JSONObject.fromObject(map));
            else
                out.print(-1);
        } else if (act.equals("showall")) {
            if (s_user == null) return;
            String paperid = Tools.ParToStr(request.getParameter("paperid"));
            String username = s_user.toString();
            Map map = Transaction.getTestShowAll(username, paperid);
            if (map != null)
                out.print(JSONObject.fromObject(map));
            else
                out.print(-1);
        } else if (act.equals("addMess")) {
            if (session.getAttribute("addmess") != null) {
                out.print("一天只能留言一次");
                return;
            }
            String name = request.getParameter("name").trim();
            String phone = request.getParameter("phone").trim();
            String email = request.getParameter("email").trim();
            String mess = request.getParameter("mess").trim();
            if (!phone.matches("\\d+-\\d+|\\d+")) {
                out.print("请输入正确的手机号码");
                return;
            }
            if (!email.matches(".+@.+\\..+")) {
                out.print("请输入正确的电子邮箱");
                return;
            }
            if (name.trim().isEmpty()) {
                out.print("姓名不能为空");
                return;
            }
            if (mess.trim().isEmpty()) {
                out.print("留言不能为空");
                return;
            }
            MessAcess.addMess(name, phone, email, mess);
            session.setAttribute("addmess", true);
            out.print("留言提交成功，感谢您的留言。");
        }else if(act.equals("fightByPapers")){
            String user = request.getParameter("user");
            if(FriendAcess.checkFriendIsExists(s_user.toString(),user)) {
                String[] papers = request.getParameterValues("papers[]");
                boolean f = false;
                if(papers!=null)
                    for (String p : papers) {
                        if(true==PKHistoryAcess.addUnAcceptPKHistory(p, s_user.toString(), user))
                            f=true;
                    }
                out.print(!f?0:1);
            }else
                out.print(-1);
        }else if(act.equals("fightByUsers")){
            String paperid = request.getParameter("paper");
            if(UserPaperAcess.checkIsExistUserPaper(s_user.toString(), paperid)) {
                String[] users = request.getParameterValues("users[]");
                boolean f = false;
                if(users!=null)
                    for (String u : users) {
                        if(PKHistoryAcess.addUnAcceptPKHistory(paperid, s_user.toString(), u))
                            f=true;
                    }
                out.print(!f?0:1);
            }else
                out.print(-1);
        }else if(act.equals("getPaperBaseInfo")){
            String paper = request.getParameter("paper");
            Paper paper1 = PaperAcess.getPaperById(paper, true);
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("maxmin", paper1.getMaxmin());
            jsonObject.put("subject", paper1.getPaper_subject());
            jsonObject.put("singleNum", paper1.getSingle_ques_num());
            jsonObject.put("multiNum", paper1.getMuti_ques_num());
            jsonObject.put("judgeNum", paper1.getJudge_ques_num());
            jsonObject.put("saNum",paper1.getSa_ques_num());
            jsonObject.put("lev", paper1.getPaper_lev()==0?"困难":paper1.getPaper_lev()==1?"适中":"简单");
            out.print(jsonObject);
        }else if(act.equals("cancelpkunaccept")){
            String papID = request.getParameter("paperID");
            String user = request.getParameter("user");
            out.print(PKHistoryAcess.cancelUnAcceptPKHistorysByPaperName(papID, s_user.toString(), user) ? 1 : -1);
        }else if(act.equals("acceptpk")){
            String papID = request.getParameter("paperID");
            String user = request.getParameter("user");
            //notify
            out.print(Transaction.accecptPk(s_user.toString(), user, papID)?1:-1);
        }else if(act.equals("disagreepk")){
            String papID = request.getParameter("paperID");
            String user = request.getParameter("user");
            //notify
            out.print(PKHistoryAcess.cancelUnAcceptPKHistorysByPaperName(papID, user, s_user.toString())?1:-1);
        }else if(act.equals("getPointChart")){
            Object ob = Transaction.getPointChart(s_user.toString());
            out.print(ob!=null?ob:-1);
        }else if(act.equals("getUnacceptNum")){
            out.print(PKHistoryAcess.getUnAcceptPKCountByName(s_user.toString()));
        }
    }
%>