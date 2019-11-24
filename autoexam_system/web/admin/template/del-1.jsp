<br>
<div class="col-lg-2"></div>
<div class="col-lg-8">
    <div id="dlg-alert" style="display: none;" class="alert alert-warning text-center" role="alert">
        <button type="button" onclick="$('#dlg-alert').hide('normal')" class="close"><span aria-hidden="true">&times;</span></button>
        <big>请按照正确规格输入（如AZ123456789）！</big></div>
    <div class="form-group">
        <div class="input-group input-group-lg">
            <span class="input-group-addon">题号 </span>
            <input id="input-ques" type="text" class="form-control" placeholder="输入待删除的题目题号（如AZ123456789）">
            <span class="input-group-btn"><button type="button" id="search" class="btn btn-primary">搜索</button></span>
        </div>
    </div>
    <hr>
    <div id="out" style="display: none">
        <div>当前待修改题目题号 <label class="text-danger" id="ques-no"></label></div><br>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 科目
                                </span>
                <input id="out-subject" type="text" class="form-control" readonly>
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 题型
                                </span>
                <input class="form-control input-lg" id="out-type" readonly/>
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 难度
                                </span>
                <input class="form-control input-lg" id="out-lev" readonly>
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 分值
                                </span>
                <input id="out-score" readonly type="number" min="0" class="form-control">
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 问题
                                </span>
                        <textarea id="out-ques" type="text" style="height: 100px" class="form-control" readonly></textarea>
            </div>
        </div>
        <div class="form-group" id="choose-list">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 选项
                                </span>
                <select multiple id="out-chooselist" class="form-control" style="height: 100px" readonly>
                </select>
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 答案
                                </span>
                        <textarea readonly id="out-answer" type="text"  style="height: 100px" class="form-control"></textarea>
            </div>
        </div>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">解析</span>
                        <textarea readonly id="out-analy" type="text" style="height: 100px" class="form-control"></textarea>
            </div>
        </div>
        <div class="form-group text-center">
            <button id="btn-del-ques" class="btn btn-block btn-lg btn-danger">确认删除</button>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#input-ques").keydown(function (e) {
            if(e!=null && e.keyCode==13)
                $("#search").click();
        });
        $("#search").click(function () {
            var input = $("#input-ques");
            if(!/^[a-zA-Z]{2}[\d]{9}$/.test(input.val().trim())){
                $("#dlg-alert").show("normal");
            }else{
                var _this = $(this);
                $(this).prop("disabled",true);
                $.ajax({
                    method:"POST",
                    url:"../ajax/adminDo.jsp",
                    data:{
                        act:"getQuesById",
                        quesno:input.val().trim().toUpperCase()
                    }
                }).done(function (d) {
                    _this.prop("disabled",false);
                    if(d==-1)
                        $.moyuAlert("题目未找到，请核实题号");
                    else{
                        d = JSON.parse(d);
                        console.log(d)
                        $("#ques-no").text(d.id);
                        $("#out-subject").val(d.ques_subject);
                        $("#out-type").val(d.ques_type=="single_choose"?"单选题":(d.ques_type=="muti_choose"?"多选题":
                                (d.ques_type=="judgement"?"判断题":"简答题")));
                        $("#out-lev").val(d.lev==0?"困难":(d.lev==1?"适中":"简单"));
                        $("#out-score").val(d.ques_score);
                        if(d.ques_content!=null)
                            $("#out-ques").val(d.ques_content[0])
                        if(d.ques_analy==''){
                            $("#out-analy").parent().hide();
                        }else {
                            $("#out-analy").val(d.ques_analy).parent().show()
                        }
                        $("#out-answer").parent().show();
                        if(d.ques_type=='single_choose' || d.ques_type=='muti_choose'){
                            $("#choose-list").show();
                            $("#out-chooselist").empty()
                            var char = 65;
                            for(var i =1; i< d.ques_content.length; i++)
                                $("#out-chooselist").append('<option>'+ String.fromCharCode(char++)+"."+ d.ques_content[i]+'</option>');
                            for(var i =0; i< d.ques_answer.length; i++)
                                $("#out-answer").val(d.ques_answer[i]);
                        }else{
                            $("#choose-list").hide();
                            if(d.ques_answer.length==0 || d.ques_answer[0]=='')
                                $("#out-answer").parent().hide();
                            else
                                $("#out-answer").val(d.ques_answer[0]).parent().show()
                        }

                        $("#out").slideDown("normal");
                    }
                })
            }

        })
        $("#btn-del-ques").click(function () {
            var out = $("#ques-no"),_this = $(this);
            if(out.text().trim()=="")  return;
            $.moyuConfirm("删除题目后，对应的考卷与考试记录也将作出修改！是否删除？",function(){
                _this.prop("disabled",true);
                $.ajax({
                    method:"POST",
                    url:"../ajax/adminDo.jsp",
                    data:{
                        act:"delQues",
                        id:out.text().trim()
                    }
                }).done(function (d) {
                    _this.prop("disabled",false);
                    if(d==-1)
                        $.moyuAlert("该题目未找到，删除失败！")
                    else {
                        $("#out").slideUp("normal");
                        $.moyuAlert("删除成功！")
                    }
                })
            })
        })
    })
</script>