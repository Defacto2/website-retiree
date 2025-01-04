<!---
    Error events for "production" environment
	path: events/onapplicationend.cfm

@CFLintIgnore AVOID_USING_CFDUMP_TAG
--->
<cfsilent>
	<cfscript>
		// create our own cfwheels style url params
		var path = cgi.path_info
		var pathLen = listLen(path, "/")
		params = { "controller" = "", "action" = "", "key" = "" }
		if(len(path)) {
			if(pathLen >= 1) params.controller = listGetAt(path, 1, "/");
			if(pathLen >= 2) params.action = listGetAt(path, 2, "/");
			if(pathLen >= 3) params.key = listGetAt(path, 3, "/");
		}
	</cfscript>
</cfsilent>
<cfif params.controller is "html3">
	<!--- HTML3 render --->
	<cfinclude template="/views/error/_error500-html3.cfm">
<cfelse>
	<!--- HTML5 render --->
    <cfif (params.action neq "testhtml5error" and StructKeyExists(session, 'op'))>
		<div>
		  <cfdump var="#arguments.exception#" label="Arguments.EXCEPTION">
		</div>
		<div>
		  <cfdump var="#request#" label="REQUEST" expand="false">
		</div>
	<cfelse>
		<cfinclude template="/views/error/_error500-html5.cfm">
	</cfif>
</cfif>