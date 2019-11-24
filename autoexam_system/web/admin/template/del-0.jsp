
<br>
<div class="col-lg-1"></div>
<div class="col-lg-5 ">
    <div id="dlg-alert" style="display: none;" class="alert alert-warning text-center" role="alert">
        <button type="button" onclick="$('#dlg-alert').hide('normal')" class="close"><span aria-hidden="true">&times;</span></button>
        <big>请按照要求输入（6-12位，不含中文与空格）！</big></div>
        <div class="form-group">
            <div class="input-group input-group-lg">
    <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span> </span>
                <input id="input-username" type="text" class="form-control" placeholder="输入用户名（6-12位，不含中文与空格）">
                <span class="input-group-btn"><button type="button" id="search-0" class="btn btn-primary">搜索</button></span>
            </div>
        </div>
    <hr>
    <div id="out1" style="display: none">
        <div>
            当前待删除用户名: <label class="text-danger" id="out1-head"></label>
        </div>
        <br>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span> </span>
            <input id="out1-username" type="text" readonly class="form-control">
        </div>
    </div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon"><span class="glyphicon glyphicon-envelope"></span> </span>
            <input id="out1-email" type="text" readonly class="form-control">
        </div>
    </div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span> </span>
            <input id="out1-regtime" type="text" readonly class="form-control">
        </div>
    </div>
        <button class="btn btn-lg btn-block btn-danger" id="delete-0">确认删除</button>
        <hr>
    </div>
</div>
<div class="col-lg-1"></div>
<div class="col-lg-5">
    <div id="dlg-alert1" style="display: none;" class="alert alert-warning text-center" role="alert">
        <button type="button" onclick="$('#dlg-alert1').hide('normal')" class="close"><span aria-hidden="true">&times;</span></button>
        <big>请正确输入电子邮箱！</big></div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon"><span class="glyphicon glyphicon-envelope"></span> </span>
            <input id="input-email" type="text" class="form-control" placeholder="输入电子邮箱">
            <span class="input-group-btn"><button type="button" id="search-1" class="btn btn-primary">搜索</button></span>
        </div>
    </div>
    <hr>

    <div id="out2" style="display: none">
        <div>
            当前待删除用户邮箱: <label class="text-danger" id="out2-head"></label>
        </div>
        <br>
        <div class="form-group">
            <div class="input-group input-group-lg">
                <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span> </span>
                <input id="out2-username" type="text" readonly class="form-control">
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                <span class="input-group-addon"><span class="glyphicon glyphicon-envelope"></span> </span>
                <input id="out2-email" type="text" readonly class="form-control">
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span> </span>
                <input id="out2-regtime" type="text" readonly class="form-control">
            </div>
        </div>
        <button class="btn btn-lg btn-block btn-danger" id="delete-1">确认删除</button>
        <hr>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#input-username").keydown(function(e){
            if(e!=null && e.keyCode==13)
                $("#search-0").click();
        });
        $("#input-email").keydown(function(e){
            if(e!=null && e.keyCode==13)
                $("#search-1").click();
        });
        $("#search-0").click(function(){
            var input = $("#input-username");
            if(!/^[^\u4e00-\u9fa5\s]{6,12}$/.test(input.val().trim()))
                $("#dlg-alert").show("normal");
            else{
                $(this).prop("disabled",true);
                var _this=$(this);
                $.ajax({
                    method:'POST',
                    url:"../ajax/adminDo.jsp",
                    data:{
                        act:"getUserByName",
                        username:input.val().trim()
                    }
                }).done(function(d){
                    _this.prop("disabled",false);
                    if(d==-1)
                        $.moyuAlert("该用户未找到");
                    else{
                        d = JSON.parse(d);
                        $("#out1-username").val(d.username);
                        $("#out1-head").text(d.username);
                        $("#out1-email").val(d.email);
                        $("#out1-regtime").val(d.createtime);
                        $("#out1").slideDown("normal");
                    }
                })
            }
        });
        $("#search-1").click(function(){
            var input = $("#input-email");
            if(!/^\w+@\w+\.\w+$/.test(input.val().trim()))
                $("#dlg-alert1").show("normal");
            else{
                $(this).prop("disabled",true);
                var _this=$(this);
                $.ajax({
                    method:'POST',
                    url:"../ajax/adminDo.jsp",
                    data:{
                        act:"getUserByEmail",
                        email:input.val().trim()
                    }
                }).done(function(d){
                    _this.prop("disabled",false);
                    if(d==-1)
                        $.moyuAlert("该用户电子邮箱未找到");
                    else{
                        d = JSON.parse(d);
                        $("#out2-username").val(d.username);
                        $("#out2-head").text(d.email);
                        $("#out2-email").val(d.email);
                        $("#out2-regtime").val(d.createtime);
                        $("#out2").slideDown("normal");
                    }
                })
            }
        });
        $("#delete-0").click(function () {
            var out = $("#out1-head"),_this = $(this);
            if(out.text().trim()=='')  return;
            $.moyuConfirm("删除用户后，对应的考试记录也将被删除！是否确认删除？", function () {
                _this.prop("disabled",true);
                $.ajax({
                    method:"POST",
                    url:"../ajax/adminDo.jsp",
                    data:{
                        act:"delUserByName",
                        user:out.text().trim()
                    }
                }).done(function (d) {
                    _this.prop("disabled",false);
                    if(d==-1)
                        $.moyuAlert("用户不存在，删除失败！");
                    else {
                        $.moyuAlert("删除成功！");
                        $("#out1").slideUp("normal");
                    }
                })
            })
        })
        $("#delete-1").click(function () {
            var out = $("#out2-head"),_this = $(this);
            if(out.text().trim()=='')  return;
            $.moyuConfirm("删除用户后，对应的考试记录也将被删除！是否确认删除？",function(){
                _this.prop("disabled",true);
                $.ajax({
                    method:"POST",
                    url:"../ajax/adminDo.jsp",
                    data:{
                        act:"delUserByEmail",
                        email:out.text().trim()
                    }
                }).done(function (d) {
                    _this.prop("disabled",false);
                    if(d==-1)
                        $.moyuAlert("用户不存在，删除失败！");
                    else {
                        $.moyuAlert("删除成功！");
                        $("#out2").slideUp("normal");
                    }
                })
            })
        })
    })
</script>
