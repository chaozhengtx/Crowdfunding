<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
              <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 许可权限管理 <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
			  <div class="panel-body">
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
	        <h4 class="modal-title" id="myModalLabel">添加权限</h4>
	      </div>
	      <div class="modal-body">
	        <div class="form-group">
				<label for="name">添加权限名称</label>
				<input type="hidden" name="pid">
				<input type="text" class="form-control" id="title" name="title" placeholder="请输入添加菜单名称">
			 </div>
	        <div class="form-group">
				<label for="icon">添加权限图标</label>
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
	
	
    <%@ include file="/WEB-INF/jsp/common/js.jsp" %>
        <script type="text/javascript">
            $(function () {
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});
				initTree();
            });
            
            function initTree() {
           		var setting = {
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
            					} else { //分支节点
            						s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="addBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
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
           		}
            	$.get("${PATH}/permission/getAllPermission",{},function(result){
            		
            		var zNodes = result;
            		
            		// 在treeDome容器中生成树
            		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
            		
            		// 展开 / 折叠 全部节点
       				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
       				treeObj.expandAll(true);
            	});
            }
            
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
            	var title = $("#addModal input[name='title']").val();
            	var icon = $("#addModal input[name='icon']").val();
            	
            	$.ajax({
            		type: "post",
            		url: "${PATH}/permission/toAdd",
            		data: {
            			pid: pid,
            			title: title,
            			icon: icon
            		},
            		success: function(result) {
            			
            			if("ok" == result) {
            				
            				layer.msg("添加成功",{time:1000,icon:"6"},function(){
            				$("#addModal").modal('hide');
            				$("#addModal input[name='tilte']").val("");
            				$("#addModal input[name='icon']").val("");
            				initTree();
            				
            			});
            			} else {
            				layer.msg("添加失败");
            			}
            				
            			
            		}
            	});
            });
            
            
        </script>
  </body>
</html>
