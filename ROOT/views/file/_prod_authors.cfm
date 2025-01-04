<!---
   	Credits partial view.
	path: views/files/_prod_authors.cfm

@CFLintIgnore
--->
<cfscript>
	var authors = function(string list="") {
		var credits = ""
		var cnt = 0
		if(!len(arguments.list)) return "";
		for(var author in arguments.list) {
			cnt++
			if(get('siteAreas').person) credits &= '<span>#linkTo(route="p",personname=obfuscateURL(author),text=author)#</span>'
			else credits &= '<span>#author#</span>'
			if(cnt < ListLen(arguments.list)) credits &= ", "
		}
		return credits
	}
</cfscript>
<cfoutput>
	<cfif ListLen(fileProd.credit_text)>
		<li class="list-group-item">#authors(fileProd.credit_text)#, <small class="gray-light">writer credits</small></li>
	</cfif>
	<cfif ListLen(fileProd.credit_program)>
		<li class="list-group-item">#authors(fileProd.credit_program)#, <small class="gray-light">program credits</small></li>
	</cfif>
	<cfif ListLen(fileProd.credit_illustration)>
		<li class="list-group-item">#authors(fileProd.credit_illustration)#, <small class="gray-light">design, art credits</small></li>
	</cfif>
	<cfif ListLen(fileProd.credit_audio)>
		<li class="list-group-item">#authors(fileProd.credit_audio)#, <small class="gray-light">audio, music credits</small></li>
	</cfif>
</cfoutput>