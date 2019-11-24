<style>
    label{
        text-align: right;
        vertical-align: middle;
    }
</style>

<footer class="panel-footer">
    <div class="container">
        <p class="text-center">Copyright &copy; 2016 Moyu All Rights Reserved.
        </p>
        <ul class="list-unstyled list-inline text-center">
            <li >当前版本： v 2.0</li>
            <li>·</li>
            <li ><a href="javascript:;" type="button" role="button" data-trigger="focus"  data-container="body"
                    data-toggle="popover" data-placement="top">扫一扫</a></li>
            <li>·</li>
            <li><a href="javascript:;" data-toggle="modal" data-backdrop="static"  data-target="#contractModal">在线留言</a></li>
            <li>·</li>
            <li><a href="admin/" target="_blank">后台管理</a></li>
        </ul>
    </div>
</footer>
<div class="modal fade" id="contractModal" style="z-index: 99999" tabindex="-1" role="dialog" aria-labelledby="contractModal">
    <div class="modal-dialog modal-open modal-lg">
        <div class="modal-content vertical-grabber">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title text-center">在线留言</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="name-input" class="col-xs-2 control-label">真实姓名</label>
                        <div class="col-xs-10"><input type="text" class=" form-control" id="name-input" placeholder="请输入姓名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="phone-input" class="col-xs-2 control-label">手机号码</label>
                        <div class="col-xs-10">
                        <input type="phone" class="form-control" id="phone-input" placeholder="请输入手机">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email-input-contract" class="col-xs-2 control-label">电子邮箱</label>
                        <div class="col-xs-10">
                        <input type="email" class="form-control" id="email-input-contract" placeholder="请输入电子邮箱">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label" for="mess-input">留言内容</label>
                        <div class="col-xs-10">
                        <textarea type="text" class="form-control" rows="5" id="mess-input" placeholder="请输入留言内容"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="contract-btn" type="submit" class="btn btn-primary">提交留言</button>
            </div>
        </div>
    </div>
</div>
<div id="notify-container" style="display: none">
</div>
<%if(request.getParameter("nosocket")==null){%>
<script src="js/jquery.websocket.js"></script>
<script src="js/websocket.js"></script>
<%}%>
<script src="js/websql.js"></script>
<script>
    document.createElement("img").src="images/sys.png";
    $("[data-toggle=popover]").popover({
        title:"<div class='text-center'>扫一扫关注</div>",
        content:"<img style='width: 200px;' src='images/sys.png' alt='扫一扫'/>",
        html:true,
        trigger:'hover',
        container:'body'
    });
    $("#contract-btn").click(function(){
        $(this).attr("disabled",true);
        $.ajax({
            method:"POST",
            url:"ajax/start",
            data:{
                act:"addMess",
                name:$("#name-input").val(),
                phone:$("#phone-input").val(),
                email:$("#email-input-contract").val(),
                mess:$("#mess-input").val(),
            }
        }).fail(function(e){
            $("#contract-btn").attr("disabled",false);
            $.moyuAlert("error: "+e.status);
        }).done(function(d){
            $("#contract-btn").attr("disabled",false);
            $.moyuAlert(trim(d));
        })
    });
    function centerModals(){
        $('.modal').each(function(i){
            var $clone = $(this).clone().css('display', 'block').appendTo('body');
            var top = Math.round(($clone.height() - $clone.find('.modal-content').height()) / 2)-20;
            top = top > 0 ? top : 0;
            $clone.remove();
            $(this).find('.modal-content').css("margin-top", top);
        });
    }
    $('.modal').on('show.bs.modal', centerModals);
    $(window).on('resize', centerModals);
</script>