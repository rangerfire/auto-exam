<%@ page import="top.moyuyc.jdbc.PointAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/27
  Time: 11:04
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
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="js/jquery-2.1.1.min.js"></script>
  <link rel="stylesheet" href="css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
  <script src="js/jquery.websocket.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/header.js"></script>
  <link href="css/app.css" type="text/css" rel="stylesheet">
    <title>Top 风云榜 · 考友无忧</title>
  <style>
    .tigger{transform:rotate(-90deg)}
  </style>
</head>
<body>
<jsp:include page="template/header.jsp"></jsp:include>
<div class="container">
  <div class="page-header">
    <h1>
      <span class="hidden-xs pull-left">
      <span class="text-success"><%=session.getAttribute("username")%></span>，欢迎您来到 <span class="text-info"><span
            class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp;</span>
      <small>———— 好记性不如烂笔头</small>
      </span>
      <label class="text-success" style="font-family:幼圆;float: right">TOP风云榜</label>
    </h1>
  </div>
</div>

<div class="container">
  <hr>
  <p>
    我的积分: <span class="text-primary"><%=PointAcess.getPointByName(session.getAttribute("username").toString())%></span>
  </p>
  <p>
    我的好友排名: <span class="text-danger"><%=1+PointAcess.getBeforeCountFriendByName(session.getAttribute("username").toString())%></span>
  </p>
  <p>
    我的世界排名: <span class="text-danger"><%=1+PointAcess.getBeforeCountAllByName(session.getAttribute("username").toString())%></span>
  </p>
  <div class="row">
    <div class="col-sm-6">
      <section class="panel panel-default portlet-item pos-rlt clearfix">
        <header class="panel-heading">
            <span class="glyphicon glyphicon-menu-down" style="transition:all 0.3s ease-in;cursor: pointer"
                  onclick="$(this).toggleClass('tigger').parent().next().slideToggle('normal');"></span> 好友排行榜 <span class="badge pull-right">积分榜</span>
        </header>
        <div>
          <div class="panel-body">
            <jsp:include page="ajax/get_toplist.jsp">
              <jsp:param name="top" value="friend"></jsp:param>
            </jsp:include>
          </div>
          <div class="panel-footer">
            <div data-target="friend" class="alert alert-info alert-dismissible fade in text-center" style="display: none;" role="alert">
              <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
              <strong></strong>
            </div>
            <div class="text-right">
              <a class="btn-link small" data="1" role="more" tag="friend" href="javascript:;">更多...</a>
            </div>
          </div>
        </div>
      </section>

    </div>

    <div class="col-sm-6">
      <section class="panel panel-default portlet-item pos-rlt clearfix">
        <header class="panel-heading">
            <span class="glyphicon glyphicon-menu-down" style="transition:all 0.3s ease-in;cursor: pointer"
                  onclick="$(this).toggleClass('tigger').parent().next().slideToggle('normal');"></span> 用户排行榜 <span class="badge pull-right">积分榜</span>
        </header>
        <div>
          <div class="panel-body">
            <jsp:include page="ajax/get_toplist.jsp">
              <jsp:param name="top" value="all"></jsp:param>
            </jsp:include>
          </div>
          <div class="panel-footer">
            <div data-target="all" class="alert alert-info alert-dismissible fade in text-center" style="display: none;" role="alert">
              <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
              <strong></strong>
            </div>
            <div class="text-right">
            <a class="btn-link small" data="1" role="more" tag="all" href="javascript:;">更多...</a>
            </div>
          </div>
        </div>
      </section>

    </div>
  </div>
</div>
<jsp:include page="template/footer.jsp"></jsp:include>
</body>
<script>
  var loadDiv='<div class="text-center" style=""><a href="javascript:;">' +
          '<img width="48" height="48" id="loading" src="images/loading.gif">' +
          '</a></div>';
  $('[role=more]').click(function () {
    var tag = $(this).attr('tag'),suparent = $(this).parent().parent();
    var _t = $(this).hide();
    suparent.append(loadDiv);
    $.ajax({method:'GET',url:'ajax/get_toplist.jsp',data:{top:tag,index:parseInt(_t.attr('data'))+1}}).done(function (html) {
      setTimeout(function () {
        _t.show();
        suparent.children(':last').remove();
        if(html==-1){
          $('[data-target='+tag+']').show().find('strong').text('已无更多信息 :(');
        }else {
          _t.attr('data',parseInt(_t.attr('data'))+1);
          suparent.prev().append(html);
        }
      },500);
    })
  })
</script>
</html>
