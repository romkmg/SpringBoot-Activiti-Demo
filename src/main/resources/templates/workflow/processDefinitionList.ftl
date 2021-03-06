<div class="layui-container margin-top">
    <div class="layui-row">
        <div class="layui-col-md-12 margin-bottom">
            <button class="layui-btn layui-btn-success" id="addProcess">导入流程</button>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md-12">
            <table class="table table-bordered table-hover" id="processTable" lay-filter="processTable">
            </table>
        </div>

    </div>
</div>

<script type="text/html" id="indexTpl">
    {{d.LAY_TABLE_INDEX+1}}
</script>
<script type="text/html" id="processTableTool">
    <a class="layui-btn layui-btn-xs" lay-event="view">查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="export">导出</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script type="text/javascript">
    layui.use(['table', 'm_utils','m_processDefinition'], function () {
        var table = layui.table;
        var m_utils = layui.m_utils;
        var m_processDefinition = layui.m_processDefinition;

        //第一个实例
        var currentTable = table.render({
            elem: "#processTable",
            page: true,
            url: "/pagingProcessDefinition",
            method: "POST",
            cols: [[
                {field:'processDefinitionId',type:'checkbox'},
                {title: '序号',templet: '#indexTpl'},
                {title:'流程名称',field:'name'},
                {title:'流程标识',field:'key'},
                {title:'版本',field:'version'},
                {title:'描述',field:'description'},
                {fixed: 'right', align: 'center', toolbar: '#processTableTool'}
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

        table.on('tool(processTable)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            console.log(data);
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var processId = data.processDefinitionId;

            if (layEvent === 'view') { //查看
                m_processDefinition.processDefinitionImage(processId);
            } else if (layEvent === 'export') { //导出
                m_processDefinition.exportDefinition(processId);
            } else if (layEvent === 'del') { //删除

            }
        });

        $("#addProcess").click(function () {
            m_processDefinition.importDefinition(function (res) {
                if(res){
                    currentTable.reload();
                }
            });
        });
    });

</script>