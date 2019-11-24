<%@ page import="top.moyuyc.jdbc.UserAcess" %>
<%@ page import="top.moyuyc.transaction.Transaction" %>
<%@ page import="top.moyuyc.entity.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.jdbc.QuesAcess" %>
<%@ page import="top.moyuyc.entity.Ques" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/26
  Time: 20:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(session.getAttribute("admin")==null)
    return;
  String act=request.getParameter("act");
  if(act.equals("add-user")){
    String username=request.getParameter("username");
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    if(UserAcess.checkUserIsExistByName(username)||UserAcess.checkUserIsExistByEmail(email)){
      out.print(-1);
      return;
    }else {
      UserAcess.addUser(username,password,email);
      out.print(1);
      return;
    }
  }else if(act.equals("addQuestion")){
    String subject=request.getParameter("subject");
    String type=request.getParameter("type");
    int score=Integer.parseInt(request.getParameter("score"));
    String content=request.getParameter("content");
    String answer=request.getParameter("answer");
    String analy=request.getParameter("analy");
    int lev=Integer.parseInt(request.getParameter("lev"));
    Transaction.adminAddQues(subject,type,score,content,answer==""?null:answer,analy==""?null:analy,lev);
    out.print(1);
  }else if(act.equals("getUserByName")){
    String username=request.getParameter("username");
    User u=UserAcess.getUserByName(username);
    if(u==null){
      out.print(-1);
      return;
    }else{
      Map<String,String> map=new HashMap<String,String>();
      map.put("pre",username);
      map.put("username",u.getUser_name());
      map.put("email",u.getUser_email());
      map.put("password",u.getUser_pwd());
      map.put("createtime",u.getCreate_time());
      out.print(JSONObject.fromObject(map));
    }
  }else if(act.equals("getUserByEmail")){
    String email=request.getParameter("email");
    User u=UserAcess.getUserByEmail(email);
    if(u==null){
      out.print(-1);
      return;
    }else{
      Map<String,String> map=new HashMap<String,String>();
      map.put("pre",email);
      map.put("username",u.getUser_name());
      map.put("email",u.getUser_email());
      map.put("password",u.getUser_pwd());
      map.put("createtime",u.getCreate_time());
      out.print(JSONObject.fromObject(map));
    }
  }else if(act.equals("changeUserByName")){
    String pre=request.getParameter("pre");
    String username=request.getParameter("username");
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    if(!Transaction.adminUpdateUserByName(pre,username,password,email))
      out.print(-1);
    else
      out.print(1);
  }else if(act.equals("changeUserByEmail")){
    String pre=request.getParameter("pre");
    String username=request.getParameter("username");
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    if(!UserAcess.updateUserByEmail(pre,username,email,password))
      out.print(-1);
    else
      out.print(1);
  }else if(act.equals("getQuesById")){
    String quesno=request.getParameter("quesno");
    Ques q=QuesAcess.getQuesById(quesno);
    if(q==null){
      out.print(-1);
    }else {
      out.print(JSONObject.fromObject(q));
    }
  }else if(act.equals("changeQuestion")){
    String quesno=request.getParameter("id");
    String type= request.getParameter("type");
    int score= Integer.parseInt(request.getParameter("score"));
    String content= request.getParameter("content");
    String answer= request.getParameter("answer");
    String analy= request.getParameter("analy");
    int lev= Integer.parseInt(request.getParameter("lev"));
    if(QuesAcess.updateQuesById(quesno,type,score,content,answer==""?null:answer,analy==""?null:analy,lev))
      out.print(1);
    else
      out.print(-1);
  }else if(act.equals("delUserByName")){
    String user = request.getParameter("user");
    if(!Transaction.adminDelUserByName(user))
      out.print(-1);
    else
      out.print(1);
  }else if(act.equals("delUserByEmail")){
    String email = request.getParameter("email");
    if(!Transaction.adminDelUserByEmail(email))
      out.print(-1);
    else
      out.print(1);
  }else if(act.equals("delQues")){
    String id = request.getParameter("id");
    if(!Transaction.adminDelQues(id))
      out.print(-1);
    else
      out.print(1);
  }else if(act.equals("delPaper")){
    String id = request.getParameter("id");
    if(!Transaction.adminDelPaper(id))
      out.print(-1);
    else
      out.print(1);
  }else if(act.equals("delUserTest")){
    String user = request.getParameter("user");
    String paper = request.getParameter("paper");
    if(!Transaction.adminDelUserPaper(user,paper))
      out.print(-1);
    else
      out.print(1);
  }
%>
