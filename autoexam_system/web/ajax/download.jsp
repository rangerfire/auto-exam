<%@ page import="com.jspsmart.upload.SmartUpload" %>
<%@ page import="top.moyuyc.transaction.WordAcess" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.File" %>
<%@ page import="com.jspsmart.upload.SmartUploadException" %>
<%@ page import="java.io.IOException" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/10/11
  Time: 11:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%if(session.getAttribute("username")==null){
  return;
  }
  String id=request.getParameter("paperId");
  // 新建一个SmartUpload对象
  SmartUpload su = new SmartUpload();
// 初始化
  su.initialize(pageContext);
// 设定contentDisposition为null以禁止浏览器自动打开文件，
//保证点击链接后是下载文件。若不设定，则下载的文件扩展名为doc时，浏览器将自动用word打开它。
//扩展名为pdf时，浏览器将用acrobat打开。
  su.setContentDisposition(null);
// 下载文件，保证Web应用下的upload目录下有测试文档.doc文件。
  new File(getServletConfig().getServletContext().getRealPath("/download/" + id + ".doc")).delete();
  WordAcess.Export(id, getServletConfig().getServletContext().getRealPath("/WEB-INF/template.doc"),
            getServletConfig().getServletContext().getRealPath("/download/" + id + ".doc"));
  su.downloadFile("/download/" + id + ".doc");
%>
