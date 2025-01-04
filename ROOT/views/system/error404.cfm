<!---
  	System error 404 view.
	path: views/system/error400.cfm

@CFLintIgnore AVOID_USING_ABORT
--->
<cfscript>
	header statuscode="404" statustext="Not Found";
	try {
		if(listFindNoCase(request.nocookies1,cgi.path_info,";")) abort;
		if(listLen(cgi.path_info,"/") >= 2 && listFindNoCase(request.nocookies2,listGetAt(cgi.path_info,2,"/"),";")) abort;
		title = "Page not found"
		pageAbout.text = '😕 This page is not found'
		pageAbout.icon = ''
	} catch(any err) {
		writeOutput("404 - Not Found")
		return
	}
</cfscript>
<!--- partial needs to be contained within cfoutput tags --->
<cftry>
	<cfoutput>#includePartial("/error/_error404-html5.cfm")#</cfoutput>
	<cfcatch type="any">404 - Not Found</cfcatch>
</cftry>