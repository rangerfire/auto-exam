<%@ page import="top.moyuyc.transaction.UserDataAnalysis" %>
<%@ page import="net.sf.json.JSONObject" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2015/9/19
  Time: 8:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .col-lg-2{width: 15%; }
  .col-lg-9{width: 80%;}
  ul.nav-pills {
    z-index:9999;
  }
  .ques-content1:hover{
    background-color: #dff0d8;
    cursor: pointer;
  }
  .ques-content2:hover{
    background-color: #d9edf7;
    cursor: pointer;
  }
  .ques-content3:hover{
    background-color:#fcf8e3;
    cursor: pointer;
  }
  /*.tb-lr{-webkit-writing-mode:vertical-lr;writing-mode:tb-rl;writing-mode:vertical-lr;}*/
  /*.no-tb-lr{-webkit-writing-mode:initial;writing-mode:initial;writing-mode:initial;}*/
</style>
<div class="container" id="progress1" style="display: none">
  <div class="progress">
    <div id="test_progress" class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="1"
         aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
      考试进行中...
    </div>
  </div>

</div>


<div style="" class="container" id="text_content">
  <nav id="myScrollspy" class="hidden-xs hidden-sm">
    <ul class="nav nav-pills nav-stacked" style="position: fixed; left:1%; top:26%;">
      <li>
        <a href="#single_panel" class="text-success">单选<span class="glyphicon glyphicon-menu-right"></span></a>
      </li><li>
      <a href="#muti_panel" class="text-info">多选<span class="glyphicon glyphicon-menu-right"></span></a>

    </li><li>
      <a href="#judge_panel" class="text-warning">判断<span class="glyphicon glyphicon-menu-right"></span></a>
    </li>
      <li>
        <a href="#sa_panel" class="text-danger">简答<span class="glyphicon glyphicon-menu-right"></span></a>
      </li>
    </ul>
  </nav>
  <div class="row">
  <div class="col-lg-8">
  <div style="display: none" class="text-primary" id="paper_id">考卷号&nbsp;&nbsp;&nbsp;&nbsp;：<span class="glyphicon glyphicon-star"></span>
    <label></label>
  </div>
  <div style="display: none" class="text-primary" id="paper_subject">考试科目：<label></label>
  </div>
  <div style="display: none" class="text-primary" id="paper_lev"><label></label></div>
  </div>
    <%if(request.getParameter("showall")!=null){%>
  <div class="col-lg-4">
    <div class="pull-right">
  <button type="button" style="vertical-align: bottom" id="test_emport" data-backdrop="static" class="btn btn-lg btn-primary"
          data-id="<%=request.getParameter("showall")%>" data-toggle="modal" data-target="#test_stra_modal"
          title="导出至本地Word">
    考卷导出
  </button>
  <button id="btn-fight"
          data-toggle="modal" data-target="#fight-Modal" class="btn btn-lg btn-danger" style="display:none;"
          title="pk积分只计算客观题">
    <span class="glyphicon glyphicon-fire"></span> 向好友宣战</button>
    </div>
  </div>
    <%}%>
  </div>

  <div class="alert alert-danger text-center" id="btn-alert" role="alert" style="display: none;">
    <button type="button" onclick="$(this).parent().slideUp('normal')" class="close" aria-label="Close"><span aria-hidden="true">×</span></button>
    <strong><big></big></strong></div>

  <%--charts--%>

  <%if(request.getParameter("showall")!=null){%>
  <hr>
  <div id="chart" style="height: 500px;width: 100%;"></div>
  <hr>
  <%}%>

  <br>
  <div class="panel panel-success" id="single_panel">
    <div id="single_panel_head" style="cursor: pointer">
      <h3 class="panel-title list-group-item list-group-item-success"><span id="singlenum" class="badge">0</span>单选题
      </h3>
    </div>
    <div class="panel-body" name="single_panel_body" id="single_body_template" style="display: none; line-height: 30px">
      <div class='row' >
        <div name="single_no" style="display: none;"></div>
        <div style="margin-left: 30px;" class="text-info" name="lev"></div>
        <div style="float: left" class='col-sm-2 text-right'><label name="single_score" ></label><label name="single_number" ></label></div>
        <div class='col-sm-9' name="content" style='font-size: 16px; display:block;word-break: normal;word-wrap: normal'></div>
      </div>
      <div class="row ques-content1" id="single_list_template" style="display: none; margin-left: 4%;margin-right: 4%;">
        <div style="float: left" class="col-sm-2 text-right"  name="radio">
          <label for="radio" name="tage">A</label><input id="radio" style="margin-left: 12px;" type="radio" />
        </div>
        <div style="float: left" class="col-xs-9" name="list" style='display:block;word-break: normal;word-wrap: normal'>
        </div>
      </div>
      <div id="single_end_template" class="panel panel-default" style="display: none; margin-left: 10%;padding-bottom: 2%; padding-top:2%;margin-right: 10%">
        <div class="panel_body">
          <div class="text-primary" style="padding-left: 8%;">
            <div name="analytag" style="margin-left: -5%;"><span class="glyphicon glyphicon-asterisk"></span><label> 解析：</label></div>
            <div name="analy" style='padding-right: 4%; font-size: 16px; display:block;word-break: normal;word-wrap: normal;'>sdsdsdsdsdsdsdsdsdssdsdsd</div>
          </div>
          <hr>
          <div style="padding-left: 8%;">
            <div name="answertag" style="margin-left: -5%;"><span class="glyphicon glyphicon-hand-right"></span><label> 答案：</label></div>
            <div name="answer" style='padding-right: 4%; font-size: 16px; display:block;word-break: normal;word-wrap: normal;'>sddaan sdsdsdsdsdsdsdssdsdsd</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="panel panel-info" id="muti_panel">
    <div id="muti_panel_head" style="cursor: pointer">
      <h3 class="panel-title list-group-item list-group-item-info"><span id="mutinum" class="badge">0</span>多选题
      </h3>
    </div>
    <div class="panel-body" name="muti_panel_body" id="muti_body_template" style="display: none; line-height: 30px">
      <div class='row' >
        <div name="muti_no" style="display: none"></div>
        <div style="margin-left: 30px;" class="text-warning" name="lev"></div>
        <div style="float: left" class='col-sm-2 text-right'><label name="muti_score"></label><label name="muti_number"></label></div>
        <div class='col-sm-9' name="content" style='font-size: 16px; display:block;word-break:normal;word-wrap: normal;'></div>
      </div>
      <div class="row ques-content2" id="muti_list_template" style="display: none; margin-left: 4%;margin-right: 4%">
        <div style="float: left" class="col-sm-2 text-right"  name="radio">
          <label for="radio" name="tage"></label><input id="checkbox" style="margin-left: 12px;" type="checkbox" />
        </div>
        <div class="col-xs-9" name="list" style='display:block;word-break: normal;word-wrap: normal;'>
        </div>
      </div>
      <div id="muti_end_template" class="panel panel-default" style="display: none; margin-left: 10%;padding-bottom: 2%; padding-top:2%;margin-right: 10%">
        <div class="panel_body">
          <div class="text-primary" style="padding-left: 8%;">
            <div name="analytag" style="margin-left: -5%;"><span class="glyphicon glyphicon-asterisk"></span><label> 解析：</label></div>
            <div name="analy" style='padding-right: 4%; font-size: 16px; display:block;word-break:normal;word-wrap: normal;'>sdsdsdsdsdsdsdsdsdssdsdsd</div>
          </div>
          <hr>
          <div style="padding-left: 8%;">
            <div name="answertag" style="margin-left: -5%;"><span class="glyphicon glyphicon-hand-right"></span><label> 答案：</label></div>
            <div name="answer" style='padding-right: 4%; font-size: 16px; display:block;word-break:normal;word-wrap: normal;'>sddaan sdsdsdsdsdsdsdssdsdsd</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="panel panel-warning" id="judge_panel">
    <div id="judge_panel_head" style="cursor: pointer">
      <h3 class="panel-title list-group-item list-group-item-warning"><span id="judgenum" class="badge">0</span>判断题
      </h3>
    </div>
    <%--moyujudge--%>
    <div class="panel-body" name="judge_panel_body" id="judge_body_template" style="display: none; line-height: 30px">
      <div class='row' >
        <div name="judge_no" style="display: none"></div>
        <div style="margin-left: 30px;" class="text-warning" name="lev"></div>
        <div style="float: left" class='col-sm-2 text-right'><label name="judge_score"></label><label name="judge_number"></label></div>
        <div class='col-sm-9' name="content" style='font-size: 16px; display:block;word-break: normal;word-wrap: normal;'></div>
      </div>

      <div class="row" id="judge_list_template" style="display: none;">
        <div class="" style=""  name="radio">
          <div id="ts"class="ques-content3" style="margin: 0px 6% 0px;padding-left: 10%">
            <input id="radio1" type="radio" value="T"/><label for="radio1" style="margin-left: 12px" name="tage"></label></div>
          <div class="ques-content3" style="margin: 0px 6% 0px; padding-left: 10%">
            <input id="radio2" type="radio" value="F" /><label style="margin-left: 12px" for="radio2" name="tage"></label></div>
        </div>
      </div>
      <div id="judge_end_template" class="panel panel-default" style="display: none; margin-left: 10%;padding-bottom: 2%; padding-top:2%;margin-right: 10%">
        <div class="panel_body">
          <div class="text-primary" style="padding-left: 8%;">
            <div name="analytag" style="margin-left: -5%;"><span class="glyphicon glyphicon-asterisk"></span><label> 解析：</label></div>
            <div name="analy" style='padding-right: 4%; font-size: 16px; display:block;word-break: normal;word-wrap: normal;'>sdsdsdsdsdsdsdsdsdssdsdsd</div>
          </div>
          <hr>
          <div style="padding-left: 8%;">
            <div name="answertag" style="margin-left: -5%;"><span class="glyphicon glyphicon-hand-right"></span><label> 答案：</label></div>
            <div name="answer" style='padding-right: 4%; font-size: 16px; display:block;word-break: normal;word-wrap: normal;'>sddaan sdsdsdsdsdsdsdssdsdsd</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="panel panel-danger" id="sa_panel">
    <div id="sa_panel_head" style="cursor: pointer">
      <h3 class="panel-title list-group-item list-group-item-danger"><span id="sanum" class="badge">0</span>简答题
      </h3>
    </div>
    <div class="panel-body" name="sa_panel_body" id="sa_body_template" style="display: none; line-height: 30px">
      <div class='row' >
        <div name="sa_no" style="display: none"></div>
        <div style="margin-left: 30px;" class="text-warning" name="lev"></div>
        <div style="float: left" class='col-sm-2 text-right'><label name="sa_score"></label><label name="sa_number"></label></div>
        <div class='col-sm-9' name="content" style='font-size: 16px; display:block;normal: break-all;word-wrap: normal;'></div>
      </div>
      <div class="row" id="sa_list_template" style="display: none; padding-left: 10%">
        <div style="float: left" class="text-right"  name="radio">
          <label style="float: left;" for="textarea" name="tage"></label>
          <textarea class="text-area form-control" style="float:left; width: 800px ;height: 100px " row="4" id="textarea" placeholder="简答"></textarea>
        </div>
      </div>
      <div id="sa_end_template" class="panel panel-default" style="display: none; margin-left: 10%;padding-bottom: 2%; padding-top:2%;margin-right: 10%">
        <div class="panel_body">
          <div class="text-primary" style="padding-left: 8%;">
            <div name="analytag" style="margin-left: -5%;"><span class="glyphicon glyphicon-asterisk"></span><label> 解析：</label></div>
            <div name="analy" style='padding-right: 4%; font-size: 16px; display:block;word-break: normal;word-wrap: normal;'>sdsdsdsdsdsdsdsdsdssdsdsd</div>
          </div>
          <hr>
          <div style="padding-left: 8%;">
            <div name="answertag" style="margin-left: -5%;"><span class="glyphicon glyphicon-hand-right"></span><label> 答案：</label></div>
            <div name="answer" style='padding-right: 4%; font-size: 16px; display:block;word-break: normal;word-wrap: normal;'>sddaan sdsdsdsdsdsdsdssdsdsd</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div id="test_timer" class="text-info tb-lr" style="position: fixed; top:20%; z-index:9999;right: 1%;">
    <span class="glyphicon glyphicon-time"></span><br/>
    剩<br/>
    余<br/>
    时<br/>
    间<br/>
    <span class="no-tb-lr" id="text_min"></span><br/>
    分<br/>
    <span class="no-tb-lr" id="text_sec"></span><br/>
    秒<br/>
  </div>
  <div class="text-right" id="test_start_btns" style="display: none">
    <button id="test_submit" class="btn btn-lg btn-success" type="button" data-toggle="tooltip" data-placement="top"
            title="提交试卷并评分。提交后您能够查看详情并导出为doc文件">交卷
    </button>
    <button id="test_save" class="btn btn-lg btn-danger" type="button" data-toggle="tooltip" data-placement="top"
            title="放弃考试。将会保存作答痕迹，方便下次继续作答">放弃
    </button>
  </div>
  <hr>
</div>
<div id="fight-Modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">

  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title text-center">选择好友</h5>
      </div>
      <div class="modal-body">
        <div id="magic1">
        </div>
      </div>

      <div class="modal-footer">
        <div id="tip-fightByUsers" class="alert alert-danger alert-dismissible fade in text-center" style="display: none;" role="alert">
          <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
          <strong></strong>
        </div>
        <button type="button" id="btn-fightByUsers" class="btn btn-danger">宣战！</button>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(){
    var w=$(".container").width();
    $("textarea[row='4']").css("width",w-120);
    $(window).on('resize', function () {
      var w=$(".container").width();
      $("textarea[row='4']").css("width",w-120);
    })
    $.ajax({method:'GET',url:'ajax/get_friends.jsp',data:{filter:true,paper:'<%=request.getParameter("showall")%>'}})
            .done(function (html) {
              json = JSON.parse(html);
            })
    $('#btn-fight').click(function () {
      var m = $('#magic1').magicSuggest({
        placeholder: '输入好友或选择好友',
        data: json,
        selectionRenderer: function(data){
          var img = data.head;
          var cls = Boolean(data.online)?'':'img-gray'
          return '<img class="'+cls+'" style="height:18;width:18;border-radius:50%;" src="' + img + '"/>' + data.name;
        },
        allowFreeEntries:false,
        disabledField:'disabled',
        noSuggestionText:'不存在 {{query}} 好友 :(',
        expandOnFocus:true,
        valueField:'name',
        autoSelect:true,
        renderer: function(data){
          var img = data.head;
          var cls = Boolean(data.online)?'':'img-gray'
          return '<div style="padding: 5px; overflow:hidden;">' +
                  '<div style="float: left;"><img class="'+cls+'" style="height:18;width:18;border-radius:50%;" src="' + img + '" /></div>' +
                  '<div style="float: left; margin-left: 5px">' +
                  '<div style="font-weight: bold; color: #333; font-size: 10px; line-height: 11px">' + data.name + '</div>' +
                  '</div>' +
                  '</div><div style="clear:both;"></div>'; // make sure we have closed our dom stuff
        }
      })
      $('#btn-fightByUsers').click(function () {
        var vs = m.getValue();
        var t= $('#tip-fightByUsers');
        if(vs.length==0){
          t.find('strong').text('请选择好友 :(');
          t.show('normal');
          return;
        }
        $.ajax({method:'POST',url:'ajax/start.jsp',data:{act:'fightByUsers',users: m.getValue(),paper:'<%=request.getParameter("showall")%>'}})
                .done(function (d) {
                  if(d==1){
                    t.find('strong').text('宣战成功！');
                    t.show('normal');
                  }else{
                    t.find('strong').text('宣战失败！');
                    t.show('normal');
                  }
                })
      })
    })
    <%if(request.getParameter("showall")!=null){%>
    var chart = echarts.init(document.getElementById('chart'));
    chart.showLoading('default',{
      text: '加载中...',
      color: '#c23531',
      textColor: '#000',
      maskColor: 'rgba(255, 255, 255, 0.8)',
      zlevel: 0
    });
    function datamap(data){
      var f = function (d,y,v) {
        for(var i =0;i<d.length;i++){
          d[i]=[d[i]-1,y,v];
        }
      }
      var g = function (d,y,v) {
        for(var i =0;i<d.length;i++){
          d[i]={name: '正确', value: v, coord:[d[i]-1,y]};
        }
      }
      f(data.single_easy,0,15);
      f(data.single_mid,0,20);
      f(data.single_hard,0,25);
      f(data.multi_easy,1,15);
      f(data.multi_mid,1,20);
      f(data.multi_hard,1,25);
      f(data.judge_easy,2,15);
      f(data.judge_mid,2,20);
      f(data.judge_hard,2,25);
      f(data.sa_easy,3,15);
      f(data.sa_mid,3,20);
      f(data.sa_hard,3,25);
      g(data.single_right,0,0);
      g(data.multi_right,1,0);
      g(data.judge_right,2,0);
    }
    function loadChart(data) {
      datamap(data);
      console.log(data);
      var option = {
        title: {
          bottom:0,
          text: '考卷可视化',
        },
        legend: {
          data: ['单选-困难','单选-适中','单选-简单','多选-困难','多选-适中','多选-简单','判断-困难','判断-适中','判断-简单','简答-困难','简答-适中','简答-简单'],
          left:'right'
        },
        toolbox: {
          show : true,
          feature : {
            mark : {show: true},
            dataView : {show: true, readOnly: true},
//            dataZoom: {show:true},
//            magicType: {show: true, type: ['stack']},
//            restore: {show:true},
            saveAsImage : {show: true}
          },
          bottom:'bottom'
        },
        tooltip: {
          position: 'top',
//          formatter: function (params) {
//            return params.value[2] + ' commits in ' + hours[params.value[0]] + ' of ' + days[params.value[1]];
//          }
        },
        grid: {
          left: 2,
          bottom: 10,
          right: 50,
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: function (max) {
            var r=[];
            for(var i=1;i<=max;i++){
              r[i-1]=i;
            }
            return r;
          }(data.max_num),
          boundaryGap: false,
          splitLine: {
            show: true,
            lineStyle: {
              color: '#ddd',
              type: 'dashed'
            }
          },
          axisLine: {
            show: false
          }
        },
        yAxis: {
          type: 'category',
          data: ['单选','多选','判断','简答'],
          axisLine: {
            show: false
          }
        },
        series: [
          {
            name: '单选-困难',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.single_hard
          },
          {
            name: '单选-适中',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.single_mid
          },
          {
            name: '单选-简单',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.single_easy
          },
          {
            name: '多选-困难',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.multi_hard
          },
          {
            name: '多选-适中',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.multi_mid
          },
          {
            name: '多选-简单',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.multi_easy
          },
          {
            name: '判断-困难',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.judge_hard
          },
          {
            name: '判断-适中',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.judge_mid
          },
          {
            name: '判断-简单',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.judge_easy
          },
          {
            name: '简答-困难',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.sa_hard
          },
          {
            name: '简答-适中',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.sa_mid
          },
          {
            name: '简答-简单',
            type: 'scatter',
            symbolSize: function (val) {
              return val[2];
            },
            data: data.sa_easy,
          },
          {
            name: '单选-正确',
            type: 'scatter',
            markPoint:{
              data: data.single_right
            }
          },{
            name: '多选-正确',
            type: 'scatter',
            markPoint:{
              data: data.multi_right
            }
          },{
            name: '判断-正确',
            type: 'scatter',
            markPoint:{
              data: data.judge_right
            }
          }
        ]
      };
      chart.setOption(option);
      chart.hideLoading();
    };


    loadChart(<%=JSONObject.fromObject(
    UserDataAnalysis.getUserDataAnalysis(
    session.getAttribute("username").toString(),request.getParameter("showall").toString()))%>);
    <%}%>
  })
</script>