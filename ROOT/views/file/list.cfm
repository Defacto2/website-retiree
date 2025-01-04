<!---
    File list view.
	path: views/files/list.cfm

@CFLintIgnore
--->
<cfscript>
	param name="params.personname" default="";
	param name="params.orgname" default="";
	var disabled = "disabled"
	// generate search term
	var searchTerm = function() {
		var search = ""
		switch(params.controller) {
			case 'organisation':
				var name = deobfuscateURL(params.orgname)
				var where = "title LIKE '#Trim(name)#%'"
				websites = model("Link").findAll(select="id,categorysort,comment,date_issued_day,date_issued_month,date_issued_year,title,uriRef",where="#where#",sort="uriref DESC",returnAs="query",includeSoftDeletes="false")
				search = params.orgname
				break;
			case 'person':
				personsname = "#deobfuscateURL(params.personname)#"
				search = params.personname
				break;
			default:
		}
		var lastword = ListLast(search,'-')
		if(ListFindNocase('bbs,ftp',Trim(lastword))) search = ListDeleteAt(search,ListLen(search,'-'),'-');
		search = LCase(deobfuscateURL(search))
		return UrlEncodedFormat('"#search#"')
	}
	var sortVerbose = function() {
		if(params.sort == 'title') return 'name';
		if(params.sort == 'posted') return 'date posted';
		if(params.sort == 'date') return 'year published';
		return params.sort
	}
	var page0 = ""
	var page1 = ""
	var pageX = ""
	var pageZ = ""
	var uriStrings = function() {
		var route = ""
		if(params.controller == "person") route = "p";
		if(params.controller == "organisation") route = "g";
		if(params.controller == "file") {
			var v1 = params.action & params.controller & "Index"
			route = "fileFilter";
			if(structKeyExists(params,"route") && params.route != v1) {
				route = params.route;
			}
			if(route == "home") route = "fileFilter";
		}
		var urlQuery = "output=#params.output#&platform=#params.platform#&section=#params.section#&sort=#params.sort#&perpage=#params.perpage#&page=#params.page#"
		var base = URLFor(route="#route#",key=params.key,rel='nofollow',personname=params.personname,orgname=params.orgname,params=urlQuery)
		base = replaceListNoCase(base, '&page=1', '')
		base = replaceListNoCase(base, '&perpage=1', '')
		page0 = replaceNoCase(base,'&page=#params.page#','&page=#pages.previous#')
		page1 = replaceNoCase(base,'&page=#params.page#','&page=#pages.next#')
		if(!page1 contains "&page=") page1 &= "&page=2"
		pageX = replaceNoCase(base,'&page=#params.page#','&page=#pages.first#')
		pageZ = replaceNoCase(base,'&page=#params.page#','&page=#pages.last#')
		variables.uriBase = base
		if(!pageZ contains "&page=") pageZ &= "&page=#pages.last#"
		// initialism appending for organisation
		if(params.controller == "organisation") {
			initialisms = groupInitialism(deobfuscateURL(params.orgname))
			if(Len(initialisms)) {
				pageAbout.text = '<small>#initialisms#</small> #heading#'
				pageAbout.icon = 'fal fa-folder-open'
			}
		}
	}
	/* pagination results */
	pages = {
		"recordCnt":collectionFilesCount,
		"first":1,
		"previous":Ceiling(params.page-1),
		"next":Ceiling(params.page+1),
	}
	try {
		pages.last = pagination().totalpages;
	}
	catch(any err) {
		pages.last = 1;
	}
	pages.total = pages.last
	// cap page navigation
	if(pages.previous < 1) pages.previous = 1;
	if(pages.next > pages.total) pages.next = pages.total;
	// verbose sort-by
	pages.sortbyverbose	= sortVerbose()
	// fetch related websites
	variables.termforwebsearch = searchTerm()
	// navigation button highlights
	button.link.style = ""
	if(params.controller == "organisation" && websites.recordCount) button.link.style = 'border-color:##5cb85c;'
	// dynamic routes, button enable/disable status and query strings
	uriStrings()
	// the disabled state is used by javascript keyboard pagination and hammer.js touch gestures
	nav.btn.next = nav.btn.prev = nav.btn.first = nav.btn.last = nav.inf.status = ""
	if(params.page lte pages.first) nav.btn.prev = disabled;
	if(params.page gte pages.last) nav.btn.next = disabled;
	else nav.inf.status = " pagination__next"
	if(params.page == pages.first) nav.btn.first = disabled;
	if(params.page == pages.last) nav.btn.last = disabled;
	pageAbout.text = '#heading#'
	pageAbout.icon = 'fal fa-folder-open'
</cfscript>
<!--- HTML --->
<cfoutput>
	<span id="LastPageOfList" class="hidden">#pages.last#</span>
	<div class="btn-toolbar grouping nav-toolbar-container" role="toolbar">
	<form method="post">
		<span class="hidden">
			<!--- used by javascript pagination, should be kept hidden --->
			<button id="GotoFirstPage" #nav.btn.first# type="submit" formaction="#pageX#"></button>
			<button id="GotoLastPage" #nav.btn.last# type="submit" formaction="#pageZ#"></button>
			<button id="GotoPrevPage" #nav.btn.prev# type="submit" class="btn btn-default" rel="prev prefetch" formaction="#page0#" title="Go to the previous page (← arrow key)" data-toggle="tooltip" data-placement="top"><i class="fal fa-arrow-alt-left fa-lg"></i></button>
			<button id="GotoNextPage" #nav.btn.next# type="submit" class="btn btn-default#nav.inf.status#" rel="next prefetch" formaction="#page1#" title="Go to the next page (arrow key →)" data-toggle="tooltip" data-placement="top"><i class="fal fa-arrow-alt-right fa-lg"></i></button>
		</span>
	</form>
	</div>
	#includePartial('/file/list_nav-sort')#
	<cfif flashCount()>#flashMessages()#</cfif>
	<!--- list items infinite-scroll-last infinite-scroll-error--->
	<div class="files-container">#includePartial(partial="/file/#partialtodisplay#")#</div>
	<div class="page-load-status">
		<p class="infinite-scroll-request loader-ellipsis">
			<span class="loader-ellips__dot"></span>
			<span class="loader-ellips__dot"></span>
			<span class="loader-ellips__dot"></span>
			<span class="loader-ellips__dot"></span>
		</p>
	</div>
</cfoutput>