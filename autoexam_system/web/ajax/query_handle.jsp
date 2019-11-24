<%@ page import="top.moyuyc.transaction.Transaction" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/1/27
  Time: 20:51
  To change this template use File | Settings | File Templates.
--%>
<%
  if(session.getAttribute("username")==null) return;
  String user = session.getAttribute("username").toString();
  String type = request.getParameter("type");
  String data = request.getParameter("data");
  if(type.equals("agree")){
    Transaction.userAgreeAddFriendQuery(user,data);
  }else if(type.equals("agreeAll")){
    Transaction.userAgreeAllAddFriendQuery(user);
  }else if(type.equals("refuse")){
    Transaction.userRefuseAddFriendQuery(user, data);
  }else if(type.equals("refuseAll")){
    Transaction.userRefuseAllAddFriendQuery(user);
  }else if(type.equals("ignoreAll")){
    Transaction.userHandleAllIgnoreQuery(user);
  }
%>