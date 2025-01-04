<!---
	File controller file.
	path: controllers/File.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="checkControllerState")
		filters(through="coopGiveAccess",only="httprequest,edit,replace,save,images")
		filters(through="sysopGiveAccess",only="delete")
		provides("html")
	}

	breadcrumbs &= appendCrumb(2, 'files', urlFor('fileList'))

	variables.myapp = "myapp"
	variables.all = opCheck("coop")
	variables.emu = "emu"
	variables.keys = [
		"-",
		"database",
		"disabled",
		"document",
		"intro",
		"magazine",
		"nfo",
		"nfotool",
		"software",
		"virusalert",
		"visual",
		"waitingApproval",
		"github"
	]
	variables.sorts = get(myapp).orderValues
	variables.unwantedSoftware = "i_understand_this_download_might_be_dangerous"

	// page timeout value adjustment for large files
	private numeric function _timeout(required numeric filesize) {
		var limit = 18.9
		var megabyte = 1000000
		var seconds = 63000
		if(arguments.filesize > (limit * megabyte)) return Ceiling(arguments.filesize/seconds);
		return get(myapp).timeoutDown
	}

	// reformats and removes any initialisms from the group title.
	private string function _formatGroup(required string group) {
		var text = arguments.group
		if(arguments.group contains "(" && arguments.group contains ")") {
			var fix = REMatchNoCase("\(([^]]+)\)", arguments.group)
			text = Mid(fix[1], 2, Len(fix[1])-2)
		}
		return organisationFormat(text)
	}

	/**
	* @hint 	Extracts a text file from an uuid archive and renames it to /var/www/uuid/[uuid].extension
	* @uuid 	UUID of a file record
	* @filename Archive filename with extension
	* @extract 	File to extract from the archive
	* @ext		Extension to append to the extracted file
	*/
	private string function _extractFile(required string uuid, required string filename, required string extract, required string ext) {
		if(!fileExists('#get(myapp).fulldirFileUuid#/#uuid#')) return;
		if(arguments.ext == "") {
			arguments.ext = ".txt"
		}
		var extension = fileExtension(filename)
		var random = "/tmp/df2_extract_" & randRange(100000000, 199999999, "SHA1PRNG") & "-#extension#";
		var cmd = {
			"method":"",
			"name":"",
			"arg":"",
			"dest":"",
			"stdout":"",
		}
		// must use this function to avoid permission issues
		directoryCreate(random)
		switch (extension) {
			case "arc":
				cmd.name = get(myapp).appsArc.file
				// arc only extracts files to current dir, so use STOUT instead
				cmd.arg = "p '#get(myapp).fulldirFileUuid#/#uuid#' '#extract#'"
				cmd.dest = "#random#/#extract#"
				cmd.method = "ARC"
				break;
			case "rar":
				cmd.name = get(myapp).appsUnRar.file
				cmd.arg = "e '#get(myapp).fulldirFileUuid#/#uuid#' '#extract#' '#random#/'"
				cmd.method = "RAR"
				break;
			case "tar.gz":
			case "tar":
				cmd.name = get(myapp).appsTar.file
				cmd.arg = "xvf '#get(myapp).fulldirFileUuid#/#uuid#' -C '#random#' '#extract#'"
				cmd.method = "TAR"
				break;
			default:
				cmd.name = get(myapp).apps7z.file
				cmd.arg = "e '#get(myapp).fulldirFileUuid#/#uuid#' -o'#random#' ""#extract#"""
				cmd.method = "7zip"
				break;
		}
		if(extension == "tar.gz") {
			cmd.arg = "z#cmd.arg#"
		}
		// extract text file where a destination is provided
		if(len(cmd.dest)) {
			//dump(cmd.name);dump(cmd.arg);dump(cmd.dest);abort;
			execute
				name=cmd.name
				arguments=cmd.arg
				outputfile=cmd.dest
				timeout=get(myapp).timeoutArchive
				variable="local.cmd.stdout";
		}
		// extract text file where NO destination is provided
		if(!len(cmd.dest)) {
			//dump(cmd.name);dump(cmd.arg);dump(cmd.dest);abort;
			try {
				execute
					name=cmd.name
					arguments=cmd.arg
					timeout=get(myapp).timeoutArchive
					variable="local.cmd.stdout";
				//dump(cmd.arg);dump(local.cmd.stdout);abort;
			} catch(any err) {}
			if(cmd.method == "7zip" && cmd.stdout contains "No files to process") {
				// attempt to fix unexpected ms-dos characters
				extract = replaceNoCase(extract, " ", "ÿ", "all")
				cmd.arg = "e '#get(myapp).fulldirFileUuid#/#uuid#' -o'#random#' ""#extract#"""
				try {
					execute
						name=cmd.name
						arguments=cmd.arg
						timeout=get(myapp).timeoutArchive
						variable="local.cmd.stdout";
					//dump(cmd.arg);dump(local.cmd.stdout);abort;
				} catch(any err) {}
			}
		}
		var test = function() {
			if(cmd.method == "ARC" && fileExists(cmd.dest)) return true;
			if(cmd.method == "RAR" && cmd.stdout contains "All Ok") return true;
			if(cmd.method == "7Zip") {
				// the feedback "No files to process" usually also includes "Everything is Ok"
				if(cmd.stdout contains "No files to process") return false;
				if(cmd.stdout contains "Everything is Ok") return true;
			}
			if(cmd.method == "TAR" && cmd.stdout contains extract) return true;
			return false;
		}
		var cleanup = function() {
			if(directoryExists(random)) {
				try { directoryDelete(random, true) }
				catch(any err) {}
			}
		}
		// handle extraction result
		if(!test()) {
			flashInsert(extractDOSTextError="#cmd.method# failed to extract #arguments.extract# from #arguments.filename#<br><small>#cmd.stdout#<br><code>#cmd.name# #cmd.arg#</code></small>")
			cleanup()
			return;
		}
		var file = ""
		try {
			var destination = '#get(myapp).fulldirFileUuid#/#uuid##arguments.ext#';
			// 1/Feb/17 - workaround for archives that contain directory names with spaces
			file = arguments.extract
			if(!fileExists('#random#/#file#')) {
				file = ListLast(file,"/")
				if(!fileExists('#random#/#file#')) {
					throw('source file [#random#/#file#] does not exist')
				}
			}
			fileMove('#random#/#file#', destination);
			try { fileSetAccessMode(destination, 664) } catch(any err) {}
			flashInsert(extractDOSTextsuccess="Extracted #file# from #arguments.filename# to use as #arguments.ext#")
		} catch(any err) {
			flashInsert(extractDOSTextError="System failed to extract<br>filename: #file#<br>source: #arguments.filename#<br><small><code>#err.message#</code></small>")
		}
		cleanup()
	}

	/**
	 * @hint 	Converts DOS ASCII art into Unicode compatible UTF-8 for display in browser
	 * @text 	A body of text encoded with CP1252 (Windows-1252) or ISO 8859-1
	 * @trim 	Remove excess whitespace from the right of any text.
	 * 			This reduces the text size and removes problematic LF/CF issues.
	 */
	private string function _retrotxt(required string text, boolean trim=true) {
		// * Code page 850 https://en.wikipedia.org/wiki/Code_page_850
		// * Code page 852 https://en.wikipedia.org/wiki/Code_page_852
		// * Code page 437 https://en.wikipedia.org/wiki/Code_page_437
		// * Code page 1252 https://en.wikipedia.org/wiki/Windows-1252
		// * character Þ (represented as either 222 or 254) will probably be a block
		// * character ⊙ will probably be .
		var html = XmlFormat(arguments.text)
		var cp437 = {
			"0":["␀", "☺", "☻", "♥", "♦", "♣", "♠", "•", "◘", "○", "◙", "♂", "♀", "♪", "♫", "☼"],
			"1":["►", "◄", "↕", "‼", "¶", "§", "▬", "↨", "↑", "↓", "→", "←", "∟", "↔", "▲", "▼"],
			"8":["Ç", "ü", "é", "â", "ä", "à", "å", "ç", "ê", "ë", "è", "ï", "î", "ì", "Ä", "Å"],
			"9":["É", "æ", "Æ", "ô", "ö", "ò", "û", "ù", "ÿ", "Ö", "Ü", "¢", "£", "¥", "₧", "ƒ"],
			"a":["á", "í", "ó", "ú", "ñ", "Ñ", "ª", "º", "¿", "⌐", "¬", "½", "¼", "¡", "«", "»"],
			"b":["░", "▒", "▓", "│", "┤", "╡", "╢", "♔", "╕", "╣", "║", "╗", "╝", "╜", "╛", "┐"],
			"c":["└", "┴", "┬", "├", "─", "┼", "╞", "╟", "╚", "╔", "╩", "╦", "╠", "═", "╬", "╧"],
			"d":["╨", "╤", "╥", "╙", "╘", "╒", "╓", "╫", "╪", "┘", "┌", "█", "▄", "▌", "▐", "▀"],
			"e":["α", "ß", "Γ", "π", "Σ", "σ", "µ", "τ", "Φ", "Θ", "Ω", "δ", "∞", chr(inputBaseN("03C6", 16)), "ε", "∩"],
			"f":["≡", "±", "≥", "≤", "⌠", "⌡", "÷", "≈", "°", chr(inputBaseN("2219", 16)), "♕", "√", "ⁿ", "²", chr(inputBaseN("25A0", 16)), chr(inputBaseN("00A0", 16))],
		}
		var map0_127 = arrayMerge(cp437.0, cp437.1);
		var map128_255 = arrayMerge(cp437.8, cp437.9);
		map128_255 = arrayMerge(map128_255, cp437.a);
		map128_255 = arrayMerge(map128_255, cp437.b);
		map128_255 = arrayMerge(map128_255, cp437.c);
		map128_255 = arrayMerge(map128_255, cp437.d);
		map128_255 = arrayMerge(map128_255, cp437.e);
		map128_255 = arrayMerge(map128_255, cp437.f);

		// characters 0…128 [00…F1]
		var char = map0_127.len();
		while (char--) {
			html = replace(html, chr(char), map0_127[char+1], "all")
		}
		// characters 129…255 [80…FF]
		char = map128_255.len();
		var offset = 128 // character position adjustment
		while (char--) {
			var code = (char + offset);
			html = replace(html, chr(code), map128_255[char+1], "all")
		}
		// replace place holders with the actual characters
		// these otherwise can conflict if both characters are contained in the same document
		html = replace(html, "♔", "╖", "all") // ╖ CP437 00B7, Unicode 2556
		html = replace(html, "♕", chr(inputBaseN("00B7", 16)), "all") // · CP436 00FA, Unicode 00B7
		// PCBoard BBS color and some control codes
		var pcBoard = left(arguments.text, 100);
		// strip linefeed characters for PCBoard detection
		pcBoard = replace(pcBoard, "♪", "", "all");
		pcBoard = replace(pcBoard, "◙", "", "all");
		pcBoard = trim(pcBoard);
		var css = "";
		var clearScreen = "@CLS@"
		var control = "@X"
		if(left(pcBoard,2) == control || left(pcBoard,5) == clearScreen) {
			// create CSS classes
			css = "<style>i{font-style:normal}.PF0{color:##000}.PF1{color:navy}.PF2{color:green}"
			css &= ".PF3{color:##0aa}.PF4{color:maroon}.PF5{color:##a0a}.PF6{color:##a50}.PF7{color:##aaa}"
			css &= ".PF8{color:##555}.PF9{color:##00f}.PFA{color:##0f0}.PFB{color:##0aa}.PFC{color:red}"
			css &= ".PFD{color:##0ff}.PFE{color:##ff5}.PFF{color:##fff}.PB0{background-color:transparent}"
			css &= ".PB1{background-color:navy}.PB2{background-color:green}.PB3{background-color:##0aa}"
			css &= ".PB4{background-color:maroon}.PB5{background-color:##a0a}.PB6{background-color:##a50}"
			css &= ".PB7{background-color:##aaa}.PB8{background-color:##555}.PB9{background-color:##00f}"
			css &= ".PBA{background-color:##0f0}.PBB{background-color:##0aa}.PBC{background-color:red}"
			css &= ".PBD{background-color:##0ff}.PBE{background-color:##ff5}.PBF{background-color:##fff}</style>"
			// remove the unneeded clear screen command
			html = replace(html,clearScreen,"","all");
			// replace PCBoard controls with HTML tags containing CSS classes
			html = rEReplaceNoCase(html,'#control#([0-9|A-F])([0-9|A-F])','</i><i class="PB\1 PF\2">','all');
			html = "#html#</i>";
			// repair broken span tags
			if(left(html,7) == "</span>") html = mid(html,8,len(html)-8);
			html = html & "</span>";
		}
		// Control Sequences
		// https://en.wikipedia.org/wiki/ANSI_escape_code
		// https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
		var ansiEscape = chr(27)
		// strip-out save/restore codes
		html = rEReplaceNoCase(html,"←\[[s|u]+","","all");
		// strip out cursor codes
		html = rEReplace(html,"←\[[0-9]+A","","all");
		html = rEReplace(html,"←\[[0-9]+D","","all");
		html = rEReplace(html,"←\[[H|A|B|C|D|E|F|G]","","all");
		html = rEReplaceNoCase(html,"←\[[0-9]+;[0-9]+[H|f]","","all");
		// strip-out all ansi control codes
		html = rEReplaceNoCase(html,"#ansiEscape#\[[0-9;]*[mG]","","all");
		// replace DOS and Windows newlines with HTML newline
		var dosNewline = "♪◙"
		var newline = chr(10)
		// replace cursor position aliases with newlines
		html = rEReplace(html,"←\[[;]?[0-9]+H",newline,"all");
		html = replace(html, dosNewline, newline, "all");
		// replace Linux and macOS newlines with HTML newline
		var linefeed = "◙"
		html = replace(html, linefeed, newline, "all");
		// replace DOS tabs with HTML tab
		var dosTab = "○"
		var tab = chr(9)
		html = replace(html, dosTab, tab, "all");
		// trim
		if(arguments.trim) {
			html = RTrim(html)
			endOfFile = "→"
			if(Right(html,1) == endOfFile) {
				html = Left(html, Len(html)-1)
			}
			html = RTrim(html)
		}
		if(len(css)) html = css & html;
		return html
	}

	// Defacto2 files index
	public any function index() {
		variables.title = "Files index"
		variables.breadcrumbs &= 'index'
		variables.description = 'Table of contents for and links to files'
		variables.count = {
			firstYear = model("Files").findOne(select="date_issued_year",where="date_issued_year IS NOT NULL",order="date_issued_year",includeSoftDeletes=false).date_issued_year,
			trosWin = model("Files").count(where="section='releaseadvert' AND platform='windows'",includeSoftDeletes=false),
			trosDos = model("Files").count(where="section='releaseadvert' AND platform='dos'",includeSoftDeletes=false),
			install = model("Files").count(where="section='releaseinstall'",includeSoftDeletes=false),
			nfotool = model("Files").count(where="section='nfotool'",includeSoftDeletes=false),
			nfo = model("File").count(where="section='releaseinformation'",includeSoftDeletes=false),
			ansi = model("File").count(where="platform='ansi'",includeSoftDeletes=false),
			bbs = model("File").count(where="section='bbs'",includeSoftDeletes=false),
			bbstro = model("File").count(where="platform='dos' AND section='bbs'",includeSoftDeletes=false),
			bbsansi = model("File").count(where="platform='ansi' AND section='bbs'",includeSoftDeletes=false),
			bbstext = model("File").count(where="platform='text' AND section='bbs'",includeSoftDeletes=false),
			proof = model("File").count(where="section='releaseproof'",includeSoftDeletes=false),
			demos = model("File").count(where="section='demo'",includeSoftDeletes=false),
			textAmi = model("File").count(where="platform='textamiga'",includeSoftDeletes=false),
			text =  model("File").count(where="platform='text'",includeSoftDeletes=false),
			mags = model("File").count(where="section='magazine'",includeSoftDeletes=false),
			magPubs = model("Files").findAll(select="group_brand_for",distinct=true,includeSoftDeletes=false,where="section='magazine'").recordCount,
			github = model("Files").count(where="web_id_github IS NOT NULL",includeSoftDeletes=false)
		}
	}
	// adjust the end user display options
	public any function adjustdisplay() {
		param name="params";
		param name="params.youtubeplayer" type="boolean" default=Client.display['yt'];
		param name="params.packagecontent" type="boolean" default=true;
		param name="params.preview" type="boolean" default=true;
		param name="params.emulation" type="boolean" default=Client.display[emu];
		param name="params.documentation" type="boolean" default=true;
		param name="params.obfuscatedKey" default="";
		param name="params.name" default="";
		param name="params.platform" default="";
		param name="params.section" default="";
		param name="params.sort" default="";
		param name="params.src" default="";
		var position = ""
		if(len(params.name) && len(params.platform) && len(params.section) && len(params.sort)) {
			var plat = lCase(params.platform)
			var sect = lCase(params.section)
			// example query string: ?name=-&platform=-&section=releaseadvert&sort=posted_desc
			position = "name=#params.name#&platform=#plat#&section=#sect#&sort=#params.sort#"
			if(len(params.src)) position = listInsertAt(position,2,"src=#params.src#","&");
		}
		onlyProvides("html");
		if(!StructKeyExists(Client,"display")) redirectTo(route="f",key=params.obfuscatedKey,params=position);
		if(IsBoolean(params.youtubeplayer)) Client.display['yt'] = params.youtubeplayer;
		if(IsBoolean(params.packagecontent)) Client.display['list'] = params.packagecontent;
		if(IsBoolean(params.preview)) Client.display['img'] = params.preview;
		if(IsBoolean(params.emulation)) Client.display[emu] = params.emulation;
		if(IsBoolean(params.documentation)) Client.display['nfo'] = params.documentation;
		redirectTo(route="f",key=params.obfuscatedKey,params=position)
	}

	// delete a file record, its download and all its associated assets
	public any function delete() {
		param name="params";
		param name="params.goto" default="";
		if(!StructKeyExists(params,'confirm')) redirectTo(back=true);
		if(!params.confirm) redirectTo(back=true);
		onlyProvides("html");
		// erase all associated files
		var dirs = "#get(myapp).dirThumb400#,#get(myapp).fulldirPreview#,#get(myapp).fulldirFileUuid#"
		loop list="#dirs#" index="local.dir" delimiters=";" {
			if(FileExists(ExpandPath("#dir#/#params.uuid#.png"))) {
				var file = "#dir#/#params.uuid#.png"
				fileDelete(delete);
				continue;
			}
			if(FileExists(ExpandPath("#dir#/#params.uuid#"))) {
				var file = "#dir#/#params.uuid#"
				fileDelete(file);
			}
		}
		// permanently delete database record
		var file = model("file").findOneByUuid(value="#params.uuid#",includeSoftDeletes=true,reload=true,cache=false)
		if(IsBoolean(file) && !file) {
			flashInsert(opkillerror="The record #UCase(params.uuid)# could not be found in the database")
			redirectTo(back=true)
		}
		file.uuid = LCase(file.uuid)
		file.delete(softDelete="false")
		flashInsert(opkillsuccess="The record #UCase(params.uuid)# and its associated files has been successfully deleted")
		// go to next record, otherwise go to the list of records
		if(len(params.goto)) {
			redirectTo(route="f",key=obfuscateParam(params.goto));
		}
		redirectTo(action="list");
	}

	// detailed view of a file
	public any function detail() {
		param name="params";
		param name="params.route" default="";
		param name="params.key" default="";
		param name="params.src" default="";
		param name="params.name" default="";
		param name="params.platform" default="-";
		param name="params.section" default="-";
		param name="params.sort" default=get(myapp).reset.FileList.sort;
		// dosee emulation params
		param name="params.dosaudio" default="";
		param name="params.dosscaler" default="";
		param name="params.dosmachine" default="";
		param name="params.dosspeed" default="";
		param name="params.dosutils" type="boolean" default=false;
		param name="params.dosuseoriginalzip" type="boolean" default=false;

		// hard-coded redirect for legacy links used on Demozoo
		// defacto2.net/file/detail/[key]
		if(params.route == "fileDetailLegacy" && params.key != "") {
			redirectTo(statusCode=301,route="f",key=params.key)
		}

		variables.groupsDatalist = queryNew("")
		variables.dos = {
			"pubkey":"",
			"filepath":"",
			"zippath":"",
			"zipFullpath":"",
			"startExe":"",
			"isExecutable":"",
		}
		variables.idPosition = 0
		variables.idCount = 0
		variables.fileContentCount = 0
		variables.fileContentList = ""
		variables.loadChiptunes = false
		variables.loadDOSee = false
		variables.nav = {
			"rec":{
				"prev":"",
				"next":"",
				"first":"",
				"last":"",
			}
		}
		variables.newFileSection = queryNew("")
		variables.newFilePlatform = queryNew("")
		variables.fileProd = queryNew("")
		variables.zippeddir = ""
		var autoid = deobfuscateParam(params.key);
		var select="createdAt,credit_program,credit_illustration,credit_audio,credit_text,deletedAt,deletedBy,comment"
		select &= ",file_zip_content,file_magic_type,preview_image,file_integrity_weak,file_integrity_strong,fileName"
		select &= ",fileSize,file_security_alert_url,id,platform,group_brand_by,date_issued_day,date_issued_month"
		select &= ",date_issued_year,record_title,group_brand_for,section,updatedAt,updatedBy,uuid,web_id_youtube"
		select &= ",web_id_pouet,web_id_demozoo,sectionText,file_last_modified,web_id_github,web_id_16colors,list_links,list_relations"
		select &= ",dosee_hardware_cpu,dosee_hardware_audio,dosee_hardware_graphic,dosee_load_utilities,dosee_no_aspect_ratio_fix"
		select &= ",dosee_incompatible,dosee_no_ems,dosee_no_xms,dosee_no_umb,dosee_run_program,retrotxt_readme,retrotxt_no_readme"

		var legacyURLs = function() {
			if(listLen(list=cgi.path_info,delimiters="/") >= 4) redirectTo(route="f",key=params.key,statusCode="301");
		}
		legacyURLs()

		var security = function() {
			var sections=model("Files").findAll(select="section",distinct=true,includeSoftDeletes=all)
			var platforms=model("Files").findAll(select="platform",distinct=true,includeSoftDeletes=all)
			if(opCheck('coop')) {
				ArrayAppend(keys, "disabled")
				if(!ListContainsNoCase(sorts, "disabled")) sorts = ListAppend(sorts,"disabled")
			}
			// IsNumeric is triggered with math exponents so cap the value check to 99999
			if(IsNumeric(params.key) && params.key < 99999) return "404";
			if(params.src != "" and !ListFindNocase("f,o,p",params.src)) return "404";
			if(!params.platform == "-" && !ListFindNocase(ValueList(platforms.platform),params.platform)) return "404";
			if(!params.section == "-" && !ListFindNocase(ValueList(sections.section),params.section)) return "404";
			try {
				fileProd = model("Files").findByKey(key=autoid,select=select,includeSoftDeletes=all,returnAs="query");
				fileProd.uuid = LCase(fileProd.uuid)
			}
			catch(any err) { return "404"; }
			// record not found
			if(fileProd.recordCount == 0) return "404";
		}
		if (security() == "404") {
			// Closures in either Lucee or CFWheels expect string values and throw errors returning objects.
			// So this is a workaround.
			return render404();
		}

		var pagination = function() {
			// defaults
			var pagi = {
				"key":'',
				"platform":'',
				"section":'',
				"order":'',
				"perPage":1,
				"page":0,
			}
			if(len(params.name)) {
				// sql injections
				if (params.name contains "UNION ALL SELECT") return "404";
				if (params.name contains "NULL%2C") return "404";
				// override defaults using URL params
				pagi.key = params.name
				pagi.platform = lCase(params.platform)
				pagi.section = lCase(params.section)
				pagi.order = params.sort
			}
			var statement = dynamicSqlForFile(pagi,sections,platforms,params.src)
			var query = queryNew("")
			try {
				if(pagi.order contains "title") {
					query = model("file").listFilesSortedAZ(where=statement.whereState,order=dynamicSqlFileOrder(pagi.order),includeSoftDeletes=all,select="id")
				}
				else {
					query = model("Files").findAll(select="id",where=statement.whereState,order=dynamicSqlFileOrder(pagi.order),includeSoftDeletes=all,maxRows="-1");
				}
			}
			catch(expression) {
				// assume expression exception is an attempt at SQL injection
				return "404";
			}
			var list = ValueList(query.id)
			if(!listLen(list)) return "404";
			variables.idPosition = ListFind(list,fileProd.id)
			variables.idCount = ListLen(list)
			if(idPosition < ListLen(list)) {
				nav.rec.next = ListGetAt(list,idPosition+1);
				nav.rec.last = ListLast(list);
			}
			if(idPosition > 1) {
				nav.rec.prev = ListGetAt(list,idPosition-1);
				nav.rec.first = ListFirst(list);
			}
		}

		// Handle file archive (zip, 7z, etc.) content
		var archive = function() {
			var maximum = 15000
			var content = Left(fileProd.file_zip_content,maximum);
			variables.zippeddir = Left(fileProd.file_zip_content,maximum);
			// Limit package file_zip_content output to significantly improve file display render time
			if(Len(trim(content))) {
				variables.fileContentList = ReReplace(content,'\n',',','all')
				variables.fileContentCount = ListLen(fileContentList)
				if(Len(fileContentList) GTE maximum) fileContentList = Left(fileContentList,maximum) & "...";
				// convert all new lines in the ZIP file content into a list delimiter
				// ":" is an illegal DOS filename char so it shouldn't conflict
				var carriage = chr(13)
				var linefeed = chr(10)
				variables.zippeddir = replaceNoCase(variables.zippeddir,"#carriage##linefeed#",":","all") // windows
				variables.zippeddir = replaceNoCase(variables.zippeddir,linefeed,":","all") // linux/macos
				variables.zippeddir = replaceNoCase(variables.zippeddir,carriage,":","all") // 8-bit micro computers
			}
		}

		// Title or Magazine edition
		var title = function() {
			var text = fileProd.filename;
			if(fileProd.section == "magazine" && Len(fileProd.record_title)) text = "#fileProd.group_brand_for#, #fileProd.record_title#";
			else if(Len(fileProd.record_title)) text = fileProd.record_title;
			if(Len(fileProd.group_brand_for)) text &= " for " & fileProd.group_brand_for;
			return text
		}

		var description = function() {
			var desc = title()
			if(Len(fileProd.date_issued_year)) desc &= " from #fileProd.date_issued_year#"
			return desc
		}

		// Operator and system, file edit forms
		var admin = function() {
			if(!opCheck("coop")) return;
			file = model("Files").findByKey(key=autoid,includeSoftDeletes=all,select=select);
			file.uuid = LCase(file.uuid)
			variables.formOnFile = file;
			variables.groupsDatalist = model("upload").getFormattedInitialisms()
			// file platform and section (hide unused options)
			newFilePlatform = model("Upload").findAll(select="platformText,platform",order="platformText",distinct=true,includeSoftDeletes=all,where="platform IS NOT NULL")
			newFileSection = model("Upload").findAll(select="sectionText,section",order="sectionText",distinct=true,includeSoftDeletes=all,where="section IS NOT NULL")
			// automatically generate thumbnails and previews for new files
			switch(file.platform) {
				case 'ansi':
				case 'image':
				case 'text':
				case 'textamiga':
					if(!isDate(file.createdat)) break;
					if(!isDate(file.deletedat)) break;
					if(!isDate(file.updatedat)) break;
					// use a leeway of 60 seconds
					if(dateDiff('s', file.createdat, file.deletedat) > 30) break;
					if(dateDiff('s', file.createdat, file.updatedat) > 30) break;
					if(file.filesize <= 0) break;
					var download = "#get(myapp).fulldirFileUuid#/#file.uuid#"
					var thumb2 = "#get(myapp).dirThumb400#/#file.uuid#.png"
					if(!fileExists(download)) break;
					if(fileExists(thumb2)) break;
					flashInsert(opAutoRefreshInfo='Generating previews for the #file.platform# file')
					file.uuid = UCase(file.uuid)
					file.save()
					file.uuid = LCase(file.uuid)
					file.save()
					redirectTo(action="edit",key=obfuscateParam(params.key),params="uuid=#file.uuid#&generateimages=true")
					return;
				default:
			}
		}

		variables.findChiptune = function(required query fileProd) {
			var finds = []
			var chipfile = ""
			// search for a suitable file
			var candidates = get(myapp).acceptedChiptunes
			loop list="#variables.zippeddir#" index="local.file" delimiters=":" {
				var extension = listLast(file,".")
				if(listFindNoCase(candidates, extension)) {
					arrayAppend(finds, file)
				}
			}
			// return first match
			if(arrayLen(finds) >= 1) return finds[1];
			return ""
		}

		variables.findTextfile = function(required query fileProd) {
			var finds = []
			// order the extensions by priority
			var extensions = "nfo,txt,unp,doc"
			var skip = "scene.org|scene.org.txt"
			var textfile = ""
			if(len(fileProd.retrotxt_readme)) {
				return fileProd.retrotxt_readme;
			}
			// search for a suitable document
			var candidates = get(myapp).acceptedDocuments
			loop list="#variables.zippeddir#" index="local.file" delimiters=":" {
				if(listFindNoCase(skip, file, '|')) continue;
				var extension = listLast(file,".")
				if(listFindNoCase(candidates, extension)) {
					arrayAppend(finds, file)
				}
			}
			// only one match
			if(arrayLen(finds) == 1) return finds[1];
			// multiple matches, so return the highest priority file type
			if(arrayLen(finds) > 1) {
				var basename = filenameLessExtension(fileProd.filename)
				for(var extension in extensions) {
					var index = arrayFindNocase(finds, "#basename#.#extension#")
					if(index) return finds[index];
				}
			}
			// try to obtain possible files from the root path of the archive first
			var rootDir = arrayFilter(finds, function(file) {
				return file does not contain "\" && file does not contain "/";
			});
			if(arrayLen(rootDir)) finds = rootDir
			var list = arrayToList(finds, ":")
			if(!listLen(list)) return "";
			for(var extension in extensions) {
				var index = ListContainsNocase(list, ".#extension#", ":")
				if(index) return trim(listGetAt(list, index, ":"))
			}
			return ""
		}

		var chiptunePlayer = function() {
			//far,it,mod,mptm,s3m,stm,xm
			var file = "#get(myapp).fulldirFileUuid#/#fileProd.uuid#.chiptune"
			var found = fileExists(file)
			// if file is an archive, we search for and extract a text file for display
			if(isArchive(fileProd.filename) && !found) {
				var chiptune = findChiptune(fileProd)
				// extract a chiptune file from file archive
				if(len(chiptune)) _extractFile(fileProd.uuid,fileProd.filename,chiptune,".chiptune")
			}
		}

		// DOS text (CP-437) to HTML converter
		var textViewer = function() {
			var file = "#get(myapp).fulldirFileUuid#/#fileProd.uuid#.txt"
			var found = fileExists(file)
			// if file is an archive, we search for and extract a text file for display
			if(isArchive(fileProd.filename) && !found) {
				var readme = findTextfile(fileProd)
				// extract readme file from file archive
				if(len(readme) && !isBoolean(fileProd.retrotxt_no_readme)) _extractFile(fileProd.uuid,fileProd.filename,readme,".txt")
			}
		}

		// pack solo executable files that are not zipped or archived
		var packBinary = function() {
			dos.isExecutable = false
			if(ListFindNocase("exe,com,bat",fileExtension(fileProd.filename))) dos.isExecutable = true;
			if(!dos.isExecutable) return;
			if(fileExists(dos.zipFullpath)) return;
			if(!fileExists(expandPath(dos.filepath))) return;
			// package the solo executable into a zip archive
			var zip = expandPath('/files/emularity/#fileProd.filename#')
			fileCopy(expandPath(dos.filepath),zip)
			if(!fileExists(zip)) return;
			execute
				name=get(myapp).apps7z.file
				arguments="a -tzip -y '#dos.zipFullpath#' '#zip#'"
				timeout="#get(myapp).timeoutArchive#"
				variable="local.stdout";
				try {
					fileSetAccessMode(dos.zipFullpath, 664)
					fileDelete(zip)
				}
				catch(any err) {}
		}

		// required to avoid permission issues in /tmp
		// a loop is used because sometimes a directory
		// [/tmp/df2_dosee_167456_id-1000] already exists is thrown
		var randomPath = function(string id="0") {
			for (i = 1; i <= 10; i++) {
				var random = "/tmp/df2_dosee_" & randRange(100000, 199999, "SHA1PRNG") & "_id-#id#"
				if(!directoryExists(random)) {
					try { directoryCreate(random) } catch(any err) { conntinue; }
					return random
				}
			}
			return ""
		}

		var randomCleanup = function(string random="") {
			if(random eq "") return;
			if(!directoryExists(random)) return;
			try { fileSetAccessMode(random, 664) } catch(any err) {}
			try { directoryDelete(random, true) } catch(any err) {}
		}

		// repack archives that don't mount correctly in BrowserFS
		var repackage = function() {
			dos.isBrokenZip = false;
			if(!params.dosuseoriginalzip) {
				// TO ADD more file extensions, you must edit variables.doseeExts in the Controller.cfc
				// ALSO the file extensions must be added to the decompress files switch below
				var extensions = "arc;arj;7z;rar;"
				if(listFindNocase(extensions, fileExtension(fileProd.filename), ";")) dos.isBrokenZip = true;
			}
			if(!dos.isBrokenZip && fileExists(dos.zipFullpath)) return;
			if(!fileExists(expandPath(dos.filepath))) return;
			var random = randomPath(fileProd.id)
			if(random == "") {
				throw("could not create a required temporary directory for the repackage of DOSee")
			}

			// limit repacking to archives with a limited number of files
			var fileContentList = ReReplace(fileProd.file_zip_content,'\n',',','all')
			if(ListLen(fileContentList) gt 1000) {
				dos.isBrokenZip=true
				fileContentList = ""
				randomCleanup(random)
				return;
			}
			fileContentList = ""
			// limit repacking to small file sizes
			var limitMB = 100
			var oneMB = 1024*1024
			if(fileProd.filesize gt (limitMB*oneMB)) {
				dos.isBrokenZip=true
				randomCleanup(random)
				return;
			}

			// decompress files
			// Dec.2022:
			// To discover abandoned temporary directories.
			// $ ssh defacto2.net
			// $ cd /opt/Defacto2-2020
			// $ dc exec webapp bash
			// $# ls /tmp
			// $# du -h -c /tmp

			var stdout = ""
			switch(fileExtension(fileProd.filename)) {
				case 'arc':
					fileCopy(expandPath(dos.filepath),random)
					if(!fileExists('#random#/#fileProd.uuid#')) break;
					// A work-around because ARC only extracts to the active directory
					// See http://www.cfelements.com/2011/11/cfexecute-with-multiple-bash-commands.html
					execute
						name='/bin/bash'
						arguments="-c 'cd #random#; #get(myapp).appsArc.file# e #random#/#fileProd.uuid#'"
						timeout="#get(myapp).timeoutArchive#"
						variable="local.stdout";
					fileDelete('#random#/#fileProd.uuid#')
				break;
				case "7z": case "arj":
					execute
						name=get(myapp).apps7z.file
						arguments="x '#expandPath(dos.filepath)#' -o'#random#'"
						timeout="#get(myapp).timeoutArchive#"
						variable="local.stdout";
				break;
				case 'rar':
					execute
						name=get(myapp).appsUnRar.file
						arguments="e '#expandPath(dos.filepath)#' '#random#'"
						timeout="#get(myapp).timeoutArchive#"
						variable="local.stdout";
				default:
			}
			// re-compress extracted directory as a zip archive
			if(stdout contains "Everything is Ok" ||
				(stdout contains "Extracting file" && stdout does not contain "Cannot create") ||
				stdout contains "All OK") {
				execute
					name=get(myapp).apps7z.file
					arguments="a -tzip -y '#dos.zipFullpath#' '#random#/*' -mx1 -mmt" // -mx1 low compression, -mnt multithread
					timeout="#get(myapp).timeoutArchive#"
					variable="local.stdout";
			}
			// cleanup
			try { fileSetAccessMode(dos.zipFullpath, 664) } catch(any err) {}
			randomCleanup(random)
		}

		variables.emulatorParams = function(required string field, required string value, required string query_string, boolean overwrite=false) {
			if(!len(arguments.field)) return ""
			// fetch field & value from browser's query string
			var query = arguments.query_string
			var index = ListContainsNoCase(query, "#arguments.field#=", "&");
			var val = arguments.value
			var search = ""
			if(index) {
				if(!arguments.overwrite) return query;
				search = ListGetAt(query, index, "&");
			}
			// if field & value doesn't exist then append it to query string
			if(!index) {
				if(len(query)) return query & "&#arguments.field#=#val#";
				return "#arguments.field#=#val#";
			}
			// if field & value exists, then overwrite its value (this overwrites user supplied fields)
			if(search != val) {
				return ListSetAt(query, index, "#arguments.field#=#val#", "&");
			}
			return query;
		}

		// DOS in JS emulator
		var emulator = function() {
			variables.loadDOSee = emulateFile(fileProd);
			if(!loadDOSee) return;
			if((structKeyExists(Client,"display") && structKeyExists(Client.display,emu) && Client.display[emu] != 1)) return;
			dos.pubkey = params.key
			dos.filepath = trim("/files/emularity/#fileProd.uuid#") // symlink to /var/www/uuid/
			dos.zippath = trim("/files/emularity/#fileProd.uuid#.zip")
			dos.zipFullpath = expandPath(dos.zippath)
			// discover filename to automatically run
			// see Controller.cfc emulatorBinary() to edit
			dos.startExe = fileProd.dosee_run_program;
			if(!len(fileProd.dosee_run_program)) dos.startExe = emulatorBinary(fileProd);
			// never autostart DOS programs for ANSI artpacks
			if(fileProd.section == "package") {
				switch(fileProd.platform) {
					case "ansi":
					case "dos":
						dos.startExe = ""; break;
				}
			}
			packBinary()
			repackage()
			// flag broken programs or software that doesn't correctly emulate in DOSee
			dos.isBrokenExe = false
			if(isBoolean(fileProd.dosee_incompatible) && fileProd.dosee_incompatible) dos.isBrokenExe = true;
			// adjust menus if no audio is in use
			dos.noAudio = false;
			// determine which zip archive to send to emulator to use as C: drive
			dos.gamefilepath = dos.filepath;
			if(!params.dosuseoriginalzip && fileExists(dos.zipFullpath)) dos.gamefilepath = dos.zippath;
			// apply hard coded default overwrites for DOSee emulation
			// only run when user hasn't overridden the emulation defaults
			if(params.dosaudio == "pcspeaker") {
				// redirect legacy dosee value
				var newParam = cgi.query_string
				newParam = emulatorParams(field="dosaudio",value="none",query_string=newParam,overwrite=true);
				redirectTo(statusCode="307",route="f",key=dos.pubkey,params=newParam);
			}
			//if(len(params.dosmachine) || len(params.dosaudio) || len(params.dosspeed)) return;
			// emulator machine defaults based on the era of the release.
			var newParam = cgi.query_string
			var refresh = false
			// dos machine enforce graphic modes

			if(len(fileProd.dosee_hardware_graphic)) {
				refresh = true;
				newParam = emulatorParams("dosmachine", fileProd.dosee_hardware_graphic, newParam);
			}
			else if(fileProd.date_issued_year >= "1993") {
				refresh = true;
				newParam = emulatorParams("dosmachine","svga", newParam);
			}
			// dos audio
			if(len(fileProd.dosee_hardware_audio)) {
				// replace legacy dosee value
				if(fileProd.dosee_hardware_audio == "pcspeaker") {
					fileProd.dosee_hardware_audio = "none";
				}
				refresh = true;
				newParam = emulatorParams("dosaudio", fileProd.dosee_hardware_audio, newParam);
			}
			else if(fileProd.date_issued_year >= "1995" && listFindNocase("releaseAdvert,demo", fileProd.section)) {
				refresh = true;
				newParam = emulatorParams("dosaudio","gus", newParam);
			}
			if(fileProd.date_issued_year <= "1989" && fileProd.dosee_hardware_audio == "") {
				dos.noAudio = true;
			}
			if(listFindNocase("pcspeaker,none",fileProd.dosee_hardware_audio)) {
				dos.noAudio = true;
			}
			// dos speed
			if(len(fileProd.dosee_hardware_cpu)) {
				//  force to auto
				refresh = true;
				newParam = emulatorParams("dosspeed", fileProd.dosee_hardware_cpu, newParam);
			}
			else if(len(fileProd.date_issued_year) && fileProd.date_issued_year >= "1995") {
				// force to maximum
				refresh = true;
				newParam = emulatorParams("dosspeed","max", newParam);
			}
			else if(len(fileProd.date_issued_year) && fileProd.date_issued_year <= "1989") {
				// force 8086 CPU
				refresh = true;
				newParam = emulatorParams("dosspeed","8086", newParam);
			}
			else {
				// default to auto
				refresh = true;
				newParam = emulatorParams("dosspeed","auto", newParam);
			}
			// force the removal of EMS expanded memory usage
			if(isBoolean(fileProd.dosee_no_ems) && fileProd.dosee_no_ems == 1) {
				refresh = true;
				newParam = emulatorParams("dosems", "false", newParam);
			}
			// force the removal of UMB upper memory block usage
			if(isBoolean(fileProd.dosee_no_umb) && fileProd.dosee_no_umb == 1) {
				refresh = true;
				newParam = emulatorParams("dosumb", "false", newParam);
			}
			// force the removal of XMS extended memory usage
			if(isBoolean(fileProd.dosee_no_xms) && fileProd.dosee_no_xms == 1) {
				refresh = true;
				newParam = emulatorParams("dosxms", "false", newParam);
			}
			// force disabling of aspect correction
			if(isBoolean(fileProd.dosee_no_aspect_ratio_fix) && fileProd.dosee_no_aspect_ratio_fix == 1) {
				refresh = true;
				newParam = emulatorParams("dosscaler", "rgb3x", newParam);
			}
			// force loading of dos utilities
			if(isBoolean(fileProd.dosee_load_utilities) && fileProd.dosee_load_utilities == 1) {
				refresh = true;
				newParam = emulatorParams("dosutils","true", newParam);
			} else if(fileProd.section == "package") {
				if(fileProd.platform == "ansi" or fileProd.platform == "dos") {
					refresh = true;
					newParam = emulatorParams("dosutils","true", newParam);
					newParam = emulatorParams("dosmachine","svga", newParam);
				}
			}
			// redirect to apply newParam query_string modifications
			if(cgi.script_name == "/index.cfm") {
				// create params for the redirectTo route by removing redundant keys
				var args = ListToArray(newParam, '&')
				var ctrl = arrayFind(args, 'controller=file')
				var act = arrayFind(args, 'action=detail')
				var key = arrayContainsNoCase(args, 'key=')
				if(ctrl && act && key) {
					args[ctrl] = ''
					args[act] = ''
					args[key] = ''
				}
				newParam = arrayToList(args, '&')
				args = ListToArray(list=newParam,delimiter='&',includeEmptyFields=false)
				newParam = arrayToList(args, '&')
			}
			if(refresh && len(newParam)) {
				if(newParam == cgi.query_string) {
					dump(newParam)
					return
				}
				redirectTo(statusCode="307",route="f",key=dos.pubkey,params=newParam);
			}

		}

		onlyProvides("html");
		var platforms=model("Files").findAll(select="platform",distinct=true,includeSoftDeletes=all,where="platform IS NOT NULL")
		var sections=model("Files").findAll(select="section",distinct=true,includeSoftDeletes=all,where="section IS NOT NULL")
		canonical = "/f/#params.key#";
		if(params.route == '') canonical = "/f/#params.key#";
		if(pagination() == "404") {
			// Closures in either Lucee or CFWheels expect string values and throw errors returning objects.
			// So this is a workaround.
			return render404();
		}
		try { archive() } catch(any err) {}
		variables.title = title()
		variables.description = description()
		admin() // TODO: pass fileProd through params?
		textViewer()
		variables.loadChiptunes = IsChiptune(fileProd.filename)
		if (!variables.loadChiptunes) {
			chiptunePlayer()
			var path = "#get(myapp).fulldirFileUuid#/#fileProd.uuid#.chiptune"
			variables.loadChiptunes = fileExists(path)
			variables.chiptunePath = "/d/#params.key#.chiptune"
		}
		emulator()
	}

	// download the file
	public any function download(string key="") {
		onlyProvides("html")
		try {
			variables.fileProd = model("Files").findByKey(
				key=deobfuscateParam(params.key),
				includeSoftDeletes=all,
				select="filename,file_last_modified,file_security_alert_url,uuid,filesize")
			fileProd.uuid = LCase(fileProd.uuid)
		} catch(any err) {
			return render404();
		}
		// enforce PATHS.PNG restrictions (see loc.myapp.ipRestrictions in /config/settings-application.cfm)
		var addresses = get(myapp).ipRestrictions
		for (var addr in addresses) {
			if(left(CGI.remote_addr,len(addr)) == addr) return render404();
			if(CGI.remote_addr != CGI.remote_host && right(CGI.remote_host,len(addr)) == addr) return render404();
		}
		// disabled downloads
		switch(fileProd.file_security_alert_url) {
			case "":
				// a normal download with no unwanted software or security restrictions
				break;
			default: {
				if(cgi.query_string != unwantedSoftware) return render404();
			}
		}
		// adjust Lucee timeout values for extra-large file downloads
		variables.pageTimeout = _timeout(fileProd.filesize)
		// automatically forward external linked downloads to the detail page
		if(!refererCheck()) redirectTo(statusCode="301",route="f",key=obfuscateParam(params.key));
		renderView();
	}

	// edit the assets of the file record and the public view
	public any function edit() {
		param name="params";
		param name="params.approvefile" default=0;
		param name="params.enablefile" default=0;
		param name="params.disablefile" default=0;
		param name="params.rescanpackage" default=false;
		param name="params.generateimages" default=false;
		param name="params.regeneratethumbs" default=false;
		param name="params.killimages" default=false;
		//writeDump(label="File.cfc edit() Params",var="#params#" ,abort=true);
		onlyProvides("html");

		var png = ""

		// delete existing images
		var deleteImages = function() {
			if(fileExists(paths.thumb400)) fileDelete(paths.thumb400);
			if(fileExists(paths.png)) fileDelete(paths.png);
			if(fileExists(paths.webp)) fileDelete(paths.webp);
			// erase db entries
			item.preview_image = ""
			flashInsert(delimagesInfo="Deleted all images and thumbs")
		}

		// clone the download image and use it for image assets
		var cloneImages = function() {
			png = fileConvertImage2Png(source=paths.download,filename=item.filename);
			if(png contains "error") {
				flashInsert(genPreviewError=png)
				return
			}
			else flashInsert(genPreview=png)
			var move = fileMoveImage(get(myapp).fulldirPreview,item.uuid)
			if(move contains "error") flashInsert(movePreviewError=move)
			else flashInsert(movePreview=move)
			var pngfile = "#get(myapp).fulldirPreview#/#item.uuid#.png"
			var webp = fileConvertImage2WebP(source=pngfile)
			if(webp contains "error") flashInsert(movePreviewError=webp)
			else flashInsert(optPreview=webp)
			thumbs(pngfile)
		}

		// capture the text document as an image for image assets
		var documentImages = function() {
			// File extension modification to force AnsiLove/C to render PCBoard control codes.
			var hack = item.filename
			var font = ""
			if(item.platform == "pcb" && listLast(item.filename,".") != "pcb") hack = item.filename & ".PCB";
			if(item.platform == "textamiga") font = "topaz+"
			// removed document check so this becomes a catch-all process. if IsDocument(local.item.filename)
			png = fileConvertText2Png(source=paths.download, filename=hack, font=font)
			if(png contains "error") flashInsert(genDocumentationError=png)
			else flashInsert(genDocumentation=png)
			thumbs(paths.png)
		}

		// generate 400x sized thumbnails
		var thumbs = function(required string src) {
			param name="params";
			// 400x
			var start = getTickCount()
			var dest = "#get(myapp).fulldirThumb400#/#params.uuid#.png"
			var result = fileConvertImageSquared(source=arguments.src,destination=dest,length="400");
			try { fileSetAccessMode(dest, 664) } catch(any e) {}
			if(result contains "error") flashInsert(genThumb400error="400x thumbnail error <small>#result#</small>");
			else if(len(result)) flashInsert(genThumb400="400x thumbnail generated <small>file.thumbs() took #((getTickCount()-start)/1000)# seconds</small>");
		}

		// extract any images from the download archive
		var extractImages = function() {
			// document
			var found = false
			var file = fileDetermineImages(item.filename,item.group_brand_for,item.group_brand_by,item.file_zip_content,'document')
			if(len(file)) {
				png = imageProcess(filename=file,archivename=item.filename,process="preview-text",uuid=item.uuid)
				if(ListFirst(png,":") != "Error") {
					found = true
					thumbs(png)
				}
				flashInsert(arcProcess=png)
			}
			// preview
			file = fileDetermineImages(item.filename,item.group_brand_for,item.group_brand_by,item.file_zip_content,'preview')
			if(len(file)) {
				png = imageProcess(filename=file,archivename=item.filename,process="preview_image",uuid=item.uuid)
				if(listFirst(png,":") != "Error") {
					found = true
					item.preview_image = Trim(file)
					thumbs(png)
				}
				flashInsert(arcProcess=png);
			}
			// zero previews
			if(!found) flashInsert(arcProcessInfo="#appname# no suitable files were found in the archive");
		}

		// rescan content of archive
		var rescan = function() {
			// archive scan
			try {
				flashInsert(rescanArchive="Successfully rescanned the content of archive");
				item.file_zip_content = fileContentofArchive(paths.download,fileExtension(item.filename)).file_zip_content
				if(item.record_title == "" && ListLen(trim(item.file_zip_content),chr(10),true) == 1) {
					item.record_title = lcase(trim(item.file_zip_content))
				}
			} catch(any err) {
				flashInsert(rescanArchiveError='#appname# could not rescan archive<br> &nbsp; <i class="fal fa-angle-double-right fa-fw"></i><small>#err.message#</small>');
				item.file_zip_content = ""
			}
			// fetch filesize, md5, sha hash
			try {
				flashInsert(hashArchive="Successfully hashed the the file");
				file = fileHashandSize(paths.download)
				item.filesize = file.size
				item.file_integrity_weak = file.md5hash
				item.file_integrity_strong = file.shahash
			}
			catch(any err) {
				flashInsert(hashArchiveError="#appname# could not hash the file");
				item.file_integrity_weak = item.filesize = ""
			}
		}

		// update the public access status
		var status = function() {
			if(params.approvefile || params.enablefile) {
				if(item.group_brand_for == get(myapp).pubNameForTests || item.group_brand_by == get(myapp).pubNameForTests) {
					flashInsert(debugsuccess="Test file is saved but it is not enabled");
					return;
				}
				item.update(deletedat="",deletedby="")
				flashInsert(debugsuccess="File is enabled");
				return;
			}
			if(params.disablefile) {
				item.update(deletedat=CreateODBCDateTime(Now()),deletedby=session.op.uuid)
				flashInsert(debugsuccess="File is disabled");
			}
		}

		// create thumbnails
		var thumbnails = function() {
			var aspect = false
			if(params.regeneratethumbs) aspect = true;
			// determine thumbnail source file
			source = "#get(myapp).tmpDirectory##application.applicationname##item.uuid#.png"
			if(params.regeneratethumbs) {
				// use previews before documents as thumbnails
				if(fileExists(paths.png)) source = paths.png;
			}
			// process source
			if(params.regeneratethumbs or (isDefined("imgrun") and !listFirst(imgrun,":") contains "Error")) {
				imgrun = fileConvertImageSquared(source=source,destination=paths.thumb400,length="400",keepaspectratio=aspect);
				if(imgrun contains 'error:') flashInsert(genThumb400Error=imgrun);
				else flashInsert(genThumb400=imgrun);
			}
		}

		var tick = getTickCount()
		var appname = "file edit"
		// override params to block anyone but the sysops from accessing the following
		if(!opCheck('sysop')) {
			params.approvefile = 0;
			params.regeneratethumbs = false;
			params.killimages = false;
		}
		// fetch database record
		if(!structKeyExists(params,"uuid")) {
			var itemByKey = model("Files").findByKey(key="#deobfuscateParam(params.key)#",includeSoftDeletes=all,select="uuid")
			params.uuid = itemByKey.uuid
			itemByKey = queryNew("") // empty record
		}
		var item = model("Files").findOneByUuid(value=params.uuid,includeSoftDeletes=true,reload=true,cache=false);
		if(isBoolean(item) && !item) {
			flashInsert(opkillerror="#appname# the record #UCase(params.uuid)# could not be found");
			redirectTo(back=true);
		}
		item.uuid = lCase(item.uuid);
		// set file paths
		var paths = {
			"download":"#get(myapp).fulldirfileuuid#/#item.uuid#",
			"thumb400":"#get(myapp).fulldirThumb400#/#item.uuid#.png",
			"png":"#get(myapp).fulldirPreview#/#item.uuid#.png",
			"webp":"#get(myapp).fulldirPreview#/#item.uuid#.webp",
		}
		if(params.rescanpackage) rescan();
		if(params.killimages) deleteImages();
		if(params.generateimages) {
			// create new images
			if(IsArchive(item.filename)) extractImages();
			else if(IsGraphic(item.filename)) cloneImages();
			else documentImages();
		}
		if(params.generateimages || params.regeneratethumbs) thumbnails();
		status()
		try {
			item.save()
		} catch(any err) {
			flashInsert(dbError="#appname# could not save changes to the database<br><small>#err.message#</small>");
		}
		if (!flashKeyExists("debugsuccess")) {
			flashInsert(debugsuccess="<strong>This record is updated</strong>");
		}
		var paramCol = ""
		try {

			paramCol = "name=#params.name#&src=#params.src#&platform=#lCase(params.platform)#&section=#lCase(params.section)#&sort=#params.sort#"
		} catch(any err) {}
		redirectTo(route="f",key=obfuscateParam(item.id),params=paramCol);
	}

	// download and save a remote file and return the fetched metadata
	public any function httprequest() {
		param name="params";
		// URL of the file to download
		param name="params.url" default="";
		// Directory to save and store the download file
		param name="params.path" default=get(myapp).fulldirFileUuid;
		// Unique ID (UUID) to use as the file download filename
		param name="params.id" default="";
		set(showDebugInformation=false);
		onlyProvides("json");

		var ftp = function() {
			if(!protocol == 'ftp') return;
			if(download.status_code != 226) return;
			var info = getFileInfo(results.filepath)
			results.success = fileExists(results.filepath)
			results.platform = detectPlatform(results.filename)
		}

		var html = function() {
			if(protocol does not contain 'http') return;
			if(download.status_code != 200) return;
			if(download['Content-Type'] != "text/html;charset=UTF-8") return;
			// throw an error if a HTML page is returned
			renderText(serializeJSON(results))
		}

		var http = function() {
			if(protocol does not contain 'http') return;
			if(download.status_code != 200) return;
			results.success = fileExists(results.filepath)
			results.lastModified = download['Last-Modified']
			results.length = download['Content-Length']
			results.filesize = humanizeFileSize(results.length)
			results.platform = detectPlatform(results.filename)
			results.type = download['Content-Type']
			results.filemd5 = fileHashed(filename=results.filepath,algorithm="md5")
			results.filesha384 = fileHashed(filename=results.filepath,algorithm="sha")
		}

		var results = {
			"error":'',
			"filemd5":'',
			"filename":listLast(params.url,'/'),
			"filepath":'#params.path#/#params.id#',
			"filesize":'',
			"filesha384":'',
			"lastModified":'',
			"length":0,
			"platform":'',
			"status_code":'',
			"success":false,
			"type":'',
			"url":params.url,
		}

		if(params.id == '') results.error = 'params.id is required to be used as a filename, it needs to be a UUID value'
		var download = {}
		if(!len(results.error)) {
			download = downloadBin(params.url,params.id,params.path)
			results.status_code = download.status_code
		}
		// handle get file results
		var protocol = ListFirst(params.url, ':')
		ftp()
		html()
		http()
		if(!results.success) {
			// return an error using the default values of results
			return renderText(serializeJSON(results));
		}
		// update record
		var record = model("File").findOneByUuid(uuid=params.id,includeSoftDeletes=true)
		if(isBoolean(record) && !record) {
			results.error = 'Could not save file to the database as record ''#params.id#'' does not exist'
			results.success = false
			return renderText(serializeJSON(results));
		}
		if(!results.success) {
			results.error = 'Could not either download the file or save it to the server'
			return renderText(serializeJSON(results));
		}
		record.filename = results.filename
		record.filesize = results.length
		record.file_last_modified = results.lastModified
		results.platform = ""
		if(!len(record.platform)) record.platform = lCase(results.platform)
		// hashed values of file
		record.file_integrity_weak = results.filemd5
		record.file_integrity_strong = results.filesha384
		// nullify entries
		record.file_zip_content = ''
		record.dosee_run_program = ''
		record.retrotxt_readme = ''
		record.save()
		if(record.hasErrors()) {
			// errors
			results.error = "Could not save file to the database record ''#params.id#'' due to #record.errorCount()# errors"
			results.success=false
		}
		renderText(text=serializeJSON(results), status=200)
	}

	// list files as a table, cards or thumbnails
	public any function list() {
		// defaults
		param name="params.key" default="-";
		param name="params.output" default=get(myapp).reset.FileList.output;
		param name="params.platform" default="-";
		param name="params.section" default="-";
		param name="params.sort" default=get(myapp).reset.FileList.sort;
		if(params.key == "waitingapproval") {
			param name="params.sort" default="posted_asc";
		}
		param name="params.perPage" default=get(myapp).reset.FileList.perpage;
		param name="params.page" default="1";
		onlyProvides("html");
		if(params.key == "waitingapproval" && !opCheck("coop")) {
			return render404();
		}
		params.section = lCase(params.section)
		params.platform = lCase(params.platform)
		// legacy URI redirects
		if(listLen(list=cgi.path_info,delimiters="/") >= 4) redirectTo(route="fileFilter",key=params.key,statusCode="301");
		if(listFindNoCase("date,posted,title",params.sort)) {
			// legacy order values
			switch(params.sort) {
				case "date": params.sort = "date_asc"; break;
				case "posted": params.sort = "posted_desc"; break;
				case "title": params.sort = "title_asc"; break;
			}
			var redirect = "output=#params.output#&platform=#params.platform#&section=#params.section#&sort=#params.sort#&perpage=#params.perpage#"
			redirectTo(route="fileList",statusCode="301",params=redirect);
		}
		if(listFindNoCase("intro,magazine,nfotool",params.key)) {
			switch(params.key) {
				case "intro":
					params.section = "releaseadvert";
					break;
				case "magazine":
					params.section = "magazine";
					params.output = "text";
					break;
				case "nfotool":
					params.section = "nfotool";
					params.output = "text";
					params.sort = "posted_desc";
					break;
			}
			params.key = "-"
			var redirect = "output=#params.output#&platform=#params.platform#&section=#params.section#&sort=#params.sort#&perpage=#params.perpage#"
			redirectTo(route="fileList",statusCode="301",params=redirect);
		}
		// custom URI redirects
		if(params.key == "new") {
			var redirect = "output=#params.output#&platform=-&section=-&sort=posted_desc&perpage=#params.perpage#"
			var temporaryRedirect = 307
			redirectTo(route="fileList",statusCode=temporaryRedirect,params=redirect);
		}
		// database section or platform values re-factor and redirection
		var platforms = "mac OS X:mac10;markupLanguage:markup"
		loop list="#platforms#" index="local.index" delimiters=";" {
			var redirect = "output=#params.output#&platform=#platform=ListLast(index,":")#&section=-&sort=posted_desc&perpage=#params.perpage#"
			if(ListFirst(index,":") == params.platform) redirectTo(route="fileList",statusCode="301",params=redirect);
		}
		var section = "fileTransferSystem:ftp"
		loop list="#section#" index="local.index" delimiters=";" {
			var redirect = "output=#params.output#&platform=-&section=#ListLast(index,":")#&sort=posted_desc&perpage=#params.perpage#"
			if(ListFirst(index,":") == params.section) redirectTo(route="fileList",statusCode="301",params=redirect);
		}
		// refactored legacy QuickLinks keys redirection. (see config/settings-navigation.cfm)
		for (var file in get(myapp).refactored.files) {
			if(params.key == file[1] && ListLen(file[2],":") == 2) {
				var redirect = "output=#params.output#&platform=#platform=ListLast(file,":")#&section=#ListLast(file[2],':')#&sort=#params.sort#&perpage=#params.perpage#"
				redirectTo(route="fileFilter",key="-",statusCode="301",params=redirect);
			}
		}
		// URI arguments value enforcement
		// permitted values
		var sections=model("Files").findAll(select="section",distinct=true,includeSoftDeletes=all)
		var platforms=model("Files").findAll(select="platform",distinct=true,includeSoftDeletes=all)
		if(opCheck('coop')) {
			if(!ListContainsNoCase(sorts, "disabled")) sorts = ListAppend(sorts,"disabled")
		}
		if(!ArrayFindNoCase(keys, params.key)) return render404();
		if(!ListFindNocase(get(myapp).displayValues,params.output)) return render404();
		if(!params.platform == "-" && !ListFindNocase(ValueList(platforms.platform),params.platform)) return render404();
		if(!params.section == "-" && !ListFindNocase(ValueList(sections.section),params.section)) return render404();
		if(!ListFindNocase(sorts,params.sort)) return render404();
		if(!IsNumeric(params.page)) return render404();
		if(params.page == 0) return render404();
		if(!IsNumeric(params.perPage)) params.perPage = get(myapp).maxPageItems;
		if(params.perPage > get(myapp).maxPageItems) params.perPage = get(myapp).maxPageItems;
		// Generate data
		if(StructKeyExists(params,"route") && cgi.script_name != '/index.cfm') {
			// reset key if route is fileList (/file/list?query)
			if(params.route == "home") params.route = "fileList";
			if(params.route == "fileList") params.key = "-";
		}
		// generate data for the dynamic menus
		variables.collectionMenuData = menuItems('filecollection',params.key);
		// title and header
		var info = {}
		try {
			info = menuTitles(params);
		}
		catch(any err) { return render404(); }
		variables.heading = info.header ?: ""
		if(params.section == "package") {
			switch(params.platform) {
				case "ansi": heading = "ANSI artpacks"; break;
				case "audio": heading = "Music packs"; break;
				case "dos": heading = "MS-DOS software packs <small>and MS-DOS+Windows mixed packs</small>"; break;
				case "image": heading = "Image packs"; break;
				case "text": heading = "ASCII artpacks, NFO and text packs"; break;
				case "windows": heading = "Windows software packs"; break;
			}
		}
		variables.title = titleize(info.title) ?: ""
		if(params.sort == 'posted_desc' && params.key == '-' && params.section == '-' && params.platform == '-') {
			params.route = 'fileFilter'
			breadcrumbs &= LCase(crumbTrail(params, 3, 'new'))
		} else {
			breadcrumbs &= crumbTrail(params, 3, params.key)
		}
		var describe = function() {
			if(params.platform != '-' && params.section != '-') {
				return 'The collection of #humanizePlatform(params.platform)# and #humanizeSection(params.section)# files'
			}
			if(params.section != '-') return 'The collection of #humanizeSection(params.section)# files'
			if(params.platform != '-') return 'The collection of #humanizePlatform(params.platform)# files'
			if(params.key == 'visual') return 'The collection of digital and pixel artworks'
			if(params.key == 'document') return 'The collection of ascii, ansi and text artworks'
			if(params.key == 'software') return 'The collection of software created by the Scene'
			if(params.key == 'github') return 'Programs and applications host their source code on GitHub'
			if(params.sort == 'posted_desc' && params.section == '-' && params.section == '-') {
				return 'The most recent files added to Defacto2'
			}
			return 'A collection of scene files'
		}
		variables.description = describe()
		var sql = dynamicSqlForFile(params,sections,platforms)
		// fetch count of records
		variables.collectionFilesCount = model("Files").count(where="#sql.whereState#",includeSoftDeletes=all)
		// fetch records for display
		variables.collectionFiles = queryNew("")
		var order = dynamicSqlFileOrder(params.sort)
		if(params.sort contains "title") {
			collectionFiles = model("file").listFilesSortedAZ(where="#sql.whereState#",page=params.page,perPage=params.perPage,order=order,includeSoftDeletes=all);
		} else {
			var select="comment,createdAt,credit_program,credit_illustration,credit_audio,credit_text,file_zip_content,fileName,preview_image,"
			select &= "fileSize,file_security_alert_url,id,group_brand_by,record_title,group_brand_for,date_issued_day,date_issued_month,"
			select &= "date_issued_year,platform,section,uuid,web_id_youtube,deletedat,deletedby,updatedby,web_id_github,web_id_16colors"
			collectionFiles = model("Files").findAll(where="#sql.whereState#",page=params.page,perPage=params.perPage,order=order,select=select,includeSoftDeletes=all);
		}
		if(IsStruct(collectionFiles) && StructKeyExists(collectionFiles,'uuid')) collectionFiles.uuid = LCase(collectionFiles.uuid);
		// format of the list of results to be displayed
		partialToDisplay = filePartialToDisplay()
		// assume invalid URL was provided if no websites are returned
		if(collectionFiles.recordCount == 0) return render404();
	}

	// process preview and thumbnail images
	public any function images() {
		param name="params";
		param name="params.formOnFile.preview_image" default="";
		onlyProvides("html")

		// if the download is an image, use that as the source to generate the image assets
		var clone = function() {
			var download = "#get(myapp).fulldirfileuuid#/#record.uuid#"
			var result = fileConvertImage2Png(source=download,overwrite=images.ow,filename=record.filename)
			var dir = get(myapp).fulldirPreview
			var move = fileMoveImage(dir,record.uuid)
			flashInsert(genPreview=result)
			flashInsert(movePreview=move)
			if(move contains "error") flashInsert(movePreviewError=move);
			else flashInsert(movePreview=move);
			fileConvertImage2WebP("#images.optimise#.png")
		}

		// use the "screenshot filename or URL" form as the source image assets
		// this function only handles URLs and not screenshot filenames stored in archives.
		var download = function() {
			if(!Len(params.formOnFile.preview_image)) {
				// empty form
				redirectTo(route="f",key=obfuscateParam(record.id));
			}
			var input = toString(params.formOnFile.preview_image)
			images.formInput = input; // todo remove
			if(!len(input)) return;
			if(!findNoCase("://", input)) return;
			var scheme = left(input, findNoCase("://", input)-1)
			if(!listFindNoCase(get(myapp).acceptedURISchemes, scheme)) return;
			// fetch image from a user supplied URL
			var name = right(input,findNoCase("/",reverse(input))-1)
			var path = ""
			try { newImg = imageNew(input) }
			catch(any err) {
				flashInsert(imghttpError="<b>Fetch image</b> #err.message#")
				redirectTo(route="f",key=obfuscateParam(record.id))
			} try {
				path = "#get(myapp).tmpDirectory##name#"
				imageWrite(name=newImg,destination=path,overwrite=true)
			}
			catch(any err) {
				flashInsert(imghttpError="<b>Save fetch image</b> #err.message#")
				redirectTo(route="f",key=obfuscateParam(record.id))
			}
			var extension = right(input,findNoCase(".",reverse(input))-1)
			if(extension != "png") {
				// convert image
				fileConvertImage2Png(source=path,overwrite=images.ow,filename="#filenameLessExtension(name)#")
				path = "#get(myapp).tmpDirectory##application.applicationname##name#.png"
			}
			// rename original image as a backup
			if(FileExists(images.preview) && (fileHashandSize(path).md5hash != fileHashandSize(images.preview).md5hash)) {
				backup = "#images.preview#.#DateFormat(Now(),'ddmmyy')##TimeFormat(Now(),'hhmmss')#.archived"
				fileMove(images.preview, backup)
				try { fileSetAccessMode(backup, 664) } catch(any err) {}
			}
			// move png image to preview image folder
			fileMove(path,images.preview)
			try { fileSetAccessMode(images.preview, 664) } catch(any err) {}
			// optimise image
			fileConvertImage2WebP("#images.optimise#.png")
			// update database with preview_image = local.imgupload.ServerFile
			flashInsert(debugsuccess="Image from URL saved and thumbs refreshed")
		}

		// use the "screenshot filename or URL" form as the source image assets
		// this function only handles filenames stored in a file archive
		var extracts = function() {
			// set file paths for imageProcess()
			paths = {
				"download":"#get(myapp).fulldirfileuuid#/#record.uuid#",
				"thumb400":"#get(myapp).fulldirThumb400#/#record.uuid#.png",
				"png":"#get(myapp).fulldirPreview#/#record.uuid#.png",
				"webp":"#get(myapp).fulldirPreview#/#record.uuid#.webp",
			}
			inputs.preview_image = trim(inputs.preview_image)
			// match input supplied filename casing to the one in archive, otherwise the extraction may fail on Linux
			var zipContent = params.formOnFile.file_zip_content
			var search = findNoCase(inputs.preview_image,zipContent)
			if(!search) {
				flashInsert(updateImagesError="Could not find the file '#inputs.preview_image#' in archive '#record.filename#'")
				redirectTo(route="f",key=obfuscateParam(record.id))
			}
			var filename = mid(zipContent,findNoCase(inputs.preview_image,zipContent),len(inputs.preview_image))
			if(filename == inputs.preview_image) inputs.preview_image = filename; // CFML is case-insensitive
 			// extract any missing images from file archive
			if(len(inputs.preview_image) && !fileExists(images.preview)) {
				var result = ""
				if(IsGraphic(inputs.preview_image)) {
				// attempt to create an image based preview
					result = imageProcess(filename=inputs.preview_image,archivename=record.filename,process="preview_image",uuid=params.uuid)
				} else {
				// attempt to create a text or ansi based preview
					result = imageProcess(filename=inputs.preview_image,archivename=record.filename,process="preview-text",uuid=params.uuid)
				}
				if(ListFirst(result,":") != "Error") {
					record.preview_image = inputs.preview_image
				}
				flashInsert(arcProcess=result);
			}
			// throw an error if neither extraction worked
			if(!fileExists(images.preview)) {
				//rewrite this to use both doc and preview
				if(Len(images.formInput)) flashInsert(opUpdateImages2Error="Could not use the source image #images.formInput#");
				else flashInsert(opUpdateImages2Error="Could not use the source image");
				redirectTo(route="f",key=obfuscateParam(record.id))
			}
			/* preview */
			if(!findNoCase("://",inputs.preview_image)) {
				var newImg = process(type="preview_image",src=images.preview,img=record)
				if(newImg contains 'error:') {
					flashInsert(opUpdateImages3Error="Could not process the source image #record.preview_image# as a screenshot")
					redirectTo(route="f",key=obfuscateParam(record.id))
				}
			}
			paths = {}
		}

		// generate 400x sized thumbnails. this is a duplicate of the thumbs closure in edit()
		var thumbs = function(required string src) {
			param name="params";
			// 400x
			var start = getTickCount()
			var dest = "#get(myapp).fulldirThumb400#/#params.uuid#.png"
			var result = fileConvertImageSquared(source=arguments.src,destination=dest,length="400");
			try { fileSetAccessMode(dest, 664) } catch(any e) {}
			if(result contains "error") flashInsert(genThumb400error="400x thumbnail error <small>#result#</small>");
			else if(len(result)) flashInsert(genThumb400="400x thumbnail generated <small>file.thumbs() took #((getTickCount()-start)/1000)# seconds</small>");
		}

		// use the "upload a screenshot" form as the source image assets
		var upload = function() {
			var upload = fileUpload(destination=get(myapp).fulldirUploadImg, fileField="filePreviewUpload", accept=images.accepted, nameConflict="overwrite")
			var desc = "#upload.ServerDirectory#/#upload.ServerFile#"
			var source = "#get(myapp).tmpDirectory#/#application.applicationname##upload.ServerFile#.png"
			if(!len(upload.serverfile)) throw("upload serverfile is empty: #desc#")
			try { fileSetAccessMode(desc, 664) } catch(any err) {}
			var extension = ""
			if(FileExists(desc)) {
				// delete or overwrite destination if it exists
				if(upload.serverfileext != "png") {
					// convert image
					var result = fileConvertImage2Png(source=desc,overwrite=images.ow,filename="#upload.serverFile#")
					extension = ".png"
					if(FileExists(source)) fileMove(source, '#desc#.png')
					if(len(result)) flashInsert(convImg=result);
				}
			}
			desc = "#upload.ServerDirectory#/#upload.ServerFile##extension#"
			try { fileSetAccessMode(desc, 664) } catch(any err) {}
			// rename original image as a backup
			if(FileExists(images.preview)) {
				if(fileHashandSize(images.preview).md5hash != fileHashandSize(desc).md5hash) {
					try { fileSetAccessMode(images.preview, 664) } catch(any err) {}
					fileMove(images.preview, '#images.preview#.#DateFormat(Now(),'ddmmyy')##TimeFormat(Now(),'hhmmss')#.archived');
				}
			}
			// move png image to preview image folder
			fileMove(desc,images.preview);
			try { fileSetAccessMode(images.preview, 664) } catch(any err) {}
			// optimise image
			fileConvertImage2WebP("#images.optimise#.png")
			// update database with preview_image = local.upload.ServerFile
			record.preview_image = upload.ServerFile
			flashInsert(previewsuccess="Preview saved and thumbs refreshed")
		}

		var process = function(required string type, required string src, required struct img) {
			if(!Len(params.formOnFile[arguments.type])) {
				// delete existing images
				if(FileExists(arguments.src)) {
					fileDelete(arguments.src)
					flashInsert(delImage="Deleted #arguments.type#")
				}
				return;
			}
			var result = ""
			if(params.formOnFile[arguments.type] != arguments.img[arguments.type]) {
				// generate new or replacement images
				result = imageProcess(params.formOnFile[arguments.type],arguments.img.filename,'#arguments.type#',arguments.img.uuid)
				if(len(result)) flashInsert(genPreview=result)
			}
			return result
		}

		var tick = getTickCount()
		var record = model("File").findOneByUuid(value=params.uuid,includeSoftDeletes=all)
		if(IsBoolean(record) && record == false) {
			flashInsert(updateImagesError="Could not locate record: #params.uuid#")
			redirectTo(back=true)
		}
		record.uuid = LCase(record.uuid)
		// Set file paths
		var images = {
			"ow":"", // ow must be a string, not a bool
			"accepted":"image/#Replace(get(myapp).acceptedGraphics,',',',image/','all')#",
			"optimise":"#get(myapp).fulldirPreview#/#record.uuid#",
			"preview":"#get(myapp).fulldirPreview#/#record.uuid#.png",
			"thumb400":"#get(myapp).fulldirThumb400#/#record.uuid#.png",
		}
		// trim form inputs for excess white space
		var inputs = params.formOnFile
		inputs.preview_image = trim(inputs.preview_image)
		if(structKeyExists(params.formOnFile,"imgow")) images.ow = trim(inputs.imgow);
		// process preview image upload
		var processing = function() {
			if(len(params.filePreviewUpload)) {
				upload();
				return;
			}
			if(structKeyExists(params,"formOnFile") && StructKeyExists(params.formOnFile, 'preview_image')) {
				download();
				return;
			}
			if(IsGraphic(record.filename)) {
				clone();
				return;
			}
			// error
			flashInsert(updateImagesError="Could not locate uploaded preview")
			redirectTo(route="f",key=obfuscateParam(record.id));
		}
		processing();
		if(!Len(params.filePreviewUpload) && IsArchive(record.filename) &&
			StructKeyExists(params,"formOnFile") && StructKeyExists(params.formOnFile,"preview_image") &&
			params.formOnFile.preview_image does not contain "://") {
			extracts();
		}
		/* process thumbnails */
		// delete existing thumbs
		if(FileExists(images.thumb400)) {
			fileDelete(images.thumb400)
			flashInsert(delthumb400Info="Deleted 400x400 thumb")
		}
		if(!StructKeyExists(params,"thumbnail") || params.thumbnail == "preview_image" && Len(record.preview_image)) {
			if(!fileExists(images.preview)) {
				flashInsert(opUpdateImages1Error="Could not use the source image #record.preview_image# as a screenshot")
				redirectTo(route="f",key=obfuscateParam(record.id))
			}
			thumbs(images.preview)
		}
		/* save updates to database and redirect */
		record.save();
		if(record.hasErrors()) flashInsert(updateImagesDBError="Record could not be saved");
		else flashInsert(dbssave="Record was saved");
		flashInsert(proccesssuccess="Processed images and thumbs")
		var paramCol = ""
		try {
			paramCol = "name=#params.name#&src=#params.src#&platform=#params.platform#&section=#params.section#&sort=#params.sort#"
		}
		catch(any err) {}
		flashInsert(debugsuccess="<strong>Record updated</strong> <small>File images() took #numberFormat(((getTickCount()-tick)/1000),'_.0')# seconds</small>")
		redirectTo(route="f",key=obfuscateParam(record.id),params=paramCol)
	}

	// replace the file download
	public any function replace() {
		param name="params";
		param name="params.uuid" default="";
		if(!Len(params.uuid)) return render404();
		var tick = getTickCount()
		var item = model("Files").findOneByUuid(value="#params.uuid#",includeSoftDeletes=true);
		item.uuid = LCase(item.uuid)
		if(!StructKeyExists(params,"file-replace") || !Len(params["file-replace"])) {
			flashInsert(hashArchiveError="No file selected to replace the download");
			redirectTo(route="f",key=obfuscateParam(item.id));
		}
		if(!StructKeyExists(params,"confirm") || !Len(params.confirm)) {
			flashInsert(hashArchiveError="Confirmation check-box must be checked before you can replace the download");
			redirectTo(route="f",key=obfuscateParam(item.id));
		}
		// upload file to a temporary location
		var upload = fileUpload(destination=get(myapp).fulldirUploadFiles, fileField="file-replace", nameConflict="makeunique");
		var original = "#get(myapp).fulldirfileuuid#/#item.uuid#"
		// backup original served file
		for (var i=1; i<=999; i++) {
			var name = "#item.uuid#.bak.#i#"
			var backup = "#get(myapp).fulldirfileuuid#/#name#"
			if(FileExists(original) and !FileExists(backup)) {
				fileCopy(original, backup);
			try { fileSetAccessMode(backup, 664) } catch(any err) {}
				flashInsert(backupDownload="Backed up the original download file as #name#");
				break;
			}
		}
		// copy upload to served file
		var replacement = "#upload.serverdirectory#/#upload.serverfile#"
		fileCopy(replacement, original);
		try { fileSetAccessMode(original, 664) } catch(any err) {}
		// alway reset with new replacements
		item.file_zip_content = "";
		// archive scan
		if(IsArchive(upload.serverfile)) {
			try {
				flashInsert(rescanArchive="Successfully rescanned the content of archive");
				item.file_zip_content = fileContentofArchive(original,fileExtension(item.filename)).file_zip_content;
			} catch(any err) {
				flashInsert(rescanArchiveError='Could not rescan archive<br> &nbsp; <i class="fal fa-angle-double-right fa-fw"></i><small>#err.message#</small>');
				item.file_zip_content = "";
			}
		}
		// fetch filesize, md5, sha hash
		try {
			flashInsert(hashArchive="Successfully hashed the the file");
			var hash = fileHashandSize(original);
			item.filesize = hash.size
			item.file_integrity_weak = hash.md5hash
			item.file_integrity_strong = hash.shahash
		} catch(any err) {
			flashInsert(hashArchiveError="Could not hash the file");
			item.filesize = ""
			item.file_integrity_weak = ""
		}
		// add file details to the record
		item.filename = upload.clientfile
		item.file_last_modified = upload.timeLastModified
		// save changes
		item.update(updatedby=session.op.uuid)
		item.save()
		// handle errors
		if(item.hasErrors()) {
			flashInsert(opReplaceError="Problems with the record");
			params.key = obfuscateParam(item.id);
			detail();
			renderView(route="f",key=obfuscateParam(item.id));
			return;
		}
		// redirect to file detail page to show the new changes
		var paramCol = ""
		try {
			paramCol = "name=#params.name#&src=#params.src#&platform=#params.platform#&section=#params.section#&sort=#params.sort#"
		}
		catch(any err) {}
		flashInsert(debugsuccess="<strong>Record updated</strong> <small>file.replace() took #numberFormat(((getTickCount()-tick)/1000),'_.0')# seconds</small>");
		redirectTo(route="f",key=obfuscateParam(item.id),params=paramCol);
	}

	// save form edits to the database
	public any function save() {
		param name="params";
		param name="params.newPlatform" default="";
		param name="params.newSection" default="";
		onlyProvides("html");
		var tick = getTickCount() // for statistics
		// original data
		var od = params.formOnFile
		params.uuid = lCase(params.uuid);
		// handle check boxes, unchecked boxes are not returned by params
		param name="od.dosee_load_utilities" default="";
		param name="od.dosee_no_aspect_ratio_fix" default="";
		param name="od.dosee_no_ems" default="";
		param name="od.dosee_no_xms" default="";
		param name="od.dosee_no_umb" default="";
		param name="od.dosee_incompatible" default="";
		param name="od.retrotxt_no_readme" default=0;
		// retrotxt_readme input is dynamic
		param name="od.retrotxt_readme" default="";
		// get artist credits from the filename?
		od = artpackMetadata(od.platform, od.fileName, od)
		// fetch original record
		var file = model("file").findOneByUuid(value=params.uuid,includeSoftDeletes=all);
		if(isBoolean(file) && (!file)) dump(label="Please check the UUID!",var=params);dump(file);
		file.uuid = lCase(file.uuid);
		// if input retrotxt_readme changed, extract the text file from file archive
		var uuidtxt = fileExists("#get(myapp).fulldirFileUuid#/#uuid#.txt")
		if(!uuidtxt && len(od.retrotxt_readme)) {
			if(od.retrotxt_no_readme != 1) {
				_extractFile(file.uuid,file.filename,od.retrotxt_readme,".txt")
			}
		}
		// if retrotxt_no_readme is set to true,
		// we not only hide but also delete any showcased text files
		if(uuidtxt && od.retrotxt_no_readme == 1) {
			try {
				fileDelete("#get(myapp).fulldirFileUuid#/#uuid#.txt")
			} catch(any err) {}
		}
		else if(od.retrotxt_readme != file.retrotxt_readme) {
			try {
				fileDelete("#get(myapp).fulldirFileUuid#/#uuid#.txt")
			} catch(any err) {}
			if(len(od.retrotxt_readme)) {
				_extractFile(file.uuid,file.filename,od.retrotxt_readme,".txt")
			}
		}
		// serialise dates
		file.updateProperty("date_issued_day", params.date_issued_day);
		file.updateProperty("date_issued_month", params.date_issued_month);
		file.updateProperty("date_issued_year", params.date_issued_year);
		// update all other params
		file.update(od);
		// these needs to be after update otherwise they will be overwritten
		// update platform & section with custom input
		if(StructKeyExists(od,"platform") && !len(od.platform) && !len(params.newPlatform)) {
			file.updateProperty("platform", '#lCase(params.newPlatform)#');
		}
		if(!len(od.section) && len(params.newSection)) file.updateProperty("section", '#lCase(params.newSection)#');
		// remove duplicates, remove illegal chrs and reorder credits credit_illustration credit_text credit_program credit_audio
		var chrs = get(myapp).acceptedDirChrs
		if(len(od.credit_text)) file.updateProperty("credit_text", cleanList(ReReplaceNocase(od.credit_text,chrs,'','all')));
		if(len(od.credit_program)) file.updateProperty("credit_program", cleanList(ReReplaceNocase(od.credit_program,chrs,'','all')));
		if(len(od.credit_illustration)) file.updateProperty("credit_illustration", cleanList(ReReplaceNocase(od.credit_illustration,chrs,'','all')));
		if(len(od.credit_audio)) file.updateProperty("credit_audio", cleanList(ReReplaceNocase(od.credit_audio,chrs,'','all')));
		// remove illegal characters
		if(len(od.group_brand_for)) file.updateProperty("group_brand_for", _formatGroup(od.group_brand_for));
		if(len(od.group_brand_by)) file.updateProperty("group_brand_by", _formatGroup(od.group_brand_by));
		// remove white space characters
		if(len(od.filename)) file.updateProperty("filename", trim(od.filename));
		// save changes
		file.update(updatedby=session.op.uuid);
		file.save();
		// handle errors
		if(file.hasErrors()) {
			var error = "";
			for(var err in file.allErrors()) {
				error = "<li><strong>#err[1]#</strong> failed because '#err[2]#'</li>";
			}
			flashInsert(opUpdateError="Problems with the record<ul>#error#</ul>");
			params.key = obfuscateParam(file.id);
			detail();
			renderView(route="f",key=obfuscateParam(file.id));
			return;
		}
		// redirect to file detail page to show the new changes
		var paramCol = ""
		try {
			paramCol = "name=#params.name#&src=#params.src#&platform=#params.platform#&section=#params.section#&sort=#params.sort#"
		}
		catch(any err) {}
		flashInsert(opUpdateSuccess="<strong>Record updated</strong> <small>file.save() took #numberFormat(((getTickCount()-tick)/1000),'_.0')# seconds</small>");
		redirectTo(route="f",key=obfuscateParam(file.id),params=paramCol)
	}

	// view file download in a browser tab
	public any function view() {
		param name="params.key" default="";
		onlyProvides("html")
		try {
			variables.fileProd = model("Files").findByKey(
				key="#deobfuscateParam(params.key)#",
				includeSoftDeletes=all,
				select="filename,filesize,platform,uuid");
			fileProd.uuid = LCase(fileProd.uuid);
		}
		catch(any err) return render404()
		variables.pageTimeout = _timeout(fileProd.filesize)
		// Abort if the file is a known binary (see helpers-system.cfm for function)
		if(!useViewFile(fileProd.filename, fileProd.filesize, fileProd.platform)) return render404();
		// Attempt to display the file in browser
		renderView()
	}

	// legacy redirect
	public any function raw() {
		param name="params.key" default="";
		redirectTo(controller="file",action="view",key=params.key,statusCode="301")
	}

}