<%@ page import="top.moyuyc.entity.Exam" %>
<%@ page import="top.moyuyc.entity.SimpleTimeShow" %>
<%@ page import="top.moyuyc.jdbc.PaperAcess" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/23
  Time: 22:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(session.getAttribute("username")==null){
    return;
  }
  String isAsc=request.getParameter("isAsc");String order=request.getParameter("order");String pag=request.getParameter("p");
  if(isAsc==null) isAsc="false"; if(order==null) order="start_time";if(pag==null) pag="1";
  if(!order.equals("subject")&&!order.equals("paper_id")&&!order.equals("is_ok")&&!order.equals("start_time")&&!order.equals("spend_min"))
    order="start_time";
  try {
    if(Integer.parseInt(pag)<1) pag="1";
  } catch (NumberFormatException e) {
    pag="1";
    e.printStackTrace();
  }
  boolean isasc=Boolean.parseBoolean(isAsc); int pg=Integer.parseInt(pag);
  int pageSize=8;
  List<Exam> data= UserPaperAcess.getExamsByUserName(session.getAttribute("username").toString(), pg, pageSize, order, isasc);
%>

<%if(data!=null){%>
<%for(Exam exam : data){
  if(exam.is_ok()){%>
<tr class="success"><%}else{%>
<tr class="danger"><%}%>
  <td><%=exam.getPaper_id()%></td>
  <td><%=exam.getSubject()%></td>
  <td <%if(exam.is_ok()){%>class="text-success">完成</td>
  <%}else{%>style='color:red'>未完成</td><%}%>
  <%String[] ss={"★★★","★★","★"};%>
  <td><%=ss[PaperAcess.getPaperLevById(exam.getPaper_id())]%></td>
  <%float p=((float)(exam.getSingle_quess_score()/(float)(exam.getSingle_quess_sum())))*100;
    String result = String .format("%.0f",p);
    if(exam.getSingle_quess_sum()==0) result="0";
    if(p>=70){%>
  <td class="text-success"><%=exam.getSingle_quess_score()%>/<%=exam.getSingle_quess_sum()%>/<%=result%>%</td><%}else{%>
  <td style="color: red"><%=exam.getSingle_quess_score()%>/<%=exam.getSingle_quess_sum()%>/<%=result%>%</td>
  <%}%>
  <%p=((float)(exam.getMuti_quess_score()/(float)(exam.getMuti_quess_sum())))*100;
    result = String .format("%.0f",p);
    if(exam.getMuti_quess_sum()==0) result="0";
    if(p>=70){%>
  <td class="text-success"><%=exam.getMuti_quess_score()%>/<%=exam.getMuti_quess_sum()%>/<%=result%>%</td><%}else{%>
  <td style="color: red"><%=exam.getMuti_quess_score()%>/<%=exam.getMuti_quess_sum()%>/<%=result%>%</td>
  <%}%>
  <%p=((float)(exam.getJudge_quess_score()/(float)(exam.getJudge_quess_sum())))*100;
    result = String .format("%.0f",p);
    if(exam.getJudge_quess_sum()==0) result="0";
    if(p>=70){%>
  <td class="text-success"><%=exam.getJudge_quess_score()%>/<%=exam.getJudge_quess_sum()%>/<%=result%>%</td><%}else{%>
  <td style="color: red"><%=exam.getJudge_quess_score()%>/<%=exam.getJudge_quess_sum()%>/<%=result%>%</td>
  <%}%>
  <td class="text-center"><%=new SimpleTimeShow(exam.getStart_time(),SimpleTimeShow.PATTERN_0)%></td>
  <td><%=exam.getSpend_min()%></td>
  <td><%=PaperAcess.getMaxMinById(exam.getPaper_id())%></td>
  <td>
    <%if(exam.is_ok()){%>
    <button type="button" class="btn btn-sm btn-success" name="show_info" data-bind="<%=exam.getPaper_id()%>">查看详情</button>
    <%}else{%>
    <button type="button" class="btn btn-sm btn-primary" name="continue_test" data-bind="<%=exam.getPaper_id()%>">继续考试</button>
    <%}%>
  </td>
</tr>
<script>
  $("[name=continue_test]").click(function(){
    location.href="test?continue="+$(this).attr("data-bind");
  })
  $("[name=show_info]").click(function(){
    location.href="test?showall="+$(this).attr("data-bind");
  })
</script>
<%}}%>

