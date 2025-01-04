<!---
	Text mode (HTML3) controller
	path: controllers/Html3.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
function config() {
	filters(through="checkControllerState")
}

variables.delimiter = "|"

// file table columns to fetch / var tbl scopes the whole controller,
// local.select does not copy to functions
variables.tbl = {
	"order":"",
	"sections":"",
	"platforms":"",
	"select":"fileName,id,uuid,fileSize,date_issued_day,date_issued_month,date_issued_year,record_title,group_brand_for,group_brand_by,section,platform,createdat",
}
// create a list of allowed keys
tbl.platforms=model("File").findAll(select="platform",distinct=true,where="platform IS NOT NULL")
tbl.sections=model("File").findAll(select="section",distinct=true,where="section IS NOT NULL")

variables.filesizeSum = 0
variables.link = {
	"parent":urlFor(controller='html3'),
	"suffex":"",
	"torrent":"defacto2offlinecompiler=true",
	"wget":"wget=true",
}
suffex = function() {
	if(cgi.query_string contains link.wget) return "?#link.wget#";
	if(cgi.request_url contains link.wget) return "?#link.wget#";
	if(cgi.query_string contains link.torrent) return "?#link.torrent#"
	if(cgi.request_url contains link.torrent) return "?#link.torrent#"
	return ""
}
link.suffex = suffex()

/*
	* Creates URL strings and SQL ORDER BY code for file lists
	*/
private struct function _sort() {
	param name="params";
	param name="params.C" type="string" default="";
	var urls = {
		"date"="C=D;O=A",
		"desc"="C=I;O=A",
		"name"="C=N;O=A",
		"post"="C=P;O=D",
		"size"="C=S;O=A",
	}
	urls.columnorder = dynamicSqlFileOrder(params.C);
	if (params.C == "N;O=D") urls.name = "C=N;O=A";
	else if (params.C == "N;O=A") urls.name = "C=N;O=D";
	else if (params.C == "D;O=A") urls.date = "C=D;O=D";
	else if (params.C == "D;O=D") urls.date = "C=D;O=A";
	else if (params.C == "S;O=A") urls.size = "C=S;O=D";
	else if (params.C == "S;O=D") urls.size = "C=S;O=A";
	else if (params.C == "I;O=A") urls.desc = "C=I;O=D";
	else if (params.C == "I;O=D") urls.desc = "C=I;O=A";
	else if (params.C == "P;O=A") urls.post = "C=P;O=D";
	else if (params.C == "P;O=D") urls.post = "C=P;O=A";
	switch(cgi.script_name) {
		case '/index.cfm':
			var uri = trim('/index.cfm?#cgi.query_string#&')
			uri = replaceNoCase(uri, '&C=N;O=D', '', 'all')
			uri = replaceNoCase(uri, '&C=N;O=A', '', 'all')
			uri = replaceNoCase(uri, '&C=D;O=D', '', 'all')
			uri = replaceNoCase(uri, '&C=D;O=A', '', 'all')
			uri = replaceNoCase(uri, '&C=S;O=D', '', 'all')
			uri = replaceNoCase(uri, '&C=S;O=A', '', 'all')
			uri = replaceNoCase(uri, '&C=I;O=D', '', 'all')
			uri = replaceNoCase(uri, '&C=I;O=A', '', 'all')
			uri = replaceNoCase(uri, '&C=P;O=D', '', 'all')
			uri = replaceNoCase(uri, '&C=P;O=A', '', 'all')
			urls.name = uri & urls.name
			urls.date = uri & urls.date
			urls.size = uri & urls.size
			urls.desc = uri & urls.desc
			urls.post = uri & urls.post
			break;
		default:
			var uri = '?'
			urls.name = uri & urls.name
			urls.date = uri & urls.date
			urls.size = uri & urls.size
			urls.desc = uri & urls.desc
			urls.post = uri & urls.post
	}
	return urls;
}

/*
	* Creates URL strings and reorder for section and platform lists
	*/
private struct function _sortDirs() {
	param name="params";
	param name="params.C" default="";
	var sorts = { listOfResults="", name="" }
	if (params.C == "N;O=D") {
		sorts.listOfResults = ListSort(listOfResults,"textnocase","desc",delimiter)
		sorts.name = "C=N;O=A"
	}
	else {
		sorts.listOfResults = ListSort(listOfResults,"textnocase","asc",delimiter)
		sorts.name = "C=N;O=D"
	}
	sorts.name = sortQuery(sorts.name)
	return sorts;
}

/*
	* Creates URL strings and reorder for a list of organisation
	*/
private struct function _sortGroups() {
	param name="params";
	param name="params.C" default="";
	var sorts = { listOfResults=listOfResults, name="" }
	if (params.C == "N;O=D") {
		sorts.listOfResults = ListSort(listOfResults,"textnocase","desc",delimiter)
		sorts.name = "C=N;O=A"
	}
	else {
		sorts.listOfResults = ListSort(listOfResults,"textnocase","asc",delimiter)
		sorts.name = "C=N;O=D"
	}
	sorts.name = sortQuery(sorts.name)
	return sorts;
}

private any function _listdirs() {
	param name="params";
	param name="params.wget" type="boolean" default=false;
	param name="params.defacto2offlinecompiler" type="boolean" default=false;
	if(params.action == "groups") {
		page = "listgroups";
		renderView(action='listgroups')
		return;
	}
	try {
		if(params.wget || params.defacto2offlinecompiler) page = "wgetdir";
	} catch(any e) {}
	renderView(action='listdirs')
}

private any function _listfiles() {
	param name="params";
	param name="params.wget" type="boolean" default=false;
	param name="params.defacto2offlinecompiler" type="boolean" default=false;
	try {
		if(params.wget || params.defacto2offlinecompiler) page = "wgetfile";
	} catch(any e) {}
	renderView(action='listfile')
}

/**
 * Returns a list of groups and organisations from `query.pubcombined` data then remove all co-group listings
 * For example "Tristar, Titan" would be listed as "Tristar","Titan".
 *
 * @Groups Query of groups
 * @delimiter List item seperator
 */
private string function _groupsListed(required query groups, required string delimiter=",") {
	if(!queryColumnExists(groups, "pubCombined")) return ""
	if(!groups.recordCount) return ""
	// convert query to a list with a comma delimiter
	var list = valueList(groups.pubCombined)
	// remove prefixed whitespace
	list = replaceNoCase(list,", ",",","all")
	// drop duplicated items
	list = listRemoveDuplicates(list)
	if(arguments.delimiter != ",") {
		list = listChangeDelims(list, arguments.delimiter)
	}
	return list
}

function index() {
	params.section = "-"
	params.platform = "-"
	variables.count = {
		"art":0,
		"document":0,
		"software":0,
	}
	// count documents
	params.key = "document"
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	count.document = model("Files").count(where="#sql.whereState#",includeSoftDeletes=false)
	// count software
	params.key = "software"
	sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	count.software = model("Files").count(where="#sql.whereState#",includeSoftDeletes=false)
	// count art
	params.key = "visual"
	sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	count.art = model("Files").count(where="#sql.whereState#",includeSoftDeletes=false)
	// reset key
	params.key = ""
}

function art() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	variables.sort = _sort(params.C)
	//dynamicSqlFileOrder
	params.key = "visual"
	params.section = "-"
	params.platform = "-"
	tbl.values="#params.key#"
	// fetch database records
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	if(sql.wherestate == "") return render404();
	StructDelete(params,"key")
	variables.records = model("Files").findAll(where=sql.whereState,order=sort.columnorder,select=tbl.select,includeSoftDeletes=false)
	// render page
	_listfiles()
}

function category() {
	param name="params";
	param name="params.C" type="string" default="N;0=D";
	if(!structKeyExists(params, "key")) return render404();
	if(!Len(params.key)) return render404();
	variables.sort = _sort(params.C)
	params.section = params.key
	params.platform = "-"
	params.key = "" // blanking this is important
	tbl.values = ""
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	if(sql.wherestate == "") return render404();
	variables.records = model("Files").findAll(where=sql.whereState,order=sort.columnorder,select=tbl.select,includeSoftDeletes=false)
	params.key = params.section
	link.parent = urlFor(controller='html3',action='categories')
	_listfiles()
}
function platform() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	if(!structKeyExists(params, "key")) return render404();
	if(!Len(params.key)) return render404();
	variables.sort = _sort(params.C)
	params.section = "-"
	params.platform = params.key
	params.key = "" // blanking this is important
	tbl.values = ""
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	if(sql.wherestate == "") return render404();
	variables.records = model("Files").findAll(where=sql.whereState,order=sort.columnorder,select=tbl.select,includeSoftDeletes=false)
	params.key = params.platform
	link.parent = urlFor(controller='html3',action='platforms')
	_listfiles()
}

function categories() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	variables.listOfResults = ""
	loop list="#ValueList(tbl.sections.section,delimiter)#" index="local.section" delimiters=delimiter {
		var name = getSectionName(section)
		if(name == "") continue;
		listOfResults &= "|#name#:#section#"
	}
	variables.sort = _sortDirs()
	_listdirs()
}
function platforms() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	variables.listOfResults = ""
	loop list="#ValueList(tbl.platforms.platform,delimiter)#" index="local.platform" delimiters=delimiter {
		var name = getPlatformName(platform)
		if(name == "") continue;
		listOfResults &= "|#name#:#platform#"
	}
	variables.sort = _sortDirs()
	_listdirs()
}

function documents() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	variables.sort = _sort(params.C)
	params.key = "document"
	params.section = "-"
	params.platform = "-"
	tbl.values=params.key
	// fetch database records
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	if(sql.wherestate == "") return render404();
	StructDelete(params,"key")
	variables.records = model("Files").findAll(where=sql.whereState,order=sort.columnorder,select=tbl.select,includeSoftDeletes=false)
	_listfiles()
}

function testhtml3error() {
	if(StructKeyExists(session, 'op')) {
		throw(type="ExceptionType",
			message="Test Error Triggered",
			detail="This is a test of the HTML3 formatted error message",
			errorCode="HTML3", extendedInfo="Go back to continue.");
	} else return render404();
}

function group() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	if(!structKeyExists(params, "key")) return render404();
	if(!Len(params.key)) return render404();
	variables.sort = _sort(params.C)
	params.section = params.key
	params.platform = "-"
	tbl.values=""
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	if(sql.wherestate == "") return render404();
	variables.records = model("Files").findAll(where=sql.whereState,order=sort.columnorder,select=tbl.select,includeSoftDeletes=false)
	link.parent = urlFor(controller='html3',action='groups')
	_listfiles()
}



function groups() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	// fetch database records and convert to list
	var groups = model("Organisation").getGroups(includeSoftDeletes=false)
	listOfResults = _groupsListed(groups,delimiter)
	groups = queryNew("") // empty the groups
	variables.sort = _sortGroups()
	_listdirs()
}

function software() {
	param name="params";
	param name="params.C" type="string" default="N;O=A";
	variables.sort = _sort(params.C)
	params.key = "software"
	params.section = "-"
	params.platform = "-"
	tbl.values=params.key
	// fetch database records
	var sql = dynamicSqlForFile(params,tbl.sections,tbl.platforms)
	if(sql.wherestate == "") return render404();
	StructDelete(params,"key")
	variables.records = model("Files").findAll(where=sql.whereState,order=sort.columnorder,select=tbl.select,includeSoftDeletes=false)
	// render page
	_listfiles()
}

}