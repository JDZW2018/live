<#assign title="分润关系"/>
<#assign menuId="5a5d244650e24e69b273aecc88368dba"/>
<#include "../common/head_top.ftl"/>

<!-- page specific plugin styles -->
<link rel="stylesheet" href="${ctx}/assets/css/jquery-ui.min.css" />
<link rel="stylesheet" href="${ctx}/assets/css/bootstrap-datepicker3.min.css" />
<link rel="stylesheet" href="${ctx}/assets/css/ui.jqgrid.min.css" />
<link rel="stylesheet" href="${ctx}/assets/css/jquery.treegrid.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/js/easy-ui/themes/gray/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${ctx}/js/easy-ui/themes/icon.css"/>
<#include "../common/head_bottom.ftl"/>
<#include "../common/body_top.ftl"/>


<div class="col-xs-12">
    <div class="col-sm-4">
        <button type="button" onclick="back()"><i class="fa fa-arrow-left"></i></button>
        <button type="button" class="btn btn-default btn-sm hide" data-dismiss="modal" onclick="back()">返 回</button>
    </div>
    <form>
        <div class="col-sm-8" >
                <div class="pull-right">
                    <div class="form-group" style="margin-bottom: 5px;margin-right: -18px;">
                    <input type="text" id="user-keyword-1" placeholder="用户名、手机号" class="col-xs-8">
                    &nbsp;&nbsp;<button type="button" class="btn btn-info btn-sm" id="user-search">查询</button>
                </div>
                </div>
            </div>
        </div>
    </form>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<div class="col-xs-12">
    <table id="grid-table" class='subgird'></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<!-- 用户修改Modal -->
<div class="modal fade" id="updateModal-type" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">修改用户</h4>
            </div>
            <div class="modal-body" style="max-height:600px; overflow:scroll; ">
                <form id="user-form-update" class="form-horizontal">
                    <input id="userId_update" name="userId" type="hidden">
                    <input id="roleIds_update" name="roleIds" type="hidden">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="loginName">登录名</label>
                        <div class="col-sm-9">
                            <input type="text" id="loginName_update" name="loginName" placeholder="登录名" class="col-xs-10 col-sm-5" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="recordName">用户名称:</label>
                        <div class="col-sm-9">
                            <input type="text" id="userName_update" name="userName" placeholder="用户名称" class="col-xs-12 col-sm-5" value="" onblur=""/>
                        </div>
                    </div>
                    <div class="space-4"></div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="recordName">昵称:</label>
                        <div class="col-sm-9">
                            <input type="text" id="nickName_update" name="nickName" placeholder="昵称" class="col-xs-12 col-sm-5" value=""/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-2">手机号: </label>
                        <div class="col-sm-9">
                            <input type="text" id="phone_update" name="phone" placeholder="手机号" class="col-xs-12 col-sm-5" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-2">角色选择: </label>
                        <div class="col-sm-9">
                            <div class="col-xs-12 col-sm-5">
                                <div class="control-group" id="role_checkbox_update">
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="updateuser">保 存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- 用户添加Modal -->
<div class="modal fade" id="addModal-type" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">添加用户</h4>
            </div>
            <div class="modal-body" style="max-height:600px; overflow:scroll; ">
                <form id="add-form-user" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="recordName"><small class="red">*</small> 用户名称:</label>
                        <div class="col-sm-9">
                            <input type="text" id="username_add" name="userName" placeholder="用户名称" class="col-xs-12 col-sm-5" value="" onblur=""/>
                        </div>
                    </div>
                    <div class="hr hr-18 dotted"></div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="recordName"><small class="red">*</small> 登录名称:</label>
                        <div class="col-sm-9">
                            <input type="text" id="loginname_add" name="loginName" placeholder="登录名称" class="col-xs-12 col-sm-5" value="" onblur=""/>
                        </div>
                    </div>
                    <div class="hr hr-18 dotted"></div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="recordName"><small class="red">*</small> 昵称:</label>
                        <div class="col-sm-9">
                            <input type="text" id="nickname_add" name="nickName" placeholder="昵称" class="col-xs-12 col-sm-5" value=""/>
                        </div>
                    </div>
                    <div class="hr hr-18 dotted"></div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-2"><small class="red">*</small> 手机号: </label>
                        <div class="col-sm-9">
                            <input type="text" id="phone_add" name="phone" placeholder="手机号" class="col-xs-12 col-sm-5" />
                            <span class="help-inline col-xs-12 col-sm-7">
                        </div>
                    </div>
                    <div class="hr hr-18 dotted"></div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-2">角色选择: </label>
                        <div class="col-sm-9">
                            <div class="col-xs-12 col-sm-5">
                                <div class="control-group" id="role_checkbox_add">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hr hr-18 dotted"></div>
                    <input type="hidden" name="roleIds" id="roleIds_add">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="adduser">保 存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<#--add-end-->
<#include "../common/body_middle.ftl"/>
<#include "../common/bootstrap_modal.ftl">

<!-- page specific plugin scripts -->
<script src="${ctx}/assets/js/bootstrap-datepicker.min.js"></script>
<script src="${ctx}/assets/js/jquery.jqGrid.min.js"></script>

<script src="${ctx}/assets/js/grid.locale-en.js"></script>

<!-- inline scripts related to this page -->
<script src="${ctx}/assets/js/jquery-ui.min.js"></script>
<script src="${ctx}/assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="${ctx}/js/jquery.form.js"></script>
<script src="${ctx}/js/easy-ui/jquery.easyui.min.js"></script>
<script src="${ctx}/assets/js/jquery.treegrid.min.js"></script>
<script>
    var overallUserId = '${userId}';
    var overallRelationId = '${relationId}';
    var back = function () {
        location.href = base + 'profitshare/relation/pageskip?relationId='+"${relationId}"+'&level=2';
    }
</script>
<script src="${ctx}/js/admincon/profit_relation_three.js"></script>
<#include "../common/body_bottom.ftl"/>
