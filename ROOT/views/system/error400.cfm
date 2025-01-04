<!---
  	System error 400 view.
	  path: views/system/error400.cfm

@CFLintIgnore
--->
<cfscript>
  header statuscode="400" statustext="Bad Request";
  dump(var="The request cannot be fulfilled due to bad syntax.",format="text");
</cfscript>