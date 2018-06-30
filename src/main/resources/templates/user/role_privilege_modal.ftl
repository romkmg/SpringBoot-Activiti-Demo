
<div class="margin-top layui-fluid">
    <div class="layui-row">
        <div calss="layui-col-md-12">
            <form class="layui-form layui-form-pane" action="">
                <#if targetRole??>
                <blockquote class="layui-elem-quote">${targetRole.roleName!}
                    <input type="hidden" id="roleId" name="roleId" value="${targetRole.id!}">
                </blockquote>

                <#if privilegesLev1??>
                <#list privilegesLev1 as privilege1>
                <fieldset class="layui-elem-field">
                    <legend><input type="checkbox" data-level="${privilege1.level!}" data-ref="${privilege1.ref!'null'}" data-alias="${privilege1.alias!}" name="privilegeId" value="${privilege1.id!}" title="${privilege1.privilegeName!}" ></legend>
                    <div class="layui-field-box">
                        <div class="layui-row">
                            <#if privilegesLev2??>
                            <#list privilegesLev2 as privilege2>
                            <#if privilege2.ref==privilege1.alias>
                            <div class="layui-col-md3">
                                <input type="checkbox" data-level="${privilege2.level!}" data-ref="${privilege2.ref!'null'}" data-alias="${privilege2.alias!}" name="privilegeId" value="${privilege2.id!}" title="${privilege2.privilegeName!}" >
                            </div>
                            </#if>
                                <#if privilegesLev3??>
                                <#list privilegesLev3 as privilege3>
                                    <#if privilege3.ref==privilege2.alias>
                                    <input type="checkbox" data-level="${privilege3.level!}" data-ref="${privilege3.ref!'null'}" data-alias="${privilege3.alias!}" name="privilegeId" value="${privilege3.id!}" title="${privilege3.privilegeName!}" >
                                    </#if>
                                </#list>
                                </#if>
                            </#list>
                            </#if>
                        </div>
                    </div>
                </fieldset>
                </#list>
                </#if>

                <div class="layui-form-item">
                    <div class="layui-input-block" style="text-align: center">
                        <button type="submit" class="layui-btn" lay-submit lay-filter="updateRolePrivilege">提交</button>
                        <button type="button" id="cancel" class="layui-btn layui-btn-primary">取消</button>
                    </div>
                </div>
                <#else>
                <h2>数据错误！</h2>
                </#if>
            </form>
        </div>
    </div>
</div>

<script>
    layui.use(['form','jquery','itenderRole'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var itenderRole = layui.itenderRole;

        form.on('submit(updateRolePrivilege)', function(data){
            var roleId = $("#roleId").val();
            var privilegeIds = new Array();
            $("input:checkbox[name='privilegeId']:checked").each(function() { // 获取多选框值
                privilegeIds.push($(this).val());
            });
            if(privilegeIds.length==0){
                privilegeIds = [''];
            }

            var formData = {roleId:roleId,privilegeId:privilegeIds};
            console.log(formData);
            itenderRole.editRolePrivilege(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("更新成功!");
                }else{
                    layer.msg('更新失败！'+res.msg);
                }
            });
            return false;
        });
        form.render();
        $("#cancel").click(function () {
            layer.closeAll('page'); //执行关闭
        });

        form.on('checkbox', function(data){//权限复选框事件
            itenderRole.privilegeCheckbox(data);
            form.render('checkbox');
        });

        //初始化已有权限复选框
        var roleIds = ["${existPrivilege?join("\",\"")}"];
        console.log(roleIds);
        roleIds.forEach(function (item, index) {
            $("input:checkbox[value='"+item+"']").prop('checked',true);
            form.render('checkbox');
        });

    });


</script>
