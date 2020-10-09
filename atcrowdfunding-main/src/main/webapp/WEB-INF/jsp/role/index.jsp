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
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
<form class="form-inline" role="form" style="float:left;">
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <input id="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
    </div>
  </div>
  <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button id="toAddBtn" type="button" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
                <tr >
                  <th width="30">#</th>
				  <th width="30"><input type="checkbox"></th>
                  <th>名称</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
                
              </tbody>
			  <tfoot>
			     <tr >
				     <td colspan="6" align="center">
						<ul class="pagination">
							
						</ul>
					 </td>
				 </tr>

			  </tfoot>
            </table>
          </div>
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
	        <h4 class="modal-title" id="myModalLabel">添加职位</h4>
	      </div>
	      <div class="modal-body">
	        <div class="form-group">
				<label for="exampleInputPassword1">添加职位名称</label>
				<input type="text" class="form-control" id="name" name="name" placeholder="请输入添加职位名称">
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
	        <h4 class="modal-title" id="myModalLabel">修改职位</h4>
	      </div>
	      <div class="modal-body">
	        <div class="form-group">
				<label for="exampleInputPassword1">修改职位名称</label>
				<input type="hidden" name="id">
				<input type="text" class="form-control" id="name" name="name" placeholder="请输入修改职位名称">
			 </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button id="doUpdateBtn" type="button" class="btn btn-primary">修改</button>
	      </div>
	    </div>
	  </div>
	</div>

	 <!-- 修改权限模态框 -->
	<div class="modal fade" id="permissionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">修改角色权限</h4>
	      </div>
	      <div class="modal-body">
	        <ul id="treeDemo" class="ztree"></ul>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button id="permissionBtn" type="button" class="btn btn-primary">修改</button>
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
            
            	initData(1);
            });
            
           	var json = {
           		pageNum:1,
           		pageSize:2
           	};
           	
           	// =====分页查询 开始=================================================
            function initData(pageNum){
            	
            	// 1.发起Ajax请求
            	
            	// 改变页码
            	json.pageNum = pageNum;
            	
            	var index = -1;
            	
            	$.ajax({
            		type:'post',
            		url:"${PATH}/role/loadData",
            		data:json,
            		beforeSend:function(){
            			index = layer.load(0,{time:10*1000});
            			return true ;
            		},
            		success:function(result){
            			
            			console.log(result);
            			layer.close(index);
            			
            			initDatas(result);
            			
            			initNavg(result);
            		}
            	});
           	}
            	// 2.展示数据
            	function initDatas(result) {
            		
            		// 每次发起局部请求前，先清空<tbody>标签里的内容，不然会重复显示
            		$('tbody').empty();
            		
            		var list = result.list;
            		
            		// 第一种迭代方式
            	/* 
            		var content = '';
            		$.each(list,function(i,e){
            			content +='<tr>';
            			content +='  <td>'+(i+1)+'</td>';
            			content +='  <td><input type="checkbox"></td>';
            			content +='  <td>'+e.name+'</td>';
            			content +='  <td>';
            			content +='	  <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            			content +='	  <button type="button" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            			content +='	  <button type="button" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            			content +='  </td>';
            			content +='</tr>';
            		});
            		
            		$("tbody").html(content); 
            	*/
            		
            		// 第二种迭代方式
            		$.each(list,function(i,e){
            			
            			// 把dom对象转换成jq对象
            			var tr = $('<tr></tr>');
            			tr.append('<td>'+(i+1)+'</td>');
            			tr.append('<td><input type="checkbox"></td>');
            			tr.append('<td>'+e.name+'</td>');
            			
            			var td = $('<td></td>');
            			td.append('<button type="button" roleId="'+e.id+'" class="permissionClass btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>');
            			td.append('<button type="button" roleId="'+e.id+'" class="updateClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>');
            			td.append('<button type="button" roleId="'+e.id+'" class="deleteClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>');
            			
            			tr.append(td);
            			
            			tr.appendTo($("tbody"));
            		});
            	}
            	
            	// 3.展示分页条
            	function initNavg(result) {
            		
            		// 每次发起局部请求前，先清空<ul>标签里的内容，不然会重复显示
            		$('.pagination').empty();
            		
            		var navigatepageNums =result.navigatepageNums;
            		
            		// 向class=pagination的标签里添加
					if(result.isFirstPage) {
						$('.pagination').append($('<li class="disabled"><a href="#">上一页</a></li>'));
					} else {
						$('.pagination').append($('<li class="disabled"><a onclick="initData('+(result.pageNum-1)+')">上一页</a></li>'));
					}
					
					$.each(navigatepageNums,function(i,num){
						if(num == result.pageNum) {
							$('.pagination').append($('<li class="active"><a href="#">'+num+'<span class="sr-only">(current)</span></a></li>'));
						} else {
							$('.pagination').append($('<li><a onclick="initData('+num+')">'+num+'</a></li>'));
						}
					});
					
					if(result.isLastPage) {
						$('.pagination').append($('<li class="disabled"><a href="#">下一页</a></li>'));
					} else {
						$('.pagination').append($('<li class="disabled"><a onclick="initData('+(result.pageNum+1)+')">下一页</a></li>'));
					}
            	}
            	
            // =====分页查询 结束=================================================
            	
            	
           	$("#queryBtn").click(function(){
        		var condition = $("#condition").val();
        		
        		json.condition = condition;
        		
        		initData(1);
        	});
            
         	// =====模糊查询 结束=================================================
         	// =====添加 开始=================================================
         		
         		$("#toAddBtn").click(function(){
         			$("#addModal").modal({
         				show:true,
         				backdrop:'static',
         				keybroad:false
         			});
         		});
         	
         		$("#doAddBtn").click(function(){
         			var name = $("#addModal input[name='name']").val();
         			
         			$.ajax({
         				type:"post",
         				url:"${PATH}/role/doAdd",
         				data:{
         					addName:name
         				},
         				before:function(){
         					
         					return true;
         				},
         				success:function(result){
         					if("ok" == result) {
         						layer.msg("添加成功",{time:2000},function(){
         							$("#addModal").modal('hide');
         							name = $("#addModal input[name='name']").val("");
         							initData(1);
         						});
         					} else {
         						layer.msg("添加失败");
         					}
         				}
         			});
         		});
         		
         	// =====添加 结束=================================================
         	// =====修改 开始=================================================
         		
         		// 表单回显
         		$('tbody').on('click','.updateClass',function(){
         			var roleId = $(this).attr("roleId");
         			
         			$.get("${PATH}/role/getRoleById",{id:roleId},function(result){
         				$("#updateModal").modal({
         					show:true,
             				backdrop:'static',
             				keybroad:false
         				});
         				$("#updateModal input[name='name']").val(result.name);
         				$("#updateModal input[name='id']").val(result.id);
         			});
         			
         		});
         	
         		// 修改操作
         		$("#doUpdateBtn").click(function(){
         			var roleId = $("#updateModal input[name='id']").val();
         			var roleName = $("#updateModal input[name='name']").val();
         			
         			$.post("${PATH}/role/doUpdate",{id:roleId,name:roleName},function(result){
         				if("ok" == result) {
         					layer.msg("修改成功",{time:2000},function(){
         						$("#updateModal").modal('hide');
         						initData(json.pageNum);
         					});
         				} else {
         					layer.msg("修改失败");
         				}
         			});
         		});
         		
         	// =====修改 结束=================================================
         	// =====删除 开始=================================================
         		
         		// 选择器用单引号
         		$('tbody').on('click','.deleteClass',function(){
         			var roleId = $(this).attr("roleId");
         			
         			layer.confirm("是否删除该条数据？",{btn:['确定','取消']},function(index){
         				$.ajax({
         					type:"get",
         					url:"${PATH}/role/delete",
         					data:{id:roleId},
         					beforeSend:function(){
         						return true;
         					},
         					success:function(result){
         						if("ok" == result) {
         							layer.msg("删除成功！",{time:1000});
         						} else {
         							layer.msg("删除失败！",{time:1000});
         						}
         						// 刷新页面
         						initData(json.pageNum);
         					}
         				});
         				layer.close(index);
         			},function(index){
         				layer.close(index);
         			});
         		});
         		
         	// =====删除 结束=================================================
         		
         	// =====权限添加 开始=================================================
         	
         	var roleId = '';	
         	
         	$('tbody').on('click','.permissionClass',function(){
       			
       			// 点击按钮显示模态框
  				$("#permissionModal").modal({
  					show:true,
      				backdrop:'static',
      				keybroad:false
  				});
  				
  				roleId = $(this).attr("roleId");
  				
  				console.log("1:"+ roleId);
  				
       			// 初始化树	
       			initTree();
       			
       		});	
         	
         	
         	
         	function initTree() {
         		
         		console.log("2:"+ roleId);
         		
           		var setting = {
           				check: { // 在节点前添加复选框
        					enable: true
        				},
           				data: {
        					simpleData: {
        						enable: true,
        						pIdKey: "pid"
        					},
        					key: {
        						url: "xUrl",
        						name:"title"
        					}
        				},
        				view: {
        					addDiyDom: function(treeId, treeNode) { // 在每个节点前加一个图标标签
                    			$("#"+treeNode.tId+"_ico").removeClass();//.addClass();
            					$("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>")
                    		}
        				}
           		}
           		
           		// 1.加载数据
            	$.get("${PATH}/permission/getAllPermission",{},function(result){
            		
            		var zNodes = result;
            		
            		// 在treeDome容器中生成树
            		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
            		
            		// 展开 / 折叠 全部节点
       				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
       				treeObj.expandAll(true);
       				
       				// 2.回显已分配许可
       				$.get("${PATH}/role/listPermissionIdByRoleId",{roleId:roleId},function(result){
       					// 遍历结果集，在已选择的节点的复选框打勾
       					$.each(result,function(i,e){
       						var permissionId = e;
       						var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
       						var node = treeObj.getNodeByParam("id", permissionId, null);
       						treeObj.checkNode(node, true, false , false);
       					});
       				});
       				
            	});
            }
         		
         	
       		$("#permissionBtn").click(function(){
       			
       			console.log("3:"+ roleId);
       			
       			var json = {
    				roleId:roleId
    			};
       			
       			// 获得已选中的节点
       			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        		var nodes = treeObj.getCheckedNodes(true);
        		
        		$.each(nodes,function(i,e){
					var permissionId = e.id;
					// 拼接id数组
					json['ids['+i+']'] = permissionId;
        		});
       		
       			// 发送修改请求
	       		$.ajax({
	       			type: "post",
	       			url: "${PATH}/role/doAssignPermissionToRole",
	       			data: json,
	       			success: function(result) {
	       				if("ok"==result){
	    					layer.msg("分配成功",{time:1000},function(){
	    						$("#assignModal").modal('hide');
	    					});
	    				}else{
	    					layer.msg("分配失败");
	    				}
	       			}
	       		});
       		});
         		
         	// =====权限添加 结束=================================================
           	
            
           
        </script>
  </body>
</html>
