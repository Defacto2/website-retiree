<!---
	HTML 3 published date partial view.
	path: views/html3/_datepublished.cfm

@CFLintIgnore
--->
<cfoutput><cfif Len(records.date_issued_day)>#NumberFormat(records.date_issued_day,"00")#-<cfelse>??-</cfif><cfif Len(records.date_issued_month)>#Left(MonthAsString(records.date_issued_month),3)#-<cfelse>???-</cfif><cfif Len(records.date_issued_year)>#records.date_issued_year#<cfelse>????</cfif></cfoutput>