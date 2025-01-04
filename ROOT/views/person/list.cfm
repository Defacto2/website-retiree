<!---
  	People list view.
	path: views/person/list.cfm

@CFLintIgnore
--->
<cfscript>
	var default = "btn-default"
	var primary = "btn-primary"
	var buttons = function() {
		switch(params.key) {
			case '-': button.badge = 'people'; button.all=primary; break;
			case 'artists': button.badge = 'artists'; button.artists=primary; break;
			case 'coders': button.badge = 'coders and programmers'; button.coders=primary; break;
			case 'musicians': button.badge = 'musicians'; button.musicians=primary; break;
			case 'writers': button.badge = 'writers'; button.writers=primary; break;
			default:
		}
	}
	var button = {
		"badge":"",
		"artists":default,
		"coders":default,
		"musicians":default,
		"writers":default,
		"all":default
	}
	buttons()
</cfscript>
<cfoutput>
	<form method="post">
		<div class="btn-toolbar grouping nav-toolbar-container" role="toolbar">
			<div class="btn-group btn-group-sm">
				<button type="button" class="btn btn-default" disabled><span class="mobile-hide">ROLES</span><span class="mobile-show"><i class="fal fa-tags"></i></span></button>
				<button type="submit" class="btn #button.artists#" formaction="#urlFor(route='personFilter',key='artists')#"><i class="fal fa-paint-brush fa-lg fa-fw"></i><span class="mobile-hide"> ARTISTS</span></button>
				<button type="submit" class="btn #button.coders#" formaction="#urlFor(route='personFilter',key='coders')#"><i class="fal fa-keyboard fa-lg fa-fw"></i><span class="mobile-hide"> CODERS</span></button>
				<button type="submit" class="btn #button.musicians#" formaction="#urlFor(route='personFilter',key='musicians')#"><i class="fal fa-music fa-lg fa-fw"></i><span class="mobile-hide"> MUSICIANS</span></button>
				<button type="submit" class="btn #button.writers#" formaction="#urlFor(route='personFilter',key='writers')#"><i class="fal fa-pen-alt fa-lg fa-fw"></i><span class="mobile-hide"> WRITERS</span></button>
				<button type="submit" class="btn #button.all#" formaction="#urlFor('personList')#"><i class="fal fa-user fa-lg fa-fw"></i><span class="mobile-hide"> ALL</span></button>
			</div>
		</div>
	</form>
	<!--- pagination statistics --->
	<div class="pagination-statistics">
		<span class="label label-default">#listLen(creditsList)# #button.badge#</span>
	</div>
	<!--- operator feedback notices --->
	<cfif flashCount()>
		#flashMessages(class="alert alert-info")#
	</cfif>
	<div class="columns-list" id="person-drill-down">
		<!--- list items --->
		#includePartial("items")#
	</div>
</cfoutput>