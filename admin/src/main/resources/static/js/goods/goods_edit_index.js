jQuery(function ($) {

    init();

    initGoodsCatComboTree($("#catIdStr").val(),$("#catNameStr").val());
    //提交Form表单新增商品信息
    $("#addGoods").click(function(){
        var $form = $("#update-form-goods");
        var goodsName = $form.find("input[name=goodsName]").val();
        var goodsNumber = $form.find("input[name=goodsNumber]").val();
        var unit = $form.find("input[name=unit]").val();
        var catId = $form.find("input[name=catId]").val();
        var imageUrl1 = $form.find("#goodsImgId1").val();
        var seqno1 = $form.find("#seqno1").val();
        var imageUrl2 = $form.find("#goodsImgId2").val();
        var seqno2 = $form.find("#seqno2").val();
        var imageUrl3 = $form.find("#goodsImgId3").val();
        var seqno3 = $form.find("#seqno3").val();
        var imageUrl4 = $form.find("#goodsImgId4").val();
        var seqno4 = $form.find("#seqno4").val();
        var imageUrl5 = $form.find("#goodsImgId5").val();
        var seqno5 = $form.find("#seqno5").val();
        if(isEmpty(goodsName)){
            Modal.alert({msg : "商品名称必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(goodsNumber)){
            Modal.alert({msg : "商品编号必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(unit)){
            Modal.alert({msg : "商品单位必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(catId)){
            Modal.alert({msg : "商品分类必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(imageUrl1) && isEmpty($("#imageUrl1").val())){
            Modal.alert({msg : "商品图片1必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(seqno1)){
            Modal.alert({msg : "商品图片1序号必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(imageUrl2) && isEmpty($("#imageUrl2").val())){
            Modal.alert({msg : "商品图片2必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(seqno2)){
            Modal.alert({msg : "商品图片2序号必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(imageUrl3)  && isEmpty($("#imageUrl3").val())){
            Modal.alert({msg : "商品图片3必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(seqno3)){
            Modal.alert({msg : "商品图片3序号必填", title : "提示", btnok : "确定"});
            return false;
        }

        if(isEmpty(imageUrl4)  && isEmpty($("#imageUrl4").val())){
            Modal.alert({msg : "商品图片4必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(seqno4)){
            Modal.alert({msg : "商品图片4序号必填", title : "提示", btnok : "确定"});
            return false;
        }

        if(isEmpty(imageUrl5)  && isEmpty($("#imageUrl5").val()) ){
            Modal.alert({msg : "商品图片5必填", title : "提示", btnok : "确定"});
            return false;
        }
        if(isEmpty(seqno5)){
            Modal.alert({msg : "商品图片5序号必填", title : "提示", btnok : "确定"});
            return false;
        }

       $("#addGoods").attr("disabled",true);
       $("#addGoods").text("商品发布中....");
        $("#update-form-goods").ajaxSubmit({
            type:"post",
            dataType:"json",
            url:base+"goods/modifyGoods",
            success: function(data) {
                $("#addGoods").attr("disabled",false);
                if(data == 1){
                    Modal.alert({msg : "修改成功！", title : "提示", btnok : "确定"});
                    emptyForm('add-form-goods');
                    location.href=base+'goods/goods_index';
                }else{
                    Modal.alert({msg : "修改失败！", title : "提示", btnok : "确定"});
                    $("#addGoods").attr("disabled",false);
                    $("#addGoods").text("重新发布");
                }
            },
            error:function(data){
                $("#addGoods").attr("disabled",false);
                $("#addGoods").text("重新发布");
                Modal.alert({msg : "系统异常，请稍后重试", title : "提示", btnok : "确定"});
            }
        });
    });
});


//初始化商品分类comboTree
function initGoodsCatComboTree(catId,catName){
   $('#catId').combotree ({
        url: base + 'goodsCat/searchGoodsCateByParentId?parentId=-1',
        onBeforeExpand:function(node) {
            $('#catId').combotree("tree").tree("options").url = base + 'goodsCat/searchGoodsCateByParentId?parentId=' + node.id;
        },
        onClick:function(node){
        },
       onLoadSuccess:function(node,data){
           // 初始化默认值
           setDefaultDbSet(catId,catName);
       }, //选择树节点触发事件
        onSelect : function(node) {
            //返回树对象
            var tree = $(this).tree;
            //选中的节点是否为叶子节点,如果不是叶子节点,清除选中
            var isLeaf = tree('isLeaf', node.target);
            if (!isLeaf) {
                Modal.alert({msg: "请选择二级分类", title: "提示", btnok: "确定", btncl: "取消"});
                //清除选中
                $('#catId').combotree('clear');
                return false;
            }
        }
    });
}


// 设置下拉树的默认值
function setDefaultDbSet(catId, catName) {
    // 设置默认值
    var t = $('#catId').combotree('tree');
    var defNode = t.tree("find", catId);
    if (!defNode) {
        t.tree('append', {
            data: [{
                id: catId,
                text: catName
            }]
        });
        defNode = t.tree("find", catId);
        t.tree('select', defNode.target);
        defNode.target.style.display = 'none';
    }
    $('#catId').combotree('setValue', catId);
}


/**
 * 清空form表单
 * @param formId 表单Id
 */
var emptyForm = function(formId){
    $(':input','#'+formId).not(':button, :submit, :reset, :hidden,:radio').val('').removeAttr('checked').removeAttr('selected');
}
function init(){

    $('#seqno').ace_spinner({
        value: 1,
        min: 1,
        max: 10000,
        step: 1,
        touch_spinner: true,
        icon_up: 'ace-icon fa fa-caret-up bigger-110',
        icon_down: 'ace-icon fa fa-caret-down bigger-110'
    });

    $('#seqno1').ace_spinner({
        value: 1,
        min: 1,
        max: 10000,
        step: 1,
        touch_spinner: true,
        icon_up: 'ace-icon fa fa-caret-up bigger-110',
        icon_down: 'ace-icon fa fa-caret-down bigger-110'
    });

    $('#seqno2').ace_spinner({
        value: 1,
        min: 1,
        max: 10000,
        step: 1,
        touch_spinner: true,
        icon_up: 'ace-icon fa fa-caret-up bigger-110',
        icon_down: 'ace-icon fa fa-caret-down bigger-110'
    });

    $('#seqno3').ace_spinner({
        value: 1,
        min: 1,
        max: 10000,
        step: 1,
        touch_spinner: true,
        icon_up: 'ace-icon fa fa-caret-up bigger-110',
        icon_down: 'ace-icon fa fa-caret-down bigger-110'
    });

    $('#seqno4').ace_spinner({
        value: 1,
        min: 1,
        max: 10000,
        step: 1,
        touch_spinner: true,
        icon_up: 'ace-icon fa fa-caret-up bigger-110',
        icon_down: 'ace-icon fa fa-caret-down bigger-110'
    });

    $('#seqno5').ace_spinner({
        value: 1,
        min: 1,
        max: 10000,
        step: 1,
        touch_spinner: true,
        icon_up: 'ace-icon fa fa-caret-up bigger-110',
        icon_down: 'ace-icon fa fa-caret-down bigger-110'
    });
    // 初始化上传文件输入框
    $('#imageUrl1').ace_file_input({
        no_file:'重新选择文件...',
        btn_choose:'选择',
        btn_change:'修改',
        droppable:false,
        onchange:null,
        thumbnail:false
    });

    // 初始化上传文件输入框
    $('#imageUrl2').ace_file_input({
        no_file:'重新选择文件...',
        btn_choose:'选择',
        btn_change:'修改',
        droppable:false,
        onchange:null,
        thumbnail:false
    });

    // 初始化上传文件输入框
    $('#imageUrl3').ace_file_input({
        no_file:'重新选择文件...',
        btn_choose:'选择',
        btn_change:'修改',
        droppable:false,
        onchange:null,
        thumbnail:false
    });

    // 初始化上传文件输入框
    $('#imageUrl4').ace_file_input({
        no_file:'重新选择文件...',
        btn_choose:'选择',
        btn_change:'修改',
        droppable:false,
        onchange:null,
        thumbnail:false
    });

    // 初始化上传文件输入框
    $('#imageUrl5').ace_file_input({
        no_file:'重新选择文件...',
        btn_choose:'选择',
        btn_change:'修改',
        droppable:false,
        onchange:null,
        thumbnail:false
    });
}




//验证商品名称是否被占用和格式
function goodsNameOnBlus(obj) {
    obj = $(obj);
    var total = checkGoodIsExist(obj.val(),"");
    if(total >= 1){
        Modal.alert({msg : "商品名称已被占用", title : "提示", btnok : "确定"});
        obj.val("");
        return false;
    }
}
//验证商品编号是否被占用 和格式
function goodsNumberOnBlus(obj) {
    obj = $(obj);
    if(obj.val() == ''){
        return true;
    }
    if(! /^[0-9a-zA-Z]+$/.test(obj.val()) || obj.val().length >11){
        Modal.alert({msg : "商品编号不合法", title : "提示", btnok : "确定"});
        obj.val("");
        return false;
    }
    var total = checkGoodIsExist("",obj.val());
    if(total >= 1){
        Modal.alert({msg : "商品编号已被占用", title : "提示", btnok : "确定"});
        obj.val("");
        return false;
    }
}

function checkGoodIsExist(goodsName,goodsNumber){
    var total=0;
    $.ajax({
        async: false,
        url: base + "goods/checkGoodsIsExist",
        dataType: "json",
        type:"POST",
        data: {"goodsName":goodsName,"goodsNumber":goodsNumber},
        success: function (data) {
            total = data;
        },
        error: function (data) {
            total = data;
        }
    });
    return total;
}