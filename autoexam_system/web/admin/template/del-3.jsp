<br>
<div class="col-lg-2"></div>
<div class="col-lg-8">
    <div id="dlg-alert" style="display: none;" class="alert alert-warning text-center" role="alert">
        <button type="button" onclick="$('#dlg-alert').hide('normal')" class="close"><span aria-hidden="true">&times;</span></button>
        <big>请按照要求输入（6-12位，不含中文与空格）！</big></div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span> </span>
            <input id="input1" type="text" class="form-control" placeholder="输入用户名（6-12位，不含中文与空格）">
        </div>
    </div>
    <div id="dlg-alert2" style="display: none;" class="alert alert-warning text-center" role="alert">
    <button type="button" onclick="$('#dlg-alert2').hide('normal')" class="close"><span aria-hidden="true">&times;</span></button>
    <big>请按照要求输入（如AB1234）！</big></div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon"><span class="glyphicon glyphicon-star"></span> </span>
            <input id="input2" type="text" class="form-control" placeholder="输入考卷号（如AB1234）">
        </div>
    </div>
    <div class="text-right">
    <button class="btn btn-danger btn-lg" id="del">确认删除</button>
    </div>
</div>
<script>
    $("#del").click(function () {
        var input1 = $("#input1"),input2 = $("#input2");
        var isTrue=true;
        if(!/^[^\u4e00-\u9fa5\s]{6,12}$/.test(input1.val().trim())){
            $("#dlg-alert").show("normal");
            isTrue=false;
        }
        if(!/^[a-zA-Z]{2}[\d]{4}$/.test(input2.val().trim())) {
            $("#dlg-alert2").show("normal");
            isTrue=false;
        }
        if(isTrue){
            var _this = $(this);
            $(this).prop("disabled",true);
            $.ajax({
                method:"POST",
                url:"../ajax/adminDo.jsp",
                data:{
                    act:"delUserTest",
                    user:input1.val().trim(),
                    paper:input2.val().trim()
                }
            }).done(function (d) {
                _this.prop("disabled",false);
                if(d==-1)
                    $.moyuAlert("该考试记录不存在！");
                else{
                    $.moyuAlert("删除成功！");
                }
            })
        }
    })
</script>