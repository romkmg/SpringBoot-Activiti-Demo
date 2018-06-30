/**
 * 权限管理模块
 */
layui.define(function (exports) {
    layui.use(["layer"], function () {

    });

    var PrivilegeObj = {
        addNewPrivilege: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: "/management/privilege/addPrivilege",
                    type: "POST",
                    dataType: "json",
                    data: data,
                    success: function (res) {
                        layui.layer.close(index);
                        if(res.status){
                            callback(res, true);
                        }else{
                            callback(res.msg,false);
                        }
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            }
            syncServer(data,function (res,status) {
                if (typeof callback == "function") {
                    callback(res, status);
                }
            });
        }
        ,updatePrivilege: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: "/management/privilege/updatePrivilege",
                    type: "POST",
                    dataType: "json",
                    data: data,
                    success: function (res) {
                        layui.layer.close(index);
                        if(res.status){
                            callback(res, true);
                        }else{
                            callback(res.msg,false);
                        }
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            }
            syncServer(data,function (res,status) {
                if (typeof callback == "function") {
                    callback(res, status);
                }
            });
        }
        ,deletePrivilege: function (privilegeId, callback) {
            //同步到服务端
            var syncServer = function (privilegeId, callback) {
                var index = layui.layer.load(2);
                //TODO 异常处理
                $.ajax({
                    url: "/management/privilege/delPrivilege",
                    type: "GET",
                    dataType: "json",
                    data: {privilegeId:privilegeId},
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res, res.status);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            }

            //删除确认窗口
            layui.layer.confirm('您确定要删除该项?删除后不可恢复!', {icon: 3, title: '删除确认'}, function (index) {
                syncServer(privilegeId, function (res, status) {
                    layui.layer.close(index);
                    if (typeof callback == "function") {
                        callback(res, status);
                    }
                })
            });
        }
    }
    /**
     * 对外暴露的方法
     */
    exports("m_privilege", {
        /**
         * 新增权限
         * @param data
         * @param callback
         */
        addPrivilege: function (data,callback) {
            PrivilegeObj.addNewPrivilege(data,callback);
        }
        /**
         * 删除权限
         * @param privilegeId
         * @param callback
         */
        ,deletePrivilege: function (privilegeId, callback) {
            PrivilegeObj.deletePrivilege(privilegeId, callback);
        }
        /**
         * 更新权限
         * @param data
         * @param callback
         */
        ,updatePrivilege: function (data,callback) {
            PrivilegeObj.updatePrivilege(data,callback);
        }
    });

});

