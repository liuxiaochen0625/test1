package listener;



import org.apache.commons.fileupload.ProgressListener;

import bean.UploadStatus;

public class UploadListener implements ProgressListener{ 

private UploadStatus status;	 //记录上传上传信息的Java Bean 

public UploadListener(UploadStatus status){ 
this.status = status; 
} 

public void update(long bytesRead, long contentLength, int items) { 
status.setBytesRead(bytesRead);	 //已读取的字节长度 
status.setContentLength(contentLength);	 //文件总长度 
status.setItems(items);	 //正在保存第几个文件 

} 


} 
