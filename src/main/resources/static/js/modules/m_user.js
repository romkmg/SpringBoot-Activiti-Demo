/**
 * 用户模块
 */
layui.define(function (exports) {
    layui.use(["layer","element"], function () {

    });

    var UserObj = {
        userLogin: function(data){
            var index = layer.load(2);
            $.ajax({
                url:"/login",
                type:"POST",
                data:data,
                success:function(result){
                    layui.layer.close(index);
                    if(result === "true"){
                        var indexFrame = parent.layer.getFrameIndex(window.name);//关闭登录弹出层
                        parent.layer.close(indexFrame);
                        if(result.admin){
                            view.goto('/admin');
                            return;
                        }
                        view.goto('/index');
                    }else{
                        layui.layer.msg('登录失败，'+result.msg, {icon: 5});
                    }
                },
                error: function (xmlHttpReq, error, ex) {
                    layui.layer.close(index);
                }
            });
        },

        userLogout: function () {
            var syncServer = function (callback) {
                $.ajax({
                    url:"/logout",
                    type:"GET",
                    cache:false,
                    success:function(result){
                        if(result === "true"){
                           callback(result,true);
                        }else{
                            callback(result,false);
                        }
                    },
                    error: function (xmlHttpReq, error, ex) {

                    }

                });
            };
            layui.layer.confirm('您确定要退出!', {icon: 3, title: '退出确认',zIndex:9999999}, function (index) {
                syncServer(function (res, status) {
                    layui.layer.close(index);
                    if(status){
                        view.goto('/');
                    }else{
                        layer.msg('系统繁忙,请稍后再试！', {icon: 5});
                    }
                })
            });
        }

        ,addUser: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: '/management/user/register',
                    type: "POST",
                    dataType: "json",
                    data: data,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })

            };
            syncServer(data,function (res,status) {
                callback(res,status);
            })
        }

        ,deleteUser: function (data, callback) {
            //同步到服务端
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                //TODO 异常处理
                $.ajax({
                    url: "/management/user/delUser",
                    type: "POST",
                    data: {userId:data.userId,operator:data.operator},
                    dataType: "json",
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            };

            //删除确认窗口
            layui.layer.confirm('您确定要冻结该用户？', {icon: 3, title: '确认'}, function (index) {
                syncServer(data, function (res, status) {
                    layui.layer.close(index);
                    callback(res, status);
                })
            });
        }
        ,updateUser: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: data.url,
                    type: "POST",
                    dataType: "json",
                    data: data.formData,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                        callback(error, false);
                    }
                })

            };
            syncServer(data,function (res,status) {
                callback(res,status);
            })
        }
        ,editUserRole: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: '/management/role/authUser',
                    type: "POST",
                    dataType: "json",
                    data: data,
                    traditional : true,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                        callback(error, false);
                    }
                })

            };
            syncServer(data,function (res,status) {
                callback(res,status);
            })
        } ,forbidden: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: '/management/user/forbidden',
                    type: "POST",
                    dataType: "json",
                    data: data,
                    traditional : true,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                        callback(error, false);
                    }
                })

            };
            syncServer(data,function (res,status) {
                callback(res,status);
            })
        } ,approve: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: '/management/user/approve',
                    type: "POST",
                    dataType: "json",
                    data: data,
                    traditional : true,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                        callback(error, false);
                    }
                })

            };
            syncServer(data,function (res,status) {
                callback(res,status);
            })
        }
};
    /**
     * 对外暴露的方法
     */
    exports("m_user", {
        /**
         * 用户登录
         * @param data
         */
        userLogin: function (data) {
            UserObj.userLogin(data);
        }

        /**
         * 用户注销
         * @param callback
         */
        ,userLogout: function () {
            UserObj.userLogout();
        }

        /**
         * 添加用户
         * @param data
         * @param callback
         */
        ,addNewUser: function (data,callback) {
            UserObj.addUser(data,callback);
        }

        /**
         * 删除用户
         * @param templateId
         * @param callback
         */
        ,deleteUser: function (userId, callback) {
            UserObj.deleteUser(userId, callback);
        }

        /**
         * 更新用户信息
         * @param data
         * @param callback
         */
        ,updateUser: function (data,callback) {
            UserObj.updateUser(data,callback);
        }

        /**
         * 给用户设置角色
         * @param data
         * @param callback
         */
        ,editUserRole: function (data,callback) {
            UserObj.editUserRole(data,callback);
        }

        /**
         * 用户注册通过审核
         * @param data
         * @param callback
         */
        ,approve: function (data,callback) {
            UserObj.approve(data,callback);
        }
        /**
         * 用户注册审核没有通过
         * @param data
         * @param callback
         */
        ,forbidden: function (data,callback) {
            UserObj.forbidden(data,callback);
        }
    });

});

