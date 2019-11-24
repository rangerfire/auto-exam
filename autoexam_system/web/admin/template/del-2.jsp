<br>
<br>
<div class="col-lg-8 col-lg-offset-2 ">
    <div id="dlg-alert" style="display: none;" class="alert alert-warning text-center" role="alert">
        <button type="button" onclick="$('#dlg-alert').hide('normal')" class="close"><span aria-hidden="true">&times;</span></button>
        <big>请按照正确输入（如AB1234）！</big></div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon">考卷号 </span>
            <input id="input" type="text" class="form-control" placeholder="输入待删除的考卷号（如AB1234）">
            <span class="input-group-btn"><button data-toggle="tooltip" data-placement="left" title="相应考试记录也将删除！" type="button" id="del" class="btn btn-danger">删除</button></span>
        </div>
    </div>
    <div class="text-right"><label class="text-danger"><em>删除后相应考试记录也将删除！</em></label></div>
</div>
<script>
    $("#del").click(function () {
        var input = $("#input")
        if(!/^[a-zA-Z]{2}[\d]{4}$/.test(input.val().trim())){
            $("#dlg-alert").show("normal");
            return;
        }
        var _this = $(this);
        $.moyuConfirm("是否确认删除该考卷？删除后相应考试记录也将删除！", function () {
            $(this).prop("disabled",true);
            $.ajax({
                method:"POST",
                url:"../ajax/adminDo.jsp",
                data:{
                    act:"delPaper",
                    id:input.val().trim()
                }
            }).done(function (d) {
                _this.prop("disabled",false);
                if(d==-1)
                    $.moyuAlert("未找到该考卷");
                else{
                    $.moyuAlert("删除成功");
                }
            })
        })
    })
    $('[data-toggle="tooltip"]').tooltip()
</script>