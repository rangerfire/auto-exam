<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.entity.PKHistory" %>
<%@ page import="top.moyuyc.entity.SimpleTimeShow" %>
<%@ page import="top.moyuyc.jdbc.PKHistoryAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/28
  Time: 10:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%int index=1;
  String me = session.getAttribute("username").toString();
  int size = Integer.parseInt(request.getParameter("size"));
  int pageindex = Integer.parseInt(request.getParameter("index"));
  List<PKHistory> list = PKHistoryAcess.getDonePKHistorysByName(me, size, pageindex);
  if(list==null) {
    out.print(-1);
    return;
  }
  for (PKHistory pkHistory:list){
    String cls = pkHistory.getStatus()==2?"active":(pkHistory.getWin_name().equals(me)?"success":"warning");%>
<tr class="<%=cls%>">
  <th scope="row"><%=index++%></th>
  <td><button class="btn-link" role="link-paper" data-name="<%=pkHistory.getPaper_id()%>"><span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%></button></td>
  <td><a target="_blank" href="infoshow?name=<%=pkHistory.getUser1()%>">
    <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser1(),config)%>">
  </a><%=pkHistory.getUser1()%></td>
  <td><a target="_blank" href="infoshow?name=<%=pkHistory.getUser2()%>">
    <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser2(),config)%>">
  </a><%=pkHistory.getUser2()%></td>
  <td><%=pkHistory.getInc_point()>0?"+"+pkHistory.getInc_point():pkHistory.getInc_point()%>/<%=pkHistory.getDec_point()%></td>
  <td><%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%></td>
  <td><button class="btn btn-sm btn-primary" role="btn-contact"
          <%JSONObject object = new JSONObject();
            object.put("user1",pkHistory.getUser1());object.put("user2",pkHistory.getUser2());
            object.put("paperID",pkHistory.getPaper_id());%>
              data-name='<%=object%>'>对比查看</button></td>
  <td><a href="test?showall=<%=pkHistory.getPaper_id()%>" target="_blank" class="btn btn-sm btn-default">查看</a></td>
</tr>
<%}%>