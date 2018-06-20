<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
    <#include "resource.ftl">
    <style>

        #background {
            z-index: -1000;
            padding-top: 15%;
            height: 100%;
            width: 100%;
            background-size: cover;
            background-position: center;
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
           background-color: #fafafa;

        }

        .layui-input-block {
            margin-left: 0px;
            margin:0 auto;
        }


        .layui-row{
            padding-left: 40px;
            padding-right: 40px;
            height: 100%;
            padding-top: 30%;
            background-color: #fafafa;
        }




    </style>
</head>
<body>

<div id="background" class="layui-container">
    <div align="center" style=" margin:0 auto;width:380px;height:100%;z-index: 1000;">

        <div class="layui-row" style="">

                <form action="/login" method="post" class="layui-form">

                    <div class="layui-form-item">

                        <div class="layui-input-block">
                            <input type="text" class="layui-input" name="username" id="username" lay-verify="username" lay-verType="tips" placeholder="请输入用户名">
                        </div>
                    </div>
                    <div class="layui-form-item">

                        <div class="layui-input-block">
                            <input type="password" class="layui-input" name="password" id="password" lay-verify="password" lay-verType="tips" placeholder="请输入密码">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-inline" style="width: 115px;font-size: 12px">
                            <input type="text" class="layui-input" name="captcha" id="captcha" lay-verify="captcha" lay-verType="tips" placeholder="输入验证码">
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="verifyImgDiv"><img id="verifyImg" src="management/user/code" style="height: 35px;margin-top: -7px;" title="验证码"> (验证码)</div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button type="submit" class="layui-btn layui-btn-default layui-btn-block" lay-submit lay-filter="login" style="width: 100%">
                                登录
                            </button>
                        </div>
                    </div>
                </form>
        </div>
    </div>


</div>
</body>
<#include "footer.ftl">
<script>
    layui.use(['form','layer','itenderUser'], function () {
        var form = layui.form;
        var itenderUser = layui.itenderUser;
        var layer = layui.layer;

  		form.verify({
            username: function (value, item) {
                if (value.length == 0) return "用户名不能为空"
            },
            password: function (value, item) {
                if (value.length == 0) return "密码不能为空"
            },
            captcha: function (value, item) {
                if (value.length == 0) return "验证码不能为空"
            }
        });
        form.on('submit(login)', function(data){
            var formData = data.field;
            formData.type='normal';
			console.log(formData);
            itenderUser.userLogin(formData);//用户登录
			return false;
		});

        $("#verifyImgDiv").click(function () {
            var time = new Date().getTime();
            $("#verifyImgDiv").empty().append('<img id="verifyImg" src="management/user/code?'+time+'" style="height: 35px;margin-top: -7px;" title="点击刷新验证码"> (验证码)');
        });

	  });
</script>
</html>
