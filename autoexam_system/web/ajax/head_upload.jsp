<%@ page import="sun.misc.BASE64Decoder" %>
<%@ page import="top.moyuyc.transaction.Transaction" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/27
  Time: 16:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="../error.jsp"%>
<%!
    private static boolean saveBase64ToFile(String base64, String filepath) throws IOException {
        if (base64 == null || !base64.startsWith("data:")) { // 图像数据为空
            return false;
        }
        String data = base64.split(",", 2)[1];
        BASE64Decoder decoder = new BASE64Decoder();
        byte[] bytes = decoder.decodeBuffer(data);
        FileOutputStream out = new FileOutputStream(filepath);
        out.write(bytes);
        out.flush();
        out.close();
        return true;
    }
%>
<%
    Object user = session.getAttribute("username");
    if(user==null)
        return;

    String filepath=getServletConfig().getServletContext().getRealPath("/userheads")+"/"+user+".jpg";
    InputStream is = request.getInputStream();
//  FileOutputStream fis = new FileOutputStream(new File("d://out.png"));
    byte[] b = new byte[1024];
    StringBuffer sb = new StringBuffer();
    int len;
    while ((len=is.read(b))!=-1) {
        sb.append(new String(b,0,len));
    }
    is.close();
    if(saveBase64ToFile(sb.toString(),filepath)) {
        Transaction.userUpdateHead(user.toString(), "userheads/"+user+".jpg");
        out.print(1);
    }else
        out.print(-1);
%>

<%/*
    int MAX_SIZE=1*1024*1024;
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
    su.setAllowedFilesList("jpg,jepg,gif,png,bmp");

    boolean sign = true;
    //4.设定禁止上传的文件（通过扩展名限制）
    try {
//        su.setDeniedFilesList("exe,bat,jsp,htm,html");
        //上传文件
        su.upload();
        //将上传文件保存到指定目录
        String ext=su.getFiles().getFile(0).getFileExt();
        String file = user.toString() + '.' + ext;
        filepath += File.separator + file;
        su.getFiles().getFile(0).saveAs(filepath);

        Transaction.userUpdateHead(user.toString(),"userheads/"+file);

    } catch (Exception e) {
        e.printStackTrace();
        sign = false;
    }
//    String ref = "<link rel=\"stylesheet\" href=\"../css/bootstrap.min.css\"><script src=\"../js/jquery-2.1.1.min.js\"></script>\n" + "<script src=\"../js/moyuDialog/dialog.js\"></script><script src=\"../js/bootstrap.min.js\"></script>";
    if (sign == true) {
        out.print("<script> $.moyuAlert('文件上传成功，请刷新该页 :)');</script>");
    } else {
        out.print("<script> $.moyuAlert('文件上传失败，可能是文件类型不正确或者大于1MB')</script>");
    }
    */

%>