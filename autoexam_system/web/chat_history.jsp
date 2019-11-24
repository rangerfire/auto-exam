<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="top.moyuyc.jdbc.HeadAcess" %>
<%@ page import="top.moyuyc.jdbc.UserAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/1/29
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
  <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
  <script src="js/header.js"></script>
  <script src="js/chat.js"></script>
  <%
    String friend = request.getParameter("name");
    int p = 1;
    if(request.getParameter("p")!=null)
      p = Integer.parseInt(request.getParameter("p"));
    Object user = session.getAttribute("username");
    if (session.getAttribute("username") == null) {
      response.sendRedirect("?reg");
      return;
    }
    if(!UserAcess.checkUserIsExistByName(friend))
      return;
    String headPath = Tools.getUserHeadPath(user.toString(), config);
  %>
  <title>与<%=friend%>的聊天记录查看</title>
  <style>
    .tab-pane{
      padding:20px 0px 20px;
    }
    [id^=chat-content]{
      padding:0px 20px 0px;
    }
    .am-icon-close {
      position: absolute;
      top: 0;
      right: 10px;
      color: #888;
      cursor: pointer;
      z-index: 100;
    }
    .edui-icon-at {
      background-image: url("umeditor/themes/default/images/email.png") ;
    }
    ul,li{list-style: none}
  </style>
</head>
<body>
<jsp:include page="template/header.jsp"></jsp:include>
<jsp:include page="template/imgModal.html"></jsp:include>

<div class="container">
  <div class="page-header">
    <h1>
      <span class="hidden-xs pull-left">
      <span class="text-info"><span class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp; </span><small>———— 好记性不如烂笔头</small>
       </span>
      <label class="text-success" style="font-family:幼圆;float: right">与 <%=friend%> 的聊天记录查看</label>
    </h1>
  </div>
</div>

<div class="container">
  <hr>
<div id="chat-content-<%=friend%>" chat-data="<%=friend%>" style="overflow-y: scroll;max-height: 800px; border-left:1px solid lightgrey;border-right:1px solid lightgrey">
  <br>
  <ul class="am-comments-list am-comments-list-flip">
    <li style="display: none;" isSelf="true" class="am-comment am-comment-primary">
      <a target="_blank" href="infoshow?name=<%=user%>">
        <img role="img-head" src="<%=headPath%>" alt="" class="am-comment-avatar img-bigger" width="48" height="48">
      </a>
      <div class="am-comment-main">
        <header class="am-comment-hd">
          <div class="am-comment-meta"><a href="infoshow?name=<%=user%>" target="_blank" role="a-name" class="am-comment-author">某人</a>
            于
            <time>2014-7-12 15:30</time>
          </div>
          <div class="am-comment-actions">
            <a onclick="$('[close='+$(this).children().attr('close-tag')+']').slideUp('normal')"  href="javascript:;">
              <i class="am-icon-close"></i></a>
          </div>
        </header>
        <div class="am-comment-bd" role="chat-content">
        </div>
      </div>
    </li>
    <li style="display: none;" isSelf="false" class="am-comment am-comment-flip"><a target="_blank" href="#link-to-user-home"><img
            role="img-head"
            alt="" class="am-comment-avatar img-bigger" width="48" height="48"></a>

      <div class="am-comment-main">
        <header class="am-comment-hd">
          <div class="am-comment-meta"><a href="#link-to-user" role="a-name" class="am-comment-author">某人</a>
            于
            <time>
            </time>
          </div>
          <div class="am-comment-actions">
            <a onclick="$('[close='+$(this).children().attr('close-tag')+']').slideUp('normal')"  href="javascript:;">
              <i class="am-icon-close"></i></a>
          </div>
        </header>
        <div class="am-comment-bd" role="chat-content"></div>
      </div>
    </li>
  </ul>
</div>
  <hr>
</div>
<div class="container">
  <nav>
    <ul class="pager">
      <%if(p>1){%>
      <li><a style="border-radius: 0" href="chat_history?name=<%=friend%>&p=<%=p-1%>" >&lt;&lt;</a></li>
      <%}%>
      <li><a style="border-radius: 0" href="javascript:;" class="active" id="cur_page"><%=p%></a></li>
      <li><a style="border-radius: 0" href="chat_history?name=<%=friend%>&p=<%=p+1%>" id="next_page">&gt;&gt;</a></li>
    </ul>
  </nav>
</div>
<jsp:include page="template/footer.jsp">
  <jsp:param name="nosocket" value=""></jsp:param>
</jsp:include>
</body>
</html>
<script>
  $(document).ready(function () {
    var addMsg = function (data) {
      if(data.for=='o2o'){
        if (data.type == 'msg')
          if (data.isSelf) addSelfMessage(data,'chat-content-'+data.to);
          else addOtherMessage(data,'chat-content-'+data.name);
      }
    }
    selectMsgDBTable('<%=user%>','<%=friend%>',<%=p%>,12, function (data) {
      if(data.length!=0)
        for(var i=0;i<data.length;i++)
          addMsg(JSON.parse(data[i].msgdata));
      else {
        var p = $('#chat-content-'+'<%=friend%>').children('ul');
        p.append('<li class="text-center"><br><h5 class="text-danger">' +
                '暂无历史记录' +
                '</h5></li>');
      }
    })
  })
</script>