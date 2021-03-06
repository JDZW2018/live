$(function(){

    var curpage=1;
    var freshH=$(".fresh").height();
    var moreState=0;
    var freshState=0;
    var myscroll = new iScroll("wrapper",{
        topOffset:freshH,
        onScrollMove:function(){
            if(this.y >=-freshH){
                if(this.y>=0){
                    this.minScrollY=0;
                    freshState=1;
                    freshElement();
                }else if(0>this.y>-freshH){
                    freshState=0;
                    freshElement();
                }else{
                    console.log("没这种情况")
                }
            }else{
                if (this.y<(this.maxScrollY)) {
                    moreState=1;
                    moreElement();
                }else{
                    moreState=0;
                    moreElement();
                }
            }
        },
        onScrollEnd:function(){
            if(freshState===1){
                freshState=2;
                pullDownAction();
                freshElement();
            }else if (moreState===1) {
                moreState=2;
                moreElement();
                pullUpAction();
            }else{
                this.refresh();
            }

        },
        onRefresh:function(){
        }
    });

    function pullUpAction(){
        setTimeout(function(){
            curpage++;
            showWzkcList(curpage,5,0);
        }, 1000)
    }

    function pullDownAction(){
        setTimeout(function(){
            curpage = 1;
            $("#informationIntro").html("");// 先清空原来加载的数据
            showWzkcList(1,8,1);
        }, 1000)
    }

    function moreElement() {
        switch (moreState){
            case 0:
                $('.more .pull_icon').removeClass('flip loading');
                $('.more span').text('上拉加载...');
                break;
            case 1:
                $('.more .pull_icon').addClass('flip');
                $('.more .pull_icon').removeClass('loading');
                $('.more span').text('释放加载...');
                break;
            case 2:
                $('.more .pull_icon').addClass('loading');
                $('.more span').text('加载中...');
                break;
            case 3:
                $('.more .pull_icon').addClass('loading');
                $('.more span').text('加载成功');
                break;
            default:
                $('.more .pull_icon').addClass('loading');
                $('.more span').text('加载失败！！');
                break;
        }
    }

    function freshElement() {
        switch (freshState){
            case 0:
                $('.fresh .pull_icon').show();
                $('.fresh .pull_icon').removeClass('flip loading');
                $('.fresh span').text('下拉刷新...');
                break;
            case 1:
                $('.fresh .pull_icon').addClass('flip');
                $('.fresh .pull_icon').removeClass('loading');
                $('.fresh span').text('释放刷新...');
                break;
            case 2:
                $('.fresh .pull_icon').addClass('loading');
                $('.fresh span').text('刷新中...');
                break;
            case 3:
                $('.fresh .pull_icon').hide();
                $('.fresh span').text('刷新成功');
                break;
            default:
                $('.fresh .pull_icon').addClass('loading');
                $('.fresh span').text('刷新失败！！');
                break;
        }
    }



    //
    showWzkcList(1,8,1);
    function showWzkcList(pageNum,pageSize,allIscrollState){
        $.ajax({
            async: true,
            type: "POST",
            url: $("#basePath").val() + "wap/news/informationList",
            data: {pageNum:pageNum,pageSize:pageSize},
            dataType: "json",
            success: function (data) {
                var htmlVal = "";
                if(data != null && data.length > 0){
                    for(var i = 0;i < data.length;i++){
                        htmlVal+= '<div class="con3" style="padding:0;margin:0;">'
                            +'<a href="'+$("#basePath").val()+'wap/news/informDetail?informationId='+data[i].informationId+'">'
                            +'<div class="con3Item">'
                            +'<div class="con3ItemRight" style="padding: 0 0.1rem 0 0.2rem;">'
                            +'<span class="con3ItemTitle">'+data[i].title+'</span>'
                            +'<div class="con3ItemBody">'
                            +'<div class="con3ItemTime con3ItemTimeMoney">'
                            +'<p>'+new Date(data[i].createTime).pattern("yyyy-MM-dd HH:mm:ss")+'</p>'
                            +'</div>'
                            +'</div>'
                            +'</div>'
                            +'<img class="con3ItemLeft" src="'+data[i].photo+'" style="padding: 0">'
                            +'</div>'
                            +'</a>'
                            +'</div>';
                    }
                    $("#informationIntro").append(htmlVal);
                    if($("#wrapper").height() > $(".scroller").height()){
                        $(".more").hide();
                    }else{
                        $(".more").show();
                    }
                    if(allIscrollState){
                        freshState = 3;
                        freshElement();
                    }else{
                        moreState=3;
                        moreElement();
                        myscroll.refresh();
                    }
                    setTimeout(function () {
                        myscroll.refresh();
                    }, 1000)
                }else{
                    if(allIscrollState){
                        freshState = 3;
                        freshElement();
                    }else{
                        moreState=3;
                        // moreElement();
                        $('.more .pull_icon').removeClass('flip loading');
                        $('.more span').text('没有更多数据');
                    }
                    setTimeout(function () {
                        myscroll.refresh();
                    }, 1000)
                }
            },
            error:function(data){
                if(allIscrollState){
                    freshState=4;
                    freshElement();
                    myscroll.refresh();
                }else {
                    moreState=4;
                    moreElement();
                    myscroll.refresh();
                }
            }
        });
    }
});
