/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package top.moyuyc.websocket;

import net.sf.json.JSONObject;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Common Chat
 */
@ServerEndpoint(value = "/websocket/login",configurator=GetHttpSessionConfigurator.class)
public class LoginServer {

    private static final Log log = LogFactory.getLog(LoginServer.class);
    public static final Map<String,List<LoginServer>> online_connections = Collections.synchronizedMap(new HashMap<>());
    private String name;
    public Session session;
    public HttpSession httpSession;

    @OnOpen
    public void start(Session session,EndpointConfig config) {
        this.session = session;
        this.httpSession = (HttpSession)config.getUserProperties()
                .get(HttpSession.class.getName());
        this.name=(String) httpSession.getAttribute("username");
        //this.name = session.getRequestParameterMap().get("v").get(0);
        if(!online_connections.containsKey(this.name)) {
            List<LoginServer> l = new LinkedList<>();
            l.add(this);
            online_connections.put(this.name, l);

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("content",name);
            jsonObject.put("for","common");
            jsonObject.put("type", "welcome");
            jsonObject.put("onlinenum", online_connections.size());
            Set<String> set=online_connections.keySet();
            for(String s:set){
                List<LoginServer> list = online_connections.get(s);
                synchronized (list){
                    for(LoginServer cs:list)
                        try {
                            cs.session.getBasicRemote().sendText(jsonObject.toString());
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                }
            }
        }
        else {
            online_connections.get(this.name).add(this);
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("content","您已在线");
            jsonObject.put("type", "again");
            jsonObject.put("for","common");
            jsonObject.put("onlinenum", online_connections.size());
            try {
                session.getBasicRemote().sendText(jsonObject.toString());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
//        String message = String.format("* %s %s", nickname, "has joined.");
//        broadcast(message);
    }


    @OnClose
    public void end(Session session) {
        List<LoginServer> list=online_connections.get(this.name);
        if(list.size()==1)
            online_connections.remove(this.name);
        else
            list.remove(this);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("type", "exit");
        jsonObject.put("for", "common");
        jsonObject.put("content", this.name);
        jsonObject.put("onlionnum", online_connections.size());

        Set<String> set = online_connections.keySet();
        for(String name:set) {
            List<LoginServer> list1 = online_connections.get(name);
            synchronized (list1){
                for(LoginServer cs:list1){
                    try {
                        cs.session.getBasicRemote().sendText(jsonObject.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

    }


    @OnMessage
    public void incoming(String message) {
        if(httpSession.getAttribute("username")==null)
            try {
                session.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        // Never trust the client
        JSONObject jsonObject = JSONObject.fromObject(message);
        jsonObject.put("time",new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date()));
        jsonObject.put("type", "msg");
        jsonObject.put("for","common");
        jsonObject.put("content", jsonObject.get("content").toString());
        jsonObject.put("name", this.name);
        jsonObject.put("onlinenum", online_connections.size());
        Set<String> set = online_connections.keySet();
        for(String name:set) {
            List<LoginServer> list = online_connections.get(name);
            jsonObject.put("isSelf", this.name.equals(name));
            synchronized (list){
                for(LoginServer cs:list){
                    try {
                        cs.session.getBasicRemote().sendText(jsonObject.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        //broadcast(jsonObject.toString());
    }


    @OnError
    public void onError(Throwable t) throws Throwable {
        log.error("Chat Error: " + t.toString(), t);
        List<LoginServer> list=online_connections.get(this.name);
        if(list.size()==1)
            online_connections.remove(this.name);
        else
            list.remove(this);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("type", "again");
        jsonObject.put("for", "common");
        jsonObject.put("content", "连接中断啦！");
        jsonObject.put("onlionnum", online_connections.size());
        this.session.getBasicRemote().sendText(jsonObject.toString());
    }

    private static void o2obroadcast(String msg){

    }


    private static void broadcast(String msg) {

    }
}
