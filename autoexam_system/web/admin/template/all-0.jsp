<%@ page import="top.moyuyc.jdbc.QuesAcess" %>
<%@ page import="top.moyuyc.entity.Ques" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/25
  Time: 21:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  int pageSize=45;
  int pag=1;
  try {
    pag = request.getParameter("p") == null ? 1 : Integer.parseInt(request.getParameter("p"));
    if(pag<=0)
      pag=1;
  }catch (Exception e){
    e.printStackTrace();
    pag=1;
  }
  List<Ques> list=QuesAcess.getAllQuess(pag,pageSize,QuesAcess.QUES_ID,true);
  list=list==null?new LinkedList<Ques>():list;
  int num=QuesAcess.getQuesCount();
%>

<caption>一共有 <label id="table-num" class="text-info"><%=num%></label> 条记录，当前显示 <label id="cur-num" class="text-info"><%=list.size()%></label> 条记录</caption>
<br><span class='text-danger'>小提示：点击表头可排序哦！表格列宽也可以调整哦！</span>
<div style="overflow-y:scroll;height: 1000px;" class="table-responsive">
<table style=" width: 1800px; overflow-x: scroll;" cellspacing="0" class="tablesorter table-bordered">
<thead>
<tr>
  <th data-resizable-column-id="#">#</th>
  <th data-resizable-column-id="题号">题号</th>
  <th data-resizable-column-id="科目" style="width:100px;">科目</th>
  <th data-resizable-column-id="题型">题型</th>
  <th data-resizable-column-id="分值">分值</th>
  <th data-resizable-column-id="难度">难度</th>
  <th data-resizable-column-id="内容">内容</th>
  <th data-resizable-column-id="答案">答案</th>
  <th data-resizable-column-id="解析">解析</th>
</tr>
</thead>
<tbody style="overflow:auto;">
<%int j=1;for(Ques q : list){%>
<tr>
  <td><%=j++%></td>
  <td><%=q.getId()%></td>
  <td><%=q.getQues_subject()%></td><%
  String type="";
  if (q.getQues_type().equals("single_choose"))
    type="单选";
  else if (q.getQues_type().equals("muti_choose"))
    type="多选";
  else if (q.getQues_type().equals(QuesAcess.TYPE_JUDGE))
    type="判断";
  else if (q.getQues_type().equals(QuesAcess.TYPE_SHORTAN))
    type="简答";%>
  <td><%=type%></td>
  <td><%=q.getQues_score()%></td>
  <td><%=q.getLev()==0?"★★★":(q.getLev()==1?"★★":"★")%></td>
  <td style="word-wrap:break-word"><%if(q.getQues_type().equals("single_choose")||q.getQues_type().equals("muti_choose")){%>
    <select style="width: 100%"><%for(int i=0;i<q.getQues_content().size();i++){String temp="题ABCDEFGHIJK";String str=q.getQues_content().get(i); %>
    <option><%=temp.charAt(i)%>.<%=str%></option>
      <%}%>
    </select>
    <%}else %><%=q.getQues_content().get(0)%></td>
  <td style="word-break:break-all"><%=q.getQues_answer()==null?"暂无答案":q.getQues_answer().toString().substring(1, q.getQues_answer().toString().length() - 1)%></td>
  <td style="word-break:break-all;"><%=q.getQues_analy()==null?"暂无解析":q.getQues_analy()%></td>
</tr>
<%}%>
</tbody>
</table>
</div>
<hr>
<nav class="text-center">
  <ul class="pagination">
    <li id="prepage" <%if(pag==1){%>class="disabled"<%}%>><a href="javascript:;" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
    <%double f=Math.ceil((double) num / (double) pageSize);
      for(int i=1;i<=f;i++){%>
    <%if(i==pag){%>
    <li class="active"><a href="#"><%=i%><span class="sr-only">(current)</span></a></li>
    <%}else{%>
    <li><a href="index.jsp?root=all&i=0&p=<%=i%>"><%=i%><span class="sr-only">(current)</span></a></li>
    <%}}%>
    <li id="nextpage" <%if(f==pag){%>class="disabled" <%}%>><a href="javascript:;" aria-label="Previous"><span aria-hidden="true">&raquo;</span></a></li>
  </ul>
</nav>
<script>
  $(document).ready(function(){
    $("#prepage").click(function(){
      if($(this).attr("class")=="disabled")
        return;
      location.href="index.jsp?root=all&i=0&p=<%=pag-1%>";
    })
    $("#nextpage").click(function(){
      if($(this).attr("class")=="disabled")
        return;
      location.href="index.jsp?root=all&i=0&p=<%=pag+1%>";
    })
  });
</script>

<script>
  $("table").resizableColumns({ store: window.store});
</script>