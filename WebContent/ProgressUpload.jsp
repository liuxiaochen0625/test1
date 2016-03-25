<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传进度条</title>
<style type="text/css">
	body, td, div {font-size: 12px; font-familly: 宋体; }
	#progressBar {width: 400px; height: 12px; background: #FFFFFF; border: 1px solid #000000; padding: 1px; }
	#progressBarItem {width: 30%; height: 100%; background: #FF0000; }
</style>

<script type="text/javascript"> 
	var _finished = true;	 //是否上传结束标识符 
	function $(obj){ 
		return document.getElementById(obj);	 //返回指定id的HTML元素 
	} 

	function showStatus(){ 
		_finished = false;	 //显示进度条 
		$('status').style.display = 'block';	 //将隐藏的进度条显示 
		$('progressBarItem').style.width='1%';	 //设置进度条初始值为1% 
		$('btnSubmit').disabled = true;	 //把提交按钮置灰 防止重复提交 

		setTimeout("requestStatus()",1000);	 //1秒后执行requestStatus()方法，更新上传进度 
	} 

	function requestStatus(){	 //向服务器请求上传进度信息 
		if(_finished)  return;	 //如果已经结束，则返回 
		var req = createRequest();	 //获取Ajax请求 
		req.open("GET","servlet/ProgressUploadServlet");	 //设置请求路径 
		req.onreadystatechange=function(){callback(req)}	 //请求完毕就执行callback(req) 
		req.send(null);	 //发送请求 
		setTimeout("requestStatus()",1000);	 //1秒后执行requestStatus()方法，更新上传进度 
	} 

	function createRequest(){	 //返回Ajax请求对象 
		if(window.XMLHttpRequest){	 //Netscape浏览器 
			return new XMLHttpRequest(); 
		}else{	 //IE浏览器 
			try{ 
				return new ActiveXObject("Msxml2.XMLHTTP"); 
			}catch(e){ 
				return new ActiveXObject("Microsoft.XMLHTTP"); 
			} 
		
		} 
		return null; 
	} 

	function callback(req){	 //刷新进度条 
		if(req.readyState == 4){	 //请求结束后 
			if(req.status != 200){	 //如果发生错误，则显示错误信息 
				debug("发生错误。req.status: "+req.status + ""); 
			return; 
			} 
		debug("status.jsp 返回值："+ req.responseText);	 //显示debug信息 
		var ss = req.responseText.split("||");	 //处理进度条信息。格式格式化：百分比||已完成数（M）||文件总长度（M）||传输速率（K）||已用时间（s）|| 
		//估计总时间（s）||估计剩余时间（s）||正在上传第几个文件 
		$('progressBarItem').style.width='' + ss[0] + '%'; 
		$('statusInfo').innerHTML = '已完成百分比: '+	 ss[0]+'%<br/>已完成数（M）:'+ss[1]+'<br/>文件总长度（M）: '+ ss[2]+ 
		'<br/>传输速率（K）: '+ss[3]+'<br/>已用时间（s）: '+ss[4]+'<br/>估计总时间（s）: '+ss[5]+'<br/>估计剩余时间（s）: '+ 
		ss[6]+'<br/>正在上传第几个文件: '+	ss[7];	
		
		if(ss[1] == ss[2]){ 
			_finished = true; 
			$('statusInfo').innerHTML += "<br/><br/><br/>上传成功。"; 
			$('btnSubmit').disabled = false; 
			}	
		} 
	} 

	function debug(){ 
		var div = document.createElement("DIV");	 //显示提示信息 
		//div.innerHTML = "[debug]: "+ obj; 
		document.body.appendChild(div); 
	} 
</script> 

</head>

<body>

<iframe name=upload_iframe width=0 height=0></iframe>

<form action="servlet/ProgressUploadServlet" method="post" enctype="multipart/form-data" target="upload_iframe" onsubmit="showStatus(); ">

<input type="file" name="file1" style="width: 350px; "> <br />
<input type="file" name="file2" style="width: 350px; "> <br />
<input type="file" name="file3" style="width: 350px; "> <br />
<input type="file" name="file4" style="width: 350px; "> <input type="submit"
	value=" 开始上传 " id="btnSubmit"></form>

<div id="status" style="display: none; ">
	上传进度条：
	<div id="progressBar"><div id="progressBarItem"></div></div>
	<div id="statusInfo"></div>
</div>

<br/>
<br/>
<br/>
<br/>
<br/>

<script type="text/javascript">

var _finished = true;

function $(obj){
	return document.getElementById(obj);
}

function showStatus(){
	_finished = false;
	$('status').style.display = 'block'; 
	$('progressBarItem').style.width = '1%'; 
	$('btnSubmit').disabled = true;
	
	setTimeout("requestStatus()", 1000); 
}

function requestStatus(){

	if(_finished)	return;
	
	var req = createRequest(); 
	
	req.open("GET", "servlet/ProgressUploadServlet");
	req.onreadystatechange=function(){callback(req);}
	req.send(null);
	
	setTimeout("requestStatus()", 1000); 
}

function createRequest()
{
	if(window.XMLHttpRequest)//ns
	{
		return new XMLHttpRequest();
	}else//IE
	{
		try{
	    	return new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			return new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	return null;
}
function callback(req){

	if(req.readyState == 4) {
		if(req.status != 200){
			_debug("发生错误。 req.status: " + req.status + "");
			return;
		}
		
		_debug("status.jsp 返回值：" + req.responseText);
		
		var ss = req.responseText.split("||");
			
		// 格式：百分比||已完成数(M)||文件总长度(M)||传输速率(K)||已用时间(s)||估计总时间(s)||估计剩余时间(s)||正在上传第几个文件
		$('progressBarItem').style.width = '' + ss[0] + '%'; 
		$('statusInfo').innerHTML = '已完成百分比: ' + ss[0] + '% <br />已完成数(M): ' + ss[1] + '<br/>文件总长度(M): ' + ss[2] + '<br/>传输速率(K): ' + ss[3] + '<br/>已用时间(s): ' + ss[4] + '<br/>估计总时间(s): ' + ss[5] + '<br/>估计剩余时间(s): ' + ss[6] + '<br/>正在上传第几个文件: ' + ss[7];
		
		if(ss[1] == ss[2]){
			_finished = true;
			$('statusInfo').innerHTML += "<br/><br/><br/>上传已完成。"; 	
			$('btnSubmit').disabled = false;
		}
	}
}
function _debug(obj){
	var div = document.createElement("DIV");
	div.innerHTML = "[debug]: " + obj;
	document.body.appendChild(div); 
}

</script>

</body>
</html>