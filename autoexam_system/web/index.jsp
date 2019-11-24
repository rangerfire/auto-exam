<%@ page import="java.net.URLDecoder" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/15
  Time: 20:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%
    String oldn = Tools.findCookie("USER_NAME", request);
    oldn=oldn!=null?URLDecoder.decode(oldn,"utf-8"):null;
    String oldp = Tools.findCookie("USER_PWD", request);
    oldp=oldp!=null? URLDecoder.decode(oldp, "utf-8"):null;
    if(oldn==null || oldp==null)
        oldn=oldp=null;
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="js/jquery-2.1.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/jquery-ui.min.css">
    <title>首页 · 考友无忧</title>
    <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
    <script src="js/header.js"></script>
    <script src="js/index.js"></script>
    <style>

        .height{
            height: 140px;
        }
    </style>
</head>
<body>
<%if(session.getAttribute("username")!=null){%>
<script>
    window.axUser = '<%=session.getAttribute("username")%>';
</script>
<%}%>
<jsp:include page="template/header.jsp">
    <jsp:param name="way" value="index"></jsp:param>
</jsp:include>
<div class="container">
    <div class="page-header">
        <h1>
            <span class="hidden-xs pull-left">
            欢迎来到 <span class="text-info"><span class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp; </span>
            <small>———— 好记性不如烂笔头</small>
            </span>
            <label class="text-success" style="font-family:幼圆;float: right">首页</label>
        </h1>
    </div>
</div>
<!--Pic slider-->
<div class="container">
    <hr>
    <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
            <li data-target="#carousel-example-generic" data-slide-to="1"></li>
            <li data-target="#carousel-example-generic" data-slide-to="2"></li>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner" role="listbox">
            <div class="item active">
                <img src="images/3.jpg" alt="pic1">
                <div class="carousel-caption">
                    ...
                </div>
            </div>
            <div class="item">
                <img src="images/2.jpg" alt="pic2">
                <div class="carousel-caption">
                    ...
                </div>
            </div>
            <div class="item">
                <img src="images/5.jpg" alt="pic3">
                <div class="carousel-caption">
                    ...
                </div>
            </div>
            <div class="item">
                <img src="images/4.jpg" alt="pic4">
                <div class="carousel-caption">
                    ...
                </div>
            </div>
        </div>

        <!-- Controls -->
        <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>
    <hr>
</div>

<div class="container">
    <div class="row">

        <div class="col-sm-6 col-md-3">
            <div href="#" class="thumbnail">
                <img style="height: 140px;" src="images/result.png"
                     alt="通用的占位符缩略图">
                <div class="caption">
                    <h3>反馈直观</h3>
                    <p class="text-right">
                        <a class="btn btn-primary" role="button" data-toggle="collapse" href=".sd" aria-expanded="false">
                            查看详情 »
                        </a>
                    </p>
                    <div class="collapse sd" id="collapseExample1">
                        <p>
                            在线考试后能够提供给用户及时的反馈信息，并且可视化出来，具有良好的用户体验，以便用户后续提高。
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div href="#" class="thumbnail">
                <img style="height: 140px;" src="images/friend_online.png"
                     alt="通用的占位符缩略图">
                <div class="caption">
                    <h3>考友在线</h3>
                    <p class="text-right">
                        <a class="btn btn-primary" role="button" data-toggle="collapse" href="#collapseExample2" aria-expanded="false" >
                            查看详情 »
                        </a>
                    </p>
                    <div class="collapse" id="collapseExample2">
                        <p>
                            拥有独立的好友系统以及聊天系统，方便您在学习提高的同时结识益友。
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div href="#" class="thumbnail">
                <img style="height: 140px;" src="images/pk.png"
                     alt="通用的占位符缩略图">
                <div class="caption">
                    <h3>好友对战</h3>
                    <p class="text-right">
                        <a class="btn btn-primary" role="button" data-toggle="collapse" href="#collapseExample0" aria-expanded="false">
                            查看详情 »
                        </a>
                    </p>
                    <div class="collapse" id="collapseExample0">
                        <p>
                            支持好友PK对战，添加积分系统，在学习过程中更加有趣味。
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div href="#" class="thumbnail">
                <img style="height: 140px;" src="images/ui.png"
                     alt="通用的占位符缩略图">
                <div class="caption">
                    <h3>界面美观</h3>
                    <p class="text-right">
                        <a class="btn btn-primary" role="button" data-toggle="collapse" href="#collapseExample3" aria-expanded="false" aria-controls="collapseExample">
                            查看详情 »
                        </a>
                    </p>
                    <div class="collapse" id="collapseExample3">
                        <p>
                            界面美观，具有良好的交互性能，提供用户优质的使用体验。
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <hr>
</div>


<jsp:include page="template/footer.jsp"></jsp:include>

</body>
</html>
<%if(request.getParameter("reg")!=null){%>
<script>
    $("#reg_btn").click()
</script>
<%}%>
<%if(session.getAttribute("username")==null){%>
<script>
    setTimeout(function () {
        $('#pwd_input').prop('type','password').val('<%=oldp==null?"":oldp%>')
        $('#username_input').val('<%=oldn==null?"":oldn%>')
        $('#inputrember').prop('checked',<%=oldn!=null%>)
    },1)
</script>
<%}%>