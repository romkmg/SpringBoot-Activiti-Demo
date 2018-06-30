/**
 * 定义渲染组件
 */

layui.define(function (exports) {

    var uploadObj = {

        getExistFilesById: function (projectId, callback) {
            $.ajax({
                url: "/attachment/files",
                type: "GET",
                data: {id: projectId},
                success: function (data) {
                    if (typeof callback == "function") {
                        callback(data);
                    }

                }
            })
        },
        deleteFilesById: function (originId, fileIds, callback) {
            $.ajax({
                url: "/attachment/delete",
                dataType: "json",
                type: "POST",
                data: {id: originId, fileIds: fileIds},
                success: function (data) {
                    if (typeof callback == "function") {
                        callback(data);
                    }
                }
            })
        }
    }

    var Render = {
        settings: {
            enableUpload: true
        },
        draw: function (upload, origin, body) {
            var chooseBtn = $('<button type="button" class="layui-btn layui-btn-normal" id="choosefileListBtn">选择多文件</button>');
            var tableTile = $('<thead>\n' +
                '        <tr><th>文件名</th>\n' +
                '        <th>大小</th>\n' +
                '        <th>状态</th>\n' +
                '        <th>操作</th>\n' +
                '      </tr></thead>');
            var tableBody = $('<tbody id="fileList"></tbody>');
            var table = $('<table class="layui-table">\n' +

                '    </table>');
            table.append(tableTile).append(tableBody);

            var container = $(
                '  <div class="layui-upload-list">\n' +

                '  </div>');

            container.append(table);

            var uploadBtn = $('<button type="button" class="layui-btn" id="fileListAction">开始上传</button>');

            var uploadFrom = $('<div class="layui-upload">\n' +

                '</div>');

            if (Render.settings.enableUpload) {
                uploadFrom.append(chooseBtn);
                uploadFrom.append(container);
                uploadFrom.append(uploadBtn);
            } else {
                uploadFrom.append(container);
            }


            body.html(uploadFrom);


            // uploadBtn.off('click').on('click',function () {
            //     alert('tedst');
            // });


            //多文件列表示例
            var uploadListIns = upload.render({
                elem: chooseBtn
                , url: '/attachment/upload'
                , accept: 'file'
                , multiple: true
                , auto: false
                , data: {projectId: origin.id}
                , bindAction: uploadBtn
                , before: function (obj) { //obj参数包含的信息，跟 choose回调完全一致，可参见上文。
                    // layer.load(); //上传loading
                }

                , choose: function (obj) {
                    var files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列

                    var reupload = '';
                    var drop = '';
                    if (Render.settings.enableUpload) {
                        reupload = '<button class="layui-btn layui-btn-mini file-reload layui-hide">重传</button>';
                        drop = '<button class="layui-btn layui-btn-mini layui-btn-danger file-delete">删除</button>';
                    }

                    //读取本地文件
                    obj.preview(function (index, file, result) {
                        //选择的文件名
                        var fileName = file.name;

                        //验证所选文件名是否与附件列表中的附件名相同，如果相同，则不能上传
                        var hasSelected = false;
                        $(".uploadFileName").each(function () {
                            if($(this).text() ==fileName ){
                                hasSelected = true;
                            }
                        });

                        if(hasSelected ){
                            alert("附件列表中已经存在名为 '"+fileName+"' 的文件");
                            return;
                        }

                        var tr = $(['<tr id="upload-' + index + '">'
                            , '<td class="uploadFileName">' + fileName + '</td>'
                            , '<td>' + (file.size / 1014).toFixed(1) + 'kb</td>'
                            , '<td>等待上传</td>'
                            , '<td>'
                            , reupload
                            , drop
                            , '</td>'
                            , '</tr>'].join(''));

                        //单个重传
                        tr.find('.file-reload').on('click', function () {
                            obj.upload(index, file);
                        });

                        //删除
                        tr.find('.file-delete').on('click', function () {
                            delete files[index]; //删除对应的文件
                            tr.remove();
                            uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                        });


                        tableBody.append(tr);


                    });
                }
                , done: function (res, index, upload) {
                    // layer.closeAll('loading'); //关闭loading
                    if (res.code == 200) { //上传成功

                        var tr = tableBody.find('tr#upload-' + index)
                            , tds = tr.children();
                        tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');

                        tds.eq(3).html(''); //清空操作
                        return delete this.files[index]; //删除文件队列已经上传成功的文件
                    }
                    this.error(index, upload);
                }
                , error: function (index, upload) {
                    // layer.closeAll('loading'); //关闭loading

                    var tr = tableBody.find('tr#upload-' + index)
                        , tds = tr.children();
                    tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
                    tds.eq(3).find('.file-reload').removeClass('layui-hide'); //显示重传
                }
            });


            uploadObj.getExistFilesById(origin.id, function (files) {
                if (!files) {

                    return;
                }


                for (var index = 0; index < files.length; index++) {

                    var file = files[index];

                    var drop = function (index) {
                        if (Render.settings.enableUpload) {
                            return '<button id="' + index + '" class="layui-btn layui-btn-mini layui-btn-danger file-delete">删除</button>';
                        }

                        return "";
                    }

                    var tr = $(['<tr id="upload-' + index + '">'
                        , '<td class="uploadFileName">' + file.name + '</td>'
                        , '<td>' + (file.size / 1014).toFixed(1) + 'kb</td>'
                        , '<td><span style="color: #5FB878;">上传成功</span></td>'
                        , '<td>'
                        , drop(index)
                        , '</td>'
                        , '</tr>'].join(''));

                    //删除

                    tr.find('.file-delete').on('click', file, function (event) {

                        var fileIds = [];
                        fileIds.push(event.data.name);

                        for (var i = 0; i < files.length; i++) {
                            var file = files[i];
                            if (file && file.name == event.data.name) {
                                delete file; //删除对应的文件
                                tableBody.find('tr[id^="upload-' + i + '"]').remove();
                                uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                                break
                            }
                        }

                        uploadObj.deleteFilesById(origin.id, JSON.stringify(fileIds), function (deletedFiles) {
                            if (!files) {

                                return;
                            }

                        });


                    });


                    tableBody.append(tr);

                }
            });

        }

    }

    exports("m_uploader", {
        setting: function (params) {
            Render.settings = $.extend(true, {}, Render.settings, params);
        },
        init: function (targetId) {
            Render.replace(targetId);
        },
        render: function (upload, origin, body) {
            Render.draw(upload, origin, body);
        }

    })


})