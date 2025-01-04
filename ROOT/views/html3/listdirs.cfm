<!---
	HTML 3 list directories view.
	path: views/html3/listdirs.cfm

@CFLintIgnore
---><cfset includePartial("directories")><cfoutput>
<img src="#gif.blank#" alt="Icon"> <a href="#sort.name#">Name</a>                                      Count  Description<hr><img src="#gif.back#" alt="[DIR]"> <a href="#link.parent##link.suffex#">Parent Directory</a>#RepeatString(" ",29)#-   Return to the root menu.
<cfloop array="#directories#" index="dir"><img src="#gif.dir#" alt="[DIR]"> <a href="#dir.href##link.suffex#">#dir.truncName#</a>#RepeatString(" ",Abs(22+dir.truncLen))##dir.count#   #dir.description#
</cfloop></cfoutput>