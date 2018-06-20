//设置jquery validator 默认值
// $.validator.setDefaults({
//     errorClass:"errorClass",
//     highlight: function(element, errorClass, validClass) {
//         $(element).addClass("layui-form-danger");
//     },
//     unhighlight: function(element, errorClass, validClass) {
//         $(element).removeClass("layui-form-danger");
//     }
// })

/**
 * layui全局配置，加载扩展模块
 */
layui.config({
    base:"/js/modules/",
    version: false
}).extend({
    utils:"utils",
    user:"user"
})

layui.use('layer', function(){
    var layer = layui.layer;
    //全局使用。即所有弹出层都默认采用，但是单个配置skin的优先级更高

});



function isLogin(userName) {
    var isLogin =  userName;
    if(isLogin && isLogin!=''){

        return true;
    }
    return false;
}

var view = {
    goto:function (url) {
        window.location.href = url;
    },
    openNew:function (url) {
        window.open(url,"_blank");
    }
}

$.ajaxSetup({
    statusCode: {403: function() {
        if(window.location.href.indexOf("entrybackend")>-1) {
            var layer = layui.layer;
            layer.open({
                type: 2,
                title: '用户登录',
                area:['100%','100%'],
                closeBtn: 0,
                shadeClose: false,
                content: ['/entrybackend/login']
            });
        }else{
            var layer = layui.layer;
            layer.open({
                type: 2,
                title: '用户登录',
                area:['70%','70%'],
                closeBtn: 0,
                shadeClose: false,
                content: ['/login']
            });
        }

        }
    }});