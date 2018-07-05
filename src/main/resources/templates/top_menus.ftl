<div class="layui-layout" id="nav">
    <ul class="layui-nav no-border-radius layui-header">
        <li class="layui-nav-item"><a href="/index">首页</a></li>
    </ul>
    <ul class="layui-nav layui-layout-right layui-header">
        <li class="layui-nav-item">
            <a href="javascript:;">
            <#--<img src="" class="layui-nav-img">-->
            ${(user.lastName)!'#unknow'}
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
    layui.use(['element', 'm_utils','m_user'], function () {
        var element = layui.element
                , utils = layui.m_utils,m_user = layui.m_user;
        $("#logout").click(function () {
            m_user.userLogout();//安全退出
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
            }, function (layerDom, index) {

            });
        });
    });
</script>