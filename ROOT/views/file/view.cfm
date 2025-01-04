<!---
    View file in browser view.
	path: views/files/view.cfm

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout=pageTimeout;
	var myapp = myapp
	var missing = function() {
		if(cgi.http_referer contains "html3") {
			flashInsert(missingfile="Sorry but the file '#fileProd.filename#' seems to be missing")
			location addtoken="false" url="#cgi.http_referer#" statusCode="307";
			return
		}
		flashInsert(missingfile="Sorry but this file seems to be missing from our server")
		redirectTo(route="f", key="#params.key#", statusCode="307")
	}
	var contentType = function() {
		// generate browser content mime type
		if(ListFindNoCase("ansi,pcb,text,textamiga",fileProd.platform)) return "text/plain; charset=ISO-8859-1";
		if(ListFindNoCase("pdf",fileProd.platform)) return "application/pdf";
		var ext = fileExtension(fileProd.filename)
		if(ListFindNoCase("png,jpg,jpeg,gif",ext)) {
			if(ext == "jpg") ext = "jpeg";
			return "image/#LCase(ext)#";
		}
		if(ListFindNoCase("htm,html",ext)) return "text/html; charset=ISO-8859-1";
		if(ListFindNoCase(get(myapp).acceptedAudio,ext)) return "audio/#LCase(ext)#";
		if(ListFindNoCase(get(myapp).acceptedVideos,ext)) return "video/#LCase(ext)#";
		// default content type that will force a file download
		return "application/octet-stream"
	}
	var dispositionHeader = function() {
		// fail-safe header to force a download if content cannot be viewed in browser
		if(file.contentType == "application/octet-stream") {
			header name="Content-Disposition" value='attachment; filename="#file.nameToSave#"';
			return
		}
		// we want the browser to render HTML files rather than display the source code as text
		// in future could also use platform markdown?
		if(ListFindNoCase("htm,html",file.extension)) return;
		// required header to display file in-browser
		header name="Content-Disposition" value='inline; filename="#file.nameToSave#"';
	}
	/* URL hack to enable in-browser viewing of files */
	var file = {
		"absolutePath":"#get(myapp).fulldirfileuuid#/#fileProd.uuid#",
		"contentType":contentType(),
		"etag":Hash(fileProd.uuid),
		"extension":fileExtension(fileProd.filename),
		"file":"",
		"info":"",
		"nameToSave":fileProd.filename,
	}
	// Determine if file exists on the server
	try {
		file.info = GetFileInfo(file.absolutePath)
	}
	catch(any err) {
		missing()
	}
	/* http headers */
	if(StructKeyExists(GetHttpRequestData().headers,"range")) header statusCode="206" statusText="Partial Content";
	header name="Accept-Ranges" value="bytes";
	header name="ETag" value='"#file.etag#"';
	header name="Last-Modified" value="#DateFormat(file.info.lastmodified,'ddd, dd mmm yyyy')# #TimeFormat(file.info.lastmodified,'HH:MM:SS')# GMT";
	dispositionHeader()
	header name="Content-Type" value="#file.contentType#";
</cfscript>
<cfcontent file="#file.absolutePath#" />