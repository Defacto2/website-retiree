 <!---
	Dropdown menu functions
	path: views/helpers-dropmenus.cfm

@CFLintIgnore VAR_TOO_SHORT,GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN
--->
<cfscript>
	active = "active"

	/**
	* Fetches the data from the myapp settings structure that will be used to propagate dynamically generated menus.
	* @menu Menu type to determine what data to fetch.
	*/
	public struct function menuItems(required string menu) {
		// determine variable part-name to search for in the myapp settings structure
		var partialName = function(required string menu) {
			switch(arguments.menu) {
				case 'filecategory': return "menufilesection";
				case 'filemedia': return "menufileplatform";
				case 'filecollection':
				case 'fileoperatoraction':
				case 'fileoperatorlink':
				case 'organisation':
				case 'people':
				case 'www':
					return 'menu#arguments.menu#';
				default: return "";
			}
		}
		var data = {
			"listofcategories":"",
			"listofIDs":"",
			"listofKeys":"",
			"listofMenus":"",
			"listofNames":"",
			"settingsPartVar" = ""
		}
		var item = {
			"category":"",
			"id":"",
			"key":"",
			"menu":"",
			"name":"",
		}
		var partial = {
			"name":"",
			"len":0,
		}
		partial.name = partialName(arguments.menu)
		partial.len = Len(partial.name)
		if(!partial.len) {
			return data
		}
		data.settingsPartVar = partial.name
		/* loop through the list of variable names */
		for(var name in listToArray(StructKeyList(get(myapp)), ",")) {
			if(!partial.len) continue;
			if(Left(name,partial.len) != partial.name) continue;
			if(!IsStruct(get(myapp)[name])) continue;
			var value = get(myapp)[name]
			if(!StructKeyExists(value,'name')) continue;
			// fetch and append the list classed under 'item.name' to a list of categories
			if(StructKeyExists(value,'category')) item.category &= ",#value.category#";
			item.id &= ",#name#"
			item.name &= ",#value.name#"
			item.menu &= ";#value.name#:#name#"
		}
		/* propagate temporary list containers */
		item.category = ListSort(item.category,'textnocase')
		item.key = LCase(ReplaceNoCase(item.id,partial.name,'','all'))
		item.id = ListSort(item.id,'textnocase')
		item.key = ListSort(item.key,'textnocase')
		item.menu = LCase(ReplaceNoCase(item.menu,partial.name,'','all'))
		item.menu = ListSort(item.menu,'textnocase','asc',';')
		item.name = ListSort(item.name,'textnocase')
		data.listofcategories = item.category
		data.listofIDs = item.id
		data.listofKeys = item.key
		data.listofMenus = item.menu
		data.listofNames = item.name
		/* loop through categories (if they exist) and associate them with names */
		var previous = ""
		for(var category in listToArray(item.category,",")){
			if(previous == category) continue;
			previous = category
			var ids = ""
			for(var id in listToArray(item.id,",")) {
				if(!IsStruct(get(myapp)[id])) continue;
				var value = get(myapp)[id]
				if(!StructKeyExists(value,'category')) continue;
				if(value.category != category) continue;
				ids &= ",#value.name#;#id#"
			}
			var key = ReplaceNoCase(category,' ','','all')
			data[key] = ListSort(ids,'textnocase')
		}
		return data;
	}

	/**
	* Uses the data fetched by `menuItems()` combined with `params` to generate HTML links for dynamically generated menus.
	*/
	public struct function menuTitles(required struct params) {
		var key = function() {
			var files = "menufilecollection#params.key#"
			var ops = "menufileoperator#params.key#"
			if(structKeyExists(get(myapp), files)) return get(myapp)[files].name;
			if(structKeyExists(get(myapp), ops)) return get(myapp)[ops].name;
			return ""
		}
		var title = function() {
			var files = ' files'
			var all = "-"
			var use = {
				"platform":iif(params.platform != all,de(true),de(false)),
				"section":iif(params.section != all,de(true),de(false)),
				"key":iif(params.key != all,de(true),de(false)),
			}
			var head = {
				"title":"",
				"section":"",
				"platform":"",
				"key":"",
			}
			/* If needed, humanize person's name or organisation */
			if(params.controller == "person") head.title = '#deobfuscateURL(params.personname)#';
			if(params.controller == "organisation") head.title = '#organisationFormat(deobfuscateURL(params.orgname))#';
			/* Humanize params.section and params.platform and params.key */
			if(use.platform) head.platform = humanizePlatform(params.platform);
			else if(use.section) {
				head.section = humanizeSection(params.section)
				if(Len(singularize(head.section)) LT Len(head.section)) head.section = singularize(head.section);
			}
			if(use.key)	head.key = key();
			// Create a HEADER if both platform and section exist
			if(use.platform and use.section) {
				var join = ' '
				// If both head.platform and head.section contain 3 words or more, add a comma to to mark the two off
				if(countWords(head.platform & ' ' & head.section) gte 3) join = ', ';
				head.title &= ', ' & head.platform & join & head.section & files
			}
			// Create a HEADER if only platform exist
			else if(use.platform) head.title &= ', ' & head.platform & files;
			// Create a HEADER if only section exist
			else if(use.section) head.title &= ', ' & head.section & files;
			// Create a HEADER if key exists
			else if(use.key) head.title &= ', ' & head.key & files;
			// Create a HEADER if neither platform or section exist and controller is not person or organisation controller
			else if(!ListFindNoCase("person,organisation", params.controller)) head.title = "all files";
			// Recent additions modifier
			if(params.section == '-' && params.platform == '-' && params.sort == 'posted_desc') head.title = "recent additions";
			// Clean-up header if it prefixed with a comma ", "
			if(Left(head.title, 2) == ", ") head.title = Mid(head.title, 3, Len(head.title)-2);
			// Create the returned HTML TITLE from the HEADER
			return Trim(head.title)
		}
		var data = {
			"title":"",
			"header":"",
		}
		var dataTitle = title()
		data.title = dataTitle
		if(dataTitle != "recent additions") {
			data.header = capitalize(Trim(dataTitle))
		}
		return data
	}
</cfscript>