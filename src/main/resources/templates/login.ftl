<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
    <#include "resource.ftl">
    <style>
        .login {
            margin-top: 15%;
        }
    </style>
</head>
<body>

<div class="layui-container login">
    <div class="layui-row">
        <div class="layui-col-md6 layui-col-md-offset3">
            <form action="/login" method="post" class="layui-form">
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <h2 style="text-align: center">登录</h2>
                    <#--<div class="layui-word-aux">默认用户名和密码:admin/123</div>-->
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label" for="username">用户名</label>
                    <div class="layui-input-block">
                        <input type="text" class="layui-input" name="username" id="username" lay-verify="username"
                               lay-verType="tips" placeholder="用户名">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label" for="password">密码</label>
                    <div class="layui-input-block">
                        <input type="password" class="layui-input" name="password" id="password" lay-verify="password"
                               lay-verType="tips" placeholder="密码">
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button type="submit" class="layui-btn layui-btn-default layui-btn-block" lay-submit
                                lay-filter="login" style="width: 100%">
                            登录
                        </button>

                        <br><br>
                        <div id="activex_install"></div>
                    </div>
                </div>
            </form>
        </div>
    </div>

</div>
</body>
<script>
    layui.use(['form', 'm_user'], function () {
        var form = layui.form;
        var user = layui.m_user;

        form.verify({
            username: function (value, item) {
                if (value.length == 0) return "用户名不能为空"
            },
            password: function (value, item) {
                if (value.length == 0) return "密码不能为空"
            }
        });
        form.on('submit(login)', function (data) {
            var formData = data.field;
            console.debug(formData);
            user.userLogin(formData);//用户登录
            return false;
        });
    });
</script>
</html>