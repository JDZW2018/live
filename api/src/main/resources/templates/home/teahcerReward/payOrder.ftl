<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,initial-scale=1.0, user-scalable=no" />
    <title>支付订单页-教头学院</title>
    <link href="${ctx}css/reset.css" rel="stylesheet" type="text/css"/>
    <link href="${ctx}css/font-awesome.min.css" type="text/css" rel="stylesheet"/>
    <link href="${ctx}css/ace.min.css" type="text/css" rel="stylesheet"/>
    <link href="${ctx}css/payOrder.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${ctx}js/conform.js"></script>
    <script src="${ctx}js/jquery.min.js" type="text/javascript" ></script>
    <script src="${ctx}js/vue.min.js"></script>
    <script src="${ctx}js/picker.min.js"></script>
    <script src="${ctx}js/base.js"></script>
    <style>
        body{font-size: 0.24rem;}
        .zhifumimaBox{width:100%;height: 100%;background-color: rgba(0,0,0,0.5);padding-top:1.5rem;position: fixed;top:0;z-index: 100;font-size: 0.28rem;}
        .zhifumima{width:90%;margin:0 5%;background-color: white;border-radius: 0.2rem;overflow: hidden;}
        .zhifumima p{width:100%;line-height: 0.8rem;text-align: center;font-size: 0.3rem;padding-top:0.2rem;}
        .zhifumima .nums{width:100%;padding:0.6rem 0.35rem;box-sizing: border-box;display: flex;/*justify-content: space-between*/}
        .zhifumima .line3{width:100%;display: flex;margin-top:0.3rem;border-top:0.01rem solid #ccc;}
        .zhifumima .line3 div{width:50%;line-height: 0.8rem;border-right: 0.01rem solid #ccc;text-align: center}
        .zhifumima .line3 .ensure{border-color: transparent;background-color: #ffa42f;color:white}
         .money {
            color: #ffa42f;
        }

        .zhifumima .nums input[type=password].pwd{border:0.03rem solid #ccc;border-right:0;width:0.975rem;height: 0.8rem;line-height:0.8rem;text-align: center;padding:0; color: #000000!important;
            background: #ffffff!important;}
        .zhifumima .nums input[type=password].pwd:last-child {
            border-right: 0.03rem solid #ccc;
            color:#000000!important;
            background: #ffffff!important;
        }
    </style>
</head>
<body>
<input type="hidden" id="money" name="money" value="${money!}"/>
<input type="hidden" id="teacherId" name="teacherId" value="${teacherId!}"/>
<div class="con1">
    <span style="width: 20%;display: inline-block;"><</span><span style="width: 60%;display: inline-block;margin: 0 auto;text-align: center;">支付订单</span>
</div>
<div class="con2">
    <div class="line2">
        <div class="moreL"><span>小计</span></div>
        <div class="more"><span class="money">${money!}学分</span></div>
    </div>
</div>
<div class="type">
    <div class="button2"><span>选择支付方式</span></div>
    <ul>
        <#--支付方式(0:银两支付（余额）；1:支付宝；2：微信；3：PayPal-->
        <li><label>微信</label><span style="width:2rem;float: right;height:1rem;"><input type="radio" name="type" value="2" checked="checked" style="margin:0.35rem 0 0 0"/></span></li>
        <li id="alipayli" style="display: none;"><label>支付宝</label><span style="width:2rem;float: right;height:1rem;"><input type="radio" name="type" value="1" style="margin:0.35rem 0 0 0"/></span></li>
        <li><label>学分支付<span class="money">（￥1元 = 10学分）</span></label><span style="width:2rem;float: right;height:1rem;"><input type="radio" name="type" value="0" style="margin:0.35rem 0 0 0"/></span></li>
    </ul>
</div>
<div class="zhifumimaBox" style="display: none;">
    <div class="zhifumima">
        <p>请输入支付密码</p>
        <div class="nums" style="overflow: hidden;">
            <input class="text" type="text" style="position: relative;z-index:-1;width:1px;padding:0;border:0" maxlength="6">
            <input class="pwd" type="password" disabled>
            <input class="pwd" type="password" disabled>
            <input class="pwd" type="password" disabled>
            <input class="pwd" type="password" disabled>
            <input class="pwd" type="password" disabled>
            <input class="pwd" type="password" disabled>
        </div>
        <div class="line3">
            <div onclick="anensure()">取消</div>
            <div class="ensure" onclick="ensure()">确定</div>
        </div>
    </div>
</div>

<a href="#"> <div class="button" onclick="pay()">结算</div></a>
</body>
<script>
    $(function () {
        if(!is_weixin()){
            $("#alipayli").show();
        }
    });
    $(".type li").click(function () {
        $(this).children("input").prop("checked",true)
    })
    $(".seltype").click(function () {
        $(".type").css("bottom","0")
    });
   //返回页面
    var returnUrl = encodeURIComponent(base+"search/teahcerReward/payOrder?teacherId="+$("#teacherId").val()+"&money="+$("#money").val())

    //返回页面
    var returnTeacherDetailUrl = encodeURIComponent(base+"search/wellTeacherHome?teacherId="+$("#teacherId").val());

    var zhifutext=$(".zhifumimaBox .nums input[type=text]");
    var zhifupassword=$(".zhifumimaBox .nums input[type=password]");
    var toStr;var i;
    zhifutext.focus();
    window.addEventListener('keyup', function () {
        zhifutext.focus();
        zhifupassword.val('');
        toStr=zhifutext.val()+'';
        for(i=0;i<toStr.length;i++){
            if(toStr[i]!==''&&toStr[i]!==null){
                zhifupassword.eq(i).val(toStr[i])
            }
        }
    }, false);
    function pay() {

        var payPassword =  searchUserPayPass();//查找用户支付密码
        if(!payPassword) {
            //设置支付密码页面;
            location.href = base+"search/setZhifuPwd?returnUrl="+returnUrl;
        }
        if(!$("input[type='radio']:checked").val()){
             alert("请选择一种支付方式");
             return false;
        }
        if($("input[type='radio']:checked").val() == 0){
            $(".zhifumimaBox").show();
            zhifutext.focus()
        }else if($("input[type='radio']:checked").val() == 1) {
            giveTeahcerReward(1,requsetaliH5Url);

        }else if($("input[type='radio']:checked").val() == 2) {
            if( is_weixin()){
                giveTeahcerReward(2,requsetUrl);
            }else{
                giveTeahcerReward(2,requsetH5Url);//H5支付
            }
        }
    }
    function is_weixin(){
        var ua = navigator.userAgent.toLowerCase();
        if(ua.match(/MicroMessenger/i)=="micromessenger") {
            return true;
        } else {
            return false;
        }
    }
    function ensure() {
       // alert(zhifutext.val());
        if($("input[type='radio']:checked").val() == 0) {
            checkPayPassword(zhifutext.val());//校验支付密码
            $(".zhifumimaBox").hide();
            zhifupassword.val('');
            zhifutext.val('');
        }
    }
    function anensure() {
        $(".zhifumimaBox").hide();
        zhifupassword.val('');
        zhifutext.val('');
    }


    /**
     * 打赏教头
     * @returns {*}
     */
    function  giveTeahcerReward_(payWay){
        var rewardResult= null;
        $.ajax({
            async: false,
            type: "POST",
            url: base + "search/giveTeahcerReward",
            data: {teacherId: $("#teacherId").val(),money:$("#money").val(),payWay:payWay},
            dataType: "json",
            success: function (data) {
                rewardResult= data;

            },
            error: function (data) {
                rewardResult= data;

            }
        });
        return rewardResult;
    }
    /**
     * 打赏教头
     * @returns {*}
     */
    function  giveTeahcerReward(payWay,callback){

        //为防止用户使用第三方支付有未完成的支付订单
        $.ajax({
            async: false,
            type: "POST",
            url: base + "search/giveTeahcerReward",
            data: {teacherId: $("#teacherId").val(),money:$("#money").val(),payWay:payWay},
            dataType: "json",
            success: function (data) {
                if(data.data && data.data.orderId){
                    callback(data.data.orderId);
                }else{
                    alert(data.message);
                    payFail();
                }
            },
            error: function (data) {
                alert("支付失败");
                payFail();
            }
        });
    }
    /**
     * 验证支付密码与余额支付，0代表没有支付密码，1代表支付密码不正确，2代表支付密码正确
     * @returns {*}
     */
    function  checkPayPassword(payPass){
        $.ajax({
            async: false,
            type: "POST",
            url: base + "course/searchUserPpCount",
            data: {userId: $("#userId").val(), payPass: payPass},
            dataType: "json",
            success: function (data) {
                if (data.data == 1) {
                    alert("支付密码错误");
                } else if (data.data == 0) {
                    alert("请设置支付密码");
                } else if (data.data == 2) {

                    var payWay = $("input[type='radio']:checked").val();
                    //密码正确，打赏教头
                    var rewardResult = giveTeahcerReward_(payWay);
                    if (rewardResult == null) { //支付失败
                        alert("支付失败");
                        payFail();
                    }
                    if (rewardResult.result == 1 && rewardResult.message == "success") {
                        if (rewardResult.data.orderId) {
                            if (payWay == 0) {
                                alert("支付成功");
                                location.href = base + "search/wellTeacherHome?teacherId=" + $("#teacherId").val();
                            }
                        }
                    } else if (rewardResult.result == 1 && rewardResult.message == "余额不足") {
                        alert(rewardResult.message);
                        //  跳转到钱包重置页面
                        var returnUrl = encodeURIComponent(base+"search/teahcerReward/payOrder?userId="+$("#userId").val()+"&teacherId="+$("#teacherId").val()+"&money="+$("#money").val());
                        location.href=base+ "user/myBalance?returnUrl="+returnUrl;
                    } else {
                        alert(rewardResult.message);
                        payFail();
                    }
                }
            },
            error: function (data) {
                alert(data.message);
            }
        });
    }



    /**
     * 支付失败跳转页面
     */
    function payFail(){
        location.href=base+"search/teahcerReward/giveTeahcerRewardFail?teacherId="+$("#teacherId").val();
    }
    /**
     * 跳转到微信支付页面
     * @param orderId
     */
    function requsetUrl(orderId) {
        window.location.href="${ctx}wap/wx/auth?orderId="+orderId+"&returnUrl="+returnTeacherDetailUrl;
    }
    /**
     * 跳转到微信H5支付页面
     * @param orderId
     */
    function requsetH5Url(orderId) {
        location.href="${ctx}wap/wx/topayWap?orderNo="+orderId+"&returnUrl="+returnTeacherDetailUrl;
    }

    /**
     * 跳转到支付宝H5支付页面
     * @param orderId
     */
    function requsetaliH5Url(orderId) {
        location.href="${ctx}wap/ali/topayWap?orderNo="+orderId+"&returnUrl="+returnTeacherDetailUrl;

    }



    /**
     * 查找用户支付密码
     * @returns {*}
     */
    function  searchUserPayPass(){
        var payPassword=null;
        $.ajax({
            async: false,
            type: "POST",
            url: base + "course/searchUserPayPass",
            data: {userId:$("#userId").val()},
            dataType: "json",
            success: function (data) {
                payPassword = data.data;
            },
            error: function (data) {
                payPassword = data.data;
            }
        });
        return payPassword;
    }
</script>
</html>