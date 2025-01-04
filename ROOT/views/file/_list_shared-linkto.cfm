<!---
	List title and filename, partial view.
	path: views/files/_list_shared-linkto.cfm

	Creates a link to the file detail page.
	It is shared between the table, thumbs and card lists.

@CFLintIgnore
--->
<cfscript>
	var linkTo = function() {
		if(!StructKeyExists(params,"orgname")) {
			if(!StructKeyExists(params,"platform")) return ""
			if(!StructKeyExists(params,"section")) return ""
			if(!StructKeyExists(params,"sort")) return ""
			if(!StructKeyExists(params,"key")) return ""
		}
		var link = "platform=#params.platform#&section=#params.section#&sort=#params.sort#"
		if(StructKeyExists(params,"orgname") && len(params.orgname)) {
			return "name=#params.orgname#&src=o&#link#"
		}
		if(StructKeyExists(params,"personname") && len(params.personname)) {
			return "name=#params.personname#&src=p&#link#"
		}
		return "name=#params.key#&#link#"
	}
	variables.linkParams = linkTo()
	linkToDetails = '<a href="#UrlFor(route="f",key=obfuscateParam(collectionFiles.id),"aria-label"="View file",params=linkParams)#">#titleLink#</a>'
</cfscript>