/**
 * Created by Yc on 2016/1/29.
 */
$(document).ready(function () {
    if(!window.openDatabase) {
        if(!Boolean($.cookie('session'))) {
            $.moyuAlert('该浏览器不支持websql，将会导致聊天记录异常，请使用最新的谷歌浏览器浏览 :)');
            $.cookie('session', true);
        }
        return;
    }
    var db = openDatabase('msgDB','','msgDB',1024*1024*50);//50M
    createDBTable = function(){
        db.transaction(function (tx) {
            tx.executeSql("create table if not exists MsgData(user varchar(12),friend VARCHAR(12),msgdata TEXT,time DATETIME)",[],
                null,
                function(){
                    $.moyuAlert('该浏览器不支持websql');
                }
            );
        })
    }();
    
    addMsgData = function (msgData) {
        if(msgData.isSelf){//to->friend
            insertDBTable(msgData.name,msgData.to,JSON.stringify(msgData),new Date(Date.parse(msgData.time)))
        }else{//name->friend
            insertDBTable(msgData.to,msgData.name,JSON.stringify(msgData),new Date(Date.parse(msgData.time)))
        }
    }
    
    insertDBTable = function(user,friend,msgdata,time){
        db.transaction(function (tx) {
            tx.executeSql("INSERT INTO MsgData VALUES(?,?,?,?)",[user,friend,msgdata,time]);
        })
    }
    resetMsgTable = function(){
        db.transaction(function (tx) {
            tx.executeSql('DELETE FROM MsgData');
        })
    }
    removeDBTable = function(user,friend){
        db.transaction(function (tx) {
            tx.executeSql("DELETE FROM MsgData WHERE friend=? AND user=?",[friend,user]);
        })
    }
    selectDBTable = function (user,friend) {
        db.transaction(function (tx) {
            tx.executeSql("select msgdata from MsgData WHERE friend = ? AND user=? ORDER BY `time`;",
                [friend,user],
                function(tx,rs){
                    console.log(rs.rows)
                }
            );
        })
    }

    selectLatestDBTable = function (user,friend,n,f) {
        db.transaction(function (tx) {
            tx.executeSql(
                "SELECT msgdata FROM (select * from MsgData WHERE friend = ? AND user=? ORDER BY `rowid` LIMIT 0,?) as b",
                [friend,user,n],
                function(tx,rs){
                    console.log(rs.rows)
                    f(rs.rows);
                }
            );
        })
    }
    selectMsgDBTable = function (user,friend,page,size,f) {
        db.transaction(function (tx) {
            tx.executeSql(
                "SELECT msgdata FROM MsgData WHERE user=? AND friend = ? ORDER BY `rowid` LIMIT ?,?",
                [user,friend,(page-1)*size,size],
                function(tx,rs){
                    console.log(rs.rows)
                    f(rs.rows);
                }
            );
        })
    }

    
    showLastestHistory = function (user,friend,afterF) {
        var n = 5;
        selectLatestDBTable(user,friend,n, function (data) {
            if(ws.receiveHandle)
                for(var i=0;i<data.length;i++)
                    ws.receiveHandle(JSON.parse(data[i].msgdata))
            if(data.length!=0)
                afterF();
        });
    }
});