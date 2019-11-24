$(function () {
    var chart = echarts.init(document.getElementById('chart'));
    chart.showLoading('default',{
        text: '加载中...',
        color: '#c23531',
        textColor: '#000',
        maskColor: 'rgba(255, 255, 255, 0.8)',
        zlevel: 0
    });
    function loadChart(data){
        tp=data.xAxis.length==1?'bar':'line';
        var option = {
            title:{
                show:true,
                text:'已完成考试记录比较',
                subtext:data.xAxis.length+' 条记录'
            },
            toolbox: {
                show : true,
                feature : {
                    mark : {show: true},
                    dataZoom: {show:true},
                    dataView : {show: true, readOnly: true},
                    magicType: {show: true, type: ['line', 'bar']},
                    restore: {show:true},
                    saveAsImage : {show: true}
                }
            },
            tooltip: {
                trigger: 'item',
                position:'inside',
                //formatter: function (params, ticket, callback) {
                //    console.log(params,ticket,callback);
                //    return [params.seriesName,params.name,params.value].join('<br>')
                //}
                formatter:'★{b}<br>题 型 : {a}<br>得分率: {c} %'
            },
            calculable : true,
            legend: {data:['单选','多选','判断'],itemGap: 5},
            grid: {
                top: '16%',
                left: '20px',
                right: '10%',
                containLabel: true
            },
            xAxis : [
                {
                    type : 'category',
                    data : data.xAxis
                }
            ],
            yAxis: [
                {
                    type : 'value',
                    name : '得分率 (%)',
                }
            ],
            dataZoom: [
                {
                    show: true,
                    start: 50,
                    end: 100,
                    handleSize: 8
                },
                {//滚轮
                    type: 'inside',
                    start: 50,
                    end: 100,
                },
                {
                    show: true,
                    yAxisIndex: 0,
                    filterMode: 'empty',
                    width: 12,
                    height: '70%',
                    handleSize: 8,
                    showDataShadow: false,
                    left: '93%'
                }
            ],
            series : [
                {
                    name:'单选',
                    type:tp,
                    data:data.sp,
                    markPoint : {
                        data : [
                            {type : 'max', name: '最高得分率'},
                            {type : 'min', name: '最低得分率'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均得分率'}
                        ]
                    }
                }, {
                    name:'多选',
                    type:tp,
                    data:data.mp,
                    markPoint : {
                        data : [
                            {type : 'max', name: '最高得分率'},
                            {type : 'min', name: '最低得分率'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均得分率'}
                        ]
                    }
                }, {
                    name:'判断',
                    type:tp,
                    data:data.jp,
                    markPoint : {
                        data : [
                            {type : 'max', name: '最高得分率'},
                            {type : 'min', name: '最低得分率'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均得分率'}
                        ]
                    }
                }
            ]
        }
        chart.setOption(option);
        chart.hideLoading();
    }
    setTimeout(function () {
        $.ajax({
            method: 'GET',
            url: 'ajax/chart_get.jsp',
        }).done(function (d) {
            d = JSON.parse(d);
            if (!d.xAxis)
                $('#chart').hide();
            else
                loadChart(d);
        })
    },500)
    getChartOption = function(){
        return chart.getOption();
    }
    setChartOption = function(op){
        return chart.setOption(op);
    }
})