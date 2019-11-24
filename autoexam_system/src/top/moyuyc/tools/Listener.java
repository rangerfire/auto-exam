package top.moyuyc.tools;

import top.moyuyc.entity.Exam;
import top.moyuyc.entity.User;
import top.moyuyc.websocket.ChatServer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.*;

/**
 * Created by Yc on 2016/2/1 for autoexam_system.
 */
public class Listener implements ServletContextListener {
    private final String path = "/WEB-INF/chat.data";
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.err.println("server running!");
        String filePath = servletContextEvent.getServletContext().getRealPath(path);
        try {
            ChatServer.loadData(filePath);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.err.println("server ending!");
        String filePath = servletContextEvent.getServletContext().getRealPath(path);
        try {
            ChatServer.writeData(filePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}
