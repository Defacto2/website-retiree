<!---
  	Sessions template view.
	path: views/system/templatesession.cfm

@CFLintIgnore
--->
<cfscript>
	var columnClass = function(string size="1") {
		if(params.key == "personal") return "";
		return "col-md-#arguments.size#";
	}
	var rowClass = function() {
		if(params.key == "personal") return "3";
		return "0";
	}
	var icon = function(string user=""){
		switch(LCase(trim(arguments.user))) {
			case 'robot': return 'l fa-server'
			case 'android': return 'l fa-mobile-android'
			case 'an iphone': return 'l fa-mobile'
			case 'an ipad': return 'l fa-tablet-alt'
			case 'windows': return 'b fa-windows'
			case 'macos': return 'b fa-apple'
			case 'linux': return 'b fa-linux'
			default: return 'l fa-laptop'
		}
	}
	var iconTitle = function(string user=""){
		switch(LCase(trim(arguments.user))) {
			case 'robot': return 'Crawler or bot'
			case 'android': return 'An Android device'
			case 'an iphone': return 'An iOS device'
			case 'an ipad': return 'An iPad device'
			case 'windows': return 'Windows'
			case 'macos': return 'macOS'
			case 'linux': return 'Linux'
			default: return 'Another operating system or device'
		}
	}
	var data
	variables.help = "session"
	if(params.key == "cgi") variables.help = "cgi";

	var parseVal = function(string val=""){
		switch(LCase(trim(arguments.val))) {
			case 'cfid': return 'CF ID'
			case 'cftoken': return 'CF token'
			case 'lastvisit': return 'Last visit'
			case 'urltoken': return 'URL token'
			case 'hitcount': return 'Hit count (visits)'
			case 'timecreated': return 'Time created'
			case 'sessionid': return 'Session ID'
			case 'stp': return 'OS. (stp)'
			case 'stb': return 'Browser (stb)'
			case 'errcnt': return 'Errors count'
			case 'persistsession': return 'Persist session'
			default: return LCase(arguments.val)
		}
	}
	var parseHead = function(string val=""){
		switch(lCase(arguments.val)){
			case 'op': return 'Operator values'
			case 'flash': return 'Flash values'
			case 'display': return 'Display'
			default: return LCase(arguments.val)
		}
	}
</cfscript>
<cfoutput>
<div class="col-lg-6 col-md-12 col-lg-offset-3">
	<div class="panel panel-info">
		<div class="panel-heading">
			<h3 class="panel-title">#header#</h3>
		</div>
		<table class="table table-striped gray">
			<cfloop list="#StructKeyList(dump)#" index="local.key">
				<cfif isSimpleValue(dump[key])>
					<cfset local.value=Trim(dump[key])>
					<cfif Len(value) eq 0><cfcontinue></cfif>
					<tr>
					<cfif Left(value,5) is "{ts '">
						<td class="col-lg-2 col-md-4"><strong class="nowrap">#parseVal(key)#</strong></td>
						<td colspan="#rowClass()#">#DateFormat(value)# #TimeFormat(value)# (#value#)</td>
					<cfelse>
						<td class="col-lg-2 col-md-4"><strong class="nowrap">#parseVal(key)#</strong></td>
						<td colspan="#rowClass()#"><samp>#value#</samp></td>
					</cfif>
					</tr>
				<cfelseif IsStruct(dump[key])>
					<cfset data=dump[key]>
					<cfif params.key eq "client" or params.key eq "personal">
						<thead><tr><th colspan="3" class="font-mono gray col-lg-2 col-md-4"><small class="nowrap">#parseHead(key)#</small></th></tr></thead>
						<tbody><tr><td colspan="3" class="font-mono gray">
					<cfelse>
						<thead><tr><th colspan="3" class="font-mono gray"><small class="nowrap">#key#</small></th></tr></thead>
						<tr><tbody>
						<td class="#columnClass(1)#">
						<span class="fa-as-first-letter fa-2x">
							<cfif structKeyExists(data, "stp")>
								<i title="#iconTitle(data.STP)#" class="fa#icon(data.STP)# fa-fw"></i>
							<cfelse>
								<i title="#iconTitle('robot')#" class="fal fa-server fa-fw"></i>
							</cfif>
						</span>
						</td><td>
					</cfif>
					<cfloop list="#StructKeyList(data)#" index="local.item">
						<cfif IsStruct(data[item])>
							<cfloop list="#StructKeyList(data[item])#" index="local.itemKey">
								<small>#Lcase(item)# #Lcase(itemKey)#</small> <code>#data[item][itemKey]#</code>.
							</cfloop>
						<cfelse>
							<cfif IsValid("date",data[item])>
								<small>#LCase(item)#</small> <code>#DateFormat(data[item])# #TimeFormat(data[item])#</code>
							<cfelse>
								<small>#LCase(item)#</small> <code>#data[item]#</code>.
							</cfif>
						</cfif>
					</cfloop>
						</td>
					</tr>
				</cfif>
			</cfloop>
			<cfif params.key is 'cgi'>
				<tr>
					<td><strong>empty values</strong></td>
					<td>
						<cfloop list="#StructKeyList(dump)#" index="local.key">
							<cfif IsStruct(data)>
								<small>#key#</small><br>
							<cfelseif Len(Trim(data)) is 0>
								<small><code>#LCase(key)#</code></small>
							</cfif>
						</cfloop>
					</td>
				</tr>
			</cfif>
		</tbody>
		</table>
	</div>
</div>
</cfoutput>