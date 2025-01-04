<!---
	People controller file.
	path: controllers/Person.cfc
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

	breadcrumbs &= appendCrumb(2, 'people', urlFor(controller='person',action='index'))

	variables.includeSoftDeletes = opCheck('sysop')

	function index() {
		redirectTo(route="personList")
	}

	function fileList() {
		param name="params";
		param name="params.personname" default="";
		param name="params.output" default=get(myapp).reset.FileList.output;
		param name="params.platform" default="-";
		param name="params.section" default="-";
		param name="params.sort" default=get(myapp).reset.FileList.sort;
		param name="params.perPage" default=get(myapp).reset.FileList.perpage;
		param name="params.page" default="1";
		// legacy URI redirect
		if(listLen(list=cgi.path_info,delimiters="/") >= 3) redirectTo(route="p",personname=params.personname,statusCode="301");
		// Sorting values re-factor and redirection
		if(listFindNoCase("date,posted,title",params.sort)) {
			switch(params.sort) {
				case "date": params.sort = "date_asc"; break;
				case "posted": params.sort = "posted_desc"; break;
				case "title": params.sort = "title_asc"; break;
			}
			redirectTo(route="p",personname=params.personname,statusCode="301",params="output=#params.output#&platform=#params.platform#&section=#params.section#&sort=#params.sort#&perpage=#params.perpage#&page=#params.page#");
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
		// dynamic title and header
		breadcrumbs &= crumbTrail(params, 3, params.personname)
		var citename = organisationFormat(deobfuscateURL(params.personname))
		variables.heading = citename
		description = '#citename# file collection'
		title = citename
		// file table columns to fetch
		var select = "comment,createdAt,credit_program,credit_illustration,credit_audio,credit_text,file_zip_content,"
		select &= "fileName,preview_image,fileSize,file_security_alert_url,id,group_brand_by,record_title,"
		select &= "group_brand_for,date_issued_day,date_issued_month,date_issued_year,platform,section,uuid,"
		select &= "web_id_youtube,deletedat,deletedby,updatedby,web_id_github";
		// determine which records to fetch
		var sql = dynamicSqlForFile(params,sections,platforms)
		sql.backetless = sqlPerson(deobfuscateURL(params.personname))
		sql.bracketed = " AND (#sql.backetless#)"
		variables.collectionFilesCount=0
		if(params.personname contains "-and-") {
			// conversion from '&' to 'and'
			collectionFilesCount = model("Files").count(where=sql.backetless,includeSoftDeletes=includeSoftDeletes)
			// 2nd retry for persons using the & symbol
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

		// format of the list of results to be displayed
		variables.partialToDisplay = filePartialToDisplay()
		if(collectionFiles.recordCount == 0) return render404();
		renderView(controller="file",action="list");
	}

	function list() {
		param name="params.key" default="-";
		var keys = "-,artists,coders,musicians,writers"
		if(!ListFindNocase(keys, params.key)) return render404();
		title = get("siteAreas").titles.person
		description = 'A list of scene members'
		if(params.key != "-") {
			var crumb = LCase(params.key)
			title = capitalize(params.key)
			description = 'A list of scene #crumb#'
			breadcrumbs &= appendCrumb(3, crumb, urlFor(route='personFilter', key=params.key))
		}
		canonical = "/people/list/-"
		// fetch count of records
		var persons = model("Person").getPeople(key=params.key,returnAs="query",includeSoftDeletes=includeSoftDeletes)
		variables.creditslist = valueList(persons.pubCombined)
		creditsList = listRemoveDuplicates(list=creditslist,ignoreCase=true)
		creditslist = ListSort(creditslist,"textnocase","asc")
	}
}