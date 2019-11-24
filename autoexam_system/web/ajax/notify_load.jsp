
<%@ page import="top.moyuyc.websocket.ChatServer" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Set" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/12/19
  Time: 22:30
  To change this template use File | Settings | File Templates.
--%>

<%
  String[] str_adds = request.getParameterValues("add[]");
  String[] str_ignores = request.getParameterValues("ignore[]");
  String msgFrom = request.getParameter("msgFrom");
  List<JSONObject> l = ChatServer.remain_msgs.get(session.getAttribute("username").toString());
  Set<String> pass_set = ChatServer.pass_rev_sender.get(session.getAttribute("username").toString());
  Map<String,Integer> name_times = new HashMap<String,Integer>();
  if(l!=null)
    for (JSONObject jsonObject:l){
      if(!name_times.containsKey(jsonObject.get("name")))
        name_times.put(jsonObject.get("name").toString(),1);
      else
        name_times.put(jsonObject.get("name").toString(),name_times.get(jsonObject.get("name"))+1);
    }
//  String  v = request.getParameter("v");
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="position:fixed;bottom:0px; right: 0px; z-index: 99999">
  <%--<div id="info">1</div>--%>
  <div class="alert alert-info alert-dismissible fade in" style="margin-bottom: 0px;padding-bottom:0px" role="alert">
    <button id="notify-close" type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
    <%if(str_adds!=null){%>
    <div id="query-add">
    <h4 id="query-add"><i class="am-icon-user-plus"></i>好友申请   <label class="label label-info"><%=str_adds.length%>个好友申请</label></h4>
    <%int index = 0;for(String str:str_adds){%>
    <div id="query-inner<%=index%>">
    <p>用户 <a target="_blank" href="infoshow?name=<%=str%>" ><%=str%></a> 请求添加您为好友 :)</p>
    <p>
      <button type="button" href="#query-inner<%=index%>" class="btn btn-success" query-type="agree" query-data="<%=str%>">允许</button>
      <button type="button" href="#query-inner<%=index%>" class="btn btn-danger" query-type="refuse" query-data="<%=str%>">残忍拒绝</button>
    </p>
    <hr>
    </div>
    <%index++; }%>
    <%if(str_adds.length>5){%>
    <p>
      <button type="button" class="btn btn-success" href="#query-add" query-type="agreeAll">全部允许</button>
      <button type="button" class="btn btn-danger" href="#query-add" query-type="refuseAll">全部拒绝</button>
    </p>
    <hr>
    <%}%>
    </div>
    <%}%>

    <div id="query-ignore">
    <%if(str_ignores!=null){%>
    <h4>好友申请被拒绝</h4>
    <%for(String str:str_ignores){%>
    <p> <%=str%> 拒绝添加您为好友 :(</p>
    <%}
    }%>
    <%if(pass_set!=null&&!pass_set.isEmpty()){%>
      <h4>好友申请已通过</h4>
      <%for(String str:pass_set){%>
      <p> <%=str%> 同意添加您为好友 :)</p>
      <%}%>
    <%}%>
      <%if(str_ignores!=null||pass_set!=null&&!pass_set.isEmpty()){%>
      <p>
        <button type="button" href="#query-ignore" class="btn btn-primary" query-type="ignore_passAll">知道了</button>
      </p>
      <hr>
      <%}%>
    </div>

    <%if(!name_times.isEmpty()||msgFrom!=null){%>
    <div id="query-remainMsg">
      <h4>新的好友消息</h4>
      <%int index=0;
        for(String str:name_times.keySet()){%>
      <div id="query-remainMsg-<%=index%>">
      <p>来自 <a data-name="<%=str%>" href="friend?o2ochat=<%=str%>" target="_blank">
        <img class="img-bigger" src="<%=Tools.getUserHeadPath(str,config)%>" style="width: 24;height: 24;border-radius: 50%;"> <%=str%> </a>的<%=name_times.get(str)%>条消息</p>
      </div>
      <%index++;
      }%>
      <%if(msgFrom!=null){%>
        <p>收到 <a data-name="<%=msgFrom%>" href="friend?o2ochat=<%=msgFrom%>" target="_blank">
          <img class="img-bigger" src="<%=Tools.getUserHeadPath(msgFrom,config)%>" style="width: 24;height: 24;border-radius: 50%;"> <%=msgFrom%> </a>的消息</p>
      <%}%>
    </div>
    <%}%>

  </div>

</div>
<script>
  $('#query-remainMsg a').click(function () {
    if(axTag=='chat'){
      $('#tab-frlist a').click();
      var s= $(this).attr('data-name');
      if($('[tab-tag='+s+']').length==0){
        addTab('与'+s+'聊天...',{friend:s,random:parseInt(Math.random()*1000000)},s,'o2oChat-'+s);
      }else{$('[tab-tag='+s+']').click();}
      $('#notify-close').click();
      return false;
    }
    $('#notify-close').click();
  });
  
  
  $("button[query-type]").click(function () {
    var _this = $(this);
    clearTimeout(t);
    var t = setTimeout(function () {
      $('#notify-container').empty();
      ws.send(JSON.stringify({
        action:'refreshNotify',
        type:_this.attr('query-type'),
        data:_this.attr('query-data')
      }))
    },0);
//      $(_this.attr('href')).remove();
//      if(($('[id^=query-inner]').length==0 || $('#query-add').length==0) && $('#query-ignore').length==0)
//        $('#notify-close').click();
  })
</script>
<%
  ChatServer.remain_msgs.remove(session.getAttribute("username").toString());
%>