<div class="margin-top layui-fluid">
    <div class="layui-row">
        <form class="layui-form layui-form-pane" action="">
                <#if currentUser??>
                    <div class="layui-form-item">
                        <label class="layui-form-label">姓名</label>
                        <div class="layui-input-inline">
                            <input type="text" name="realname" class="layui-input" value="${currentUser.realName!}"
                                   disabled>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">用户名</label>
                        <div class="layui-input-inline">
                            <input type="hidden" name="userId" value="${currentUser.id!}">
                            <input type="text" name="username" class="layui-input" value="${currentUser.userName!}"
                                   disabled>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">Email</label>
                        <div class="layui-input-inline">
                            <input type="text" name="email" lay-verify="" lay-verType="tips" placeholder="邮箱地址"
                                   autocomplete="off" class="layui-input" value="${currentUser.email!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">密码</label>
                        <div class="layui-input-inline">
                            <input type="password" id="password" name="password" lay-verify="password"
                                   lay-verType="tips" placeholder="密码" autocomplete="off" class="layui-input"
                                   value="${currentUser.password!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <div class="layui-input-block">
                        <#if currentUser.id==user.id>
                        <button type="submit" class="layui-btn" lay-submit lay-filter="updateMy">提交</button>
                        <#else>
                        <button type="submit" class="layui-btn" lay-submit lay-filter="updateUser">提交</button>
                        </#if>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>
                <#else>
                <h2>服务器内部错误！</h2>
                </#if>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'itenderUser'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var itenderUser = layui.itenderUser;

        form.verify({
            password: function (value, item) {
                if (value.length == 0) {
                    return "密码不能为空";
                }
            }
        });
        form.on('submit(updateUser)', function (data) {
            var formData = data.field;
            var datas = {url: '/management/user/updateUser', formData: formData};
            itenderUser.updateUser(datas, function (res, status) {
                if (status) {
                    layer.closeAll('page'); //执行关闭
                    layer.msg("更新成功!");
                } else {
                    layer.msg("更新失败!" + res.msg);
                }
            });
            return false;
        });
        form.on('submit(updateMy)', function (data) {
            var formData = data.field;
            var datas = {url: '/management/user/updateMy', formData: formData};
            itenderUser.updateUser(datas, function (res, status) {
                if (status) {
                    layer.closeAll('page'); //执行关闭
                    layer.msg("更新成功!");
                } else {
                    layer.msg("更新失败!" + res.msg);
                }
            });
            return false;
        });
    });
</script>