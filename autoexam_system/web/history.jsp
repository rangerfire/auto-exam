
<%@ page import="top.moyuyc.entity.Exam" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/17
  Time: 9:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="error.jsp"%>
<%!

%>
<%
  if(session.getAttribute("username")==null){
  response.sendRedirect("?reg");
  return;
  }
  int size=8;
  int num=UserPaperAcess.getTimesByUserName(session.getAttribute("username").toString());
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
  <title><%=session.getAttribute("username")%> 的考试记录 · 考友无忧</title>
  <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
  <script src="js/header.js"></script>
  <script src="js/echarts-all-3.js"></script>
  <script src="js/chart.js"></script>
  <script src="js/jquery.tablesorter.min.js"></script>
  <style>
    th{
       color: #333333;
       cursor: pointer;
    }
    th:hover{
       color: darkcyan;
    }
    th.headerSortUp {
       color: #d43f3a;
    }
    th.headerSortDown {
       color: forestgreen;
    }

  </style>
</head>
<body>
<jsp:include page="template/header.jsp">
  <jsp:param name="way" value="history"></jsp:param>
</jsp:include>

<div class="container">
  <div class="page-header">
    <h1>
      <span class="hidden-xs pull-left">
      <span class="text-info"><span class="glyphicon glyphicon-book"></span>&nbsp;考友无忧&nbsp;&nbsp;&nbsp; </span><small>———— 好记性不如烂笔头</small>
        </span>
      <label class="text-success" style="font-family:幼圆;float: right">考试记录</label>
    </h1>
  </div>
</div>
<div class="container">
  <hr>
  <div id="chart" style="width: 100%; height: 500px;">
  </div>
  <hr>
  <div class="table-responsive ">
  <table id="search_table" class="table table-condensed text-center">

    <caption <%if(num==0){%>style="color: red"<%}%>><%if(0==num){%>暂无考试记录<%}else{%>共有
    <span class="text-info"><%=num%> </span>条记录<%}%></caption>
    <%if(num!=0){out.print("<span class='text-danger'>小提示：点击表头可排序查看哦！</span>");}%>
    <thead <%if(num==0){%>style="display: none"<%}%>>
    <tr class="text-nowrap " style="font-size: 15px">
      <th><span class="glyphicon glyphicon-star"></span>考卷号</th>
      <th class="text-center">科目</th>
      <th class="text-center">状态</th>
      <th class="text-center">难度</th>
      <th class="text-center">单选得分/总分/得分率</th>
      <th class="text-center">多选得分/总分/得分率</th>
      <th class="text-center">判断得分/总分/得分率</th>
      <th class="text-center">开始时间</th>
      <th class="text-center">用时(分钟)</th>
      <th class="text-center">考试时间(分钟)</th>
      <th class="text-center">操作</th>
    </tr>
    </thead>
    <tbody id="table-load" class="text-info" <%if(num==0){%>style="display: none"<%}%>>

    </tbody>
  </table>
  </div>
  <hr>
  <nav <%if(num==0){%>style="display: none"<%}%>>
    <ul class="pager">
      <li class="disabled"><a style="border-radius: 0"href="javascript:;" id="pre_page"><<</a></li>
      <li><a style="border-radius: 0" href="javascript:;" class="active" id="cur_page">1</a></li>
      <li><a style="border-radius: 0" href="javascript:;" id="next_page">>></a></li>
    </ul>
  </nav>

</div>
<jsp:include page="template/footer.jsp"></jsp:include>
</body>
</html>
<script>
  $('#table-load').load('ajax/history_load.jsp',null, function () {
    $("table").tablesorter();
  });

  $("#pre_page").click(function(){
    var cur = Number($("#cur_page").text());
    if(cur<=1)  return;
    $('#table-load').load('ajax/history_load.jsp',{p:cur-1},function(){
      $("#cur_page").text(cur-1);
      $("table").trigger('update');
      if(cur-1<=1)
        $("#pre_page").parent().addClass('disabled');
    })
//    $.ajax({
//      url:'ajax/history_load.jsp',
//      method:'GET',
//      data:{p:cur-1}
//    }).done(function (html) {
//      $('#table-load').html(html);
//      $("#cur_page").text(cur-1);
//      $("table").tablesorter();
//      if(cur-1<=1)
//        $("#pre_page").parent().addClass('disabled');
//    })
  })
  $("#next_page").click(function(){
    var cur = Number($("#cur_page").text());
    if(<%=size%>*cur>=<%=num%>)
    {
      $(this).popover({
        html:true,
        content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>到顶啦！</span>",
        trigger: 'manual',
        placement: 'top',
        container:'body'
      }).popover('show').on('shown.bs.popover', function () {
                var t=$(this)
                setTimeout(function(){
                  t.popover('hide')
                  t.popover('destroy')
                },1500)
              }
        )
      return;
    }else{
      $('#table-load').load('ajax/history_load.jsp',{p:cur+1},function(){
        $("table").trigger('update');
        $("#cur_page").text(cur+1);
        $("#pre_page").parent().removeClass('disabled');
      })

//      $.ajax({
//        url:'ajax/history_load.jsp',
//        method:'GET',
//        data:{p:cur+1}
//      }).done(function (html) {
//        $('#table-load').html(html);
//        $("table").tablesorter();
//        $("#cur_page").text(cur+1);
//        $("#pre_page").parent().removeClass('disabled');
//      })
    }
  })

</script>