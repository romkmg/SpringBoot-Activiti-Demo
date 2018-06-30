<#--<#include "../resource.ftl">-->
<div class="margin-top layui-fluid">
    <div class="layui-row">
            <form class="layui-form layui-form-pane" action="" autocomplete="off">
                <div class="layui-form-item">
                    <label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="realname" lay-verify="realname" lay-verType="tips" placeholder="真实姓名" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="username" lay-verify="username" lay-verType="tips" placeholder="用户名" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">Email</label>
                    <div class="layui-input-inline">
                        <input type="text" name="email" lay-verify="" lay-verType="tips" placeholder="邮箱地址" autocomplete="off" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">密码</label>
                    <div class="layui-input-inline">
                        <input type="password" id="password" name="password" lay-verify="password" lay-verType="tips" placeholder="密码" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">确认密码</label>
                    <div class="layui-input-inline">
                        <input type="password" id="rePassword" name="rePassword" lay-verify="rePassword" lay-verType="tips" placeholder="密码" autocomplete="off" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button type="submit" class="layui-btn" lay-submit lay-filter="addUser">提交</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
            </form>
    </div>
</div>
<script>
    layui.use(['form','itenderUser'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var itenderUser = layui.itenderUser;

        form.verify({
            realname: function (value, item) {
                if (value.length == 0){
                    return "姓名不能为空";
                }
            },
            username: function (value, item) {
                var reg =new RegExp("^[a-zA-Z][a-zA-Z0-9_]{0,15}$");

                if (value.length == 0){
                    return "用户名不能为空";
                }else if(!reg.test(value)){
                    return "用户名需为英文字母开头字母数字或下划线组成";
                }
            },
            password: function (value, item) {
                if (value.length == 0){
                    return "密码不能为空";
                }
            },
            rePassword: function (value, item) {
                var password = $("#password").val();
                if (value.length == 0){
                    return "确认密码不能为空";
                }
                if (value != password){
                    return "两次密码不一致";
                }
            }
        });
        form.on('submit(addUser)', function(data){
            var formData = data.field;
            itenderUser.addNewUser(formData,function (res,status) {
                if(status){
                    layer.closeAll('page'); //执行关闭
                    layer.msg("添加成功!");
                }else{
                    layer.msg("添加失败!"+res.data);
                }
            });
            return false;
        });
    });
</script>