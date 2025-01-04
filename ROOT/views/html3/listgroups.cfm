<!---
	HTML 3 list groups view.
	path: views/html3/listgroups.cfm

@CFLintIgnore
---><cfoutput>
<img src="#gif.blank#" alt="Icon"> <a href="#sort.name#">Name</a>                                      Count  Description<hr><img src="#gif.back#" alt="[DIR]"> <a href="#link.parent#">Parent Directory</a>#RepeatString(" ",29)#-   Return to the root menu
<cfloop list="#sort.listOfResults#" index="local.result" delimiters="|"><cfset local.trunc = truncate(result,44,'..')><cfset prefix = Val(23-Len(trunc))><img src="#gif.dir#" alt="[DIR]"> <a href="/html3/group/#obfuscateURL(result)#/">#trunc#</a>#RepeatString(" ",Abs(22+prefix))#-
</cfloop></cfoutput>