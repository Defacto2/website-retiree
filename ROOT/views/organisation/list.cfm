<!---
  	Group list view.
	path: views/organisation/list.cfm

@CFLintIgnore
--->
<cfscript>
	var exists = function() {
		var filePath = "files/html/#params.key#.htm";
		return fileExists(ExpandPath(filePath), false)
	}
	var default = "btn-default"
	var primary = "btn-primary"
	var buttons = function() {
		switch(params.key) {
			case 'group': button.badge = 'groups'; button.group=primary; break;
			case 'bbs': button.badge = 'boards'; button.bbs=primary; break;
			case 'ftp': button.badge = 'sites'; button.ftp=primary; break;
			case 'magazine': button.badge = 'magazines'; button.magazine=primary; break;
			default:
		}
	}
	var button = {
		"badge":"",
		"group":default,
		"bbs":default,
		"ftp":default,
		"magazine":default
	}
	var firstLetter = ''
	buttons()
</cfscript>
<cfoutput>
	<form method="post">
		<div class="btn-toolbar grouping nav-toolbar-container" role="toolbar">
			<div class="btn-group btn-group-sm">
				<button type="button" class="btn #default#" disabled><span class="mobile-hide">FILTER</span><span class="mobile-show"><i class="fal fa-tags"></i></span></button>
				<button type="submit" class="btn #button.group#" formaction="#urlFor(route='organisationFilter',key='group')#"><i class="fal fa-users fa-lg fa-fw"></i><span class="mobile-hide"> GROUPS</span></button>
				<button type="submit" class="btn #button.bbs#" formaction="#urlFor(route='organisationFilter',key='bbs')#"><i class="fal fa-phone fa-lg fa-fw"></i><span class="mobile-hide"> BBS BOARDS</span></button>
				<button type="submit" class="btn #button.ftp#" formaction="#urlFor(route='organisationFilter',key='ftp')#"><i class="fal fa-sitemap fa-lg fa-fw"></i><span class="mobile-hide"> FTP SITES</span></button>
				<button type="submit" class="btn #button.magazine#" formaction="#urlFor(route='organisationFilter',key='magazine')#"><i class="fal fa-newspaper fa-lg fa-fw"></i><span class="mobile-hide"> MAGAZINES</span></button>
			</div>
		</div>
	</form>
	<!--- operator feedback notices --->
	<cfif flashCount()>
		#flashMessages(class="alert alert-info")#
	</cfif>
	<!-- list items -->
<cfif !exists()><p>Sorry, the #params.key# file is missing</p><cfelse>
<cfinclude template="/files/html/#params.key#.htm"></cfif>
</cfoutput>