<!---
  	Search result index view.
	path: views/search/result.cfm

@CFLintIgnore VAR_HAS_PREFIX_OR_POSTFIX,VAR_TOO_SHORT
--->
<cfscript>
	//dump(searches);abort;
	var checked = "checked"
	var default = "display:default"
	var info = "info"
	var none = "display:none"
	var warn = "warning"
	variables.cite = function(required string item) {
		var text = arguments.item
		loop list=xssCleanedKey index='local.key' delimiters='|' {
			if(arguments.item does not contain key) continue;
			text = citeText(text,key)
		}
		return text
	}
	var errorFree = function() {
		if(!error.empty && !error.tooShort && !error.section) return true
		return false
	}
	var errors = function() {
		if(!Len(xssCleanedKey)) error.empty = true; // a
		else if(Len(xssCleanedKey) < minSearchLength) error.tooShort = true; // b
		if(searches.people) return;
		if(searches.groups) return;
		if(searches.sites) return;
		if(searches.files) return;
		error.section = true // c
	}
	var external = function() {
		if(!results.pouet.recordCount && !results.demozoo.recordCount) return "";
		if(!results.pouet.recordCount) return 'Demozoo'
		if(!results.demozoo.recordCount) return 'Pouët'
		return "Demozoo and Pouët"
	}
	var files = function() {
		if(!searches.files) return;
		if(results.file.recordCount) {
			file.panel = info
			return
		}
		file.panel = warn
		file.style = none
	}
	var header = function() {
		if(!Len(xssCleanedKey)) return ""
		var cnt = 0
		var text = ""
		loop list=xssCleanedKey index="local.key" delimiters="|" {
			cnt++
			if (ListLen(list=key,delimiters=" ")>=2) text &= '"#key#" '
			else text &= "#key# "
			if (cnt > 0 && cnt < ListLen(xssCleanedKey,"|")) text &= ' <small>or</small> '
		}
		return text
	}
	var links = function() {
		if(!searches.sites) return;
		if(results.link.recordCount > 1) variables.class.link = "columns-list-wide"
		if(results.link.recordCount) {
			link.panel = info
			return
		}
		link.panel = warn
		link.style = none
	}
	var groups = function() {
		if(!searches.groups) return;
		if(ListLen(results.group) > 1) variables.class.group = "columns-list"
		if(Len(Trim(results.group))) {
			group.panel = info
			return
		}
		group.panel = warn
		group.style = none
	}
	var noResults = function() {
		if(Len(Trim(results.group))) return false;
		if(Len(Trim(q4_credits))) return false;
		if(results.link.recordCount) return false;
		if(results.file.recordCount) return false;
		if(results.pouet.recordCount) return false;
		if(results.demozoo.recordCount) return false;
		return true
	}
	var noResultsP = function() {
		switch(params.search) {
			case 'files': return "No filenames or titles found with this search";
			case 'groups': return "No groups, bbs or ftp sites found with this search";
			case 'people': return "No people or sceners found with this search";
			case 'websites': return "No websites found with this search";
			default: return "No results found with this search";
		}
	}
	var persons = function() {
		if(!searches.people) return;
		q4_credits = ListRemoveDuplicates(q4_credits)
		if(ListLen(q4_credits) > 1) variables.class.people = "columns-list";
		if(Len(Trim(q4_credits))) {
			people.panel = info
			return
		}
		people.panel = warn
		people.style = none
	}
	var finds = function() {
		files()
		links()
		groups()
		persons()
		switch(params.search) {
			case 'files': variables.radio.files = checked; break;
			case 'groups': variables.radio.groups = checked; break;
			case 'people': variables.radio.people = checked; break;
			case 'websites': variables.radio.websites = checked; break;
			default: variables.radio.all = checked
		}
	}
	var group = {
		"panel":"",
		"style":default
	}
	var file = {
		"panel":"",
		"style":default
	}
	var link = {
		"panel":"",
		"style":default
	}
	var people = {
		"panel":"",
		"style":default
	}
	var error = {
		"empty":false,
		"tooShort":false,
		"section":false,
	}
	variables.class = {
		"link":"",
		"group":"",
		"people":"",
	}
	variables.radio = {
		"all":"", // 1
		"files":"", // 2
		"groups":"", // 3
		"people":"", // 4
		"websites":"", // 5
	}
	finds()
	errors()
	pageAbout.icon = ''
	pageAbout.text = header()
</cfscript>
<cfoutput>
	<!-- search query results -->
	<div class="search-results">
		#includePartial('form')#<br>
		<cfif error.empty>
			<!-- no search term provided -->
			<div class="well well-lg readable-text">
				<p>Searches are <u>case-insensitive</u> and match <u>exact</u> phrases</p>
				<p class="mobile-hide">Separate multiple phrases with<code><b>|</b></code>pipe characters; searching <a href="/search/result?search=all&query=razor%2B1911%257Crzr" class="nowrap">razor 1911|rzr</a> lists both <mark>razor 1911</mark> and <mark>rzr</mark> matches</p>
				<p class="mobile-hide"><br><small>You may find files using a <a href="//www.pouet.net/prod.php?which=50581">Pouët</a> or <a href="//demozoo.org/productions/167153">Demozoo</a> production ID, searching <code><a href="/search/result?search=all&query=50581">50581</a></code> or <code><a href="/search/result?search=all&query=167153">167153</a></code> takes you to the <a href="/f/a6292a">Defacto2 Site Intro 2008</a></small></p>
			</div>
		</cfif>
		<cfif error.tooShort>
			<!-- results returned an error -->
			<div class="alert alert-danger readable-text">Search term '#xssCleanedKey#' was blocked as your term must be at least 2 characters or larger</div>
		</cfif>
		<cfif error.section>
			<div class="alert alert-warning readable-text">
				<i class="fal fa-exclamation-triangle"></i> <span>No sections have been selected for the search query</span><br>
				Choose: &nbsp; <i class="fal fa-folder"></i> Files &nbsp;<i class="fal fa-users"></i> Groups &nbsp;<i class="fal fa-user"></i> People &nbsp;<i class="fal fa-external-link-square"></i> Websites
			</div>
		</cfif>
		<cfif errorFree()>
			<cfif noResults()>
				<p class="text-center"><strong>#noResultsP()#</strong></p>
				<cfreturn>
			</cfif>
			<!--- organisation results --->
			<cfif searches.groups>
				<div class="panel panel-#group.panel# readable-text" style="#group.style#">
					<div class="panel-heading">
						<h2 class="panel-title">#get('siteAreas').titles.organisation#</h2>
					</div>
					<div class="panel-body">
						#includePartial(partial="listorganisations")#
					</div>
				</div><br>
			</cfif>
			<!--- people results --->
			<cfif searches.people && Len(Trim(q4_credits))>
				<div class="panel panel-#people.panel# readable-text" style="#people.style#">
					<div class="panel-heading readable-text">
						<h2 class="panel-title">#get('siteAreas').titles.person# <span class="badge">#ListLen(q4_credits)#</span></h2>
					</div>
					<div class="panel-body" id="person-drill-down">
						<ul class="#variables.class.people#">#includePartial(partial="listpersons")#</ul>
					</div>
				</div><br>
			</cfif>
			<!--- link results --->
			<cfif searches.sites>
				<div class="panel panel-#link.panel# readable-text" style="#link.style#">
					<div class="panel-heading">
						<h2 class="panel-title">Scene #get('siteAreas').titles.link# <span class="badge">#results.link.recordCount#</span></h2>
					</div>
					<div class="panel-body">
						<ul class="#variables.class.link#">#includePartial(partial="listsites")#</ul>
					</div>
				</div><br>
			</cfif>
			<!--- external links --->
			<cfif results.pouet.recordCount or results.demozoo.recordCount>
				<div class="panel panel-default">
					<div class="panel-heading">
						<h2 class="panel-title">
						<i class="fal fa-external-link-square"></i> External links <em>#external()#</em></h2>
					</div>
					<div class="panel-body">
						#includePartial(partial="listexternallinks")#
					</div>
				</div>
			</cfif>
			<!--- file results --->
			<cfif searches.files>
				<div class="panel panel-#file.panel#" style="#file.style#">
					<div class="panel-heading">
						<h2 class="panel-title">
							Metadata <span class="badge">#results.file.recordCount#<cfif results.files gt results.file.recordCount>/#results.files# (results capped)</cfif></span>
							<small>results only match titles, filenames and notes</small></h2>
					</div>
					<div class="panel-body">
						#includePartial(partial="listfiles")#
					</div>
				</div>
			</cfif>
		</cfif>
	</div>
</cfoutput>