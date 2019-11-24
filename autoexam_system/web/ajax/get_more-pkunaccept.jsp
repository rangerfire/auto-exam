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
  Time: 10:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String me = session.getAttribute("username").toString();
  int size = Integer.parseInt(request.getParameter("size"));
  int index = Integer.parseInt(request.getParameter("index"));
  List<PKHistory> list = PKHistoryAcess.getUnAcceptPKHistorysByName(me, size, index);
  if(list==null){
    out.print(-1);
    return;
  }
  for(PKHistory pkHistory:list){
if(pkHistory.getUser2().equals(me)){%>
<p>
  <span class="glyphicon glyphicon-time"></span> <%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%>，来自<a target="_blank" href="infoshow?name=<%=pkHistory.getUser1()%>">
  <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser1(),config)%>"> <%=pkHistory.getUser1()%>
</a>
  的<button class="btn-link" role="link-paper" data-name="<%=pkHistory.getPaper_id()%>"><span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%></button>
  <%JSONObject object = new JSONObject();
    object.put("user",pkHistory.getUser1());
    object.put("paperID",pkHistory.getPaper_id());%>
  考卷挑战 <button class="btn btn-sm btn-success" role="btn-acceptpk" data-name='<%=object%>'>接受</button>
  <button role="btn-disagreepk" data-name='<%=object%>' class="btn btn-sm btn-danger">拒绝</button>
</p><%}else{%>
<p>
  <span class="glyphicon glyphicon-time"></span> <%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%>送至<a target="_blank" href="infoshow?name=<%=pkHistory.getUser2()%>">
  <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser2(),config)%>"> <%=pkHistory.getUser2()%>
</a>的
  <button class="btn-link" href="javascript:;"
     role="link-paper"
     data-name="<%=pkHistory.getPaper_id()%>">
    <span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%>
  </button>
  考卷挑战 <button role="btn-cancelunaccept"
        <%JSONObject object = new JSONObject();
          object.put("user",pkHistory.getUser2());
          object.put("paperID",pkHistory.getPaper_id());%>
               data-name='<%=object%>' class="btn btn-sm btn-danger">取消</button>
</p>
<%}%>
<%}%>