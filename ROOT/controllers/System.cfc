<!---
	System controller file.
	path: controllers/System.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
// system initialisation
public any function config() {
	filters(through="checkControllerState")
	// require coop or sysop for everything except
	filters(through="coopGiveAccess", except="session")
	// block these from coops
	filters(through="sysopGiveAccess", only="cachereset,logs,pathsdashboard,testhtml3error,testhtml5error")
}

variables.breadcrumbs &= 'system / '
variables.robotsNoIndex = true
variables.title = "System"

public string function dangerDefault(boolean cond) {
	if(!arguments.cond) return "danger";
	return "default";
}

public any function cachereset() {
	pageAbout.text = title = "Reset server cache"
	pageAbout.icon = 'fal fa-redo'
	breadcrumbs &= 'reset cache'
	variables.process = {
		"legend":"Reset cache",
		"stats":'<li class="list-group-item">Attempted to clear page pool, component and custom tag cache.</li>',
		"li":"",
	}
	var state = "error";
	var brand = "danger"
	try {
		pagePoolClear();
		state = "empty";
		brand = "success"
	}
	catch(any err) {
		state = "error";
		brand = "danger"
	}
	process.li &= '<li><strong>Page Pool is <span class="brand-#brand#">#state#</span></strong></li>'
	process.li &= '<li><em>This cache is used to cache the template object classes (loaded source code).</em></li>'
	try {
		componentCacheClear();
		state = "empty";
		brand = "success"
	}
	catch(any err) {
		state = "error";
		brand = "danger"
	}
	process.li &= '<li style="margin-top:1em;"><strong>Component Path is <span class="brand-#brand#">#state#</span></strong></li>'
	process.li &= '<li><em>Clear the component path cache.</em></li>'
	try {
		ctCacheClear();
		state = "empty";
		brand = "success"
	}
	catch(any err) {
		state = "error";
		brand = "danger"
	}
	process.li &= '<li style="margin-top:1em;"><strong>Custom Tag Path is <span class="brand-#brand#">#state#</span></strong></li>'
	process.li &= '<li><em>Clear the custom tag path cache.</em>'
	renderView('system','templateprocess')
}

private struct function data() {
	var log = {
		"exp":ListGetAt(params.key,1,'-'),
		"filter":'',
		"path":'',
		"ordered":[],
		"list":[],
	}
	log.path = get(myapp)["logs#log.exp#"].dir
	log.filter = get(myapp)["logs#log.exp#"].filter

	var list = []
	if(Len(log.filter)) list = DirectoryList(absolute_path=log.path,filter=log.filter);
	else list = DirectoryList(log.path);
	for (var item in list){
		if(fileExists(item) == false) continue;
		var info = GetFileInfo(item)
		ArrayAppend(log.ordered,"#DateFormat(info.lastmodified,'YYMMDD')##TimeFormat(info.lastmodified,'HHMMSS')#|#info.lastmodified#|#info.Size#|#item#")
	}
	ArraySort(log.ordered, "textnocase", "desc")
	var index = 0
	for (var item in log.ordered){
		index++
		log.list[index]=ListGetAt(item,4,'|')
	}
	return log;
}

public any function download() {
	param name="params.key";
	try {
		var log = data()
	} catch (any err) {
		return render404();
	}
	var filename = ListLast(log.list[ListLast(params.key,'-')],SERVER.separator.file);
	if(cgi.local_host == application.productionHost &&
		ListLen(cgi.http_referer,'/') > 1 &&
		ListGetAt(cgi.http_referer,2,'/') != cgi.http_host) {
		// automatically forward external linked downloads to the detail page
		redirectTo(statusCode="301",controller="system",action="download",key=params.key)
	}
	header name="content-disposition" value="attachment; filename=#filename#";
	header name="Content-Type" value="text/plain";
	content file="#log.path#/#filename#";
}

public any function files() {
	param name="params.key" default="";
	var color = function(required numeric finds, required numeric total) {
		if(!arguments.finds MOD 2 && arguments.total > 3) return "mod2";
		return "mod1";
	}
	pageAbout.text = title = "Manage files"
	pageAbout.icon = 'fal fa-folder'
	breadcrumbs &= 'files'

	variables.process = {
		"legend":"",
		"li":"",
	}
	// Maximum number of records to approve in a batch
	variables.approveLimit = 35
	// handle keys
	switch(params.key){
	case "index":
		pageAbout.text = title = "Statistics"
	case "":
		var statement = "section='releaseadvert'"
		finds.count = model("Files").Count(where=statement,includeSoftDeletes=true)
		renderView('system','files')
		return;
	/* Approve all files */
	case "approveall":
		title = "Approve files in waiting"
		process.legend = '<i class="fal fa-check"></i> Files'
		var statement = "deletedat IS NOT NULL AND deletedby IS NULL"
		var files = model("Files").findAll(
			select="id,filename,group_brand_by,group_brand_for,uuid",order=dynamicSqlFileOrder("posted_asc"),
			where=statement,returnAs="query",includeSoftDeletes="yes",maxRows=approveLimit)
		var finds = 0
		var licolor = "mod1"
		for(var record in files) {
			licolor = color(finds, files.recordCount)
			var hold = model("Files").findOneByUuid(
				select="deletedat,id,uuid",value="#record.uuid#",
				includeSoftDeletes=true);
			hold.updateProperty("deletedat","");
			hold.updateProperty("updatedby",session.op.uuid);
			hold.save();
			finds++
			// generate extra files
			var link = hold.uuid
			var brandFor = ""
			var brandBy = ""
			if(Len(record.group_brand_for)) brandFor = "for #record.group_brand_for#";
			if(Len(record.group_brand_by)) brandBy = "by #record.group_brand_by#";
			savecontent variable="process.li" {
				writeOutput('#process.li#');
				writeOutput('<li class="#licolor#"><small><b>#finds#.</b></small> ')
				var groups = Trim("#record.filename# #brandBy# #brandFor#")
				writeOutput('#LinkTo(text=groups,route="f",key="#obfuscateParam(record.id)#")#</li> <samp>#link#</samp>');
			}
		}
		// okay message
		if(finds == fileStats.waitingapproval) process.li = '<li class="brand-success">Congratulations all the files look good.</li>' & process.li;
		else if(fileStats.waitingapproval > 0) {
			process.li = '<li class="brand-warning">Some of the file records need updating before they can pass Q/A.</li>' & process.li;
			// process statistics
			savecontent variable="process.li" {
				var li = writeOutput('#process.li#</li><li>#LinkTo(text="Go back to the other files waiting approval",route="fileFilter",key="waitingapproval")#</li>');
			}
		}
		break;
	default:
		return render404();
	}
	renderView('system','templateprocess')
}

public any function link() {
	param name="params";
	param name="params.key" default="";

	title = "Manage websites"
	breadcrumbs &= 'manage websites'

	switch(params.key){
	case "":
	case "index":
		pageAbout.text = 'Manage websites'
		pageAbout.icon = ''
		variables.directory = "#get(myapp).waybackRoot#"
		variables.schemes = model("Link").findSchemes(includeSoftDeletes="true")
		variables.waybackwebsites = model("Link").findAll(where="uriref NOT LIKE '%//%'",returnAs="query",includeSoftDeletes="yes")
		renderView(action="link")
		break;
	case "update":
		title = get('siteAreas').titles.link
		// fetch records
		websites = model("Link").Count(where="categorysort='#params.source#'",includeSoftDeletes="yes")
		// update group_brand_for records
		recordsForReturned = model("Link").updateAll(
			categorysort="#params.newName#",
			where="categorysort='#params.source#'",
			includeSoftDeletes=true);
		// handle errors
		if(websites > 0 && recordsForReturned == 0) flashInsert(danger="You have not mentioned a new category name");
		else if(websites == 0) flashInsert(danger="No links with your category could be found in the database");
		else flashInsert(success="The records have been successfully renamed");
		redirectTo(action="link",key="categories");
		break;
	default:
		// force a 404 page not found error
		return render404();
	}
}

public any function logtailed() {
	param name="params.key";
	pageAbout.icon = 'fal fa-file-alt'
	try {
		var log = data()
	} catch (any err) {
		return render404();
	}
	var filename = ListLast(log.list[ListLast(params.key,'-')],SERVER.separator.file);
	title = 'Log: #filename#'
	pageAbout.text = 'Tailed log file: #filename#'
	breadcrumbs &= 'log = #filename#'

	var lines = 50
	if(log.exp == 'lucee') {
		lines = 1000;
		// Lucee logs are Java dumps that require more lines
		if(filename == 'exception.log') lines = 2000;
	}
	try {
	execute
		name="#get(myapp).appsTail.file#"
		arguments="-v -n#lines# #log.path##filename#"
		timeout="#get(myapp).timeoutArchive#"
		variable="file_zip_content" {};
	}
	catch(application excpt) {
		file_zip_content = "#excpt.Message#<br>#excpt.Detail#";
	}
}

public any function networkdashboard() {
	pageAbout.text = title = "Network tests"
	pageAbout.icon = 'fal fa-chart-network'
	breadcrumbs &= 'network dashboard'
	variables.dnslookup = networkDNS()
	variables.ipconfig = networkIP()
	variables.netstat = networkStat()
	variables.ping = networkPing()
}

public any function notfound() {
	breadcrumbs &= '404'
	render404();
}

public any function pathsdashboard() {
	title="Logs and paths"
	pageAbout.text = 'Logfiles and critical directories'
	pageAbout.icon = 'fal fa-folder-tree'
	breadcrumbs &= 'logs and paths'

	variables.lists = {
		"more":StructKeyList(get(myapp)),
	}
	lists.more = ListSort(lists.more,'text')

	variables.logs = []
	var index = 0
	cfloop(list=StructKeyList(get(myapp)), index='local.log', delimiters=","){
		if(Left(log,4) != 'logs') continue;
		if(!Len(get(myapp)[log].dir)) continue;
		local.name = get(myapp)[log].name
		if(name == "Lucee") index = 2
		else if(name == "nginx") index = 1
		else if(name == "apache tomcat") index = 3
		else index++
		logs[index] = [log,name,get(myapp)[log].dir,get(myapp)[log].displayedfilename,get(myapp)[log].filter]
	}
}

public any function sessions() {
	param name="params.key" default="";
	pageAbout.text = title = "Sessions"
	pageAbout.icon = 'fal fa-network-wired'
	breadcrumbs &= 'sessions'
	switch(params.key){
	case "index": case "":
		redirectTo(controller="system",action="sessions",key="server")
		return;
	case "client":
		title = "Client variables"
		header = "Your #title# <strong>CLIENT</strong>"
		variables.dump = CLIENT;
		renderView(controller="system",action="templatesession")
		return;
	case "cookie":
		title =  "Browser cookies"
		header = "Your #title# <strong>COOKIE</strong>"
		variables.dump = COOKIE;
		renderView(controller="system",action="templatesession")
		return;
	case "cgi":
		title = "CGI environment variables"
		header = "Your #title# <strong>CGI</strong>"
		variables.dump = CGI;
		renderView(controller="system",action="templatesession")
		return;
	case "http":
		title = "Server HTTP request data"
		header = "#title#: <u>getHTTPRequestData().headers</u>"
		variables.dump = getHTTPRequestData().headers
		renderView(controller="system",action="templatesession")
		return;
	case "personal":
		title = "Session details"
		header = "Details of your <strong>SESSION</strong>"
		variables.dump = SESSION;
		renderView(controller="system",action="templatesession")
		return;
	case "server":
		var count = createObject("java","coldfusion.runtime.SessionTracker").getSessionCount()
		title = "Server sessions"
		header = "active server sessions <strong>#count#</strong>, <small>the list below shows the unique sessions</small>"
		variables.dump = createObject("java","coldfusion.runtime.SessionTracker").getSessionCollection(Application.applicationname);
		renderView(controller="system",action="templatesession")
		return;
	default:
		return render404();
	}
}

public any function testhtml5error() {
	throw(type="ExceptionType", message="Test Error Triggered",
		detail="This is a test of the HTML5 formatted error message",
		errorCode="HTML5", extendedInfo="Go back to continue.");
}

public any function softwaredashboard() {
	pageAbout.text = title = "System and software"
	pageAbout.icon = 'fal fa-hdd'
	breadcrumbs &= 'system & software'

	var lists = StructKeyList(get(myapp))
	lists = ListSort(lists,"text")
	var index = 0
	var apps = []
	cfloop(list=lists, index="local.list", delimiters=","){
		if(Left(list,4) != "apps") continue;
		if(list == "appssymlink") continue;
		if(!StructKeyExists(get(myapp)[list],'file')) continue;
		if(!Len(get(myapp)[list].file)) continue;
		index++
		apps[index] = []
		apps[index][1] = list
		apps[index][2] = ""
		apps[index][3] = ""
		apps[index][4] = ""
		apps[index][5] = ""
		apps[index][6] = ""
		if(StructKeyExists(get(myapp)[list],'name') && Len(get(myapp)[list].name)) apps[index][2] = get(myapp)[list].name;
		if(StructKeyExists(get(myapp)[list],'file') && Len(get(myapp)[list].file)) apps[index][3] = get(myapp)[list].file;
		if(StructKeyExists(get(myapp)[list],'www') && Len(get(myapp)[list].www)) apps[index][4] = get(myapp)[list].www;
		if(StructKeyExists(get(myapp)[list],'testCmd') && Len(get(myapp)[list].testCmd)) apps[index][5] = get(myapp)[list].testCmd;
		if(StructKeyExists(get(myapp)[list],'testOutputCnt') && Len(get(myapp)[list].testOutputCnt)) apps[index][6] = get(myapp)[list].testOutputCnt;
	}
	// Java information
	variables.java = serverJava()
	// Operating System info
	variables.os = serverOS()
	// Process applications
	index = 0
	variables.appGroup = []
	for (var app in apps) {
		index++
		appGroup[index].regname = app[1]
		appGroup[index].file = app[3]
		appGroup[index].name = app[2]
		appGroup[index].testOutputCnt = app[6]
		appGroup[index].testOutput = "Yes"
		if(!FileExists(appGroup[index].file)) {
			appGroup[index].testOutput = "ERROR: Application file does not exist"
		}
	}
	// application paths
	variables.paths = {
		"1":getbasetemplatepath(),
		"2":application.pathWwwRoot,
		"3":application.pathServingRoot,
		"4":GetTempDirectory(),
		"8":get(myapp).appsAnsilove.file,
		"9":get(myapp).appsgm.file,
		"10":Server.lucee.loaderPath,
	}
	// version values
	variables.versions = {
		"8":"",
		"9":"",
		"11":"",
	}
	try {
	execute
		name = paths.8
		arguments = "-v"
		timeout = get(myapp).timeoutAnsiLove
		variable = "variables.versions.8";
	}
	catch(any err) {}
	finally {
		if(listLen(versions.8, " ") > 1) versions.8 = listGetAt(versions.8, 2, " ");
	}
	try {
	execute
		name = paths.9
		arguments = ""
		timeout = get(myapp).timeoutImage
		variable = "variables.versions.9";
	}
	catch(any err) {}
	finally {
		if(listLen(versions.9, " ") > 1) versions.9 = listGetAt(versions.9, 2, " ") & " <small>" & listGetAt(versions.9, 3, " ") & "</small>";
	}
	// obtain font awesome version
	try {
		var file = FileOpen("/javascripts/fontawesome-all.min.js", "read");
		var read = FileRead(f, 30);
		FileClose(file);
		if(Len(read) > 5) versions.11 = Right(read,6)
	}
	catch(any err) {}
}

public any function testupload() {
	pageAbout.text = title = "Test file upload"
	pageAbout.icon = 'fal fa-upload'
	breadcrumbs &= 'test upload'
	variables.uploadedFile
	variables.uploadedMimeType
	try { variables.uploadedFile = fileUpload(destination=get(myapp).fulldirUploadFiles, fileField="fileName", nameConflict="makeunique"); }
	catch(any err);
	try { variables.uploadedMimeType = getPageContext().getServletContext().getMimeType("#uploadedFile.serverdirectory#/#uploadedFile.serverfile#") }
	catch(any err);
	// delete the file upload
	if(IsStruct(uploadedFile)) {
		var upload = "#get(myapp).fulldirUploadFiles#/#uploadedFile.serverfile#";
		if(FileExists("#upload#")) fileDelete(upload);
	}
}

public string function serverfreeram() {
	set(showDebugInformation=false);
	cfheader( name="Content-Type", value="application/json" )
	onlyProvides("json");
	var freeram = serverRAM().free;
	var jsontext = "error"
	if(len(freeram)) jsontext = humanizeFileSize(freeram*1024);
	renderText(SerializeJson(jsontext));
}

public string function serverfreehd() {
	set(showDebugInformation=false);
	cfheader( name="Content-Type", value="application/json" )
	onlyProvides("json");
	var freehd = serverDisk().free;
	var jsontext = "error"
	if(len(freehd)) jsontext =  humanizeFileSize(freehd*1024);
	renderText(SerializeJson(jsontext));
}
}