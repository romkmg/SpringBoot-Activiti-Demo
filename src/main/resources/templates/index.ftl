<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>Demo</title>
    <#include "resource.ftl">
    <style>
        .layui-tab-title .layui-this:after{
            border-radius: 0px;
        }
    </style>
</head>
<body class="layui-layout-body">

<div class="layui-layout layui-layout-admin">
<#include "top_menus.ftl">
    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree"  lay-filter="test">
                <li class="layui-nav-item layui-nav-itemed">
                    <a class="" href="javascript:;">任务管理</a>
                    <dl class="layui-nav-child">
                        <dd id="list-task" data-uri="/taskList"><a href="javascript:;">任务列表</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">流程管理</a>
                    <dl class="layui-nav-child">
                        <dd id="list-process" data-uri="/processDefinitionList"><a href="javascript:;">流程列表</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">用户管理</a>
                    <dl class="layui-nav-child">
                        <dd id="list-user" data-uri="/management/user/listUser"><a href="javascript:;">用户列表</a></dd>
                        <dd id="list-role" data-uri="/management/role/listRole"><a href="javascript:;">角色列表</a></dd>
                        <dd id="list-privilege" data-uri="/management/privilege/listPrivilege"><a href="javascript:;">权限列表</a></dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div class="layui-tab" lay-filter="tabBody" lay-allowclose="true" style="margin-top: 0;">
            <ul class="layui-tab-title">
            </ul>
            <div class="layui-tab-content layui-col-md-12" lay-filter="tabTable">
            </div>
        </div>

    </div>

    <div class="layui-footer" style="text-align: center">
        <!-- 底部固定区域 -->
        <span>CopyRight</span>
    </div>
</div>
</body>
<script>
    layui.use(['element','m_utils'], function(){
        var $ = layui.jquery
                ,element = layui.element //Tab的切换功能，切换事件监听等，需要依赖element模块
                ,utils = layui.m_utils;

        $('dd').on('click',function () {
            var othis = $(this);
            var id = othis.attr("id"); //左侧导航栏id
            var uri = othis.data("uri"); //新标签页URI
            var title = othis.text(); //新标签页标题

            element.tabDelete('tabBody', id);//删除旧的已存在Tap
            utils.addNewTab(id,uri,title,'tabBody');//新建新标签页
        });

    });
</script>
</html>