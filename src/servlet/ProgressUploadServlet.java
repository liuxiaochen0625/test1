package servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import listener.UploadListener;


import bean.UploadStatus;

@WebServlet("/ProgressUploadServlet")
public class ProgressUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ProgressUploadServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Cache-Control", "no-store");	 //禁止浏览器缓存 
		response.setHeader("Pragrma", "no-cache");	 //禁止浏览器缓存 
		response.setDateHeader("Expires", 0);	 //禁止浏览器缓存 
		response.setCharacterEncoding("UTF-8"); 

		UploadStatus status = (UploadStatus) request.getSession(true) 
		.getAttribute("uploadStatus");	 //从session中读取上传信息 
		if (status == null) { 
		response.getWriter().println("没有上传信息"); return;	 //没有上传信息，返回 
		} 

		long startTime = status.getStartTime();	 //上传开始时间 
		long currentTime = System.currentTimeMillis();	 //现在时间 
		long time = (currentTime - startTime) / 1000 + 1;	 //已传输的时间 单位: s 

		double velocity = ((double)status.getBytesRead()) / (double)time;	 //传输速度 单位: byte/s 
		double totalTime = status.getContentLength() / velocity;	 //估计总时间  单位: s 
		double timeLeft = totalTime - time;	 //估计剩余时间 单位: s 
		int percent = (int)(100 * (double)status.getBytesRead() / (double) 
		status.getContentLength());	 //已完成的百分比 
		double length = ((double)status.getBytesRead())/1024/1024;	 //已完成数 单位: M 
		double totalLength = ((double)status.getContentLength())/1024/1024;	 //总长度 单位: M 

		//格式化：百分比||已完成数（M）||文件总长度（M）||传输速率（K）||已用时间（s）|| 
		//估计总时间（s）||估计剩余时间（s）||正在上传第几个文件 
		String value = percent + "||"+ length+"||"+totalLength+"||"+velocity+"||"+ time + 
		"||"+totalTime +"||"+timeLeft+"||"+status.getItems(); 
		response.getWriter().println(value);	 //输出给浏览器进度条 
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UploadStatus status = new UploadStatus();	 //上传状态 
		UploadListener listener = new UploadListener(status);	 //监听器 
		request.getSession(true).setAttribute("uploadStatus", status);	 //把状态放到Session里 

		ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());	//解析 
		upload.setProgressListener(listener);	 //设置上传listener 

		try { 
		List itemList = upload.parseRequest((RequestContext) request);	 //提交所有的参数 
		for (Iterator it=itemList.iterator();it.hasNext();) {	 //遍历所有的参数 
		FileItem item = (FileItem)it.next(); 

		if (item.isFormField()) {	 //如果是表单数据 
		System.out.println("FormField: "+item.getFieldName()+" = "+item.getString()); 

		}else {	 //否则就是上传文件 
		System.out.println("File: "+item.getName()); 
		//统一Linux 与 windows 分路径分隔符 
//			 String fileName = item.getName().replace("/", "\\"); 
//			 fileName = fileName.substring(fileName.lastIndexOf("\\")); 
		String fileName = item.getName(); 

		File saved = new File("D:\\upload_test",fileName);	 //创建文件对象 
		saved.getParentFile().mkdirs();	 //保证路径存在 

		InputStream ins = item.getInputStream();	 //提交的文件内容 
		OutputStream ous = new FileOutputStream(saved);	 //输出流 

		byte[] tmp = new byte[1024];	 //缓存 
		int len = -1;	 //缓存的实际长度 
		while ((len = ins.read(tmp))!=-1) { 
		ous.write(tmp,0,len);	 //写文件 

		} 
		ous.close(); 
		ins.close(); 
		response.getWriter().println("已保存文件: "+ saved); 
		} 

		} 

		} catch (FileUploadException e) { 
		response.getWriter().println("上传文件发生错误: "+ e.getMessage()); 
		} 
	}

}
