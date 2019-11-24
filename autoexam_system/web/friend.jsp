<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/12/15
  Time: 14:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("username")==null) {
        response.sendRedirect("index?reg");
        return;
    }

%>
<html>
<head lang="zh">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="js/jquery-2.1.1.min.js"></script>
    <link rel="stylesheet" href="assets/css/amazeui.min.css">
    <link rel="stylesheet" href="assets/css/app.css">
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/jquery.websocket.js"></script>
    <script src="umeditor/umeditor.config.js"></script>
    <script src="umeditor/umeditor.js"></script>
    <script src="assets/js/amazeui.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/header.js"></script>
    <script src="umeditor/lang/zh-cn/zh-cn.js"></script>
    <script src="js/mobilePC.js"></script>
    <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
    <link href="umeditor/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
    <link href="css/app.css" type="text/css" rel="stylesheet">
    <%--<link href="css/icon.css" type="text/css" rel="stylesheet">--%>
    <title><%=session.getAttribute("username")%>的好友中心 · 考友无忧</title>
</head>
<body>
<jsp:include page="template/header.jsp">
  <jsp:param name="way" value="friend"></jsp:param>
</jsp:include>
<div class="container">
    <div class="page-header">
        <h1>
            <span class="hidden-xs pull-left">
            <span class="text-success"><%=session.getAttribute("username")%></span>，欢迎您来到 <span class="text-info"><span
                class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp;</span>
            <small>———— 好记性不如烂笔头</small>
            </span>
            <label class="text-success" style="font-family:幼圆;float: right">好友中心</label>
        </h1>
    </div>
</div>

<script>
  window.axUser="<%=session.getAttribute("username")%>";
  window.axTag="chat";
</script>
<jsp:include page="chat.jsp"></jsp:include>

<jsp:include page="template/footer.jsp"></jsp:include>
</body>
</html>
