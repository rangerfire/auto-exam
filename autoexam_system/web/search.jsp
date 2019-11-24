<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="top.moyuyc.entity.Ques" %>
<%@ page import="top.moyuyc.jdbc.QuesAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="net.sf.json.JSONObject" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/17
  Time: 9:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="error.jsp"%>
<%if (session.getAttribute("username") == null) {
        response.sendRedirect("?reg");
        return;
    }
    boolean f = true;
    String con = null, order = null, content = null;
    int pag = 1;
    boolean isAsc = true;
    Boolean isCertain = null;
    int pageSize = 10;
    try {
        con = Tools.ParToStr(request.getParameter("searchCon"));
        isCertain = Boolean.parseBoolean(Tools.ParToStr(request.getParameter("isCertain")));
        pag = Integer.parseInt(Tools.ParToStr(request.getParameter("page")));
        order = Tools.ParToStr(request.getParameter("order"));
        if (!order.equals("id"))
            order = "ques_" + order;
        isAsc = Boolean.parseBoolean(Tools.ParToStr(request.getParameter("isAsc")));
        content = Tools.ParToStr(request.getParameter("content"));

        if (con == null || order == null || content == null || !order.equals("ques_subject")
                || !order.equals("id") || !order.equals("ques_type") || !con.equals("ques_Id")
                || !con.equals("ques_Subject") || !con.equals("ques_Content") || !con.equals("ques_Analy"))
            throw new Exception();
    } catch (Exception e) {
        //response.sendRedirect(defaultUrl);
        e.printStackTrace();
    }
    List<Ques> list = null;
    try {
        if (con.equals("ques_Id")) {
            list = QuesAcess.getQuessById(content, pag, pageSize, order, isAsc, isCertain);
        } else if (con.equals("ques_Subject")) {
            list = QuesAcess.getQuessBySubject(content, pag, pageSize, order, isAsc, isCertain);
        } else if (con.equals("ques_Content")) {
            list = QuesAcess.getQuessByContent(content, pag, pageSize, order, isAsc);
        } else {
            list = QuesAcess.getQuessByAnaly(content, pag, pageSize, order, isAsc);
        }
    } catch (Exception e) {
        //response.sendRedirect(defaultUrl);
        e.printStackTrace();
    }
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
    <link rel="stylesheet" href="css/jquery.resizableColumns.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="Shortcut Icon" href="images/ico.ico" type="image/x-icon" />
    <script src="js/header.js"></script>
    <script src="js/jquery.resizableColumns.js"></script>
    <script src="js/jquery.tablesorter.min.js"></script>
    <script src="js/store.js"></script>
    <title>题目搜索 · 考友无忧</title>
</head>
<body>
<jsp:include page="template/header.jsp">
    <jsp:param name="way" value="search"></jsp:param>
</jsp:include>
<div class="container">
    <div class="progress">
        <div id="search_progress" class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="1"
             aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
            <span class="sr-only">progress</span>
        </div>
    </div>

    <div id="caption">
        搜索 <span class="text-info"><%=content%></span> 的结果 <div class='pull-right'>本页共有 <label class='text-info'><%=list!=null?list.size():0%></label> 条记录</div>
    </div>
    <div class='text-danger'>小提示：点击表头可排序查看哦！表格列宽也可以动态调整！</div>
    <br>
    <div>
        <ul id="myTabs" class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active">
                <a href="#content1" id="id-tab" role="tab" data-toggle="tab" aria-controls="content1" aria-expanded="true">
                    题号
                </a>
            </li>
            <li role="presentation" class="">
                <a href="#content2" role="tab" id="content-tab" data-toggle="tab" aria-controls="content2" aria-expanded="false">
                    内容
                </a>
            </li>
            <li role="presentation" class="">
                <a href="#content3" role="tab" id="analy-tab" data-toggle="tab" aria-controls="content3" aria-expanded="false">
                    解析
                </a>
            </li>
            <li role="presentation" class="">
                <a href="#content4" role="tab" id="subject-tab" data-toggle="tab" aria-controls="content4" aria-expanded="false">
                    科目
                </a>
            </li>
        </ul>
        <div id="myTabContent" class="tab-content">
            <div role="tabpanel" class="tab-pane fade active in" id="content1" value="ques_Id" aria-labelledby="id-tab">
                <div class="table-responsive">
                    <table id="searchId_table"  class="tablesorter table-bordered">
                        <thead>
                        <tr>
                            <th data-resizable-column-id="题号">题号</th>
                            <th data-resizable-column-id="科目">科目</th>
                            <th data-resizable-column-id="类型">类型</th>
                            <th data-resizable-column-id="分值">分值</th>
                            <th data-resizable-column-id="难度">难度</th>
                            <th data-resizable-column-id="内容">内容</th>
                            <th data-resizable-column-id="答案">答案</th>
                            <th data-resizable-column-id="解析">解析</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <hr>
                <nav>
                    <ul class="pager" <%if(list==null){%>style="display: none;"<%}%>>
                        <li><a style="border-radius: 0" href="javascript:;" name="pre_page"><<</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" class="active" name="cur_page">1</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" name="next_page">>></a></li>
                    </ul>
                </nav>
            </div>
            <div role="tabpanel" class="tab-pane fade" id="content2" value="ques_Content" aria-labelledby="content-tab">
                <div class="table-responsive">
                    <table id="searchContent_table"  class="tablesorter table-bordered">
                        <thead>
                        <tr>
                            <th data-resizable-column-id="题号">题号</th>
                            <th data-resizable-column-id="科目">科目</th>
                            <th data-resizable-column-id="类型">类型</th>
                            <th data-resizable-column-id="分值">分值</th>
                            <th data-resizable-column-id="难度">难度</th>
                            <th data-resizable-column-id="内容">内容</th>
                            <th data-resizable-column-id="答案">答案</th>
                            <th data-resizable-column-id="解析">解析</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <hr>
                <nav>
                    <ul class="pager" >
                        <li><a style="border-radius: 0" href="javascript:;" name="pre_page"><<</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" class="active" name="cur_page">1</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" name="next_page">>></a></li>
                    </ul>
                </nav>
            </div>
            <div role="tabpanel" class="tab-pane fade" id="content3" value="ques_Analy" aria-labelledby="analy-tab">
                <div class="table-responsive">
                    <table id="searchAnaly_table"  class="tablesorter table-bordered">
                        <thead>
                        <tr>
                            <th data-resizable-column-id="题号">题号</th>
                            <th data-resizable-column-id="科目">科目</th>
                            <th data-resizable-column-id="类型">类型</th>
                            <th data-resizable-column-id="分值">分值</th>
                            <th data-resizable-column-id="难度">难度</th>
                            <th data-resizable-column-id="内容">内容</th>
                            <th data-resizable-column-id="答案">答案</th>
                            <th data-resizable-column-id="解析">解析</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <hr>
                <nav>
                    <ul class="pager" >
                        <li><a style="border-radius: 0" href="javascript:;" name="pre_page"><<</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" class="active" name="cur_page">1</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" name="next_page">>></a></li>
                    </ul>
                </nav>
            </div>
            <div role="tabpanel" class="tab-pane fade" id="content4" value="ques_Subject" aria-labelledby="subject-tab">
                <div class="table-responsive">
                    <table id="searchSubject_table"  class="tablesorter table-bordered">
                        <thead>
                        <tr>
                            <th data-resizable-column-id="题号">题号</th>
                            <th data-resizable-column-id="科目">科目</th>
                            <th data-resizable-column-id="类型">类型</th>
                            <th data-resizable-column-id="分值">分值</th>
                            <th data-resizable-column-id="难度">难度</th>
                            <th data-resizable-column-id="内容">内容</th>
                            <th data-resizable-column-id="答案">答案</th>
                            <th data-resizable-column-id="解析">解析</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <hr>
                <nav>
                    <ul class="pager" >
                        <li><a style="border-radius: 0" href="javascript:;" name="pre_page"><<</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" class="active" name="cur_page">1</a></li>
                        <li><a style="border-radius: 0" href="javascript:;" name="next_page">>></a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<jsp:include page="template/footer.jsp"></jsp:include>
</body>
</html>


<script>
    $(document).ready(function () {
        function tableIdMap(i){
            if(i==0) return 'searchId_table';
            if(i==1) return 'searchContent_table';
            if(i==2) return 'searchAnaly_table';
            if(i==3) return 'searchSubject_table';
        }
        function contentMap(i){
            if(i==0) return 'ques_Id';
            if(i==1) return 'ques_Content';
            if(i==2) return 'ques_Analy';
            if(i==3) return 'ques_Subject';
        }
        var search_info;
        $("[name=cur_page]").text(<%=pag%>)
        $("[name=pre_page]").each(function (i) {
            $(this).click(function () {
                if ($("#cur_page").text() == 1)
                    return;
                if (search_info == null) return;
                var temp=search_info
                temp.page = Number($("[name=cur_page]").eq(i).text() - 1)
                if(temp.page<1)
                    return;
                $.ajax({
                    method: "GET",
                    url: "ajax/start",
                    data: temp
                }).done(function (d) {
                    if (d == -1)
                        $("[name=pre_page]").eq(i).popover({
                            html:true,
                            trigger:'manual',
                            content:"<span style='color:red'><span class='glyphicon glyphicon-remove'></span> 无数据</span>",
                            placement:'top',
                        }).popover('show').on("shown.bs.popover",function(){
                            var t=$(this)
                            setTimeout(function(){
                                t.popover('hide')
                            },1000)
                        })
                    else{
                        $("#search_progress").animate({width: "100%"}, 100, null, function () {
                            $("#"+tableIdMap(i)).quesTableShow(d)
                        })
                        search_info=temp
                        $("[name=cur_page]").eq(i).text(temp.page)

                    }
                })
            })
        });
        $("[name=next_page]").each(function (i) {
            $(this).click(function () {
                if (search_info == null) return;
                var temp=search_info
                temp.page = Number($("[name=cur_page]").eq(i).text()) + 1
                $.ajax({
                    method: "GET",
                    url: "ajax/start",
                    data: temp
                }).done(function (d) {
                    if (d == -1)
                        $("[name=next_page]").eq(i).popover({
                            html:true,
                            trigger:'manual',
                            content:"<span style='color:red'><span class='glyphicon glyphicon-remove'></span> 无数据</span>",
                            placement:'top'
                        }).popover('show').on("shown.bs.popover",function(){
                            var t=$(this)
                            setTimeout(function(){
                                t.popover('hide')
                            },1500)
                        })
                    else{
                        $("#search_progress").animate({width: "100%"}, 100, null, function () {
                            $("#"+tableIdMap(i)).quesTableShow(d)
                        })
                        search_info=temp
                        $("[name=cur_page]").eq(i).text(temp.page)
                    }
                })
            })
        });
        loadDiv='<div class="text-center" style=""><a href="javascript:;">' +
                '<img width="48" height="48" id="loading" src="images/loading.gif">' +
                '</a></div>';
        $('#myTabs li a').each(function (i) {
            $(this).on('show.bs.tab', function () {
                var tabcon = $($(this).attr('href'));
                tabcon.children().hide();
                tabcon.append(loadDiv);
                search_info.searchCon = contentMap(i);
                search_info.page=1;
                $.ajax({
                    method: "GET",
                    url: "ajax/start",
                    data: search_info
                }).done(function (d) {
                    setTimeout(function () {
                        $('#'+tableIdMap(i)).quesTableShow(d);
                        tabcon.children(':last').remove();
                        $("[name=cur_page]").text(1);
                        tabcon.children().slideDown('normal');
                    },600);
                })
            })
        })
        $("#search_progress").css("width", "100%")
        search_info=<%
            Map map=new HashMap<String,String>();
            map.put("act","userSearch");map.put("isCertain",isCertain);
            map.put("searchCon",con);map.put("content",content);
            map.put("page",pag);map.put("isAsc",isAsc);
            map.put("order",order);map.put("pageSize",pageSize);
            %><%=JSONObject.fromObject(map)%>
        $("#searchId_table").quesTableShow(<%if(list==null){%>-1<%}else{
        Map m = new HashMap<String,String>();
        m.put("data",list);
        m.put("content",content);%>
        '<%=JSONObject.fromObject(m)%>'<%}%>)
        $("#search_btn").off("click");
        $("#search_btn").click(function (e, a) {
            console.log(a);
            if (trim($("#search_input").val()) == "") {
                $("#search_input").popover({
                    html: true,
                    content: "<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请输入</span>",
                    trigger: 'manual',
                    placement: 'bottom',
                    container:'body'
                }).popover('show')
                return;
            }
            $("#search_progress").removeClass("progress-bar-success")
            $("#search_progress").removeClass("progress-bar-danger")
            $("#search_progress").hide().animate({width: '0%'}, 100, null,
                    function () {
                        $("#search_progress").show().animate({width: '95%'})
                    }
            );
            var isCertain = false;
            var con='ques_Id';
            search_info = {
                act: 'userSearch',
                isCertain: isCertain,
                searchCon: con,
                content: trim($("#search_input").val()),
                //
                page: 1,
                isAsc: true,
                order: 'subject',
                pageSize: <%=pageSize%>
            }
            $(this).prop("disabled",true);
            $.ajax({
                method: "GET",
                url: "ajax/start.jsp",
                data: search_info
            }).done(function (d) {
                setTimeout(function () {
                    $("#search_btn").prop("disabled",false);
                    $("#search_progress").animate({width: "100%"}, 100, null, function () {
                        $("#searchId_table").quesTableShow(d);
                        $("#searchId_table").find("th").addClass("header")
                    })
                    $("#cur_page").text(1)
                    if(d==-1){
                        $("[class=pager]").hide("normal")
                    }else
                        $("[class=pager]").show("normal")
                }, 1200)

            })
        })
    })

    $.fn.quesTableShow = function (data) {
        var caption = $('#caption');
        var head = $(this).find("thead")
        var body = $(this).find("tbody")
        body.html("")
        if (data == -1) {
            $("#search_progress").removeClass("progress-bar-success")
            $("#search_progress").addClass("progress-bar-danger")
            head.show().hide("normal")
            body.show().hide("normal")
            caption.text("无搜索结果").css("color", "red").show("normal")
        } else {
            $("#search_progress").removeClass("progress-bar-danger")
            $("#search_progress").addClass("progress-bar-success")
            data = JSON.parse(data)
            caption.html("搜索 "+data.content+" 的结果 <div class='pull-right'>本页共有 <label class='text-info'>" + data.data.length + "</label> 条记录</div>").css("color", "").show("normal")
            head.hide().show("normal")
            body.hide().show("normal")
            for (var i in data.data) {
                body.append($(getQuesTr(data.data[i])))
            }
            $("table").resizableColumns()
            $("table").trigger("update")//.trigger("sorton",[[0,0]]);
            $("table th").removeClass("headerSortDown").removeClass("headerSortUp")
        }
    }
    $("table").tablesorter()
    function getQuesTr(data) {
        var tr = document.createElement("tr");
        var td, td1, td2, td3, td4, td5, td6,tdLev;
        td = document.createElement("td");
        td.innerHTML = data.id

        tr.appendChild(td)
        td1 = document.createElement("td");
        td1.innerHTML = data.ques_subject;

        tr.appendChild(td1)
        td2 = document.createElement("td");
        var t;
        if (data.ques_type == 'single_choose')
            t = '单选'
        else if (data.ques_type == 'muti_choose')
            t = '多选'
        else if (data.ques_type == 'judgement')
            t = '判断'
        else
            t = '简答'
        td2.innerHTML = t;

        tr.appendChild(td2)
        td3 = document.createElement("td");
        td3.innerHTML = data.ques_score;
        tr.appendChild(td3)
        console.log(data)
        tdLev=document.createElement("td");
        var lev;
        switch (data.lev){
            case 0:lev='★★★'; break;
            case 1:lev='★★'; break;
            case 2:lev='★'; break;
        }
        tdLev.innerHTML = lev;
        tr.appendChild(tdLev);

        td4 = document.createElement("td");
        if (data.ques_type != 'muti_choose' && data.ques_type != 'single_choose')
            td4.innerHTML = data.ques_content.length == 0 ? "无" : data.ques_content;
        else {
            td4.innerHTML = data.ques_content.length == 0 ? "无" : getQuesSelect(data.ques_content).outerHTML;
        }
        tr.appendChild(td4)
        td5 = document.createElement("td");
        td5.innerHTML = data.ques_answer.length == 0 ? '无' : data.ques_answer;

        tr.appendChild(td5)
        td6 = document.createElement("td");
        td6.innerHTML = data.ques_analy == "" ? '无' : data.ques_analy;

        tr.appendChild(td6)
        return tr;
    }
    function getQuesSelect(data) {
        var sel = document.createElement('select');

        sel.style.width="100%"

        var s = '题ABCDEFGHIJK'
        for (var i in data) {
            var op = document.createElement('option');
            op.innerHTML = s.charAt(i) + '. ' + data[i]
            sel.appendChild(op)
        }

        return sel;
    }
</script>
