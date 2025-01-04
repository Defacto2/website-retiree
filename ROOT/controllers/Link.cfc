<!---
	Scene websites controller file.
	path: controllers/Link.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="checkControllerState")
		filters(through="sysopGiveAccess",only="add,edit,httpreset,new,operator,update")
		filters(through="render404",only="_navigate")
	}

	breadcrumbs &= appendCrumb(2, 'scene sites', urlFor('linkList'))
	description = "A list of scene web sites"

	variables.includeSoftDeletes = opCheck("sysop")

	function index() {
		redirectTo(route='linkList', statusCode="301")
	}

	private void function _saveError() {
		flashInsert(danger="Record could not be saved");
	}

	private struct function _navigate(numeric id, boolean includeSoftDeletes=false, boolean enable=false) {
		if(!arguments.enable) return render404();
		var nav = {
			"idPosition":0,
			"idCount":0,
			"next":"",
			"previous":"",
		};
		var query = model("Link").findAll(select="id", includeSoftDeletes=arguments.includeSoftDeletes, maxRows="-1");
		var ids  = ValueList(query.id)
		nav.idCount = ListLen(ids)
		// position of current record in query
		nav.idPosition = ListFind(ids,arguments.id)
		nav.idCount = ListLen(ids)
		// fetch id of next record
		if(nav.idPosition < ListLen(ids)) nav.next = ListGetAt(ids,nav.idPosition+1);
		// fetch id of previous record
		if(nav.idPosition > 1) nav.previous = ListGetAt(ids,nav.idPosition-1);
		return nav;
	}

	function add() {
		onlyProvides("html")
		title = "Add new site"
		breadcrumbs &= appendCrumb(4, 'add', urlFor(controller='link',action='add'))
		variables.website = model("Link").new()
		variables.categoryKeys = model("Link").findAll(select="categorykey",where="categorykey IS NOT NULL",distinct=true,includeSoftDeletes=true);
		variables.categorySorts = model("Link").findAll(select="categorysort",where="categorysort IS NOT NULL",distinct=true,includeSoftDeletes=true);
		// form submissions goes to new()
	}

	function delete() {
		param name="params";
		param name="params.key" default="-";
		params.uuid = LCase(params.uuid)
		if(!StructKeyExists(params,"confirm")) redirectTo(controller="Link",action="edit",key="#params.key#");
		if(!params.confirm) redirectTo(controller="Link",action="edit",key="#params.key#");

		variables.website = model("Link").findOneByUuid(value=params.uuid,includeSoftDeletes=includeSoftDeletes)
		website.uuid = LCase(website.uuid)
		website.delete(softDelete="false")
		flashInsert(success="The website '#params.title#' (#params.uuid#) is gone")
		redirectTo(route="linkList",params="sort=date")
	}

	function edit() {
		param name="params.key" default="-";
		website = model("Link").findByKey(key=deObfuscateParam(params.key),includeSoftDeletes=includeSoftDeletes)
		website.uuid = LCase(website.uuid)
		title = "Edit #website.title# site"
		variables.categoryKeys = model("Link").findAll(select="categorykey",where="categorykey IS NOT NULL",distinct=true,includeSoftDeletes=true)
		variables.categorySorts = model("Link").findAll(select="categorysort",where="categorysort IS NOT NULL",distinct=true,includeSoftDeletes=true)
		variables.navigation = _navigate(id=website.id,includeSoftDeletes=includeSoftDeletes,enable=true)
		// form submissions goes to update()
	}

	function httpreset() {
		param name="params";
		param name="params.uuid" default="";
		params.uuid = LCase(params.uuid)

		variables.website = model("Link").findOneByUuid(value=params.uuid,includeSoftDeletes=includeSoftDeletes)
		variables.categoryKeys = model("Link").findAll(select="categorykey",where="categorykey IS NOT NULL",distinct=true,includeSoftDeletes=true)
		variables.categorySorts = model("Link").findAll(select="categorysort",where="categorysort IS NOT NULL",distinct=true,includeSoftDeletes=true)
		if(IsBoolean(website) && !website) {
			_saveError()
			redirectTo(controller="link",action="edit",key=params.key)
		}
		variables.navigation = _navigate(id=website.id,includeSoftDeletes=includeSoftDeletes,enable=true)
		// erase all HTTP response data sourced from pinging
		website.uuid = params.uuid
		website.httpstatuscode = ""
		website.httpstatustext = ""
		website.httplocation = ""
		website.httpetag = ""
		website.httplastmodified = ""
		website.metadescription = ""
		website.metatitle = ""
		website.metaauthors = ""
		website.metakeywords = ""
		website.save()
		// redirect to file detail page to show the new changes --->
		if(website.hasErrors()) {
			flashInsert(danger="Record #deObfuscateParam(params.key)# HTTP response could not be reset")
			flashInsert(danger=website.allErrors())
			redirectTo(controller="link",action="edit",key=params.key)
		}
		flashInsert(success="HTTP response has been reset")
		renderView(controller="link",action="edit",key=params.key)
	}

	function list() {
		param name="params.page" default="1";
		param name="params.perPage" default="50";
		param name="params.key" default="-";
		param name="params.sort" default="category";
		// legacy redirects
		if(listLen(list=cgi.path_info,delimiters="/") >= 4) redirectTo(route="linkFilter",key=params.key,statusCode="301");
		// custom uri redirects
		if(params.key == "new") {
			params.page = 1
			if(params.perPage == 0) params.page = 0;
			redirectTo(route="linkList",statusCode="307",params="sort=date&perpage=#params.perPage#&page=#params.page#")
		}
		// check key validity
		if(params.key != '-' && !structKeyExists(get(myapp), 'menuwww#params.key#')) return render404();
		// reset key when view all
		if(structKeyExists(params,"route") && params.route == "linkList") params.key = "-";
		var urlCheck = function() {
			if(!IsNumeric(params.page)) return false;
			if(!IsNumeric(params.perPage)) return false;
			if(!ListFindNocase("0,50",params.perPage)) return false;
			if(params.perPage == 0 && params.page != 0) return false;
			if(params.perPage != 0 && params.page == 0) return false;
			if(!ListFindNocase('category,date,title,status',params.sort)) return false;
			var keys = "-,ansi,bbs,cracktro,document,history,mainstream,sceneGroup,wikipedia"
			if(opCheck('coop')) keys &= ",disabled,statuserrors";
			if(!ListFindNocase(keys,params.key)) return false;
			if(ListFindNocase('status',params.sort) && !opCheck('op')) return false;
			return true
		}
		if(!urlCheck()) return render404();
		// bread crumb navigation
		if(params.key != '-') breadcrumbs &= appendCrumb(3, LCase(get(myapp)['menuwww#params.key#'].name), URLFor(key=params.key));
		// generate data for the dynamic menus
		collectionMenuData = menuItems('www',params.key)
		switch(params.key) {
			case '-':
				header = "#get('siteAreas').titles.link#"
				title = "#get('siteAreas').titles.link#"
				break;
			case 'statuserrors':
				header = title = "#get('siteAreas').titles.link# with HTTP"
				break;
			default:
				header = "#get('siteAreas').titles.link#"
				title = "#get('siteAreas').titles.link# #LCase(get(myapp)['menuwww#params.key#'].name)#"
		}
		// create table structure
		var select="comment, id, uuid, categorykey, metadescription, metatitle, categorySort, title,
		date_issued_year, date_issued_month, date_issued_day, httpstatuscode, httpstatustext, httplocation, uriref,	createdat, deletedatcomment, deletedat";
		var values = params.key
		// sort records
		var sort = function() {
			switch(params.sort) {
				case "category": return "categorySort ASC,title ASC";
				case "date": return "createdAt DESC";
				case "status": return "httpstatuscode DESC";
				case "title":
					if(params.key == 'wayback') return "uriRef ASC";
					return "title ASC";
				default: return ""
			}
		}
		var order = sort()
		// where statement
		var where = "categoryKey='#params.key#'"
		// fetch records
		variables.website
		variables.websiteCount = 0
		switch(params.key) {
			// filter by primary categories
			case "ansi": case "bbs": case "cracktro": case "document": case "history": case "mainstream": case "sceneGroup": case "wikipedia":
				websiteCount = model("Link").count(where=where,includeSoftDeletes=includeSoftDeletes);
				website = model("Link").findAll(page=params.page,perPage=params.perPage,value=values,order=order,select=select,where=where,includeSoftDeletes=includeSoftDeletes);
			break;
			case "disabled":
				websiteCount = model("Link").count(where="deletedat IS NOT NULL",includeSoftDeletes=includeSoftDeletes);
				website = model("Link").findAll(page=params.page,perPage=params.perPage,value=values,order=order,select=select,where="deletedat IS NOT NULL",includeSoftDeletes=includeSoftDeletes);
			break;
			case "statuserrors":
				websiteCount = model("Link").count(where="httpstatuscode >= 202",includeSoftDeletes=includeSoftDeletes);
				website = model("Link").findAll(page=params.page,perPage=params.perPage,value=values,order=order,select=select,where="httpstatuscode >= 202",includeSoftDeletes=includeSoftDeletes);
			break;
			// no filter
			default:
				websiteCount = model("Link").count(includeSoftDeletes=includeSoftDeletes);
				website = model("Link").findAll(page=params.page,perPage=params.perPage,order=order,select=select,includeSoftDeletes=includeSoftDeletes,result="websiteinfo")
			break;
		}
		// assume invalid URL was provided if no websites are returned
		if(!website.recordCount) return render404();
	}

	function new() {
		param name="params";
		param name="params.newCategoryKey" default="";
		param name="params.newCategorySort" default="";
		onlyProvides("html")
		title = "Add new link"
		// Fetch a list of categories
		variables.categoryKeys = model("Link").findAll(select="categorykey",where="categorykey IS NOT NULL",distinct=true,includeSoftDeletes=includeSoftDeletes);
		variables.categorySorts = model("Link").findAll(select="categorysort",where="categorysort IS NOT NULL",distinct=true,includeSoftDeletes=includeSoftDeletes);
		// Create a new record based on supplied form submission
		variables.website = model("Link").new(params.website);
		// Create blank form values if they were not supplied by form
		if(!StructKeyExists(website,'uriref')) website.uriref = ""
		if(!StructKeyExists(website,'title')) website.title = ""
		if(!StructKeyExists(website,'date_issued_year')) website.date_issued_year = ""
		if(!StructKeyExists(website,'date_issued_month')) website.date_issued_month = ""
		if(!StructKeyExists(website,'date_issued_day')) website.date_issued_day = ""
		if(!StructKeyExists(website,'comment')) website.comment = ""
		if(!StructKeyExists(website,'categorykey')) website.categorykey = ""
		if(!StructKeyExists(website,'categorysort')) website.categorysort = ""
		// Create blank or default variables
		website.deletedAt = CreateODBCDateTime(Now()) // For security disable new upload using a soft delete
		// these changes need to be after update otherwise they're overwritten
		if(!Len(params.website.categorysort) && Len(params.newCategorySort)) website.updateProperty("categorysort", '#params.newCategorySort#');
		if(!Len(params.website.categorykey) && Len(params.newCategoryKey)) website.updateProperty("categorykey", '#params.newCategoryKey#');
		// trim trailing forward slash /
		if(Right(website.uriRef,1) == "/") website.uriRef = Left(website.uriRef,(Len(website.uriRef)-1));
		website.save();
		// redirect to file detail page to show the new changes
		if(website.hasErrors()) {
			_saveError()
			flashInsert(danger=website.allErrors())
			renderView(action="add")
			return
		}
		flashInsert(success="Saved record #website.id#");
		redirectTo(route="linkList",params="sort=date")
	}

	function operator() {
		param name="params";
		params.uuid = LCase(params.uuid)

		var website = model("Link").findOneByUuid(value=params.uuid,includeSoftDeletes=includeSoftDeletes)
		website.uuid = LCase(website.uuid)
		local.nameforflash = LCase(params.function);
		switch(params.function){
			case "Disable":
				website.updateProperty("deletedat",Now());
			break;
			case "Restore":
			case "Approve":
				website.updateProperty("deletedat","");
			break;
			default:
				flashInsert(danger="operator function '#params.function#'' is invalid");
				redirectTo(controller="link",action="edit",key=params.key);
		}
		website.save();
		if(website.hasErrors()) {
			_saveError();
			flashInsert(danger="#website.allErrors()#")
		}
		else flashInsert(success="Saved record #deObfuscateParam(params.key)#");
		// redirect to file detail page to show the new changes
		redirectTo(controller="link",action="edit",key=params.key);
	}

	function update() {
		param name="params";
		params.uuid = LCase(params.uuid)
		var website = model("Link").findOneByUuid(value=params.uuid,includeSoftDeletes=includeSoftDeletes)
		website.uuid = LCase(website.uuid)
		title = "Update #website.title# site"
		// form date conversion
		website.date_issued_day = params.date_issued_day ?: ""
		website.date_issued_month = params.date_issued_month ?: ""
		website.date_issued_year = params.date_issued_year ?: ""
		// update all other params
		website.update(params.website)
		// update categorysort & categorykey with custom input / needs to be after update otherwise it will be overwritten
		if(!Len(params.website.categorysort) && Len(params.newCategorySort)) website.updateProperty("categorysort", '#params.newCategorySort#');
		if(!Len(params.website.categorykey) && Len(params.newCategoryKey)) website.updateProperty("categorykey", '#params.newCategoryKey#');
		// trim trailing forward slash /
		if(Right(website.uriRef,1) == "/") website.uriRef = Left(website.uriRef,(Len(website.uriRef)-1));
		// automatic approval on save
		if(params.savefunction contains "approve") website.deletedat = "";
		website.save();
		// redirect to file detail page to show the new changes
		if(website.hasErrors()) {
			_saveError();
			flashInsert(danger="#website.allErrors()#")
			renderView(controller="link",action="edit",key=params.key);
			return
		}
		flashInsert(success="Saved record #deObfuscateParam(params.key)#");
		redirectTo(controller="link",action="edit",key=params.key);
	}

	function visit() {
		param name="params.key" default="-";
		try {
			variables.website = model("Link").findByKey(select="uriRef",key=deObfuscateParam(params.key),includeSoftDeletes=includeSoftDeletes,returnAs='query');
		} catch(any err) {
			return render404();
		}
		if(!website.recordCount) return render404();
	}

	function wayback() {
		param name="params.key" default="-";
		try {
			variables.website = model("Link").findByKey(select="uriRef",key=deObfuscateParam(params.key),includeSoftDeletes=includeSoftDeletes,returnAs='query');
		} catch(any err) {
			return render404();
		}
		if(!website.recordCount) return render404();
	}
}