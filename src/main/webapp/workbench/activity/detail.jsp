<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            //==============================================================================
            //页面加载完毕后，展现该市场活动关联的备注信息列表
            showRemarkList();

            //为删除按钮绑定事件，执行市场活动删除操作
            $("#deleteBtn").click(function () {

                //找到复选框中所有挑√的复选框的jquery对象 $("text:radio:checked")

                    if(confirm("确定删除所选中的记录吗？")){

                        //url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx
                        //拼接参数

                        $.ajax({

                            url : "workbench/activity/delete.do",
                            data : {

                                "id": "${a.id}"

                            },
                            type : "post",
                            dataType : "json",
                            success : function (data) {

                                if(data.success){
                                    //删除成功后重定向到市场活动列表页面
                                    //request.getRequestDispatcher("/workbench/activity/index.jsp").forward(request, response);

                                    document.location.href = "workbench/activity/index.jsp";

                                    //回到第一页，维持每页展现的记录数

                                    //pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                }else{
                                    alert("删除市场活动失败");
                                }
                            }
                        })
                    }

            })


            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {

                $.ajax({

                    url: "workbench/activity/getUserListAndActivity.do",
                    data: {

                        "id": "${a.id}"

                    },
                    type: "get",
                    dataType: "json",
                    success: function (data) {

                        //处理所有者下拉框
                        var html = "<option></option>";

                        $.each(data.uList, function (i, n) {

                            html += "<option value='" + n.id + "'>" + n.name + "</option>";

                        })

                        $("#edit-owner").html(html);

                        //处理单条activity
                        $("#edit-id").val(data.a.id);
                        $("#edit-name").val(data.a.name);
                        $("#edit-owner").val(data.a.owner);
                        $("#edit-startDate").val(data.a.startDate);
                        $("#edit-endDate").val(data.a.endDate);
                        $("#edit-cost").val(data.a.cost);
                        $("#edit-description").val(data.a.description);

                        //所有的值都填写好之后，打开修改操作的模态窗口
                        $("#editActivityModal").modal("show");


                    }
                })
            })


            //为更新市场活动详细信息页面按钮绑定事件，执行市场活动的修改操作
            $("#updateBtn").click(function () {

                $.ajax({

                    url: "workbench/activity/update.do",
                    data: {

                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val())

                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {

                            refresh();

                            $("#editActivityModal").modal("hide");

                            // window.location.reload(true);
                            // showRemarkList();


                        } else {

                            alert("修改市场活动失败");

                        }

                    }

                })

            })


            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })


            //为保存备注按钮绑定事件，执行备注添加操作
            $("#saveRemarkBtn").click(function () {

                $.ajax({

                    url: "workbench/activity/saveRemark.do",
                    data: {

                        "noteContent": $.trim($("#remark").val()),
                        "activityId": "${a.id}"

                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        /*

                            data
                                {"success":true/false,"ar":{备注}}

                         */

                        if (data.success) {

                            //添加成功

                            //textarea文本域中的信息清空掉
                            $("#remark").val("");

                            //在textarea文本域上方新增一个div
                            var html = "";

                            html += '<div id="' + data.ar.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5>' + data.ar.noteContent + '</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;"> ' + (data.ar.createTime) + ' 由' + (data.ar.createBy) + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" ><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #da6a6a;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.ar.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';

                            $("#remarkDiv").before(html);

                        } else {

                            alert("添加备注失败");

                        }


                    }

                })

            })


            //为备注更新按钮绑定事件
            $("#updateRemarkBtn").click(function () {

                var id = $("#remarkId").val();

                $.ajax({

                    url: "workbench/activity/updateRemark.do",
                    data: {

                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())

                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        /*

                            data
                                {"success":true/false,"ar":{备注}}

                         */
                        if (data.success) {

                            //修改备注成功
                            //更新div中相应的信息，需要更新的内容有 noteContent，editTime，editBy
                            $("#e" + id).html(data.ar.noteContent);
                            $("#s" + id).html(data.ar.editTime + " 由" + data.ar.editBy);

                            //更新内容之后，关闭模态窗口
                            $("#editRemarkModal").modal("hide");


                        } else {

                            alert("修改备注失败");

                        }


                    }

                })

            })

        });

        function showRemarkList() {

            $.ajax({

                url: "workbench/activity/getRemarkListByAid.do",
                data: {

                    "activityId": "${a.id}"

                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    /*

                        data
                            [{备注1},{2},{3}]


                     */

                    var html = "";

                    $.each(data, function (i, n) {

                        /*
                            javascript:void(0);
                                将超链接禁用，只能以触发事件的形式来操作
                         */

                        html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="e' + n.id + '">' + n.noteContent + '</h5>';
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s' + n.id + '"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';

                    })

                    $("#remarkDiv").before(html);

                }

            })

        }

        function deleteRemark(id) {

            $.ajax({

                url: "workbench/activity/deleteRemark.do",
                data: {

                    "id": id

                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    /*

                        data
                            {"success":true/false}

                     */

                    if (data.success) {

                        //删除备注成功
                        //这种做法不行，记录使用的是before方法，每一次删除之后，页面上都会保留原有的数据
                        //showRemarkList();

                        //找到需要删除记录的div，将div移除掉
                        $("#" + id).remove();


                    } else {

                        alert("删除备注失败");

                    }


                }

            })

        }

        function editRemark(id) {

            //alert(id);

            //将模态窗口中，隐藏域中的id进行赋值
            $("#remarkId").val(id);

            //找到指定的存放备注信息的h5标签
            var noteContent = $("#e" + id).html();

            //将h5中展现出来的信息，赋予到修改操作模态窗口的文本域中
            $("#noteContent").val(noteContent);

            //以上信息处理完毕后，将修改备注的模态窗口打开
            $("#editRemarkModal").modal("show");

        }

        function refresh() {
            $.ajax({

                url: "workbench/activity/refresh.do",
                data: {

                    "id": "${a.id}"

                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    $("#owner").html(data.owner);
                    $("#name").html(data.name);
                    $("#startDate").html(data.startDate);
                    $("#endDate").html(data.endDate);
                    $("#cost").html(data.cost);
                    $("#description").html(data.description);
                    $("#editBy").html(data.editBy);
                    $("#editTime").html(data.editTime);
                }

            })

        }
    </script>

</head>
<body>
<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <input type="hidden" id="edit-id"/>

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">


                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称123<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <!--

                                关于文本域textarea：
                                    （1）一定是要以标签对的形式来呈现,正常状态下标签对要紧紧的挨着
                                    （2）textarea虽然是以标签对的形式来呈现的，但是它也是属于表单元素范畴
                                            我们所有的对于textarea的取值和赋值操作，应该统一使用val()方法（而不是html()方法）

                            -->
                            <textarea class="form-control" rows="3" id="edit-description">123</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动11-${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn" data-toggle="modal" data-target="#editActivityModal">
            <span class="glyphicon glyphicon-edit"></span> 编辑11
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;" id="detailDiv">
    <div style="position: relative; left: 40px; height: 30px;">
        <%--<input type="hidden" name="id" value="${a.id}"/>--%>
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="owner">${a.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="name">${a.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期1</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="startDate">${a.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期2</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="endDate">${a.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="cost">${a.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">${a.createBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;" id="createTime">${a.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${a.editBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;" id="editTime">${a.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="description">
                ${a.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>