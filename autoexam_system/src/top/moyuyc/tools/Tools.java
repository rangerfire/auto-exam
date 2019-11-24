package top.moyuyc.tools;


import top.moyuyc.entity.UserHead;
import top.moyuyc.jdbc.HeadAcess;

import javax.servlet.ServletConfig;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * Created by Yc on 2015/9/16.
 */
public class Tools {
    public static String getUserHeadPath(String username,ServletConfig config){
        UserHead head = HeadAcess.getHeadByName(username);
        return head!=null ? head.getPicPath()
                : config.getServletContext().getInitParameter("defaultHeadPath");
    }

    public static String likeStrFilter(String str){
        return str.replaceAll("([_%])","*$1");
    }
    public static Cookie getCookie(String key, String value,int maxage, boolean isSecure){
        Cookie c = new Cookie(key,value);
        c.setPath("/");
        c.setMaxAge(maxage);
        if(isSecure) {
            c.setHttpOnly(true);
            c.setSecure(true);
        }
        return c;
    }

    public static String findCookie(String key,HttpServletRequest request){
        Cookie[] cs = request.getCookies();
        if(cs==null)    return null;
        for (Cookie c : cs){
            if(c.getName().equals(key))
                return c.getValue();
        }
        return null;
    }

    /**
     * 前端的datetime（‘T’）转换为后端的时间日期（‘ ’）
     *
     * @param htmldate
     * @return yyyy-MM-dd HH:mm:ss
     */
    public static String htmlDateToWebDate(String htmldate) {
        return htmldate.replace('T', ' ');
    }

    /**
     * mysql中datetime到String
     *
     * @param mysqldate mysql数据库中的datetime类型数据
     * @return yyyy-MM-dd HH:mm:ss
     */
    public static String mySqlDateToWebDate(Date mysqldate) {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                .format(mysqldate);
    }

    public static String mySqlDateToWebDate2(Date mysqldate) {
        return new SimpleDateFormat("yyyy-MM-dd")
                .format(mysqldate);
    }
    /**
     * 后端的时间日期（‘ ’）转换为前端的datetime（‘T’）
     *
     * @param webdate
     * @return yyyy-MM-dd('T')HH:mm:ss
     */
    public static String webDateToHtmlDate(String webdate) {
        return webdate.replace(' ', 'T');
    }

    /**
     * 前端获取的参数编码转化，防止中文出现中文乱码
     *
     * @param parstr 参数字符串
     * @return utf-8
     */
    public static String ParToStr(String parstr) {
        try {
            return new String(parstr.getBytes("ISO-8859-1"), "utf-8");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 产生随机字符串 字母在前，数字在后
     *
     * @param letter_n 大写字母数目 >= 0
     * @param number_n 数字数目 >= 0
     * @return 随机产生的字符串
     */
    public static String randUpperStr(int letter_n, int number_n) {
        char[] letter_s = new char[letter_n];
        for (int i = 0; i < letter_n; i++) {
            letter_s[i] = (char) ('A' + new Random().nextInt(26));
        }
        char[] number_s = new char[number_n];
        for (int i = 0; i < number_n; i++) {
            number_s[i] = (char) ('0' + new Random().nextInt(10));
        }
        return new String(letter_s) + new String(number_s);
    }

    public static String ListToString(List list,String delim){
        if(list==null) return null;
        StringBuilder sb=new StringBuilder("");
        for(int i=0;i<list.size();i++){
            sb.append(list.get(i).toString());
            if(i!=list.size()-1)
                sb.append(delim);
        }
        return sb.toString();
    }
    public static List<String> StringToList(String src,String delim){
        if(src==null)   return null;
        return Arrays.asList(src.split(delim));
    }

    public static List ListCombine(List... lists){
        List out=new LinkedList<>();
        for(List list: lists){
            out.addAll(list);
        }
        return out;
    }



}
