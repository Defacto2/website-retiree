<!---
	HTML 3 wget directory example view.
	path: views/html3/wgetdirs.cfm

@CFLintIgnore
---><cfset includePartial("directories")><cfoutput>
<ol><cfloop array="#directories#" index="local.dir"><li><a href="#dir.href#/#link.suffex#">#dir.truncName#</a>#RepeatString(" ",Abs(22+dir.truncLen))#</li></cfloop></ol></cfoutput>