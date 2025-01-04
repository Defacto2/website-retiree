<!---
  	Website item partial view.
	path: views/link/_items.cfm

@CFLintIgnore VAR_TOO_SHORT
--->
<cfscript>
	var siteDate = function() {
		if(website.date_issued_year lte 1900) return ""
		var date = website.date_issued_year
		if(website.date_issued_month gte 1) date &= ', #MonthAsString(website.date_issued_month)#'
		if(Len(website.date_issued_day)) date &= ' #website.date_issued_day#'
		return date
	}
	var siteLink = function() {
		if(params.controller == "search") {
			return LCase(linkExpand(website.uriref,website.categoryKey))
		}
		return XMLFormat(LCase(linkExpand(website.uriref,website.categoryKey)))
	}
	var siteMeta = function() {
		if(ListFirst(website.metatitle," ") == website.httpstatuscode) return ""
		if(ListFirst(website.metatitle," ") == "error") return ""
		if(Len(website.metatitle) && Len(website.metadescription)) {
			if(website.metadescription != website.metatitle) return '#website.metatitle# #website.metadescription#'
		}
		if(Len(website.metadescription)) {
			if(website.metadescription != website.metatitle) return website.metadescription
		}
		if(Len(website.metatitle)) {
			return website.metatitle
		}
		return ""
	}
	var siteStatus = function() {
		var code = website.httpstatuscode
		if(Len(httpFindStatus(code,'4,5'))) return '#code# #website.httpstatustext#'
		if(Len(httpFindStatus(code,'3'))) return '#website.httpstatustext#: #website.httplocation#'
		if(code == '666') return 'Last attempt at connection failed'
		return ""
	}
	var siteTitle = function(numeric row) {
		var icon = '<i class="fal fa-quote-left fa-lg fa-pull-left fa-border"></i>'
		var h4 = '<h4>'
		if(arguments.row == 1) h4 = '<h4 class="row-first-item">'
		h4 &= '<a href="#UrlFor(controller="link",action='#listaction#',key=obfuscateParam(website.id))#">#website.title#</a>'
		h4 &= '</h4>'
		return icon & h4
	}
	var admin = {
		"button": "disable",
		"icon": "plus-square",
		"colour": "success"
	}
	if(website.deletedat == website.createdat && Len(website.deletedat)) {
		admin.button = "approve"
		admin.icon = "plus-square"
		admin.colour = "warning"
	}
	else if(Len(website.deletedat)) {
		admin.button = "restore"
		admin.icon = "minus-square"
		admin.colour = "danger"
	}
</cfscript>
<cfoutput>
	<div class="link-as-item">
		#siteTitle(currentRow)#
		<!--- item link for display --->
		<samp>#truncate(text=siteLink(),length="50")#</samp>
		<!--- link status --->
		<cfif Len(website.deletedat)><span class="label gray-light"><i class="fal fa-times fa-fw gray-light"></i> disabled on #DateFormat(website.deletedat,'d-mmm-yy')#</span></cfif>
		<cfif Len(siteStatus())><span class="label gray-light"><i class="fal fa-exclamation-circle fa-fw gray-light"></i> #siteStatus()#</span></cfif>
		<cfif !Find('//',website.uriref)><span class="label gray-light"><i class="fal fa-hdd fa-fw gray-light"></i> mirrored</span></cfif>
		#siteDate()#
	</div>
	<cfif opCheck('sysop')>
		<form method="post">
			<div class="btn-group btn-group-sm">
				<button type="submit" class="btn" title="Edit site" formaction="#URLFor(controller="link",action="edit",key=obfuscateParam(website.id))#">
					<i class="fal fa-edit fa-fw fa-lg"></i>
				</button>
				<button type="submit" class="btn btn-#admin.colour#" title="Toggle site" formaction="#URLFor(route="linkOperator",function=admin.button,key=obfuscateParam(website.id),uuid=website.uuid)#">
				<i class="fal fa-#admin.icon# fa-fw fa-lg"></i>
				</button>
			</div>
			<cfif website.deletedat eq website.createdat and Len(website.deletedat)>
				<span class="label gray-light"><i class="fal fa-calendar-minus fa-fw gray-light"></i> on-hold since #DateFormat(website.createdat,'d-mmm-yy')#</span>
			<cfelseif Len(website.createdat)>
				<span class="label gray-light"><i class="fal fa-calendar-plus fa-fw gray-light"></i> inserted on #DateFormat(website.createdat,'d-mmm-yy')#</span>
			</cfif>
			<cfif Len(website.categorykey) or Len(website.categorysort)>
				<span class="label gray-light"><i class="fal fa-tag fa-fw gray-light"></i> #website.categorykey#</span> <span class="label gray-light"><i class="fal fa-tag fa-fw gray-light"></i> #website.categorysort#</span>
			</cfif>
		</form>
	</cfif>
	<cfif Len(siteMeta())><div class="mobile-hide"><em>#siteMeta()#</em></div></cfif>
	<cfif Len(website.comment)><div class="comments mobile-hide">#website.comment#</div></cfif>
	<cfif Len(deletedatcomment)><div>#website.deletedatcomment#</div></cfif>
</cfoutput>