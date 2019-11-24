<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="javax.tools.Tool" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="../WEB-INF/error.jsp"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Expires", "0");
    Boolean admin = (Boolean) session.getAttribute("admin");
    if (admin != null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String oldname = Tools.findCookie("ADMIN_NAME", request);
    oldname=oldname!=null?URLDecoder.decode(oldname,"utf-8"):null;
    String oldpwd  = Tools.findCookie("ADMIN_PWD", request);
    oldpwd=oldpwd!=null?URLDecoder.decode(oldpwd,"utf-8"):null;
    if(oldname==null||oldpwd==null)
        oldname=oldpwd=null;
%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>管理员登录</title>
    <script src="../js/jquery-2.1.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/login.css">
    <link rel="Shortcut Icon" href="../images/ico.ico" type="image/x-icon" />
    <script>
        $(document).ready(function () {
            $(document).keydown(function (e) {
                if (e != null && e.keyCode == 13)
                    $("#login").click();
            });
            $("#login").click(function () {
                if ($("#inputAdmin").val().trim() == "" || $("#inputPassword").val().trim() == "")
                    return;
                $.ajax({
                    method: "POST",
                    url: "../ajax/adminStart.jsp",
                    data: {
                        admin: $("#inputAdmin").val(),
                        password: $("#inputPassword").val(),
                        remember: $("#inputrember").prop("checked")
                    }
                }).done(function (d) {
                    if (d == -1)
                        $("#login").popover({
                            html: true,
                            content: "<span style='color:red'><span class='glyphicon glyphicon-remove'></span> 登录失败</span>",
                            trigger: 'manual',
                            placement: 'top',
                            container:'body'
                        }).popover('show')
                    else if (d == 0)
                        $("#login").popover({
                            html: true,
                            content: "<span style='color:red'><span class='glyphicon glyphicon-remove'></span> 尝试次数已到上限</span>",
                            trigger: 'manual',
                            placement: 'top',
                            container:'body'
                        }).popover('show')
                    else {
                        location.href = "index.jsp";
                    }
                }).fail(function (e) {
                    $("#login").popover({
                        html: true,
                        content: "<span style='color:red'><span class='glyphicon glyphicon-remove'></span> 连接服务器失败 Error:" + e.status + "</span>",
                        trigger: 'manual',
                        placement: 'top',
                        container:'body'
                    }).popover('show')

                })

                $("#login").on("shown.bs.popover", function () {
                    var t = $(this)
                    setTimeout(function () {
                        t.popover('destroy')
                    }, 1500)
                })
            });
        });
    </script>
</head>
<body>
<div class="container">
    <div class="form-signin">
        <h2 class="form-signin-heading">管理员登录</h2>
        <input type="text" value="<%=oldname==null?"":oldname%>" id="inputAdmin" autocomplete="off" class="form-control" placeholder="管理员" required autofocus>
        <input type="text" autocomplete="off" id="inputPassword" class="form-control" placeholder="密&nbsp;&nbsp;&nbsp;码" required>
        <div class="checkbox">
            <label for="inputrember">
                <input type="checkbox" id="inputrember" <%=oldpwd==null?"":"checked"%>>七天内记住我
            </label>
        </div>

        <button class="btn btn-lg btn-primary btn-block" type="submit" id="login">登&nbsp;&nbsp;&nbsp;录</button>
    </div>
</div>

</body>
</html>
<script>
    setTimeout("$('#inputPassword').prop('type','password').val('<%=oldpwd==null?"":oldpwd%>');",1);
</script>