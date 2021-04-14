<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/raqsoftReport.tld" prefix="report" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="com.raqsoft.report.view.*"%>
<%@ page import="com.raqsoft.report.util.*"%>
<%@ page import="cn.threeplp.plp.web.login.service.DataScreenService" %>
<%@ page import="cn.threeplp.plp.web.report.task.ReportOperationJSPTask" %>

<html>
<head>
    <meta name="viewport" content="initial-scale=1" />
</head>
<link type="text/css" href="css/style.css" rel="stylesheet"/>
<% 
	if(request.getProtocol().compareTo("HTTP/1.1")==0 ) response.setHeader("Cache-Control","no-cache");
	else response.setHeader("Pragma","no-cache");
	request.setCharacterEncoding( "UTF-8" );
	String appmap = request.getContextPath();
%>
<link rel="stylesheet" type="text/css" href="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/themes/<%=ReportConfig.theme%>/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/themes/icon.css">
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.min.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/locale/easyui-lang-<%=ReportUtils2.getEasyuiLanguage(request)%>.js"></script>
<<<<<<< .mine
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/tabSize.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/colresizable/1.6.0/colResizable-1.6.js"></script>
||||||| .r18342
=======
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/tabSize.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/colResizable-1.6.min.js"></script>
>>>>>>> .r18358

<body topmargin=0 leftmargin=0 rightmargin=0 bottomMargin=0 style="background:#F1F4F7" onload="try{parent.hideLoading()}catch(e){}">
<jsp:include page="echartjs.jsp" flush="false" />
<%
	String reportCode = request.getParameter( "bsdm" );
	String reportLogo = request.getParameter( "bbls" );

	//获取报表物理路径
	ReportOperationJSPTask dataTask = new ReportOperationJSPTask();
	String path = dataTask.getReportPath(reportCode,reportLogo);

	//request.getParameter("rpx");
	String report = path;
	String scroll = request.getParameter( "scroll" );
	if (scroll==null || scroll.length()==0) scroll = "no";
	StringBuffer param=new StringBuffer();
	
	//保证报表名称的完整性
	int iTmp = 0;
	if( (iTmp = report.lastIndexOf(".rpx")) <= 0 ){
		iTmp = report.length();
		report = report + ".rpx";
	}
	
	Enumeration paramNames = request.getParameterNames();
	if(paramNames!=null){
		while(paramNames.hasMoreElements()){
			String paramName = (String) paramNames.nextElement();
			String paramValue=request.getParameter(paramName);
			//System.out.println("paramValue="+paramValue);
			if(paramValue!=null){
				//把参数拼成name=value;name2=value2;.....的形式
				param.append(paramName).append("=").append(paramValue).append(";");
			}
		}
	}
//	report = path;
	String resultPage = "queryReport.jsp?rpx=" + URLEncoder.encode( report, "UTF-8" ) + "&scroll=" + scroll;
	//以下代码是检测这个报表是否有相应的参数模板
	String paramFile = report.substring(0,iTmp)+"_arg.rpx";
	boolean hasParam = ReportUtils.isReportFileExist( paramFile );
%>
<div id=mengban style="background-color:white;position:absolute;z-index:999;width:100%;height:100%">
	<table width=100% height=100%>
		<tr><td width=100% style="text-align:center;vertical-align:middle"><img src="../raqsoft/images/loading.gif"><br><%=ServerMsg.getMessage(request,"jsp.loading")%></td></tr>
	</table>
</div>
<div id=reportArea class="easyui-layout" data-options="fit:true" style="display:none;width:100%;height:100%">
<div data-options="region:'north',border:false" style="height:30px;overflow:hidden">
<jsp:include page="toolbar.jsp" flush="false" />
</div>
<div data-options="region:'center',border:false">
<div class="easyui-layout" data-options="fit:true">
	<%	//如果参数模板存在，则显示参数模板
	if( hasParam ) {
	%>
		<div data-options="region:'north',border:false"><center>
			<table id="param_tbl" align=center><tr><td>
				<report:param name="form1" paramFileName="<%=paramFile%>"
					needSubmit="no"
					params="<%=param.toString()%>"
					hiddenParams="<%=param.toString()%>"
					needImportEasyui="no"
					resultContainer="reportContainer"
					resultPage="<%=resultPage%>"
				/>
			</td>
			<td style="padding-left:15px"><a href="javascript:_submit( form1 )" class="easyui-linkbutton" style="vertical-align:middle;padding:0px 8px;"><%=ServerMsg.getMessage(request,"jsp.query")%></a></td>
			</tr></table>
		</center></div>
	<% }%>
	<div id=reportContainer data-options="region:'center',border:false" style="text-align:center">
		<report:html name="report1" reportFileName="<%=report%>"
			funcBarLocation="no"
			needScroll="<%=scroll%>"
			generateParamForm="no"
			params="<%=param.toString()%>"
			exceptionPage="/reportJsp/myError2.jsp"
			appletJarName="/raqsoftReportApplet.jar"
			scrollWidth="100%" 
			scrollHeight="100%"
			needImportEasyui="no"
			scale="1.5"
			width="-1"
		/>
	</div>
</div>
</div>
<script language="javascript">
	//设置分页显示值
	try {
		document.getElementById( "t_page_span" ).innerHTML = getPageCount( "report1" );
		document.getElementById( "report1_currPage" ).innerHTML = getCurrPage( "report1" );
	}catch(e){}
	document.getElementById( "mengban" ).style.display = "none";
	document.getElementById( "reportArea" ).style.display = "";
    //穿透到vue-route跳转
	function jumpUnit(reportName, dwjs, dwdm, year, kjqj, sflj, bsdm, bbls) {
		var url = "/showReport.jsp?rpx="+ reportName +".rpx" +
				"&dwjs=" + dwjs +
				"&dwdm=" + dwdm +
				"&year=" + year +
				"&kjqj=" + kjqj +
				"&sflj=" + sflj +
				"&bsdm=" + bsdm +
				"&bbls=" + bbls
        // 跨域
		window.parent.postMessage({
			data: 'haveparams',
			params: {
                reportName: reportName,
				dwjs: dwjs,
				dwdm: dwdm,
				year: year,
				kjqj: kjqj,
				bsdm: bsdm,
				bbls: bbls,
				sflj: sflj,
				url: url
			}
		}, '*')
	}
	// 穿透跳转
	function penetrate(reportName, dwjs, dwdm, year, kjqj, sflj, bsdm, bbls) {
		var url = "./showReport.jsp?rpx=" + reportName + ".rpx" +
            "&dwjs=" + dwjs +
            "&dwdm=" + dwdm +
            "&year=" + year +
            "&kjqj=" + kjqj +
            "&bsdm=" + bsdm +
            "&bbls=" + bbls +
            "&sflj=" + sflj
        window.location.href = url
        // window.open(url)
	}

	function jumpDialog(id) {
		// 跨域
		window.parent.postMessage({
			data: 'havParamsDialog',
			params: {
				id: id
			}
		}, '*')
	}
<<<<<<< .mine
    // 分配情况跳转
    function jumpAllocation(id, dwdm, dwjs) {
        // 跨域
        window.parent.postMessage({
            data: 'havaParamsDialog',
            params: {
                id: id,
                dwdm: dwdm,
                dwjs: dwjs
            }
        }, '*')
    }

    $(function() {
        $("table").colResizable();
		$("table").removeClass("JPadding");
    })
    // window.onload = function() {
    //     tabSize.init('report1');
    // };
    // var tabSize = tabSize || {};
    // tabSize.init = function (id) {
    //     var i,
    //         self,
    //         table = document.getElementById(id),
    //         header = table.rows[3], // 此处的获取润乾表的 thead 是没有的； 而且bug是 拖动一个 全部加宽
    //         // header = table.rows[2] || table.rows[3] || table.rows[4] || table.rows[5], // 此处的获取润乾表的 thead 是没有的； 而且bug是 拖动一个 全部加宽
    //         tableX = header.clientWidth,
    //         length = header.cells.length;
    //     console.log(table)
    //     console.log(header)
    //     console.log(header.cells)
    //     console.log(header.clientWidth)
    //     // debugger
    //     for (i = 0; i < length; i++) {
    //         header.cells[i].onmousedown = function () {
    //             self = this;
    //             if (event.offsetX > self.offsetWidth - 10) {
    //                 self.mouseDown = true;
    //                 self.oldX = event.x;
    //                 self.oldWidth = self.offsetWidth;
    //             }
    //         };
    //         header.cells[i].onmousemove = function () {
    //             if (event.offsetX > this.offsetWidth - 10) {
    //                 this.style.cursor = 'col-resize';
    //             } else {
    //                 this.style.cursor = 'default';
    //             }
    //             if (self == undefined) {
    //                 self = this;
    //             }
    //             if (self.mouseDown != null && self.mouseDown == true) {
    //                 self.style.cursor = 'default';
    //                 console.log(self)
    //                 console.log(self.oldWidth)
    //                 console.log(event.x)
    //                 console.log(self.oldX)
    //                 if (self.oldWidth + (event.x - self.oldX) > 0) {
    //                     console.log(self.oldWidth)
    //                     console.log(self.oldX)
    //                     self.width = self.oldWidth + (event.x - self.oldX);
    //                 }
    //                 console.log(self.width)
    //                 console.log(self.style)
    //                 self.style.width = self.width; // 列宽
    //                 console.log(7777)
    //                 console.log(tableX)
    //                 console.log((event.x - self.oldX))
    //                 table.style.width = tableX + (event.x - self.oldX) + 'px'; // 表格宽
    //                 console.log(table.style.width)
    //                 self.style.cursor = 'col-resize';
    //             }
    //         };
    //         table.onmouseup = function () {
    //             if (self == undefined) {
    //                 self = this;
    //             }
    //             self.mouseDown = false;
    //             self.style.cursor = 'default';
    //             tableX = header.clientWidth;
    //         };
    //     }
    // };
||||||| .r18342
=======

	// 分配情况跳转
	function jumpAllocation(id, dwdm, dwjs) {
		// 跨域
		window.parent.postMessage({
			data: 'havaParamsDialog',
			params: {
				id: id,
				dwdm: dwdm,
				dwjs: dwjs
			}
		}, '*')
	}

	$(function() {
		$("#report1").colResizable({
			liveDrag: true, //实时显示滑动位置
			gripInnerHtml: "<div class='grip'></div>",
			postbackSafe: true, //刷新后保留之前的拖拽宽度
		});
	})
>>>>>>> .r18358
</script>

</div>
</body>
</html>
