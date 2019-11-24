<%@ page import="top.moyuyc.entity.PKHistory" %>
<%@ page import="top.moyuyc.entity.Paper" %>
<%@ page import="top.moyuyc.entity.SimpleTimeShow" %>
<%@ page import="top.moyuyc.jdbc.PKHistoryAcess" %>
<%@ page import="top.moyuyc.jdbc.PaperAcess" %>
<%@ page import="top.moyuyc.jdbc.PointAcess" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="java.util.List" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.transaction.Transaction" %>
<%--
  Created by IntelliJ IDEA.
  User: Yc
  Date: 2016/2/27
  Time: 14:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String me = session.getAttribute("username").toString();
  int size = 4;
%>

<div>
  <p>
    <span class="glyphicon glyphicon-star"></span> 我的积分: <span class="text-primary"><%=PointAcess.getPointByName(me)%></span>
  </p>
  <p>
    <i class="am-icon-trophy"></i> 好友排名: <span class="text-danger"><%=1+PointAcess.getBeforeCountFriendByName(me)%></span>
  </p>
  <p>
    <i class="am-icon-trophy"></i> 世界排名: <span class="text-danger"><%=1+PointAcess.getBeforeCountAllByName(me)%></span>
  </p>
  <div id="tip-pk" class="alert alert-info alert-dismissible fade in text-center" style="display: none;" role="alert">
    <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
    <strong></strong>
  </div>
  <p><label class="label label-primary">未接受战书</label></p>
  <%List<PKHistory> list = PKHistoryAcess.getUnAcceptPKHistorysByName(me, size, 1);
    if(list!=null){
      out.print("<div data-target=\"more-pkunaccept\" class=\"col-sm-offset-1\">");
      for(PKHistory pkHistory:list){
      if(pkHistory.getUser2().equals(me)){%>
      <p>
        <span class="glyphicon glyphicon-time"></span> <%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%>，来自<a target="_blank" href="infoshow?name=<%=pkHistory.getUser1()%>">
        <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser1(),config)%>"> <%=pkHistory.getUser1()%>
        </a>
        的<button class="btn-link" role="link-paper" data-name="<%=pkHistory.getPaper_id()%>"><span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%></button>
        <%JSONObject object = new JSONObject();
          object.put("user",pkHistory.getUser1());
          object.put("paperID",pkHistory.getPaper_id());%>
        考卷挑战 <button class="btn btn-sm btn-success" role="btn-acceptpk" data-name='<%=object%>'>接受</button>
        <button role="btn-disagreepk" data-name='<%=object%>' class="btn btn-sm btn-danger">拒绝</button>
      </p><%}else{%>
      <p>
        <span class="glyphicon glyphicon-time"></span> <%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%>，送至<a target="_blank" href="infoshow?name=<%=pkHistory.getUser2()%>">
        <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser2(),config)%>"> <%=pkHistory.getUser2()%>
      </a>的
        <a class="btn-link" href="javascript:;"
           role="link-paper"
           data-name="<%=pkHistory.getPaper_id()%>">
          <span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%>
          </a>
          考卷挑战 <button role="btn-cancelunaccept"
              <%JSONObject object = new JSONObject();
                object.put("user",pkHistory.getUser2());
                object.put("paperID",pkHistory.getPaper_id());%>
                       data-name='<%=object%>' class="btn btn-sm btn-danger">取消</button>
      </p>
      <%}%>
    <%}%>
  </div>
    <p class="text-center"><a href="javascript:;" class="btn-link small" id="more-pkunaccept" data-name="1">查看更多...</a></p>
    <div tipfor="more-pkunaccept" class="alert alert-info alert-dismissible fade in text-center" style="display: none;" role="alert">
      <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
      <strong></strong>
    </div>
    <%}else{%><h4 class="text-danger text-center">暂无未接受战书 :)</h4><%}%>
  <hr>
  <p><label class="label label-primary">未完成PK</label></p>
  <div>
    <%list = PKHistoryAcess.getUnDonePKHistorysByName(me,size,1);
      if(list==null)
        out.print("<h4 class=\"text-danger text-center\">暂无未完成PK :)</h4>");
      else{
    %>
    <div class="table-responsive">
    <table class="table table-condensed">
      <thead>
      <tr>
        <th>#</th>
        <th>考卷号</th>
        <th>挑战者</th>
        <th>被挑战者</th>
        <th>状态</th>
        <th>PK接受时间</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody data-target="more-pkundone">
      <%int index = 1;
        for (PKHistory pkHistory:list){
        String other = pkHistory.getUser1().equals(me)?pkHistory.getUser2():pkHistory.getUser1();
        boolean isOk = UserPaperAcess.getIs_OkByUserPaper(other, pkHistory.getPaper_id());
      %>
      <tr class="<%=isOk?"danger":"warning"%>">
        <th scope="row"><%=index++%></th>
        <td><button class="btn-link" role="link-paper" data-name="<%=pkHistory.getPaper_id()%>"><span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%></button></td>
        <td class="<%=pkHistory.getUser1().equals(me)?"text-danger":""%>">
          <a target="_blank" href="infoshow?name=<%=pkHistory.getUser1()%>">
            <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser1(),config)%>">
          </a><%=pkHistory.getUser1()%>
        </td>
        <td class="<%=pkHistory.getUser2().equals(me)?"text-danger":""%>">
          <a target="_blank" href="infoshow?name=<%=pkHistory.getUser2()%>">
            <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser2(),config)%>">
          </a><%=pkHistory.getUser2()%>
        </td>
        <td><%=isOk?"您未完成":"对方未完成"%></td>
        <td><%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%></td>
        <td><a target="_blank" href="test?<%=isOk?"continue":"showall"%>=<%=pkHistory.getPaper_id()%>" class="btn btn-sm btn-primary"
                    role="btn-<%=isOk?"answer":"showinfo"%>"><%=isOk?"进行作答":"查看详情"%></a></td>
      </tr>
      <%}%>
      </tbody>
    </table>
    </div>
    <p class="text-center"><a href="javascript:;" class="btn-link small" id="more-pkundone" data-name="1">查看更多...</a></p>
    <div tipfor="more-pkundone" class="alert alert-info alert-dismissible fade in text-center" style="display: none;" role="alert">
      <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
      <strong></strong>
    </div>
    <%}%>
    </p>
  </div>
  <hr><%JSONObject o = Transaction.getPointChart(me);boolean ischart = true;
      if(o==null) {
        out.print("<h4 class=\"text-danger text-center\">暂无积分变化情况 </h4>");
        ischart = false;
      }
    else{%>
    <div id="pointChange-chart" style="height:400px;width: 100%;"></div>
    <%}%>
  <hr>
  <p><label class="label label-primary">已完成PK</label></p>
    <div>
      <p>
      <%list = PKHistoryAcess.getDonePKHistorysByName(me,size,1);
        if(list==null)
          out.print("<h4 class=\"text-danger text-center\">暂无完成PK :( , 快去找好友宣战吧!</h4>");
        else {%>
      <div class="table-responsive">
      <table class="table table-condensed">
        <thead>
        <tr>
          <th>#</th>
          <th>考卷号</th>
          <th>挑战者</th>
          <th>被挑战者</th>
          <th>积分变化</th>
          <th>PK完成时间</th>
          <th>操作</th>
          <th>查看</th>
        </tr>
        </thead>
        <tbody data-target="more-pkdone">
        <%int index=1;
          for (PKHistory pkHistory:list){
          String cls = pkHistory.getStatus()==2?"active":(pkHistory.getWin_name().equals(me)?"success":"warning");%>
        <tr class="<%=cls%>">
          <th scope="row"><%=index++%></th>
          <td><button class="btn-link" role="link-paper" data-name="<%=pkHistory.getPaper_id()%>"><span class="glyphicon glyphicon-star"></span> <%=pkHistory.getPaper_id()%></button></td>
          <td><a target="_blank" href="infoshow?name=<%=pkHistory.getUser1()%>">
            <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser1(),config)%>">
          </a><%=pkHistory.getUser1()%></td>
          <td><a target="_blank" href="infoshow?name=<%=pkHistory.getUser2()%>">
            <img style="height: 32;width: 32;border-radius: 50%;" class="img-bigger" src="<%=Tools.getUserHeadPath(pkHistory.getUser2(),config)%>">
          </a><%=pkHistory.getUser2()%></td>
          <td><%=pkHistory.getInc_point()>0?"+"+pkHistory.getInc_point():pkHistory.getInc_point()%>/<%=pkHistory.getDec_point()%></td>
          <td><%=new SimpleTimeShow(pkHistory.getPktime(),SimpleTimeShow.PATTERN_0)%></td>
          <td><button class="btn btn-sm btn-primary" role="btn-contact"
                      <%JSONObject object = new JSONObject();
                        object.put("user1",pkHistory.getUser1());object.put("user2",pkHistory.getUser2());
                        object.put("paperID",pkHistory.getPaper_id());%>
                       data-name='<%=object%>'>对比查看</button></td>
          <td><a href="test?showall=<%=pkHistory.getPaper_id()%>" target="_blank" class="btn btn-sm btn-default">查看</a></td>
        </tr>
        <%}%>
        </tbody>
      </table>
      </div>
      <p class="text-center"><a href="javascript:;" class="btn-link small" id="more-pkdone" data-name="1">查看更多...</a></p>
      <div tipfor="more-pkdone" class="alert alert-info alert-dismissible fade in text-center" style="display: none;" role="alert">
        <button type="button" class="close" onclick="$(this).parent().hide('normal')" aria-label="Close"><span aria-hidden="true">×</span></button>
        <strong></strong>
      </div>
      <%}%>
      </p>
    </div>
</div>

<script src="js/echarts-all-3.js"></script>
<script>
  $(function () {
    var tip=$('#tip-pk');
    $.fn.showAlert = function (text) {
      $(this).find('strong').text(text);
      $(this).show('normal');
    }
    refreshHandle = function () {
      $('[role=btn-cancelunaccept]').click(function () {
        var _t = $(this);
        $.moyuConfirm('是否确认取消该请求？', function () {
          var d = JSON.parse(_t.attr('data-name'));
          d.act = 'cancelpkunaccept';
          $.ajax({method:'POST',url:'ajax/start.jsp',data:d}).done(function (d) {
//            if(d==-1) tip.showAlert('Sorry, 取消失败，可能对方已经接受');
//            else{
              tip.showAlert('取消成功');
              _t.parent().remove();
//            }
          })
        })
      });
      $('[role=btn-acceptpk]').click(function () {
        var _t = $(this)
        $.moyuConfirm('是否确认接受该挑战？', function () {
          var d = JSON.parse(_t.attr('data-name'));
          var paper = d.paperID;
          d.act = 'acceptpk';
          $.ajax({method: 'POST', url: 'ajax/start.jsp', data: d}).done(function (d) {
            if (d == -1) tip.showAlert('Sorry, 接受失败，可能对方已经取消');
            else {
              tip.showAlert('接受成功 :)');
              _t.parent().remove();
              location.href = 'test?continue=' + paper;
            }
          })
        })
      })//
      $('[role=btn-disagreepk]').click(function () {
        var _t = $(this)
        $.moyuConfirm('是否拒绝接受该挑战？', function () {
          var d = JSON.parse(_t.attr('data-name'));
          var paper = d.paperID;
          d.act = 'disagreepk';
          $.ajax({method:'POST',url:'ajax/start.jsp',data:d}).done(function (d) {
            if(d==-1) tip.showAlert('Sorry, 拒绝失败，可能对方已经取消');
            else{
              tip.showAlert('拒绝成功 :)');
              _t.parent().remove();
            }
          })
        })
      });
      $('[role=btn-contact]').hover(function () {
        $(this).unbind('mouseenter mouseleave');
        var _this = $(this);
        var d=JSON.parse(_this.attr('data-name'));
          $.ajax({method:'GET',url:'ajax/get_compare_chart.jsp',data:d}).done(function (html) {
            _this.popover({content:html,placement:'top',html:true,trigger:'click',title:'可视化对比'})
        })
      });
      $('[role=link-paper]').click(function () {
        var _this = $(this);
        if(_this.attr('data-flag'))
          return;
        $.ajax({method:'GET',url:'ajax/start.jsp',data:{act:'getPaperBaseInfo',paper:_this.attr('data-name')}}).done(function (d) {
          d = JSON.parse(d);
          _this.attr('data-flag',true);
          var content = '<div class="table-responsive"><table class="table table-condensed"> <thead> <tr>' +
                  '<th>科目</th>' +
                  '<th>难度</th>' +
                  '<th>用时</th>' +
                  '<th>单选/多选/判断/简答数目</th>' +
                  '</tr> </thead>' +
                  '<tbody><tr>'+
                  '<td>'+ d.subject+'</td>'+
                  '<td>'+ d.lev+'</td>'+
                  '<td>'+ d.maxmin+'</td>'+
                  '<td>'+ [d.singleNum,d.multiNum, d.judgeNum, d.saNum].join('/')+'</td>'+
                  '</tr></tbody></table></div>';
          _this.popover({content:content,placement:'top',html:true,trigger:'focus',title:'考卷基本信息',container:'body'})
                  .popover('show');
        })
      })
    };
    refreshHandle();
    $('[id*=more-pk]').click(function () {
      var _this = $(this),id = _this.attr('id');
      var par=_this.parent();
      _this.hide();
      par.append(loadDiv);
      $.ajax({method:'GET',url:'ajax/get_'+id+'.jsp',data:{size:<%=size%>,index:parseInt(_this.attr('data-name'))+1}})
              .done(function (d) {
                setTimeout(function () {
                  _this.show();
                  par.children(':last').remove();
                  if(d==-1){
                    $('[tipfor='+id+']').showAlert('Sorry, 已经无更多的信息 :(');
                  }else{
                    $('[data-target='+id+']').append(d);
                    _this.attr('data-name',Number(_this.attr('data-name'))+1);
                    refreshHandle();
                  }
                },500)
              })
    });
    <%if(ischart){%>
    var chart = echarts.init(document.getElementById('pointChange-chart'));
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
          text: 'PK积分变化表',
        },
        tooltip : {
          trigger: 'axis'
        },
        legend: {
          data:['积分']
        },
        dataZoom: [
          {
            show: true,
            start: 0,
            end: 100,
            handleSize: 8
          },
          {//滚轮
            type: 'inside',
            start: 0,
            end: 100,
          }
        ],
        toolbox: {
          show : true,
          feature : {
            dataZoom: {},
            dataView: {readOnly: true},
            magicType: {type: ['line']},
            restore: {},
            saveAsImage: {}
          }
        },
        xAxis : [
          {
            type : 'category',
            boundaryGap : false,
            data : <%=o.get("dates")%>
          }
        ],
        yAxis : [
          {
            type : 'value',
            axisLabel : {
              formatter: '{value} 分'
            },

          }
        ],
        series : [
          {
            name:'积分',
            type:'line',
            data: <%=o.get("points")%>,
            markPoint : {
              data : [
                {type : 'max', name: '最大值',itemStyle:{normal:{color:'green'},emphasis:{color:'green'}}},
                {type : 'min', name: '最小值',itemStyle:{normal:{color:'gray'},emphasis:{color:'gray'}}}
              ]
            },
            markLine : {
              data : [
                {type : 'average', name: '平均值'}
              ]
            }
          }
        ]
      });
      chart.hideLoading();
    },500);
    <%}%>
  })
</script>