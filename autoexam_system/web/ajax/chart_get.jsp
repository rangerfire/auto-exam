<%@ page import="top.moyuyc.transaction.Transaction" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/23
  Time: 22:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(session.getAttribute("username")==null)
    return;
  out.print(Transaction.getChartData(session.getAttribute("username").toString()));
%>

