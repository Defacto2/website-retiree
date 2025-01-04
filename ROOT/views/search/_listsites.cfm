<!---
  	Search "websites" partial view.
	path: views/search/_listsites.cfm

@CFLintIgnore
--->
<cfscript>
	var citeLinks = function() {
		if(Find(":",website.uriref)) listaction = "visit";
		else listaction = "wayback";
		// cite query searches (keep the if() order the same as the order of display)
		loop list=xssCleanedKey index='local.key' delimiters='|' {
			if(website.title contains key) website.title = citeText(website.title,key)
			if(website.metatitle contains key) website.metatitle = citeText(website.metatitle,key)
			if(website.metadescription contains key) website.metadescription = citeText(website.metadescription,key)
			if(website.comment contains key) website.comment = citeText(website.comment,key)
			if(website.uriref contains key) website.uriref = citeText(website.uriref,key)
		}
	}
	website = results.link
	var count=0
</cfscript>
<cfoutput >
	<cfif website.recordCount is 0>
		<li>Your search <code>#xssCleanedKey#</code> did not match any links.</li>
	<cfelse>
	<cfloop query="website">
		<cfset count++>
		#citeLinks()#
		<!-- site result #count#. -->
		<li>#Trim(includePartial(partial="/link/items"))#</li>
	</cfloop>
	</cfif>
</cfoutput>