<!---
  	Search "files" partial view.
	path: views/search/_listfiles.cfm

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
		variables.titleLink = title
		loop list=xssCleanedKey index='local.key' delimiters='|' {
			if(titleLink contains key) titleLink = citeText(titleLink,key)
			if(display.filename contains key) display.filename = citeText(display.filename,key)
			if(display.comment contains key) display.comment = citeText(collectionFiles.comment,key)
		}
	}
	variables.cnt=0
	variables.collectionFiles = results.file
	params.sort = "title"
</cfscript>
<cfoutput>
	#includePartial(partial="/file/list_table")#
</cfoutput>