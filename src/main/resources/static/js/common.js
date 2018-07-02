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
    base: "/js/modules/"
}).extend({
    m_user: "m_user",
    m_role: "m_role",
    m_privilege: "m_privilege",
    m_utils:"m_utils",
    m_workflow:"m_workflow"
});

var view = {
    goto: function (url) {
        window.location.href = url;
    },
    openNew: function (url) {
        window.open(url, "_blank");
    }
};

$.ajaxSetup({
    cache:false,    //禁止浏览器缓存ajax请求
    statusCode: {
        403: function () {
            var layer = layui.layer;
            layer.open({
                type: 2,
                title: '用户登录',
                area: ['50%', '50%'],
                skin: 'layui-layer-molv',
                closeBtn: 0,
                shadeClose: false,
                content: ['/']
            });
        }
    }
});
