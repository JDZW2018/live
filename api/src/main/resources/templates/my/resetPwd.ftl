<!DOCTYPE html>
<html lang="en" xmlns:v-on="http://www.w3.org/1999/xhtml" xmlns:v-bind="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,initial-scale=1.0, user-scalable=no"/>
    <title>教头学院</title>
    <link href="${ctx}css/reset.css" rel="stylesheet" type="text/css"/>
    <link href="${ctx}css/getpwd.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${ctx}js/conform.js"></script>
    <script src="${ctx}js/jquery.min.js" type="text/javascript"></script>
    <script src="${ctx}js/vue.min.js" type="text/javascript"></script>
    <script src="${ctx}js/base.js" type="text/javascript"></script>
</head>
<body>
<div class="con1">
    <span style="width: 20%;display: inline-block;"><a href="${ctx}wap/user/setting"><</a></span><span
        style="width: 60%;display: inline-block;margin: 0 auto;text-align: center;">修改登录密码</span>
</div>
<div class="con4">
    <div class="con4Con">
        <label>旧密码</label><input class="oldpwd" type="password" placeholder="原密码"/>
    </div>
    <div class="con4Con">
        <label>新密码</label><input class="newpwd" type="password" placeholder="请输入一个6-12位的新密码"/>
    </div>
    <div class="con4Con">
        <label>确认密码</label><input class="requirepwd" type="password" placeholder="请再次输入新密码"/>
    </div>
    <div class="con4Con">
        <input type="button" value="完成" class="submit">
    </div>
</div>
</body>
<script>
    <#--修改登陆的密码校验-->
    function check() {
        var result = true;
        if ($(".oldpwd").val() == null || $(".oldpwd").val() == "") {
            alert("旧密码不能为空！");
            result = false;
        } else {
            if ($(".newpwd").val() == null || $(".newpwd").val() == "") {
                alert("新密码不能为空！");
                result = false;
            } else {
                if ($(".requirepwd").val() == null || $(".requirepwd").val() == "") {
                    alert("确认密码不能为空！");
                    result = false;
                } else {
                    if ($(".requirepwd").val() != $(".newpwd").val()) {
                        alert("两次密码输入不一样！");
                        result = false;
                    }
                }

            }

        }

        return result;
    }
    <#--修改登录密码的操作-->
    $(".submit").on("click", function () {
        if (!check())return;
        $.ajax({
            async: false,
            type: "POST",
            url: base + "user/updatePwd",
            data: {'oldpwd': $(".oldpwd").val(), 'newpwd': $(".newpwd").val()},
            dataType: "json",
            success: function (data) {
                alert(data.message);
                if (data.result == 1) {
                    window.location.href = "${ctx}wap/wx/logout";
                }
            },
            error: function (data) {
                alert("系统异常，请稍后重试");
            }
        })
    })
</script>
</html>
