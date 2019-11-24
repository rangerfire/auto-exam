<div class="row">
    <br>
    <div class="col-lg-8 col-lg-offset-2">
        <div class="form-group">
            <div class="input-group input-group-lg">
                <span class="input-group-addon">题号</span>
                <input id="search-quesno" type="text" class="form-control" placeholder="输入待修改的题目题号（如AZ123456789）">
                <span class="input-group-btn">
                <button id="btn-ques-search" class="btn btn-primary" type="button">搜索</button>
                </span>
            </div>
        </div>
        <hr>
        <div id="result" style="display: none;">
        <div>当前待修改题目题号 <label class="text-danger" id="ques-no"></label></div><br>
        <div class="form-group">
            <div class="input-group input-group-lg">
                                <span class="input-group-addon">
                                 科目
                                </span>
                <input id="input-subject" type="text" class="form-control" disabled
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
            <button id="btn-change-ques" class="btn btn-block btn-lg btn-primary">修改问题</button>
        </div>
        </div>
    </div>
</div>


<script>
    $(document).ready(function(){
        $("#btn-ques-search").click(function(){
            if(!/^[a-zA-Z]{2}[\d]{9}$/.test($("#search-quesno").val().trim())) {
                $.moyuAlert('请正确输入！');
                return;
            }
            $("#btn-ques-search").prop("disabled",true);
            $.ajax({
                method: 'POST',
                url:'../ajax/adminDo.jsp',
                data: {
                    act: 'getQuesById',
                    quesno: $("#search-quesno").val().trim()
                }
            }).fail(function(){$("#btn-ques-search").prop("disabled",false);}).done(function(d){
                $("#btn-ques-search").prop("disabled",false);
                if(d==-1){
                    $.moyuAlert('未找到相应的题目')
                }
                else{
                    d=JSON.parse(d)
                    console.log(d)
                    $("#ques-no").text(d.id);
                    $("#input-subject").val(d.ques_subject);
                    var type=null;
                    switch (d.ques_type){
                        case 'single_choose':type=0; break;
                        case 'muti_choose':type=1; break;
                        case 'judgement':type=2; break;
                        case 'short_answer':type=3; break;
                    }
                    if(type>1){
                        $("#btn-add-choose,#btn-del-choose").addClass("disabled")
                    }
                    $("#select-type").find("[value="+type+"]").attr("selected",true);
                    $("#select-lev").find("[value="+ d.lev+"]").attr("selected",true);
                    $("#input-score").val(d.ques_score)
                    $("#input-ques").val(d.ques_content[0])
                    var charCode=65;
                    $("select[multiple]").empty();
                    for(var i=1;i<d.ques_content.length;i++)
                        $("select[multiple]").append('<option value="'+ d.ques_content[i]+'">'+String.fromCharCode(charCode++)+'.'+d.ques_content[i]+'</option>')
                    var answer='';
                    if(d.ques_answer!=null)
                        for(var i=0;i< d.ques_answer.length;i++){
                            if(i==0)
                                answer+= d.ques_answer[i];
                            else
                                answer+="###" + d.ques_answer[i];
                        }
                    $("#input-answer").val(answer);
                    $("#input-analy").val(d.ques_analy==null?'':d.ques_analy);
                    $("#result").slideDown("normal");
                }
            })
        })
        $("#search-quesno").keydown(function(e){
            if(e!=null && e.keyCode==13)
                $("#btn-search").click()
        });

        $("#btn-change-ques").click(function(){
            $(this).on('shown.bs.popover', function () {
                var t=$(this)
                setTimeout(function(){
                    t.popover('destroy')
                },2000)
            })
            if($("#input-score").val().trim()==''||$("#input-ques").val().trim()==''
                    ||isNaN($("#input-score").val().trim()))
            {
                $("#btn-change-ques").popover({
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
                if($("#input-answer").val().trim()==''||$("select[multiple]>option").length==0){
                    $("#btn-change-ques").popover({
                        html:true,
                        trigger:'manual',
                        placement:'top',
                        content:'<label style="color: red"> 请正确输入答案和选项！</label>',
                        container:'body'
                    }).popover('show');
                    return;
                }
            }
            else if($("#select-type>option:selected").val()==2){//judge
                if($("#input-answer").val().trim()==''){
                    $("#btn-change-ques").popover({
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
            $("#btn-change-ques").attr("disabled",true);
            $.ajax({
                method:"POST",
                url:"../ajax/adminDo.jsp",
                data:{
                    act:'changeQuestion',
                    id:$("#ques-no").text().trim(),
                    type:type,
                    score:$("#input-score").val().trim(),
                    content:content,
                    answer:$("#input-answer").val().trim(),
                    analy:$("#input-analy").val().trim(),
                    lev:$("#select-lev>option:selected").val().trim()
                }
            }).fail(function(e){
                $("#btn-change-ques").attr("disabled",false);
                $.moyuAlert("Error: "+ e.status);
            }).done(function(d){
                $("#btn-change-ques").attr("disabled",false);
                if(d==-1)
                    $("#btn-change-ques").popover({
                        html:true,
                        trigger:'manual',
                        placement:'top',
                        content:'<label style="color: red"></span> 修改题目失败！</label>',
                        container:'body'
                    }).popover('show');
                else {
                    $("#btn-change-ques").popover({
                        html: true,
                        trigger: 'manual',
                        placement: 'top',
                        content: '<label class="text-success"> 题目已经正确修改！</label>',
                        container:'body'
                    }).popover('show');
                }
            });

        })

        $("#btn-add-choose").click(function(){
            if($("#input-choose").val().trim()=='')  return;
            var option_num=$("#choose-list select>option").length;
            var tags="ABCDEFGHIJK";
            var op=document.createElement("option");
            $(op).val($("#input-choose").val().trim());
            $(op).text(tags[option_num]+'.'+$("#input-choose").val().trim());
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
    });

</script>