<style>
    /*
        多选框CSS
     */
    .layui-form select[multiple] + .layui-form-select dd { padding: 0;}
    .layui-form select[multiple] + .layui-form-select .layui-form-checkbox[lay-skin="primary"] {width:100%; text-align:left;}
    .layui-form select[multiple] + .layui-form-select .layui-form-checkbox[lay-skin="primary"] span {float: left; padding-left:30px;}
    .layui-form select[multiple] + .layui-form-select .layui-form-checkbox[lay-skin="primary"] i {position: absolute;left:10px;top: 0;}
    .layui-form select[multiple] + .layui-form-select dd.layui-disabled{ padding-left:10px;}
    .multiSelect{ line-height:normal; height:auto; padding:4px 10px; overflow:hidden;min-height:38px; margin-top:-38px; left:0; z-index:99;position:relative;background:none;}
    .multiSelect a{ padding:2px 5px; background:#908e8e; border-radius:2px; color:#fff; display:block; line-height:20px; height:20px; margin:2px 2px 2px 0; float:left;}
    .multiSelect a span{ float:left;}
    .multiSelect a i{ float:left; display:block; margin:2px 0 0 2px; border-radius:2px; width:8px; height:8px; background:url(/css/close.png) no-repeat center; background-size:65%; padding:4px;}
    .multiSelect a i:hover{ background-color:#545556;}
</style>
<div class="margin-top layui-fluid">
    <div class="layui-row">
        <div calss="layui-col-md-12">
            <form class="layui-form layui-form-pane" action="">
                <#if targetUser??>
                <div class="layui-form-item">
                    <label class="layui-form-label">用户</label>
                    <div class="layui-input-block">
                        <input type="hidden" id="userId" name="userId" value="${targetUser.id!}">
                        <input type="text" class="layui-input" value="${targetUser.userName!}" disabled>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">角色</label>
                    <div class="layui-input-block">

                    <#if allRoles??>
                    <#list allRoles as role>
                    <#if existRole??>
                    <#if existRole?seq_contains(role.roleName)>
                    <div class="layui-col-md4">
                        <input type="checkbox" name="roleId" value="${role.id}" title="${role.roleName}" checked>
                    </div>
                    <#else>
                   <div class="layui-col-md4">
                       <input type="checkbox" name="roleId" value="${role.id}" title="${role.roleName}" >
                   </div>
                    </#if>
                    <#else>
                    <div class="layui-col-md4">
                        <input type="checkbox" name="roleId" value="${role.id}" title="${role.roleName}" >
                    </div>
                    </#if>
                    </#list>
                    </#if>


                        <#--<select id="roleIdSelect" multiple="multiple" name="roleId">-->
                            <#--<option value=""></option>-->
                            <#--<#if allRoles??>-->
                                <#--<#list allRoles as role>-->
                                    <#--<#if existRole??>-->
                                        <#--<#if existRole?seq_contains(role.roleName)>-->
                                            <#--<option value="${role.id}" selected>${role.roleName}</option>-->
                                        <#--<#else>-->
                                            <#--<option value="${role.id}">${role.roleName}</option>-->
                                        <#--</#if>-->
                                    <#--<#else>-->
                                        <#--<option value="${role.id}">${role.roleName}</option>-->
                                    <#--</#if>-->
                                <#--</#list>-->
                            <#--</#if>-->
                        <#--</select>-->
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button type="submit" class="layui-btn" lay-submit lay-filter="updateUserRole">提交</button>
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

    layui.use(['form','jquery','itenderUser','multipleSelect'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var itenderUser = layui.itenderUser;
        var multipleSelect = layui.multipleSelect;

        form.on('submit(updateUserRole)', function(data){
            var roleIds = new Array();
            $("input:checkbox[name='roleId']:checked").each(function() { // 获取多选框值
                roleIds.push($(this).val());
            });
            if(roleIds.length==0){
                roleIds = [''];
            }

            var userId = $("#userId").val();
            // var roleIds = $("#roleIdSelect").val();
            var formData = {userId:userId,roleId:roleIds};
            console.log(formData);
            itenderUser.editUserRole(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("更新成功!");
                }else{
                    layer.msg('更新失败！'+res.msg);
                }
            });
            return false;
        });

        //上面已做处理，不用js赋值
        //通过js给下拉框初始值，这里服务器返回值existRole为roleID数组
        <#--var roleIds = ["${existRole?join("\",\"")}"];-->
        <#--console.log(roleIds);-->
        <#--$("select[name=roleId]").val(roleIds);-->

        form.render();
        // multipleSelect.render();//宣染带有multiple="multiple"的select变成带checkbox的

        $("#cancel").click(function () {
            layer.closeAll('page'); //执行关闭
        });
    });
</script>