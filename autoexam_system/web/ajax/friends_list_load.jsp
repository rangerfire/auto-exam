<%@ page import="top.moyuyc.entity.FriendRelation" %>
<%@ page import="top.moyuyc.entity.FriendRelationWithStatus" %>
<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="top.moyuyc.jdbc.FriendAcess" %>
<%@ page import="top.moyuyc.jdbc.HeadAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="top.moyuyc.websocket.ChatServer" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/1/28
  Time: 9:19
  To change this template use File | Settings | File Templates.
--%>
<%!
  public static String getFriendName(String me,FriendRelation relation){
    return relation.getUser1().equals(me)?relation.getUser2():relation.getUser1();
  }

    /**
     * get friend's list by online and offline
     */
  public static List<FriendRelationWithStatus> getFriendList(String user,int p,int size){
    List<FriendRelation> all_friends = FriendAcess.getAllFriends(user);
    List<FriendRelationWithStatus> refactor_friends = new ArrayList<FriendRelationWithStatus>();
    List<FriendRelationWithStatus> show_friends = new ArrayList<FriendRelationWithStatus>();
    List<FriendRelationWithStatus> onlion_friends = new ArrayList<FriendRelationWithStatus>();
    List<FriendRelationWithStatus> offlion_friends = new ArrayList<FriendRelationWithStatus>();
    for (FriendRelation fr : all_friends){
      if(isOnline(getFriendName(user,fr))){
        onlion_friends.add(new FriendRelationWithStatus(fr,true));
      }else
        offlion_friends.add(new FriendRelationWithStatus(fr,false));
    }

    refactor_friends.addAll(onlion_friends);
    refactor_friends.addAll(offlion_friends);
    if(refactor_friends.isEmpty()) return null;
    int bg = (p-1)*size, ed = p*size;
    for (int i = bg; i < ed; i++) {
      if(i<refactor_friends.size())
        show_friends.add(refactor_friends.get(i));
      else break;
    }
    return show_friends.isEmpty()?null:show_friends;
  }

  static boolean isOnline(String user){
    return ChatServer.connections.get(user)!=null;
  }

  public static int getFriendRelationDays(String date){
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    long to = new Date().getTime();
    long from = 0;
    try {
      from = df.parse(date).getTime();
    } catch (ParseException e) {
      e.printStackTrace();
    }
    return (int) ((to - from) / (1000 * 60 * 60 * 24));
  }
%>
<%
  String user = session.getAttribute("username").toString();
  int pageSize = 8;
  int p = Integer.parseInt(request.getParameter("p").toString());
  List<FriendRelationWithStatus> relations = getFriendList(user, p, pageSize);
  int total = FriendAcess.getFriendCount(user);
%>
<div class="list-group" id="friends-list">
  <small class="text-info">共有
    <label id="friend-num"><%=total%></label> 位好友</small>
  <%if(relations!=null){for(FriendRelationWithStatus fr:relations){
    String frName = getFriendName(user, fr);
    String headPath = Tools.getUserHeadPath(frName, config);
  %>
  <button type="button" class="list-group-item"
          onclick="if($('[tab-tag=<%=frName%>]').length==0){
              addTab('与<%=frName%>聊天...',{friend:'<%=frName%>',random:parseInt(Math.random()*1000000)},'<%=frName%>','o2oChat-<%=frName%>');
          }else{$('[tab-tag=<%=frName%>]').click();}">
    <span type="button" class="close" aria-label="Close" name="delete-friend" data="<%=frName%>">
      </span>
  <a href="infoshow?name=<%=frName%>" target="_blank"><img
          class="img-bigger <%=fr.isOnline()?"":"img-gray"%>" style="border-radius: 50%; width: 32;height: 32;"  src="<%=headPath%>"></a> <label class="text-primary"><%=frName%></label>
    <span class="pull-right"><span class="glyphicon glyphicon-time"></span> 成为好友<%=getFriendRelationDays(fr.getDate())%>天&nbsp;&nbsp;&nbsp;</span>
  </button>
  <%}}else{%>
   <h4 class="text-primary">您没有好友哦，快去添加好友吧！</h4>
  <%return;}%>
</div>
<div class="form-group">
  <div id="seaFrialert" class="alert alert-warning alert-dismissible fade in text-center" style="display: none;" role="alert">
    <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
    <strong></strong>
  </div>
  <div class="input-group">
    <input type="text" id="searchFriend_input" placeholder="好友搜索" class="form-control" aria-label="...">
                    <span class="input-group-btn">
                        <button id="searchFriend_btn" class="btn btn-primary" type="button">
                          &nbsp;<i class="am-icon-search"></i>&nbsp;
                        </button>
                    </span>
  </div>
</div>
<nav>
  <ul class="pager">
    <li class='disabled'><a style="border-radius: 0" href="javascript:;" id="pre_page1">
      <<
    </a></li>
    <li><a style="border-radius: 0" href="javascript:;" class="active" id="cur_page1">1</a></li>
    <li><a style="border-radius: 0" href="javascript:;" id="next_page1">>></a></li>
  </ul>
</nav>
<hr>
<script>
  $(function () {
    $('#searchFriend_btn').click(function () {
      var _this = $(this).prop('disabled',true);
      console.log(_this)
      var val = $('#searchFriend_input').val().trim();
      var alert = $('#seaFrialert');
      var alert_text = alert.find('strong');
      if(val==''){
        alert_text.text('请输入好友用户名 :(');
        alert.show('normal');
        _this.prop('disabled',false);
      }
      else{
        $.ajax({
          method:'POST',
          url:'ajax/search_Friend_post.jsp',
          data:{name:val}
        }).done(function (d) {
          _this.prop('disabled',false);
          console.log(_this,d)
          if(d==-1){//not friend
            alert_text.text(val+' 不是您的好友 :(');
            alert.show('normal');
          }else if(d==0) {//self
            alert_text.text('不能搜索您自己 :)');
            alert.show('normal');
          }else{
            searchFriend(val);
          }
        })
      }
    });
    $('#searchFriend_input').keydown(function (e) {
      if(e && e.keyCode == 13)
        $('#searchFriend_btn').click();
    })
    searchFriend = function (name) {
      if($('[tab-tag='+name+']').length==0){
        addTab('与'+name+'聊天...',{friend:name,random:parseInt(Math.random()*1000000)},name,'o2oChat-'+name);
      }else{$('[tab-tag='+name+']').click();}
    }
    $('#pre_page1').click(function () {
      var cur = Number($('#cur_page1').text());
      if(cur<=1)
        $(this).parent().addClass('disabled');
      else{
        clickFriendListTab(cur-1);
        $('#cur_page1').text(cur-1);
        $('#next_page1').parent().removeClass('disabled');
        if(cur-1<=1)
          $(this).parent().addClass('disabled');
      }
    })
    $('#next_page1').click(function () {
      var cur = Number($('#cur_page1').text());
      var total = Number($('#friend-num').text());
      if(cur*<%=pageSize%>>=total)
        $(this).parent().addClass('disabled');
      else{
        clickFriendListTab(cur+1);
        $('#cur_page1').text(cur+1);
        $('#pre_page1').parent().removeClass('disabled');
        if((cur+1)*<%=pageSize%>>=total)
          $(this).parent().addClass('disabled');
      }
    })
  })
</script>