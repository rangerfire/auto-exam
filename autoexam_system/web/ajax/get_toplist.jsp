<%@ page import="top.moyuyc.entity.UserPoint" %>
<%@ page import="top.moyuyc.jdbc.PointAcess" %>
<%@ page import="java.util.List" %>
<%@ page import="top.moyuyc.entity.User" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/27
  Time: 10:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String topfor = request.getParameter("top").toString();
  int topSize = 10, index = 1;
  if(request.getParameter("index")!=null)
    index = Integer.parseInt(request.getParameter("index"));
  List<UserPoint> l = null;
  if(topfor.equals("friend"))
    l = PointAcess.getFriendTopList(session.getAttribute("username").toString(), topSize, index);
  else
    l = PointAcess.getAllUserTopList(topSize, index);
  if(l==null) {
    out.print(-1);
    return;
  }
  String[] labels = {"danger","warning","info","default"};
  int i = (index-1)*topSize;
%>
<ul class="list-group">
  <%for(UserPoint up:l){
    String lab=i>2?labels[3]:labels[i];
  %>
  <li class="list-group-item">
    <div class="media" style="overflow: visible">
      <div class="pull-left text-success">
        <label class="label label-<%=lab%>">TOP <%=++i%></label>
      </div>
      <div class="media-body" style="overflow: visible">
        <div>&nbsp;&nbsp;&nbsp;
          <a href="infoshow?name=<%=up.getUser_name()%>" target="_blank">
          <img style="height: 32;width:32;border-radius: 50%;" class="img-hover" src="<%=Tools.getUserHeadPath(up.getUser_name(),config)%>"> <%=up.getUser_name()%></a>
          <span class="text-info pull-right">积分：<%=up.getPoint()%></span>
        </div>
      </div>
    </div>
  </li>
  <%}%>
</ul>