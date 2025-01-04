<!---
  	Search "pouet" and "demozoo" partial view.
	path: views/search/_listexternallinks.cfm

@CFLintIgnore
--->
<cfscript>
 	variables.formatFiles = function() {
		variables.cnt++
		variables.display = {
			"comment":XMLFormat(removeTags(collectionFiles.comment)),
			"filename":XMLFormat(removeTags(collectionFiles.filename)),
			"group_brand_by":titleize(collectionFiles.group_brand_by),
			"group_brand_for":titleize(collectionFiles.group_brand_for),
		}
		var title = display.filename
		if(collectionFiles.section eq "magazine") title = "#collectionFiles.group_brand_for# #collectionFiles.record_title#"
		else if(Len(collectionFiles.record_title)) title = collectionFiles.record_title
		if(title contains xssCleanedKey) title = citeText(title,xssCleanedKey);
		variables.titleLink = title
		if(display.filename contains xssCleanedKey) display.filename = citeText(display.filename,xssCleanedKey);
		if(display.comment contains xssCleanedKey) display.comment = citeText(collectionFiles.comment,xssCleanedKey);
	}
	variables.cnt=0
	params.sort = "title"
</cfscript>
<cfoutput>
	<cfif results.pouet.recordcount>
		<cfset collectionFiles = results.pouet>
		<div><a href="#get('myapp').other.pouet##xssCleanedKey#"><code>#get('myapp').other.pouet#<cite>#xssCleanedKey#</cite></code></a></div>
		#includePartial(partial="/file/list_table")#
	</cfif>
	<cfif results.demozoo.recordcount>
		<cfset collectionFiles = results.demozoo>
		<div><a href="#get('myapp').other.demozoo##xssCleanedKey#"><code>#get('myapp').other.demozoo#<cite>#xssCleanedKey#</cite></code></a></div>
		#includePartial(partial="/file/list_table")#
	</cfif>
</cfoutput>