<div class="margin-top layui-fluid">
    <div class="layui-row">
        <form class="layui-form layui-form-pane" action="">
            <#if itenderPrivilege??>
                <div class="layui-form-item">
                    <label class="layui-form-label">权限名</label>
                    <div class="layui-input-inline">
                        <input type="hidden" name="privilegeId" value="${itenderPrivilege.id!}">
                        <input type="text" name="privilegeName" lay-verify="privilegeName" lay-verType="tips" autocomplete="off" class="layui-input" value="${itenderPrivilege.privilegeName!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">资源路径</label>
                    <div class="layui-input-inline">
                        <input type="text" name="privilegeUri" lay-verify="privilegeUri" lay-verType="tips" autocomplete="off" class="layui-input" value="${itenderPrivilege.privilegeUri!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">请求方法</label>
                    <div class="layui-input-inline">
                        <input type="text" name="privilegeMethod" lay-verify="privilegeMethod" lay-verType="tips" placeholder="如:GET" autocomplete="off" class="layui-input" value="${itenderPrivilege.privilegeMethod!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">唯一别名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" lay-verify="alias" lay-verType="tips" placeholder="如:用户管理" autocomplete="off" class="layui-input" value="${itenderPrivilege.alias!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">图标</label>
                    <div class="layui-input-inline">
                        <input type="text" name="icon" lay-verify="icon" lay-verType="tips" placeholder="图标" autocomplete="off" class="layui-input" value="${itenderPrivilege.icon!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">序号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="seq" lay-verify="seq" lay-verType="tips" placeholder="序号" autocomplete="off" class="layui-input" value="${itenderPrivilege.seq!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">级别</label>
                    <div class="layui-input-inline">
                        <input type="text" name="level" lay-verify="level" lay-verType="tips" placeholder="级别" autocomplete="off" class="layui-input" value="${itenderPrivilege.level!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">关联</label>
                    <div class="layui-input-inline">
                        <input type="text" name="ref" lay-verify="ref" lay-verType="tips" placeholder="关联唯一别名" autocomplete="off" class="layui-input" value="${itenderPrivilege.ref!}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button type="submit" class="layui-btn" lay-submit lay-filter="updatePrivilege">提交</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
            <#else>
                <div class="layui-form-item">
                    <label class="layui-form-label">权限名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="privilegeName" lay-verify="privilegeName" lay-verType="tips" placeholder="权限名" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">资源路径</label>
                    <div class="layui-input-inline">
                        <input type="text" name="privilegeUri" lay-verify="privilegeUri" lay-verType="tips" placeholder="URL" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">请求方法</label>
                    <div class="layui-input-inline">
                        <input type="text" name="privilegeMethod" lay-verify="privilegeMethod" lay-verType="tips" placeholder="如:GET" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">唯一别名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" lay-verify="alias" lay-verType="tips" placeholder="如:用户管理" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">图标</label>
                    <div class="layui-input-inline">
                        <input type="text" name="icon" lay-verify="icon" lay-verType="tips" placeholder="图标" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">序号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="seq" lay-verify="seq" lay-verType="tips" placeholder="序号" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">级别</label>
                    <div class="layui-input-inline">
                        <input type="text" name="level" lay-verify="level" lay-verType="tips" placeholder="级别" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">关联</label>
                    <div class="layui-input-inline">
                        <input type="text" name="ref" lay-verify="ref" lay-verType="tips" placeholder="关联唯一别名" autocomplete="off" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button type="submit" class="layui-btn" lay-submit lay-filter="addPrivilege">提交</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
            </#if>
        </form>
    </div>
</div>
<script>
    layui.use(['form','itenderPrivilege'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var itenderPrivilege = layui.itenderPrivilege;

        form.verify({
            privilegeName: function (value, item) {
                if (value.length == 0){
                    return "权限名不能为空";
                }
            },
            privilegeUri: function (value, item) {
                if (value.length == 0){
                    return "资源路径不能为空";
                }
            },
            alias: function (value, item) {
                if (value.length == 0){
                    return "别名不能为空";
                }
            },
            level: function (value, item) {
                if (value.length == 0){
                    return "级别不能为空";
                }
            },
            ref: function (value, item) {
                if (value.length == 0){
                    return "关联不能为空";
                }
            }
        });
        form.on('submit(addPrivilege)', function(data){
            var formData = data.field;
            itenderPrivilege.addPrivilege(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("添加成功!");
                }else{
                    layer.msg("添加失败!");
                }
            });
            return false;
        });
        form.on('submit(updatePrivilege)', function(data){
            var formData = data.field;
            itenderPrivilege.updatePrivilege(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("更新成功!");
                }else{
                    layer.msg("更新失败!");
                }
            });
            return false;
        });
    });
</script>