package top.moyuyc.transaction;

import top.moyuyc.jdbc.UserAcess;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;


public class SendMail {
    private static String newPwd() {//8wei
        String pwd = "";
        for (int i = 0; i < 8; i++)
            pwd += (int) (Math.random() * 10);
        return pwd;
    }



    public static boolean SendNewPw(String name, String email, String path) {
        String smtphost = null;
        String user = null;
        String password = null;
        String from = null;
        String to = email;
        if (to == null) return false;
        String subject = null;
        String newpw = newPwd();
        Properties pro = new Properties();
        try {
            pro.load(new FileInputStream(path));
            smtphost = pro.getProperty("mail.smtp");
            user = pro.getProperty("mail.user");
            password = pro.getProperty("mail.password");
            from = pro.getProperty("mail.sender");
            subject = pro.getProperty("mail.subject");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", smtphost);
            props.put("mail.smtp.auth", "true");
            Session session = Session.getDefaultInstance(props, null);
            session.setDebug(true);
            MimeMessage message = new MimeMessage(session);
            InternetAddress fromAddress = new InternetAddress(from);
            message.setFrom(fromAddress);
            InternetAddress toAddress = new InternetAddress(to);
            message.addRecipient(Message.RecipientType.TO, toAddress);
            message.setSubject(subject);
            message.setText("尊敬的&nbsp;<span style='color:red'>" + name + "</span>&nbsp;用户，您好！<br>"
                    + "您的新密码为"
                    + ": &nbsp;&nbsp;<span style='color:red'>"
                    + newpw + "</span>", "utf-8", "html");
            Transport transport = session.getTransport("smtp");
            transport.connect(smtphost, user, password);
            transport.sendMessage(message, message.getAllRecipients());
            transport.close();
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        UserAcess.updateUserPwdbyName(name, newpw);
        return true;
    }

    public static boolean SendWelCome(String name, String email, String path) {
        String smtphost = null;
        String user = null;
        String password = null;
        String from = null;
        String to = email;
        if (to == null) return false;
        String subject = null;
        Properties pro = new Properties();
        try {
            pro.load(new FileInputStream(path));
            smtphost = pro.getProperty("mail.smtp");
            user = pro.getProperty("mail.user");
            password = pro.getProperty("mail.password");
            from = pro.getProperty("mail.sender");
            subject = pro.getProperty("mail.subject");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", smtphost);
            props.put("mail.smtp.auth", "true");
            Session session = Session.getDefaultInstance(props, null);
            session.setDebug(true);
            MimeMessage message = new MimeMessage(session);
            InternetAddress fromAddress = new InternetAddress(from);
            message.setFrom(fromAddress);
            InternetAddress toAddress = new InternetAddress(to);
            message.addRecipient(Message.RecipientType.TO, toAddress);
            message.setSubject(subject);
            message.setText("尊敬的&nbsp;<span style='color:red'>" + name + "</span>&nbsp;用户，您好！<br>"
                    + "&nbsp;&nbsp;欢迎您使用我们的产品", "utf-8", "html");
            Transport transport = session.getTransport("smtp");
            transport.connect(smtphost, user, password);
            transport.sendMessage(message, message.getAllRecipients());
            transport.close();
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
