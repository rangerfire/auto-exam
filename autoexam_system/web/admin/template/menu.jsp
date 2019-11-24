<%@ page import="top.moyuyc.entity.Ques" %>
<%@ page import="top.moyuyc.jdbc.QuesAcess" %>
<%@ page import="top.moyuyc.jdbc.UserAcess" %>
<%@ page import="top.moyuyc.jdbc.PaperAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/25
  Time: 17:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  li{
    margin-top: 2px;
  }
</style>
<div class="col-sm-3 col-md-2 sidebar">
  <ul class="nav nav-sidebar">
    <li><a id="root-all" data-tag="all" href="javascript:;">总览 <span class="sr-only">(current)</span></a></li>
    <li><a style="display: none" id="all-0" href="index.jsp?root=all&i=0">题库总览 <span name="num" class="badge"><%=QuesAcess.getQuesCount()%></span></a></li>
    <li><a style="display: none" id="all-1" href="index.jsp?root=all&i=1">用户总览 <span name="num" class="badge"><%=UserAcess.getUserCount()%></span></a></li>
    <li><a style="display: none" id="all-2" href="index.jsp?root=all&i=2">试卷总览 <span name="num" class="badge"><%=PaperAcess.getPaperCount()%></span></a></li>
  </ul>
  <ul class="nav nav-sidebar">
    <li><a id="root-add" data-tag="add" href="javascript:;">添加</a></li>
    <li><a style="display: none" id="add-0" href="add.jsp?root=add&i=0">用户添加</a></li>
    <li><a style="display: none" id="add-1" href="add.jsp?root=add&i=1">题库添加</a></li>
  </ul>
  <ul class="nav nav-sidebar">
    <li><a id="root-cha" data-tag="cha" href="javascript:;">修改</a></li>
    <li><a style="display: none" id="cha-0" href="cha.jsp?root=cha&i=0">用户修改</a></li>
    <li><a style="display: none" id="cha-1" href="cha.jsp?root=cha&i=1">题库修改</a></li>
  </ul>
  <ul class="nav nav-sidebar">
    <li><a id="root-del" data-tag="del" href="javascript:;">删除*</a></li>
    <li><a style="display: none" id="del-0" href="del.jsp?root=del&i=0">用户删除</a></li>
    <li><a style="display: none" id="del-1" href="del.jsp?root=del&i=1">题库删除</a></li>
    <li><a style="display: none" id="del-2" href="del.jsp?root=del&i=2">考卷删除</a></li>
    <li><a style="display: none" id="del-3" href="del.jsp?root=del&i=3">考试记录删除</a></li>
  </ul>
</div>
<script>
  $("#root-<%=request.getParameter("root")%>").parent().addClass("active").nextAll().children().show();
  $("#<%=request.getParameter("root")%>-<%=request.getParameter("i")==null?0:request.getParameter("i")%>").parent().addClass("active");
  var curExpend=$("#root-<%=request.getParameter("root")%>");
</script>