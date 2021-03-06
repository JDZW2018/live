var grid_selector = "#grid-table";
var pager_selector = "#grid-pager";
jQuery(function ($) {
    var parent_column = $(grid_selector).closest('[class*="col-"]');
    $(window).on('resize.jqGrid', function () {
        $(grid_selector).jqGrid('setGridWidth', parent_column.width());
    });
    $(document).on('settings.ace.jqGrid', function (ev, event_name, collapsed) {
        if (event_name === 'sidebar_collapsed' || event_name === 'main_container_fixed') {
            //setTimeout is for webkit only to give time for DOM changes and then redraw!!!
            setTimeout(function () {
                $(grid_selector).jqGrid('setGridWidth', parent_column.width());
            }, 20);
        }
    });
    $("#find").on("click",function(){
        var keyword=$("#keyword").val();
        $("#grid-table").jqGrid('setGridParam',{
            postData:{"keyword":encodeURI(keyword)},
            rows:20
        }).trigger('reloadGrid');
    });

    jQuery(grid_selector).jqGrid({
        url: base + "letter/getLetterPage?r="+Math.random(),
        subGrid: false,
        datatype: "json",
        height: 'auth',
        colNames: ['id', '用户名称','昵称','手机号','内容','发送时间','操作'],
        colModel: [
            {name: 'userId', index: 'userId', width: 200, editable: true, hidden: true, key: true},
            {name: 'userName', index: 'userName', width: 90},
            {name: 'nickName', index: 'nickName', width: 90},
            {name: 'phone', index: 'phone', width: 90},
            {name: 'content', index: 'content', width: 90},
            {name: 'createTime', index: 'createTime', width: 160,
                formatter:function (cellvalue, options, rowObject) {
                    if(typeof(cellvalue) != "undefined"){
                        return new Date(cellvalue).pattern("yyyy-MM-dd HH:mm:ss");
                    }else{
                        return '';
                    }
                }
            },
            {name:'',index:'', width:90, fixed:true, sortable:false, resize:false,
                formatter: function(cellvalue, options, rowObject) {
                    return '<a type="button" class="btn btn-white btn-sm btn-primary" onclick="sendMessage(\''+rowObject.userId+'\')">发送私信</a>';
                }
            }
        ],
        jsonReader: {
            root: "list",
            page: "pageNum",
            total: "pages",
            records: "total"
        },
        pgtext: "第 {0} 页，共 {1}页",
        recordtext: "第 {0} 到 {1} 共 {2} 条",
        viewrecords: true,
        rowNum: 10,
        rowList: [10,20,30],
        pager: pager_selector,
        altRows: true,
        //toppager: true,
        multiselect: false,
        //multikey: "ctrlKey",
        multiboxonly: true,
        loadComplete: function () {
            var table = this;
            setTimeout(function () {
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },
        caption: "私信列表",
        autowidth: true
    });

    $(window).triggerHandler('resize.jqGrid');//trigger window resize to make the grid get the correct size
    var alertText = "<div style='margin:0.3em; background:#FFFFFF; border:1px solid #A6C9E2; padding: 0.5em;' mce_style='margin:0.3em; background:#FFFFFF; border:1px solid #A6C9E2; padding: 0.5em;'>请选择需要操作的数据行!</div>";
    //navButtons
    jQuery(grid_selector).jqGrid('navGrid', pager_selector,
        {
            edit: false,
            add: false,
            del:false,
            search:false,
            refresh: true,
            refreshicon: 'ace-icon fa fa-refresh yellow',
            alerttext : "请选择需要操作的数据行!",
        }
    ).navSeparatorAdd(pager_selector,{
        sepclass:"ui-separator",
        sepcontent:""
    }).navButtonAdd(pager_selector,{ //新增加载全部按钮
        caption:"",
        buttonicon:"ace-icon fa fa-users yellow ",
        title:"Load All User",
        onClickButton: function(){
            getJQAllData();
        },
        position:"last"
    })

    //replace icons with FontAwesome icons like above
    function updatePagerIcons(table) {
        var replacement =
            {
                'ui-icon-seek-first': 'ace-icon fa fa-angle-double-left bigger-140',
                'ui-icon-seek-prev': 'ace-icon fa fa-angle-left bigger-140',
                'ui-icon-seek-next': 'ace-icon fa fa-angle-right bigger-140',
                'ui-icon-seek-end': 'ace-icon fa fa-angle-double-right bigger-140'
            };
        $('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function () {
            var icon = $(this);
            var $class = $.trim(icon.attr('class').replace('ui-icon', ''));

            if ($class in replacement) icon.attr('class', 'ui-icon ' + replacement[$class]);
        })
    }

    function enableTooltips(table) {
        $('.navtable .ui-pg-button').tooltip({container: 'body'});
        $(table).find('.ui-pg-div').tooltip({container: 'body'});
    }

    //var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');
    $(document).one('ajaxloadstart.page', function (e) {
        $.jgrid.gridDestroy(grid_selector);
        $('.ui-jqdialog').remove();
    });

    $.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
        _title: function (title) {
            var $title = this.options.title || '&nbsp;'
            if (("title_html" in this.options) && this.options.title_html == true)
                title.html($title);
            else title.text($title);
        }
    }));
});

var userType = function(v){
    if (v == 1) {
        return "<span class=\"label label-info arrowed-in-right arrowed\">教头</span>";
    } else if (v == 2) {
        return "<span class=\"label label-success arrowed\">用户</span>";
    }else{
        return '';
    }
}

var userIdentity = function(v){
    if (v == 1) {
        return "<span class=\"btn btn-white btn-danger btn-sm\">普通用户</span>";
    } else if (v == 2) {
        return "<span class=\"btn btn-white btn-inverse btn-sm\">会员用户</span>";
    }else{
        return '';
    }

}

var labelname = function(v){
    if(isEmpty(v)){
        return '';
    }
    return "<span class=\"label label-lg label-yellow arrowed-in arrowed-in-right\">"+v+"</span>";
}

var stuname = function(v){
    if(isEmpty(v)){
        return '';
    }
    return "<span class=\"label label-green arrowed-in\">"+v+"</span>";
}

var sendMessage = function(userId){
    location.href = base + "/letter/letterList?rows=10&page=1&userId="+userId;
}

$("#sendMessageBtn").bind("click",function(){
    if(isEmpty($("#content").val())){
        Modal.alert({msg : "内容为空", title : "提示", btnok : "确定", btncl : "取消"});
        return;
    }
    if(confirm("确认要发送本条信息？")){
        $.ajax({
            url:base+"mail/addRecord",
            data:$("#sendMessage-form").serialize(),
            type:"POST",
            dateType:"json",
            success:function(data){
                if("success" == data.status){
                    Modal.alert({msg : "发送成功！", title : "提示", btnok : "确定", btncl : "取消"});
                    $("#content").val("");
                    $("#userIds").val("");
                    $("#addModal").modal("hide");
                }else{
                    Modal.alert({msg : data.message, title : "提示", btnok : "确定", btncl : "取消"});
                }
            },
            error:function(data){
                Modal.alert("系统异常，请稍后重试！");
            }
        })
    }
})

var sendMessageAll = function(){
    var obj = $(grid_selector).jqGrid("getRowData");
    if(isNotEmpty(obj) && obj.length>0){
        if(confirm("确认要给本页的"+obj.length+"位会员发送站内信？")){
            var userIds ="";
            for(var str in obj){
                userIds += ","+obj[str].userId;
            }
            if(isNotEmpty(userIds)){
                userIds = userIds.substring(userIds.indexOf(",")+1);
            }
            $("#userIds").val(userIds);
            $("#addModal").modal("show");
        }
    }else{
        Modal.alert({msg :"数据为空！", title : "提示", btnok : "确定", btncl : "取消"});
    }
}

//获取当前表格的所有数据
function getJQAllData() {
     location.href = base + "letter/sendUser"
}


