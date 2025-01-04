<!---
  	Search "Enter a word or a phrase to lookup" partial view.
	path: views/search/_form.cfm

@CFLintIgnore
--->
<cfscript>
	var search = {
		"input":"search",
		"classDefault":"",
		"classBody":" readable-text",
		"label":"Enter a word or a phrase to lookup",
		"placeHolder": "Search for ?",
	}
	if(params.controller == search.input) {
		search.classDefault = search.classBody
		search.classBody = ""
	}
	if(!structKeyExists(params, 'search')) {
		// if(params.controller == "home") params.search = 'all'
		// else params.search = 'groups'
		params.search = 'all'
	}
	switch("#params.search#"){
		case "files":
			search.label = "Enter the metadata to lookup";
			break;
		case "groups":
			search.label = "Enter the groups to lookup";
			break;
		case "people":
			search.label = "Enter the people to lookup";
			break;
		case "websites":
			search.label = "Enter a word or a phrase of a website to lookup";
			break;
		case "all":
			search.label = "Enter a filename, group, person, word or a phrase to lookup";
			break;
	}
	if(params.search == "all") search.placeHolder = "Search for ..."
	else search.placeHolder = "Search for #params.search#"
</cfscript>
<cfoutput>
<div class="panel panel-default#search.classDefault#">
	#startFormTag(controller=search.input,action="processurl",method="post",id=search.input)#
	<div class="panel-body#search.classBody#">
		<cfif params.controller is search.input>
			<label for="query-input" id="search-label" class="lead">#search.label#</label>
		</cfif>
		<div class="input-group">
			<span class="input-group-btn" title="Submit search (Ctrl+Enter)" data-toggle="tooltip" data-placement="top">
				<button class="btn btn-primary" type="submit" id="clickThisButton" aria-label="Submit search">
					<i class="fal fa-search fa-fw"></i>
				</button>
			</span>
			<input type=search.input id="query-input" name="query" class="form-control" value="#params.key#" maxlength="50" aria-label="Search for #params.search#" placeholder="#search.placeHolder#" autofocus>
			<span id="s_all-span" class="input-group-addon searchfor-btns btn btn-default" title="Search files, groups, people and websites" data-toggle="tooltip" data-placement="top">
				<input id="s_all-true" name=search.input type="radio" value="all" aria-label="Search files, groups, people and websites" #variables.radio.all#>
				<!--- <label for="s_all-true"></label> --->
			</span>
			<span id="s_file-span" class="input-group-addon searchfor-btns btn btn-default" title="Search files" data-toggle="tooltip" data-placement="top">
				<input id="s_file-true" name=search.input type="radio" value="files" aria-label="Search files" #variables.radio.files#>
				<label for="s_file-true"><i class="fal fa-folder fa-fw fa-lg"></i></label>
			</span>
			<span id="s_groups-span" class="input-group-addon searchfor-btns btn btn-default" title="Search groups" data-toggle="tooltip" data-placement="top">
				<input id="s_groups-true" name=search.input type="radio" value="groups" aria-label="Search groups" #variables.radio.groups#>
				<label for="s_groups-true"><i class="fal fa-users fa-fw fa-lg"></i></label>
			</span>
			<span id="s_people-span" class="input-group-addon searchfor-btns btn btn-default" title="Search people" data-toggle="tooltip" data-placement="top">
				<input id="s_people-true" name=search.input type="radio" value="people" aria-label="Search people" #variables.radio.people#>
				<label for="s_people-true"><i class="fal fa-user fa-fw fa-lg"></i></label>
			</span>
			<span id="s_websites-span" class="input-group-addon searchfor-btns btn btn-default" title="Search websites" data-toggle="tooltip" data-placement="top">
				<input id="s_websites-true" name=search.input type="radio" value="websites" aria-label="Search websites" #variables.radio.websites#>
				<label for="s_websites-true"><i class="fal fa-external-link fa-fw fa-lg"></i></label>
			</span>
		</div>
		<p class="text-right"><small><a href="/search/result">new search</a></small></p>
	</div>
	#endFormTag()#
</div>
</cfoutput>