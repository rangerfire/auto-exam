<%@ page import="top.moyuyc.transaction.Transaction" %>
<%@ page import="net.sf.json.JSONObject" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/28
  Time: 18:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String user1 = request.getParameter("user1");
  String user2 = request.getParameter("user2");
  String paperID = request.getParameter("paperID");
  JSONObject object = Transaction.getCompareChart(user1,user2,paperID);
  if(object==null) {
    out.print("<h4>暂无数据</h4>");
    return;
  }
  int sum1 = Integer.parseInt(object.get("user1SingleScore").toString())+Integer.parseInt(object.get("user1MultiScore").toString())+Integer.parseInt(object.get("user1JudgeScore").toString());
  int sum2 = Integer.parseInt(object.get("user2SingleScore").toString())+Integer.parseInt(object.get("user2MultiScore").toString())+Integer.parseInt(object.get("user2JudgeScore").toString());
%>
<div id="<%=user1+user2+paperID%>" style="width: 620px;height:530px;"></div>

<script>
  $(function () {
    var w1 = $(".container").width();
    var w2 = $('body').prop('clientWidth');
    var w = w1>w2?w2:w1;
    var h = $('body').prop('clientHeight');
    var c = $('#<%=user1+user2+paperID%>');
    w = c.width()>w?w:c.width();
    h = c.height()>h?h:c.height();
    c.width(w-20).height(h-30);

    var chart = echarts.init(document.getElementById('<%=user1+user2+paperID%>'));
    chart.showLoading('default',{
      text: '加载中...',
      color: '#c23531',
      textColor: '#000',
      maskColor: 'rgba(255, 255, 255, 0.8)',
      zlevel: 0
    });
    setTimeout(function () {
      chart.setOption({
        title : {
          text: '考卷:<%=paperID%>,科目:<%=object.get("subject")%>,难度:<%=object.get("lev")%>',
          subtext:'<%=object.get("status").equals(1)?"胜者："+object.get("winname"):"平局"%>，<%=user1%>得分<%=sum1%>，<%=user2%>得分<%=sum2%>',
        },
        tooltip : {
          trigger: 'item'
        },
        legend: {
          data:['<%=user1%>','<%=user2%>'],
          bottom:'0'
        },
        toolbox: {
          show : true,
          feature : {
            dataZoom: {},
            dataView: {readOnly: true},
            magicType: {type: ['bar','line']},
            restore: {},
            saveAsImage: {}
          }
        },
        xAxis : [
          {
            type : 'category',
            data : ['单选','多选','判断']
          }
        ],
        yAxis : [
          {
            type : 'value',
            axisLabel : {
              formatter: '{value} 分'
            },
            max:<%=Math.max(sum1,sum2)%>
          }
        ],
        series : [
          {
            name:'<%=user1%>',
            type:'bar',
            data: [<%=object.get("user1SingleScore")%>,<%=object.get("user1MultiScore")%>,<%=object.get("user1JudgeScore")%>],
            markPoint : {
              data : [
                {type : 'max', name: '最大值'},
                {type : 'min', name: '最小值'}
              ]
            },
            markLine : {
              data : [
                {type : 'average', name: '平均值'},
              ]
            }
          },
          {
            name:'<%=user2%>',
            type:'bar',
            data: [<%=object.get("user2SingleScore")%>,<%=object.get("user2MultiScore")%>,<%=object.get("user2JudgeScore")%>],
            markPoint : {
              data : [
                {type : 'max', name: '最大值'},
                {type : 'min', name: '最小值'}
              ]
            },
            markLine : {
              data : [
                {type : 'average', name: '平均值'},
              ]
            }
          }
        ]
      });
      chart.hideLoading();
    },500);
  })

</script>