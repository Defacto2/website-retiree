<!---
    Application START event
	path: events/onapplicationstart.cfm

@CFLintIgnore
--->
<cfscript>
	var myapp = "myapp"
	/* Log the application start-up time */
	if(StructKeyExists(get(myapp),"logstomcat") and
		StructKeyExists(get(myapp).logstomcat,"dir")
		and DirectoryExists(get(myapp).logstomcat.dir)) {
		var path = "#get(myapp).logstomcat.dir#/startup.log"
		var text = "#CGI.local_host#;#application.productionHost#;#DateFormat(Now(),'YYYY-MM-DD')#;#TimeFormat(Now(),'HH:MM:SS')#"
		// append to log file
		if(FileExists(path)) {
			logFile = fileOpen(path, "append");
			fileWrite(logFile, text);
			fileClose(logFile);
		}
		// create new log file
		else fileWrite(path, text);
	}
	/* Check for the existence of and create any missing paths that will host dynamically generated files */
	// Default Linux octal file permissions when saving or writing to the file system
	// owner / group / everyone else | 0=- 1=x 2=w 3=wx 4=r 5=rx 6=rw 7=rwx
	if (get("environment") != "maintenance") {
		var mode = "775"
		if(!DirectoryExists("#get(myapp).fulldirBackup#")) directory action="create" directory="#get(myapp).fulldirBackup#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirFileUuid#")) directory action="create" directory="#get(myapp).fulldirFileUuid#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirImages#")) directory action="create" directory="#get(myapp).fulldirImages#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirPreview#")) directory action="create" directory="#get(myapp).fulldirPreview#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirTest#")) directory action="create" directory="#get(myapp).fulldirTest#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirThumb400#")) directory action="create" directory="#get(myapp).fulldirThumb400#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirUploadFiles#")) directory action="create" directory="#get(myapp).fulldirUploadFiles#" mode="#mode#";
		if(!DirectoryExists("#get(myapp).fulldirUploadImg#")) directory action="create" directory="#get(myapp).fulldirUploadImg#" mode="#mode#";
	}
</cfscript>