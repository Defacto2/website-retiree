<!---
    Download file view.
	path: views/files/download.cfm

@CFLintIgnore
--->
<cfscript>
	var myapp = "myapp"
	var missing = function() {
		if(cgi.http_referer contains "html3") {
			flashInsert(missingfile="Sorry but the file '#fileProd.filename#' seems to be missing")
			location addtoken="false" url="#cgi.http_referer#" statusCode="307";
			return
		}
		flashInsert(missingfile="Sorry but this file seems to be missing from our server")
		redirectTo(route="f", key="#params.key#", statusCode="307")
	}
	// URL hack to enable in-browser viewing of files
	setting requesttimeout="#get(myapp).timeoutUp#";
	file = {
		"absolutePath":"#get(myapp).fulldirfileuuid#/#fileProd.uuid#",
		// file last-modified date
		"lastMod":"#DateFormat(fileProd.file_last_modified,'ddd, dd mmm yyyy')# #TimeFormat(fileProd.file_last_modified,'HH:MM:SS')# GMT",
		"etag":Hash(fileProd.uuid),
		"info":"",
		"nameToSave":fileProd.filename,
	}
	// URL hack to allow chiptune-ui.js to download an extracted tracker song.
	if(params.route eq 'chiptune') {
		file.absolutePath &= ".chiptune"
		file.nameToSave = "#fileProd.uuid#.chiptune"
	}
	// Determine if file exists on the server
	try {
		file.info = GetFileInfo('#file.absolutePath#')
	}
	catch(any err) {
		missing()
	}
	if(!Len(Trim(file.lastMod))) {
		file.lastMod = "#DateFormat(file.info.lastmodified,'ddd, dd mmm yyyy')# #TimeFormat(file.info.lastmodified,'HH:MM:SS')# GMT"
	}
	// create HTTP header
	if(StructKeyExists(GetHttpRequestData().headers,"range")) header statusCode="206" statusText="Partial Content";
	header name="Accept-Ranges" value="bytes";
	header name="ETag" value='"#file.etag#"';
	header name="Last-Modified" value="#file.lastMod#";
	header name="Content-Disposition" value='attachment; filename="#file.nameToSave#"';
	header name="Content-Type" value="application/octet-stream";
	header name="Content-Length" value="#file.info.size#";
	header name="X-Leech" value="Enjoy the download ;)";
	content file="#file.absolutePath#";
</cfscript>