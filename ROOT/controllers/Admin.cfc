<!---
	Database admin controller file.
	path: controllers/admin.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{

	// admin database initialisation
public any function config() {
	filters(through="checkControllerState")
	// require coop or sysop for everything except these actions
	filters(through="coopGiveAccess", except="session")
	// block these actions from coop users
	filters(through="sysopGiveAccess", only="cachereset,logs,pathsdashboard,testhtml3error,testhtml5error")
}

variables.title = "Admin"
variables.breadcrumbs &= 'admin / '
variables.description = ""
variables.robotsNoIndex = true

// create a unique list of items for data-list auto-competition
private string function _dataList(required string name) {
	var query = queryNew("")
	switch(arguments.name) {
		case "organisation":
			query = model("organisation").getGroups(key="-",includeSoftDeletes=true)
			return _dataListSort(query)
		case "person":
			query = model("person").getPeople(key="-",includeSoftDeletes=true)
			return _dataListSort(query)
		default:
			return ""
	}
}

private string function _dataListSort(required query data) {
	var list = ""
	for(var row in arguments.data) {
		list &= ',#row.pubCombined#'
	}
	arguments.data = queryNew("") // empty the data as it isn't needed
	var struct = {}
	for (var row in listToArray(list, ",")) {
		struct[trim(row)] = ""
	}
	list = "" // empty the list as it is also too large
	// list sort a struct key list is the most performant option
	return ListSort(StructKeyList(struct),"textnocase","asc")
}

public any function dashboard() {
	pageAbout.text = title = "Database dashboard"
	pageAbout.icon = 'fal fa-database'
	breadcrumbs &= 'database dashboard'
}

public any function initialism() {
	param name="params";
	param name="params.key" default="";
	switch(params.key){
	case "update":
		param name="params.modifyGroup" default="";
		param name="params.initialism" default="";
		var find = findInitialism(params.modifyGroup)
		var count = model("Organisation").Count(where="group_brand_for='#params.modifyGroup#' OR group_brand_by='#params.modifyGroup#'",includeSoftDeletes=true)
		var update = ""
		// make sure the group exist
		if(count == 0) {
			flashInsert(danger="#params.modifyGroup# does not exist in the database")
			redirectTo(action="organisation")
		}
		// do nothing
		if(find == params.initialism) {
			flashInsert(warning="'#find#' is already applied to #params.modifyGroup#");
			redirectTo(action="organisation")
		}
		// delete
		if(find != "" && params.initialism == "") {
			update = model("Initialism").findOneByPubname("#params.modifyGroup#")
			if(update.delete()) {
				flashInsert(success="Removed '#find#' from #params.modifyGroup#");
				redirectTo(action="organisation")
			}
			flashInsert(danger="Could not remove '#find#' from #params.modifyGroup#");
			redirectTo(action="organisation")
		}
		// new
		if(find == "" && params.initialism != "") {
			update = model("Initialism").new()
			update.initialisms="#params.initialism#"
			update.pubname="#params.modifyGroup#"
			if(update.save()) {
				flashInsert(success="Applied '#params.initialism#' to #params.modifyGroup#");
				redirectTo(action="organisation")
			}
			flashInsert(danger="Could not apply '#params.initialism#' to #params.modifyGroup#");
			redirectTo(action="organisation")
		}
		// update
		if(find != params.initialism) {
			update = model("Initialism").findOneByPubname("#params.modifyGroup#")
			update.initialisms="#params.initialism#"
			if(update.save()) {
				flashInsert(success="Applied '#params.initialism#' to #params.modifyGroup#");
				redirectTo(action="organisation")
			}
			flashInsert(danger="Could not apply '#params.initialism#' to #params.modifyGroup#");
			redirectTo(action="organisation")
		}
		flashInsert(warning="Unexpected conditional problem, cannot delete, create, update or skip '#params.initialism#'")
		redirectTo(action="organisation")
		return;
	default:
		return render404();
	}
}

public any function organisation() {
	param name="params";
	param name="params.key" default="";
	pageAbout.text = title = "Manage " & get("siteAreas").titles.organisation
	pageAbout.icon = 'fal fa-users'
	breadcrumbs &= 'groups'
	// params.key functions
	switch(params.key){
	case "":
	case "index":
		variables.groups = model("organisation").getInitialisms()
		variables.groupDatalist = _dataList("organisation")
		return;
	case "confirm":
		param name="params.renameGroup" default="";
		param name="params.renameTo" default="";
		// make sure new name exists
		if(!Len(params.renameTo)) {
			flashInsert(danger="You have not provided a replacement group name");
			redirectTo(action="organisation")
		}
		var count = model("Organisation").Count(where="group_brand_for='#params.renameGroup#' OR group_brand_by='#params.renameGroup#'",includeSoftDeletes=true)
		var exists = model("Organisation").Count(where="group_brand_for='#params.renameTo#' OR group_brand_by='#params.renameTo#'",includeSoftDeletes=true)
		// make sure source records exist
		if(count == 0) {
			flashInsert(danger="#params.renameGroup# does not exist in the database")
			redirectTo(action="organisation")
		}
		variables.rename = {
			"action":"organisation",
			"key":"save",
			"count":count,
			"exists":exists,
			"valueOld":params.renameGroup,
			"valueNew":organisationFormat(params.renameTo),
		}
		renderView(controller="system",action="templateprompt")
		return;
	case "save":
		param name="params.valueOld" default="";
		param name="params.valueNew" default="";
		var count = model("Organisation").Count(where="group_brand_for='#params.valueOld#' OR group_brand_by='#params.valueOld#'",includeSoftDeletes=true)
		if(!count) {
			flashInsert(danger="#params.valueOld# does not exist in the database")
			redirectTo(action="organisation")
		}
		model("File").updateAll(
			group_brand_for="#params.valueNew#",
			where="group_brand_for='#params.valueOld#'",
			includeSoftDeletes=true,instantiate=true);
		model("File").updateAll(
			group_brand_by="#params.valueNew#",
			where="group_brand_by='#params.valueOld#'",
			includeSoftDeletes=true,instantiate=true);
		flashInsert(success="Renamed #params.valueOld# to #params.valueNew#");
		redirectTo(action="organisation");
		return;
	default:
		return render404();
	}
}

public any function person() {
	param name="params";
	param name="params.key" default="";
	pageAbout.text = title = 'Manage people'
	pageAbout.icon = 'fal fa-user'
	breadcrumbs &= 'people'
	switch(params.key){
	case "":
	case "index":
		variables.distinctList = _dataList("person")
		return;
	case "confirm":
		param name="params.renamePerson" default="";
		param name="params.renameTo" default="";
		// make sure new name exists
		if(!Len(params.renameTo)) {
			flashInsert(danger="You have not provided a replacement person name");
			redirectTo(action="person")
		}
		var count = model("Person").Count(where="#sqlPerson(params.renamePerson)#",includeSoftDeletes=true)
		var exists = model("Person").Count(where="#sqlPerson(params.renameTo)#",includeSoftDeletes=true)
		if(count == 0) {
			flashInsert(danger="#params.renamePerson# does not exist in the database")
			redirectTo(action="person")
		}
		variables.rename = {
			"action":"person",
			"key":"save",
			"count":count,
			"exists":exists,
			"valueOld":params.renamePerson,
			"valueNew": ReReplaceNocase(params.renameTo,get(myapp).acceptedDirChrs,'','all'),
		}
		renderView(controller="system",action="templateprompt")
		return;
	case "save":
		param name="params.valueOld" default="";
		param name="params.valueNew" default="";
		// fetch uuid of records that contain source name in credits
		var query = model("Person").findAll(where="#sqlPerson(params.valueOld)#",select="uuid",includeSoftDeletes=true,returnAs="query")
		if(!query.recordCount) {
			flashInsert(danger="#params.valueOld# does not exist in the database")
			redirectTo(action="person")
		}
		var uuids = ValueList(query.uuid)
		// make source and newName params RegEx friendly
		params.valueOld = obfuscateRegEx(params.valueOld)
		params.valueNew = obfuscateRegEx(params.valueNew)
		// loop through list of uuids
		var person = queryNew("")
		for (var uuid in listToArray(uuids, ",")) {
			var roles = "credit_text,credit_program,credit_illustration,credit_audio"
			person = model("Person").findOneByUUID(uuid="#uuid#",select="id,#roles#",includeSoftDeletes=true)
			// loop through the 4 roles for each record & then pattern and replace
			for (var role in listToArray(roles, ",")) {
				if(REFindNoCase('^#params.valueOld#$',person[role])) person[role] = REReplaceNoCase(person[role],'^#params.valueOld#$','#params.valueNew#');
				else if(REFindNoCase('^#params.valueOld#,',person[role])) person[role] = REReplaceNoCase(person[role],'^#params.valueOld#,','#params.valueNew#,');
				else if(REFindNoCase(',#params.valueOld#$',person[role])) person[role] = REReplaceNoCase(person[role],',#params.valueOld#$',',#params.valueNew#');
				else if(REFindNoCase(',#params.valueOld#,',person[role])) person[role] = REReplaceNoCase(person[role],',#params.valueOld#,',',#params.valueNew#,');
				person.save();
			}
		}
		// handle errors
		if(person.hasErrors()) {
			flashInsert(danger="Cannot rename #params.valueOld# to #params.valueNew#")
			renderView(action="person")
			return;
		}
		flashInsert(success="#params.valueOld#' is now #params.valueNew#")
		redirectTo(action="person")
		return;
	default:
		return render404();
	}
}
}