<%@ page import="top.moyuyc.jdbc.FriendAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/9
  Time: 12:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Object me = session.getAttribute("username");
  if(me==null) return;
  String other = request.getParameter("name").toString();
  if(me.equals(other)){
    out.print(0);
    return;
  }
  if(!FriendAcess.checkFriendIsExists(me.toString(),other)){
    out.print(-1);
    return;
  }
  out.print(1);
%>