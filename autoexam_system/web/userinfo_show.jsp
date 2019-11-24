<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.entity.Exam" %>
<%@ page import="top.moyuyc.entity.User" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="top.moyuyc.transaction.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="top.moyuyc.jdbc.*" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/1/27
  Time: 17:56
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
    <link rel="stylesheet" href="css/jquery-ui.min.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/card.css">
    <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
    <script src="js/header.js"></script>
    <style>
        /*.img-bigger{zoom:100%;cursor: pointer;}*/

    </style>
  <%
      if (session.getAttribute("username") == null) {
          response.sendRedirect("?reg");
          return;
      }
    String user = request.getParameter("name");
    Object me = session.getAttribute("username");
    if(me==null) return;
    User u = UserAcess.getUserByName(user);
    if(u==null){
      out.print("不存在该用户");
      return;
    }
    String uhPath = Tools.getUserHeadPath(user,config);
    int n_friend = FriendAcess.getFriendCount(user);
    int n_exam = UserPaperAcess.getTimesByUserName(user);
      boolean f=false;
  %>
    <title><%=user%>的个人资料</title>
</head>
<body>

<jsp:include page="template/header.jsp"></jsp:include>
<div class="container">
  <div class="page-header">
    <h1>
        <span class="hidden-xs pull-left">
        <span class="text-info"><span class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp; </span><small>———— 好记性不如烂笔头</small>
        </span>
      <label class="text-success" style="font-family:幼圆;float: right"><%=user%> 的个人资料查看</label>
    </h1>
  </div>
</div>
<div class="container" id="info-show">
    <hr>
  <div class="row">

        <div class="card hovercard">
            <div class="card-background">
                <img class="card-bkimg" src="<%=uhPath%>"></a>
            </div>
            <div class="useravatar">
                <img class="img-bigger" style="border-radius: 50%;" height="100" width="100" src="<%=uhPath%>"></a>
            </div>
            <div class="card-info"> <span class="card-title"><%=user%></span></div>
        </div>
        <div class="btn-pref btn-group btn-group-justified btn-group-lg" data-toggle="buttons">
            <label class="btn btn-default">
                <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                <div class="hidden-xs">积分</div>
                <p style="padding-top: 6px;"><%=PointAcess.getPointByName(user)%></p>
            </label>
            <label class="btn btn-default">
                <span class="glyphicon glyphicon-pencil"></span>
                <div class="hidden-xs">考试</div>
                <p style="padding-top: 6px;"><%=n_exam%>次</p>
            </label>
            <label class="btn btn-default">
                <i class="am-icon-group"></i>
                <div class="hidden-xs">好友</div>
                <p style="padding-top: 6px;"><%=n_friend%>位</p>
            </label>
            <label class="btn btn-default">
                <i class="am-icon-trophy"></i>
                <div class="hidden-xs">排名</div>
                <p style="padding-top: 6px;" class="">第<%=1+PointAcess.getBeforeCountAllByName(user)%>名</p>
            </label>
            <label class="btn btn-default">
                <span class="glyphicon glyphicon-fire"></span>
                <div class="hidden-xs">PK</div>
                <p style="padding-top: 6px;" class=""><%=PKHistoryAcess.getPKCountByName(user)%>次</p>
            </label>
        </div>
      <hr>
      <div class="text-center">
          <%if(FriendAcess.checkFriendIsExists(me.toString(),user)){
              f=true;%>
          <button id="btn-fight" data-toggle="modal" data-target="#fight-Modal"
                  data-name="<%=user%>" class="btn btn-primary btn-lg"
                  title="pk积分只计算客观题">
              <i class="glyphicon glyphicon-fire"></i> 向他下战书</button>
          <button role="button-remove-friend" data-name="<%=user%>" class="btn btn-danger btn-sm">
              <i class="glyphicon glyphicon-remove"></i> 删除好友</button>
          <%}else if(Transaction.isExistsAddFriendQuery(me.toString(),user)){%>
          <h4 class="text-info">您的请求正在申请中...</h4>
          <%}else if(Transaction.isExistsAddFriendAccept(me.toString(), user)){%>
          <h4 class="text-info">该用户已经申请您为好友...</h4>
          <%}else if(!me.equals(user)){%>
          <button role="button-add-friend" data-name="<%=user%>" class="btn btn-success btn-lg">
              <i class="am-icon-user-plus"></i> 申请添加好友</button>
          <%}%>
      </div>
    </div>
    <br>
    <div id="tip" class="alert alert-info alert-dismissible fade in text-center" style="display:none" role="alert">
        <button type="button" class="close" aria-label="Close" onclick="$(this).parent().hide('normal')"><span aria-hidden="true">×</span></button>
        <strong></strong>
    </div>
    <br>
</div>
<%if(f){%>
<div id="fight-Modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">

    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h5 class="modal-title text-center">选择考卷</h5>
            </div>
            <div class="modal-body">
                <div id="magic1">
                </div>
            </div>
            <div class="modal-footer">
                <div id="modal-tip" class="alert alert-danger alert-sm alert-dismissible fade in text-center" style="display:none" role="alert">
                    <button type="button" class="close" aria-label="Close" onclick="$(this).parent().hide('normal')"><span aria-hidden="true">×</span></button>
                    <strong></strong>
                </div>
                <button type="button" class="btn btn-danger" id="btn-dofight">宣战！</button>
            </div>
        </div>
    </div>
</div>
<%}%>
<jsp:include page="template/footer.jsp"></jsp:include>
</body>
<%JSONArray array = new JSONArray();
    if(f){
    List<Exam> list = UserPaperAcess.getFinishExamsByUserName(me.toString(), "paper_id", true);
    for (Exam exam : list){
        JSONObject object = new JSONObject();
        if(PKHistoryAcess.checkIsExistsByNamesPaper(exam.getPaper_id(),user,me.toString())
            || UserPaperAcess.checkIsExistUserPaper(user,exam.getPaper_id()))
            object.put("disabled",true);
        object.put("name",exam.getPaper_id());
        object.put("subject",exam.getSubject());
        int lev = PaperAcess.getPaperLevById(exam.getPaper_id());
        object.put("lev", lev==0?"困难":lev==1?"适中":"简单");
        array.add(object);
    }
%>
<link href="css/magicsuggest-min.css" rel="stylesheet">
<script src="js/magicsuggest-min.js"></script>
<%}%>
<script>
    <%if(f){%>
    $('#btn-fight').click(function () {
        var m = $('#magic1').magicSuggest({
            placeholder: '输入考卷号或选择考卷',
            autoSelect: true,
            allowFreeEntries :false,
            data: <%=array%>,
            disabledField:'disabled',
            noSuggestionText: '不存在 {{query}} 考卷 :(',
            expandOnFocus:true,
            valueField:'name',
            selectionRenderer: function(data){
                var id = data.name;
                return '<span><span class="glyphicon glyphicon-star"></span> '+id+'</span>';
            },
            renderer: function (data) {
                return '<span><span class="glyphicon glyphicon-star"></span> '+data.name+'</span>' +
                        '<div class="pull-right"><span class="text-right small">'+data.subject+'</span>&nbsp;&nbsp;&nbsp;' +
                        '<span class="text-right small">'+data.lev+'</span></div>';
            }
        });
        m.collapse();
        $('#btn-dofight').click(function () {
            var vs = m.getValue(),tip = $('#modal-tip'),text = tip.find('strong');
            if(vs.length==0) {
                text.text('请选择考卷号 :(');
                tip.show('normal');
            }
            $.ajax({
                method:'POST',
                url:'ajax/start.jsp',
                data:{
                    act:'fightByPapers',
                    user:'<%=user%>',
                    papers:vs
                }
            }).done(function (d) {
                text.text(d!=-1?'宣战成功！ :)':d==0?'宣战失败，不能重复宣战 :(':'宣战失败，可能该用户不是您的好友 :(');
                tip.show('normal');
            })
        })
    });
    <%}%>

    $('[role=button-remove-friend]').click(function () {
        var _this = $(this);
        var name = _this.attr('data-name');
        $.moyuConfirm("确认删除"+name+" ?", function () {
            $.ajax({
                method:'POST',
                url:'ajax/delfriend_post.jsp',
                data:{
                    name:name
                }
            }).done(function (d) {
                if(d==1){
                    $('#tip').show("normal").find('strong').text('删除成功');
                    _this.remove();
                    removeDBTable(window.axUser,name);
                }
                else{
                    $('#tip').show("normal").find('strong').text('删除失败');
                }
            })
        });
//      event.stopPropagation();
        return false;
    })
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
</html>
