<!---
	This is the parent controller file that all your controllers should extend.
	You can add functions to this file to make them globally available in all your controllers.
	Do not delete this file.
--->
<!--- /controllers/controller.cfc --->
component
	extends="wheels.Controller"
	output=false
{
param name="title" type="string" default="";
param name="breadcrumbs" type="string" default="";
param name="description" type="string" default="";
param name="canonical" type="string" default="";
param name="robotsNoIndex" type="boolean" default=false;

// Supported archive extensions for DOSee
variables.doseeExts = "zip;arc;arj;7z;rar"

variables.myapp = "myapp"
variables.siteAreas = "siteAreas"
variables.fileStats = {
	"waitingApproval":0,
	"approveall":0,
}

// Add the active user and status to the Application.WHOISONLINE session
variables.whoisString = function() {
	var user = whoisSystemType(CGI.http_user_agent)
	if(user.platform == "" && user.browser == "") return;
	session.stb = user.browser
	session.stp = user.platform
}

// Setup variables used by the system and admin pages
variables.admin = function() {
	variables.commandLists = ""
	// waiting for approval to go public
	statement = dynamicSqlForFile(params={key='waitingapproval'}).WHERESTATE
	fileStats.waitingapproval = model("Files").count(where=statement,includeSoftDeletes=true)
	// approve all records waiting to go public
	fileStats.approveall = fileStats.waitingapproval
}

if(opCheck("coop")) admin();
whoisString()
// after their onetime use, remove these functions from the global scope
variables.admin = function() {}
variables.whoisString = function() {}

/**
 * Uses the filename of digital artwork commonly found in 1990s artpacks to extract metadata
 *
 * @platform File platform
 * @fileName File name
 * @data Data structure
 */
public struct function artpackMetadata(required string platform, required string fileName, required struct data) {
	var placeholder = 'Changeme'

	var authors = function(required string group, required string initialism) {
		switch(arguments.group) {
		case 'Chaos':
			switch(arguments.initialism) {
				case 'bb': return 'Bloodbane';
				case 'cd': return 'Creeping Death';
				case 'co': return 'Corwin of Amber';
				case 'dj': return 'Dr Jekyl';
				case 'dn': return 'Dreadnought';
				case 'dt': return 'Death';
				case 'ed': return 'Emperor of Darkness';
				case 'fa': return 'Fallen Angel';
				case 'gz': return 'Ground Zero';
				case 'kr': return 'King Ram';
				case 'lc': return 'Love Child';
				case 'ls': return 'Lord South';
				case 'ln': return 'Liquid Nitrogen';
				case 'lz': return 'Lizard';
				case 'mi': return 'Malicious Insanity';
				case 'mk': return 'Master Koresh';
				case 'mo': return 'Morat the Black';
				case 'mt': return 'Minor Threat';
				case 'os': return 'Onslaught';
				case 'pm': return 'PiroManiak';
				case 'sc': return 'Silent Cry';
				case 'st': return 'Stealth';
				case 'zt': return 'Z Trasher';
				default: return "";
			}
		case 'CIA (Creators Of Intense Art)':
			switch(arguments.initialism) {
				case 'd4': return 'Defcon 4';
				case 'gf': return 'Goldfinger';
				case 'jd': return 'Jack Daniels';
				case 'na': return 'Napalm';
				case 'rb': return 'RudeBoy';
				case 'pz': return 'Prozac'; //?
				case 'sd': return 'Sudden Death';
				case 'sr': return 'Shorin-Ryu';
				case 'tl': return 'Telstar';
				case 'tr': return 'Tron';
				default: return "";
			}
		case 'iCE (Insane Creators Enterprise)':
			switch(arguments.initialism) {
				case 'tmt': return 'The Malevolent Trickster';
				case 'am': return 'Amroth';
				case 'bz': return 'Beez';
				case 'bw': return 'Black Wolf';
				case 'ca': return 'Cardiac Arrest';
				case 'cd': return 'Civil Disobedient';
				case 'cy': return 'Cyclonus';
				case 'de': return 'Dreamevil';
				case 'ds': return 'Darksider';
				case 'ed': return 'Eternal Darkness';
				case 'lm': return 'Lord Mischief';
				case 'lv': return 'Leviathan';
				case 'ic': return 'Icy';
				case 'ki': return 'Killer';
				case 'ft': return 'Frozen Tormentor';
				case 'mf': return 'MicroFarad';
				case 'mh': return 'Metal Head';
				case 'ms': return 'Mindslayer';
				case 'ml': return 'Marshal Law';
				case 'mu': return 'Mushroom';
				case 'na': return 'Napalm';
				case 'nm': return 'Necromancer';
				case 'ps': return 'Posyden';
				case 'qs': return 'Quick Silver';
				case 're': return 'Resonant';
				case 'ri': return 'Riothamus';
				case 'ro': return 'RePete Ophender';
				case 'sp': return 'The Scarlet Pimpernel';
				case 'st': return 'Stiletto';
				case 'te': return 'Tech';
				case 'tf': return 'The Feind';
				case 'tt': return 'Tempus Thales';
				case 'tu': return 'The Unforgiven';
				case 'to': return 'Tornado';
				case 'wv': return 'Wolverine';
				case 'va': return 'Vassago';
				case 'zi': return 'Zippy';
				default: return "";
			}
		case 'LTD (Licensed To Draw)':
			switch(arguments.initialism) {
				case 'ae': return 'Aerosol';
				case 'bm': return 'Boardmaster';
				case 'cb': return 'Cerberus';
				case 'ds': return 'Dark Silver';
				case 'fe': return 'Forlorn Extender';
				case 'gr': return 'Ghostrider';
				case 'gs': return 'God Speed';
				case 'gx': return 'Grafx';
				case 'lq': return 'Liquidizer';
				case 'md': return 'Mandor';
				case 'nc': return 'No Carrier';
				case 'rb': return 'Red Baron';
				case 'rm': return 'Raistlin';
				case 'se': return 'Special Ed';
				case 'vf': return 'Violent Fury';
				default: return "";
			}
		default: return "";
		}
	}
	var brands = function(required string extension) {
		switch(arguments.extension) {
			case 'air': return 'AiR (Artists In Revolt)';
			case 'chs': return 'Chaos';
			case 'cia': return 'CIA (Creators Of Intense Art)';
			case 'ice': return 'iCE (Insane Creators Enterprise)';
			case 'ltd': return 'LTD (Licensed To Draw)';
			case 'mir': return 'Mirage';
			case 'sda': return 'Silicon Dream Artists (SDA)';
			default: return "";
		}
	}
	// generate authors using nickname acronyms embedded into ANSI art filenames
	var author = function(required string group, required string filename) {
		var initialism = listFirst(arguments.filename,'-')
		if(initialism == arguments.filename) return "";
		return authors(arguments.group, initialism)
	}
	var brand = function() {
		if(!structKeyExists(data, 'group_brand_by')) return;
		if(len(data.group_brand_by.toString())) return;
		// create a group_brand_by key if it doesn't exist
		data.group_brand_by = ""
		// use file extension to determine a group's name
		if(data.platform != 'ansi' || data.platform == '') return;
		if(structKeyExists(data, 'group_brand_for') &&
			len(data.group_brand_for.toString()) &&
			data.group_brand_for != placeholder) return;
		var extension = listLast(data.fileName, '.')
		data.group_brand_by = brands(extension)
	}


	// Fix for Upload.js Custom tab, 500 error
	// https://github.com/bengarrett/Defacto2-2020/issues/62
	if(!structKeyExists(data, "group_brand_by")) data.group_brand_by = ""

	brand()
	// use the filename for the basis of credits
	switch(data.platform) {
	case 'ansi':
	case 'image':
		if(!structKeyExists(data, 'credit_illustration') || !len(data.credit_illustration.toString())) {
			var result = author(data.group_brand_by, arguments.fileName)
			if(len(result)) data.credit_illustration = result;
		}
		break;
	case 'dos':
		if(!structKeyExists(data, 'credit_program') || !len(data.credit_program.toString())) {
			var result = author(data.group_brand_by, arguments.fileName)
			if(len(result)) data.credit_program = result;
		}
		break;
	}
	// remove the placeholder group AFTER the credits logic
	if(data.platform == 'ansi') {
		if(data.group_brand_for == placeholder && len(data.group_brand_by)) {
			// swap group_brand data
			data.group_brand_for = data.group_brand_by
			data.group_brand_by = ''
		}
	}
	return data
}

/**
* Guess which executable should automatically run in the DOSee emulator
*
* @prod	File record
*/
public string function emulatorBinary(required query prod) {
	// convert a standard filename into a DOS friendly 8.3 short filename
	var dosFilename = function(required string filename) {
		// rules for 8.3 file and directory names
		// 1) any extension longer than 3 characters are dropped, .executable will return .exe
		// 2) only last dot is processed, all others are dropped, file.tar.gz will return file.gz
		// 3) all spaces are dropped, "my file.exe" will return "myfile.exe"
		// 4) commas, square brackets, semi colons, = signs and + signs are changed to underscores.
		var file = arguments.filename
		var dots = listLen(file,".")
		var brand = filenameLessExtension(file)
		// handle extension
		var extension
		if(dots > 1) {
			// cap at 3 chars
			extension = left(fileExtension(file),3)
		}
		// handle name
		name = brand
		// delete dots and spaces
		name = rEReplaceNoCase(name,"(\.|\s)", "", "all");
		// replace other chrs with underscores
		name = rEReplaceNoCase(name,"(\,|[|]|;|=|\+)","_","all");
		var dosMaximumLength = 8
		if(len(brand) > dosMaximumLength) {
			// ~1 was the character combination that DOS would append to filenames that were too long
			name = left(name, 6) & "~1"
		}
		if(len(extension)) return uCase("#name#.#extension#")
		return uCase(name)
	}

	// ordered by priority
	var programs = "bat,com,exe"
	var executables = []
	var file = arguments.prod

	// handle files other then known and supported archives
	if(!listFindNocase(doseeExts, fileExtension(file.filename), ";")) {
		if(ListFindNocase(programs,fileExtension(file.filename))) return file.filename;
		return "";
	}

	// : column is an illegal DOS filename character
	var delimiter = ":"
	// convert all newlines to a list delimiter
	var zip = file.file_zip_content;
	var carriage = chr(13)
	var linefeed = chr(10)
	zip = replaceNoCase(zip,"#carriage##linefeed#",delimiter,"all") // dos, windows
	zip = replaceNoCase(zip,linefeed,delimiter,"all") // linux, mac
	zip = replaceNoCase(zip,carriage,delimiter,"all") // 8-bit micros

	// convert any filenames to DOS friendly short filenames
	var shortNames = listToArray(zip, delimiter)
	var count=0
	for(var name in listToArray(zip, delimiter)) {
		count++
		var newName = name
		var names = 0
		// handle filenames that include relative path information
		loop list="#name#" index="local.dir" delimiters="/" {
			names++;
			var short = dosFilename(listGetAt(newName,names,"/"))
			newName = listSetAt(newName,names,short,"/")
		}
		if(newName != name) shortNames[count] = newName;
	}
	// look for & rename duplicates in shortNames
	// this currently only handles up-to 9 duplicates
	for(var name in shortNames) {
		var finds = arrayFindAllNoCase(shortNames, name)
		if(!arrayLen(finds)) continue;
		count=0
		for(var find in finds) {
			count++
			// skip first match as it will keep ~1
			if(count == 1) continue;
			// only process the last ~ in the filename
			var reversed = reverse(shortNames[find])
			reversed = replace(reversed, "1~", "#count#~")
			shortNames[find] = reverse(reversed)
		}
	}
	// search for executables
	loop list="#arrayToList(shortNames,delimiter)#" index="local.name" delimiters=delimiter {
		if(listFindNoCase(programs,listLast(name,"."))) {
			arrayAppend(executables, name)
		}
	}
	// guess program executable
	// first by comparing it to the host zip file name
	var matches = arrayLen(executables)
	if(matches == 1) return executables[1]
	if(matches > 1) {
		var basename = filenameLessExtension(file.filename)
		for(var program in programs) {
			var match = arrayFindNocase(executables, "#basename#.#program#" )
			if(match) return executables[match]
		}
	}
	// otherwise return first matched program file ordered by the extension priority
	var listMatches = arrayToList(executables, delimiter)
	var firstMatch = ""
	for(var program in programs) {
		var match = ListContainsNocase(listMatches, ".#program#", delimiter)
		if(!match) continue;
		firstMatch = trim(listGetAt(listMatches, match, delimiter))
		// check for and skip possible install, configuration & setup program names
		var configs = "install:config:setup"
		var name = listLast(firstMatch,"/")
		var skip = listFindNoCase(configs,ListFirst(name,"."),delimiter)
		if(!skip) return firstMatch
	}
	// fail-safe for when nothing else is suitable
	if(arrayLen(executables)) return executables[1]
	return ""
}

/**
 * Checks to see if the DOSee emulator should be used
 *
 * @prod Results of a `findByKey()` query in the File model
 */
public boolean function emulateFile(required query prod) {
	var programs = "exe,com,bat"
	var file = arguments.prod
	var archive = listFindNoCase(doseeExts,fileExtension(file.filename),";")
	var ansiArtpack = (file.section == "package" && file.platform == "ansi")
	if(ansiArtpack) return true;
	if(file.platform != "dos") return false; // && file.platform != "package"
	if(file.filesize lte 0 || file.filesize == "") return false;
	if(!archive) {
		if(!ListFindNocase(programs,fileExtension(file.filename))) return false;
		return true;
	}
	// if file is an archive check that it contains an executable file
	for(var program in programs) {
		if(ListContainsNocase(file.file_zip_content, ".#program#", " ")) return true;
	}
	return false;
}

/**
* Searches for the initialism of a group
*
* @group Group name
*/
public string function findInitialism(required string group="") {
	try {
		var query = model("groupnames").findOne(select="initialisms",where="pubname='#Trim(arguments.group)#'",returnas="query");
		if(query.recordCount) return Trim(query.initialisms);
	}
	catch(any err) {}
	return "";
}

/**
* Searches for a group initialism from its title.
* @initstr Initialism
*/
public string function groupInitialism(required string title) {
	// creates an initialism from a group cooperation
	var join = function(required string groups="") {
		var initialisms = ""
		for (group in listToArray(groups, ",")) {
			var find = findInitialism(group)
			if(!Len(find)) continue;
			initialisms = listAppend(initialisms, find)
		}
		return Trim(initialisms);
	}

	var initialism = findInitialism(arguments.title)
	if(len(initialism)) initialism = " (#initialism#)"
	if(ListLen(arguments.title) >= 2 && Len(initialism) <= 2) {
		initialism = join(arguments.title)
		initialism = " [#replace(initialism,",","/","all")#]"
	}
	if(len(Trim(initialism)) <= 2) return ""
	return initialism;
}

/**
* Used by `function config()` in controllers to (self) check if they are enabled in `/config-settings.cfm`
*/
public any function checkControllerState() {
	param name="params";
	if(!StructKeyExists(get('siteAreas'),params.controller)) return;
	if(get('siteAreas')[params.controller]) return;
	if(opCheck("sysop")) return;
	title = "#titleize(LCase(params.controller))# disabled"
	renderView(controller="system",action="siteareadisabled")
}

/**
* Style the list of files to be displayed.
*/
public any function filePartialToDisplay() {
	param name="params";
	if(StructKeyExists(params,"output")) {
		if(Left(params.output,4) == "card") return "list_card";
		if(Left(params.output,5) == "thumb") return "list_thumb";
	}
	// default, list as table
	return "list_table"
}

/**
* Used by `function config()` in controllers to (self) check if a 'coop' user has access.
* If access is false then a 404 error page is generated.
*/
public any function coopGiveAccess() {
	if(opCheck('coop')) return;
	if(opCheck('sysop')) return;
	render404();
}

/**
* Used by `function config()` in controllers to (self) check if a 'sysop' user has access.
* If access is false then a 404 error page is generated.
*/
public any function sysopGiveAccess() {
	if(!opCheck('sysop')) return render404();
}

/**
* Checks a session of the active user to determine if they have operator access.
*
* @access Query access type
*/
public boolean function opCheck(required string access="") {
	if(!StructKeyExists(session, 'op')) return false;
	// user is logged in with session.op = {}
	switch(arguments.access) {
	case "sysop":
		// only sys-ops
		if(session.op.sysop) return true;
		return false;
	case "coop":
		// co-ops and sys-ops
		if(session.op.sysop) return true;
		if(session.op.coop) return true;
		return false;
	default:
		return false;
	}
}

/**
* Renders a 400 error code.
* Used for internal apps such as JavaScript and API interactions.
*/
public any function render400() {
	renderView(controller="system", action="error400")
}

/**
* Renders a 404 error page.
*/
public any function render404() {
	breadcrumbs = '404 status'
	try {
		renderView(controller="system", action="error404")
	} catch(any err) {
		// this catches untraceable CFWheels 500 status errors
		header statuscode="404" statustext="Not Found";
		renderText("404 - Not Found")
	}
}

/**
* Determines browser and platform types from the user agent.
* @useragent Browser user-agent string normally fetched from `CGI.HTTP_USER_AGENT`.
*/
public struct function whoisSystemType(required string useragent) {
	var bot = function(string ua="") {
		if(ua contains "AhrefsBot") return "Ahrefs";
		if(ua contains "bingbot") return "Bing";
		if(ua contains "Facebot") return "Facebook";
		if(ua contains "facebookexternalhit") return "Facebook";
		if(ua contains "Googlebot") return "Google";
		if(ua contains "Feedfetcher-Google") return "Google";
		if(ua contains "Twitterbot") return "Twitter";
		if(ua contains "Yandex") return "Yandex";
		if(ua contains "Yahoo") return "Yahoo Slurp";
		// lesser known bots
		if(ua contains "ai_archiver") return "Alexa";
		if(ua contains "archive.org_bot") return "Wayback Machine";
		if(ua contains "Baiduspider") return "Baidu";
		if(ua contains "commoncrawl") return "CommonCrawl";
		if(ua contains "Defacto2/local") return "Defacto2 Test";
		if(ua contains "EasouSpider") return "Easou";
		if(ua contains "Mail.RU_Bot") return "Mail.RU";
		if(ua contains "MJ12bot") return "MJ12bot";
		if(ua contains "UniversalFeedParser") return "UniversalFeedParser";
		if(ua contains "voilabot") return "VoilaBot";
		return ""
	}
	var browser = function(string ua="") {
		if(ua contains "MSIE") return "Internet Explorer";
		if(ua contains "Trident") return "Internet Explorer";
		if(listLen(ua, "/") lte 1) {
			// legacy and text browsers
			if(ua contains "Navigator" && ua contains "Mozilla") return "Netscape";
			if(ua contains "Netscape" && ua contains "Mozilla") return "Netscape";
			if(Left(ua,6) == "Elinks") return "a text browser";
			if(Left(ua,5) == "Links") return "a text browser";
			if(Left(ua,4) == "Lynx") return "a text browser";
			// ?
			return "unknown"
		}
		// Chrome
		if(listLen(ua,"/") == 5 && listGetAt(ua,3,"/") contains "Chrome"
			&& listGetAt(ua,4,"/") contains "Safari") return "Chrome";
		// Firefox
		if(left(ua, 7) == "Mozilla" && ua contains "Gecko" && ua contains "Firefox") return "Firefox";
		// legacy Edge
		if(left(ua, 7) == "Mozilla" && ua contains "AppleWebKit" && ua contains "Edge") return "Edge discontinued";
		// Edge
		if(left(ua, 7) == "Mozilla" && ua contains "AppleWebKit" && ua contains "Edg") return "Edge";
		// unknown modern browser
		return listFirst(listLast(ua, " "),"/");
	}
	var platform = function(string ua="") {
		if(ua contains "Windows") {
			if(ua contains "phone") return "Windows Phone";
			return "Windows";
		}
		if(ua contains "Android") return "Android";
		if(ua contains "AppleWebKit") {
			if(ua contains "ipad") return "an IPad";
			if(ua contains "iphone") return "an IPhone";
			if(ua contains "ipod") return "an IPod";
			if(left(result.platform,5) == "an IP") return "Safari or another iOS browser";
		}
		if(ua contains "Mac OS X") {
			if(ua contains "Intel") return "Intel macOS";
			if(ua contains "M1") return "macOS"; // not tested
			return "PPC OS X";
		}
		if(ua contains "Linux") return "Linux";
		if(ua contains "Xbox One") return "XBox One";
		if(ua contains "playstation") return "Playstation";
		if(ua contains "nintendo") return "Nintendo";
		if(ua contains "Kindle") return "Kindle";
		if(ua contains "xbox") return "Xbox";
		// legacy platforms
		if(ua contains "Amiga") return "Amiga";
		if(ua contains "Beos") return "BeOS";
		if(ua contains "Blackberry") return "Blackberry";
		// unknowns
		if(ua contains "robot") return "Robot";
		if(ua contains "bot") return "Robot";
		if(ua contains "spider") return "Robot";
		return ua;
	}
	var result = {
		"ua":trim(arguments.useragent),
		"browser":"",
		"platform":"",
	}
	// robots/spiders detection
	result.browser = bot(result.ua)
	if(Len(result.browser)) {
		result.platform = "Robot"
		return result;
	}
	// browser detection
	result.browser = browser(result.ua)
	result.platform = platform(result.ua)
	return result;
}

/**
* Builds RDFa BreadcrumbList markup. http://schema.org/BreadcrumbList
* @position Breadcrumb order
* @name		Website name for display
* @href		Website link
*/
public string function appendCrumb(required number position, required string name, required string href, boolean eol=false) {
	var item = '<span property="itemListElement" typeof="ListItem">'
	item &= '<a property="item" typeof="WebPage" href="#arguments.href#"><span property="name">#arguments.name#</span></a>'
	item &= '<meta property="position" content="#arguments.position#"></span>'
	if(!arguments.eol) item &= ' / '
	return item
}
}