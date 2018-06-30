<div class="layui-container margin-top">
    <div class="layui-row">
        <div class="layui-col-md-12 margin-bottom">
            <@resource_check url="/management/privilege/addPrivilege">
            <button class="layui-btn layui-btn-success" id="addPrivilege">添加权限</button>
            </@resource_check>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md-12">
            <table class="table table-bordered table-hover" id="privilegeTable" lay-filter="privilegeTable">
            </table>
        </div>
    </div>
</div>

<script type="text/html" id="indexTpl">
    {{d.LAY_TABLE_INDEX+1}}
</script>
<script type="text/html" id="privilegeTableTool">
    <@resource_check url="/management/privilege/updatePrivilege">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    </@resource_check>
    <@resource_check url="/management/privilege/delPrivilege">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@resource_check>
</script>

<script type="text/javascript">
    layui.use(['table', 'util', 'itenderPrivilege','itenderUser'], function () {
        var table = layui.table;
        var itenderPrivilege = layui.itenderPrivilege;
        var itenderUser = layui.itenderUser;

        //第一个实例
        var currentTable = table.render({
            elem: "#privilegeTable",
            page: true,
            url: "/management/privilege/listPrivilege",
            method: "POST",
            cols: [[
                {title: '序号',templet: '#indexTpl'},
                {title: "权限名称", field: 'privilegeName'},
                {title: "资源路径", field: 'privilegeUri'},
                {fixed: 'right', align: 'center', toolbar: '#privilegeTableTool'}
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

        table.on('tool(privilegeTable)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var privilegeId = data.id;

            if (layEvent === 'edit') { //编辑
                var data = {
                    title: '权限编辑',//标题
                    area: 'auto',//宽高
                    closeBtn: 1,//关闭按钮
                    shadeClose: true,//是否点击遮罩关闭
                    queryId: privilegeId,
                    queryUrl: '/management/privilege/privilegeDetils'
                }
                itenderUser.openModal(data,function (layerDom,index) {
                    currentTable.reload();
                });
            } else if (layEvent === 'del') { //删除
                itenderPrivilege.deletePrivilege(privilegeId,function (res,status) {
                    if(status){
                        currentTable.reload();
                        layui.layer.msg("删除成功！");
                    }else{
                        layui.layer.msg("操作失败！"+res.msg);
                    }
                });
            }
        });
        $('#addPrivilege').click(function () {
            var data = {
                title: '添加权限',//标题
                area: 'auto',//宽高
                closeBtn: 1,//关闭按钮
                shadeClose: true,//是否点击遮罩关闭
                queryId: '',
                queryUrl: '/management/privilege/privilegeDetils'
            }
            itenderUser.openModal(data,function (layerDom,index) {
                currentTable.reload();
            });
        });
    });

</script>