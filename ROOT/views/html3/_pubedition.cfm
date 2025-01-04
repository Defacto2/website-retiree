<!---
	HTML 3 magazine partial view.
	path: views/html3/_pubedition.cfm

@CFLintIgnore
--->
<cfoutput><cfif records.section eq "magazine">
#records.group_brand_for# issue #records.record_title#
<cfelse>
<cfif Right(records.record_title,1) is '.'>#Trim(Left(records.record_title,Len(records.record_title)-1))#<cfelse>#Trim(records.record_title)#</cfif><cfif Len(records.group_brand_for)><cfif Len(records.record_title)> from <cfelse>From </cfif>#records.group_brand_for#</cfif><cfif ListFindNoCase("Dos,Java,Linux,Windows,Mac10",records.platform)> for #Trim(Replacenocase(getPlatformName(records.platform),'Apps. ',''))#</cfif></cfif></cfoutput>