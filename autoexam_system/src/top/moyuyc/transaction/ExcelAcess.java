package top.moyuyc.transaction;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.*;
import top.moyuyc.jdbc.DataBase;
import top.moyuyc.tools.Tools;

import java.io.*;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.*;

/**
 * Created by Yc on 2015/9/27.
 */
public class ExcelAcess extends DataBase {
    public static int[] Import(String filename,String logpath) {
        int errNum = 0;
        int okNum = 0;
        try {
            InputStream file = new FileInputStream(filename);
            if (filename.endsWith(".xls")) {
                HSSFWorkbook wb = new HSSFWorkbook(file);
                if(conn==null || conn.isClosed())
                    conn = getConnInstance();
                conn.setAutoCommit(false);
                ps = conn.prepareStatement("INSERT INTO `questions` VALUES(?,?,?,?,?,?,?,?)");
                for (int k = 0; k < wb.getNumberOfSheets(); k++) {
                    HSSFSheet sh = wb.getSheetAt(k);
                    HSSFRow ro = null;
                    for (int i = 1; (ro = sh.getRow(i)) != null; i++) {
                        if (ro.getPhysicalNumberOfCells() > 7) {
                            errNum++;
                            continue;
                        }
                        Cell[] cells = new Cell[]{ro.getCell(0), ro.getCell(1), ro.getCell(2), ro.getCell(3), ro.getCell(4), ro.getCell(5),ro.getCell(6)};
                        cells[0].setCellType(HSSFCell.CELL_TYPE_STRING);
                        cells[1].setCellType(HSSFCell.CELL_TYPE_STRING);
                        cells[2].setCellType(HSSFCell.CELL_TYPE_STRING);
                        cells[3].setCellType(HSSFCell.CELL_TYPE_STRING);
                        cells[4].setCellType(HSSFCell.CELL_TYPE_STRING);
                        if(cells[6]!=null)
                            cells[6].setCellType(HSSFCell.CELL_TYPE_STRING);
                        if(cells[5]!=null)
                            cells[5].setCellType(HSSFCell.CELL_TYPE_STRING);
                        ps.setString(1, Tools.randUpperStr(2, 9));
                        ps.setString(2, cells[0].toString().trim());
                        ps.setString(3,cells[1].toString().trim());
                        ps.setInt(4, (int)Float.parseFloat(cells[3].toString()));
                        ps.setString(5, cells[4].toString().trim());
                        ps.setString(6,cells[5]==null?null:cells[5].toString().trim().equals("")?null:cells[5].toString().trim());
                        ps.setString(7, cells[6] == null ? null : cells[6].toString().trim().equals("") ? null : cells[6].toString().trim());
                        ps.setString(8, String.valueOf((int) Float.parseFloat(cells[2].toString())));
                        ps.addBatch();
                    }
                }
                int[] updateCounts = ps.executeBatch();
                conn.commit();
                for (int n : updateCounts)
                    if(n==0)
                        errNum++;
                    else
                        okNum++;
                int[] data= new int[]{errNum,okNum};
                writeLog(filename,data,logpath);
                return data;
            } else {
                XSSFWorkbook wb = new XSSFWorkbook(file);
                wb.setWorkbookType(XSSFWorkbookType.XLSX);
                if(conn==null || conn.isClosed())
                    conn = getConnInstance();
                conn.setAutoCommit(false);
                ps = conn.prepareStatement("INSERT INTO `questions` VALUES(?,?,?,?,?,?,?,?)");
                for (int k = 0; k < wb.getNumberOfSheets(); k++) {
                    XSSFSheet sh = wb.getSheetAt(k);
                    XSSFRow ro = null;
                    for (int i = 1; (ro = sh.getRow(i)) != null; i++) {
                        if (ro.getPhysicalNumberOfCells() > 7) {
                            errNum++;
                            continue;
                        }
                        Cell[] cells = new Cell[]{ro.getCell(0), ro.getCell(1), ro.getCell(2), ro.getCell(3), ro.getCell(4), ro.getCell(5),ro.getCell(6)};
                        try {
                            cells[0].setCellType(XSSFCell.CELL_TYPE_STRING);
                            cells[1].setCellType(XSSFCell.CELL_TYPE_STRING);
                            cells[2].setCellType(XSSFCell.CELL_TYPE_STRING);
                            cells[3].setCellType(XSSFCell.CELL_TYPE_STRING);
                            cells[4].setCellType(XSSFCell.CELL_TYPE_STRING);
                        }catch (NullPointerException ex){
                            break;
                        }
                        if(cells[6]!=null)
                            cells[6].setCellType(XSSFCell.CELL_TYPE_STRING);
                        if(cells[5]!=null)
                            cells[5].setCellType(XSSFCell.CELL_TYPE_STRING);
                        ps.setString(1, Tools.randUpperStr(2, 9));
                        ps.setString(2, cells[0].toString().trim());
                        ps.setString(3,cells[1].toString().trim());
                        ps.setInt(4, (int)Float.parseFloat(cells[3].toString()));
                        ps.setString(5, cells[4].toString().trim());
                        ps.setString(6,cells[5]==null?null:cells[5].toString().trim().equals("")?null:cells[5].toString().trim());
                        ps.setString(7, cells[6] == null ? null : cells[6].toString().trim().equals("") ? null : cells[6].toString().trim());
                        ps.setString(8, String.valueOf((int)Float.parseFloat(cells[2].toString())));
                        ps.addBatch();
                    }
                }
                int[] updateCounts = ps.executeBatch();
                conn.commit();
                for (int n : updateCounts)
                    if(n==0)
                        errNum++;
                    else
                        okNum++;
                int[] data= new int[]{errNum,okNum};
                writeLog(filename,data,logpath);
                return data;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            Close();
        }
    }
    private static void writeLog(String filename,int[]data,String logpath){
        File file=new File(filename);
        String name=file.getName();
        PrintWriter pw=null;
        try {
            File f=new File(logpath);
            pw = new PrintWriter(new FileWriter(f,true));
            pw.println(name+"###"+"errorNum:"+data[0]+",okNum:"+data[1]);
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(pw!=null)
                pw.close();
        }
    }

    public static void main(String[] args) {
        System.out.println(".sdsds".replaceAll("\\.","***"));
//        try {
//            Data1Parse();
//        } catch (IOException e) {
//            e.printStackTrace();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        Import("src/tt.xlsx","");
    }
    public static void Data1Parse() throws IOException, SQLException {
        XSSFWorkbook wb = new XSSFWorkbook("src/data1.xlsx");
        XSSFWorkbook wb1 = new XSSFWorkbook();
        XSSFSheet sheet=wb1.createSheet("sheet1");
        Row head=sheet.createRow(0);
        head.createCell(0).setCellValue("ques_subject");
        head.createCell(1).setCellValue("ques_type");
        head.createCell(2).setCellValue("ques_lev");
        head.createCell(3).setCellValue("ques_score");
        head.createCell(4).setCellValue("ques_content");
        head.createCell(5).setCellValue("ques_answer");
        head.createCell(6).setCellValue("ques_analy");
        int rowIndex=1;

        wb.setWorkbookType(XSSFWorkbookType.XLSX);
        Map<String,String> typeMap = new HashMap<>();
        Map<String,Integer>scoreMap=new HashMap<>();
        typeMap.put("选择题","single_choose");
        typeMap.put("解答题","short_answer");
        scoreMap.put("解答题",5);
        scoreMap.put("选择题",2);
        for (int k = 0; k < wb.getNumberOfSheets(); k++) {
            XSSFSheet sh = wb.getSheetAt(k);
            XSSFRow ro = null;
            for (int i = 1; (ro = sh.getRow(i)) != null; i++) {

                Cell[] cells = new Cell[]{ro.getCell(1), ro.getCell(2), ro.getCell(3)};
                cells[0].setCellType(HSSFCell.CELL_TYPE_STRING);
                cells[1].setCellType(HSSFCell.CELL_TYPE_STRING);
                cells[2].setCellType(HSSFCell.CELL_TYPE_STRING);
                if(cells[0].toString().equals("填空题"))
                    continue;
                System.out.println(cells[0].toString());
                XSSFRow row=sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue("计算机-操作系统");
                row.createCell(1).setCellValue(typeMap.get(cells[0].toString()));
                row.createCell(2).setCellValue((new Random().nextInt(3)));
                row.createCell(3).setCellValue(scoreMap.get(cells[0].toString()));
                String content=cells[1].toString();
                String answer=cells[2].toString();
                if(cells[0].toString().equals("选择题")){
                    content=content.replaceAll("[A-D]\\.","###");
                    content=content.replaceAll("[A-D]、","###");
                    content=content.replaceAll("[A-D]．","###");
                }else {//答： （1）
                    content=content.replaceAll("(?=（[1-9]）)","<br>");
                    answer=answer.replaceAll("(?=（[2-9]）)","<br>").replaceFirst("答：\\s*","");
                }
                row.createCell(4).setCellValue(content.trim());
                row.createCell(5).setCellValue(answer.trim());
                row.createCell(6).setCellValue("");

            }
        }
        OutputStream os=new FileOutputStream("src/out.xlsx");
        wb1.write(os);
        os.close();
    }
}
