<%@ page import="top.moyuyc.jdbc.QuesAcess" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/16
  Time: 22:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="error.jsp" %>
<%
    String username=(String)session.getAttribute("username");
    if (session.getAttribute("username") == null) {
        response.sendRedirect("?reg");
        return;
    }
    String[] oldstra = null;
    String value = Tools.findCookie("examstra",request);
    oldstra = value!=null?URLDecoder.decode(value,"utf-8").split("&"):null;
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="js/jquery-2.1.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/jquery-ui.min.css">
    <link rel="stylesheet" href="css/magicsuggest-min.css">
    <title><%if(request.getParameter("showall")!=null){%><%=request.getParameter("showall")%> 考卷详情<%}else if(request.getParameter("continue")==null){%>我要考试<%}else{%><%=request.getParameter("continue")%>继续考试<%}%> · 考友无忧</title>
    <script src="js/header.js"></script>
    <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
    <script src="js/test.js"></script>
    <script src="js/magicsuggest-min.js"></script>
</head>
<body>
<jsp:include page="template/header.jsp">
    <jsp:param name="way" value="test"></jsp:param>
</jsp:include>
<div class="container">
    <!-- Button trigger modal -->
    <div class="page-header" style="<%if(request.getParameter("showall")!=null){%>display:none;<%}%>" id="test_header">

        <h1>
            <span class="hidden-xs pull-left">
            <span class="text-info"><span class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp; </span>
            <small>———— 好记性不如烂笔头
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</small>
            </span>
            <button type="button" id="test_strategy_btn" data-backdrop="static"
                    class="btn btn-primary btn-lg" style="float: right;font-family: 幼圆"
                    data-toggle="modal" data-target="#test_stra_modal">
                我要考试
            </button>
        </h1>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="test_stra_modal" tabindex="-1" style="z-index: 10000" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-sm cover" role="form">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title text-center" id="myModalLabel">出卷策略表</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="test_stra_subject" class="col-sm-4 control-label">科目</label>

                            <div class="col-sm-8">
                                <select id="test_stra_subject" class="form-control">
                                    <%List<String> subs = QuesAcess.getAllSubs();%>
                                    <%  if (subs != null) {
                                            Collections.sort(subs);
                                            for (int i = 0; i < subs.size(); i++) {
                                                if (oldstra==null){
                                                    if(i == 0) {%>
                                    <option selected><%=subs.get(i)%></option>
                                    <%} else {%>
                                    <option><%=subs.get(i)%></option>
                                    <%}} else{
                                        if(subs.get(i).equals(oldstra[1])) {%>
                                    <option selected><%=subs.get(i)%></option>
                                    <%} else {%>
                                    <option><%=subs.get(i)%></option>
                                    <%}
                                    }}}%>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="test_stra_singlenum" class="col-sm-4 control-label">单选数目</label>

                            <div class="col-sm-8">
                                <select id="test_stra_singlenum" class="form-control">
                                    <%int[] a1 = new int[]{0,5,10,15,20,30};
                                        int o1 = oldstra!=null?Integer.parseInt(oldstra[2]):5;
                                        for(int i : a1){
                                            if(o1==i)
                                                out.print("<option selected>"+i+"</option>");
                                            else
                                                out.print("<option>"+i+"</option>");
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="test_stra_mutinum" class="col-sm-4 control-label">多选数目</label>

                            <div class="col-sm-8">
                                <select id="test_stra_mutinum" class="form-control">
                                    <%  a1 = new int[]{0,5,10,15,20,30};
                                        o1 = oldstra!=null?Integer.parseInt(oldstra[3]):5;
                                        for(int i : a1){
                                            if(o1==i)
                                                out.print("<option selected>"+i+"</option>");
                                            else
                                                out.print("<option>"+i+"</option>");
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="test_stra_judgenum" class="col-sm-4 control-label">判断数目</label>

                            <div class="col-sm-8">
                                <select id="test_stra_judgenum" class="form-control">
                                    <%  a1 = new int[]{0,5,10,15,20,30};
                                        o1 = oldstra!=null?Integer.parseInt(oldstra[4]):5;
                                        for(int i : a1){
                                            if(o1==i)
                                                out.print("<option selected>"+i+"</option>");
                                            else
                                                out.print("<option>"+i+"</option>");
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="test_stra_sanum" class="col-sm-4 control-label">简答数目</label>

                            <div class="col-sm-8">
                                <select id="test_stra_sanum" class="form-control">
                                    <%  a1 = new int[]{0,1,2,4,6,10,20};
                                        o1 = oldstra!=null?Integer.parseInt(oldstra[5]):2;
                                        for(int i : a1){
                                            if(o1==i)
                                                out.print("<option selected>"+i+"</option>");
                                            else
                                                out.print("<option>"+i+"</option>");
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="test_stra_lev" class="col-sm-4 control-label">试卷难度</label>

                            <div class="col-sm-8">
                                <select id="test_stra_lev" class="form-control">
                                    <%  o1 = oldstra!=null?Integer.parseInt(oldstra[7]):2;
                                        switch (o1){
                                            case 0:%>
                                    <option value="2">简单</option>
                                    <option value="1">适中</option>
                                    <option value="0" selected>困难</option>
                                    <%
                                                break;
                                            case 1:
                                    %>
                                    <option value="2">简单</option>
                                    <option value="1" selected>适中</option>
                                    <option value="0">困难</option>
                                    <%
                                                break;
                                            case 2:
                                    %>
                                    <option value="2" selected>简单</option>
                                    <option value="1">适中</option>
                                    <option value="0">困难</option>
                                    <%
                                                break;
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="test_stra_maxmin" class="col-sm-4 control-label">时间(分钟)</label>

                            <div class="col-sm-8">
                                <select id="test_stra_maxmin" class="form-control">
                                    <%  a1 = new int[]{10,25,40,60,80,100,120,200};
                                        o1 = oldstra!=null?Integer.parseInt(oldstra[6]):10;
                                        for(int i : a1){
                                            if(o1==i)
                                                out.print("<option selected>"+i+"</option>");
                                            else
                                                out.print("<option>"+i+"</option>");
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" id="autotest_btn" class="btn btn-primary btn-block">开始考试</button>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <hr>
    <div class="alert alert-danger text-center" id="text_alert" role="alert" style="display: none">
        <button type="button" id="testalert_close" class="close" aria-label="Close"><span
                aria-hidden="true">&times;</span></button>
        <strong><big>您已经正在考试中！！！</big></strong></div>
</div>
<jsp:include page="template/testcontent.jsp"></jsp:include>
<jsp:include page="template/footer.jsp"></jsp:include>
<jsp:include page="template/toTop.html"></jsp:include>
</body>
</html>
<%if(request.getParameter("continue")!=null){%>
<script>
    continue_test("<%=request.getParameter("continue")%>")
</script>
<%}else if(request.getParameter("showall")!=null){%>
<script src="js/echarts-all-3.js"></script>
<script>
    paperShow("<%=request.getParameter("showall")%>",true)
</script>
<%}%>
