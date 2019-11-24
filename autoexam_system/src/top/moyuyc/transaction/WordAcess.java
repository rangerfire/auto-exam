package top.moyuyc.transaction;

import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.usermodel.Paragraph;
import org.apache.poi.hwpf.usermodel.Range;
import top.moyuyc.entity.Paper;
import top.moyuyc.entity.Ques;
import top.moyuyc.jdbc.PaperAcess;
import top.moyuyc.jdbc.QuesAcess;
import top.moyuyc.jdbc.UserPaperAcess;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Yc on 2015/10/11.
 */
public class WordAcess {
    public static void Export(String paperId,String templatePath,String downPath) throws IOException {
        InputStream is = null;
        try {
            is = new FileInputStream(templatePath);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        Paper paper=PaperAcess.getPaperById(paperId, true);
        Map map=PaperAcess.getScoresById(paperId);
        HWPFDocument doc = new HWPFDocument(is);
        Range range = doc.getRange();

        range.replaceText("${paperId}",paper.getId());
        range.replaceText("${subject}",paper.getPaper_subject());
        range.replaceText("${paperLev}",paper.getPaper_lev()==0?"★★★":(paper.getPaper_lev()==1?"★★":"★★★"));
        range.replaceText("${emportDate}", new SimpleDateFormat("yyyy/MM/dd").format(new Date()));

        range.replaceText("${singleNum}",String.valueOf(paper.getSingle_ques_num()));
        range.replaceText("${multiNum}",String.valueOf(paper.getMuti_ques_num()));
        range.replaceText("${judgeNum}", String.valueOf(paper.getJudge_ques_num()));
        range.replaceText("${saNum}",String.valueOf(paper.getSa_ques_num()));

        range.replaceText("${singleScore}",String.valueOf(map.get("single"))+"分");
        range.replaceText("${multiScore}",String.valueOf(map.get("muti"))+"分");
        range.replaceText("${judgeScore}", String.valueOf(map.get("judge"))+"分");
        range.replaceText("${saScore}",String.valueOf(map.get("sa"))+"分");

        StringBuffer sb1=new StringBuffer();
        if(paper.getSingle_ques_num()!=0){
            int index=0;
            for(String id:paper.getSingle_ques_lists()){
                Ques ques=QuesAcess.getQuesById(id);
                sb1.append("("+ques.getQues_score()+"')"+(++index)+ "、").append(ques.getQues_content().get(0)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;", "<").replaceAll("&gt;", ">"));
                char ch='A';
                for(int j=1; j<ques.getQues_content().size();j++){
                    String choose = ques.getQues_content().get(j)
                            .replaceAll("<br>", "\r           ").replaceAll("&lt;", "<").replaceAll("&gt;",">");
                    sb1.append("\r    " +(ch++)+". "+choose);
                }
                sb1.append("\r" + "    解析： " + (ques.getQues_analy() == null ? "暂无解析" : ques.getQues_analy()
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;", ">")));
                sb1.append("\r"+"    答案： "+(ques.getQues_answer()==null?"暂无答案":ques.getQues_answer().get(0)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;",">")))
                        .append("\r");
            }
        }
        range.replaceText("${single}",sb1.toString().replaceAll("\n", ""));

        StringBuffer sb2=new StringBuffer();
        if(0!=paper.getMuti_ques_num()){
            int index=0;
            for(String id:paper.getMuti_ques_lists()){
                Ques ques=QuesAcess.getQuesById(id);
                sb2.append("("+ques.getQues_score()+"')"+(++index)+ "、").append(ques.getQues_content().get(0)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;", "<").replaceAll("&gt;", ">"));
                char ch='A';
                for(int j=1; j<ques.getQues_content().size();j++){
                    String choose = ques.getQues_content().get(j)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;", "<").replaceAll("&gt;",">");
                    sb2.append("\r    " +(ch++)+". "+choose);
                }
                String answer="";
                if(ques.getQues_answer()!=null){
                    for(String an:ques.getQues_answer()){
                        answer+=an;
                    }
                }
                sb2.append("\r" + "    解析： " + (ques.getQues_analy() == null ? "暂无解析" : ques.getQues_analy()
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;", ">")));
                sb2.append("\r"+"    答案： "+(ques.getQues_answer()==null?"暂无答案":answer
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;",">")))
                        .append("\r");
            }
        }
        range.replaceText("${multi}",sb2.toString().replaceAll("\n", ""));

        StringBuffer sb3=new StringBuffer();
        if(0!=paper.getJudge_ques_num()){
            int index=0;
            for(String id:paper.getJudge_ques_lists()){
                Ques ques=QuesAcess.getQuesById(id);
                sb3.append("("+ques.getQues_score()+"')"+(++index)+ "、").append(ques.getQues_content().get(0)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;",">"));
                sb3.append("\r" + "    解析： " + (ques.getQues_analy() == null ? "暂无解析" : ques.getQues_analy()
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;",">")));
                sb3.append("\r"+"    答案： "+(ques.getQues_answer()==null?"暂无答案"
                                        :ques.getQues_answer().get(0).equalsIgnoreCase("T")?"正确":"错误"))
                        .append("\r");
            }
        }
        range.replaceText("${judge}",sb3.toString().replaceAll("\n",""));

        StringBuffer sb4=new StringBuffer();
        if(0!=paper.getSa_ques_num()){
            int index=0;
            for(String id:paper.getSa_ques_lists()){
                Ques ques=QuesAcess.getQuesById(id);
                sb4.append("("+ques.getQues_score()+"')"+(++index)+ "、").append(ques.getQues_content().get(0)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;", "<").replaceAll("&gt;",">"));
                sb4.append("\r" + "    解析： " + (ques.getQues_analy() == null ? "暂无解析" : ques.getQues_analy()));
                sb4.append("\r"+"    答案： "+(ques.getQues_answer()==null?"暂无答案" : ques.getQues_answer().get(0)
                        .replaceAll("<br>", "\r           ").replaceAll("&lt;","<").replaceAll("&gt;",">")))
                        .append("\r");
            }
        }
        range.replaceText("${sa}",sb4.toString().replaceAll("\n",""));

        OutputStream os = null;
        try {
            os = new FileOutputStream(downPath);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        //把doc输出到输出流中
        try {
            doc.write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        os.close();
        is.close();
    }

    public static void main(String[] args) throws IOException {
        System.out.println("ss");
    }
}
