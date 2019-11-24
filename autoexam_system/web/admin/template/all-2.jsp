<%@ page import="java.util.List" %>
<%@ page import="top.moyuyc.jdbc.PaperAcess" %>
<%@ page import="top.moyuyc.entity.Paper" %>
<%@ page import="top.moyuyc.jdbc.QuesAcess" %>
<%@ page import="top.moyuyc.entity.Ques" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="net.sf.json.JSONArray" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/25
  Time: 21:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  int pageSize=12;
  int pag=1;
  try {
    pag = request.getParameter("p") == null ? 1 : Integer.parseInt(request.getParameter("p"));
    if(pag<=0)
      pag=1;
  }catch (Exception e){
    e.printStackTrace();
    pag=1;
  }
  List<Paper> list= PaperAcess.getAllPapers(pag,pageSize,"id",true);
  list=list==null?new LinkedList<Paper>():list;
  int num=PaperAcess.getPaperCount();
%>
<style>
  [data-popover]:hover{
    background-color:#c7ddef;
    cursor: pointer;
  }
</style>
<caption>一共有 <label id="table-num" class="text-info"><%=num%></label> 条记录，当前显示 <label id="cur-num" class="text-info"><%=list.size()%></label> 条记录</caption>
<br><span class='text-danger'>小提示：点击表头可排序哦！点击各题型可以查看详细内容！</span>
<div class="table-responsive">
<table style="table-layout: fixed;width: 1500px;" class="table table-hover text-center tablesorter">
  <thead>
  <tr>
    <th class="text-center" style="width: 50px;">#</th>
    <th class="text-center" style="width: 100px;">试卷号</th>
    <th class="text-center" style="width: 100px;">科目</th>
    <th class="text-center" style="width: 100px;">试卷难度</th>
    <th class="text-center" style="width: 120px;" >单选数量/总分</th>
    <th class="text-center" style="width: 150px;" >单选列表</th>
    <th class="text-center" style="width: 120px;">多选数量/总分</th>
    <th class="text-center" style="width: 150px;">多选列表</th>
    <th class="text-center" style="width: 120px;" >判断数量/总分</th>
    <th class="text-center" style="width: 150px;" >判断列表</th>
    <th class="text-center" style="width: 120px;" >简答数量/总分</th>
    <th class="text-center" style="width: 150px;" >简答列表</th>
    <th class="text-center" style="width: 150px;">考试时间(分钟)</th>
  </tr>
  </thead>
  <tbody>
  <%int j=1;for(Paper q : list){
    List<Ques> ques_list1=new LinkedList<Ques>();
    List<Ques> ques_list2=new LinkedList<Ques>();
    List<Ques> ques_list3=new LinkedList<Ques>();
    List<Ques> ques_list4=new LinkedList<Ques>();
    for(String s : q.getSingle_ques_lists()){
      ques_list1.add(QuesAcess.getQuesById(s));
    }for(String s : q.getMuti_ques_lists()){
      ques_list2.add(QuesAcess.getQuesById(s));
    }for(String s : q.getJudge_ques_lists()){
      ques_list3.add(QuesAcess.getQuesById(s));
    }for(String s : q.getSa_ques_lists()){
      ques_list4.add(QuesAcess.getQuesById(s));
    }
  %>
  <tr>
    <td><%=j++%></td>
    <td><%=q.getId()%></td>
    <td><%=q.getPaper_subject()%></td>
    <%int lev=PaperAcess.getPaperLevById(q.getId());%>
    <td ><%=lev==0?"★★★":(lev==1?"★★":"★")%></td>
    <%String ques=null;
      if(q.getSingle_ques_num()==0)
        ques="暂无";
      else
        ques=q.getSingle_ques_num()+"/"+q.getSingle_ques_score();
    %>
    <td data-popover='<%=JSONArray.fromObject(ques_list1).toString()%>'><%=ques%></td>
    <td>
    <%if(q.getSingle_ques_num()!=0){%>
      <select>
      <%for(String s : q.getSingle_ques_lists()){%>
      <option><%=s%></option>
      <%}%>
    </select><%}else{%>
      暂无
      <%}%></td>
    <%if(q.getMuti_ques_num()==0)
        ques="暂无";
      else
        ques=q.getMuti_ques_num()+"/"+q.getMuti_ques_score();
    %>
    <td data-popover='<%=JSONArray.fromObject(ques_list2).toString()%>'><%=ques%></td>
    <td>
      <%if(q.getMuti_ques_num()!=0){%>
      <select>
        <%for(String s : q.getMuti_ques_lists()){%>
        <option><%=s%></option>
        <%}%>
      </select><%}else{%>
      暂无
      <%}%></td>
    <%if(q.getJudge_ques_num()==0)
        ques="暂无";
      else
        ques=q.getJudge_ques_num()+"/"+q.getJudge_ques_score();
    %>
    <td data-popover='<%=JSONArray.fromObject(ques_list3).toString()%>'><%=ques%></td>
    <td>
      <%if(q.getJudge_ques_num()!=0){%>
      <select>
        <%for(String s : q.getJudge_ques_lists()){%>
        <option><%=s%></option>
        <%}%>
      </select><%}else{%>
      暂无
      <%}%></td>
    <%if(q.getSa_ques_num()==0)
        ques="暂无";
      else
        ques=q.getSa_ques_num()+"/"+q.getSa_ques_score();
    %>
    <td data-popover='<%=JSONArray.fromObject(ques_list4).toString()%>'><%=ques%></td>
    <td>
      <%if(q.getSa_ques_num()!=0){%>
      <select>
        <%for(String s : q.getSa_ques_lists()){%>
        <option><%=s%></option>
        <%}%>
      </select><%}else{%>
      暂无
      <%}%></td>
    <td><%=q.getMaxmin()%></td>
  </tr>
  <%}%>
  </tbody>
</table>
</div>
<div id="viewport"></div>
<hr>
<nav class="text-center">
  <ul class="pagination">
    <li id="prepage" <%if(pag==1){%>class="disabled"<%}%>><a href="javascript:;" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
    <%double f=Math.ceil((double) num / (double) pageSize);
      for(int i=1;i<=f;i++){%>
    <%if(i==pag){%>
    <li class="active"><a href="#"><%=i%><span class="sr-only">(current)</span></a></li>
    <%}else{%>
    <li><a href="index.jsp?root=all&i=2&p=<%=i%>"><%=i%><span class="sr-only">(current)</span></a></li>
    <%}}%>
    <li id="nextpage" <%if(f==pag){%>class="disabled" <%}%>><a href="javascript:;" aria-label="Previous"><span aria-hidden="true">&raquo;</span></a></li>
  </ul>
</nav>
<script>
  $(document).ready(function(){
    $("#prepage").click(function(){
      if($(this).attr("class")=="disabled")
        return;
      location.href="index.jsp?root=all&i=2&p=<%=pag-1%>";
    })
    $("#nextpage").click(function(){
      if($(this).attr("class")=="disabled")
        return;
      location.href="index.jsp?root=all&i=2&p=<%=pag+1%>";
    })
    $("[data-popover]").each(function(i){
      $(this).attr("index",i);
      var d=JSON.parse($(this).attr("data-popover"));
      console.log(d);
      var html="";
      if(d[0]==null)
        html="<label style='   color: red'>无题目列表</label>"
      else{
        var id="dy-table"+i;
        var head = '<div class="table-responsive"><table id="'+id+'" class="table table-bordered" style="width:800px; z-index: 9999"><thead><tr>' +
                '<th >题号</th>'+ '<th>难度</th>' + '<th>内容</th>' +
                '<th >答案</th>' + '<th>解析</th>' +
                '</tr> </thead>' +
                '<tbody class="text-info"><tr>';
        var end='</tr></tbody></table></div>';
        html+=head;
        for(var i=0;i< d.length;i++) {
          if(d[i]==null)
            continue;
          var t=null;
          if(d[i].ques_type=='single_choose' || d[i].ques_type=='muti_choose') {
            t='<select style="width: 100%;">'
            for (var j = 0; j < d[i].ques_content.length; j++) {
              var str = "题ABCDEFGHIJK";
              t +='<option>'+str[j]+'.'+d[i].ques_content[j]+'</option>';
            }
            t+='</select>'
          }
          else
            t=d[i].ques_content[0];
          var hide=i>4?' style="display:none;"':'';
          html += '<tr'+hide+'><td>'+d[i].id+'</td>'
                  +'<td>'+(d[i].lev==0?'★★★':(d[i].lev==1?'★★':'★'))+'</td>'
                  +'<td style="word-wrap: break-word">'+t+'</td>'
                  +'<td>'+(d[i].ques_answer.length==0?'暂无答案':d[i].ques_answer[0])+'</td>'
                  +'<td>'+(d[i].ques_analy==""?"暂无解析":d[i].ques_analy)+'</td></tr>'
        }
        html+=end;
        html+="<div class='text-center'><a href='javascript:;'>显示更多</a><div>"
      }
      $(this).popover({
        title:'试卷题目预览',
        placement:'bottom',
        html:true,
        content:html,
        trigger:'click',
        container:'body'
      }).on("shown.bs.popover",function(){
        console.log($(this))
        var index=$(this).attr("index");
        var tbody=$("#dy-table"+index).find("tbody");
        var trs=tbody.find("tr");
        var more=$("#dy-table"+index).next().find("a");
        more.click(function(){
          var shownum=0;
          trs.each(function(){
            if(shownum==5)
              return;
            if($(this).css("display")!='none')
              return;
            $(this).slideDown("normal");
            shownum++;
          })
        });
      });
    });
  });
</script>