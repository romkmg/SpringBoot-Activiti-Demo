<#include "resource.ftl">
<script>
layui.use('layer', function(){
  var layer = layui.layer;
  layer.msg('抱歉，你没有相关权限！', {icon: 5});
  setInterval("view.goto('/index')","2000");
});  
</script>