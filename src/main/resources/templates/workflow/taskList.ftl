<div class="layui-container margin-top">
    <div class="layui-row">
        <div class="layui-col-md-12 margin-bottom">
            <button class="layui-btn layui-btn-success" id="addTask">导入流程</button>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md-12">
            <table class="table table-bordered table-hover" id="taskTable" lay-filter="taskTable">
            </table>
        </div>

    </div>
</div>

<script type="text/html" id="indexTpl">
    {{d.LAY_TABLE_INDEX+1}}
</script>
<script type="text/html" id="taskTableTool">
    <#--<a class="layui-btn layui-btn-xs" lay-event="edit">部署</a>-->
    <a class="layui-btn layui-btn-xs" lay-event="export">办理</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script type="text/javascript">
    layui.use(['table', 'm_utils'], function () {
        var table = layui.table;
        var m_utils = layui.m_utils;

        //第一个实例
        var currentTable = table.render({
            elem: "#taskTable",
            page: true,
            url: "/pagingTask",
            method: "POST",
            cols: [[
                {title: '序号',templet: '#indexTpl'},
                {title:'流程名称',field:'name'},
                {title:'流程标识',field:'key'},
                {title:'版本',field:'version'},
                {title:'描述',field:'description'},
                {fixed: 'right', align: 'center', toolbar: '#taskTableTool'}
            ]],
            request: {
                pageName: 'pageNo' //页码的参数名称，默认：page
                , limitName: 'pageSize' //每页数据量的参数名，默认：limit
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

        table.on('tool(taskTable)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var taskId = data.id;

            if (layEvent === 'export') { //编辑

            } else if (layEvent === 'del') { //删除

            }
        });

        $("#addTask").click(function () {
            var data = {
                title: '添加角色',//标题
                area: '60%',//宽高
                closeBtn: 1,//关闭按钮
                shadeClose: true,//是否点击遮罩关闭
                queryId: '',
                queryUrl: '/task/addTask'
            };
            m_utils.openModal(data,function (layerDom,index) {
                currentTable.reload();
            });
        });
    });

</script>