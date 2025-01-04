<!---
	HTML 3 posted date partial view.
	path: views/html3/_dateposted.cfm

@CFLintIgnore
--->
<cfoutput><cfif Len(records.createdAt)>#DateFormat(records.createdAt,"DD-MMM-YYYY")#<cfelse>??-???-????</cfif></cfoutput>