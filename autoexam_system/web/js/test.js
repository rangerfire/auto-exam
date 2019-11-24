/**
 * Created by Yc on 2015/9/18.
 */
$(document).ready(function () {
    alignNav();
    $(window).on("resize", alignNav);
    $("#test_emport").click(function () {
        var id = $(this).attr("data-id");
        $(this).attr("disabled", true);
        setTimeout('$("#test_emport").attr("disabled",false);', 3500);
        location.href = "download?paperId=" + id;
    })

    $("#text_alert").hide()
    $("#single_panel_head").click(function () {
        $("[name=single_panel_body]").each(function () {
            $(this).slideToggle("slow");
        })
    })
    $("#muti_panel_head").click(function () {
        $("[name=muti_panel_body]").each(function () {
            $(this).slideToggle("slow");
        })
    })
    $("#judge_panel_head").click(function () {
        $("[name=judge_panel_body]").each(function () {
            $(this).slideToggle("slow");
        })
    })
    $("#sa_panel_head").click(function () {
        $("[name=sa_panel_body]").each(function () {
            $(this).slideToggle("slow");
        })
    })
    $("#testalert_close").off('click')
    $("#testalert_close").on('click', function () {
        $("#text_alert").hide("normal")
    })
    $("#test_strategy_btn").click(function () {
        if (isStart) {
            $("#test_stra_modal").modal('hide')
            $("#text_alert").show("normal")
            return false;
        }
    })
    $("#autotest_btn").click(function () {
        $(this).popover({
            html: true,
            trigger: 'manual',
            content: "<span class='text-info'><span class='glyphicon glyphicon-time'></span> 试卷生成中...请稍后</span>",
            placement: 'top',
            container: 'body'
        }).popover('show').on("shown.bs.popover", function () {
            var t = $(this)
            setTimeout(function () {
                t.popover('hide')
            }, 1200)
        })
        $(this).attr("disabled", true);
        $.ajax({
            method: "GET",
            url: "ajax/start",
            data: {
                act: 'userTest',
                subject: $("#test_stra_subject").val(),
                singlenum: $("#test_stra_singlenum").val(),
                mutinum: $("#test_stra_mutinum").val(),
                judgenum: $("#test_stra_judgenum").val(),
                sanum: $("#test_stra_sanum").val(),
                maxmin: $("#test_stra_maxmin").val(),
                lev: $("#test_stra_lev").val(),
            }
        }).done(function (d) {
            setTimeout(function () {
                if (d != -1) {
                    $("#test_stra_modal").modal('hide')
                    d = JSON.parse(d)
                    m = d.maxmin
                    Testmaxmin = m;
                    startTimer();
                    //console.log(d)
                    testShow(d)
                    $("#progress1").show("normal")
                    var min = Testmaxmin;
                    n = 0;
                    settime1 = setInterval(function () {
                        n++;
                        var t = n * (100 / (min * 60))
                        $("#test_progress").css({width: t + '%'})
                        if (t > 50 && t < 75)
                            $("#test_progress").removeClass("progress-bar-success").addClass("progress-bar-warning")
                        else if (t >= 75)
                            $("#test_progress").removeClass("progress-bar-warning").addClass("progress-bar-danger")
                        if (n > min * 60)
                            clearInterval(settime1)
                    }, 1000)

                    $("#text_content").show("normal")
                    $("#test_start_btns").show('normal')
                    $("#autotest_btn").attr("disabled", false)

                    $("[class*=ques-content]").each(function () {
                        $(this).click(function (e) {
                            if(e.target.tagName=='INPUT')
                                return;
                            $(this).find("input:checkbox").click();
                            $(this).find("input:radio").prop("checked", true);
                            e.stopPropagation();
                            //return false;
                        })
                    });
                    $('#btn-fight').show();
                } else {
                    $("#autotest_btn").attr("disabled", false)
                    $.moyuAlert("您选择的有效题目数量为0");
                }
            }, 1500)
        }).fail(function () {
            $("#autotest_btn").attr("disabled", false)
        })
    })
    $('[data-toggle="tooltip"]').tooltip()


    $("#test_submit").click(function () {
        var count = coutNonWriteQues();
        var str = count == 0 ? "你已经全部完成，是否确定交卷？" : "你还有" + count + "道题目未完成，是否确定交卷？",
            _this = $(this);
        $.moyuConfirm(str, function () {
            if (!isStart) return false;
            _this.attr('title','').popover({
                html: true,
                trigger: 'manual',

                content: "<span class='text-info'><span class='glyphicon glyphicon-time'></span> 试卷提交中...请稍后</span>",
                placement: 'top',
                container: 'body'
            }).popover('show').on("shown.bs.popover", function () {
                var t = $(this)
                setTimeout(function () {
                    t.popover('hide')
                }, 1500)
            })
            _this.attr("disabled", true);
            submit(true)
        });
    })
    $("#test_save").click(function () {
        var _t = $(this);
        $.moyuConfirm("是否确定放弃此次考试？", function () {
            if(!isStart) return false;
            _t.attr("disabled", true);
            submit(false);
        })
    })

})

function alignNav() {
    var timer = $("#test_timer"), menu = $("#myScrollspy>ul");
    var containerWidth = $(".container").width();
    var allWidth = $(document).width();
    var ulinnerWidth = menu.width();
    var timeinnerWidth = timer.width();
    var blankWidth = (allWidth - containerWidth) / 2;
    var left = blankWidth - ulinnerWidth - 20, right = blankWidth - timeinnerWidth - 20;
    timer.css({
        right: (right > 0) ? right : 0
    })
    if (left <= 0)
        menu.hide();
    else
        menu.show();
    menu.css({
        left: left
    })
}

var isStart = false;
var m;
var s = 0;
var settime;
function showtime() {
    document.getElementById('text_min').innerHTML = m;
    document.getElementById('text_sec').innerHTML = s;
    s = s - 1;
    if (s == -1) {
        m = m - 1;
        s = 59
    }
    if (m < 10)
        $("#text_min,#text_sec").css("color", 'red');
    if (m == -1 && s == 59) {

        clearInterval(settime);
        $.moyuAlert('3秒后自动提交,并跳页')
        setTimeout("isStart=false; submit(true);location.href='history'", 3000);
    }
}
function startTimer() {
    isStart = true;
    s = 0;
    clearInterval(settime);
    settime = setInterval(function () {
        showtime();
    }, 1000);
}
/*data:{maxmin,single,muti,judge,sa,paper_lev}*/
function testShow(data) {
    var lev;
    switch (data.paper_lev) {
        case 0:
            lev = '★★★';
            break;
        case 1:
            lev = '★★';
            break;
        case 2:
            lev = '★';
            break;
    }
    $("#paper_lev").show().text("试卷难度：" + lev);
    //数字呈现
    $("#singlenum").text(data.single[0] == null ? 0 : data.single.length)
    $("#mutinum").text(data.muti[0] == null ? 0 : data.muti.length)
    $("#judgenum").text(data.judge[0] == null ? 0 : data.judge.length)
    $("#sanum").text(data.sa[0] == null ? 0 : data.sa.length)
    $("#paper_id").show().find("label").text(data.paper_id);
    $("#paper_subject").show().find("label").text(data.subject);
    paperId = data.paper_id
    //单选呈现
    if (data.single[0] != null) {
        for (var i = 0; i < data.single.length; i++) {
            if(data.single[i]==null)
                continue;
            var body = $("#single_body_template").clone().remove("#single_list_template").show().attr("id", "single" + i)
            body.find("[name=single_no]").html(data.single[i].id)
            body.find("[name=single_number]").html(i + 1 + "、")
            body.find("[name=single_score]").html("(" + data.single[i].ques_score + "分)&nbsp;&nbsp;")
            for (var j = 0; j < data.single[i].ques_content.length; j++) {
                if (j == 0)
                    body.find("[name=content]").html(data.single[i].ques_content[j] == '' ? '无' : data.single[i].ques_content[j])
                else {
                    var str = "ABCDEFGHIJK"
                    var list = $("#single_list_template").clone().removeAttr("id").show()
                    list.find("[name=tage]").attr("for", "single" + i + j).html(str[j - 1])
                    list.find("#radio").attr("id", "single" + i + j).attr("name", 'single' + i)
                    list.find("[name=list]").html(data.single[i].ques_content[j] == '' ? '无' : data.single[i].ques_content[j])
                    list.appendTo(body)
                }
            }
            body.appendTo($("#single_panel"))
            body.append(document.createElement('hr'))
        }
    }
    //多选显示
    if (data.muti[0] != null) {
        for (var i = 0; i < data.muti.length; i++) {
            if(data.muti[i]==null)
                continue;
            var body = $("#muti_body_template").clone().remove("#muti_list_template").show().attr("id", "muti" + i)
            body.find("[name=muti_no]").html(data.muti[i].id)

            body.find("[name=muti_number]").html(i + 1 + "、")
            body.find("[name=muti_score]").html("(" + data.muti[i].ques_score + "分)&nbsp;&nbsp;")
            for (var j = 0; j < data.muti[i].ques_content.length; j++) {
                if (j == 0)
                    body.find("[name=content]").html(data.muti[i].ques_content[j] == '' ? '无' : data.muti[i].ques_content[j])
                else {
                    var str = "ABCDEFGHIJK"
                    var list = $("#muti_list_template").clone().removeAttr("id").show()
                    list.find("[name=tage]").attr("for", "muti" + i + j).html(str[j - 1])
                    list.find("#checkbox").attr("id", "muti" + i + j).attr("name", 'muti' + i)
                    list.find("[name=list]").html(data.muti[i].ques_content[j] == '' ? '无' : data.muti[i].ques_content[j])
                    list.appendTo(body)
                }
            }
            body.appendTo($("#muti_panel"))
            body.append(document.createElement('hr'))
        }
    }
    //判断显示
    if (data.judge[0] != null) {
        for (var i = 0; i < data.judge.length; i++) {
            if(data.judge[i]==null)
                continue;
            var body = $("#judge_body_template").clone().remove("#judge_list_template").show().attr("id", "judge" + i)
            body.find("[name=judge_no]").html(data.judge[i].id)

            body.find("[name=judge_number]").html(i + 1 + "、")
            body.find("[name=judge_score]").html("(" + data.judge[i].ques_score + "分)&nbsp;&nbsp;")

            body.find("[name=content]").html(data.judge[i].ques_content[0] == '' ? '无' : data.judge[i].ques_content[0])
            var str = ["正确", "错误"];
            var list = $("#judge_list_template").clone().removeAttr("id").show()
            list.find("[name=tage]").each(function (index) {
                $(this).attr("for", "judge" + i + index).html(str[index])
            })
            list.find("#radio1").attr("id", "judge" + i + 0).attr("name", 'judge' + i)
            list.find("#radio2").attr("id", "judge" + i + 1).attr("name", 'judge' + i)
            //list.find("[name=list]").html(data.judge[i].ques_content[0] == '' ? '无' : data.judge[i].ques_content[0])
            list.appendTo(body)

            body.appendTo($("#judge_panel"))
            body.append(document.createElement('hr'))
        }
    }
    //简答显示
    if (data.sa[0] != null) {
        for (var i = 0; i < data.sa.length; i++) {
            if(data.sa[i]==null)
                continue;
            var body = $("#sa_body_template").clone().remove("#sa_list_template").show().attr("id", "sa" + i)
            body.find("[name=sa_no]").html(data.sa[i].id)

            body.find("[name=sa_number]").html(i + 1 + "、")
            body.find("[name=sa_score]").html("(" + data.sa[i].ques_score + "分)&nbsp;&nbsp;")
            //for(var j=0;j<data.sa[i].ques_content.length;j++){
            //if(j==0)
            body.find("[name=content]").html(data.sa[i].ques_content[0] == '' ? '无' : data.sa[i].ques_content[0])
            //else{
            //var str="ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫ"
            var list = $("#sa_list_template").clone().removeAttr("id").show()
            list.find("[name=tage]").attr("for", "sa" + i + j).html("回答：")
            list.find("#textarea").attr("id", "sa" + i + 0).attr("name", 'sa' + i).addClass("form-control")
            //list.find("[name=list]").html(data.sa[i].ques_content[0]==''?'无':data.sa[i].ques_content[0])
            list.appendTo(body)
            //}
            //}
            body.appendTo($("#sa_panel"))
            body.append(document.createElement('hr'))
        }
    }
    //模板块清除
    $("[id$=body_template]").remove()
}

window.onbeforeunload = function () {
    if (isStart) {
        if (document.all) {
            if (event.clientY < 0) {
                submit(null)
                return "离开默认为放弃";
            }
        } else {
            submit(null)
            return "离开默认为放弃";
        }
    }
}
//提交或者保存
function submit(isOk) {
    var is_Ok = isOk
    if (is_Ok == null)
        is_Ok = false;
    var spendtime;
    if (m < 0)
        spendtime = Testmaxmin;
    else
        spendtime = Testmaxmin - m - 1;
    var as = fillAnswer();
    $("#test_save").attr("disabled", true);
    $("#test_submit").attr("disabled", true);
    $.ajax({
        method: 'POST',
        url: "ajax/start",
        data: {
            act: 'testOp',
            isok: is_Ok,
            st: spendtime,
            pi: paperId,
            sn: $('#singlenum').text(),
            mn: $('#mutinum').text(),
            jn: $('#judgenum').text(),
            san: $('#sanum').text(),
            s: as[0],
            m: as[1],
            j: as[2],
            sa: as[3]
        }
    }).done(function () {
        $("#test_save").attr("disabled", false);
        $("#test_submit").attr("disabled", false);
        if (isOk != null) {
            isStart = false;
            location.href = "history";
        }
    }).fail(function () {
        $("#test_save").attr("disabled", false);
        $("#test_submit").attr("disabled", false);
    })
}
//继续考试
function continue_test(paperid) {
    $.ajax({
        method: "GET",
        url: "ajax/start",
        data: {
            act: 'testContinue',
            paperid: paperid,
        }
    }).done(function (d) {
        if (d == -1) {
            $.moyuAlert("Error:" + "连接服务器出错")
            location.href = "index";
            return;
        }
        d = JSON.parse(d)
        m = d.maxmin - d.spendmin;
        var base = (d.spendmin / d.maxmin) * 100
        $("#test_progress").css("width", base + "%")
        Testmaxmin = d.maxmin;
        startTimer();
        //console.log(d)
        testShow(d)
        var min = Testmaxmin;
        n = 0;
        settime1 = setInterval(function () {
            n++;
            var t = n * (100 / (min * 60)) + base;
            $("#test_progress").css({width: t + '%'})
            if (t > 50 && t < 75)
                $("#test_progress").removeClass("progress-bar-success").addClass("progress-bar-warning")
            else if (t >= 75)
                $("#test_progress").removeClass("progress-bar-warning").addClass("progress-bar-danger")
            if (n > min * 60)
                clearInterval(settime1)
            $("#progress1").show("normal")
        }, 1000)

        $("#text_content").show("normal")
        $("#test_start_btns").show('normal')
        $("[class*=ques-content]").each(function () {
            $(this).click(function (e) {
                if(e.target.tagName=='INPUT')
                    return;
                $(this).find("input:checkbox").click();//prop("checked",!$(this).find("input:checkbox").prop("checked"));
                $(this).find("input:radio").prop("checked", true);
                e.stopPropagation();
                //return false;
            })
        });

        //自己的答案填写
        PaintMyAnswer({
            singleanswer: d.singleanswer,
            mutianswer: d.mutianswer,
            judgeanswer: d.judgeanswer,
            saanswer: d.saanswer
        })
        $('#btn-fight').show();
    })
}
//试卷解析
function paperShow(paperid, isShowAll) {
    $.ajax({
        method: "GET",
        url: "ajax/start",
        data: {
            act: 'showall',
            paperid: paperid,
        }
    }).fail(function () {
        paperShow(paperid,isShowAll);
    }).done(function (data) {
        if (data == -1) {
            $.moyuAlert("Error:" + "连接服务器出错")
            location.href = "index";
            return;
        }
        data = JSON.parse(data)
        //console.log(data);
        $("#test_header").hide()
        $("#test_timer").hide()
        var lev;
        switch (data.paper_lev) {
            case 0:
                lev = '★★★';
                break;
            case 1:
                lev = '★★';
                break;
            case 2:
                lev = '★';
                break;
        }
        $("#paper_lev").show().text("试卷难度：" + lev)

        //数字呈现
        $("#singlenum").text(data.single[0] == null ? 0 : data.single.length)
        $("#mutinum").text(data.muti[0] == null ? 0 : data.muti.length)
        $("#judgenum").text(data.judge[0] == null ? 0 : data.judge.length)
        $("#sanum").text(data.sa[0] == null ? 0 : data.sa.length)
        $("#paper_id").show().find("label").text(data.paper_id);
        $("#paper_subject").show().find("label").text(data.subject);
        paperId = data.paper_id
        //单选呈现
        if (data.single[0] != null) {
            for (var i = 0; i < data.single.length; i++) {
                if(data.single[i]==null)
                    continue;
                var body = $("#single_body_template").clone().remove("#single_list_template").show().attr("id", "single" + i)
                body.find("[name=single_no]").html(data.single[i].id)
                if (isShowAll != null) {
                    var lev;
                    switch (data.single[i].lev) {
                        case 0:
                            lev = '★★★';
                            break;
                        case 1:
                            lev = '★★';
                            break;
                        case 2:
                            lev = '★';
                            break;
                    }
                    body.find("[name=lev]").html('难度：' + lev).addClass("html-warning");
                }
                body.find("[name=single_number]").html(i + 1 + "、")
                body.find("[name=single_score]").html("(" + data.single[i].ques_score + "分)&nbsp;&nbsp;")

                var end = $("#single_end_template").clone().removeAttr('id').show().attr("id", "single_end" + i);
                end.find('[name=analy]').html(data.single[i].ques_analy.trim() == '' ? '暂无解析' : data.single[i].ques_analy.trim())
                var realaw = "", myaw = data.singleanswer[i];
                for (var j = 0; j < data.single[i].ques_answer.length; j++) {
                    realaw += data.single[i].ques_answer[j];
                }
                end.find('[name=answer]').html(realaw == '' ? '暂无答案' : realaw)
                if (realaw == myaw) {
                    end.find("[name=answertag]").addClass("text-success")
                    end.find('[name=answer]').addClass("text-success")
                }
                else {
                    end.find("[name=answertag]").css("color", 'red')
                    end.find('[name=answer]').css("color", 'red')
                }

                for (var j = 0; j < data.single[i].ques_content.length; j++) {
                    if (j == 0)
                        body.find("[name=content]").html(data.single[i].ques_content[j] == '' ? '无' : data.single[i].ques_content[j])
                    else {
                        var str = "ABCDEFGHIJK"
                        var list = $("#single_list_template").clone().removeAttr("id").show()
                        list.find("[name=tage]").attr("for", "single" + i + j).html(str[j - 1])
                        list.find("#radio").attr("id", "single" + i + j).attr("name", 'single' + i)
                        list.find("[name=list]").html(data.single[i].ques_content[j] == '' ? '无' : data.single[i].ques_content[j])
                        list.appendTo(body)

                    }
                }
                end.appendTo(body)
                body.appendTo($("#single_panel"))
                //hr
                body.append(document.createElement('hr'))

            }
        }
        //多选显示
        if (data.muti[0] != null) {
            for (var i = 0; i < data.muti.length; i++) {
                if(data.muti[i]==null)
                    continue;
                var body = $("#muti_body_template").clone().remove("#muti_list_template").show().attr("id", "muti" + i)
                body.find("[name=muti_no]").html(data.muti[i].id)
                if (isShowAll != null) {
                    var lev;
                    switch (data.muti[i].lev) {
                        case 0:
                            lev = '★★★';
                            break;
                        case 1:
                            lev = '★★';
                            break;
                        case 2:
                            lev = '★';
                            break;
                    }
                    body.find("[name=lev]").html('难度：' + lev);
                }
                body.find("[name=muti_number]").html(i + 1 + "、")
                body.find("[name=muti_score]").html("(" + data.muti[i].ques_score + "分)&nbsp;&nbsp;")

                var end = $("#muti_end_template").clone().removeAttr('id').show().attr("id", "muti_end" + i);
                end.find('[name=analy]').html(data.muti[i].ques_analy.trim() == '' ? '暂无解析' : data.muti[i].ques_analy.trim())
                var realaw = "", myaw = '';
                if (data.mutianswer[i] != null)
                    myaw = data.mutianswer[i].replace(/@@@/g, "")
                for (var j = 0; j < data.muti[i].ques_answer.length; j++) {
                    realaw += data.muti[i].ques_answer[j];
                }
                end.find('[name=answer]').html(realaw == '' ? '暂无答案' : realaw)
                if (realaw == myaw) {
                    end.find("[name=answertag]").addClass("text-success")
                    end.find('[name=answer]').addClass("text-success")
                }
                else {
                    end.find("[name=answertag]").css("color", 'red')
                    end.find('[name=answer]').css("color", 'red')
                }

                for (var j = 0; j < data.muti[i].ques_content.length; j++) {
                    if (j == 0)
                        body.find("[name=content]").html(data.muti[i].ques_content[j] == '' ? '无' : data.muti[i].ques_content[j])
                    else {
                        var str = "ABCDEFGHIJK"
                        var list = $("#muti_list_template").clone().removeAttr("id").show()
                        list.find("[name=tage]").attr("for", "muti" + i + j).html(str[j - 1])
                        list.find("#checkbox").attr("id", "muti" + i + j).attr("name", 'muti' + i)
                        list.find("[name=list]").html(data.muti[i].ques_content[j] == '' ? '无' : data.muti[i].ques_content[j])
                        list.appendTo(body)
                    }
                }
                end.appendTo(body)
                body.appendTo($("#muti_panel"))
                body.append(document.createElement('hr'))
            }
        }
        //判断显示
        if (data.judge[0] != null) {
            for (var i = 0; i < data.judge.length; i++) {
                if(data.judge[i]==null)
                    continue;
                var body = $("#judge_body_template").clone().remove("#judge_list_template").show().attr("id", "judge" + i)
                body.find("[name=judge_no]").html(data.judge[i].id)
                if (isShowAll != null) {
                    var lev;
                    switch (data.judge[i].lev) {
                        case 0:
                            lev = '★★★';
                            break;
                        case 1:
                            lev = '★★';
                            break;
                        case 2:
                            lev = '★';
                            break;
                    }
                    body.find("[name=lev]").html('难度：' + lev);
                }
                body.find("[name=judge_number]").html(i + 1 + "、")
                body.find("[name=judge_score]").html("(" + data.judge[i].ques_score + "分)&nbsp;&nbsp;")
                body.find("[name=content]").html(data.judge[i].ques_content[0] == '' ? '无' : data.judge[i].ques_content[0])
                var str = ["正确", "错误"];
                var list = $("#judge_list_template").clone().removeAttr("id").show()
                list.find("[name=tage]").each(function (index) {
                    $(this).attr("for", "judge" + i + index).html(str[index])
                })
                list.find("#radio1").attr("id", "judge" + i + 0).attr("name", 'judge' + i)
                list.find("#radio2").attr("id", "judge" + i + 1).attr("name", 'judge' + i)
                //list.find("[name=list]").html(data.judge[i].ques_content[0] == '' ? '无' : data.judge[i].ques_content[0])
                list.appendTo(body)

                var end = $("#judge_end_template").clone().removeAttr('id').show().attr("id", "judge_end" + i);
                end.find('[name=analy]').html(data.judge[i].ques_analy.trim() == '' ? '暂无解析' : data.judge[i].ques_analy.trim())
                var realaw = "", myaw = data.judgeanswer[i]
                for (var j = 0; j < data.judge[i].ques_answer.length; j++) {
                    realaw += data.judge[i].ques_answer[j];
                }
                if (realaw == myaw) {
                    end.find("[name=answertag]").addClass("text-success")
                    end.find('[name=answer]').addClass("text-success")
                } else {
                    end.find("[name=answertag]").css("color", 'red')
                    end.find('[name=answer]').css("color", 'red')
                }
                if (realaw == '') realaw = '暂无答案';
                else if (realaw == 'T') realaw = '正确';
                else if (realaw == 'F') realaw = '错误';
                end.find('[name=answer]').html(realaw)

                end.appendTo(body)

                body.appendTo($("#judge_panel"))
                body.append(document.createElement('hr'))
            }
        }
        //简答显示
        if (data.sa[0] != null) {
            for (var i = 0; i < data.sa.length; i++) {
                if(data.sa[i]==null)
                    continue;
                var body = $("#sa_body_template").clone().remove("#sa_list_template").show().attr("id", "sa" + i)
                body.find("[name=sa_no]").html(data.sa[i].id)
                if (isShowAll != null) {
                    var lev;
                    switch (data.sa[i].lev) {
                        case 0:
                            lev = '★★★';
                            break;
                        case 1:
                            lev = '★★';
                            break;
                        case 2:
                            lev = '★';
                            break;
                    }
                    body.find("[name=lev]").html('难度：' + lev);
                }
                body.find("[name=sa_number]").html(i + 1 + "、")
                body.find("[name=sa_score]").html("(" + data.sa[i].ques_score + "分)&nbsp;&nbsp;")
                body.find("[name=content]").html(data.sa[i].ques_content[0] == '' ? '无' : data.sa[i].ques_content[0])
                var list = $("#sa_list_template").clone().removeAttr("id").show()
                list.find("[name=tage]").attr("for", "sa" + i + j).html("回答：")
                list.find("#textarea").attr("id", "sa" + i + 0).attr("name", 'sa' + i)
                list.appendTo(body)

                var end = $("#sa_end_template").clone().removeAttr('id').show().attr("id", "sa_end" + i);
                end.css("margin-top", "40px")
                end.find('[name=analy]').html(data.sa[i].ques_analy.trim() == "" ? "暂无解析" : data.sa[i].ques_analy.trim())
                var realaw = ''
                for (var j = 0; j < data.sa[i].ques_answer.length; j++) {
                    realaw += data.sa[i].ques_answer[j];
                }
                end.find('[name=answer]').html(realaw == '' ? '暂无答案' : realaw)
                end.find('[name=answer]').addClass("text-primary")
                end.find('[name=answertag]').addClass("text-primary")
                end.appendTo(body)

                body.appendTo($("#sa_panel"))
                body.append(document.createElement('hr'))
            }
        }
        $("[class*=ques-content]").each(function () {

            if ($(this).css("display") == "none") {
                //console.log($(this))
                return;
            }
            $(this).click(function (e) {
                if(e.target.tagName=='INPUT')
                    return;
                $(this).find("input:checkbox").click()//.prop("checked",!$(this).find("input:checkbox").prop("checked"));
                $(this).find("input:radio").prop("checked", true);
                e.stopPropagation();
                //return false;
            })
        });
        PaintMyAnswer(data)

        $('#btn-fight').show();
    })
}

function fillAnswer() {
    //模板块清除
    $("[id$=body_template]").remove()
    var singlenum = Number($("#singlenum").text());
    var mutinum = Number($("#mutinum").text());
    var judgenum = Number($("#judgenum").text());
    var sanum = Number($("#sanum").text());
    var answers0 = [], answers1 = [], answers2 = [], answers3 = [];
    var answers = []
    for (var i = 0; i < singlenum; i++) {
        answers0.push({
            id: $("[name=single_no]").eq(i).text(),
            aw: $("input[name=single" + i + "]:checked").prev().text(),
        })
    }
    for (var i = 0; i < mutinum; i++) {
        var aw = '';
        $("input[name=muti" + i + "]:checked").each(function (index) {
            if (index == 0)
                aw += $(this).prev().text()
            else
                aw += "@@@" + $(this).prev().text()//'@@@'
        })
        answers1.push({
            id: $("[name=muti_no]").eq(i).text(),
            aw: aw
        })
    }
    for (var i = 0; i < judgenum; i++) {
        var aw = $("input[name=judge" + i + "]:checked").val();
        aw = (aw == null) ? "" : aw;
        answers2.push({
            id: $("[name=judge_no]").eq(i).text(),
            aw: aw
        })
    }
    for (var i = 0; i < sanum; i++) {
        answers3.push({
            id: $("[name=sa_no]").eq(i).text(),
            aw: $("textarea[name=sa" + i + "]").val().replace(/\n/g, "&&&"),//换行
        })
    }
    answers.push(answers0, answers1, answers2, answers3)
    return answers;
}

/**
 *
 * @param data data.singleanswer  data.mutianswer ...
 */
function PaintMyAnswer(data) {
    //模板块清除
    $("[id$=body_template]").remove()
    if (data.singleanswer != null)
        for (var i = 0; i < data.singleanswer.length; i++) {
            var t = -1;
            switch (data.singleanswer[i]) {
                case "A":
                    t = 0;
                    break;
                case "B":
                    t = 1;
                    break;
                case "C":
                    t = 2;
                    break;
                case "D":
                    t = 3;
                    break;
                case "E":
                    t = 4;
                    break;
                case "F":
                    t = 5;
                    break;
                case "G":
                    t = 6;
                    break;
                case "H":
                    t = 7;
                    break;
                case "I":
                    t = 8;
                    break;
            }
            if (t != -1)
                $("[name=single" + i + "]").eq(t).attr("checked", true);
        }
    if (data.mutianswer != null)
        for (var i = 0; i < data.mutianswer.length; i++) {
            var t = data.mutianswer[i].split("@@@");
            var t1 = -1;
            for (var j = 0; j < t.length; j++) {
                switch (t[j]) {
                    case "A":
                        t1 = 0;
                        break;
                    case "B":
                        t1 = 1;
                        break;
                    case "C":
                        t1 = 2;
                        break;
                    case "D":
                        t1 = 3;
                        break;
                    case "E":
                        t1 = 4;
                        break;
                    case "F":
                        t1 = 5;
                        break;
                    case "G":
                        t1 = 6;
                        break;
                    case "H":
                        t1 = 7;
                        break;
                    case "I":
                        t1 = 8;
                        break;
                }
                if (t1 != -1)
                    $("[name=muti" + i + "]").eq(t1).attr("checked", true);
            }
        }
    if (data.judgeanswer != null)
        for (var i = 0; i < data.judgeanswer.length; i++) {
            var t = -1;
            switch (data.judgeanswer[i]) {
                case "T":
                    t = 0;
                    break;
                case "F":
                    t = 1;
                    break;
            }
            if (t != -1)
                $("[name=judge" + i + "]").eq(t).attr("checked", true);
        }
    if (data.saanswer != null)
        for (var i = 0; i < data.saanswer.length; i++) {
            $("textarea[name=sa" + i + "]").val(data.saanswer[i].replace(/&&&/g, '\n'));
        }
    $("#text_content").show("normal")
}

function coutNonWriteQues() {
    var singlenum = Number($("#singlenum").text());
    var mutinum = Number($("#mutinum").text());
    var judgenum = Number($("#judgenum").text());
    var sanum = Number($("#sanum").text());
    var noneDo = 0;
    for (var i = 0; i < singlenum; i++) {
        if ($("[name=single" + i + "]:checked").length == 0)
            noneDo++;
    }
    for (var i = 0; i < mutinum; i++) {
        if ($("[name=muti" + i + "]:checked").length == 0)
            noneDo++;
    }
    for (var i = 0; i < judgenum; i++) {
        if ($("[name=judge" + i + "]:checked").length == 0)
            noneDo++;
    }
    for (var i = 0; i < sanum; i++) {
        if ($("textarea[name=sa" + i + "]").val().trim() == "")
            noneDo++;
    }
    return noneDo;
}