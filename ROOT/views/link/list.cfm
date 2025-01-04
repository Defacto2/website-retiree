<!---
  	Websites list view.
	path: views/link/list.cfm

@CFLintIgnore
--->
<cfscript>
	var noFollow = 'rel="nofollow"'
	var pageRoute = "linkFilter"

	var activeOrganisation = function(string item="") {
		if(arguments.item == "") return "";
		var key = listGetAt(arguments.item,1,'.')
		var value = ""
		if(len(arguments.item) > 1) value = listGetAt(arguments.item,2,'.')
		switch(key) {
			case "page":
				if (value == params.page) return active;
				return ""
			case "perpage":
				if (value == params.perpage) return active;
				return ""
			case "filter":
				if (value == params.key) return active;
				return ""
			case "info":
				if (value == "more" && !params.page) return "disabled";
				return ""
			default:
				return ""
		}
	}
	var activeMenu = function(string item="") {
		if(arguments.item == "") return "";
		var key = listGetAt(arguments.item,1,'.')
		var value = ""
		if(len(arguments.item) > 1) value = listGetAt(arguments.item,2,'.')
		switch(local.key) {
			case "page":
				if (value == params.page) return active
				return ""
			case "perpage":
				if (value == params.perpage) return active
				return ""
			case "sort":
				if (value == params.sort) return active
				return ""
			case "key":
				if (value == params.key) return active
				return ""
			default:
				return ""
		}
	}
	var collectionsMenu = function(required struct data) {
		var items = arguments.data
		items.menus = []
		//data.menus = []
		var menu = {
			"use":items.settingsPartVar,
			"args":arguments.data,
			"category":"",
			"categories":arguments.data.listofcategories,
			"comparision":"",
			"head":{
				"mode":"", // tmp.head
				"text":"", // tmp.headtxt
				"title":"", // tmp.headtitle
			},
			"menus":arguments.data.listofmenus,
			"page":1,
			"queryString":"",
		}
		if(StructKeyExists(params,'page') && !params.page) menu.page = 0;
		menu.queryString = "sort=#params.sort#&perpage=#params.perpage#&page=#menu.page#"
		items.menuwww = {
			"rel":"nofollow",
		}
		menu.head.mode = "collections"
		menu.head.text = "All #get('siteAreas').titles.link#"
		menu.head.title = "Display all the #get('siteAreas').titles.link# in our collection."
		items.header = menu.head.mode
		items.inactivetext = menu.head.text
		items.inactivetitle = menu.head.title
		// generate and return menus structured by category headers
		var index = 0
		for (menu.category in listToArray(menu.categories, ",")) {
			if(menu.comparision != menu.category) index++;
			// container for category name used for the header
			items.menus[index][1] = menu.category
			// container for HTML links for display under the category header
			items.menus[index][2] = ''
			// duplicate destructible data
			menu.comparision = menu.category
			// loop through category data containers
			for (var value in listToArray(menu.args[ReplaceNoCase(menu.category,' ','','all')])) {
				var search = StructFindValue(get(myapp),'#ListFirst(value,';')#','all')
				var identity = ""
				var text = ""
				var title = ""
				// generate an identifier for the current category
				for (var result in search) {
					if(result.path == ".#ListLast(value,';')#.name") {
						identity = ReplaceNocase(ListLast(value,";"),menu.use,'')
						continue;
					}
				}
				// format identifier
				identity = LCase(identity)
				// fetch the category's full title and description by searching for the category identifier in settings-menus.cfm
				if(StructKeyExists(get(myapp),'#menu.use##identity#')) {
					text = ReplaceNoCase(get(myapp)['#menu.use##identity#'].name,'&','+')
					title = ReplaceNoCase(get(myapp)['#menu.use##identity#'].description,'&','+')
				} else text = ReplaceNoCase(humanize(identity),'&','+');
				text = XMLFormat(capitalize(text))
			}
		}
		// return HTML and finish if categories are used otherwise continue on
		if(ArrayLen(items.menus) gte 1) return data;
		// generate menus that do not use categories
		items.menus[1][1] = "#menu.head.mode#"
		items.menus[1][2] = ''
		for (menu.category in listToArray(menu.menus, ";")) {
			var text = ""
			var title = ""
			menu.category = ListLast(menu.category,":")
			if(StructKeyExists(get(myapp),'#menu.use##menu.category#')) {
				text = ReplaceNoCase(Capitalize(get(myapp)['#menu.use##menu.category#'].name),'&','+')
				title = ReplaceNoCase(get(myapp)['#menu.use##menu.category#'].description,'&','+')
			} else text = ReplaceNoCase(humanize(menu.category),'&','+');
			routename = "linkFilter"
			items.menus[1][2] &= ";#menu.category#:" & linkTo(encode=false,route="#routename#",text=text,title=title,key=menu.category,argumentcollection=items.menuwww,params=menu.queryString)
		}
		return data
	}
	var buttons = function() {
		if(!params.page) {
			page.prev = page.next = page.first = page.last = "disabled"
			return
		}
		if(params.page lte pages.first) {
			page.prev = page.first = "disabled"
		}
		if(params.page gte pages.last) {
			page.next = page.last = "disabled"
		}
	}
	var itemClass = function() {
		if(website.recordCount lte params.perpage) return "onepage";
		if(!params.perpage) return "onepage";
		return "multiplepages"
	}
	var links = function() {
		if(params.key is "-") pageRoute = "linkList"
		page.pURL = URLFor(route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"&page=#params.page#","&page=#pages.previous#"))
		page.nURL = URLFor(route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"&page=#params.page#","&page=#pages.next#"))
		page.fURL = URLFor(route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"&page=#params.page#","&page=#pages.first#"))
		page.lURL = URLFor(route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"&page=#params.page#","&page=#pages.last#"))
	}
	var pageLimits = function() {
		try { pages.last = pagination().totalpages; }
		catch(any excpt) { pages.last = 1; }
		pages.total	= pages.last
		if(pages.previous lt 1) pages.previous = 1;
		if(pages.next gt pages.total) pages.next = pages.total;
		// disable navigation if there is only 1 page
		if(pages.total lte 1) pages.fieldset = " disabled";
	}
	var pageSort = function() {
		pages.sortbyverbose	= params.sort
		if(params.sort is 'title') pages.sortbyverbose = 'name';
		if(params.sort is 'date') pages.sortbyverbose = 'date posted';
		if(params.sort is 'category') pages.sortbyverbose = 'categories';
	}
	var queryStrings = function() {
		var base = "sort=#params.sort#&perpage=#params.perPage#"
		if(params.perPage == "0") urlString.all = "sort=#params.sort#&perpage=0&page=0"
		else urlString.all = "#base#&page=1"
		urlString.filter = "#base#&page=#params.page#"
		urlString.limit = "#base#&page=1"
		urlString.unlimited = "#base#&page=0"
	}
	var collections = collectionsMenu(collectionMenuData,params)
	var page = {
		"prev": "", "next": "", "first": "", "last": "",
		"pURL": "", "nURL": "", "fURL": "", "lURL": "",
	}
	var pages = {
		"recordCnt": websiteCount,
		"first": 1,
		"last": 1,
		"previous": Ceiling(params.page-1),
		"next": Ceiling(params.page+1),
		"total": 1,
		"fieldset": "",
		"sortbyverbose": ""
	}
	var urlString = {
		"all":"",
		"filter":"",
		"limit":"",
		"unlimited":""
	}
	pageLimits()
	pageSort()
	buttons()
	timeHTML = GetTickCount()
	queryStrings()
	links()
	pageAbout.text = '#header#'
	pageAbout.icon = 'fal fa-external-link'
</cfscript><cfoutput>
<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" #page.first# type="submit" formaction="#page.fURL#"></button>
		<button id="GotoLastPage" #page.last# type="submit" formaction="#page.lURL#"></button>
	</span>
	<div class="btn-toolbar nav-toolbar-container" role="toolbar">
		<fieldset class="btn-group btn-group-sm"#pages.fieldset#>
			<button id="GotoPrevPage" #page.prev# type="submit" class="btn btn-default" rel="prev" formaction="#page.pURL#" title="Go to the previous page (← arrow key)"><i class="fal fa-arrow-alt-left fa-lg"></i></button>
			<button id="GotoNextPage" #page.next# type="submit" class="btn btn-default" rel="next" formaction="#page.nURL#" title="Go to the next page (arrow key →)"><i class="fal fa-arrow-alt-right fa-lg"></i></button>
			<button type="button" class="btn btn-default mobile-hide" id="jumpto_menu" aria-label="Jump to menu" disabled><i class="fal fa-arrow-alt-from-right fa-lg"></i><i class="fal fa-arrow-alt-from-left fa-lg"></i></button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" title="List pages to jump to">
				<span class="caret"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu" role="menu" aria-labelledby="jumpto_menu">
				<li title="Go to the first page (Ctrl+←)"><a href="#page.fURL#"><i class="fal fa-arrow-alt-to-left fa-fw"></i> First page</a></li>
				<li title="Go to the last page (Ctrl+→)"><a href="#page.lURL#"><i class="fal fa-arrow-alt-to-right fa-fw"></i> Last page</a></li>
				<li class="divider"></li>
				<cfif params.page>
				#paginationLinks(
					route=pageRoute,
					key=params.key,
					title="Go to page",
					windowSize=5,
					appendToPage=" ",
					linkToCurrentPage=true,
					alwaysShowAnchors=false,
					classForCurrent="active",
					argumentcollection=noFollow,
					params=replaceNocase(urlString.filter,"&page=#params.page#",""),
					pageNumberAsParam=true,
					prependToPage="<li>",
					appendToPage="</li>",
					encode="attributes"
				)#
				</cfif>
			</ul>
		</fieldset>
		<!--- collections menu --->
		<div class="btn-group btn-group-sm">
			<button type="button" class="btn btn-default" id="collections_menu" disabled><span class="mobile-hide">COLLECTIONS</span><span class="mobile-show"><i class="fal fa-tags fa-fw"></i></span></button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" title="List collections">
				<span class="caret"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu" role="menu" aria-labelledby="collections_menu">
				<cfif params.key is "-"><li class="active"><cfelse><li></cfif>
					#LinkTo(route="linkList",text="#XMLFormat(collections.inactivetext)#",title="#XMLFormat(collections.inactivetitle)#",argumentcollection=collections.menuwww,params=urlString.all)#
				</li>
				<li class="divider"></li>
				<cfloop array="#collections.menus#" index="local.menu">
					<cfif Len(menu[2]) gte 1>
						<cfif FindNocase("href",menu[2]) eq 0>
							<li class="divider"></li>
						</cfif>
						<cfloop list="#replace(menu[2],'&amp;','&','all')#" index="local.index" delimiters=";">
							<cfif ListFindNocase("disabled,statuserrors",ListFirst(index,":"))>
								<cfcontinue/><!--- skip operator menu options --->
							</cfif>
							<li class="#activeOrganisation('filter.#ListFirst(index,":")#')#">#ListLast(index,":")#</li>
						</cfloop>
					</cfif>
				</cfloop>
			</ul>
		</div>
		<!--- sort menu --->
		<div class="btn-group btn-group-sm" title="Sort links">
			<button type="button" class="btn btn-default" id="sort_menu" aria-label="Sort links" disabled><i class="fal fa-sort-amount-down fa-fw fa-lg"></i></button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="fal fa-sort"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu" role="menu" aria-labelledby="sort_menu">
				<li class="#activeMenu('sort.title')#">
					<a href="#UrlFor(title="Sort #get('siteAreas').titles.link# by their title in alphabetical order",route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"sort=#params.sort#","sort=title"))#">
						<i class="fal fa-sort-alpha-down fa-fw"></i> Name</a></li>
				<li class="#activeMenu('sort.date')#">
					<a href="#UrlFor(title="Sort #get('siteAreas').titles.link# by the date posted on #get('siteAreas').titles.df2#",route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"sort=#params.sort#","sort=date"))#">
						<i class="fal fa-calendar-plus fa-fw"></i> Date posted</a></li>
				<li class="#activeMenu('sort.category')#">
					<a href="#UrlFor(title="Sort #get('siteAreas').titles.link# by their tagged categories",route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.filter,"sort=#params.sort#","sort=category"))#">
						<i class="fal fa-tags fa-fw"></i> Categories</a></li>
			</ul>
		</div>
		<!--- record count menu --->
		<div class="btn-group btn-group-sm mobile-hide" title="Links per page">
			<button type="button" class="btn btn-default" id="show_menu" aria-label="Links per page" disabled><i class="fal fa-spinner fa-fw fa-lg"></i></button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu" role="menu" aria-labelledby="display_menu">
				<li class="#activeMenu('perpage.0')#">#LinkTo(text="All",route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.unlimited,"&perpage=#params.perpage#","&perpage=0"))#</li>
				<li class="#activeMenu('perpage.50')#">#LinkTo(text="50",route=pageRoute,key=params.key,argumentcollection=noFollow,params=replaceNocase(urlString.limit,"&perpage=#params.perpage#","&perpage=50"))#</li>
			</ul>
		</div>
	</div>
</form>
<!--- pagination statistics --->
<div class="pagination-statistics mobile-hide">
	<span class="label label-default">#pages.recordCnt# websites</span>
	<span class="label label-default">sort by #pages.sortbyverbose#</span>
	<span class="label label-info"><cfif params.page>page #params.page# of #pages.total#<cfelse>show all</cfif></span>
	&nbsp;
	<cfif !len(page.prev) or !len(page.next)>#touchandkeyboardIcons()#</cfif>
</div>
<!--- operator feedback notices --->
<cfif flashCount()>
	<p>#flashMessages(class="alert alert-info")#</p>
</cfif>
<!--- list items --->
<div class="#itemClass()# readable-text">
	<div>
		<cfloop query="website">
			<cfset currentRow = website.currentRow>
			<cfif currentRow is 1>
				<ul class="container-first-item">
			<cfelse>
				<ul>
			</cfif>
			<cfif website.categorySort is "homepage"><cfset website.categorySort = "Group Homepage"></cfif>
			<cfif website.categorySort is "wayback"><cfset website.categorySort = "Wayback Site"></cfif>
			<cfif not Len(website.categorySort) and params.key neq '-'>
				<cfset website.categorySort = website.categoryKey />
			</cfif>
			<cfif not Len(website.categorySort) and params.key eq '-'>
				<cfset website.categorySort = "Uncategorised" />
			</cfif>
			<cfif Find(":",website.uriref)>
				<cfset listaction = "visit">
			<cfelse>
				<cfset listaction = "wayback">
			</cfif>
			<!--- clean and format strings --->
			<cfset website.comment = XMLFormat(removeTags(website.comment))>
			<cfset website.metadescription = XMLFormat(removeTags(website.metadescription))>
			<cfset website.metatitle = XMLFormat(removeTags(website.metatitle))>
			<cfset website.title = XMLFormat(removeTags(website.title))>
			<cfif params.sort is "category"
				and Len(website.categorySort)
				and (!flashKeyExists("websiteSort")
						or website.categorySort
						neq flash("websiteSort"))>
				<li><h4 class="row-first-item link-category"><i class="fal fa-tag fa-fw"></i> #humanize(website.categorySort)#</h4></li>
			</cfif>
			<cfset flashInsert(websiteSort=website.categorySort)>
			<li>
				#includePartial(partial="items")#
			</li>
		</ul>
	</cfloop>
	</div>
</div>
</cfoutput>