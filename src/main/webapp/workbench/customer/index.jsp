<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>


	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

	<script type="text/javascript">

	$(function(){

		//页面加载完毕后触发一个方法
		//默认展开列表的第一页，每页展现两条记录
		pageList(1, 2);

		//alert("123");

		//为全选的复选框绑定事件，触发全选操作
		$("#qx").click(function () {

			$("input[name=xz]").prop("checked", this.checked);

		})

		$("#customerBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);

		})

        //为查询按钮绑定事件，触发pageList方法
        $("#searchBtn").click(function () {

            /*
                点击查询按钮的时候，我们应该将搜索框中的信息保存起来,保存到隐藏域中
             */
            $("#hidden-name").val($.trim($("#search-name").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-phone").val($.trim($("#search-phone").val()));
            $("#hidden-website").val($.trim($("#search-website").val()));


            pageList(1, 2);

        })

		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			$(".time").datetimepicker({
				minView: "month",
				language: 'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});

			alert("打开客户添加页面");

			//走后台，目的是为了取得线索列表，为所有者下拉框铺值
			$.ajax({

				url: "workbench/customer/getUserList.do",
				type: "get",
				dataType: "json",
				success: function (data) {

					/*

                        data
                            [{客户1},{2},{3}]

                     */



					var html = "<option></option>";

					$.each(data, function (i, n) {

						html += "<option value='" + n.id + "'>" + n.name + "</option>";

					})

					$("#create-owner").html(html);

					var id = "${user.id}";

					$("#create-owner").val(id);

					//处理完所有者下拉框数据后，打开模态窗口
					$("#createCustomerModal").modal("show");

				}

			})

		})

		//为保存按钮绑定事件，执行线索添加操作
		$("#saveBtn").click(function () {

			$.ajax({

				url: "workbench/customer/save.do",
				data: {
					"owner": $.trim($("#create-owner").val()),
					"name": $.trim($("#create-name").val()),
					"website": $.trim($("#create-website").val()),
					"phone": $.trim($("#create-phone").val()),
					"description": $.trim($("#create-description").val()),
					"contactSummary": $.trim($("#create-contactSummary").val()),
					"nextContactTime": $.trim($("#create-nextContactTime").val()),
					"address": $.trim($("#create-address").val())


				},
				type: "post",
				dataType: "json",
				success: function (data) {

					/*

                        data
                            {"success":true/false}

                     */

					if (data.success) {

						//刷新列表
						pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

						$("#customerAddForm")[0].reset();

						//alert("123");

						//关闭添加操作的模态窗口
						$("#createCustomerModal").modal("hide");

					} else {

						alert("添加客户失败");

					}

				}

			})

		})

		//为修改按钮绑定事件，执行线索修改操作
		$("#editBtn").click(function () {


			var $xz = $("input[name=xz]:checked");

			if ($xz.length == 0) {

				alert($xz.length+"请选择需要修改的记录");

			} else if ($xz.length > 1) {

				alert($xz.length+"只能选择一条记录进行修改");

			} else {

				alert($xz.length+"一条记录进行修改");

				var id = $xz.val();

				//alert(id);

				$.ajax({
					url: "workbench/customer/getUserListAndCustomer.do",

					data: {
						"id": id
					},
					type: "get",
					dataType: "json",
					success: function (data) {

						/*
                            data
                                用户列表
                                客户对象
                                {”uList":{用户1},{2},{3},"c":{客户对象}}
                        */
						var html = "<option></option>";

						$.each(data.uList, function (i, n) {
							html += "<option value='" + n.id + "'>" + n.name + "</option>";
						})

						$("#edit-owner").html(html);

						$("#edit-id").val(data.c.id);
						$("#edit-name").val(data.c.name);
						$("#edit-owner").val(data.c.owner);
						$("#edit-website").val(data.c.website);
						$("#edit-phone").val(data.c.phone);
						$("#edit-description").val(data.c.description);
						$("#edit-contactSummary").val(data.c.contactSummary);
						$("#edit-nextContactTime").val(data.c.nextContactTime);
						$("#edit-address").val(data.c.address);


						//所有值都铺好之后，打开修改操作的模态窗口
						$("#editCustomerModal").modal("show");
					}
				})
			}


		})

		//为更新按钮绑定事件，执行线索的修改操作
		$("#updateBtn").click(function () {
			$.ajax({

				url: "workbench/customer/update.do",

				data: {

					"id": $.trim($("#edit-id").val()),
					"name": $.trim($("#edit-name").val()),
					"owner": $.trim($("#edit-owner").val()),
					"phone": $.trim($("#edit-phone").val()),
					"website": $.trim($("#edit-website").val()),
					"description": $.trim($("#edit-description").val()),
					"contactSummary": $.trim($("#edit-contactSummary").val()),
					"nextContactTime": $.trim($("#edit-nextContactTime").val()),
					"address": $.trim($("#edit-address").val())
				},
				type: "post",
				dataType: "json",
				success: function (data) {

					if (data.success) {

						pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
								, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

						//关闭修改操作的模态窗口
						$("#editCustomerModal").modal("hide");


					} else {
						alert("修改线索失败");
					}
				}

			})
		})

		//为删除按钮绑定事件，执行线索删除操作
		$("#deleteBtn").click(function () {

			//alert("123");

			//找到复选框中所有挑√的复选框的jquery对象 $("text:radio:checked")
			var $xz = $("input[name=xz]:checked");

			if ($xz.length == 0) {

				alert("请选择需要删除的记录");

				//肯定选了，而且有可能是1条，有可能是多条
			} else {

				if (confirm("确定删除所选中的记录吗？")) {

					//url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx

					//拼接参数
					var param = "";

					/* for (var i = 0; i < $xz.length; i++) {
                         alert($($xz[i]).val());
                     }*/
					//将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录的id
					for (var i = 0; i < $xz.length; i++) {

						param += "id=" + $($xz[i]).val();
						//如果不是最后一个元素，需要在后面追加一个&符
						if (i < $xz.length - 1) {

							param += "&";
						}
					}
					//alert(param);
					$.ajax({

						url: "workbench/customer/delete.do",
						data: param,
						type: "post",
						dataType: "json",
						success: function (data) {
							if (data.success) {

								//删除成功后
								//回到第一页，维持每页展现的记录数
								pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

							} else {

								alert("删除潜在客户失败");
							}
						}
					})
				}
			}
		})


		
	});

	//分页函数
	function pageList(pageNo, pageSize) {

		//将全选的复选框的√干掉
		$("#qx").prop("checked", false);

		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-website").val($.trim($("#hidden-website").val()));

		$.ajax({

			url: "workbench/customer/pageList.do",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"name": $.trim($("#search-name").val()),
				"owner": $.trim($("#search-owner").val()),
				"phone": $.trim($("#search-phone").val()),
				"website": $.trim($("#search-website").val())
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				/*
                    data
                        我们需要的：客户信息列表
                        [{客户1},{2},{3}] List<Clue> aList
                        一会分页插件需要的：查询出来的总记录数
                        {"total":100} int total
                        {"total":100,"dataList":[{客户1},{2},{3}]}
                 */
				var html = "";
				//每一个n就是每一个线索对象
				$.each(data.dataList, function (i, n) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
					html += '<td>' + n.owner + '</td>';
					html += '<td>' + n.phone + '</td>';
					html += '<td>' + n.website + '</td>';
					html += '</tr>';

				})

				$("#customerBody").html(html);

				//计算总页数
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#customerPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//该回调函数时在，点击分页组件的时候触发的
					onChangePage: function (event, data) {
						pageList(data.currentPage, data.rowsPerPage);
					}
				});


			}

		})

	}
	
</script>
</head>
<body>

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-phone"/>
	<input type="hidden" id="hidden-website"/>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form id="customerAddForm" class="form-horizontal" role="form">



						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button  type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户12</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id" />

						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者12<span
									style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">123</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateBtn" type="button" class="btn btn-primary" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	<%--主页面--%>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="search-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input id="search-website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="searchBtn" type="button" class="btn btn-default">查询123</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addBtn" type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal">
					  <span class="glyphicon glyphicon-plus"></span> 创建2</button>

				  <button id="editBtn" type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal">
					  <span class="glyphicon glyphicon-pencil"></span> 修改3</button>

					<button id="deleteBtn" type="button" class="btn btn-danger">
					  <span class="glyphicon glyphicon-minus"></span> 删除4</button>
				</div>
				
			</div>

			<%--客户信息列表展示--%>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>

					<tbody id="customerBody">

					</tbody>
					<%--<tbody>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>
					</tbody>--%>
				</table>
			</div>


			<%--分页模块--%>
			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<div id="customerPage"></div>
				</div>
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>