<!---
	Upload controller file.
	path: controllers/Upload.cfc

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	// upload initialisation
	public any function config() {
		filters(through="checkControllerState,checkDriveQuota");
		provides("html,json");
	}

	title = "Upload";
	breadcrumbs &= appendCrumb(2, 'send us files', urlFor(controller='upload', action='file'))
	description = 'Upload and submit files to Defacto2'
	variables.groupsDatalist = model("upload").getFormattedInitialisms();

	pageAbout.text = 'Uploader'
	pageAbout.icon = ''

	if(get('environment') == 'development') {
		pageAbout.text &= '<br><small class="text-warning">This form does not work in the cfwheels development environment</small>'
	}

	/**
	* Completely disable controller if server disk-drive space is low.
	*/
	public any function checkDriveQuota() {
		param name="params";
		var quotaPercentage = 2
		if(serverDisk().freepercentage < quotaPercentage) {
			title = "#titleize(LCase(params.controller))# Disabled (quota)"
			renderView(controller="system",action="siteareadisabled")
		}
	}

	public any function index() {
		redirectTo(controller="upload", action="file", statusCode="301")
	}

	/**
	* @hint Returns the SAUCE meta-data (http://www.acid.org/info/sauce/sauce.htm) attached to the EOF.
	* @file Absolute path to file.
	* @binary Return unprocessed SAUCE binary data in as Native and CFML arrays.
	*/
	private struct function _fileSAUCE(required string file, boolean binary=false) {
		// Known issues:
		// The following are not implemented: Comments, Flags, Filesize, TInfoS
		var path = arguments.file
		// number of tail characters to fetch from the files
		var sauceRange = 128
		// characters 1 to characterRange will be treated as ASCII text
		var characterRange = 90
		// characters 91 - 128 will be treated as binary data
		var unsignedRange = (sauceRange-characterRange)
		var result = {
			"bin":{},
			"fileFound":false,
			"sauce":false,
			"filePath":path,
			"bin":{
				"bytes":"",
				"date":"",
			},
			"version":"",
			"title":"",
			"author":"",
			"group":"",
			"date":"",
		}
		// data and file type containers
		var dataType = {
			"name":['None','Character','Bitmap','Vector','Audio','BinaryText','XBin','Archive','Executable'],
			"desc":['Undefined filetype.','A character based file.','Bitmap graphic and animation files.','A vector graphic file.','An audio file.',
			'This is a raw memory copy of a text mode screen. Also known as a .BIN file.','An XBin or eXtended BIN file.','An archive file.','A executable file.'],
		}
		var fileType = {
			// none
			"name"[1]:['-'],
			"desc"[1]:['Undefined filetype.'],
			// character (text)
			"name"[2]:['ASCII','ANSi','ANSiMation','RIP script','PCBoard','Avatar','HTML','Source','TundraDraw'],
			"desc"[2]:['Plain ASCII text file with no formatting codes or color codes.','A file with ANSi coloring codes and cursor positioning.',
			'Like an ANSi file, but it relies on a fixed screen size.','Remote Imaging Protocol graphics.','A file with PCBoard color codes, macros and ANSi codes.',
			'A file with Avatar color and ANSi codes.','HyperText Markup Language.','Source code for some programming language.','A TundraDraw file.'],
			// bitmap
			"name"[3]:['GIF','PCX','LBM/IFF','TGA','FLI','FLC','BMP','GL','DL','WPG','PNG','JPEG','MPEG','AVI','ICO'],
			"desc"[3]:['CompuServe Graphics Interchange Format','ZSoft Paintbrush PCX','DeluxePaint LBM/IFF','Targa Truecolor','Autodesk FLI animation',
			'Autodesk FLC animation','Windows or OS/2 Bitmap','Grasp GL Animation','DL Animation','Wordperfect Bitmap','Portable Network Graphics',
			'JPEG image (any subformat)','MPEG video (any subformat)','Audio Video Interleave (any subformat)','Windows Icon'],
			// vector
			"name"[4]:['DXF','DWG','WPG','3DS'],
			"desc"[4]:['CAD Drawing eXchange Format','AutoCAD Drawing File','WordPerfect or DrawPerfect vector graphics','3D Studio'],
			// audio (and music)
			"name"[5]:['MOD','669','STM','S3M','MTM','FAR','ULT','AMF','DMF','OKT','ROL','CMF','MID','SADT','VOC','WAV','SMP8','SMP8S','SMP16','SMP16S',
			'PATCH8','PATCH16','XM','HSC','IT'],
			"desc"[5]:['4, 6 or 8 channel MOD (NoiseTracker)','Renaissance 8 channel 669','Future Crew 4 channel ScreamTracker',
			'Future Crew variable channel ScreamTracker 3','Renaissance variable channel MultiTracker','Farandole composer','UltraTracker',
			'DMP/DSMI Advanced Module Format','Delusion Digital Music Format (XTracker)','Oktalyser','AdLib ROL file (FM audio)','Creative Music File (FM Audio)',
			'MIDI (Musical Instrument Digital Interface)','SAdT composer (FM Audio)','Creative Voice File','Waveform Audio File Format',
			'Raw, single channel 8bit sample','Raw, stereo 8 bit sample','Raw, single-channel 16 bit sample','Raw, stereo 16 bit sample',
			'8 bit patch file','16 bit patch file','FastTracker ]:[ module','HSC Tracker (FM Audio)','Impulse Tracker'],
			// binary text
			"name"[6]:['BinaryText'],
			"desc"[6]:['Binary screen image'],
			// extended binary text
			"name"[7]:['XBin'],
			"desc"[7]:['eXtended Bin'],
			// archive
			"name"[8]:['ZIP','ARJ','LZH','ARC','TAR','ZOO','RAR','UC2','PAK','SQZ'],
			"desc"[8]:['PKWare Zip.','Archive Robert K. Jung','Haruyasu Yoshizaki (Yoshi)','S.E.A.','Unix TAR','ZOO','RAR','UC2','PAK','SQZ'],
			// executable
			"name"[7]:['-'],
			"desc"[7]:['Any executable file. .exe, .dll, .bat, ... Executable scripts such as .vbs should be tagged as Source.'],
		}
		if(!FileExists(path)) {
			result.fileFound = false
			result.sauce = false
			return result;
		}
		var file = FileOpen(path, 'readBinary')
		// fetch sauce data from EOF
		var read = FileRead(file)
		var sauceData = Right(read,sauceRange)
		FileClose(file)
		// see if data is SAUCE otherwise abort function
		if(FindNocase('sauce',sauceData) && Left(sauceData,5) != "SAUCE") {
			// attempt to fix any white-space positioning issues
			if(Left(Trim(sauceData),5) == "SAUCE") sauceData = Trim(sauceData);
			else {
				// found 'SAUCE' but it's not in the expected location.
				result.filefound = true
				result.sauce = true
				return result;
			}
		}
		if(Left(sauceData,5) != "SAUCE") {
			result.filefound = true
			result.sauce = false
			return result;
		}
		result.filefound = true
		result.sauce = true
		// fetch binary encoded data from the sauce data
		var unsignedData = Right(sauceData,UnsignedRange)
		// decode binary data and apply the DOS code page 437 character set
		var bytes = ToBinary(CharsetDecode(unsignedData, 'CP437'))
		// copy data to RAW var
		result.bin.bytes = bytes
		result.id = Mid(SAUCEData,1,5)
		result.version = Mid(SAUCEData,6,2)
		result.title = Mid(SAUCEData,8,35)
		result.author = Mid(SAUCEData,43,20)
		result.group = Mid(SAUCEData,63,20)
		var date = Mid(SAUCEData,83,8)
		result.bin.date = date
		result.date = ""
		try {
			result.date = CreateDate(Left(date,4), Mid(date,5,2), Right(date,2))
		} catch('expression') {
			// catch and retry non-numeric data or invalid date ranges
			try {
				// sometimes the data uses US style dates yyyy-dd-mm
				result.date = CreateDate(Left(date,4), Right(date,2), Mid(date,5,2))
			} catch('expression') {}
		}
		// The original file size not including the SAUCE information.
		// filesize is currently ignored as CFML needs extra work to handle negative int.
		result.bin.filesize = arraySlice(bytes,1,4)
		//  Type of data
		var dataValue = arraySlice(bytes,5,1)
		// SAUCE array first elements are 0 while in CFML it is 1
		dataValue = (dataValue[1]+1)
		result.datatype = (dataValue-1)
		result.datatypeName = ""
		result.datatypeDescription = ""
		if(IsNumeric(dataValue) && dataValue > 0 && dataValue < 9) {
				result.datatypeName = dataType.name[dataValue]
				result.datatypeDescription = dataType.desc[dataValue]
		}
		//  Type of file
		var fileValue = arraySlice(bytes,6,1)
		// SAUCE array first elements are 0 while in CFML it is 1
		fileValue = (fileValue[1]+1)
		result.filetype = (fileValue-1)
		result.filetypeName = ""
		result.filetypeDescription = ""
		if(IsNumeric(fileValue) && fileValue > 0 && fileValue < 26) {
				result.filetypeName = fileType.name[dataValue][fileValue]
				result.filetypeDescription = fileType.desc[dataValue][fileValue]
		}
		// Return Data and File types to original values
		dataValue = result.datatype
		fileValue = result.filetype
		var ti1 = arraySlice(bytes,7,2)
		result.bin.TInfo1 = ti1
		result.TInfo1 = ti1[1]
		result.TInfo1Name = fileSauceTInfo(dataValue,fileValue).TInfo1
		var ti2 = arraySlice(bytes,9,2)
		result.bin.TInfo2 = ti2
		result.TInfo2 = ti2[1]
		result.TInfo2Name = fileSauceTInfo(dataValue,fileValue).TInfo2
		var ti3 = arraySlice(bytes,11,2)
		result.bin.TInfo3 = ti3
		result.TInfo3 = ti3[1]
		result.TInfo3Name = fileSauceTInfo(dataValue,fileValue).TInfo3
		result.TInfo4 = ""
		result.bin.TInfo4 = arraySlice(bytes,13,2)
		var byteValue = arraySlice(bytes,15,1)
		result.comments = YesNoFormat(byteValue[1])
		result.bin.comments = byteValue
		result.TFlags = ""
		result.bin.TFlags = arraySlice(bytes,16,1)
		result.TInfoS = ""
		result.bin.TInfoS = arraySlice(bytes,17,22)
		if(!arguments.binary) StructDelete(result, 'bin');
		return result;
	}

	/**
	 * Parse the Demozoo JSON response
	 *
	 * @import Demozoo JSON data as a structure
	 */
	private any function _parseAPIDemozoo(required struct import) {
		var platform = 10
		var section = 11
		var json = []
		json[1] = {"id":"record_title","v":""}
		json[2] = {"id":"group_brand_for","v":""}
		json[3] = {"id":"group_brand_by","v":""}
		json[4] = {"id":"date_issued_day","v":""}
		json[5] = {"id":"date_issued_month","v":""}
		json[6] = {"id":"date_issued_year","v":""}
		json[7] = {"id":"credit_program","v":""}
		json[8] = {"id":"credit_illustration","v":""}
		json[9] = {"id":"credit_audio","v":""}
		json[platform] = {"id":"platform","v":""}
		json[section] = {"id":"section","v":""}
		json[12] = {"id":"list_links","v":""}
		json[13] = {"id":"web_id_pouet","v":""}
		json[14] = {"id":"credit_text","v":""}
		json[15] = {"id":"thumbnail1","v":""}
		json[16] = {"id":"thumbnail2","v":""}
		json[17] = {"id":"thumbnail3","v":""}
		json[18] = {"id":"web_id_youtube","v":""}
		json[19] = {"id":"comment","v":""}
		// section checks come first
		// this switch should match
		for (var item in import.types) {
			if(json[section].v neq "") break;
		 	switch(item.name) {
				// Production releases
				case "Diskmag": case "Textmag":
					json[section].v = "magazine";
				break;
				case "Game": case "Intro": case "Demo":
					json[section].v = "demo";
				break;
				case "BBStro":
					json[section].v = "bbs";
				break;
				case "Cracktro":
					json[section].v = "releaseadvert";
				break;
				case "Tool":
					json[section].v = "programmingtool";
				break;
				case "Executable Graphics": case "4K Executable Graphics":
					json[section].v = "logo";
					//json[platform].v = "dos";
				break;
				case "ASCII Collection":
					json[section].v = "package";
					json[platform].v = "text";
				case "Artpack": case "Pack":
					json[section].v = "package";
				break;
				// Graphics releases
				case "Graphics":
					json[section].v = "logo";
					json[platform].v = "image";
				break;
				case "ANSI":
					json[section].v = "logo";
					json[platform].v = "ansi";
				break;
				case "ASCII":
					json[section].v = "logo";
					json[platform].v = "text";
				break;
				// Music releases
				case "Music": case "Musicdisk": case "Tracked Music":
					json[section].v = "demo";
					json[platform].v = "audio";
				break;
				case "Executable Music": case "32K Executable Music": case "64K Executable Music":
					json[section].v = "demo";
				case "Music Pack":
					json[section].v = "package";
					json[platform].v = "audio";
				default:
					if(FindNoCase(substring="application generator", string=import.title)) {
						json[section].v = "groupapplication";
						break;
					}
					if(Right(item.name,5) == "Intro") {
						json[section].v = "demo";
						break;
					}
		 	}
		}
		// handle a possible empty platform
		for(var item in import.platforms) {
			if(json[platform].v neq "") break;
			switch(item.name) {
				case "Browser": case "Flash": case "Javascript":
					json[platform].v = "markup";
				break;
				case "Java":
					json[platform].v = "java";
				break;
				case "Linux":
					json[platform].v = "linux";
				break;
				case "MS-Dos":
					json[platform].v = "dos";
				break;
				case "Windows":
					json[platform].v = "windows";
				break;
				default:
			}
		}
		// if there is no section and no platform, then the production is unsuitable
		if(json[platform].v eq "" || json[section].v eq "") {
			if(len(import.platforms)) {
				return "The production '#import.title#' for the #import.platforms.first().name# does not look suitable for Defacto2";
			}
			return "The production '#import.title#' does not look suitable for Defacto2";
		}
		// sanitise data
		json[1].v = import.title
		// groups
		found = 0
		for (var item in import.author_nicks) {
			found += 1
			if(found == 1) json[2].v = item.name
			if(found == 2) json[3].v = item.name
			if(found > 2) break;
		}
		// handle Demozoo's quirks
		var demozooQuirks = function() {
			// fix titles that contain 'x FTP' or 'x BBS'
			if (right(import.title,4) == ' BBS' || right(import.title,4) == ' FTP') {
				if (!found) {
					json[1].v = ''
					json[2].v = import.title
					return;
				}
				if (!Len(json[3].v)) {
					// blank record_title
					json[1].v = ''
					// copy group_brand_for to group_brand_by
					json[3].v = json[2].v
					// set group_brand_for to eq title
					json[2].v = import.title
					return;
				}
			}
			if (import.title contains 'application generator') {
				json[section].v = "groupapplication"
				return;
			}
			// else if title contains 'x FTP (?)' or 'x BBS (?)' then swap data
			var bbs = reFindNoCase(' BBS \([^\d]*(\d+)[^\d]*\)$', import.title)
			if (bbs) {
				// blank record_title
				json[1].v = ''
				// copy group_brand_for to group_brand_by
				json[3].v = json[2].v
				// set group_brand_for to eq title with ' BBS (?)' dropped
				json[2].v = left(import.title, bbs) & ' BBS'
				return;
			}
			var ftp = reFindNoCase(' FTP \([^\d]*(\d+)[^\d]*\)$', import.title)
			if (ftp) {
				// blank record_title
				json[1].v = ''
				// copy group_brand_for to group_brand_by
				json[3].v = json[2].v
				// set group_brand_for to eq title with ' FTP (?)' dropped
				json[2].v = left(import.title, ftp) & ' FTP'
				return;
			}
		}
		demozooQuirks()
		// dates
		if(!isNull(import.release_date)) {
			slugs = listToArray(import.release_date,"-")
			if(arrayLen(slugs) > 2) json[4].v = slugs[3]
			if(arrayLen(slugs) > 1) json[5].v = NumberFormat(slugs[2])
			if(arrayLen(slugs)) json[6].v = slugs[1]
		}
		// credits
		for(var item in import.credits) {
			switch(item.category) {
				case "Code": json[7].v = listAppend(json[7].v,item.nick.name);
				break;
				case "Graphics": json[8].v = listAppend(json[8].v,item.nick.name);
				break;
				case "Music": json[9].v = listAppend(json[9].v,item.nick.name);
				break;
				case "Text": json[14].v = listAppend(json[14].v,item.nick.name);
				break;
				default:
			}
		}
		// download link
		if(arrayLen(import.download_links)) json[12].v = import.download_links[1].url
		// screenshots
		found = 0
		for(var item in import.screenshots) {
			found += 1
			if(found == 1) json[15].v = item.thumbnail_url
			if(found == 2) json[16].v = item.thumbnail_url
			if(found == 3) json[17].v = item.thumbnail_url
			if(found > 3) break;
		}
		return json
	}

	/**
	 * Parse the Pouet JSON response
	 *
	 * @import Pouet JSON data as a structure
	 */
	private any function _parseAPIPouet(required struct import) {
		local.json = []
		json[1] = {"id":"record_title","v":""}
		json[2] = {"id":"group_brand_for","v":""}
		json[3] = {"id":"group_brand_by","v":""}
		json[4] = {"id":"date_issued_day","v":""}
		json[5] = {"id":"date_issued_month","v":""}
		json[6] = {"id":"date_issued_year","v":""}
		json[7] = {"id":"credit_program","v":""}
		json[8] = {"id":"credit_illustration","v":""}
		json[9] = {"id":"credit_audio","v":""}
		json[10] = {"id":"platform","v":""}
		json[11] = {"id":"section","v":""}
		json[12] = {"id":"list_links","v":""}
		json[13] = {"id":"web_id_demozoo","v":""}
		json[14] = {"id":"thumbnail1","v":""}
		json[15] = {"id":"web_id_youtube","v":""}
		json[16] = {"id":"comment","v":""}
		// check platform
		var slugs = ["java","linux","msdos","msdosgus","php","windows"]
		var found = 0
		var slug = ""
		for (var item in import.platforms) {
			found = arrayContainsNoCase(slugs, import.platforms[item].slug)
			if(found) {
				slug = "true";
				continue;
			}
			slug = "#import.platforms[item].name#"
		}
		if(slug != "true") return "The #slug# platform used by the production '#import.name#' does not look suitable for Defacto2";
		slugs = ["java","linux","dos","dos","php","windows"] // DO NOT DELETE duplicates
		json[10].v = slugs[found]
		// check types
		slug = ""
		slugs = ["bbstro","cracktro","demo","demotool","diskmag","game","intro"]
		for (var item in import.types) {
			found = arrayContainsNoCase(slugs, item)
			if(found) {
				slug = "true";
				break;
			}
			slug = item
		}
		if(slug != "true") {
			if(len(item) >= 2 && len(item) <= 4 && (Right(item,1) == "b" || Right(item,1) == "k")) {
				// item as string with the last chr dropped
				if(isNumeric(left(item,len(item)-1))) {
					// treat 32b to 256k types as intros
					found = 3;
					slug = "true";
				}
			}
		}
		if(slug != "true") return "The #slug# type used with the production '#import.name#' does not look suitable for Defacto2";
		// sanitise types
		slugs = ["bbs","releaseadvert","demo","programmingtool","magazine","demo","releaseadvert"]
		json[11].v = slugs[found]
		// sanitise data
		if(arrayLen(import.groups) >= 1) json[2].v = import.groups[1].name
		if(arrayLen(import.groups) >= 2) json[3].v = import.groups[2].name
		if(!IsNull(import.releaseDate)) {
			slugs = listToArray(import.releaseDate,"-")
			if(arrayLen(slugs) >= 3) json[4].v = slugs[3]
			if(arrayLen(slugs) >= 2) json[5].v = NumberFormat(slugs[2])
			if(arrayLen(slugs) >= 1) json[6].v = slugs[1]
		}
		for (var item in import.credits) {
			// removes comments within brackets
			item.role = REReplaceNoCase(item.role, '\((.+?)\)', '', 'all')
			for (var slug in item.role) {
				slug = lCase(slug)
				switch(slug) {
					case "code":
						json[7].v = listAppend(json[7].v,item.user.nickname);
						break;
					case "music":
						json[9].v = listAppend(json[9].v,item.user.nickname);
						break;
					case "2d": case "3d": case "design": case "graphics": case "font": case "logo": case "ascii": case "ansi": {
						json[8].v = listAppend(json[8].v,item.user.nickname);
						slug = true
						break;
					}
				}
			}
		}
		// complete JSON
		json[1].v = import.name
		if(!isNull(import.download)) json[12].v = import.download
		if(!isNull(import.demozoo)) json[13].v = import.demozoo
		if(!isNull(import.screenshot)) json[14].v = import.screenshot
		return json
	}

	/**
	* Lookup and fetch the title of a Demozoo ID in JSON format.
	* @id Demozoo ID to lookup.
	* @method Either `extenalUpload`, `json` or `title`
	*
	* note: append a m=dump pair to the queryString to dump() the data
	* 		/upload/lookup-demozoo/1?m=dump
	*/
	public any function lookupDemozoo(string id="#params.key#",string method="title") {
		set(showDebugInformation=false);
		cfheader( name="Content-Type", value="application/json" )
		onlyProvides("json")

		var errors = function(string id="") {
			if(IsSimpleValue(htmlData) && htmlData contains "404") return "Demozoo ID #arguments.id# is invalid"
			if(!IsStruct(htmlData)) return "Demozoo API did not work"
			if(!StructKeyExists(htmlData, "title")) return "Demozoo API did not return a title"
			return ""
		}

		if(structKeyExists(params,"m")) arguments.method = params.m
		var protocol = "https"
		if(CGI.server_name == "localhost") protocol = "http"
		var htmlData = downloadHTML('#protocol#://demozoo.org/api/v1/productions/#arguments.id#?format=json','GET')
		if(arguments.method == "dump") {
			dump(htmlData)
			abort;
		}
		var json = errors()
		if(len(json)) {
			renderText(SerializeJSON(json))
			return;
		}
		switch(arguments.method) {
			case "extenalUpload":
				var exist = model("Upload").Count(where="web_id_demozoo=#params.key#",includeSoftDeletes=true)
				if(exist) {
					json = "Demozoo ID #arguments.id# already exists on Defacto2";
					renderText(SerializeJSON(json))
					return;
				}
				json = _parseAPIDemozoo(htmlData)
				break;
			case "json":
				json = htmlData
				break;
			case "title":
				json = htmlData.title
				if(!StructKeyExists(htmlData, "author_nicks")) break;
				for (var nick in htmlData.author_nicks) {
					if(structKeyExists(nick.releaser, "is_group") && nick.releaser.is_group) {
						if(json == htmlData.title) json = "#json# by #nick.name#"
						else json = "#json#, #nick.name#"
					}
				}
				break;
			default:
				render404()
				return;
		}
		renderText(SerializeJSON(json))
	}

	/**
	* Lookup and fetch the title of a Pouet ID in JSON format.
	* @id Pouet ID to lookup.
	* @method Either `extenalUpload`, `json` or `title`
	*
	* note: append a m=dump pair to the queryString to dump() the data
	* 		/upload/lookup-pouet/1?m=dump
	*/
	public any function lookupPouet(string id="#params.key#",string method="title") {
		if(structKeyExists(params,"m")) arguments.method = params.m
		set(showDebugInformation=false);
		if(arguments.method != "dump") {
			cfheader( name="Content-Type", value="application/json" )
			onlyProvides("json")
		}
		var errors = function(string id="") {
			if(IsSimpleValue(htmlData) && htmlData contains "404") return "Pouët ID #arguments.id# is invalid"
			if(!IsStruct(htmlData)) return "Pouët API did not work"
			if(!StructKeyExists(htmlData, "success")) return "The Pouët API said the request failed"
			if(!htmlData.success) return "The Pouët API said the request failed"
			if(!StructKeyExists(htmlData.prod, "name")) return "Pouët API did not return a title"
			return ""
		}
		var htmlData = downloadHTML('http://api.pouet.net/v1/prod/?id=#arguments.id#','GET')
		if(arguments.method == "dump") {
			dump(htmlData)
			abort;
		}
		if(StructKeyExists(htmlData, "error")) {
			json = "Pouët ID #arguments.id# is invalid";
			renderText(SerializeJSON(json))
			return ""
		}
		switch(arguments.method) {
			case "extenalUpload":
				// match to existing id
				exist = model("Upload").Count(where="web_id_pouet=#params.key#",includeSoftDeletes=true)
				if(exist) {
					json = "Pouët ID #arguments.id# already exists on Defacto2";
					renderText(SerializeJSON(json))
				}
				json = _parseAPIPouet(htmlData.prod)
				break;
			case "json":
				json = htmlData.prod
				break;
			case "title":
				json = htmlData.prod.name
				if(!StructKeyExists(htmlData.prod, "groups")) break;
				for (var group in htmlData.prod.groups) {
					if(!structKeyExists(group, "name")) continue;
					if(json eq htmlData.prod.name) {
						json = "#json# by #group.name#"
						continue;
					}
					json = "#json#, #group.name#"
				}
				break;
			default:
				render404()
				return;
		}
		renderText(SerializeJSON(json))
	}

	/**
	* Lookup and fetch the title of a YouTube video ID in JSON format.
	* @id YouTube ID to lookup.
	*/
	public any function lookupYouTube(string id="#params.key#", boolean debug=false) {
		set(showDebugInformation=false);
		cfheader( name="Content-Type", value="application/json" )
		onlyProvides("json")

		var title = function() {
			if(structKeyExists(htmlData,'statuscode')) {
				if(htmlData.statuscode contains "400") return "YouTube API did not work";
				if(htmlData.statuscode contains "404") return "YouTube ID #arguments.id# is invalid";
				return ""
			}
			if(structKeyExists(htmlData, "error") && structKeyExists(htmlData.error, "message")) {
				return "YouTube ID #arguments.id# returned the error: " & htmlData.error.message
			}
			return htmlData.items[1].snippet.title
		}
		// API v3 (JSON based, requires API key)
		if(get(myapp).youtube.lookup == "") {
			//json = "YouTube requires a Google API key that is missing"
			json = "YouTube ID looks okay"
			renderText(SerializeJSON(json))
			return;
		}
		var htmlData = receiveURL(url='#get(myapp).youtube.lookup##arguments.id#')
		if(structKeyExists(params,"m")) arguments.method = params.m
		if(arguments.method == "dump") {
			dump(htmlData)
			abort;
		}
		renderText(SerializeJSON(title()))
	}

	public any function art() {
		onlyProvides("html")
		title = "Send us your art"
		breadcrumbs &= appendCrumb(3, 'art', urlFor(controller='upload', action='art'))
		newFile = model("Upload").new()
	}

	public any function document() {
		onlyProvides("html")
		title = "Send us your documents"
		breadcrumbs &= appendCrumb(3, 'documents', urlFor(controller='upload', action='document'))
		newFile = model("Upload").new()
	}

	public any function external() {
		onlyProvides("html")
		title = "Demozoo or Pouët suggestions"
		breadcrumbs &= appendCrumb(3, 'Demozoo or Pouët', urlFor(controller='upload', action='external'))
		variables.newFile = model("Upload").new()
		newFile.postprocess = false
		variables.newFilePlatform = model("Upload").findAll(select="platformText,platform",order="platformText",distinct=true,where="platform IS NOT NULL")
		variables.newFileSection = model("Upload").findAll(select="sectionText,section",order="sectionText",distinct=true,where="section IS NOT NULL")
	}

	public any function intro() {
		onlyProvides("html")
		title = "Send us your intros"
		breadcrumbs &= appendCrumb(3, 'intro + cracktros', urlFor(controller='upload', action='intro'))
		variables.newFile = model("Upload").new()
	}

	public any function file() {
		onlyProvides("html")
		title = "Send us your files"
		variables.newFile = model("Upload").new()
	}

	public any function magazine() {
		onlyProvides("html")
		title = "Send us your magazines"
		breadcrumbs &= appendCrumb(3, 'magazines', urlFor(controller='upload', action='magazine'))
		variables.newFile = model("Upload").new()
	}

	public any function site() {
		onlyProvides("html")
		title = "Send us your adverts"
		breadcrumbs &= appendCrumb(3, 'adverts', urlFor(controller='upload', action='site'))
		variables.newFile = model("Upload").new()
	}

	public any function other() {
		onlyProvides("html")
		title = "Send us your files"
		breadcrumbs &= appendCrumb(3, 'other', urlFor(controller='upload', action='other'))
		variables.newFile = model("Upload").new()
		newFile.postprocess = false
		variables.newFilePlatform = model("Upload").findAll(select="platformText,platform",order="platformText",distinct=true,where="platform IS NOT NULL")
		variables.newFileSection = model("Upload").findAll(select="sectionText,section",order="sectionText",distinct=true,where="section IS NOT NULL")
	}

	public any function submitFile() {
		try {
			_submitFile()
		} catch(any err) {
			// This error catch must be a JSON friendly output so upload.js can display the issue
			cfheader(statuscode=500);
			var error = {message=err.message,trace=left(err.stacktrace,999),variables=params}
			renderText(serializeJSON(error))
		}
	}

	/**
	 * The internal function of submitFile()
	 */
	private any function _submitFile() {
		param = params
		var page = function() {
			switch(params.newFile.uploadtype) {
				case "external":
					return "pouet_demozoo";
				case "note":
					return "file";
				case "magazine":
				case "art":
				case "other":
					return params.newFile.uploadtype;
				case "intro":
				case "site":
				case "document":
				case "art":
					return params.newFile.uploadtype;
				default:
					return ""
			}
		}
		var validate = function() {
			switch(params.newFile.uploadtype) {
				case "note":
					return ["comment"];
				case "magazine":
				case "art":
				case "other":
					return ["group_brand_for"];
				case "intro":
				case "site":
				case "document":
				case "art":
					return ["group_brand_for"];
				default:
					return [];
			}
		}
		var errors = function() {
			if(pageToRender !== "pouet_demozoo") {
				// error output for JSON
				if(structKeyExists(params,"operator") &&
					structKeyExists(params.operator, "xhr2") &&
					params.operator.xhr2) return;
				// error output for HTML
				for(var inspect in fieldstovalidate) {
					if(!Len(params.newFile[inspect])) {
						flashInsert(error="Please make sure the highlighted fields are completed");
					}
				}
				if(!structKeyExists(params,"file0")) flashInsert(error="Please make sure the highlighted fields are completed");
				if(!Len(params.file0)) flashInsert(error="Please make sure the highlighted fields are completed");
				if(flashKeyExists('error')) return renderView(template=pageToRender);
			}
		}
		// determine if an upload is for a BBS or FTP site
		var site = function() {
			if (structKeyExists(param.newFile, "section") && params.newFile.section == "bbs") return -1
			if (structKeyExists(param.newFile, "section") && params.newFile.section == "ftp") return -1
			if (param.newFile.uploadtype == "site") {
				if(right(param.newFile.group_brand_for,3) == "bbs") return 0
				if(right(param.newFile.group_brand_for,3) == "ftp") return 1
			}
			return -1
		}
		// accept & use file's Last Modification Date as the release date
		var dateMod = function(date last) {
			var siteType = site()
			if(siteType == -1) return;
			if(!isDate(last)) return;
			if(structKeyExists(params.newFile, "date_issued_year")) return;
			if(siteType == 0) {
				if(dateCompare(last, '1/1/1981', 'yyyy') lt 1) return;
				if(dateCompare(last, '1/1/1998', 'yyyy') gt 1) return;
			}
			if(siteType == 1) {
				if(dateCompare(last, '1/1/1995', 'yyyy') lt 1) return;
				if(dateCompare(last, '1/1/2015', 'yyyy') gt 1) return;
			}
			params.newFile.date_issued_year = last.year()
			params.newFile.date_issued_month = last.month()
			params.newFile.date_issued_day = last.day()
		}
		// if the FORM data is missing then respond with an error in JSON format
		if(!structKeyExists(params, "newFile")) {
			fileProcessed.itemNumber = gethttprequestdata().headers["X-File-Count"] ?: ""
			fileProcessed.clientfile = gethttprequestdata().headers["X-File-Name"] ?: ""
			fileProcessed.filesize = gethttprequestdata().headers["X-File-Size"] ?: ""
			fileProcessed.errors = [{"message":"The form and its input data is missing from this upload submission; maybe the file transfer is too large"}]
			return renderView(layout=false,template="responseasync");
		}
		// server validation of form used as a fall-back when client has no JavaScript or HTML5 support.
		// see: /javascript/src/upload.js for client side validation
		var pageToRender = page()
		var fieldstovalidate = validate()
		errors()
		setting RequestTimeout = get(myapp).timeoutUp;
		// variables
		filesProcessed = [] // this needs to be un-scoped!
		// form input containing the selected files
		params.newFile.filename = "file0"
		// file last modified date
		var parseLastMod = ""
		var fileName = ""
		if(structKeyExists(gethttprequestdata().headers, "X-File-Last-Modified")) {
			var xLastMod = gethttprequestdata().headers["X-File-Last-Modified"]
			parseLastMod = parseDateTime(xLastMod)
			var lastMod = createODBCDateTime(parseLastMod)
			params.newFile.file_last_modified = lastmod
		}
		// original name
		// NOTE: HTTP Headers do not support Unicode characters.
		if(structKeyExists(gethttprequestdata().headers, "X-File-Name")) {
			fileName = gethttprequestdata().headers["X-File-Name"]
		}
		// parse metadata for automation
		// ANSI files for BBSes
		if(parseLastMod != "") dateMod(parseLastMod);
		if(structKeyExists(param.newFile, 'platform') && structKeyExists(param.newFile, 'section')) {
			// extract metadata from the original filename
			if(len(fileName)) {
				// get artist credits from the filename?
				params.newFile = artpackMetadata(param.newFile.platform, fileName, params.newFile)
			}
		}
		// save file to server and data to database, return results to filesProcessed
		fileProcessed = _savefile(params)
		// render response for client's browser
		if(pageToRender == "pouet_demozoo") {
			return renderView(layout=false,template="responseasync")
		}
		if(structKeyExists(params.operator, "xhr2") and params.operator.xhr2) {
			if(structKeyExists(gethttprequestdata().headers, "X-File-Count")) {
				fileProcessed.itemNumber = gethttprequestdata().headers["X-File-Count"];
			}
			// client has asynchronous transfers enabled so don't render a layout
			return renderView(layout=false,template="responseasync")
		}
		// client uses synchronous transfers or javascript disabled
		title = "Submit File"
		renderView(template="responsesync")
	}

	public any function submitWebsite() {
		if(!structKeyExists(params, "newSite")) {
			render400();
			return;
		}
		onlyProvides("html")
		title = "Send us a website link"
		variables.newSite = model("Link").new(params.newSite)
		// for security disable new resource using a soft delete
		newSite.deletedAt = CreateODBCDateTime(Now())
		// trim trailing forward slash /
		if(Right(newSite.uriRef,1) == "/") newSite.uriRef = Left(newSite.uriRef,(Len(newSite.uriRef)-1));
		// save form to database
		newSite.save();
		if(newSite.hasErrors()) {
			renderView(action="website");
			return;
		}
		flashInsert(success="Thank you, your link has been submitted for review and should be added shortly");
		redirectTo(controller="upload");
	}

	public any function website() {
		onlyProvides("html")
		title = "Send us a website link"
		variables.newSite = model("Link").new();
	}

	/**
	* Save an uploaded file to server storage and add data to the database.
	*/
	private struct function _saveFile() {
		// to view the response use the upload form /upload/file and submit an upload.
		// in the browser console or netowrk panel view the XHR POST response /upload/submit-file?format=json
		// the file, size, type, wassave, wasstored and errors array are returned.
		param = params;
		if(!structKeyExists(params.newFile, "uploadtype")) {
			render400();
			return;
		}
		// format and remove any initialisms from input forms
		var clean = function(required string group) {
			var fixed = group
			if(group contains "(" and group contains ")") {
				var fix = REMatchNoCase("\(([^]]+)\)", group)
				fixed = Mid(fix[1], 2, Len(fix[1])-2)
			}
			return organisationFormat(fixed)
		}
		// return structure
		var reply = {
			"clientfile":"",
			"filesize":-1,
			"contenttype":"",
			"contentsubtype":"",
			"wassaved":false,
			"wasstored":false,
			"errors":[],
		}
		// fetch a list of platforms and sections
		var newFilePlatform = model("Upload").findAll(select="platformText,platform",distinct=true,where="platform IS NOT NULL")
		var newFileSection = model("Upload").findAll(select="sectionText,section",distinct=true,where="section IS NOT NULL")
		var newFile = queryNew("")
		// format section
		switch(params.newFile.uploadtype) {
			case "art":
				newFile = model("UploadArt").new(params.newFile)
				newFile.section = "logo"
				break;
			case "document":
				newFile = model("UploadDocument").new(params.newFile)
				newFile.section = "releaseinformation"
				break;
			case "external":
				// demozoo and pouet submissions
				newFile = model("UploadExternal").new(params.newFile)
				break;
			case "intro":
				newFile = model("UploadIntro").new(params.newFile)
				newFile.section = "releaseadvert"
				break;
			case "magazine":
				newFile = model("UploadDocument").new(params.newFile)
				newFile.section = "magazine"
				break;
			case "site":
				newFile = model("UploadSite").new(params.newFile)
				if(Right(params.newFile.group_brand_for,4) == " BBS") newFile.section = "bbs";
				if(Right(params.newFile.group_brand_for,5) == " BBS)") newFile.section = "bbs";
				if(Right(params.newFile.group_brand_for,4) == " FTP") newFile.section = "ftp";
				if(Right(params.newFile.group_brand_for,5) == " FTP)") newFile.section = "ftp";
				break;
			default:
				newFile = model("Upload").new(params.newFile);
		}
		// use the elvis operator to create blank form values if they were not supplied by the form
		newFile.web_id_youtube = newFile.web_id_youtube ?: ""
		newFile.web_id_pouet = newFile.web_id_pouet ?: ""
		newFile.web_id_demozoo = newFile.web_id_demozoo ?: ""
		newFile.preview_image = newFile.preview_image ?: ""
		newFile.list_links = newFile.list_links ?: "";
		params.operator.postprocess = params.operator.postprocess ?: false;
		// create blank or default variables
		newFile.clientfileext = ""
		// for security disable new upload using a soft delete
		newFile.deletedAt = CreateODBCDateTime(Now())
		newFile.file_integrity_weak = ""
		newFile.file_integrity_strong = ""
		newFile.upload1 = {
			"clientfile":"",
			"contenttype":"",
			"contentsubtype":"",
			"filesize":"",
			"timeLastModified":"",
			"serverfullpath":"",
			"serverdirectory":"",
			"serverfile":"",
		 }
		// upload file to server
		// delete filename to skip file handling
		if(params.newFile.uploadtype == "external") newFile.fileName = "";
		if(StructKeyExists(newFile,"fileName") && Len(newFile.fileName)) {
			cffile = FileUploadAll(
				destination=get(myapp).fulldirUploadFiles,
				nameconflict='MakeUnique');
			newFile.upload1 = "#cffile[1]#"
			newFile.upload1.serverfullpath = "#cffile[1].serverdirectory#/#cffile[1].serverfile#"
			newFile.clientfileext = cffile[1].clientFileExt
			reply.clientfile = cffile[1].clientfile
			reply.filesize = cffile[1].filesize
			reply.contenttype = cffile[1].contenttype
			reply.contentsubtype = cffile[1].contentsubtype
			reply.wassaved = cffile[1].filewassaved
		}
		// obtain uploaded file details
		var uploaded = newFile.upload1.serverfullpath ?: ""
		if(FileExists(uploaded)) {
			newFile.file_integrity_weak = fileHashed(filename=uploaded,algorithm="md5")
			newFile.file_integrity_strong = fileHashed(filename=uploaded,algorithm="sha")
		}
		// remove duplicates, remove illegal chrs and reorder credits credit_illustration credit_text credit_program credit_audio
		newFile.credit_text = newFile.credit_text ?: ""
		newFile.credit_text = cleanList(ReReplaceNocase(newFile.credit_text,get(myapp).acceptedDirChrs,'','all'))
		newFile.credit_program = newFile.credit_program ?: ""
		newFile.credit_program = cleanList(ReReplaceNocase(newFile.credit_program,get(myapp).acceptedDirChrs,'','all'))
		newFile.credit_illustration = newFile.credit_illustration ?: ""
		newFile.credit_illustration = cleanList(ReReplaceNocase(newFile.credit_illustration,get(myapp).acceptedDirChrs,'','all'))
		newFile.credit_audio = newFile.credit_audio ?: ""
		newFile.credit_audio = cleanList(ReReplaceNocase(newFile.credit_audio,get(myapp).acceptedDirChrs,'','all'))
		// apply SAUCE information to any empty fields
		newFile.record_title = newFile.record_title ?: ""
		newFile.date_issued_day = newFile.date_issued_day ?: ""
		newFile.date_issued_month = newFile.date_issued_month ?: ""
		newFile.date_issued_year = newFile.date_issued_year ?: ""
		if (FileExists(newFile.upload1.clientfile) && !IsArchive(newFile.upload1.clientfile)) {
			//("#cffile[1].serverdirectory#/#cffile[1].serverfile#")
			if(StructCount(sauce) > 1 && sauce.sauce) {
				if(!Len(newFile.record_title) && Len(Trim(sauce.title))) newFile.record_title = Capitalize(LCase(sauce.title));
				if(!Len(newFile.group_brand_by) && Len(Trim(sauce.group))) newFile.group_brand_by = Capitalize(LCase(sauce.group));
				if(!Len(newFile.credit_illustration) && Len(Trim(sauce.author))) newFile.credit_illustration = Capitalize(LCase(sauce.author));
				if(!Len(newFile.date_issued_year) && IsDate(Trim(sauce.date))) newFile.date_issued_year = DateFormat(sauce.date,'yyyy');
				if(!Len(newFile.date_issued_month) && IsDate(Trim(sauce.date))) newFile.date_issued_month = DateFormat(sauce.date,'mm');
				if(!Len(newFile.date_issued_day) && IsDate(Trim(sauce.date))) newFile.date_issued_day = DateFormat(sauce.date,'dd');
			}
		}
		// clean and format organisation name
		newFile.group_brand_for = newFile.group_brand_for ?: "Change_Me"
		if(newFile.group_brand_for != "Change_Me") newFile.group_brand_for = clean(newFile.group_brand_for)
		newFile.group_brand_by = newFile.group_brand_by ?: ""
		newFile.group_brand_by = clean(newFile.group_brand_by) ?: ""
		if(newFile.group_brand_for == newFile.group_brand_by) newFile.group_brand_by = "";
		// client comments
		newFile.comment = newFile.comment ?: ""
		// add file details to record
		newFile.fileName = Trim(newFile.upload1.clientfile)
		newFile.filesize = newFile.upload1.filesize
		// handle invalid date values
		if(Len(newFile.date_issued_day)) {
			if(!isNumeric(newFile.date_issued_day)) newFile.date_issued_day = "";
			if(newFile.date_issued_day < 1) newFile.date_issued_day = "";
			if(newFile.date_issued_day > 31) newFile.date_issued_day = "";
		}
		if(Len(newFile.date_issued_month)) {
			if(!isNumeric(newFile.date_issued_month)) newFile.date_issued_month = "";
			if(newFile.date_issued_month < 1) newFile.date_issued_month = "";
			if(newFile.date_issued_month > 12) newFile.date_issued_month = "";
		}
		if(Len(newFile.date_issued_year)) {
			if(!isNumeric(newFile.date_issued_year)) newFile.date_issued_year = "";
			if(newFile.date_issued_year < 1980) newFile.date_issued_year = "";
			if(newFile.date_issued_year > DateFormat(Now(),'YYYY')) newFile.date_issued_year = "";
		}
		// if lastmodified value was not provided by the client using FormAPI, use the timelastmodified value from cfupload
		newFile.file_last_modified = newFile.file_last_modified ?: ""
		if(!IsDate(newFile.file_last_modified)) newFile.file_last_modified = newFile.upload1.timeLastModified;
		newFile.platform = newFile.platform ?: ""
		if(!len(newFile.platform)) newFile.platform = detectPlatform(newFile.fileName)
		// automatically apply lastmodified date as the pubDate
		// if no SAUCE date exists and no or incomplete user date information was provided
		var lastModYear = dateFormat(newFile.file_last_modified,"YYYY")
		var validDate = function() {
			if(!isDefined("sauce")) return false;
			if(!structKeyExists(sauce,"date")) return false;
			if(!IsDate(Trim(sauce.date))) return false;
			return true;
		}
		var modYear = function() {
			if(Len(newFile.date_issued_month) && Len(newFile.date_issued_day)) return false;
			if(lastModYear < get(myapp).yearStart) return false;
			if(lastModYear > dateFormat(now(),"YYYY")) return false;
			if(newFile.date_issued_year != lastModYear) return false;
			if(!Len(newFile.date_issued_year)) return false;
			return true;
		}
		if(validDate() && modYear()) {
			// if user provided information mismatches file last modified info, we assume user info is more accurate
			if(!Len(newFile.date_issued_year)) newFile.date_issued_year = lastModYear;
			if(!Len(newFile.date_issued_month)) newFile.date_issued_month = DateFormat(newFile.file_last_modified,'mm');
			if(!Len(newFile.date_issued_day)) newFile.date_issued_day = DateFormat(newFile.file_last_modified,'dd');
		}
		// tag overwrites for Custom upload tab
		switch(newFile.platform){
			case "audio":
				newFile.section = "releaseadvert";
				break;
			default:
				newFile.section = newFile.section ?: ""
		}
		// additional file details for notification e-mail
		var fileMimeType = newFile.upload1.contenttype
		if(Len(newFile.upload1.contentsubtype)) fileMimeType &= "#newFile.upload1.contentsubtype#";
		// post process
		params.operator.postprocess = trueFalseFormat(params.operator.postprocess)
		// set permission bits BEFORE saving file
		if(FileExists(uploaded)) fileSetAccessMode(uploaded, 664);
		/* save form to database */
		newFile.save();
		/* if errors */
		if(newFile.hasErrors()) {
			var index=0
			for (var error in newFile.allErrors()) {
				index++
				reply.errors[index] = {
					"property":error.property,
					"message":error.message,
				}
			}
			reply.wasstored = "false";
			return reply;
		}
		reply.wasstored = "true";
		if(params.newFile.uploadtype == 'external') return reply;
		// copy uploaded file to UUID value for archiving and serving.
		var download = "#get(myapp).fulldirFileUuid#/#newFile.uuid#"
		fileCopy(uploaded, download);
		fileSetAccessMode(download, 664);
		// process and generate thumbnail, document and preview images from upload
		if(!opCheck("sysop")) return reply;
		if(!params.operator.postprocess) return reply;
		if(!isGraphic(newFile.filename) && !IsDocument(newFile.filename)) return reply;
		var extract = "error"
		var preview = "#get(myapp).fulldirPreview#/#newFile.uuid#.png"
		var errorCnt = arrayLen(reply.errors) ?: 0
		if(errorCnt == 0) reply.errors = [];
		// process image and graphic uploads
		if(IsGraphic(newFile.filename)) {
			// convert uploaded image to a PNG image and store it in temporary directory
			extract = fileConvertImage2Png(download)
		}
		if(ListFirst(extract,":") contains "error") {
			errorCnt++
			reply.errors[errorCnt] = { "property"="fileConvertImage2Png()", "message"="Upload image could not be converted into a PNG image.<br><samp>#extract#</samp>" }
			return reply;
		}
		// process documents
		if(IsDocument(newFile.filename)) {
			var font = ""
			if (newFile.platform == "textamiga") font = "topaz+"
			// convert uploaded image to a PNG image and store it in temporary directory
			extract = fileConvertText2Png(source=download,font=font)
		}
		if(ListFirst(extract,":") contains "error") {
			errorCnt++
			reply.errors[errorCnt] = { "property"="fileConvertText2Png()", "message"="Upload text could not be converted into a PNG image.<br><samp>#extract#</samp>" }
			return reply;
		}
		// copy file from temporary directory to preview directory
		var fileCopy = FileCopy(source = "#get(myapp).tmpDirectory#/#application.applicationname##newFile.uuid#.png", destination = preview);
		if(!fileExists(preview)) {
			errorCnt++
			reply.errors[errorCnt] = { "property"="FileCopy()", "message"="Image preview could not be created.<br><samp>#preview#</samp>" }
			return reply;
		}
		// optimise preview
		extract = fileConvertImage2WebP("#download#.png")
		if(ListFirst(extract,":") contains "error") {
			errorCnt++
			reply.errors[errorCnt] = { property="fileConvertImage2WebP()", message="WebP preview could not be created.<br><samp>#extract#</samp>" }
		}
		// generate 400x400 thumbnail
		extract = fileConvertImageSquared(
			source = preview,
			destination = "#get(myapp).fulldirThumb400#/#newFile.uuid#.png",
			length = "400");
		if(ListFirst(extract,":") contains "error") {
			errorCnt++
			reply.errors[errorCnt] = { property="fileConvertImageSquared()", message="400x400 thumbnail could not be created.<br><samp>#extract#</samp>" }
		}
		return reply;
	}
}