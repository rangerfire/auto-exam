<%@ page import="top.moyuyc.jdbc.HeadAcess" %>
<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="top.moyuyc.jdbc.FriendAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/1/28
  Time: 12:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String headPath = Tools.getUserHeadPath(session.getAttribute("username").toString(),config);
  String user = session.getAttribute("username").toString();
  String friend = request.getParameter("friend");
  String random = request.getParameter("random");

%>
  <div id="chat-content-<%=friend%>" chat-data="<%=friend%>" style="overflow-y: scroll;max-height: 800px; border-left:1px solid lightgrey;border-right:1px solid lightgrey">
    <br>
    <%
      if(!FriendAcess.checkFriendIsExists(user,friend)||friend==null){
        out.print("<h4 class='text-center text-danger'>不存在该好友 :(</h4><hr>");
        return;
      }%>
    <div class="text-center"><h5>与 <%=friend%> 聊天中...</h5>
    </div>
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
            <div class="am-comment-meta"><a href="#link-to-user" role="a-name" target="_blank" class="am-comment-author">某人</a>
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

  <br>
  <div class="modal-footer" >
    <div id="chat-foot-<%=friend%>" class="text-left">
      <script type="text/plain" style="height:20%;width:100%" id="myEditor-<%=random%>" class="btn-block"></script>
      <button id="send-<%=friend%>" role="sendMsg"
              class="btn btn-success pull-right visible-xs visible-sm">发送
      </button>

    </div>
  </div>
  <hr>

<script>
  (function () {
    var mesnum=0;
    var um = UM.getEditor("myEditor-<%=random%>", {
      allowDivTransToP: false,
      initialContent: '输入后 Ctrl+Enter 发送',
      autoHeightEnabled: true,
      autoFloatEnabled: true,
      focus:true,
      enterTag:'br',
      initialFrameWidth:'100%'
    });
    var chat = $('#myEditor-<%=random%>');
    chat.keydown(function (event) {
      if (event.keyCode == 13 && event.ctrlKey) {
        sendMessage(um,chat,{to:'<%=friend%>'});
      }
    })
    $('#send-<%=friend%>').click(function () {
      sendMessage(um,chat,{to:'<%=friend%>'});
    });
    $('#chat-foot-<%=friend%>').get(0).oncopy= function (e) {
      e.stopPropagation();
      return true;
    }
    ws.receiveHandle = function (data) {
      if(data.for=='o2o'){
        if (data.type == 'msg')
          if (data.isSelf) addSelfMessage(data,'chat-content-'+data.to);
          else addOtherMessage(data,'chat-content-'+data.name);
      }
    }
    $(window).resize();
  }())

</script>