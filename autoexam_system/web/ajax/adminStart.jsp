<%@ page import="top.moyuyc.transaction.Transaction" %>

<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="java.net.URLEncoder" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/25
  Time: 15:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(session.getAttribute("tryTimes")==null){
    session.setAttribute("tryTimes", 0);
  }else {
    int bf=(Integer)session.getAttribute("tryTimes");
    if(bf==5) {
      out.print(0);
      return;
    }
    session.setAttribute("tryTimes",bf+1);
  }
  String admin=request.getParameter("admin");
  String password=request.getParameter("password");
  boolean isRem = Boolean.parseBoolean(request.getParameter("remember"));
  if(admin!=null && password!=null){
    String path = getServletConfig().getServletContext().getRealPath("/WEB-INF/config/admin.properties");
    if(!Transaction.adminLogin(admin,password,path))
      out.print(-1);
    else {
      out.print(1);
      session.setAttribute("admin", true);
      session.removeAttribute("tryTimes");
      if(isRem) {//add cookie
        response.addCookie(Tools.getCookie("ADMIN_NAME", URLEncoder.encode(admin, "utf-8"), 7 * 24 * 3600, false));
        response.addCookie(Tools.getCookie("ADMIN_PWD", URLEncoder.encode(password, "utf-8"), 7 * 24 * 3600, false));
      }else{//delete cookie
        response.addCookie(Tools.getCookie("ADMIN_NAME", URLEncoder.encode(admin, "utf-8"), 0, false));
        response.addCookie(Tools.getCookie("ADMIN_PWD", URLEncoder.encode(password, "utf-8"), 0, false));
      }
    }
    return;
  }
  String act=request.getParameter("act");
  if(act!=null&&act.equals("exit")) {
    session.removeAttribute("admin");
    session.removeAttribute("tryTimes");
  }
%>