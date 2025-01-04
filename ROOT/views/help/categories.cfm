<!---
	Categories used help view.
	path: views/help/categories.cfm

@CFLintIgnore
--->
<cfscript>
	var platforms	= ""
	var sections	= ""
	var platformKey	= "menufileplatform"
	var sectionKey	= "menufilesection"
	var name 		= "name"
	var store 		= get(myapp)
	var keys		= StructKeyList(store)
	// fetch and reorder data for platforms
	for (var key in keys) {
		if(Left(key,Len(platformKey)) != platformKey) continue;
		platforms &= store?.key?.name ?: ",#get(myapp)[key].name#"; ""
	}
	var sortedPlatforms = ListSort(platforms,'textnocase')
	// fetch and reorder data for sections
	for (var key in keys) {
		if(Left(key,Len(sectionKey)) != sectionKey) continue;
		sections &= store?.key?.name ?: ",#get(myapp)[key].name#"; ""
	}
	var sortedSections = ListSort(sections,'textnocase')
	pageAbout.text = 'Platforms and tags for sorting'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='allowedUploads')#"></button>
	</span>
	</form>
<div class="readable-text">
	<div class="panel panel-default">
	<div class="panel-heading lead">Media and platforms</div>
		<div class="list-group">
		<cfloop list="#sortedPlatforms#" index="local.platform">
			<cfset search = StructFindValue(get(myapp),'#platform#','all')>
			<cfloop array="#search#" index="local.data">
			<cfif !StructKeyExists(data,'path')	or Left(data.path,Len(platformKey)+1) neq ".#platformKey#"><cfcontinue /></cfif>
<a href="http://#data.owner.www#" class="list-group-item"><!--- #LinkTo(href="http://#data.owner.www#",text=data.owner.www)# --->
<h4 class="list-group-item-heading">#Capitalize(data.owner.name)#</h4>
<p class="list-group-item-text">#data.owner.description#<cfif Len(data.owner.technical)><br><em>Geek fluff: #data.owner.technical#</em></cfif></p></a>
			</cfloop>
		</cfloop>
		</div>
	</div>

	<div class="panel panel-default">
	<div class="panel-heading lead">Tags</div>
		<div class="list-group">
		<cfloop list="#sortedSections#" index="local.section">
			<cfset search = StructFindValue(get(myapp),'#local.section#','all')>
			<cfloop array="#search#" index="local.data">
			<cfif !StructKeyExists(data,'path') or Left(data.path,Len(sectionKey)+1) neq ".#sectionKey#"><cfcontinue /></cfif>
<a href="http://#data.owner.www#" class="list-group-item">
<h4 class="list-group-item-heading">#Capitalize(data.owner.name)#</h4>
<p class="list-group-item-text">#data.owner.description#</p></a>
			</cfloop>
		</cfloop>
		</div>
	</div>
</div>
</cfoutput>