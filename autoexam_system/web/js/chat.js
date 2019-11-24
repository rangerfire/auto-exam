/**
 * Created by Yc on 2016/1/29.
 */
$(document).ready(function () {
    timeFormat = function(t){
        return t.substring(0,t.lastIndexOf(':'));
    }
    // 初始化消息输入框
    var mesnum=0;
    sendMessage = function (um,chat,flag) {
        if (!um.hasContents()) {
            chat.addClass('am-animation-shake')
            setTimeout('chat.removeClass("am-animation-shake")', 1000)
            return;
        }
        ws.send(JSON.stringify({
            to:flag.to,
            content: um.getContent()
        }));
        um.setContent('')
    }
    addSelfMessage = function (data,contentID) {
        console.log(data)
        var p = $('#'+contentID)
        var c =p.children('ul');
        var line = c.find('[isSelf=true]').clone().show().removeAttr('isSelf').attr('close',mesnum);
//            line.find('[role=img-head]');
        line.find('[role=a-name]').text(data.name)
        line.find('time').text(timeFormat(data.time))
        var content = line.find('[role=chat-content]').html(data.content)
        line.find('.am-icon-close').attr('close-tag',mesnum);
        mesnum++;
        c.append(line)
        if(data.onlinenum)
            $('#commonchat-num').text(data.onlinenum)
        content.MediaShow(function () {
            p.scrollTop(p.prop('scrollHeight'))
        });
    }
    addOtherMessage = function (data,contentID) {
//                data = JSON.parse(data)
        console.log(data)
        var p = $('#'+contentID);
        var c =p.children('ul')
        var line = c.find('[isSelf=false]').clone().show().removeAttr('isSelf').attr('close',mesnum);
        line.find('[role=img-head]').prop('src',data.head).parent().attr('href','infoshow?name='+data.name);
        line.find('[role=a-name]').text(data.name).attr('href','infoshow?name='+data.name);
        line.find('time').text(timeFormat(data.time))
        var content = line.find('[role=chat-content]').html(data.content)
        line.find('.am-icon-close').attr('close-tag',mesnum++);
        c.append(line)
        if(data.onlinenum)
            $('#commonchat-num').text(data.onlinenum)
        content.MediaShow(function () {
            p.scrollTop(p.prop('scrollHeight'))
        });
    }



    var first = true;
    clickFriendListTab = function (p){
        var id = first?'#friends':'#friends-list';
        $(id).empty().append('<div class="text-center" style=""><a href="javascript:;">' +
            '<img width="48" height="48" id="loading" src="images/loading.gif">' +
            '</a></div>')
        if(!arguments[0]) p = 1;
        setTimeout(function () {
            var data={p:p};
            console.log(data);
            if(first)
                $(id).load('ajax/friends_list_load.jsp',data,function(){
                    $('#loading').remove();
                })
            else
                $(id).load('ajax/friends_list_load.jsp #friends-list',data,function(){
                    $('#loading').remove();
                })
            first = false;
        },500)
    }

})
