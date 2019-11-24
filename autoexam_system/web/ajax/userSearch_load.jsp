<%@ page import="top.moyuyc.transaction.Transaction" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.entity.FriendRelation" %>
<%@ page import="java.util.List" %>
<%@ page import="top.moyuyc.jdbc.FriendAcess" %>
<%@ page import="top.moyuyc.jdbc.UserAcess" %>
<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="top.moyuyc.jdbc.HeadAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/12/19
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Object me = session.getAttribute("username");
  if(me==null){
    out.print("<h4>请登录后再操作！</h4>");
    return;
  }
  String user = request.getParameter("name");
  int p = Integer.parseInt(request.getParameter("p"));
  int ps = Integer.parseInt(request.getParameter("pagesize"));
  JSONArray array = new JSONArray();
  int num = 0;
  if(user!=null&&!user.isEmpty()) {
    array = Transaction.userSearchUsers(me.toString(),user,p,ps);
    num = UserAcess.getUserNumByLikeName(me.toString(),user);
  }
%>
<div id="user-search-rlt">
  <div id="tip" class="alert alert-info alert-dismissible fade in text-center" style="display:none" role="alert">
    <button type="button" class="close" aria-label="Close" onclick="$(this).parent().hide('normal')"><span aria-hidden="true">×</span></button>
    <strong></strong>
  </div>
  <%if(array.isEmpty()){%><div class="text-center"><h4 class="text-danger">未找到符合要求的用户 :(</h4></div><%}
  else{%>
  <div class="table-responsive">
  <table class="table table-striped">
    <caption>搜索 <%=user%>，一共搜索到 <%=num%> 条记录，当前显示 <%=array.size()%> 条记录</caption>
    <thead style="font-size: 14px">
    <tr>
      <th>#</th>
      <th>用户</th>
      <th>添加好友</th>
      <th>查看资料</th>
    </tr>
    </thead>
    <tbody>
    <% int j = 1;
      for(int i =0;i<array.size();i++){
        JSONObject object = (JSONObject) array.get(i);
        String na = object.get("name").toString();
        String headPath = Tools.getUserHeadPath(na,config);
        boolean isf = FriendAcess.checkFriendIsExists(na,me.toString());
    %>
    <tr <%if(isf){%>class="warning" <%}%>>
      <th scope="row"><%=j++%></th>
      <td><img src="<%=headPath%>" class="img-bigger" style="width: 32;height: 32; border-radius: 50%;"><%=na%></td>
      <td><%if(isf){%>
        已经为您的好友
        <%}else if(Transaction.isExistsAddFriendQuery(me.toString(),na)){%>
        您的请求正在申请中...
        <%}else if(Transaction.isExistsAddFriendAccept(me.toString(),na)){%>
        该用户已经申请您为好友...
        <%}else{%>
        <button role="button-add-friend" data-name="<%=na%>" class="btn btn-success"><i class="am-icon-user-plus"></i> 申请添加</button>
        <%}%></td>
      <td><a href="infoshow?name=<%=na%>" target="_blank" class="btn btn-primary">查看资料</a></td>
    </tr>
    <%}%>
    </tbody>

  </table>
  </div>
  <hr>
  <nav>
    <ul class="pager">
      <li><a style="border-radius: 0" href="javascript:;" onclick="var cur=Number($('#cur_page0').text());
      if(cur==1){return;}$('#cur_page0').text(cur-1);addTab('用户搜索',{name:'<%=user%>',p:cur-1,pagesize:<%=ps%>},'userSearch')" >&lt;&lt;</a></li>
      <li><a style="border-radius: 0" href="javascript:;" class="active" id="cur_page0"><%=p%></a></li>
      <li><a style="border-radius: 0" href="javascript:;" onclick="var cur=Number($('#cur_page0').text());if(<%=num%>><%=p%>*<%=ps%>){$('#cur_page0').text(cur+1);addTab('用户搜索',{name:'<%=user%>',p:cur+1,pagesize:<%=ps%>},'userSearch');}" >&gt;&gt;</a></li>
    </ul>
  </nav>
  <%}%>
</div>
<script>
  $('[role=button-add-friend]').click(function () {
    var value = $(this).attr('data-name');
    var _this = $(this);
    $.ajax({
      method:'POST',
      url:'ajax/add_friend_post.jsp',
      data:{
        name:value
      }
    }).fail(function () {
      $.moyuAlert('服务器出错')
    }).done(function (d) {
      var t = $('#tip');
      var tip = t.find('strong');
      if(d==-2){
        tip.text(value+" 已经是您的好友了 ")
        t.show('normal');
      }
      else if(d==-1){
        //name not exists
        tip.text(value+" 不存在 :(")
        t.show('normal');
      }else if(d==0){
        //already query
        tip.text("您已经申请，请等待对方验证 :(")
        t.show('normal');
      }else{
        //success
        tip.text("成功申请！ :)")
        t.show('normal');
      }
    })
  })
</script>