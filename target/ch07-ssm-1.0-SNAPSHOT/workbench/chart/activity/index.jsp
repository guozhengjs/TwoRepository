<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

/*

需求：

根据交易表中的不同的阶段的数量进行一个统计，最终形成一个漏斗图（倒三角）

将统计出来的阶段的数量比较多的，往上面排列
将统计出来的阶段的数量比较少的，往下面排列

例如：
01资质审查  10条
02需求分析  85条
03价值建议  3条
...
07成交      100

sql:
按照阶段进行分组

resultType="map"

select

stage,count(*)

from tbl_tran

group by stage




*/

%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>柱状图</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>

    <script>

        $(function () {
            alert("123");
            //页面加载完毕后，绘制统计图表
            //getCharts();

            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));

            // 指定图表的配置项和数据
            var option = {
                title: {
                    text: 'ECharts 入门示例'
                },
                tooltip: {},
                legend: {
                    data:['销量']
                },
                xAxis: {
                    data: ["衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"]
                },
                yAxis: {},
                series: [{
                    name: '销量',
                    type: 'bar',
                    data: [5, 20, 36, 10, 10, 20]
                }]
            };
            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);
        })




    </script>
</head>
<body>

<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>


