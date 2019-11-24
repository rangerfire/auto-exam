package top.moyuyc.entity;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by Yc on 2015/12/12.
 */
public class SimpleTimeShow {
    private Calendar _thisDate;
    public static final String PATTERN_0 = "yyyy-MM-dd HH:mm:ss";
    public static final String PATTERN_1 = "yyyy-MM-dd";
    public static final String PATTERN_2 = "HH:mm";
    public static final String PATTERN_3 = "hh:mm";

    public SimpleTimeShow(String time,String pattern){
        Date date = null;
        try {
            date = new SimpleDateFormat(pattern).parse(time);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        _thisDate = Calendar.getInstance();
        _thisDate.setTime(date);
    }
    /**
     *
     * @return timStr 与今天相差天数 >0 在今天之后几天
     */
    private int compareToToday(){
        Calendar today = Calendar.getInstance();
        return _thisDate.get(Calendar.DAY_OF_YEAR)-today.get(Calendar.DAY_OF_YEAR);
    }

    @Override
    public String toString() {
        int v = compareToToday();
        boolean isPM = _thisDate.get(Calendar.AM_PM)==1;
        if(v==0){
            return "今天"+new SimpleDateFormat(PATTERN_2).format(_thisDate.getTime());
        }else{
            String[] ss = new String[]{"大前天","前天","昨天","今天","明天","后天","大后天"};
            if(v>=-3 && v<=3)
                return ss[v+3]+new SimpleDateFormat(PATTERN_2).format(_thisDate.getTime());
            else
                return new SimpleDateFormat(PATTERN_1).format(_thisDate.getTime());
        }
    }

    public static void main(String[] args) {
        System.out.println(new SimpleTimeShow("2016-02-27 13:43:09",PATTERN_0));
    }
}
