<!---
    404 - Not Found events for "production" environment
	path: events/onmissingtemplate.cfm

	Not found functions also exist at /views/system/error404.cfm for render404() function calls

@CFLintIgnore
--->
<cfscript>
	set("sendEmailOnError"=false)
</cfscript>
<cfif IsDefined("params") and params.controller is "html3">
	<!--- Default HTML3 page not found document --->
	Sorry this page request does not exist.
	<!--- return nginx header 404 error --->
<cfelse>
	<!--- Default HTML5 page not found document --->
	<cftry>
		<cfset render404()>
		<cfoutput>#includeLayout("/layout.cfm")#</cfoutput>
		<cfcatch type="any">
			😕 Sorry this page request does not exist.
		</cfcatch>
	</cftry>
</cfif>