<div class="margin-top layui-fluid">
    <div class="layui-row">
        <form class="layui-form layui-form-pane" action="">
            <div class="layui-form-item">
                <fieldset class="layui-elem-field layui-field-title">
                    <legend>角色名</legend>
                    <div class="layui-field-box">
                        <input type="text" id="roleName" name="roleName" lay-verify="roleName" lay-verType="tips" placeholder="角色名" autocomplete="off" class="layui-input">
                    </div>
                </fieldset>
            </div>
            <div class="layui-form-item">
                <fieldset class="layui-elem-field layui-field-title"">
                    <legend>权限设置</legend>
                    <div class="layui-field-box">
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
                    </div>
                </fieldset>

            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="submit" class="layui-btn" lay-submit lay-filter="addRole">提交</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
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
        form.on('submit(addRole)', function(data){
            var roleName = $("#roleName").val();
            var privilegeIds = new Array();
            $("input:checkbox[name='privilegeId']:checked").each(function() { // 获取多选框值
                privilegeIds.push($(this).val());
            });
            var formData = {roleName:roleName,privilegeId:privilegeIds};
            console.log(formData);
            itenderRole.addRole(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("添加成功!");
                }else{
                    layer.msg("添加失败!"+res.msg());
                }
            });
            return false;
        });
        form.on('checkbox', function(data){//权限复选框事件
            itenderRole.privilegeCheckbox(data);
            form.render('checkbox');
        });
        form.render('checkbox');
    });
</script>