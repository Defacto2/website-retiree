<!---
  	Search "people" partial view.
	path: views/search/_listpersons.cfm

@CFLintIgnore
--->
<cfscript>
	var cnt=0
	loop list="#q4_credits#" index="local.credit" {
		var html = ""
		cnt++
		WriteOutput('<!-- person #cnt#. #credit# -->')
		if(cnt == 1) html = '<li><h2 class="row-first-item">'
		else html = '<li><h2>'
		html &= '<i class="fal fa-angle-right fa-xs fw-fw gray"></i> '
		html &= '<a href="#UrlFor(route='p',personname=obfuscateURL(credit))#">#variables.cite(credit)#</a>'
		html &= '</h2></li>'
		WriteOutput(html)
	}
</cfscript>