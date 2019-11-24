/**
 * Created by Yc on 2015/9/16.
 */
$(document).ready(function(){

    //$('.img-bigger').on('mouseover',function () {
    //    $(this).css('zoom','120%');
    //})
    autoHide()
    $("#username_input,#pwd_input").blur(function(){
        $(this).popover({
            content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请按照正确规格输入,6-12位,不含中文,空格</span>",
            trigger:'manual',
            html:true,
            placement:'bottom',
            container:'body'
        })
        $(this).removeAttr("style");
        if($(this).val()=="")   return;
        if(!validatePwdandName($(this).val())){
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            autoHide()
            return false;
        }
    })
    $("#reg_pwdinput,#reg_userinput").blur(function(){
        $(this).popover({
            content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请按照正确规格输入</span>",
            trigger:'manual',
            html:true,
            placement:'top',
            container:'body'
        })
        $(this).removeAttr("style");
        if($(this).val()=="")  return false;
        if(!validatePwdandName($(this).val())){
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            autoHide()
            return false;
        }
    })
    $("#reg_pwd2input").blur(function(){
        $(this).removeAttr("style");
        if($(this).val()=="")  return false;
        if($(this).val()!=$("#reg_pwdinput").val()){
            $(this).popover({
                content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>两次密码不一致</span>",
                trigger:'manual',
                html:true,
                placement:'top',
                container:'body'
            })
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            autoHide()
            return false;
        }
    })
    $("#reg_email").blur(function(){
        $(this).removeAttr("style");
        if($(this).val()=="")   return false;
        if(!/^\w+@\w+\.\w+$/.test($(this).val())){
            $(this).popover({
                content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请输入正确的电子邮箱</span>",
                trigger:'manual',
                html:true,
                placement:'top',
                container:'body'
            })
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            autoHide()
            return false;
        }
    })
    $("#reg_pininput").blur(function(){
        $(this).removeAttr("style");
        if($(this).val()=="")   return false;
        if($("#reg_code").text()!=$(this).val()){

            $(this).popover({
                content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>验证码错误</span>",
                trigger:'manual',
                html:true,
                placement:'top',
                container:'body'
            })
            $(this).focus();
            $(this).css("border-color","red")
            $(this).select();
            $(this).popover('show');
            autoHide()
            return false;
        }
    })
    $("#login_btn").on("click",function(){
        if(!validatePwdandName($("#username_input").val())) return false;
        if(!validatePwdandName($("#pwd_input").val())) return false;
        $(this).attr("disabled",true)
        $.ajax({
            method:"POST",
            url:"ajax/start",
            data:{act:"userlogin",username:$("#username_input").val(),password:$("#pwd_input").val(),
                isRem:$("#inputrember").prop("checked")}
        }).done(function (d) {
            d=trim(d)
            if(d==1)
                location.href='index'
            else if(d==-1){
                $("#login_btn").popover({
                    content: "<span style='color: red'><span class='glyphicon glyphicon-remove'></span>用户名不存在</span>",
                    trigger: 'manual',
                    html: true,
                    placement: 'top',
                    container:'body'
                }).popover('show')
            }else {
                $("#login_btn").popover({
                    content: "<span style='color: red'><span class='glyphicon glyphicon-remove'></span>密码错误</span>",
                    trigger: 'manual',
                    html: true,
                    placement: 'top',
                    container:'body'
                }).popover('show')
            }
            autoHide()
            $("#login_btn").attr("disabled",false)
        })
    })

    $("#exit_btn").click(function(){
        $.moyuConfirm("是否确认退出?", function () {
            $.ajax({
                method:"POST",
                url:"ajax/start",
                data:{act:"userExit",username:$("#username_input").val()}
            }).done(function (d) {
                location.href="index";
            })
        })
    })

    $("#reg_code").click(function(){
        var number1 = '';
        var color = '#';
        for (var i = 0; i < 4; i++) { number1 += parseInt(Math.random() * 10); }
        for (var i = 0; i < 6; i++) { color += parseInt(Math.random() * 9); }
        $(this).css("background-color",color);
        $(this).html(number1);
    }).click();

    $("#forget_btn").click(function(){
        if(!validatePwdandName($("#username_input").val())){
            $("#username_input").focus();
            $("#username_input").css("border-color","red")
            $("#username_input").select()
            return;
        }
        $.ajax({
            method:"POST",
            url:"ajax/start",
            data:{act:"userForget",username:$("#username_input").val()}
        }).done(function (d) {
            d=trim(d)
            //alert(d)
            if(d==1)
                $("#forget_btn").popover({
                    html:true,
                    content:"<span style='color: green'><span class='glyphicon glyphicon-ok'></span>新密码已经发送至注册邮箱中</span>",
                    trigger: 'manual',
                    placement: 'bottom',
                    container:'body'
                }).popover('show')
            else if(d==-1)
                $("#forget_btn").popover({
                    html:true,
                    content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>新密码已经发至注册邮箱中，请5分钟后点击</span>",
                    trigger: 'manual',
                    placement: 'bottom',
                    container:'body'
                }).popover('show')
            else
                $("#forget_btn").popover({
                    html:true,
                    content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>该用户名不存在</span>",
                    trigger: 'manual',
                    placement: 'bottom',
                    container:'body'
                }).popover('show')
            autoHide()
        })
    })

    $("#reg_close").click(function () {
        $("#reg_userinput,#reg_pwdinput,#reg_pwd2input,#reg_email,#reg_pininput").each(function(){
            $(this).val("");
        })
    })
    /*注册*/
    $("#confirmreg_btn").click(function(){
        var f = true;
        $("#reg_userinput,#reg_pwdinput,#reg_pwd2input,#reg_email,#reg_pininput").each(function(){
            if(!f) return;
            if($(this).val()=="") {
                console.log($(this))
                $(this).css("border-color","red");
                $(this).select();
                $(this).focus();
                f=false;
                return;
            }
        })
        if(!f) return;

        if($("#reg_userinput").val())
        if($("#reg_code").text()!=$("#reg_pininput").val()){
            $("#reg_pininput").css("border-color","red");
            $("#reg_pininput").focus();
            $("#reg_pininput").select();
            return;
        }
        if(!/^.+@.+\..+$/.test($("#reg_email").val())){
            $("#reg_email").css("border-color","red");
            $("#reg_email").focus();
            $("#reg_email").select();
            return;
        }
        if($("#reg_pwd2input").val()!=$("#reg_pwdinput").val()){
            $("#reg_pwd2input").css("border-color","red");
            $("#reg_pwd2input").focus();
            $("#reg_pwd2input").select();
            return;
        }
        $(this).prop("disabled",true)
        $.ajax({
            method:"GET",
            url:"ajax/start",
            data:{act:"userReg",username:$("#reg_userinput").val(),password:$("#reg_pwdinput").val(),email:$("#reg_email").val()}
        }).done(function (d) {
            d=trim(d)
            if(d==1){
                $("#confirmreg_btn").popover({
                    html:true,
                    content:"<span style='color: green'><span class='glyphicon glyphicon-ok'></span>注册成功</span>",
                    trigger: 'manual',
                    placement: 'top',
                    container:'body'
                }).popover('show')
                $("#reg_userinput,#reg_pwdinput,#reg_pwd2input,#reg_email,#reg_pininput").each(function(){
                    $(this).val("")
                })
                setTimeout('$("#reg_close").click()',1000);
            }
            else if(d==-1)//username error
                $("#confirmreg_btn").popover({
                    html:true,
                    content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>该用户名已被注册</span>",
                    trigger: 'manual',
                    placement: 'top',
                    container:'body'
                }).popover('show')
            else//email error
                $("#confirmreg_btn").popover({
                    html:true,
                    content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>该邮箱已被注册</span>",
                    trigger: 'manual',
                    placement: 'top',
                    container:'body'
                }).popover('show')
            autoHide()
            $("#reg_code").click()
            $("#confirmreg_btn").prop("disabled",false)
        }).fail(function(){
            $("#confirmreg_btn").prop("disabled",false)
        })
    })
    /* 搜索 */
    //var sea_con=$("#search_content")
    //var sea_way=$("#search_way")
    var sea_btn=$("#search_btn")
    var sea_in=$("#search_input")
    //点击替换
    //sea_con.next().children("li").click(function(){
    //    sea_con.html($(this).text()+" <span class='caret'></span>")
    //})
    //sea_way.next().children("li").click(function(){
    //    sea_way.html($(this).text()+" <span class='caret'></span>")
    //})
    //sea_btn 点击
    sea_btn.click(function(){
        if(trim(sea_in.val())=="") {
            sea_in.popover({
                html:true,
                content:"<span style='color: red'><span class='glyphicon glyphicon-remove'></span>请输入</span>",
                trigger: 'manual',
                placement: 'bottom',
                container:'body'
            }).popover('show')
            return;
        }
        var isCertain=false;
        var con="ques-Id";
        //switch (trim(sea_con.text())){
        //    case "题号":con="ques_Id"; break;
        //    case "内容":con="ques_Content"; break;
        //    case "解析":con="ques_Analy"; break;
        //    case "科目":con="ques_Subject"; break;
        //}
        var url="search?act=userSearch&isCertain="+isCertain+"&searchCon="+con+"&content="+trim(sea_in.val())+
                "&page=1&isAsc=true&order=subject";
        console.log(url)
        window.open(url);
    })
})

function validatePwdandName(text){
    return /^[^\u4e00-\u9fa5\s]{6,12}$/.test(text);
}
function trim(str) { return str.replace(/(^\s*)|(\s*$)/g, ""); }

function autoHide(){
    $("#username_input,#pwd_input,#login_btn,#forget_btn,#reg_pwdinput,#reg_userinput,#reg_pwd2input,#reg_pininput,#reg_email" +
        ",#confirmreg_btn,#search_input,#search_btn").on('shown.bs.popover', function () {
        var t=$(this)
        setTimeout(function(){
            t.popover('hide')
            t.popover('destroy')
        },2000)
    })
}