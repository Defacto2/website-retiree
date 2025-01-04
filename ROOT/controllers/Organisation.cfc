<!---
	Groups controller file.
	path: controllers/Organisation.cfc
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

	breadcrumbs &= appendCrumb(2, 'groups', urlFor(controller='organisation',action='index'))
	includeSoftDeletes = opCheck('sysop')

	// work around for the key value `model` that throws an error with cfwheels
	if(cgi.path_info == '/organisation/model') {
		redirectTo(route="organisationFilter", key="model_")
	}

	function index() {
		redirectTo(route="organisationFilter",key="group")
	}

	function fileList() {
		param name="params.orgname" default="";
		param name="params.output" default=get(myapp).reset.FileList.output;
		param name="params.platform" default="-";
		param name="params.section" default="-";
		param name="params.sort" default=get(myapp).reset.FileList.sort;
		param name="params.perPage" default=get(myapp).reset.FileList.perpage;
		param name="params.page" default="1";
		// work around for the key value `model`
		if(params.orgname == 'model_') params.orgname = 'model'
		// legacy URI redirect
		if(listLen(list=cgi.path_info,delimiters="/") >= 3) redirectTo(route="g",orgname=params.orgname,statusCode="301");
		if(params.orgname contains "+") {
			params.orgname = replace(params.orgname,"+","*","all")
			redirectTo(route="g",orgname=params.orgname,statusCode="301");
		}
		// Sorting values re-factor and redirection
		if(listFindNoCase("date,posted,title",params.sort)) {
			switch(params.sort) {
				case "date": params.sort = "date_asc"; break;
				case "posted": params.sort = "posted_desc"; break;
				case "title": params.sort = "title_asc"; break;
			}
			redirectTo(route="g",orgname=params.orgname,statusCode="301",params="output=#params.output#&platform=#params.platform#&section=#params.section#&sort=#params.sort#&perpage=#params.perpage#&page=#params.page#");
		}
		var sections=model("Files").findAll(select="section",distinct=true,includeSoftDeletes=includeSoftDeletes)
		var platforms=model("Files").findAll(select="platform",distinct=true,includeSoftDeletes=includeSoftDeletes)
		var urlCheck = function() {
			if(!ListFindNocase(get(myapp).displayValues,params.output)) return false;
			if(!params.platform == "-" && !ListFindNocase(ValueList(platforms.platform),params.platform)) return false;
			if(!params.section == "-" && !ListFindNocase(ValueList(sections.section),params.section)) return false;
			if(!ListFindNocase(get(myapp).orderValues,params.sort)) return false;
			if(!IsNumeric(params.perPage)) params.perPage = get(myapp).maxPageItems;
			if(params.perPage > get(myapp).maxPageItems) params.perPage = get(myapp).maxPageItems;
			if(!IsNumeric(params.page)) return false;
			if(params.page == 0) return false;
			return true
		}
		if(!urlCheck()) return render404();

		onlyProvides("html");
		params.key = "-"
		variables.collectionMenuData = menuItems('filecollection',params.key)
		variables.citename = organisationFormat(deobfuscateURL(params.orgname))
		description = '#citename# file collections'
		var crumb = function() {
			if(Right(citename,4) == ' BBS') return appendCrumb(3, 'BBS', urlFor(route='organisationFilter',key='bbs')) & crumbTrail(params, 4, replace(params.orgname,' BBS',''))
			if(Right(citename,4) == ' FTP') return appendCrumb(3, 'FTP', urlFor(route='organisationFilter',key='ftp')) & crumbTrail(params, 4, replace(params.orgname,' FTP', ''))
			return crumbTrail(params, 3, params.orgname)
		}
		breadcrumbs &= crumb()
		heading = citename
		title = citename
		// file table columns to fetch
		select = "comment,createdAt,credit_program,credit_illustration,credit_audio,credit_text,file_zip_content,fileName,preview_image,fileSize,"
		select &= "file_security_alert_url,id,group_brand_by,record_title,group_brand_for,date_issued_day,date_issued_month,date_issued_year,"
		select &= "platform,section,uuid,web_id_youtube,deletedat,deletedby,updatedby,web_id_github"
		values = params.key
		// determine which records to fetch
		var sql = dynamicSqlForFile(params,sections,platforms)
		sql.backetless = sqlOrganisation(deobfuscateURL(params.orgname))
		sql.bracketed = " AND (#sql.backetless#)"
		variables.collectionFilesCount=0
		if(params.orgname contains "-and-") {
			// conversion from '&' to 'and'
			collectionFilesCount = model("Files").count(where=sql.backetless,includeSoftDeletes=includeSoftDeletes)
			// 2nd retry for groups using the & symbol
			if(collectionFilesCount == 0) {
				sql.backetless = ReplaceNoCase(sql.backetless,' & ',' and ','all')
				sql.bracketed = " AND (#sql.backetless#)"
			}
		}
		if(!Len(sql.whereState)) sql.whereState = sql.backetless;
		else sql.whereState = sql.whereState & sql.bracketed;

		// fetch records for display
		var order = dynamicSqlFileOrder(params.sort)
		collectionFilesCount = model("Files").count(where="#sql.whereState#",includeSoftDeletes=includeSoftDeletes)
		if(params.sort contains "title") collectionFiles = model("file").listFilesSortedAZ(where="#sql.whereState#",page=params.page,perPage=params.perPage,order=order,includeSoftDeletes=includeSoftDeletes);
		else collectionFiles = model("Files").findAll(where="#sql.whereState#",page=params.page,perPage=params.perPage,order=order,select=select,includeSoftDeletes=includeSoftDeletes);

		// fetch the most recent created and updated dates
		var uat = model("File").findOne(where="#sql.whereState#",order="updatedAt DESC",select="updatedAt",includeSoftDeletes=includeSoftDeletes);
		if(isObject(uat)) variables.collectionUpdate = uat.updatedAt;
		var cat = model("File").findOne(where="#sql.whereState#",order="createdAt DESC",select="createdAt",includeSoftDeletes=includeSoftDeletes);
		if(isObject(cat)) variables.collectionUpload = cat.createdAt

		// use distinct, organisation or group name for exact printing with formatting
		variables.exactName = model("person").searchGroups(variables.citename,false)
		if(Len(variables.exactName.tagName) gte 1) {
			heading = variables.exactName.tagName
			title = heading
			description = '#heading# file collections'
		}

		// format of the list of results to be displayed
		partialToDisplay = filePartialToDisplay()
		if(collectionFiles.recordCount == 0) return render404();
		renderView(controller="file",action="list");
	}

	function list() {
		param name="params.key" default="";
		var keys = "bbs,ftp,group,magazine"
		if(!ListFindNocase(keys, params.key)) return render404();
		onlyProvides("html")
		title = get("siteAreas").titles.organisation
		description = 'A list of all groups and organisations'
		var crumb = ''
		switch(params.key) {
			case 'bbs': title = crumb = 'Bulletin Board Sites'; break;
			case 'ftp': title = crumb = 'Internet FTP sites'; break;
			case 'group': title = 'Scene groups'; break;
			case 'magazine': title = 'Magazines'; break;
			default: title = 'Groups ' & get('myapp')['menuorganisation#params.key#'].name; break;
		}
		if(len(crumb) == 0) crumb = LCase(title)
		breadcrumbs &= appendCrumb(3, crumb, urlFor(route='organisationFilter', key=params.key))
		description = 'A list of #LCase(title)#'
		if(params.key == 'bbs') description &= ' (BBS)'
		if(params.key == 'ftp') description &= ' (FTP)'
		canonical = "/organisation/list/-"
	}
}