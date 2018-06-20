<div class="layui-layout layui-layout-admin layui-header header-index">
    <ul class="layui-nav no-border-radius layui-header">
        <li class="layui-nav-item"><a href="/processDefinitionList">首页</a></li>
        <li class="layui-nav-item"><a href="/processDefinitionList">任务列表</a></li>
        <li class="layui-nav-item"><a href="/processDefinitionList">流程管理</a></li>
        <li class="layui-nav-item"><a href="/management/user">用户</a></li>
    </ul>
    <ul class="layui-nav layui-layout-right layui-header">
        <li class="layui-nav-item">
            <a href="javascript:;">
                <#--<img src="" class="layui-nav-img">-->
                ${(user.userName)!'#unknow'}
            </a>
            <ul class="layui-nav-child">
                <li><a id="userDetils" href="javascript:;">基本资料</a></li>
            </ul>
        </li>
        <li class="layui-nav-item"><a id="logout" href="javascript:;">安全退出</a></li>
    </ul>
</div>
<script>
    $(function () {
        var pathname = window.location.pathname;
        $(".layui-nav").find("a").each(function (index) {
            var href = $(this).attr("href");
            if (pathname.indexOf(href) != -1) {
                $(this).addClass("layui-this");
            }
        })
    });

    //注意：导航 依赖 element 模块，否则无法进行功能性操作
    layui.use(['element','utils'], function () {
        var element = layui.element
                ,user = layui.user
                ,utils = layui.utils;
        $("#logout").click(function () {
            user.userLogout();//安全退出
        });
        $("#userDetils").click(function () {
            var url = '/management/user/detilsModal';
            var userId = '${(user.id)!}';
            utils.openModal({
                title: '用户详情',//标题
                area: 'auto',//宽高
                closeBtn: '1',//关闭按钮
                shadeClose: false,//是否点击遮罩关闭
                queryId: userId,
                queryUrl: url
            },function (layerDom,index) {

            });
        });
    });
</script>