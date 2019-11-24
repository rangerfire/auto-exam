<%@ page import="top.moyuyc.jdbc.HeadAcess" %>
<%@ page import="top.moyuyc.entity.UserHead" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="top.moyuyc.jdbc.UserPaperAcess" %>
<%@ page import="top.moyuyc.tools.Tools" %>
<%@ page import="top.moyuyc.entity.PKHistory" %>
<%@ page import="top.moyuyc.jdbc.PKHistoryAcess" %>
<%
    String user = session.getAttribute("username").toString();
    String headPath = Tools.getUserHeadPath(user,config);

%>

<jsp:include page="template/toTop.html"></jsp:include>
<script src="js/chat.js"></script>

<script>
    $(document).ready(function () {

        var um = UM.getEditor("myEditor", {
            allowDivTransToP: false,
            initialContent: '输入后 Ctrl+Enter 发送',
            autoHeightEnabled: true,
            autoFloatEnabled: true,
            focus:true,
            enterTag:'br',
            initialFrameWidth:'100%'
        });

        var chat = $('#myEditor')

        var $tab = $('#left-tab');
        var $bd = $('#left-tabpane');
        // 移除标签页
        $tab.on('click', '.am-icon-close', function() {
            var $item = $(this).closest('li');
            var index = $tab.children('li').index($item);

            $item.remove();
            $bd.find('.tab-pane').eq(index).remove();

            index = index > 0 ? index - 1 : index + 1
            $tab.find('li').eq(index).find('a').tab('show')
        });

        addTab=function (text,data,tag,pane_id) {
            var find = $tab.children('li').children('a').filter('[tab-tag='+tag+']');
            var url = null;
            switch(tag){
                case 'userSearch':
                    url='ajax/userSearch_load.jsp';
                    break;
                case data.friend:
                    url='ajax/chatTab_load.jsp';
                    break;
            }
            if(find.length!=0) {
                find.click()
                $('#'+pane_id).empty().append('<div class="text-center" style=""><a href="javascript:;">' +
                        '<img width="48" height="48" id="loading" src="images/loading.gif">' +
                        '</a></div>')
                setTimeout(function () {
                    $('#'+pane_id).load(url,data,function(){
                        $('#loading').remove();
                    })
                },500)

                return;
            }
            var nav = '<li><i class="am-icon-close"></i>' +
                    '<a tab-tag="'+tag+'" data-toggle="tab" aria-expanded="true" href="#'+pane_id+'">' + text + '</a></li>';

            var content = '<div class="tab-pane fade" id="'+pane_id+'"'
                    +'><div class="text-center" style=""><a href="javascript:;">' +
                    '<img width="48" height="48" id="loading" src="images/loading.gif">' +
                    '</a></div></div>';
            $tab.append(nav);
            $bd.append(content);
            $tab.children('li').children('a').filter('[tab-tag='+tag+']').click();
            setTimeout(function(){
                $('#'+pane_id).load(url,data, function () {
                    $('#loading').remove();
                    if(tag==data.friend){
                        showLastestHistory('<%=user%>',data.friend, function () {
                            var p = $('#chat-content-'+tag).children("ul");
                            p.append('<li class="text-center"><br><small class="text-info">' +
                                    '<span class="glyphicon glyphicon-time"></span> 以上为历史记录，' +
                                    '<a href="chat_history?name='+tag+'" target="_blank">点击查看更多</a></small></li>');
                        })
                    }
                })
            },500)
        }

        chat.keydown(function (event) {
            if (event.keyCode == 13 && event.ctrlKey) {
                sendMessage(um,chat,{to:'common'});
            }
        })
        $('#send').click(function () {
            sendMessage(um,chat,{to:'common'})
        })

        $('#chat-foot').get(0).oncopy= function (e) {
            e.stopPropagation();
            return true;
        }

})
</script>
<style>
    .tigger{transform:rotate(-90deg)}
    [role=tabpanel]{
        padding:20px 0px 20px;
    }
    [id*=pk-content]{
        padding:0px 20px 0px;
    }
    [id*=chat-content]{
        padding:0px 20px 0px;
    }
    .am-icon-close {
        position: absolute;
        top: 0;
        right: 10px;
        color: #888;
        cursor: pointer;
        z-index: 100;
    }
    .edui-icon-at {
        background-image: url("umeditor/themes/default/images/email.png") ;
    }
    ul,li{list-style: none}
</style>
<body oncopy="return false;">
<jsp:include page="template/imgModal.html"></jsp:include>
<div class="container">
    <hr>
    <div class="row">
        <div class="col-sm-8">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs nav-justified" id="left-tab" role="tablist">
                <li role="presentation" class="active"><a href="#chat-tab" role="tab" data-toggle="tab"><i class="am-icon-comment"></i> 公共聊天室</a></li>
                <li role="presentation"><a href="#pk-tab" role="tab" data-toggle="tab"><span class="glyphicon glyphicon-fire"></span> PK记录 <%int count = PKHistoryAcess.getUnAcceptPKCountByName(user);%>
                    <span title="新的未接受挑战" class="label label-danger" id="lab-unaccept-num"><%=count<=0?"":count%></span></a></li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content" id="left-tabpane">
                <div role="tabpanel" class="tab-pane fade in active" id="chat-tab">
                    <div id="chat-content" style="overflow-y: scroll;max-height: 800px; border-left:1px solid lightgrey;border-right:1px solid lightgrey">

                        <ul class="am-comments-list am-comments-list-flip">
                            <li style="display: none;" isSelf="true" class="am-comment am-comment-primary"><a target="_blank" href="infoshow?name=<%=user%>"><img role="img-head"
                                                                                                                                             src="<%=headPath%>"
                                                                                                                                             alt=""
                                                                                                                                             class="am-comment-avatar img-bigger"
                                                                                                                                             width="48"
                                                                                                                                             height="48"></a>

                                <div class="am-comment-main">
                                    <header class="am-comment-hd">
                                        <div class="am-comment-meta"><a href="#link-to-user" role="a-name" class="am-comment-author">某人</a>
                                            于
                                            <time>2014-7-12 15:30</time>
                                        </div>
                                        <div class="am-comment-actions">
                                            <a onclick="$('[close='+$(this).children().attr('close-tag')+']').slideUp('normal')"  href="javascript:;">
                                                <i class="am-icon-close"></i></a>
                                        </div>
                                    </header>
                                    <div class="am-comment-bd" role="chat-content">
                                    </div>
                                </div>
                            </li>
                            <li style="display: none;" isSelf="false" class="am-comment am-comment-flip"><a target="_blank" href="#link-to-user-home"><img
                                    role="img-head"
                                    alt="" class="am-comment-avatar img-bigger" width="48" height="48"></a>

                                <div class="am-comment-main">
                                    <header class="am-comment-hd">
                                        <div class="am-comment-meta"><a href="#link-to-user" role="a-name" class="am-comment-author">某人</a>
                                            于
                                            <time>
                                            </time>
                                        </div>
                                        <div class="am-comment-actions">
                                            <a onclick="$('[close='+$(this).children().attr('close-tag')+']').slideUp('normal')"  href="javascript:;">
                                                <i class="am-icon-close"></i></a>
                                        </div>
                                    </header>
                                    <div class="am-comment-bd" role="chat-content"></div>
                                </div>
                            </li>
                        </ul>


                    </div>
                    <br>
                    <div class="modal-footer" >
                        <div id="chat-foot" class="text-left">
                            <script type="text/plain" style="height:20%;width:100%" id="myEditor" class="btn-block"></script>
                            <button id="send" role="sendMsg"
                                    class="btn btn-success pull-right visible-xs visible-sm">发送
                            </button>
                        </div>
                    </div>
                    <hr>
                </div>


                <div role="tabpanel" class="tab-pane fade" id="pk-tab">
                    <div id="pk-content" style="border-left:1px solid lightgrey;border-right:1px solid lightgrey;
                                border-bottom:1px solid lightgrey">

                    </div>
                </div>
            </div>

        </div>
        <div class="col-sm-4">
            <li><div class="form-group">
                <div class="input-group">
                    <input type="text" onkeydown="if($(this).val().trim()!=''&&event.keyCode==13){ addTab('用户搜索',
                    {name:$(this).val().trim(),p:1,pagesize:12},'userSearch','userSearch-pane');$(this).val('')}" id="search_input_user" placeholder="用户搜索" class="form-control" aria-label="...">
                    <span class="input-group-btn">
                        <button onclick="if($('#search_input_user').val().trim()!=''){ addTab('用户搜索',
                        {name:$('#search_input_user').val().trim(),p:1,pagesize:12},'userSearch','userSearch-pane');$('#search_input_user').val('')}" id="search_btn" class="btn btn-default" type="button">
                            &nbsp;<i class="am-icon-search"></i>&nbsp;
                        </button>
                    </span>
                </div>
            </div></li>
            <!-- Nav tabs -->
            <ul class="nav nav-tabs nav-pills nav-justified" role="tablist">
                <li role="presentation" class="active"><a href="#chat-rooms" role="tab" data-toggle="tab"><i class="am-icon-comment"></i> 聊天室</a></li>
                <li role="presentation" id="tab-frlist" onclick="clickFriendListTab()"><a href="#friends" role="tab" data-toggle="tab"><i class="am-icon-group"></i> 好友列表</a></li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">

                <div class="tab-pane fade in active" id="chat-rooms">
                    <div class="list-group">
                        <button type="button" class="list-group-item active"><i class="am-icon-comment"></i> 公共聊天室
                            <label id="commonchat-num" style="cursor: pointer;float: right"
                                   onmouseenter="$(this).popover({trigger:'hover', content: '当前在线人数',placement:'top',container:'body'}).popover('show')" class="label label-info">1</label>
                        </button>
                    </div>
                    <hr>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="friends"></div>
            </div>
            <!--好友TOP-->
            <div id="friend-topList">
                <section class="panel panel-success portlet-item pos-rlt clearfix">
                    <header class="panel-heading">
                        <a href="topshow" target="_blank" class="btn btn-xs btn-default btn-rounded pull-right">更多</a>
                        <span class="glyphicon glyphicon-menu-down" style="transition:all 0.3s ease-in;cursor: pointer"
                              onclick="$(this).toggleClass('tigger').parent().next().slideToggle('normal');"></span> 好友排行榜 <span class="badge">积分榜</span>
                    </header>
                    <div class="panel-body">
        
                    </div>
                </section>
                <hr>
            </div>
            <!--用户TOP-->
            <div id="all-topList">
                <section class="panel panel-info portlet-item pos-rlt clearfix">
                    <header class="panel-heading">
                        <a href="topshow" target="_blank" class="btn btn-xs btn-default btn-rounded pull-right">更多</a>
                        <span class="glyphicon glyphicon-menu-down" style="transition:all 0.3s ease-in;cursor: pointer"
                        onclick="$(this).toggleClass('tigger').parent().next().slideToggle('normal');"></span> 用户排行榜 <span class="badge">积分榜</span>
                    </header>
                    <div class="panel-body">
                        
                    </div>
                </section>
            </div>
        </div>
    </div>

</div>
</body>
</html>
<script>
    var loadDiv='<div class="text-center" style=""><a href="javascript:;">' +
                '<img width="48" height="48" id="loading" src="images/loading.gif">' +
                '</a></div>';
    $(function () {
        $('[id$=topList] .panel-body').append(loadDiv);
        setTimeout(function () {
            $('#friend-topList .panel-body').empty().load('ajax/get_toplist.jsp',{top:'friend'})
            setTimeout(function () {
                $('#all-topList .panel-body').empty().load('ajax/get_toplist.jsp',{top:'all'});
            },600)
        },800);

        $('a[href=#pk-tab]').click(function () {
            $('#pk-content').empty().append(loadDiv);
            setTimeout(function () {
                $('#pk-content').load('ajax/get_pkhistory.jsp',null,function(){$.ajax({method:'POST',url:'ajax/start.jsp',data:{act:'getUnacceptNum'}})
                        .done(function(d){
                            d=d.trim();
                            $('#lab-unaccept-num').text(d<=0?'':d);
                        })})
            },500);
        })
        <%if(request.getParameter("o2ochat")!=null){
            String s = request.getParameter("o2ochat");%>
            $('#tab-frlist a').click();
            addTab('与<%=s%>聊天...',{friend:'<%=s%>',random:parseInt(Math.random()*1000000)},'<%=s%>','o2oChat-<%=s%>');
        <%}%>
    })
</script>