package top.moyuyc.transaction;

import net.sf.json.JSONObject;
import top.moyuyc.jdbc.PaperAcess;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by KingFish on 2016/2/27.
 */
public class UserDataAnalysis {
    public static Map<String,Object> getUserDataAnalysis(String username,String paperid){
//        Paper paper= PaperAcess.getPaperById(paperid, true);
        Map<String,Object> map =new HashMap<String,Object>();
        map.put("single_easy",PaperAcess.getListByQuest(paperid,"single_ques_lists","2"));
        map.put("single_mid", PaperAcess.getListByQuest(paperid,"single_ques_lists", "1"));
        map.put("single_hard",PaperAcess.getListByQuest(paperid, "single_ques_lists", "0"));

        map.put("single_right",PaperAcess.getListByRight(username,paperid, "single_ques_lists"));

        map.put("multi_easy",PaperAcess.getListByQuest(paperid, "muti_ques_lists", "2"));
        map.put("multi_mid",PaperAcess.getListByQuest(paperid, "muti_ques_lists", "1"));
        map.put("multi_hard",PaperAcess.getListByQuest(paperid, "muti_ques_lists", "0"));

        map.put("multi_right",PaperAcess.getListByRight(username,paperid, "muti_ques_lists"));

        map.put("judge_easy",PaperAcess.getListByQuest(paperid, "judge_ques_lists", "2"));
        map.put("judge_mid",PaperAcess.getListByQuest(paperid,"judge_ques_lists", "1"));
        map.put("judge_hard",PaperAcess.getListByQuest(paperid, "judge_ques_lists", "0"));

        map.put("judge_right",PaperAcess.getListByRight(username,paperid, "judge_ques_lists"));

        map.put("sa_easy",PaperAcess.getListByQuest(paperid,"sa_ques_lists", "2"));
        map.put("sa_mid",PaperAcess.getListByQuest(paperid,"sa_ques_lists", "1"));
        map.put("sa_hard",PaperAcess.getListByQuest(paperid, "sa_ques_lists", "0"));

        map.put("max_num",PaperAcess.getNumByPaperId(paperid));
        return map;
    }

    public static void main(String[] args) {
        System.out.println(JSONObject.fromObject(getUserDataAnalysis("111111", "DL1894")));
    }


}
