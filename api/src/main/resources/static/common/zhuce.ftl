<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,initial-scale=1.0, user-scalable=no" />
    <title>教头学院</title>
    <link href="${ctx}css/reset.css" rel="stylesheet" type="text/css"/>
    <link href="${ctx}css/zhuce.css" rel="stylesheet" type="text/css"/>
    <link href="${ctx}css/swiper-3.3.1.min.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${ctx}js/conform.js"></script>
    <script src="${ctx}js/jquery.min.js" type="text/javascript" ></script>
    <script src="${ctx}js/swiper-3.3.1.min.js" type="text/javascript"></script>
    <script src="${ctx}js/picker.min.js"></script>
    <script src="${ctx}js/tele86.js"></script>
    <style>
        html, body {
            position: relative;

        }
        body {
            background: #eee;
            font-family: Helvetica Neue, Helvetica, Arial, sans-serif;
            font-size: 14px;
            color:#000;
            margin: 0;
            padding: 0;
        }
        .swiper-container {
            width: 100%;
            height: 3rem;
            margin-top: 0.85rem;
        }
        .swiper-slide {
            text-align: center;
            font-size: 18px;
            background: #fff;

            /* Center slide text vertically */
            display: -webkit-box;
            display: -ms-flexbox;
            display: -webkit-flex;
            display: flex;
            -webkit-box-pack: center;
            -ms-flex-pack: center;
            -webkit-justify-content: center;
            justify-content: center;
            -webkit-box-align: center;
            -ms-flex-align: center;
            -webkit-align-items: center;
            align-items: center;
        }
    </style>
</head>
<body>
<div class="con1">
    <span style="width: 20%;display: inline-block;"><</span><span style="width: 60%;display: inline-block;margin: 0 auto;text-align: center;">注册</span>
</div>
<div class="con3">
    <form id="registerForm">
        <div class="con3Con">
            <label>手机号码</label><span class="span1" id="sel_city">+86</span><input class="input1" type="text" placeholder="请输入手机号">
        </div>
        <div class="con3Con">
            <label style="vertical-align: middle;"> </label><input class="input2" style="width: 3.5rem;" type="text" placeholder="输入验证码"><span class="span2">获取验证码</span>
        </div>
        <div class="con3Con">
            <label>用户名</label><input type="text" placeholder="输入用户名">
        </div>
        <div class="con3Con">
            <label>密码</label><input type="text" placeholder="设置密码">
        </div>
        <div class="con3Con">
            <label>确认密码</label><input type="text" placeholder="确认密码">
        </div>
        <div class="con3Con">
            <input type="button" value="注册" style="width:100%;background-color: #ffa42f;border-color: transparent;margin:0.4rem auto;color: white;font-size: 0.32rem;">
        </div>
    </form>
</div>
<div class="con4">
    <div class="con4Con">
        注册代表您已经阅读并同意《教头学院协议》
    </div>
</div>

</body>
<script>
    var nameEl = document.getElementById('sel_city');
    function creatList(obj, list){
        obj.forEach(function(item, index, arr){
            var temp = new Object();
            temp.text = item.name;
            temp.num = item.num;
            temp.value = index;
            list.push(temp);
        })
    }
    var data = [];
    var picker;
    var text;
    creatList(tele_num, data);
    picker = new Picker({
        data: [data],
        selectedIndex:[0],
        title: '地址选择'
    });
    picker.on('picker.select', function (selectedVal, selectedIndex) {
        text = data[selectedIndex[0]].num;
        nameEl.innerText = text;
    });
    nameEl.addEventListener('click', function () {
        picker.show();
    });

</script>
</html>