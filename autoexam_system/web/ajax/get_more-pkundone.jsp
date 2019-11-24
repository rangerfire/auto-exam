<%@ page import="top.moyuyc.entity.PKHistory" %>
<%@ page import="top.moyuyc.entity.SimpleTimeShow" %>
<%@ page import="top.moyuyc.jdbc.PKHistoryAcess" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/28
  Time: 12:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%int index = 1;
  String me = session.getAttribute("username").toString();
  int size = Integer.parseInt(request.getParameter("size"));
  int pageindex = Integer.parseInt(request.getParameter("index"));
  List<PKHistory> list = PKHistoryAcess.getUnDonePKHistorysByName(me, size, pageindex);
  if(list==null) {
    out.print(-1);
    return;
  }
  for (PKHistory pkHistory:list){
    String other = pkHistory.getUser1().equals(me)?pkHistory.getUser2():pkHistory.getUser1();
    boolean isOk = UserPaperAcess.getIs_OkByUserPaper(other, pkHistory.getPaper_id());
%>
<tr class="<%=isOk?"danger":"warning"%>">
  <th scope="row"><%=index++%></th>
  <td><button class="btn-link" role="link-paper" data-name="<%=pkHistory.getPaper_id()%>">
    <span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%></button></td>
  <td class="<%=pkHistory.getUser1().equals(me)?"text-danger":""%>">
    <a target="_blank" href="infoshow?name=<%=pkHistory.getUser1()%>">
      <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser1(),config)%>">
    </a><%=pkHistory.getUser1()%>
  </td>
  <td class="<%=pkHistory.getUser2().equals(me)?"text-danger":""%>">
    <a target="_blank" href="infoshow?name=<%=pkHistory.getUser2()%>">
      <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser2(),config)%>">
    </a><%=pkHistory.getUser2()%>
  </td>
  <td><%=isOk?"您未完成":"对方未完成"%></td>
  <td><%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%></td>
  <td><a target="_blank" href="test?<%=isOk?"continue":"showall"%>=<%=pkHistory.getPaper_id()%>" class="btn btn-sm btn-primary"
         role="btn-<%=isOk?"answer":"showinfo"%>"><%=isOk?"进行作答":"查看详情"%></a></td>
</tr>
<%}%>