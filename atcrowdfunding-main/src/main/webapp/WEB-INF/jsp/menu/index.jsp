<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" autoFlush="false" buffer="100kb"%>
<!DOCTYPE html>
<html lang="zh_CN">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<%@ include file="/WEB-INF/jsp/common/css.jsp" %>
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
	</style>
  </head>

  <body>

    <jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i>菜单列表</h3>
			  </div>
			  <div class="panel-body">
			  	<!-- 放菜单树的容器 -->
				<ul id="treeDemo" class="ztree"></ul>
			  </div>
			</div>
        </div>
      </div>
    </div>
    
    <!-- 添加模态框 -->
	<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加菜单</h4>
	      </div>
	      <div class="modal-body">
	        <div class="form-group">
				<label for="name">添加菜单名称</label>
				<input type="hidden" name="pid">
				<input type="text" class="form-control" id="name" name="name" placeholder="请输入添加菜单名称">
			 </div>
	        <div class="form-group">
				<label for="url">添加菜单URL</label>
				<input type="text" class="form-control" id="url" name="url" placeholder="请输入添加URL">
			 </div>
	        <div class="form-group">
				<label for="icon">添加菜单图标</label>
				<input type="text" class="form-control" id="icon" name="icon" placeholder="请输入添加菜单图标">
			 </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button id="doAddBtn" type="button" class="btn btn-primary">添加</button>
	      </div>
	    </div>
	  </div>
	</div>
    <!-- 修改模态框 -->
	<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">修改菜单</h4>
	      </div>
	      <div class="modal-body">
	        <div class="form-group">
				<label for="name">修改菜单名称</label>
				<input type="hidden" name="id">
				<input type="text" class="form-control" id="name" name="name" placeholder="请输入添加菜单名称">
			 </div>
	        <div class="form-group">
				<label for="url">修改菜单URL</label>
				<input type="text" class="form-control" id="url" name="url" placeholder="请输入添加URL">
			 </div>
	        <div class="form-group">
				<label for="icon">修改菜单图标</label>
				<input type="text" class="form-control" id="icon" name="icon" placeholder="请输入添加菜单图标">
			 </div>
	      </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button id="doUpdateBtn" type="button" class="btn btn-primary">修改</button>
	      </div>
	    </div>
	  </div>
	</div>

  <%@ include file="/WEB-INF/jsp/common/js.jsp" %>
      <script type="text/javascript">
        $(function () {// 文档就绪函数
		    $(".list-group-item").click(function() {
			    if ( $(this).find("ul") ) {
					$(this).toggleClass("tree-closed");
					if ( $(this).hasClass("tree-closed") ) {
						$("ul", this).hide("fast");
					} else {
						$("ul", this).show("fast");
					}
				}
			 });
        
        	initTMenuTree();
         });
            
         function initTMenuTree() {
        	 var url = "${PATH}/menu/getAllMenu";
        	 $.get(url,{},function(result){
        		 
        		var setting = {
        			data: {
   						// 开启简单json数据模式
   						simpleData: {
   							enable: true,
   							pIdKey:"pid"
   						}
        			},
        			view: {// 增加按钮组
        				addDiyDom: function(treeId, treeNode) { // 在每个节点前加一个图标标签
                			$("#"+treeNode.tId+"_ico").removeClass();//.addClass();
        					$("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>")
                		},
        				addHoverDom: function(treeId, treeNode) { //treeNode节点 -> TMenu对象设置鼠标移到节点上，在后面显示一个按钮
                			
                			var aObj = $("#" + treeNode.tId + "_a");
        					aObj.attr("href", "javascript:;");
        					aObj.attr("target", "");
        					if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
        					
        					// 拼接按钮
        					var s = '<span id="btnGroup'+treeNode.tId+'">';
        					
        					// 根据节点级别判断是根节点、分支节点、叶子节点，并赋予相关功能按钮，给按钮绑定点击事件
        					if ( treeNode.level == 0 ) { //根节点
        						s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="addBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        					} else if ( treeNode.level == 1 ) { //分支节点
        						s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="updateBtn('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
        						if (treeNode.children.length == 0) {
        							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="deleteBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        						}
        						s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="addBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        					} else if ( treeNode.level == 2 ) { //叶子节点
        						s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="updateBtn('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
        						s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="deleteBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        					}
        	
        					s += '</span>';
        					aObj.after(s);
                		},
        				removeHoverDom: function(treeId, treeNode) {
                			$("#btnGroup"+treeNode.tId).remove();
                		}
        			}
        		};
        		
        		
   				var zNodes = result;
   				
   				zNodes.push({id:"0",name:"菜单列表",icon:"glyphicon glyphicon-list"});
				
   				// 生成菜单树
   				$.fn.zTree.init($("#treeDemo"), setting, zNodes);
   				
   				// 展开 / 折叠 全部节点
   				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
   				treeObj.expandAll(true);
        		 
        	 });
         }
         
         // =========== 添加 开始 ==========================================================
        	 
       	 function addBtn(id) {
        	 $("#addModal").modal({
        		 show:true,
        		 backdrop:'static',
        		 keyboard:false
        	 });
        	 // 把添加行的pid赋值为当前行的id
        	 $("#addModal input[name='pid']").val(id);
         }
         $("#doAddBtn").click(function(){
        	 var pid = $("#addModal input[name='pid']").val();
        	 var name = $("#addModal input[name='name']").val();
        	 var url = $("#addModal input[name='url']").val();
        	 var icon = $("#addModal input[name='icon']").val();
        	 
        	 $.ajax({
        		 type:"post",
        		 url:"${PATH}/menu/addMenu",
        		 data:{
        			 pid:pid,
        			 name:name,
        			 url:url,
        			 icon:icon
        		 },
        		 beforeSend:function() {
        			 return true;
        		 },
        		 success:function(result) {
        			 if("ok" == result) {
        				 layer.msg("添加成功！",{time:1000},function(){
        					 $("#addModal").modal('hide');
        					 $("#addModal input[name='pid']").val("");
     						 $("#addModal input[name='name']").val("");
     						 $("#addModal input[name='url']").val("");
     						 $("#addModal input[name='icon']").val("");
        					 initTMenuTree();
        				 });
        			 } else {
        				 layer.msg("添加失败！");
        			 }
        		 }
        	 });
        	 
         });
        	 
         // =========== 添加 结束 ==========================================================
        	 
         // =========== 修改 开始 ==========================================================
        	 
         function updateBtn(id) {
        	 
        	 $("#updateModal").modal({
        		 show:true,
        		 backdrop:'static',
        		 keyboard:false
        	 });
        	 
        	 // 数据回显
        	 $.get("${PATH}/menu/getMenuById",{id:id},function(result){
        		 $("#updateModal input[name='id']").val(result.id);
        		 $("#updateModal input[name='name']").val(result.name);
        		 $("#updateModal input[name='url']").val(result.url);
        		 $("#updateModal input[name='icon']").val(result.icon);
        	 });
         }
         
         $("#doUpdateBtn").click(function(){
        	 
        	 var id = $("#updateModal input[name='id']").val();
         	 var name = $("#updateModal input[name='name']").val();
         	 var url = $("#updateModal input[name='url']").val();
         	 var icon = $("#updateModal input[name='icon']").val();
        	 
        	 $.ajax({
        		 type:"post",
        		 url:"${PATH}/menu/doUpdate",
        		 data:{
        			 id:id,
        			 name:name,
        			 url:url,
        			 icon:icon
        		 },
        		 beforeSend:function() {
        			 return true;
        		 },
        		 success:function(result) {
        			 if("ok" == result) {
        				 layer.msg("修改成功",{time:1000},function(){
        					 $("#updateModal").modal('hide');
        					 initTMenuTree();
        				 });
        			 } else {
        				 layer.msg("修改失败");
        			 }
        		 }
        	 });
         });
        	 
         // =========== 修改 结束 ==========================================================
        	 
         // =========== 删除 开始 ==========================================================
        	 
         function deleteBtn(id) {
        	 layer.confirm("确定删除么？",{btn:['确定','取消']},function(index){
        		 $.post("${PATH}/menu/delete",{id:id},function(result){
        			 if("ok" == result) {
        				 layer.msg("删除成功",{time:1000},function(){
        					 layer.close(index);
        					 initTMenuTree();
        				 });
        			 } else {
        				 layer.msg("删除失败");
        				 layer.close(index);
        			 }
        		 });
        		 
        	 },function(index){
        		 layer.close(index);
        	 });
         }
        	 
         // =========== 删除 结束 ==========================================================
            
           
        </script>
  </body>
</html>
