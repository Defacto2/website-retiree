<!---
	Home controller
	path: controllers/Home.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	public any function config() {
		filters(through="checkControllerState")
	}

	title = "Retro cracking and art underground"
	description = "Defacto2 is the premier destination for old school files and historical texts of the underground PC cracking, BBS and art scenes"
	canonical = "/"

	public string function recentfiles() {
		set(showDebugInformation=false);
		cfheader( name="Content-Type", value="application/json" )
		onlyProvides("json");
		var files = model('File').findAll(maxrows=100,order='createdat DESC',
			select='id,uuid,record_title,group_brand_for,group_brand_by,filename,date_issued_year,createdat,updatedat')
		var json = queryNew("uuid,urlid,title", "Varchar,Varchar,Varchar")
		for (var file in files){
			queryAddRow(json)
			querySetCell(json, 'uuid', lCase(files.uuid))
			querySetCell(json, 'urlid', obfuscateParam(files.id))
			var title = '#timeAgoInWords(fromTime=files.updatedat,toTime=now())# ago, '
			if(len(file.record_title) && len(file.filename)) title &= ' #file.record_title# (#file.filename#)'
			else if(len(file.filename)) title &= '#file.filename#'
			if(len(file.group_brand_for)) title &= ' for #file.group_brand_for#'
			else if(len(file.group_brand_for)) title &= ' by #file.group_brand_by#'
			if(len(file.date_issued_year)) title &= ' in #file.date_issued_year#'
			if(right(title,1) == ',') title = mid(title, 1, len(title)-1)
			querySetCell(json, 'title', title)
		}
		renderText(SerializeJson(json));
	}

	public string function whoandwhere() {
		renderPartial(layout=false,partial="whoandwhere")
	}

	public string function index() {
		var last = model('File').findAll(maxrows=1,order='createdat DESC',select='updatedat')
		variables.homeFileCount = model('File').count(includeSoftDeletes=false)
		variables.timeAgo = '#timeAgoInWords(fromTime=last.updatedat,toTime=now())# ago'
	}

	public string function countbots() {
		set(showDebugInformation=false);
		cfheader( name="Content-Type", value="application/json" )
		onlyProvides("json");
		var count = whoisBotCount();
		var jsontext = count
		if(!len(count)) jsontext = '"error"';
		renderText(SerializeJson(jsontext));
	}

	public string function counthumans() {
		set(showDebugInformation=false);
		cfheader( name="Content-Type", value="application/json" )
		onlyProvides("json");
		var count = whoisHumanCount();
		var jsontext = count
		if(!len(count)) jsontext = '"error"';
		renderText(SerializeJson(jsontext));
	}

	/**
	* Counts the number of search engine robots connected to the site.
	* @listConnections	If true list the total number of connected bot sessions,
	*					Google & Bing bots together have 15 bot connections.
	* 					If false return the number of different bot types,
	* 					Google & Bing are 2 bot connections.
	*/
	private numeric function whoisBotCount(boolean listConnections=false) {
		var botList = ""
		var sessions = createObject("java","coldfusion.runtime.SessionTracker").getSessionCollection(Application.applicationname)
		// conditional containers
		for (var sess in sessions) {
			browser = structKeyExists(sessions[sess], "stb");
			platform = structKeyExists(sessions[sess], "stp");
			var stb = false
			var stp = false
			var bot = false
			if(browser) stb = isSimpleValue(sessions[sess].stb);
			if(platform) {
				stp = isSimpleValue(sessions[sess].stp)
				bot = sessions[sess].stp == "Robot"
			}
			if(!browser) continue;
			if(!platform) continue;
			if(!stb) continue;
			if(!stp) continue;
			if(!bot) continue;
			// append bot
			if(len(trim(sessions[sess].stb))) {
				botList = listAppend(botList, sessions[sess].stb);
				continue;
			}
			// append unknown bot
			botList = listAppend(botList, "Generic");
		}
		if(!listConnections) {
			// remove duplicate entries of bots,
			// so 5 Googlebot connections counts as 1 Google bot.
			botList = listRemoveDuplicates(botList)
		}
		return listLen(botList);
	}

	/**
	* Counts the number of human users connected to the site.
	*/
	private numeric function whoisHumanCount() {
		var obj = createObject("java","coldfusion.runtime.SessionTracker").getSessionCollection(Application.applicationname)
		var sessions = structCount(obj)
		var bots =  Val(whoisBotCount(listConnections=true))
		var humans = sessions - bots
		return humans;
	}
}