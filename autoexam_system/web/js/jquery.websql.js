/**
 * Created by Yc on 2015/12/13.
 */
(function($) {
    $.websql = function(options) {
        var defaults = {
            version:'',
            name:'defaultDB',
            display:'defaultDB',
            size:1024*5,
            createpars:[]
        };
        var opts = $.extend(defaults,options);
        var db;
        var event = {
            init:function(){
                db = openDatabase(opts.name,opts.version,opts.display,opts.size,
                    function () {
                        if(opts.init){
                            opts.init();
                        }
                    }
                )
            },
            execute: function (sql,pars) {
                db.transaction(function (tx) {
                    if(opts.createsql!=null)
                        tx.executesql(opts.createsql,opts.createpars);
                    tx.executeSql(sql,pars);
                },this.success,this.error)
                return $.websql;
            },
            success: function (tx,rs) {
                if(opts.success)
                    opts.success(tx,rs)
                return $.websql;
            },
            error: function (tx,ex) {
                if(opts.error)
                    opts.error(tx,ex)
                return $.websql;
            }
        }

        event.init();
        this.execute = event.execute;
        this.success = event.success;
        this.error = event.error;
        return this;
    };
})(jQuery);