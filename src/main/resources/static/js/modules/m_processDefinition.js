/**
 * 工具模块
 */
layui.define(function (exports) {
    layui.use(["layer","element","form"], function () {

    });

    var ProcessDefinitionObj = {

        importDefinition: function (callback) {
            var html = '<form class="layui-form" enctype="multipart/form-data">' +
                        '   <div class="layui-form-item">\n' +
                        '   </div>'+
                        '   <div class="layui-form-item">\n' +
                        '    <label class="layui-form-label">选择文件</label>\n' +
                        '    <div class="layui-input-block">\n' +
                        '      <input type="file" name="file" id="file" lay-verify="required"  lay-verType="tips" >\n' +
                        '    </div>\n' +
                        '   </div>'+
                        '   <div class="layui-form-item">\n' +
                        '    <div class="layui-input-block">\n' +
                        '      <button class="layui-btn" lay-submit lay-filter="ok" style="width: 150px;">上传</button>\n' +
                        '    </div>\n' +
                        '   </div>'+
                        '</form>';
            var index_ = layer.open({
                type: 1,
                title: "上传流程部署",
                content: html,
                area:['400px','200px'],
                btn: false,
                success: function(index, layero){
                    layui.form.render();
                    layui.form.on('submit(ok)',function (data) {
                        console.log(data);
                        syncServer(data.form,function (res) {
                                layui.layer.close(index_);
                                callback(true);
                            if(!res){
                                layui.layer.alert("上传失败！")
                            }
                        });
                        return false;
                    });
                }
            });

            var syncServer = function (form, callback) {
                var index = layui.layer.load(2);
                var formData = new FormData();
                formData.append("file",form[0].files[0]);
                $.ajax({
                    url: "/workflow/importDefinition",
                    type:"post",
                    data:formData,
                    cache: false,
                    processData: false,
                    contentType: false,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            }
        },
        processDefinitionImage: function(id,callback) {
            var json = {
                "title": "", //相册标题
                "id": 123, //相册id
                "start": 0, //初始显示的图片序号，默认0
                "data": [   //相册包含的图片，数组格式
                    {
                        "alt": "流程图",
                        "pid": 666, //图片id
                        "src": "/workflow/processDefinitionImage?processDefinitionId="+id, //原图地址
                        "thumb": "" //缩略图地址
                    }
                ]
            };
            layer.photos({
                photos: json
                ,anim: 5 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
            });
        },

        exportDefinition: function (id,callback) {
            view.openNew("/workflow/exportDefinition?processDefinitionId="+id);
        },

        delDefinition:function (id,callback) {
            var syncServer = function (id,callback) {
                $.ajax({
                    url:"/workflow/delete",
                    type:"POST",
                    cache:false,
                    data:{"id":id},
                    success:function(result){
                        callback(result,true);
                    },
                    error: function (xmlHttpReq, error, ex) {

                    }

                });
            };
            syncServer(id,function (res) {
                callback(res);
            });
        },

        optProcessinstance:function (id,state,callback) {
            var title = "";
            if(state==="suspend"){
                title = "挂起流程实例";
            }else if(state==="active"){
                title = "激活流程实例";
            }else if(state==="delete"){
                title = "删除流程实例";
            }
            var html = '<form class="layui-form">' +
                        '   <div class="layui-form-item">\n' +
                        '   <label class="layui-form-label">原因:</label>\n' +
                        '    <div class="layui-input-inline">\n' +
                        '      <textarea class="layui-input" style="width: 250px;height: 90px"></textarea>\n' +
                        '    </div>\n' +
                        '   </div>'+
                        '   <div class="layui-form-item">\n' +
                        '    <div class="layui-input-block">\n' +
                        '      <button class="layui-btn" lay-submit lay-filter="ok" style="width: 150px;">确认</button>\n' +
                        '    </div>\n' +
                        '   </div>'+
                        '</form>';

            var index_ = layer.open({
                type: 1,
                title: title,
                content: html,
                area:['400px','205px'],
                btn: false,
                success: function(index, layero){
                    layui.form.render();
                    layui.form.on('submit(ok)',function (data) {
                        console.log(data);
                        syncServer(data.field,function (res) {
                            layui.layer.close(index_);
                            callback(res);
                        });
                        return false;
                    });
                }
            });
            var syncServer = function (data, callback) {
                $.ajax({
                    url: "/workflow/processinstance/update/"+state+"/"+id,
                    type:"post",
                    data:data,
                    cache: false,
                    processData: false,
                    contentType: false,
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            }
        }
    };

    /**
     * 对外暴露的方法
     */
    exports("m_processDefinition", {

        /**
         * 导入并部署流程
         * @param callback
         */
        importDefinition: function (callback) {
            ProcessDefinitionObj.importDefinition(callback);
        },
        /**
         * 查看流程图
         * @param data
         * @param callback
         */
        processDefinitionImage: function (data,callback) {
            ProcessDefinitionObj.processDefinitionImage(data,callback);
        },

        /**
         * 导出流程实例
         */
        exportDefinition:function (id,callback) {
            ProcessDefinitionObj.exportDefinition(id,callback);
        },

        /**
         * 删除流程定义
         */
        delDefinition:function (id,callback) {
            ProcessDefinitionObj.delDefinition(id,callback);
        },

        /**
         * 挂起、激活、删除流程
         * @param id
         * @param state: suspend active delete
         * @param callback
         */
        optProcessinstance:function (id,state,callback) {
            ProcessDefinitionObj.optProcessinstance(id,state,callback);
        }


    });

});

