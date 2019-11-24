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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;
import top.moyuyc.entity.UserHead;
import top.moyuyc.jdbc.HeadAcess;
import top.moyuyc.transaction.Transaction;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Common Chat
 */
@ServerEndpoint(value = "/websocket/chat",configurator=GetHttpSessionConfigurator.class)
public class ChatServer {

    private static final Log log = LogFactory.getLog(ChatServer.class);
    private static final String configPath = "/WEB-INF/config/chatrooms.properties";
    public static final Map<String,List<ChatServer>> connections = Collections.synchronizedMap(new HashMap<>());
    public static Map<String,Set<String>> rev_sender = new ConcurrentHashMap();
    public static Map<String,Set<String>> ignore_rev_sender = new ConcurrentHashMap();
    public static Map<String,Set<String>> pass_rev_sender= new ConcurrentHashMap();
    public static Map<String,List<JSONObject>> remain_msgs = new ConcurrentHashMap();

    private String name;
    public Session session;
    public HttpSession httpSession;



    public static void writeData(String path) throws IOException {
        ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(path));
        oos.writeObject(rev_sender);
        oos.writeObject(ignore_rev_sender);
        oos.writeObject(pass_rev_sender);

        Map<String,List<Object>> new_remain_msgs = new ConcurrentHashMap<>();
        for(String key:remain_msgs.keySet()){
            List<JSONObject> l = remain_msgs.get(key);
            List newl = new LinkedList<>();
            for(JSONObject jo:l)
                newl.add(jo.toString());
            new_remain_msgs.put(key,newl);
        }
        oos.writeObject(new_remain_msgs);

        oos.flush();
        oos.close();
    }
    public static void loadData(String path) throws IOException, ClassNotFoundException {
        ObjectInputStream ois = new ObjectInputStream(new FileInputStream(path));
        rev_sender = (Map<String, Set<String>>) ois.readObject();
        ignore_rev_sender = (Map<String, Set<String>>) ois.readObject();
        pass_rev_sender = (Map<String, Set<String>>) ois.readObject();
        Map<String,List> new_remain_msgs = (Map<String, List>) ois.readObject();
        ois.close();
        for(String key : new_remain_msgs.keySet()){
            List newl = new_remain_msgs.get(key);
            List<JSONObject> l = new LinkedList<>();
            for(Object o:newl)
                l.add(JSONObject.fromObject(o));
            remain_msgs.put(key,l);
        }

    }
    @OnOpen
    public void start(Session session,EndpointConfig config) {
        HttpSession s1 = (HttpSession)config.getUserProperties()
                .get(HttpSession.class.getName());
        if(s1.getAttribute("username")==null) {
            try {
                session.close();
                return;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        this.session = session;
        this.httpSession = s1;
        this.name = (String )s1.getAttribute("username");
        String tag = session.getRequestParameterMap().get("tag").get(0);
        if(tag.equals("chat")) {
            if (!connections.containsKey(this.name)) {
                List<ChatServer> l = new LinkedList<>();
                l.add(this);
                connections.put(this.name, l);
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("content", name);
                jsonObject.put("for", "common");
                jsonObject.put("type", "welcome");
                jsonObject.put("onlinenum", connections.size());
                Set<String> set = connections.keySet();
                for (String s : set) {
                    List<ChatServer> list = connections.get(s);
                    synchronized (list) {
                        for (ChatServer cs : list)
                            try {
                                cs.session.getBasicRemote().sendText(jsonObject.toString());
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                    }
                }
            } else {
                connections.get(this.name).add(this);
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("content", "您已在线");
                jsonObject.put("type", "again");
                jsonObject.put("for", "common");
                jsonObject.put("onlinenum", connections.size());
                try {
                    session.getBasicRemote().sendText(jsonObject.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            broadNotify(this.name);
        }else if(tag.equals("login")){
            JSONObject jsonObject = new JSONObject();
            if (!connections.containsKey(this.name)) {
                List<ChatServer> l = new LinkedList<>();
                l.add(this);
                connections.put(this.name, l);
            }else{
                connections.get(this.name).add(this);
            }

            broadNotify(this.name);
        }
    }

    public static void broadNotify(String name){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("notify-add", JSONArray.fromObject(ChatServer.rev_sender.get(name)));
        jsonObject.put("notify-ignore", JSONArray.fromObject(ChatServer.ignore_rev_sender.get(name)));
        jsonObject.put("notify-pass", (ChatServer.pass_rev_sender.get(name)!=null&&!ChatServer.pass_rev_sender.get(name).isEmpty()));
        jsonObject.put("notify-remainMsg", ChatServer.remain_msgs.get(name));
        List<ChatServer> l = ChatServer.connections.get(name);
        if(l!=null) {
            synchronized (l) {
                for (ChatServer cs : l) {
                    try {
                        cs.session.getBasicRemote().sendText(jsonObject.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
    @OnClose
    public void end(Session session) {
        List<ChatServer> list=connections.get(this.name);
        if(list!=null&&list.size()==1)
            connections.remove(this.name);
        else if(list!=null)
            list.remove(this);
//
//        JSONObject jsonObject = new JSONObject();
//        jsonObject.put("type", "exit");
//        jsonObject.put("for", "common");
//        jsonObject.put("content", this.name);
//        jsonObject.put("onlionnum", connections.size());
//
//        Set<String> set = connections.keySet();
//        for(String name:set) {
//            if(name.equals(this.name))  continue;
//            List<ChatServer> list1 = connections.get(name);
//            broadList(list1,jsonObject);
//        }

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
        boolean isToCommon = true;
        JSONObject jsonObject = JSONObject.fromObject(message);
        if(!(jsonObject.get("action")!=null && jsonObject.get("action").equals("refreshNotify"))) {
            jsonObject.put("time", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS").format(new Date()));
            jsonObject.put("type", "msg");
            if(jsonObject.get("to")!=null) {
                if (jsonObject.get("to").equals("common")) {
                    jsonObject.put("for", "common");
                    jsonObject.put("onlinenum", connections.size());
                    isToCommon=true;
                } else{
                    jsonObject.put("for", "o2o");
                    isToCommon=false;
                }
            }
            jsonObject.put("content", jsonObject.get("content").toString());
            jsonObject.put("name", this.name);
            if(isToCommon) {
                Set<String> set = connections.keySet();
                for (String name : set) {
                    List<ChatServer> list = connections.get(name);
                    boolean f = this.name.equals(name);
                    jsonObject.remove("to");
                    jsonObject.put("isSelf", f);
                    UserHead uh = HeadAcess.getHeadByName(this.name);
                    if (!f) jsonObject.put("head", uh == null ?
                            httpSession.getServletContext().getInitParameter("defaultHeadPath") : uh.getPicPath());
                    broadList(list,jsonObject);
                }
            }else {
                String to = jsonObject.get("to").toString();

                List<ChatServer> list = connections.get(this.name);
                jsonObject.put("isSelf", true);
                broadList(list, jsonObject);

                list = connections.get(to);
                jsonObject.put("isSelf", false);
                UserHead uh = HeadAcess.getHeadByName(this.name);
                jsonObject.put("head", uh == null ?
                        httpSession.getServletContext().getInitParameter("defaultHeadPath") : uh.getPicPath());
                if(list==null){
                    List<JSONObject> jsons = remain_msgs.get(to);
                    if(jsons==null)
                        jsons = new LinkedList<>();
                    jsons.add(jsonObject);
                    remain_msgs.put(to,jsons);
                }else
                    broadList(list,jsonObject);
            }
        }else{
            String type = jsonObject.get("type").toString();
            String data = jsonObject.get("data")!=null?jsonObject.get("data").toString():"";
            if(type.equals("agree")){
                Transaction.userAgreeAddFriendQuery(this.name, data);
                broadNotify(data);
            }else if(type.equals("agreeAll")){
                Transaction.userAgreeAllAddFriendQuery(this.name);

            } else if (type.equals("refuse")) {
                Transaction.userRefuseAddFriendQuery(this.name, data);
                broadNotify(data);
            }else if(type.equals("refuseAll")){
                Set<String> list = rev_sender.get(this.name);
                for (String str:list){
                    broadNotify(str);
                }
                Transaction.userRefuseAllAddFriendQuery(this.name);
            }else if(type.equals("ignore_passAll")){
                Transaction.userHandleAllIgnoreQuery(this.name);
                Transaction.userHandleAllPassQuery(this.name);
                broadNotify(this.name);
            }

        }
        //broadcast(jsonObject.toString());
    }


    @OnError
    public void onError(Throwable t) throws Throwable {
        log.error("Chat Error: " + t.toString(), t);
        List<ChatServer> list=connections.get(this.name);
        if(list.size()==1)
            connections.remove(this.name);
        else
            list.remove(this);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("type", "again");
        jsonObject.put("for", "common");
        jsonObject.put("content", "连接中断啦！");
        jsonObject.put("onlionnum", connections.size());
        this.session.getBasicRemote().sendText(jsonObject.toString());
    }

    private static void o2obroadcast(String msg){

    }



    private static void broadList(List<ChatServer> list,JSONObject jsonObject) {
        if (list != null)
            synchronized (list) {
                for (ChatServer cs : list) {
                    try {
                        cs.session.getBasicRemote().sendText(jsonObject.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
    }
}
