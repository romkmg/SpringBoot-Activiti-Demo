/**
 * 工具模块
 */
layui.define(function (exports) {
    layui.use(["layer","element"], function () {

    });

    var UtilsObj = {
        addNewTab: function(id,uri,title,filter) {
            console.log(id+""+uri+""+title+""+filter);
            //服务端获取页面
            var syncServer = function (url, callback) {
                var index = layui.layer.load(2);
                $.ajax({
                    url: url,
                    type:"GET",
                    success: function (res) {
                        layui.layer.close(index);
                        callback(res,true);
                    },
                    error: function (xmlHttpReq, error, ex) {
                        layui.layer.close(index);
                    }
                })
            }

            syncServer(uri, function (data, status) {
                if(status){
                    layui.element.tabAdd(filter, {//添加新Tap
                        title: title
                        ,content: data
                        ,id: id
                    });
                    layui.element.tabChange(filter, id); //选中新Tap
                }else{
                    layui.layer.msg('获取数据失败！', {icon: 5});
                }
            })
        }

        ,openModal: function (data,callback) {
            var layer = layui.layer;
            var synServer = function (data,callback) {
                $.ajax({
                    url: data.queryUrl,
                    type: "GET",
                    cache:false,
                    data: {id: data.queryId},
                    success: function (res) {
                        var isJson = UtilsObj.isJsonString(res);
                        if(isJson){
                            var result = JSON.parse(res);
                            console.log(result);
                            if(result.status===false){
                                layer.msg(result.msg);
                            }
                        }else{
                            layer.open({
                                type: 1,
                                title: data.title,
                                area: data.area,
                                content: res,
                                scrollbar: true,
                                closeBtn: data.closeBtn,
                                shadeClose: data.shadeClose,
                                success: function (layerDom,index) {
                                    callback(layerDom, index);
                                },
                                end: function () {
                                    callback();
                                }
                            });
                        }
                    },
                    error: function (xmlHttpReq, error, ex) {
                    }
                });
            };
            synServer(data,function (layerDom,index) {
                callback(layerDom, index);
            })
        },

        isJsonString: function(str) {
            try {
                if (typeof JSON.parse(str) == "object") {
                    return true;
                }
            } catch(e) {
            }
            return false;
    }
};
    /**
     * 对外暴露的方法
     */
    exports("m_utils", {
        /**
         * 打开弹出层
         * @param data
         * @param callback
         */
        openModal: function (data,callback) {
            console.log(data);
            UtilsObj.openModal(data,callback);
        }

        /**
         * 新建标签页
         * @param id
         * @param uri 标签页uri
         * @param title 导航栏标题
         * @param filter
         */
        ,addNewTab: function (id,uri,title,filter) {
            UtilsObj.addNewTab(id,uri,title,filter);
        }

    });

});

