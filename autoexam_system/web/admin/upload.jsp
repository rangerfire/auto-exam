<%@ page import="com.jspsmart.upload.SmartUpload" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="top.moyuyc.transaction.ExcelAcess" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/27
  Time: 16:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="../WEB-INF/error.jsp"%>
<%
    if(session.getAttribute("admin")==null)
        return;

    String filepath=getServletConfig().getServletContext().getRealPath("/admin/upload");
    final String logpath=getServletConfig().getServletContext().getRealPath("/admin")+File.separator+"log.txt";
    int MAX_SIZE=5*1024*1024;
    //新建一个SmartUpload对象
    SmartUpload su = new SmartUpload();
    //上传初始化
    su.initialize(pageContext);
    // 设定上传限制
    //1.限制每个上传文件的最大长度。
    su.setMaxFileSize(MAX_SIZE);

    //2.限制总上传数据的长度。
    su.setTotalMaxFileSize(MAX_SIZE);

    //3.设定允许上传的文件（通过扩展名限制）
    su.setAllowedFilesList("xls,xlsx");

    boolean sign = true;
    String file=null;
    //4.设定禁止上传的文件（通过扩展名限制）
    try {
//        su.setDeniedFilesList("exe,bat,jsp,htm,html");
        //上传文件
        su.upload();
        //将上传文件保存到指定目录
        String ext=su.getFiles().getFile(0).getFileExt();
        file=filepath + File.separator
                + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.' + ext;
        su.getFiles().getFile(0).saveAs(file);
//        su.save(filepath);
    } catch (Exception e) {
        e.printStackTrace();
        sign = false;
    }
    if (sign == true) {
        final String fileclone=file;
        Thread th=new Thread(){
            @Override
            public void run() {
                ExcelAcess.Import(fileclone,logpath);
            }
        };
        th.start();
        out.print("<script> $.moyuAlert('文件上传成功')</script>");
    } else {
        out.print("<script> $.moyuAlert('文件上传失败，可能是文件类型不正确或者大于5MB')</script>");
    }
%>