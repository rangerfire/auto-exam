<%@ page import="top.moyuyc.transaction.Transaction" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/1/27
  Time: 10:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Object user = session.getAttribute("username");
  if(user==null)  return;
  out.print(Transaction.userAddFriendQuery(user.toString(),request.getParameter("name")));
%>
