/**
 * 权限管理模块
 */
layui.define(function (exports) {
    layui.use(["layer"], function () {

    });

    var RoleObj = {
        addNewRole: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: "/management/role/addRole",
                    type: "POST",
                    dataType: "json",
                    data: data,
                    traditional : true,
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
        ,updateRole: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: "/management/role/updateRole",
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
        ,deleteRole: function (roleId, callback) {
            //同步到服务端
            var syncServer = function (roleId, callback) {
                var index = layui.layer.load(2);
                //TODO 异常处理
                $.ajax({
                    url: "/management/role/delRole",
                    type: "GET",
                    dataType: "json",
                    data: {roleId:roleId},
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
                syncServer(roleId, function (res, status) {
                    layui.layer.close(index);
                    if (typeof callback == "function") {
                        callback(res, status);
                    }
                })
            });
        }
        ,editRolePrivilege: function (data,callback) {
            var syncServer = function (data, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: '/management/role/authRole',
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

            }
            syncServer(data,function (res,status) {
                callback(res,status);
            })
        }
        ,rolePrivilegeCheckbox: function (data) {
            var ref = data.elem.getAttribute("data-ref");
            var alias = data.elem.getAttribute("data-alias");
            var level = data.elem.getAttribute("data-level");
            if(level==1){//顶级权限事件
                var $p = $(":checkbox[data-ref="+alias+"]");
                if(data.elem.checked){//父级权限选中，则子代权限默认全选中
                    $p.each(function () {
                        $(this).prop("checked",true);
                    });
                }else{//父级权限取消选中，则子代权限全部取消
                    $p.each(function () {
                        $(this).prop("checked", false);
                    });
                }
            }else if(level>1){//子代权限选中事件
                if(data.elem.checked){//子代权限选中，则父级权限必须为选中
                    $(":checkbox[data-alias="+ref+"]").prop("checked",true);
                }else{
                    var $t = $(":checkbox[data-ref="+ref+"]").not($(this));
                    var hasChecked = false;
                    $t.each(function () {//子代权限取消选中，若有同级权限为选中状态则父级权限为选中，若没有则父级权限取消选中
                        var flag = $(this).prop("checked");
                        if(flag){
                            hasChecked = true;
                        }
                        console.log($(this).attr("data-alias")+" : "+flag+" : "+hasChecked);
                    });
                    if(!hasChecked){
                        $(":checkbox[data-alias="+ref+"]").prop("checked",false);
                    }
                }
            }
        }
    }
    /**
     * 对外暴露的方法
     */
    exports("m_role", {
        /**
         * 新增角色
         * @param data
         * @param callback
         */
        addRole: function (data,callback) {
            RoleObj.addNewRole(data,callback);
        }
        /**
         * 删除角色
         * @param roleId
         * @param callback
         */
        ,deleteRole: function (roleId, callback) {
            RoleObj.deleteRole(roleId, callback);
        }
        /**
         * 更新角色
         * @param data
         * @param callback
         */
        ,updateRole: function (data,callback) {
            RoleObj.updateRole(data,callback);
        }

        /**
         * 给角色赋权限
         * @param data
         * @param callback
         */
        ,editRolePrivilege: function (data, callback) {
            RoleObj.editRolePrivilege(data,callback);
        }

        /**
         * 权限多选框功能
         * @param data
         */
        ,privilegeCheckbox: function (data) {
            RoleObj.rolePrivilegeCheckbox(data);
        }
    });

});

