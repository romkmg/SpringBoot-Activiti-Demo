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
                    $("#btn").click(function () {
                        $("#file").click();
                    });
                }
            });

            var syncServer = function (form, callback) {
                var index = layui.layer.load(2);
                var formData = new FormData();
                formData.append("file",form[0].files[0]);
                $.ajax({
                    url: "/importDefinition",
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
                        "src": "/processDefinitionImage?processDefinitionId="+id, //原图地址
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
            view.openNew("/exportDefinition?processDefinitionId="+id);
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
         * 导出流程
         */
        exportDefinition:function (id,callback) {
            ProcessDefinitionObj.exportDefinition(id,callback);
        }

    });

});

