/**
 * Created by Yc on 2015/12/19.
 */
$(document).ready(function () {

    ws = $.websocket({
        path: 'autoexam/websocket/chat?tag='+window.axTag,
        onReceive: function (data, time) {
            var hasNotify = false;
            data = JSON.parse(data)
            if(data.for=='common') {
                if (data.type == 'msg')
                    if (data.isSelf) addSelfMessage(data,'chat-content'); else addOtherMessage(data,'chat-content');
                else if (data.type == 'welcome') {
                    var p = $('#chat-content').children("ul");
                    $('#commonchat-num').text(data.onlinenum)
                    p.append('<li class="text-center"><h4 class="text-danger">' +
                        '欢迎 <span class="glyphicon glyphicon-user"></span> ' + data.content + ' 来到公共聊天室！</h4></li>');
                } else if (data.type == 'again') {
                    var p = $('#chat-content').children("ul");
                    $('#commonchat-num').text(data.onlinenum)
                    p.append('<li class="text-center"><h4 class="text-danger">' +
                        data.content + '</h4></li>');
                } else if (data.type == 'exit') {
                    var p = $('#chat-content').children("ul");
                    $('#commonchat-num').text(data.onlinenum)
                    p.append('<li class="text-center"><h5 class="text-info">' +
                        ' <span class="glyphicon glyphicon-user"></span> ' + data.content + ' 离开公共聊天室</h5></li>');
                }
            }else{
                var d = {}
                if(data['notify-add']!=null && data['notify-add'][0]!=null){
                    hasNotify=true;
                    d.add=data['notify-add'];
                }
                if(data['notify-ignore']!=null && data['notify-ignore'][0]!=null){
                    hasNotify=true;
                    d.ignore=data['notify-ignore'];
                }if(data['notify-remainMsg']){
                    //离线未读
                    console.log("离线未读")
                    console.log(data['notify-remainMsg'])
                    hasNotify=true;
                    for(var i in data['notify-remainMsg'])
                        addMsgData(data['notify-remainMsg'][i])
                }if(data['notify-pass']){
                    hasNotify=true;
                }

                if(ws.receiveHandle && data.for=='o2o') {
                    ws.receiveHandle(data);
                    addMsgData(data);
                    if(!data.isSelf) {
                        d.msgFrom = data.name
                        $('#notify-container').empty()
                        $('#notify-container').load("ajax/notify_load.jsp",d, function () {
                            $('#notify-container').show('normal')
                        })
                    }
                }
                else if(hasNotify || data.for=='o2o'){
                    console.log(d)
                    if(data.for=='o2o'){
                        addMsgData(data);
                        if(!data.isSelf)
                            d.msgFrom = data.name
                    }
                    $('#notify-container').empty()
                    $('#notify-container').load("ajax/notify_load.jsp",d, function () {
                        $('#notify-container').show('normal')
                    })
                }
            }
        },
        onClose: function () {
//                alert('close')
        }
    })
})