<!---
	Sort or order file items, partial view.
	path: views/files/_list_nav-sort.cfm

@CFLintIgnore
--->
 <cfscript>
	var buttons = function() {
		if(params.output contains 'thumb') {
			thumbH1.button = params.output
			if(right(params.output,1) != '-') {
				thumbH1.button &= '-'
				thumbH1.urlquery = ''
			} else {
				thumbH1.button = left(thumbH1.button,len(thumbH1.button)-1)
			}
		}
		switch(params.output) {
			case "text": button.table = 'active'; break;
			case "card": button.card = 'active'; break;
			case "thumb": case "thumb-": button.thumb = 'active'; break;
			default:
		}
		if(params.sort contains '_asc') {
			button.sort = 'up'
			return
		}
		if(params.sort contains '_desc') {
			button.sort = 'down'
			return
		}
		// for when sort = `disabled`
		button.sort = 'down'
	}
	// controller file, active menu item highlight
	var menuSelection = function(required string listItem="") {
		var value = ""
		var key = listGetAt(arguments.listItem,1,'.');
		try {
			value = listGetAt(arguments.listItem,2,'.');
		} catch(any excpt) {}
		switch(key) {
			case "action":
				if (value == params.action) return active
			case "perpage":
				if (value == params.perpage) return active
			case "sort":
				if (value == params.sort) return active
			case "key":
				if (value == params.key) return active
			case "platform":
				if (value == params.platform) return active
			case "section":
				if (value == params.section) return active
			case "output":
				if (value == params.output) return active
			default: return "";
		}
		return ""
	}
	var wgets = function() {
		if(listFindNoCase("document,software,visual",params.key)) {
			switch(params.key) {
				case "document":
					wget.action = 'documents'
					return;
				case "visual":
					wget.action = 'art'
					return;
				default:
					wget.action = '#params.key#'
					return;
			}
		}
		if(params.section != "-" and params.section != "") {
			wget.action = 'category'
			wget.key = params.section
			return
		}
		if(params.platform != "-" and params.platform != "") {
			wget.action = 'platform'
			wget.key = params.platform
			return
		}
	 	if(params.orgname != "") {
			wget.action = 'group'
			wget.key = params.orgname
			return
		}
	}

	var button = {
		"card":'default',
		"sort":'',
		"thumb":'default',
		"table":'default',
	}
	var thumbH1 = {
		"button":'',
		"class":'hide-true',
		"title":'',
		"urlquery":'-',
	}
	var wget = {
		"state":false,
		"controller":'html3',
		"action":'',
		"key":'',
		"link":'/html3/',
	}
	uriBase = replaceListNoCase(uriBase, '&page=1', '') // global
	var formHref = {
		// requires #uriBase# located in /view/file/list.cfm
		"card":replaceNoCase(uriBase,'output=#params.output#','output=card'),
		"h1":replaceNoCase(uriBase,'output=#params.output#','output=#thumbH1.button#'),
		"saPost":replaceNoCase(uriBase,'sort=#params.sort#','sort=posted_asc'),
		"sdPost":replaceNoCase(uriBase,'sort=#params.sort#','sort=posted_desc'),
		"saDate":replaceNoCase(uriBase,'sort=#params.sort#','sort=date_asc'),
		"sdDate":replaceNoCase(uriBase,'sort=#params.sort#','sort=date_desc'),
		"saSize":replaceNoCase(uriBase,'sort=#params.sort#','sort=size_asc'),
		"sdSize":replaceNoCase(uriBase,'sort=#params.sort#','sort=size_desc'),
		"saTitle":replaceNoCase(uriBase,'sort=#params.sort#','sort=title_asc'),
		"sdTitle":replaceNoCase(uriBase,'sort=#params.sort#','sort=title_desc'),
		"table":replaceNoCase(uriBase,'output=#params.output#','output=text'),
		"thumb":replaceNoCase(uriBase,'output=#params.output#','output=thumb#thumbH1.urlquery#'),
	}
	wgets()
	if(wget.action != '' && pages.recordCnt > 3) wget.state = true
	buttons()
	// time ago badges
	var uploadAgo = ""
	var updateAgo = ""
	if(structKeyExists(variables,"collectionUpload") && isDate(variables.collectionUpload)) uploadAgo = timeAgoInWords(fromTime=variables.collectionUpload,toTime=now());
	if(structKeyExists(variables,"collectionUpload") && isDate(variables.collectionUpdate)) updateAgo = timeAgoInWords(fromTime=variables.collectionUpdate,toTime=now());
</cfscript>
<cfoutput>
	<!--- tables, cards and thumbs toggle tabs --->
	<ul class="nav nav-tabs mobile-hide">
		<li role="presentation" class="#button.table# mobile-hide" title="Table view" data-toggle="tooltip" data-placement="top">
			<a aria-label="Table view" href="#formHref.table#"><i class="fal fa-list-ul fa-fw fa-lg"></i></a></li>
		<li role="presentation" class="#button.card#" title="Cards view" data-toggle="tooltip" data-placement="top">
			<a aria-label="Cards view" href="#formHref.card#"><i class="fal fa-th-list fa-fw fa-lg"></i></a></li>
		<li role="presentation" class="#button.thumb#" title="Thumbnails view" data-toggle="tooltip" data-placement="top">
			<a aria-label="Thumbnails view" href="#formHref.thumb#"><i class="fal fa-th fa-fw fa-lg"></i></a></li>
		<!--- sort list --->
		<li role="presentation" class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="##" role="button" aria-haspopup="true" aria-expanded="false">
				<i class="fal fa-sort-amount-#button.sort# fa-fw fa-lg"></i>
				<strong>#UCase(listFirst(pages.sortbyverbose,"_"))#</strong> <span class="caret"></span>
			</a>
			<ul class="dropdown-menu pull-left" role="menu" aria-labelledby="sort_menu">
				<li class="dropdown-header">Date posted</li>
				<li class="#menuSelection('sort.posted_asc')#" title="Oldest posts first" data-toggle="tooltip" data-placement="right"><a href="#formHref.saPost#"><i class="fal fa-sort-down fa-fw"></i>2006</a></li>
				<li class="#menuSelection('sort.posted_desc')#" title="Newest posts first" data-toggle="tooltip" data-placement="right"><a href="#formHref.sdPost#"><i class="fal fa-sort-down fa-fw"></i>#dateformat(now(),"YYYY")#</a></li>
				<li class="divider"></li>
				<li class="dropdown-header">Published</li>
				<li class="#menuSelection('sort.date_asc')#"><a href="#formHref.saDate#" title="Oldest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>1980</a></li>
				<li class="#menuSelection('sort.date_desc')#"><a href="#formHref.sdDate#" title="Newest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>#dateformat(now(),"YYYY")#</a></li>
				<li class="divider"></li>
				<li class="dropdown-header">File size</li>
				<li class="#menuSelection('sort.size_asc')#"><a href="#formHref.saSize#" title="Smallest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>0 b</a></li>
				<li class="#menuSelection('sort.size_desc')#"><a href="#formHref.sdSize#" title="Largest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>∞ GB</a></li>
			</ul>
		</li>
		<!--- send files and wget batch download --->
		<li role="presentation" class="mobile-hide" title="Go to the file upload form" data-toggle="tooltip" data-placement="top">
			<a aria-label="Go to the file upload form" href="#urlFor(controller='upload',action='index')#" id="upload_btn"><i class="fal fa-file-upload fa-fw fa-lg"></i> <strong>Uploader</strong></a></li>
		<cfif wget.state>
			<li role="presentation" class="mobile-hide" title="View this in a HTML 3 page for legacy browsers" data-toggle="tooltip" data-placement="top">
			<a aria-label="View this in a HTML 3 page for legacy browsers" href="#urlFor(controller='html3',action='#wget.action#',key='#wget.key#')#">
				<strong>Text mode</strong></a></li>
		</cfif>
		<cfif params.controller neq "file">
			<!--- display links menu instead of disabled collections menu for organisations and people --->
			#includePartial('/file/prod_nav-links')#
		</cfif>
	</ul>
	<!--- mobile cards and thumbs toggle tabs --->
	<ul display="block:none" class="nav nav-tabs mobile-show">
		<li role="presentation" class="#button.card#" title="Cards view" data-toggle="tooltip" data-placement="top">
			<a aria-label="Cards view" href="#formHref.card#"><i class="fal fa-th-list fa-fw fa-lg"></i></a></li>
		<li role="presentation" class="#button.thumb#" title="Thumbnails view" data-toggle="tooltip" data-placement="top">
			<a aria-label="Thumbnails view" href="#formHref.thumb#"><i class="fal fa-th fa-fw fa-lg"></i></a></li>
		<!--- sort list --->
		<li role="presentation" class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="##" role="button" aria-haspopup="true" aria-expanded="false">
				<i class="fal fa-sort-amount-#button.sort# fa-fw fa-lg"></i>
				<strong>#UCase(listFirst(pages.sortbyverbose,"_"))#</strong> <span class="caret"></span>
			</a>
			<ul class="dropdown-menu pull-left" role="menu" aria-labelledby="sort_menu">
				<li class="dropdown-header">Date posted</li>
				<li class="#menuSelection('sort.posted_asc')#" title="Oldest posts first" data-toggle="tooltip" data-placement="right"><a href="#formHref.saPost#"><i class="fal fa-sort-down fa-fw"></i>2006</a></li>
				<li class="#menuSelection('sort.posted_desc')#" title="Newest posts first" data-toggle="tooltip" data-placement="right"><a href="#formHref.sdPost#"><i class="fal fa-sort-down fa-fw"></i>#dateformat(now(),"YYYY")#</a></li>
				<li class="divider"></li>
				<li class="dropdown-header">Published</li>
				<li class="#menuSelection('sort.date_asc')#"><a href="#formHref.saDate#" title="Oldest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>1980</a></li>
				<li class="#menuSelection('sort.date_desc')#"><a href="#formHref.sdDate#" title="Newest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>#dateformat(now(),"YYYY")#</a></li>
				<li class="divider"></li>
				<li class="dropdown-header">File size</li>
				<li class="#menuSelection('sort.size_asc')#"><a href="#formHref.saSize#" title="Smallest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>0 b</a></li>
				<li class="#menuSelection('sort.size_desc')#"><a href="#formHref.sdSize#" title="Largest files first" data-toggle="tooltip" data-placement="right"><i class="fal fa-sort-down fa-fw"></i>∞ GB</a></li>
			</ul>
		</li>
	</ul>
	<!--- pagination badge statistics --->
	<div class="pagination-statistics">
		<span class="label label-default">#pages.recordCnt# files</span>
<cfif uploadAgo neq ""><span class="label label-default">last upload, #uploadAgo# ago</span></cfif>
<cfif updateAgo neq "" and updateAgo neq uploadAgo><span class="label label-default">revised #updateAgo# ago</span></cfif>
		<span class="label label-default mobile-hide">sort by #replace(LCase(pages.sortbyverbose),"_"," ")#</span>
		<span class="hide-from-infscroll">
			<span class="label label-default mobile-hide">show #params.perpage#</span>
			<span class="label label-info">page #params.page# of #pages.total#</span>
		</span>
		<cfif opCheck('coop') && params.key neq "-">
			<span class="label label-warning" title="Categories in use">
				<i class="fal fa-tags"></i>
				<cfswitch expression="#params.key#">
					<cfcase value="waitingapproval">files that need approval</cfcase>
					<cfcase value="disabled">files that are disabled</cfcase>
					<cfcase value="virusalert">unwanted software</cfcase>
					<cfdefaultcase>#LCase(getKeyName(params.key))#</cfdefaultcase>
				</cfswitch>
			</span> &nbsp;
		</cfif>
		<span id="infScrollBadge" class="label label-info mobile-hide hidden">infinite scroll</span>
		<cfif !len(nav.btn.prev) or !len(nav.btn.next)>
			<span class="mobile-hide hide-from-infscroll label label-default">#touchandkeyboardIcons(cls='white-href')#</span>
		</cfif>
	</div>
</cfoutput>