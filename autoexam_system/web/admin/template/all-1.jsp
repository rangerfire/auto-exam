<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="top.moyuyc.entity.Exam" %>
<%@ page import="top.moyuyc.entity.User" %>
<%@ page import="top.moyuyc.jdbc.UserAcess" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="java.util.List" %>
<%@ page import="top.moyuyc.jdbc.PaperAcess" %>
<%@ page import="java.util.LinkedList" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/26
  Time: 8:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int pageSize = 16;
    int pag = 1;
    try {
        pag = request.getParameter("p") == null ? 1 : Integer.parseInt(request.getParameter("p"));
        if (pag <= 0)
            pag = 1;
    } catch (Exception e) {
        e.printStackTrace();
        pag = 1;
    }
    List<User> list = UserAcess.getAllUsers(pag, pageSize, UserAcess.USER_NAME, true);
    int num = UserAcess.getUserCount();
%>
<caption>一共有 <label id="table-num" class="text-info"><%=num%></label> 条记录，当前显示 <label id="cur-num" class="text-info"><%=list.size()%></label> 条记录</caption>
<br><span class='text-danger'>小提示：点击表头可排序哦！点击可以查看最近考试记录哦！</span>
<div class="table-responsive">
<table class="table table-hover">
    <thead>
    <tr>
        <th>#</th>
        <th>用户名</th>
        <th>注册邮箱</th>
        <th>密码</th>
        <th>注册时间</th>
        <th>考试次数</th>
    </tr>
    </thead>
    <tbody>
    <%
        int j = 1;
        for (User q : list) {
            List<Exam> data = UserPaperAcess.getExamsByUserName(q.getUser_name(), 1, 6, UserPaperAcess.START_TIME, false);
            List<Integer> maxmin_list=new LinkedList<Integer>();
            if(data!=null)
                for(Exam e : data)
                    maxmin_list.add(PaperAcess.getMaxMinById(e.getPaper_id()));
    %>
    <tr style="cursor: pointer" maxmin="<%=JSONArray.fromObject(maxmin_list).toString()%>"
        data-click='<%=JSONArray.fromObject(data).toString()%>'>
        <td><%=j++%>
        </td>
        <td><%=q.getUser_name()%>
        </td>
        <td><%=q.getUser_email()%>
        </td>
        <td><%=q.getUser_pwd()%>
        </td>
        <td><%=q.getCreate_time()%>
        </td>
        <td><%=UserPaperAcess.getTimesByUserName(q.getUser_name())%>
        </td>
    </tr>
    <%}%>
    </tbody>
</table>
</div>
<hr>
<nav class="text-center">
    <ul class="pagination">
        <li id="prepage" <%if(pag==1){%>class="disabled"<%}%>><a href="javascript:;" aria-label="Previous"><span
                aria-hidden="true">&laquo;</span></a></li>
        <%
            double f = Math.ceil((double) num / (double) pageSize);
            for (int i = 1; i <= f; i++) {
        %>
        <%if (i == pag) {%>
        <li class="active"><a href="#"><%=i%><span class="sr-only">(current)</span></a></li>
        <%} else {%>
        <li><a href="index.jsp?root=all&i=1&p=<%=i%>"><%=i%><span class="sr-only">(current)</span></a></li>
        <%
                }
            }
        %>
        <li id="nextpage" <%if(f==pag){%>class="disabled" <%}%>><a href="javascript:;" aria-label="Previous"><span
                aria-hidden="true">&raquo;</span></a></li>
    </ul>
</nav>
<script>
    $(document).ready(function () {
        $("#prepage").click(function () {
            if ($(this).attr("class") == "disabled")
                return;
            location.href = "index.jsp?root=all&i=1&p=<%=pag-1%>";
        })
        $("#nextpage").click(function () {
            if ($(this).attr("class") == "disabled")
                return;
            location.href = "index.jsp?root=all&i=1&p=<%=pag+1%>";
        })

        $("tbody>tr").each(function () {
            var d = JSON.parse($(this).attr("data-click"));
            var maxmin = JSON.parse($(this).attr("maxmin"));
            console.log(d)
            var html = "";
            if (d[0] == null)
                html = '<label style="color: red">无考试记录</label>';
            else {
                var head = '<div class="table-responsive"><table class="table table-bordered" style="z-index: 9999"><thead><tr>' +
                        '<th>考卷号</th>' + '<th>学科</th>' +
                        '<th>状态</th>' +  '<th>试卷难度</th>' +
                        '<th>单选得分/总分/得分率</th>' +
                        '<th>多选得分/总分/得分率</th>' + '<th>判断得分/总分/得分率</th>' +
                        '<th>开始时间</th>' + '<th>用时(分钟)</th>' +
                        '<th>考试时间(分钟)</th>' +
                        '</tr> </thead>' +
                        '<tbody class="text-info">';
                var end='</tr></tbody></table></div>';
                html+=head;
                for(var i=0;i< d.length;i++){
                    if(d[i]._ok)
                        html+='<tr class="success"><td>'+ d[i].paper_id+'</td>';
                    else
                        html+='<tr class="danger"><td>'+ d[i].paper_id+'</td>';
                    html+='<td>'+ d[i].subject+'</td>';
                    html+='<td>'+ (d[i]._ok?"完成":"未完成") +'</td>';
                    html+='<td>'+ (d[i].paper_lev==0?'★★★':(d[i].paper_lev==1?'★★':'★')) +'</td>';
                    var per=(d[i].single_quess_score/d[i].single_quess_sum).toFixed(2)*100;
                    if(d[i].single_quess_score==0)
                        per=0;
                    if(per>=70)
                        html+='<td class="text-success">'+ d[i].single_quess_score+'/'+ d[i].single_quess_sum+'/'+per+'%</td>';
                    else
                        html+='<td style="color: red">'+ d[i].single_quess_score+'/'+ d[i].single_quess_sum+'/'+per+'%</td>';

                    var per=(d[i].muti_quess_score/d[i].muti_quess_sum).toFixed(2)*100;
                    if(d[i].muti_quess_score==0)
                        per=0;
                    if(per>=70)
                        html+='<td class="text-success">'+ d[i].muti_quess_score+'/'+ d[i].muti_quess_sum+'/'+per+'%</td>';
                    else
                        html+='<td style="color: red">'+ d[i].muti_quess_score+'/'+ d[i].muti_quess_sum+'/'+per+'%</td>';
                    var per=(d[i].judge_quess_score/d[i].judge_quess_sum).toFixed(2)*100;
                    if(d[i].judge_quess_score==0)
                        per=0;
                    if(per>=70)
                        html+='<td class="text-success">'+ d[i].judge_quess_score+'/'+ d[i].judge_quess_sum+'/'+per+'%</td>';
                    else
                        html+='<td style="color: red">'+ d[i].judge_quess_score+'/'+ d[i].judge_quess_sum+'/'+per+'%</td>';
                    html+='<td>'+ d[i].start_time+'</td>';
                    html+='<td>'+ d[i].spend_min+'</td>';
                    html+='<td>'+ maxmin[i]+'</td>';
                }
                html+=end;
            }
            console.log(html)
            $(this).popover({
                title:'最近 <lable>6</lable> 次考试记录预览',
                placement:'bottom',
                html:true,
                content:html,
                trigger:'click',
                container:'body'
            })
        });

    });

</script>