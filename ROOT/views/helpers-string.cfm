<!---
	String and other HTML functions
	path: views/helpers-string.cfm

@CFLintIgnore EXCESSIVE_FUNCTIONS,UNUSED_LOCAL_VARIABLE
--->
<cfscript>
	/*
	 * String functions
	 */

	/**
	* Determines the file platform type using its extension.
	* @filename File name with extension.
	*/
	public string function detectPlatform(string filename="") {
		if(isANSI(arguments.filename)) return "ansi"
		if(isAudio(arguments.filename)) return"audio"
		if(isGraphic(arguments.filename)) return"image"
		if(isDocument(arguments.filename)) {
			if(ListFindNoCase("pdf",fileExtension(arguments.filename))) return "pdf";
			return "text";
		}
		if(isVideo(arguments.filename)) return "video";
		return "";
	}

	/**
	* Inserts the HTML cite tag into a string to selectively highlight text.
	* @text A string of text.
	* @highlight The subtext that will be highlighted.
	*/
	public string function citeText(string text="", string highlight="") {
		var cite = ""
		var length = Len(arguments.highlight)
		var position = 0
		var mark = {"open":"[cite]","close":"[/cite]"}
		var tag = {"open":"<cite>", "close":"</cite>"}

		var txt = ReplaceNocase(arguments.text,tag.close,mark.close,'all') // '</cite>' [/cite]
		txt = ReplaceNocase(txt,tag.open,tag.close,'all') // '<cite>','[cite]'
		txt = XMLFormat(linkExpand(txt))
		position = FindNoCase(arguments.highlight,txt)-1
		try {
			cite = Insert(tag.open, txt, position)
		}
		catch(any err) {
			return arguments.text;
		}
		try {
			cite = Insert(tag.close, cite, position+length+Len(tag.open))
		}
		catch(any err) {
			return arguments.text;
		}
		cite = ReplaceNocase(cite,mark.close,tag.close,'all') // '[/cite]','</cite>
		cite = ReplaceNocase(cite,mark.open,tag.open,'all') // '[cite]','<cite>'
		return cite;
	}

	/**
	* Removes duplicates, reorders values and trim white-space from a list.
	* TODO: TEST
	* @list The list to clean-up.
	* @capitalise Capitalise each item within list.
	* @delimiter List delimiter.
	*/
	public string function cleanList(string list="", boolean capitalise=true, string delimiter=",") {
		var clean = ""
		var cap = arguments.capitalise
		var sep = arguments.delimiter
		arguments.list.listEach(function(element,index,list) {
			var item = Trim(arguments.element)
			if(cap) item = capitalize(item)
			clean=listAppend(clean,item,sep,false)
		}, "#sep#");
		clean = listSort(clean,"textnocase","asc",sep)
		clean = REReplace(clean,'([^\s-])[\&]','\1 &','all')
		clean = REReplace(clean,'[\&]([^-\s])','& \1','all')
		return clean;
	}

	/**
	* Removes all tags from a string and replaces each tag with a space, then all trailing white-space is trimmed.
	* @text Text to clean.
	* @append String to append to the text.
	*/
	public string function removeTags(string text="", string append=".") {
		var txt = Trim(REReplaceNoCase(arguments.text,"<[^>]*>"," ","all"))
		/* automatically add a period to end of line */
		if(REFind("(\!|\.|\?|\_|\=|\+)", Right(txt,1)) != 0) return txt;
		if(!Len(arguments.text)) return txt;
		if(!Len(arguments.append)) return txt;
		txt &= '#arguments.append#'
		return txt
	}

	/**
	* Counts the number of words in a given string.
	* @text String of text.
	*/
	public string function countWords(required string text="") {
		var txt = Trim(arguments.text)
		var space = Chr(32)
		var position = FindNocase(space, txt, 0)
		var words = 0
		while(position){
			words++
			position = Find(space, txt, (position + Len(space)));
		}
		return words;
	}

	/**
	* Aliases for SVG icons sourced from Font Awesome 5.
	* @icon Icon to display.
	* @fixed Fixed Width icon.
	* @size Icon Size.
	* @class Append other CSS classes to the icon.
	* @title Include a title attribute most often shown as a tooltip text when the mouse moves over the icon.
	*/
	public string function svg(required string icon, boolean fixed=true, string size='', string class='', string title='') {
		var glyph = function(string icon="") {
			switch(arguments.icon) {
				// people aliases
				case "person-artists": return "fal fa-paint-brush";
				case "person-coders": return "fal fa-keyboard";
				case "person-musicians": return "fal fa-music";
				case "person-writers": return "fal fa-pen-alt";
				// file platform aliases
				case "platform-archive": return "fal fa-file-archive";
				case "platform-ansi": case "platform-image": return "fal fa-file-image";
				case "platform-audio": return "fal fa-music";
				case "platform-dos": return "fal fa-save";
				case "platform-database": return "fal fa-database";
				case "platform-package": return "fal fa-archive";
				case "platform-linux": return "fab fa-linux";
				case "platform-java": return "fab fa-java";
				case "platform-php": case "platform-markup": return "fal fa-browser";
				case "platform-mac10": return "fab fa-apple";
				case "platform-pcb": return "fal fa-tty";
				case "platform-pdf": return "fal fa-print";
				case "platform-text": return "fal fa-file-alt";
				case "platform-video": return "fal fa-video";
				case "platform-windows": return "fab fa-windows";
				// misc aliases
				case "dosee": return "fal fa-save";
				case "github": return "fab fa-github";
				default: return ""; // this will display a missing alert icon
			}
		}
		var fixedWidth = function(required boolean fixed) {
			if(!arguments.fixed) return ""
			return " fa-fw"
		}
		var resize = function(string size="") {
			if(!len(arguments.size)) return ""
			switch(arguments.size) {
				case "xs": case "sm": case "lg": return " fa-#arguments.size#"; // must include the space prefix
				case "2x": case "3x": case "4x":
				case "5x": case "6x": case "7x":
				case "8x": case "9x": case "10x": return " fa-#arguments.size#"; // must include the space prefix
				default: return ""
			}
		}
		var css = function(string class="") {
			return " #arguments.class#" // must include the space prefix
		}
		var titleAttr = function(string title="") {
			return ' title="#arguments.title#"'
		}
		var font = glyph(arguments.icon)
		font &= fixedWidth(arguments.fixed)
		font &= resize(arguments.size)
		font &= css(arguments.class)
		return '<i class="#font#"#titleAttr(arguments.title)#></i>';
	}

	/**
	* Creates a Date Published string for a file record.
	* @fileRecord Record of the file to generate the display date.
	*/
	public string function fileDate(required query fileRecord) {
		var item = arguments.fileRecord
		if(!Len(item.date_issued_year) && !Len(item.date_issued_month) && !Len(item.date_issued_day)) return ""
		var date = ""
		if(Len(item.date_issued_year)) date = item.date_issued_year;
		if(Len(item.date_issued_month)) date &= "-" & NumberFormat(item.date_issued_month,'00');
		if(Len(item.date_issued_day)) date &= "-" & NumberFormat(item.date_issued_day,'00');
		return date;
	}

	/**
	* Creates a title string for a file record.
	* @fileRecord Record of the file to generate the display title.
	*/
	public string function fileTitleDate(required query fileRecord) {
		var item = arguments.fileRecord
		var title = function() {
			// note there are no try/catches in place, this function assumes the correct schema is being used
			if(item.section == "magazine") return "#item.group_brand_for# - #item.record_title#"
			if(structKeyExists(item, "record_title") && Len(item.record_title)) return Replace(item.record_title,chr(34),chr(39),'all');
			if(structKeyExists(item, "comment") && Len(item.comment)) return Replace(truncate(item.comment,200),chr(34),chr(39),'all');
			if(structKeyExists(item, "filename")) return "#item.filename#";
			return ""
		}
		var published = function() {
			if(!Len(item.date_issued_year) && !Len(item.date_issued_month) && !Len(item.date_issued_day)) return ""
			var date = ""
			if(Len(item.date_issued_year)) date &= item.date_issued_year;
			if(Len(item.date_issued_month) && IsNumeric(item.date_issued_month)) date &= " #MonthAsString(item.date_issued_month)#";
			if(Len(item.date_issued_day)) date &= " #item.date_issued_day#"
			return " (#trim(date)#)"
		}
		var text = title()
		text &= published()
		return XMLFormat(removeTags(text=text,append=""));
	}

	/**
	* Creates a title string for a file record that is used as a href link.
	* @fileRecord Record of the file to generate the display title.
	*/
	public string function fileTitle(required query fileRecord) {
		var item = arguments.fileRecord
		if(item.section == "magazine") return "#item.group_brand_for# #item.record_title#";
		if(Len(item.record_title)) return "#item.record_title#";
		return "#item.filename#";
	}

	/**
	* Returns a extension belonging to a file.
	* @filename File name.
	*/
	public string function fileExtension(required string filename) {
		var tarGZ = ".tar.gz" // note the double extension
		if(Right(arguments.filename,7) == tarGZ) return tarGZ
		var position = Len(ListLast(arguments.filename,'.'))
		if(position) return Trim(Right(arguments.filename,position));
		return Trim(arguments.filename);
	}

	/**
	* Returns a extension belonging to a file.
	* @filename File name.
	*/
	public string function fileWithoutExtension(required string filename) {
		var tarGZ = ".tar.gz" // note the double extension
		if(Right(arguments.filename,7) == tarGZ) return Trim(Left(arguments.filename,Len(arguments.filename)-7))
		var position = Len(ListLast(arguments.filename,'.'))
		if(position) return Trim(Left(arguments.filename,Len(arguments.filename)-position-1));
		return Trim(arguments.filename);
	}

	/**
	* Returns a CSS property used to highlight a recommended form input element.
	* @trigger Boolean to display CSS property.
	*/
	public string function highlightWarning(boolean trigger=false, boolean highlight=false) {
		if(!arguments.trigger) return ""
		var css = ""
		// brand-danger is used for <label>
		// has-error is for form <input>
		css = "brand-warning has-warning";
		if(arguments.highlight) css &= " highlight-brand-warning";
		return css;
	}

	/**
	* Returns a CSS property used to highlight a required form input element.
	* @trigger Boolean to display CSS property.
	*/
	public string function highlightDanger(boolean trigger=false, boolean highlight=false) {
		if(!arguments.trigger) return ""
		var css = ""
		// brand-danger is used for <label>
		// has-error is for form <input>
		css = "brand-danger has-error";
		if(arguments.highlight) css &= " highlight-brand-danger";
		return css;
	}

	/**
	* Returns a CSS property used to highlight a required form input element.
	* @trigger Boolean to display CSS property.
	*/
	public string function formDanger(required array triggers=[]) {
		for (var element in arguments.triggers) {
			if(element) return "highlight-brand-danger";
		}
		return "";
	}

	/**
	* Converts a numeric value into a readable file size measurement.
	* @fileSize Byte value to format.
	*/
	public string function humanizeFileSize(number fileSize=0) {
		var none = "n/a"
		var kilo = 1024
		var mega = kilo^2
		var giga = kilo^3
		var tera = kilo^4
		var size = arguments.fileSize
		if(!isNumeric(size)) return none
		if(!size) return none
		// 3/1 returns a decimal, 3\1 returns an integer
		if(size/tera >= 1 && (size\tera) != size) {
			var val = NumberFormat(size/tera, "_._")
			if(Right(val,1) == "0") val = (size\tera)
			return val & ' TB';
		}
		if(size/giga >= 1 && (size\giga) != size) {
			var val = NumberFormat(size/giga, "_._")
			if(Right(val,1) == "0") val = (size\giga)
			return val & ' GB';
		}
		if(size/mega >= 1 && (size\mega) != size) {
			var val = NumberFormat(size/mega, "_._")
			if(Right(val,1) == "0") val = (size\mega)
			return val & ' MB';
		}
		if(size/kilo >= 1) return (size\kilo) & ' kB';
		return size & ' B';
	}

	/**
	* Combines and converts filename extension and database platform category into a readable string.
	* @filename File name with extension.
	* @platform Platform category of the file used by the database.
	* @formal True uses the formal name, false uses the short name.
	*/
	public string function humanizeFileFormat(string filename="", string platform="", boolean formal=false) {
		var extension = ListLast(arguments.filename,'.')
		var left = ""
		var right = ""
		if(ListLen(arguments.filename,'.') > 1) {
			right = ReplaceNocase(getPlatformName(arguments.platform),"Apps. ","")
			if(arguments.formal) left = getExtensionFormalName(extension);
			else left = getExtensionShortName(extension);
			if(!Len(left)) left = UCase(extension);
			if(left == arguments.platform) left = UCase(extension);
		}
		var info = left;
		if(left == "ANS" && right == "ANSI") return "ANSI";
		if(left == "HTM" && right == "HTML") return "HTML";
		if(Len(Trim(right)) gte 1 && !arguments.formal && Trim(left) != Trim(right)) info = left & " - " & right;
		if(!Len(Trim(info))) {
			if(arguments.platform == "video") return "&lt;video/>";
			return "Text";
		}
		if(right == "text for amiga") return "Amiga Text";
		if(right == "text or ascii") return "Text";
		return info;
	}

	/**
	 * Humanizes the platform.
	 */
	public string function humanizePlatform(required string platform) {
		var name = arguments.platform
		try {
			name = get(myapp)["menufileplatform#arguments.platform#"].name;
		}
		catch(any err) {}
		return xmlFormat(Capitalize(name));
	}

	/**
	 * Humanizes the section.
	 */
	public string function humanizeSection(required string section) {
		var name = arguments.section
		try {
			name = get(myapp)["menufilesection#arguments.section#"].name;
		}
		catch(any err) {}
		return xmlFormat(Capitalize(name));
	}

	/**
	 * Formats text to be JSON friendly by double-escaping backslashes.
	 */
	public string function jsonFormat(string text="") {
		var jss = JSStringFormat(arguments.text)
		return jss.replace("\", "\\", "all")
	}

	/**
	* Returns a null UUID.
	*/
	public string function uuidNulled() {
		return "00000000-0000-0000-0000-000000000000"
	}

	/**
	* Creates a CFML date time from a Windows WMCI serialised date.
	* @wmciDate Date used by Windows WMCI.
	*/
	public date function wmciDateToCFML(required string wmciDate="") {
		var wmci = arguments.wmciDate
		var pair = 2
		if(Len(wmci) lte 14) return Now()
		if(!IsNumeric(Left(wmci,14))) return Now()
		return CreateDateTime(Left(wmci,4),Mid(wmci,5,pair),Mid(wmci,7,pair),Mid(wmci,9,pair),Mid(wmci,11,pair),Mid(wmci,13,pair))
	}
	/**
	* This is a hacked fix to repair a CFWheels error where passing filename=fileWith&sign through LinkTo(params) adds an tailing = symbol.
	*/
	public string function filedownloadTo(string text="", string title="", string key="", string type="", string format="", string params="") {
		var html = ""
		var par = arguments.params
		var tit = arguments.title
		if(arguments.type is "detail") {
			if(Len(arguments.title)) tit = "#arguments.title# (Ctrl+Enter)";
			else tit = "(Ctrl+Enter)";
			if(arguments.params contains "&") par = ReplaceNocase(par,'&', '+', 'all');
			if(arguments.format is "urlfor") html = "#URLFor(text=arguments.text,title=tit,route="d",key=arguments.key,id='clickThisButton',params=par)#";
			else html = '<a href="#URLFor(route="d",key=arguments.key,id='clickThisButton',params=par)#" title="#tit#">#arguments.text#</a>';
		} else {
			if(arguments.params contains "&") par = ReplaceNocase(par,'&', '+', 'all')
			if(arguments.format is "urlfor") html = "#URLFor(text=arguments.text,title="Download",route="d",key=arguments.key,params=par)#";
			else html = '<a href="#URLFor(route="d",key=arguments.key,params=par)#" title="Download">#arguments.text#</a>';
		}
		if(arguments.params contains "&") html = ReplaceNocase(html,'=" title=','" title=','first');
		return html;
	}
	/**
	 * Colourise file labels to notify administrators on its state
	 */
	public string function fileState(required query record) {
		if(!len(arguments.record.deletedat)) return ""
		if(len(arguments.record.deletedby)) return "danger" // disabled
		if(!len(arguments.record.updatedby)) return "info"; // new untouched upload
		return "warning"; // new but modified upload
	}

	/**
	* Filters out irrelevant http status codes and only displays those referencing errors.
	* @statusCode HTTP status code.
	* @triggerCode HTTP status code.
	*/
	public string function httpFindStatus(required string statusCode="", required string triggerCode="") {
		var numericCode = Left(arguments.statusCode,1)
		if(!IsNumeric(numericCode)) return "";
		if(!ListFind(arguments.triggerCode,numericCode)) return "";
		return arguments.statusCode;
	}

	/**
	* Returns a HTML list item LI with padding formatting.
	* @rowCount Total count of list items.
	* @greaterThanOne False pads rows that LTE 0 or True pads rows GTE 2.
	*/
	public string function dynamicLI(required numeric rowCount="0", required boolean greaterThanOne=false) {
		var tag = "li"
		if(!arguments.greaterThanOne && !arguments.rowCount) return tag & ' class="padded-top"'
		if((arguments.greaterThanOne && arguments.rowCount >= 2)) return tag & ' class="padded-top"'
		return tag;
	}

	/**
	* Returns Keyboard & gesture tips
	*/
	public string function touchandkeyboardIcons(string class='brand-success') {
		var href = urlFor(controller="help",action="keyboard")
		var elms = '<span title="Pagination keys and gestures are in use" class="mobile-hide">'
		elms &= '<a href="#href#" aria-label="Keyboard and gestures help">'
		elms &= '<i class="touch-key-tablet fal fa-tablet-alt fa-fw #arguments.class#"></i>'
		elms &= '<i class="touch-key-keyboard fal fa-keyboard fa-fw #arguments.class#"></i></a></span>'
		return "#elms#";
	}

	/*
	 * is[String] functions
	 */

	/**
	* Internal function used by is[fileType] functions
	* @filename File name with extension.
	* @extensions A list of file extensions used to determine file type, i.e. 'jpg,png,gif'.
	*/
	private boolean function _isFileType(required string filename="", required string extensions="") {
		if(ListFindNoCase(arguments.extensions,fileExtension(arguments.filename))) return true
		return false;
	}

	/**
	* Determines if a file is ANSI art.
	* @filename File name with extension.
	*/
	public boolean function isANSI(required string filename="") {
		return _isFileType(arguments.filename, "ans");
	}

	/**
	* Determines if a file is audio.
	* @filename File name with extension.
	*/
	public boolean function isAudio(required string filename="") {
		var ext = get(myapp).acceptedAudio
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is an archive.
	* @filename File name with extension.
	*/
	public boolean function isArchive(required string filename="") {
		var ext = get(myapp).acceptedArchives
		// common, multiple-part archive extensions
		for (i=1; i <= 9; i++) {
			ext = listAppend(ext, "z0#i#")
			ext = listAppend(ext, "7z.00#i#")
		}
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is a chip tune audio.
	* @filename File name with extension.
	*/
	public boolean function isChiptune(required string filename="") {
		var ext = get(myapp).acceptedChiptunes
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is a document.
	* @filename File name with extension.
	*/
	public boolean function isDocument(required string filename="") {
		var ext = get(myapp).acceptedDocuments
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is on the no-preview generation list.
	* @filename File name with extension.
	*/
	public boolean function isNoPreview(required string filename="") {
		var ext = get(myapp).acceptedNoPreviews
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is a program.
	* @filename File name with extension.
	*/
	public boolean function isProgram(required string filename="") {
		var ext = get(myapp).acceptedPrograms
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is an image or graphic.
	* @filename File name with extension.
	*/
	public boolean function isGraphic(required string filename="") {
		var ext = get(myapp).acceptedGraphics
		var result = _isFileType(arguments.filename, ext)
		return result;
	}

	/**
	* Determines if a file is a video.
	* @filename File name with extension.
	*/
	public boolean function isVideo(required string filename="") {
		var ext = get(myapp).acceptedVideos
		var result = _isFileType(arguments.filename, ext)
		return result;
	}
</cfscript>