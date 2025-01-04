<!---
  	Website pagination partial view.
	path: views/link/_inputPagination.cfm

@CFLintIgnore
--->
<cfscript>
	var link = {
		"prev":"",
		"next":""
	}
	var page = { "prev": "", "next": "" }
	var admin = {
		"icon": "plus-square",
		"colour": "success"
	}
	if(Len(Trim(website.deletedAt))){
		admin.icon		= 'minus-square'
		admin.colour	= 'danger'
	}
	if(!Len(navigation.previous)) page.prev = "disabled";
	else link.prev = URLFor(controller='link',action='edit',key=obfuscateParam(navigation.previous),rel='nofollow')
	if(!Len(navigation.next)) page.next = "disabled";
	else link.next = URLFor(controller='link',action='edit',key=obfuscateParam(navigation.next),rel='nofollow')
</cfscript>
<cfoutput>
	<!-- pagination -->
	<div class="btn-toolbar grouping nav-toolbar-container" role="toolbar">
		<form method="post">
			<fieldset class="btn-group btn-group-sm">
			<button id="GotoPrevPage" #page.prev# type="submit" class="btn btn-default" formaction="#link.prev#" title="Go to the previous file"><i class="fal fa-arrow-alt-left fa-fw fa-lg"></i></button>
			<button id="GotoNextPage" #page.next# type="submit" class="btn btn-default" formaction="#link.next#" title="Go to the next file"><i class="fal fa-arrow-alt-right fa-fw fa-lg"></i></button>
			</fieldset>
		</form>
		<form method="post">
			<fieldset class="btn-group btn-group-sm btn-group-as-form">
			<cfif !variables.edit.local>
				<button class="btn btn-default" disabled><i class="fal fa-globe fa-fw fa-lg"></i></button>
				<button type="submit" class="btn btn-warning" formaction="#URLFor(controller='link',action='httpreset',key=params.key)#" title="Clear HTTP response data"><i class="fal fa-times fa-fw fa-lg"></i></button>
			</cfif>
			</fieldset>
			<fieldset class="btn-group btn-group-sm btn-group-as-form">
				<button type="submit" class="btn btn-#admin.colour#" formaction="#URLFor(controller='link',action='operator',key=params.key)#" title="Link and record public accessibility"><i class="fal fa-external-link fa-fw fa-lg"></i> <i class="fal fa-#admin.icon# fa-fw fa-lg"></i></button>
			</fieldset>
			#hiddenFieldTag(name="uuid",value="#website.uuid#")#
			#hiddenFieldTag(name="function",value="#edit.button#")#
		</form>
	</div>
	<div class="pagination-statistics">
		<!-- pagination statistics -->
		<span class="label label-default">#navigation.idPosition# of #LCase(pluralize(word="link",count=navigation.idCount))#</span>
	</div>
</cfoutput>