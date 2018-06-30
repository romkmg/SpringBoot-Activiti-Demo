<div class="margin-top layui-fluid">
    <div class="layui-row">
        <form class="layui-form layui-form-pane" action="">
            <#if itenderRole??>
                <div class="layui-form-item">
                    <label class="layui-form-label">角色名</label>
                    <div class="layui-input-inline">
                        <input type="hidden" name="roleId" value="${itenderRole.id!}">
                        <input type="text" name="roleName" lay-verify="roleName" lay-verType="tips" placeholder="角色名" autocomplete="off" class="layui-input" value="${itenderRole.roleName!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button type="submit" class="layui-btn" lay-submit lay-filter="updateRole">更新</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
            <#else>
                <h2>数据异常！</h2>
            </#if>
        </form>
    </div>
</div>
<script>
    layui.use(['form','itenderRole'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var itenderRole = layui.itenderRole;

        form.verify({
            roleName: function (value, item) {
                if (value.length == 0){
                    return "角色名不能为空";
                }
            }
        });
        form.on('submit(updateRole)', function(data){
            var formData = data.field;
            itenderRole.updateRole(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("更新成功!");
                }else{
                    layer.msg("更新失败!"+res.msg);
                }
            });
            return false;
        });
    });
</script>