<%@ page import="top.moyuyc.entity.FriendRelation" %>
<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="top.moyuyc.jdbc.FriendAcess" %>
<%@ page import="top.moyuyc.jdbc.HeadAcess" %>
<%@ page import="top.moyuyc.websocket.ChatServer" %>
<%@ page import="java.util.List" %>
<%@ page import="top.moyuyc.entity.FriendRelationWithStatus" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="top.moyuyc.jdbc.PKHistoryAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/26
  Time: 12:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public static String getFriendName(String me,FriendRelation relation){
    return relation.getUser1().equals(me)?relation.getUser2():relation.getUser1();
  }
  static boolean isOnline(String user){
    return ChatServer.connections.get(user)!=null;
  }
%>
<%
  String user = session.getAttribute("username").toString();
  boolean filter = Boolean.parseBoolean(request.getParameter("filter"));
  List<FriendRelation> list = FriendAcess.getAllFriends(user);
  JSONArray jsonArray = new JSONArray();
  if(filter) {
    String paper = request.getParameter("paper");
    for (FriendRelation fr:list){
      JSONObject json = new JSONObject();
      String name=getFriendName(user,fr);
      if(UserPaperAcess.checkIsExistUserPaper(name,paper)|| PKHistoryAcess.checkIsExistsByNamesPaper(paper,user,name))
        continue;
      String head = Tools.getUserHeadPath(name, config);
      json.put("online", isOnline(name));
      json.put("head", head);
      json.put("name", name);
      jsonArray.add(json);
    }
  }
  else
    for (FriendRelation friendRelation: list) {
      String name = getFriendName(user, friendRelation);
      String head = Tools.getUserHeadPath(name,config);
      JSONObject json = new JSONObject();
      json.put("online", isOnline(name));
      json.put("head", head);
      json.put("name", name);
      jsonArray.add(json);
    }
  out.print(jsonArray);
%>