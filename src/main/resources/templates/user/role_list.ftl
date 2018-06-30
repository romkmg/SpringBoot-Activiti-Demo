<div class="layui-container margin-top">
    <div class="layui-row">
        <div class="layui-col-md-12 margin-bottom">
            <@resource_check url="/management/privilege/addPrivilege">
            <button class="layui-btn layui-btn-success" id="addRole">添加角色</button>
            </@resource_check>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md-12">
            <table class="table table-bordered table-hover" id="roleTable" lay-filter="roleTable">
            </table>
        </div>

    </div>
</div>

<script type="text/html" id="indexTpl">
    {{d.LAY_TABLE_INDEX+1}}
</script>
<script type="text/html" id="roleTableTool">
<@resource_check url="/management/role/roleDetils">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
</@resource_check>
<@resource_check url="/management/role/rolePrivilegeEditModal">
    <a class="layui-btn layui-btn-xs" lay-event="privilege">权限</a>
</@resource_check>
<@resource_check url="/management/role/delRole">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</@resource_check>
</script>

<script type="text/javascript">
    layui.use(['table', 'util', 'itenderRole','itenderUser'], function () {
        var table = layui.table;
        var itenderRole = layui.itenderRole;
        var itenderUser = layui.itenderUser;

        //第一个实例
        var currentTable = table.render({
            elem: "#roleTable",
            page: true,
            url: "/management/role/listRole",
            method: "POST",
            cols: [[
                {title: '序号',templet: '#indexTpl'},
                {title: "角色名", field: 'roleName'},
                {fixed: 'right', align: 'center', toolbar: '#roleTableTool'}
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

        table.on('tool(roleTable)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var roleId = data.id;

            if (layEvent === 'edit') { //编辑
                var data = {
                    title: '角色详情',//标题
                    area: 'auto',//宽高
                    closeBtn: 1,//关闭按钮
                    shadeClose: true,//是否点击遮罩关闭
                    queryId: roleId,
                    queryUrl: '/management/role/roleDetils'
                }

                itenderUser.openModal(data,function (layerDom,index) {
                    currentTable.reload();
                });
            } else if (layEvent === 'del') { //删除
                itenderRole.deleteRole(roleId,function (res,status) {
                    if(status){
                        currentTable.reload();
                        layui.layer.msg("删除成功！");
                    }else{
                        layui.layer.msg("操作失败！"+res.msg);
                    }
                });
            } else if(layEvent === 'privilege'){
                var data = {
                    title: '权限分配',//标题
                    area: ['800px','500px'],//宽高
                    closeBtn: 1,//关闭按钮
                    shadeClose: true,//是否点击遮罩关闭
                    queryId: roleId,
                    queryUrl: '/management/role/rolePrivilegeEditModal'
                }
                itenderUser.openModal(data,function (layerDom,index) {
                    currentTable.reload();
                });
            }
        });

        $('#addRole').click(function () {
            var data = {
                title: '添加角色',//标题
                area: '60%',//宽高
                closeBtn: 1,//关闭按钮
                shadeClose: true,//是否点击遮罩关闭
                queryId: '',
                queryUrl: '/management/role/addRole'
            }
            itenderUser.openModal(data,function (layerDom,index) {
                currentTable.reload();
            });
        });
    });

</script>