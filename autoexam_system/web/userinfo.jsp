<%@ page import="top.moyuyc.entity.User" %>
<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="top.moyuyc.jdbc.*" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/17
  Time: 9:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="error.jsp"%>
<%
if (session.getAttribute("username") == null) {
response.sendRedirect("?reg");
return;
}
    String headPath = Tools.getUserHeadPath(session.getAttribute("username").toString(), config);
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
    <link rel="stylesheet" href="css/headupload.css">
    <link rel="stylesheet" href="css/cropper.min.css">
    <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
    <title><%=session.getAttribute("username")%> 的个人中心 · 考友无忧</title>
    <script src="js/header.js"></script>
    <script src="js/cropper.min.js"></script>
    <script src="js/headupload.js"></script>
</head>
<body>
<jsp:include page="template/header.jsp">
    <jsp:param name="way" value="userinfo"></jsp:param>
</jsp:include>

<div class="container">
    <div class="page-header">
        <h1>
            <span class="hidden-xs pull-left">
            <span class="text-success"><%=session.getAttribute("username")%></span>，欢迎您来到 <span class="text-info"><span
                class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp;</span>
            <small>———— 好记性不如烂笔头</small>
            </span>
            <label class="text-success" style="font-family:幼圆;float: right">个人中心</label>
        </h1>
    </div>
</div>

<div class="container">
    <hr>
    <div class="row">
        <div class="col-xs-3 text-center">
            <div class="list-group">
                <a href="#info" aria-controls="messages" role="tab" data-toggle="tab" id="info_show"
                   class="list-group-item">个人资料 <span class="glyphicon glyphicon-chevron-right"></span></a>
                <a href="#pwd" aria-controls="messages" role="tab" data-toggle="tab" id="info_pwd"
                   class="list-group-item">修改密码 <span class="glyphicon glyphicon-chevron-right"></span></a>
                <a href="#email" aria-controls="settings" role="tab" data-toggle="tab" id="info_email"
                   class="list-group-item">修改邮箱 <span class="glyphicon glyphicon-chevron-right"></span></a>
                <a href="#head" aria-controls="settings" role="tab" data-toggle="tab"
                   class="list-group-item">修改头像 <span class="glyphicon glyphicon-chevron-right"></span></a>
            </div>
        </div>
        <div class="col-xs-9" >
            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane fade" id="info">
                    <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <th>头像</th>
                            <th>注册邮箱</th>
                            <th>考试次数</th>
                            <th>PK次数</th>
                            <th>PK积分</th>
                            <th>注册时间</th>
                        </thead>
                        <tbody><%String me = (String)session.getAttribute("username");%>
                            <tr><%User user=UserAcess.getUserByName(me);%>
                                <td><a href="javascript:;"><img class="img-bigger" style="border-radius: 50%;" height="64" width="64" src="<%=headPath%>"></a>
                                </td>
                                <td><%=user.getUser_email()%></td>
                                <td><%=UserPaperAcess.getTimesByUserName(me)%></td>
                                <td><%=PKHistoryAcess.getPKCountByName(me)%></td>
                                <td><%=PointAcess.getPointByName(me)%></td>
                                <td><%=user.getCreate_time()%></td>
                            </tr>
                        </tbody>
                    </table>
                    </div>
                    <hr>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="pwd">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="inputPassword1" class="col-sm-2 control-label">原密码</label>
                            <div class="col-sm-10">
                                <input type="password" class="form-control" id="inputPassword1" placeholder="请输入原密码（6-12位，不含空格）">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputPassword2" class="col-sm-2 control-label">新密码</label>
                            <div class="col-sm-10">
                                <input type="password" class="form-control" id="inputPassword2" placeholder="请输入新密码（6-12位，不含空格）">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputPassword3" class="col-sm-2 control-label">确认密码</label>
                            <div class="col-sm-10">
                                <input type="password" class="form-control" id="inputPassword3" placeholder="请再次输入新密码">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-10 text-right">
                                <button type="button" id="info_pwd_btn" class="btn btn-default">修改密码</button>
                            </div>
                        </div>
                        <hr>
                    </form>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="email">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="inputPassword2" class="col-sm-2 control-label">新邮箱</label>
                            <div class="col-sm-10">
                                <input type="email" class="form-control" id="inputEmail2" placeholder="请输入新邮箱">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-10 text-right">
                                <button type="button" id="info_email_btn" class="btn btn-default">修改邮箱</button>
                            </div>
                        </div>
                        <hr>
                    </form>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="head">
                    <div>
                        <h4><span class="label label-primary">修改头像</span></h4>
                        <div id="div-file-add" class="col-sm-offset-1">
                            <div class="ibox-content">
                                <div id="crop-avatar">
                                    <div title="点击修改头像" role="head-container">
                                        <a href="javascript:;">
                                            <img class="img-bigger" style="border-radius: 50%;" height="100" width="100" src="<%=headPath%>">
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="modal fade" id="avatar-modal" aria-hidden="true" aria-labelledby="avatar-modal-label" role="dialog" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <form class="avatar-form" >
                                            <div class="modal-header">
                                                <button class="close" data-dismiss="modal" type="button">&times;</button>
                                                <h4 class="modal-title" id="avatar-modal-label">头像修改</h4>
                                            </div>
                                            <div class="modal-body">
                                                <div class="avatar-body">
                                                    <div class="avatar-upload">
                                                        <input class="avatar-src" name="avatar_src" type="hidden">
                                                        <input class="avatar-data" name="avatar_data" type="hidden">
                                                        <label for="avatarInput" class="btn btn-primary">图片上传</label>
                                                        <input class="avatar-input" id="avatarInput" name="avatar_file" type="file" style="display: none;"></div>
                                                    <div class="row">
                                                        <div class="col-md-9">
                                                            <div class="avatar-wrapper"></div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="avatar-preview preview-lg"></div>
                                                            <div class="avatar-preview preview-md"></div>
                                                            <div class="avatar-preview preview-sm"></div>
                                                        </div>
                                                    </div>
                                                    <div class="row avatar-btns">
                                                        <div class="col-md-9" >
                                                            <div class="btn-group">
                                                                <button class="btn" data-method="rotate" data-option="-90" type="button" title="Rotate -90 degrees"><i class="fa fa-undo"></i> 向左旋转</button>
                                                            </div>
                                                            <div class="btn-group">
                                                                <button class="btn" data-method="rotate" data-option="90" type="button" title="Rotate 90 degrees"><i class="fa fa-repeat"></i> 向右旋转</button>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <button id="btn-file-up" class="btn btn-block btn-success avatar-save">保存修改</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div id="page-wrapper">
                            <div class="loading" aria-label="Loading" role="img" tabindex="-1"></div>
                            </div>
                            <%--<iframe name="hideframe" style=''>--%>
                            <%--</iframe>--%>
                            </div>

                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/template/footer.jsp"></jsp:include>
</body>
</html>
<script>
    $("#info_show").click()
    $("#inputPassword1,#inputPassword2").blur(function(){
        $(this).on('shown.bs.popover', function () {
            var t=$(this)
            setTimeout(function(){
                t.popover('hide')
            },1500)
        })
        $(this).popover({
            content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请按照正确规格输入,6-12位,不含空格,中文</span>",
            trigger:'manual',
            html:true,
            placement:'top',
            container:'body'
        })
        $(this).removeAttr("style");
        if($(this).val()=="")   return;
        if(!validatePwdandName($(this).val())){
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            //autoHide()
            return false;
        }
    })
    $("#inputPassword3").blur(function(){
        $(this).on('shown.bs.popover', function () {
            var t=$(this)
            setTimeout(function(){
                t.popover('hide')
            },1500)
        })
        $(this).removeAttr("style");
        if($(this).val()=="")  return false;
        if($(this).val()!=$("#inputPassword2").val()){
            $(this).popover({
                content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>两次密码不一致</span>",
                trigger:'manual',
                html:true,
                placement:'top',
                container:'body'
            })
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            //autoHide()
            return false;
        }
    })
    $("#inputEmail1,#inputEmail2").blur(function(){
        $(this).on('shown.bs.popover', function () {
            var t=$(this)
            setTimeout(function(){
                t.popover('hide')
            },1500)
        })
        $(this).removeAttr("style");
        if($(this).val()=="")   return false;
        if(!/^.+@.+\..+$/.test($(this).val())){
            $(this).popover({
                content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请输入正确的电子邮箱</span>",
                trigger:'manual',
                html:true,
                placement:'top',
                container:'body'
            })
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            //autoHide()
            return false;
        }
    })
    $("#info_pwd_btn").click(function(){
        $(this).on('shown.bs.popover', function () {
            var t=$(this)
            setTimeout(function(){
                t.popover('hide')
                t.popover('destroy')
            },1500)
        })
        if($("#inputPassword1").val()=="" || $("#inputPassword2").val()=="" || $("#inputPassword3").val()=="")  return false;
        $.ajax({
            method:"POST",
            url:"ajax/start.jsp",
            data:{
                act:'userPwdChange',
                oldPwd:$("#inputPassword1").val(),
                newPwd:$("#inputPassword2").val(),
            }
        }).done(function(d){
            if(d==-1){
                $("#info_pwd_btn").popover({
                    content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>原密码错误，密码修改失败</span>",
                    trigger:'manual',
                    html:true,
                    placement:'top',
                    container:'body'
                }).popover('show');
            }else{
                $("#info_pwd_btn").popover({
                    content:"<span style='color: green'><span class='glyphicon glyphicon-ok'></span>密码已被成功修改</span>",
                    trigger:'manual',
                    html:true,
                    placement:'top',
                    container:'body'
                }).popover('show');
                $("#inputPassword1,#inputPassword2,#inputPassword3").val("")
            }
        })
    })
    $("#info_email_btn").click(function(){
        $(this).on('shown.bs.popover', function () {
            var t=$(this)
            setTimeout(function(){
                t.popover('hide')
                t.popover('destroy')
            },1500)
        })
        if($("#inputEmail1").val()=="" || $("#inputEmail2").val()=="")  return false;
        $.ajax({
            method:"POST",
            url:"ajax/start.jsp",
            data:{
                act:'userEmailChange',
                newEmail:$("#inputEmail2").val(),
            }
        }).done(function(d){
            if(d==-1){
                $("#info_email_btn").popover({
                    content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>邮箱修改失败</span>",
                    trigger:'manual',
                    html:true,
                    placement:'top',
                    container:'body'
                }).popover('show');
            }else{
                $("#info_email_btn").popover({
                    content:"<span style='color: green'><span class='glyphicon glyphicon-ok'></span>邮箱已被成功修改</span>",
                    trigger:'manual',
                    html:true,
                    placement:'top',
                    container:'body'
                }).popover('show');
                $("#inputEmail1,#inputEmail2").val("")
            }
        })
    })



</script>