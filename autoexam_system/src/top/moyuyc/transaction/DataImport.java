package top.moyuyc.transaction;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import top.moyuyc.jdbc.QuesAcess;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Yc on 2015/10/14.
 */
public class DataImport {
    public static void importData(String quesId,String quesNum,String pageIndex,int quesType) throws IOException{
        String url=String.format("http://apis.haoservice.com/lifeservice/exam/query?key=dcabfa6c677c4c43bbdfd5067b9517ea&" +
                "id=%s&pn=%S&rn=%s",quesId,pageIndex,quesNum);
        System.out.println(url);
        HttpURLConnection urlConnection = (HttpURLConnection)(new URL(url).openConnection());
        urlConnection.connect();
        BufferedReader reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
        String lines = reader.readLine();
        reader.close();
        urlConnection.disconnect();

        lines=lines.replaceAll("<[^>]*>", "");
        lines=lines.replaceAll("&nbsp;", " ");
        lines=lines.replaceAll("\n", "");

        JSONObject data=JSONObject.fromObject(lines);
        JSONArray resultall=JSONArray.fromObject(data.get("result"));
        for(Object object:resultall) {
            JSONObject result=JSONObject.fromObject(object);
            String subject = result.get("subjectName").toString();
            String question = result.get("question").toString();
            System.out.println("   "+question);
            String score = null;
            Pattern p = Pattern.compile("（.分）");
            Matcher m = p.matcher(lines);
            if (m.find())
                score = m.group().replaceAll("[（|）|分]","");
            question = question.replaceFirst("（[\\d]分）", "");
            question = question.replaceAll("[A-F]．", "###");
            String answer = result.get("answer").toString();
            String analy = result.get("resolve").toString();
            analy=analy.replaceFirst("试题分析：","");
            String[] typearr=new String[]{"single_choose","muti_choose","judgement","short_answer"};
            String type=typearr[quesType];
            System.out.println(subject);
            System.out.println(question.trim());
            System.out.println(score);
            System.out.println(type);
            System.out.println(answer);
            System.out.println(analy);

            //先打印看看是否格式正确，内容正确？然后再导入。
//            String id=null;
//            while(QuesAcess.checkQuesIsExitById(id=Tools.randUpperStr(2,9)));
//            QuesAcess.addQues(id,subject,type,Integer.parseInt(score)
//                        ,question,answer,analy,new Random().nextInt(3));
        }
    }
    public static void main(String[] args) throws IOException {
        //dcabfa6c677c4c43bbdfd5067b9517ea
        //String url = "http://apis.haoservice.com/lifeservice/exam/Catalog?key=dcabfa6c677c4c43bbdfd5067b9517ea";
        //id	String	是	试题分类ID
        //pn	String	否	页码（默认为第一页）
        //rn	String	否	每页返回记录条数（默认为30）

        importData("604","1","1",0);

    }
}
