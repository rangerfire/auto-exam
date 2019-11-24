<br>
<ul class="nav nav-tabs text-center">
    <li style="width: 50%" class="active">
        <a href="#div-single-add" id="tab-single-add">
            单个添加
        </a>
    </li>
    <li style="width: 50%">
        <a href="#div-file-add" id="tab-file-add">
            文件导入
        </a>
    </li>
</ul>
<div class="tab-content">
    <div id="div-single-add" class="tab-pane fade in active">
        <div class="row">
            <br><br>
            <div class="col-lg-2"></div>
            <div class="col-lg-8 form-group">
                    <div class="form-group">
                        <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 科目
                                </span>
                            <input id="input-subject" type="text" class="form-control"
                                   placeholder="输入学科">
                        </div>
                    </div>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 题型
                                </span>
                        <select class="form-control input-lg" id="select-type">
                            <option value="0">单选</option>
                            <option value="1">多选</option>
                            <option value="2">判断</option>
                            <option value="3">简答</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 难度
                                </span>
                        <select class="form-control input-lg" id="select-lev">
                            <option value="2">简单</option>
                            <option value="1">适中</option>
                            <option value="0">困难</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 分值
                                </span>
                        <input id="input-score" type="number" min="0" class="form-control"
                               placeholder="输入分值">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 问题
                                </span>
                        <textarea id="input-ques" type="text" style="height: 100px" class="form-control"
                               placeholder="输入问题"></textarea>
                    </div>
                </div>
                <div class="form-group" id="pane-choose">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 选项
                                </span>
                        <input id="input-choose" type="text" class="form-control"
                               placeholder="输入选项">
                        <a id="btn-add-choose" class="btn btn-success input-group-addon">添加选项</a>
                    </div>
                </div>
                <div class="form-group" id="choose-list">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 结果
                                </span>
                        <select multiple class="form-control" style="height: 100px">
                        </select>
                        <a id="btn-del-choose" class="btn btn-danger input-group-addon">删除选项</a>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 答案
                                </span>
                        <textarea id="input-answer" type="text"  style="height: 100px" class="form-control"
                               placeholder="输入答案，多选答案用###间隔(简答非必填)"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 解析
                                </span>
                        <textarea id="input-analy" type="text" style="height: 100px" class="form-control"
                               placeholder="输入解析(非必填)"></textarea>
                    </div>
                </div>
                <div class="form-group text-center">
                    <button id="btn-add-user" class="btn btn-block btn-lg btn-primary">添加新问题</button>
                </div>
            </div>
        </div>
    </div>
    <div id="div-file-add" class="tab-pane fade in">
        <div class="row">
            <br><br>
            <div class="col-lg-2"></div>
            <form class="col-lg-8" method="post" action="/admin/upload.jsp"
                  target="hideframe" enctype="multipart/form-data">
                <div class="form-group">
                    <div class="input-group input-group-lg" >
                        <span class="input-group-addon help-block">
                         excel文件上传(*.xls;*.xlsx)
                        </span>
                        <input type="file" class="form-control" name="up-file">
                    </div>
                </div>
                <div class="form-group">
                    <button id="btn-file-up"
                            onclick="return confirm('是否确定上传？')"
                            type="submit" class="btn btn-block btn-lg btn-success">文件上传</button>
                </div>
                <a class="btn btn-link" href="/admin/template/template.xls">数据模板下载</a>
                <a class="btn btn-link" href="/admin/log.txt" target="_blank">日志信息查看</a>
            </form>
            <iframe name="hideframe" style=' display:none;'></iframe>
        </div>
    </div>
</div>

<div class="modal fade" id="load-modal" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
            <img src="/images/loading.gif">
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
//    function fileUpCompelete(d){
//        $('#load-modal').modal('hide')
//        alert(d);
//    }
    $(document).ready(function(){
        $("#btn-add-user").click(function(){
            $(this).on('shown.bs.popover', function () {
                var t=$(this)
                setTimeout(function(){
                    t.popover('destroy')
                },2000)
            })
            if($("#input-subject").val().trim()==''||$("#input-score").val().trim()==''||$("#input-ques").val().trim()==''
                    ||isNaN($("#input-score").val().trim()))
            {
                $("#btn-add-user").popover({
                    html:true,
                    trigger:'manual',
                    placement:'top',
                    content:'<label style="color: red"> 请正确输入！</label>',
                    container:'body'
                }).popover('show');
                return;
            }
            if($("#select-type>option:selected").val()<2)//single_choose muti_choose
            {
                var ans=$("#input-answer").val().trim().split("###")
                for(var i=0;i<ans.length;i++) {
                    if (ans[i].length > 1 || !/^[A-Z]$/.test(ans[i])){
                        $("#btn-add-user").popover({
                            html: true,
                            trigger: 'manual',
                            placement: 'top',
                            content: '<label style="color: red"> 请正确输入答案！</label>',
                            container:'body'
                        }).popover('show');
                        return;
                    }
                }
                if($("#input-answer").val().trim()==''||$("select[multiple]>option").length==0){
                    $("#btn-add-user").popover({
                        html:true,
                        trigger:'manual',
                        placement:'top',
                        content:'<label style="color: red"> 请正确输入答案或选项！</label>',
                        container:'body'
                    }).popover('show');
                    return;
                }
            }
            else if($("#select-type>option:selected").val()==2){//judge
                if($("#input-answer").val().trim()==''){
                    $("#btn-add-user").popover({
                        html:true,
                        trigger:'manual',
                        placement:'top',
                        content:'<label style="color: red"> 请正确输入答案！</label>',
                        container:'body'
                    }).popover('show');
                    return;
                }
            }


            var type;
            switch (Number($("#select-type").val())){
                case 0:type="single_choose"; break;
                case 1:type="muti_choose"; break;
                case 2:type="judgement"; break;
                case 3:type="short_answer"; break;
            }
            var content=$("#input-ques").val().trim();
            if(($("#select-type").val())<2){
                $("select[multiple]>option").each(function(){
                    content+="###"+$(this).val();
                });
            }
            console.log(content);
            $("#btn-add-user").attr("disabled",true);
            $.ajax({
                method:"POST",
                url:"../ajax/adminDo.jsp",
                data:{
                    act:'addQuestion',
                    subject:$("#input-subject").val().trim(),
                    type:type,
                    score:$("#input-score").val().trim(),
                    content:content,
                    answer:$("#input-answer").val().trim(),
                    analy:$("#input-analy").val().trim(),
                    lev:$("#select-lev>option:selected").val().trim()
                }
            }).fail(function(e){
                $("#btn-add-user").attr("disabled",false);
                $.moyuAlert("Error: "+ e.status);
            }).done(function(d){
                $("#btn-add-user").attr("disabled",false);
                if(d==-1)
                    $("#btn-add-user").popover({
                        html:true,
                        trigger:'manual',
                        placement:'top',
                        content:'<label style="color: red"></span> 添加题目失败！</label>',
                        container:'body'
                    }).popover('show');
                else {
                    $("#btn-add-user").popover({
                        html: true,
                        trigger: 'manual',
                        placement: 'top',
                        content: '<label class="text-success"> 题目已经正确添加！</label>',
                        container:'body'
                    }).popover('show');
                    $("#div-single-add [id^=input]").val("");
                    $("select[multiple]").empty();
                }
            });

        })



        $("#btn-add-choose").click(function(){
            if($("#input-choose").val().trim()=='')  return;
            var option_num=$("#choose-list select>option").length;
            var tags=65;
            var op=document.createElement("option");
            $(op).val($("#input-choose").val().trim());
            $(op).text(String.fromCharCode(tags+option_num)+'.'+$("#input-choose").val().trim());
            $("#choose-list select").append($(op))
            $("#input-choose").val('')
        });
        $("#btn-del-choose").click(function(){
            $("#choose-list select>option:selected").remove();
        });

        $("#select-type").click(function(){
           if($(this).val()>1)
               $("#btn-del-choose,#btn-add-choose").addClass("disabled");
           else
               $("#btn-del-choose,#btn-add-choose").removeClass("disabled");
        });


        $("#tab-single-add").click(function(){
            $("#tab-file-add").parent().removeClass("active");
            $(this).parent().addClass("active");

            $($("#tab-file-add").attr("href")).hide();
            $($(this).attr("href")).slideDown("normal");
        })
        $("#tab-file-add").click(function(){
            $("#tab-single-add").parent().removeClass("active");
            $(this).parent().addClass("active");

            $($("#tab-single-add").attr("href")).hide();
            $($(this).attr("href")).slideDown("normal");
        })

    })
</script>