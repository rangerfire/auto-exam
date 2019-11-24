/**
 * Created by Yc on 2015/9/25.
 */
$(document).ready(function(){

    $("[id^=root]").off("click").click(function () {
        var tag = $(this).attr("data-tag");
        var list=$("[id^="+tag+"]");
        list.slideToggle("normal");
        if(list.css("display")!="none")
            list.css("display","")
        if($(this).attr("id")!=curExpend.attr("id")) {
            var list=$("[id^="+curExpend.attr("data-tag")+"]").slideUp("normal");
            curExpend=$(this);
        }
    });

})