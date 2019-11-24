<%@ page import="top.moyuyc.jdbc.FriendAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/25
  Time: 19:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String user = session.getAttribute("username").toString();
  String fr = request.getParameter("name");
  out.print(FriendAcess.delFriend(user,fr)?1:-1);
%>
