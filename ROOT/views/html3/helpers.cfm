<!---
	HTML 3 helpers.
	path: views/html3/helpers.cfm

	Functions available for all views within html3/

@CFLintIgnore
--->
<cfscript>
{
	variables.myapp = "myapp"
	variables.gif = {
		"back": "/images/html3/back.gif",
		"blank": "/images/html3/blank.gif",
		"dir": "/images/html3/dir.gif"
	}
	/*
	 * Converts a numeric value into a readable file size measurement
	 * @fileSize Byte value to format
	 */
	string function html3FileSize(numeric filesize=0) {
		var kilo = 1024
		var mega = kilo^2
		var giga = kilo^3
		var tera = kilo^4
		// 3/1 returns a decimal, 3\1 returns an integer
		if(filesize/tera >= 1 && (filesize\tera) != filesize) return NumberFormat(filesize/tera, ".9" ) & 'T';
		if(filesize/giga >= 1 && (filesize\giga) != filesize) return NumberFormat(filesize/giga, ".9" ) & 'G';
		if(filesize/mega >= 1 && (filesize\mega) != filesize) return NumberFormat(filesize/mega, ".9" ) & 'M';
		if(filesize/kilo >= 1) return (filesize\kilo) & 'K';
		return Replace(filesize,'.0','')
	}

	string function sortQuery(string name = '') {
		switch(cgi.script_name) {
			case '/index.cfm':
				var uri = cgi.query_string
				uri = replaceNoCase(uri, '&C=N;O=D', '', 'all')
				uri = replaceNoCase(uri, '&C=N;O=A', '', 'all')
				return '#uri#&#arguments.name#'
			default:
				return '?#arguments.name#'

		}
	}

	/*
	 * Generates an icon determined by the file's extension
	 */
	function displayIcon(string filename) {
		var ext = ListLast(arguments.filename,".")
		if(ListFindNoCase(get(myapp).acceptedArchives,ext)) return "compressed";
		if(ListFindNoCase(get(myapp).acceptedAudio,ext)) return "sound2";
		if(ListFindNoCase(get(myapp).acceptedChiptunes,ext)) return "sound2";
		if(ListFindNoCase(get(myapp).acceptedDocuments,ext)) return "text";
		if(ListFindNoCase(get(myapp).acceptedGraphics,ext)) return "image2";
		if(ListFindNoCase(get(myapp).acceptedNoPreviews,ext)) return "text";
		if(ListFindNoCase(get(myapp).acceptedPrograms,ext)) return "comp2";
		if(ListFindNoCase(get(myapp).acceptedVideos,ext)) return "movie";
		return "unknown";
	}

	/*
	 * Generates a link determined by the file extension
	 */
	function linkIcon(string uuid, string filename, string key) {
		var img = '<img src="/images/html3/#displayIcon(arguments.fileName)#.gif" alt="[FILE]">'
		if(wgetmode()) return "&nbsp; "; // return whitespace
		if(isDocument(arguments.filename)) return '<a href="#URLFor(controller='file',action='raw',key=arguments.key)#">#img#</a>';
		if(ListFindNoCase("htm,html,gif,png,jpeg",fileExtension(arguments.filename))) return '<a href="#URLFor(controller='file',action='view',key=arguments.key)#">#img#</a>';
		return img;
	}

	/*
	 * Determine client browser mode
	 */
	function wgetmode() {
		param name="params.wget" default="false";
		param name="params.defacto2offlinecompiler" default="false";
		try{
			if (params.wget) return true;
			if (params.defacto2offlinecompiler) return true;
		}
		catch(any err) {}
		return false;
	}

	/*
	 * Generate directory crumbs
	 */
	function pathDir() {
		param name="params";
		param name="params.action" default="";
		param name="params.key" default="";
		var pathDir = "/html3/"
		if(len(params.action) && params.action != "index") pathDir &= "#params.action#/"
		if(len(params.key)) pathDir &= "#params.key#/"
		return pathDir;
	}
}
</cfscript>