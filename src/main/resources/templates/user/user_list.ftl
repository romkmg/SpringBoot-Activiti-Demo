<#--<!DOCTYPE html>-->
<#--<html lang="en">-->
<#--<head>-->
    <#--<meta charset="UTF-8">-->
    <#--<title>招标编辑器</title>-->
    <#--<#include "../resource.ftl">-->
<#--</head>-->
<#--<body>-->
<#--<#include "../top_menus.ftl">-->

<div class="layui-container margin-top">
    <#--<fieldset class="layui-elem-field layui-field-title">-->
        <#--<legend>用户列表</legend>-->
    <#--</fieldset>-->

    <div class="layui-row">
        <div class="layui-col-md7 margin-bottom">
        <@resource_check url="/management/user/register">
            <button id="addUser" class="layui-btn layui-btn-success">添加用户</button>
        </@resource_check>
        </div>
        <div class="layui-col-md5 margin-bottom">
            <form class="layui-form layui-form-pane" action="javascript:void(0)">
                <div class="layui-input-inline">
                    <input type="text" name="username" placeholder="用户名" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-filter="search" lay-submit>
                        <i class="layui-icon">&#xe615;</i> 搜索
                    </button>
                </div>
            </form>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md-12">
            <div class="table table-bordered table-hover" id="userTable" lay-filter="userTable">
            </div>
        </div>

    </div>
</div>
<#--</body>-->
<script type="text/html" id="indexTpl">
    {{d.LAY_TABLE_INDEX+1}}
</script>
<script type="text/html" id="userTableTool">
    <@resource_check url="/management/user/detilsModal">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    </@resource_check>
    <@resource_check url="/management/user/userRoleEditModal">
        <a class="layui-btn layui-btn-xs" lay-event="role">角色</a>
    </@resource_check>
    <@resource_check url="/management/user/delUser">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@resource_check>
</script>
<script type="text/html" id="registerTime">
    {{ layui.util.toDateString(d.registerTime,'yyyy-MM-dd HH:mm:ss')}}
</script>

<script type="text/html" id="lastLoginTime">
    {{ layui.util.toDateString(d.lastLoginTime,'yyyy-MM-dd HH:mm:ss')}}
</script>

<script type="text/javascript">
    layui.use(['table', 'util','layer','form','itenderUser'], function () {
        var table = layui.table;
        var itenderUser = layui.itenderUser;
        var layer = layui.layer;
        var form = layui.form;

        //第一个实例
        var currentTable = table.render({
            elem: "#userTable",
            page: true,
            url: "/management/user/listUser",
            method: "POST",
            cols: [[
                {title: '序号',templet: '#indexTpl',width: 70},
                {title: "姓名", field: 'realName',width: 120},
                {title: "用户名", field: 'userName'},
                {title: "Email", field: 'email'},
                {title: "注册时间", field: 'registerTime',width: 160,templet: "#registerTime"},
                {title: "最近登录时间", field: 'lastLoginTime',width: 160,templet: "#lastLoginTime"},
                {fixed: 'right', align: 'center',width: 200, toolbar: '#userTableTool'}
            ]],
            request: {
                pageName: 'pageNum' //页码的参数名称，默认：page
                , limitName: 'pagesize' //每页数据量的参数名，默认：limit
            },
            response: {
                statusName: 'statusCode' //数据状态的字段名称，默认：code
                , statusCode: 200 //成功的状态码，默认：0
                , msgName: 'msg' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'data' //数据列表的字段名称，默认：data
            },
            done: function (res, curr, count) {
                //如果是异步请求数据方式，res即为你接口返回的信息。
                //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
                console.log(res);

                //得到当前页码
                console.log(curr);

                //得到数据总量
                console.log(count);
            }
        });

        table.on('tool(userTable)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var userId = data.id;

            if (layEvent === 'edit') { //编辑
                var data = {
                    title: '用户详情',//标题
                    area: 'auto',//宽高
                    closeBtn: 1,//关闭按钮
                    shadeClose: true,//是否点击遮罩关闭
                    queryId: userId,
                    queryUrl: '/management/user/detilsModal'
                };
                itenderUser.openModal(data,function (layerDom,index) {
                    currentTable.reload();
                });
            } else if (layEvent === 'del') { //删除
                var data = {
                    userId: userId,
                    operator: '${user.userName!}',
                }
                itenderUser.deleteUser(data,function (res,status) {
                    if(status){
                        layer.msg("删除成功！");
                    }else{
                        layer.msg("删除失败！"+res.msg);
                    }
                    currentTable.reload();
                });
            } else if(layEvent === 'role'){ //设置角色
                var data = {
                    title: '角色设置',//标题
                    area: ['500px','300px'],//宽高
                    closeBtn: 1,//关闭按钮
                    shadeClose: true,//是否点击遮罩关闭
                    queryId: userId,
                    queryUrl: '/management/user/userRoleEditModal'
                };
                itenderUser.openModal(data,function (layerDom,index) {
                    currentTable.reload();
                });
            }
        });
        $('#addUser').click(function () {
            var data = {
                title: '添加用户',//标题
                area: 'auto',//宽高
                closeBtn: 1,//关闭按钮
                shadeClose: true,//是否点击遮罩关闭
                queryId: '',
                queryUrl: '/management/user/register'
            };
            itenderUser.openModal(data,function (layerDom,index) {
                currentTable.reload();
            });
        });

        form.on('submit(search)', function (data) {
            var formData = data.field;
            //刷新表格
            currentTable.reload({
                where: {
                    username:formData.username
                }, page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
            return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });


    });

</script>
<#--</html>-->