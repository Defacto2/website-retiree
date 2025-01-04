<!---
    Global functions available to the application.
	path: global/functions.cfm

	1) controllers/Controller.cfc contain the functions intended for use with controllers
	2) views/helpers.cfm for functions that work with views

@CFLintIgnore EXCESSIVE_FUNCTIONS,EXCESSIVE_FUNCTION_LENGTH,LOCAL_LITERAL_VALUE_USED_TOO_OFTEN,UNUSED_LOCAL_VARIABLE,AVOID_USING_ABORT,AVOID_USING_WRITEDUMP,FUNCTION_TYPE_ANY,UNUSED_METHOD_ARGUMENT
--->
<cfscript>
variables.myapp = "myapp"
variables.tmpDir = "/tmp/#application.applicationName#" // myapp.tmpDirectory cannot be referenced here

/**
* Get the hashed value of a file
*
* @filename Path to file
* @algorithm choice either short `mda5` or long `sha`
*/
public string function fileHashed(string filename = "", string algorithm = "md5") {
	var bin = function(string algorithm="") {
		switch(arguments.algorithm) {
		case "md5":
			return get(myapp).appsHash.file;
		case "sha":
			return get(myapp).appsSHA.file;
		default:
			return ""
		}
	}
	var path = bin(arguments.algorithm)
	if(path == "") return render404();
	execute name = "#path#"
		arguments = '"#arguments.filename#"'
		timeout = 5
		variable = "local.result";
	var hash = LCase(Trim(ListGetAt(Trim(result),1,' ')))
	var md5Len = 32
	var shaLen = 96
	if(Len(hash) == md5Len) return hash;
	if(Len(hash) == shaLen) return hash;
	return Trim(LCase(hash));
}

/**
 * Returns a file name with its file extension trimmed
 *
 * @filename File name
 */
public string function filenameLessExtension(string filename="") {
	var extLen = Len(ListLast(arguments.filename,'.'))
	var baseLen = Len(arguments.filename) - extLen - 1
	if(baseLen gte 1) return Left(arguments.filename,baseLen);
	return arguments.filename;
}

/**
 * Returns the SAUCE metadata attached to the EOF
 * http://www.acid.org/info/sauce/sauce.htm
 *
 * @DataType SAUCE DataType
 * @FileType SAUCE FileType
 */
public struct function fileSauceTInfo(required numeric dataType, required numeric fileType) {
	var result = { "tInfo1":'', "tInfo2":'', "tInfo3":'', "tInfo4":'' }
	var tInfo1 = ['Character width','Pixel width (640)','Pixel width','Sample rate']
	var tInfo2 = ['Number of lines','Character screen height','Pixel height (350)','Pixel height']
	var tInfo3 = ['Number of colors (16)','Pixel depth']
	var dataTypeTrigger = '1,2,4,6'
	// check dataType against dataTypeTrigger else return empty values
	if(!ListFind(dataTypeTrigger,arguments.dataType)) return result;
	// drill down for dataType 1 'Character'
	if(arguments.dataType == 1) {
		if(ListFind('0,1,4,5,8',arguments.fileType)) {
			// Character width, Number of lines
			result.tInfo1 = tInfo1[1]
			result.tInfo2 = tInfo2[1]
			return result;
		}
		if(arguments.fileType == 2) {
			// Character width,	Character screen height
			result.tInfo1 = tInfo1[1]
			result.tInfo2 = tInfo2[2]
			return result;
		}
		if(arguments.fileType == 3) {
			// Pixel width (640),	Pixel height (350),	Number of colors (16)
			result.tInfo1 = tInfo1[2]
			result.tInfo2 = tInfo2[3]
			result.tInfo3 = tInfo3[1]
			return result;
		}
		return result;
	}
	// drill down for dataType 2 'Bitmap'
	if(arguments.dataType == 2) {
		// Pixel width, Pixel height,	Pixel depth
		result.tInfo1 = tInfo1[3]
		result.tInfo2 = tInfo2[4]
		result.tInfo3 = tInfo3[2]
		return result;
	}
	// drill down for dataType 4 'Audio'
	if(arguments.dataType == 4) {
		if(ListFind('16,17,18,19',arguments.fileType)) {
			// Sample rate
			result.tInfo1 = tInfo1[4]
		}
		return result;
	}
	// crill-down for dataType 6 'XBin'
	if(arguments.dataType == 6) {
		// Character width, Number of lines
		result.tInfo1 = tInfo1[1]
		result.tInfo2 = tInfo2[1]
		return result;
	}
	return result;
}

/**
* Uses Graphics Magick to convert any image into a standard PNG format.
*
* @source Full path to the source file.
* @overwrite Overwrite source image format auto-detection (ie GIF87 instead of GIF).
* @filename Filename of the source file (only needed if PDF sources are used).
*/
public string function fileConvertImage2Png(required string source, string overwrite="", string filename="") {
	var appname = "fileConvertImage2Png() GraphicsMagick"
	var sourcePage = ""
	var sourceFile = arguments.source
	var temporary = "#tmpDir##ListLast(arguments.source,'/')#"
	// an insert to process a page number, currently used for PDF files that defaults to the last page rather than the first
	if(fileextension(arguments.filename) == "pdf") sourcePage = "[0]";
	// windows icons often contain multiple resolutions, to view in Linux: identify file.ico
	if(fileextension(arguments.filename) == "ico") {
		sourcePage = ".ico[0]";
		FileCopy(sourceFile, '#sourceFile#.ico');
	}
	if(fileextension(arguments.filename) == "iff") {
		// Netpbm conversions (for legacy)
		// ilbmtoppm Image.iff | pnmtopng - > Image.png
		appname = "fileConvertImage2Png() Netpbm"
		try {
		execute
			name="/usr/local/bin/iff-to-png.sh"
			arguments="#sourceFile# #temporary#"
			timeout=get(myapp).timeoutImage;
		}
		catch(any err) {
			return "#appname# convert error: #cfcatch.message#. #cfcatch.detail#";
		}
	}
	if(fileextension(arguments.filename) != "iff") {
		// GraphicsMagick (recommended)
		// apply source overwrite using a string value, example: `GIF87:myimage.gif`
		if(len(arguments.overwrite)) sourceFile = "#arguments.overwrite#:#arguments.source#"
		try {
		execute
		name=get(myapp).appsGm.file
		arguments="convert '#sourceFile##sourcePage#' -flatten '#temporary#.png'"
		timeout=get(myapp).timeoutImage
		variable="executeDump" {
			// this has been disabled, as it seems to trigger BEFORE execute is complete
		};
		}
		catch(any err) {
			return "#appname# convert error: #cfcatch.message#. #cfcatch.detail#";
		}
	}
	// feedback
	if(!FileExists("#temporary#.png")) return "#appname# error: has failed to generate '#temporary#.png'.";
	return "#appname# has generated '#temporary#.png'.";
}

/**
* Optimise a PNG image to use lossy and lossless compression and generate a secondary WebP image.
*
* @source Full path to the source file WITHOUT the file extension.
*/
public string function fileConvertImage2WebP(required string source) {
	var appname = "fileConvertImage2WebP()"
	var dest = "#filenameLessExtension(arguments.source)#.webp"
	// optimise image, lossy compressor
	try {
		execute
		name=get(myapp).appsPngquant.file
		arguments='--ext=.png -f "#arguments.source#"'
		timeout=get(myapp).timeoutImage;
	}
	catch(any err) {
		return "#appname# pngquant error: #cfcatch.message#. #cfcatch.detail#";
	}
	// optimise image, lossless compressor
	try {
		execute
		name=get(myapp).appsOptiPng.file
		arguments='"#arguments.source#"'
		timeout=get(myapp).timeoutImage;
	}
	catch(any err) {
		return "#appname# optipng error: #cfcatch.message#. #cfcatch.detail#";
	}
	// set permission bits otherwise they revert to 640 (rw,r,-)
	try { fileSetAccessMode("#arguments.source#", 664) } catch(any err) {}
	// webp generator
	try {
		execute
		name=get(myapp).appsWebp.file
		arguments='cwebp -near_lossless 70 "#arguments.source#" -o "#dest#"'
		timeout=get(myapp).timeoutImage;
	}
	catch(any err) {
		return "#appname# convert error: #cfcatch.message#. #cfcatch.detail#";
	}
	// feedback
	if(!FileExists("#dest#")) return "#appname# error: has failed to generate '#dest#'.";
	// access bits
	fileSetAccessMode("#dest#", 664);
	return "#appname# has generated '#dest#'.";
}

/**
* Uses GraphicsMagick to convert, resize and square crop an image for use as a thumbnail.
*
* @source Full path to the source file.
* @destination Full path to the destination.
* @length Width and height of squared image.
* @keepaspectratio Keep original image aspect ratio if it is too wide or tall for a square crop.
*/
public string function fileConvertImageSquared(required string source, string destination="", numeric length=400, boolean keepaspectratio=false) {
	var appname = "fileConvertImageSquared() GraphicsMagick"
	var image = {
		"identifyOriginal":"",
		"geometry":"",
		"length":0,
		"width":0,
		"args":"",
	}
	var len = arguments.length
	var src = arguments.source
	var des = arguments.destination
	var ratio = arguments.keepaspectratio
	// make sure source file exists
	if(!FileExists(src)) return "#appname# 1 error: source file is missing '#src#'";
	// create a destination if none exists
	var createDest = function() {
		if(!Len(des) && ListLen(src,'.')) return Reverse(ListRest(Reverse(src),'.')) & "_#len#x#len#" & '.' & Reverse(ListFirst(Reverse(src),'.'));
		if(!Len(des)) return src & "_#len#x#len#.png";
		return des
	}
	des = createDest()
	// extract image information
	try {
		execute
		name=get(myapp).appsGm.file
		arguments='identify -verbose "#src#"'
		timeout=get(myapp).timeoutImage
		variable="image.identifyOriginal";
	}
	catch(any err) {
		return "#appname# verbose 2 error: #cfcatch.message#. #cfcatch.detail#";
	}
	// serialise image information
	//dump(label="Image information",var=image.identifyOriginal)
	image.geometry = "#REMatchNoCase('geometry:\W([\d]+x[\d]+)',image.identifyOriginal)#"
	if(IsDefined("image.geometry") && IsArray(image.geometry)) {
		image.geometry = ListGetAt(image.geometry[1],2,' ')
		image.width = ListGetAt(image.geometry,1,'x')
		image.length = ListGetAt(image.geometry,2,'x')
	}
	// create graphicsmagick arguments
	var createArgs = function() {
		if(!ratio && (image.length/image.width) >= 1.5) return "-thumbnail #len#x -crop #len#x#len#+0+0";
		if(!ratio && (image.width/image.length) >= 3) return "-thumbnail x#len# -gravity center -crop #len#x#len#+0+0";
		return "-thumbnail #len#x#len# -gravity center";
	}
	image.args = createArgs()
	try {
		execute
		name=get(myapp).appsGm.file
		arguments='convert -size #image.width#x#image.length# "#src#" #image.args# +antialias +profile "*" -background "##999" -extent #len#x#len# "#des#"'
		timeout=get(myapp).timeoutImage;
	}
	catch(any err) {
		return "#appname# convert -thumbnail 3 error: #cfcatch.message#. #cfcatch.detail#";
	}
	// optimise image
	try {
		execute
		name=get(myapp).appsPngquant.file
		arguments='--ext=.png -f "#des#"'
		timeout=get(myapp).timeoutImage;
	}
	catch(any err) {
		return "#appname# optimise 4 error: #cfcatch.message#. #cfcatch.detail#";
	}
	// change permissions
	try{
		fileSetAccessMode("#des#", 664)
	}
	catch(any err) {}
	if(!FileExists("#des#")) "#appname# 5 error: failed to generate '#src#'";
	return "GraphicsMagick has generated a #len#x#len# thumbnail";
}

/**
* Extract the content of a compressed or storage archive file.
*
* @source Full path to the source file.
* @filenameExtension Filename extension.
*/
public struct function fileContentOfArchive(required string source, required string filenameExtension="") {
	var toa = get(myapp).timeoutArchive
	var ranz = RandRange(100000,999999)
	var file = {
		"archive" = arguments.source,
		"contentArray" = '',
		"file_zip_content" = '',
		"randomiser" = ranz,
		"tempFolder" = "#tmpDir##ranz#"
	}
	var args = {
		"noun":"",
		"archiver":"",
		"switches":"",
	}
	// RegExpression file name character filter for files contained within an Archive
	var reCleanName = "[^[:print:][:space:][:punct:]]"
	switch(arguments.fileNameExtension){
		case "zip":
			args.noun = "ZIP"
			args.archiver = get(myapp).appsZipInfo.file
			args.switches = "-1"
			execute
				name="#args.archiver#"
				arguments="#args.switches# '#file.archive#'"
				timeout="#toa#"
				variable="file.file_zip_content";
		break;
		case "tar.gz":
		case "tar":
			args.noun = "TAR"
			args.archiver = get(myapp).appsTar.file
			args.switches = "-t -f"
			if(arguments.fileNameExtension eq "tar.gz") {
				// gzip support
				args.switches = "-z " & args.switches;
			}
			try {
			execute
				name="#args.archiver#"
				arguments="#args.switches# '#file.archive#'"
				timeout="#toa#"
				variable="file.file_zip_content";
				} catch(any err) {
					dump(err.message);
					abort;
				}

		break;
		case "rar":
			args.noun = "RAR"
			args.archiver = get(myapp).appsUnrar.file
			args.switches = "vb"
			var fcopy = "#file.tempFolder#.rar"
			if(!FileExists(fcopy)) {
				file.archive = Replace(file.archive,'\','/','all')
				fileCopy(file.archive, fcopy);
				fileSetAccessMode(fcopy, 664);
				file.archive = fcopy
			}
			execute
				name="#args.archiver#"
				arguments="#args.switches# '#fcopy#'"
				timeout="#toa#"
				variable="file.file_zip_content";
			if(FileExists(fcopy)) fileDelete(fcopy);
		break;
		case "7z":
		case "arj":
		case "cab":
		case "lha":
		case "lzh":
		case "gz":
			args.noun = "7-Zip"
			args.archiver = get(myapp).apps7z.file
			args.switches = "l -slt"
			execute
				name="#args.archiver#"
				arguments="#args.switches# '#file.archive#'"
				timeout="#get(myapp).timeoutArchive#"
				variable="archivecontent";
			var firstRow = true
			var cnt = 0
			for(var row in ReMatchNocase('\nPath = [^"\r\n]*',ReReplaceNocase(archivecontent,'#reCleanName#','','all'))) {
				if(firstRow) {
					firstRow = false;
					continue;
				}
				cnt++
				if(cnt > 999) {
					break;
				}
				file.file_zip_content  = file.file_zip_content & ReplaceNoCase(row,'Path = ','') & Chr(13) & Chr(10)
			}
		break;
		case "arc":
			args.noun = "ARC"
			args.archiver = get(myapp).appsArc.file
			args.switches = "l"
			<!--- arc l DOC.ARC
			Name          Length    Date
			============  ========  =========
			DOC.UNP           1366  26 Apr 88
					====  ========
			Total      1      1366
				--->
			execute
				name="#args.archiver#"
				arguments="#args.switches# '#file.archive#'"
				timeout="#get(myapp).timeoutArchive#"
				variable="file.file_zip_content";
			file.contentArray = listToArray(REReplace(Trim(file.file_zip_content),'\n',':','all'),':',true)
			if(ArrayLen(file.contentArray) lte 4) {
				file.file_zip_content = "ARC archive is empty";
				return file;
			}
			// drop first 2 and last 2 lines
			file.contentArray = arrayMid(file.contentArray,3,ArrayLen(file.contentArray)-4)
			var index = 0
			for (var row in file.contentArray) {
				index++
				if(index > 999) {
					break;
				}
				// parse array list of files to only show filenames
				file.contentArray[index] = ListFirst(row,' ')
			}
			file.file_zip_content = ArrayToList(file.contentArray,':')
			file.file_zip_content = REReplace(file.file_zip_content,':',Chr(13) & Chr(10),'all')
		break;
		default:
			return file;
	}
	file.file_zip_content = ReReplaceNocase(file.file_zip_content,'#reCleanName#','','all')
	try{
		// required by virtual image but not critical so ignore any failures
		fileSetAccessMode(file.archive, 664);
	} catch(e) {}
	return file;
}

private boolean function backup(required string name) {
	var path = arguments.name
	if(FileExists(path)) {
		var dest = "#path#.#DateFormat(Now(),'ddmmyy')##TimeFormat(Now(),'hhmmss')#.archived";
		fileMove("#path#", dest);
		fileSetAccessMode(dest, 664);
		return true
	}
	return false
}

/**
* Backs up and then moves an image from the image/uuid/ subdirectories to the arguments destination.
*
* @destination Full path to the destination.
* @uuid UUID of the file record.
*/
public string function fileMoveImage(required string destination, required string uuid) {
	var filename = "#arguments.uuid#.png";
	var dest = "#arguments.destination#/#filename#";
	var source = "#tmpDir##filename#"
	if(!FileExists(source)) return "fileMoveImage() error: no source found '#source#'";
	// rename original image as a backup
	if(fileHashandSize(dest).shahash != fileHashandSize(source).shahash) backup(dest);
	// copy image to the destination'
	try {
		FileCopy(source, dest);
	} catch(any err) {
		return "fileMoveImage() host file system critical error: #err.message#";
	}
	FileSetAccessMode(dest, 664);
	return "Permanently stored temporary image as #filename#";
}

/**
* Uses AnsiLove/C to convert a plain text ASCII or ANSI file to a standard PNG image.
*
* @source Full path to the source file.
* @filename Used the extract the file extension.
* @font AnsiLove/C font to render text in.
*/
public string function fileConvertText2Png(required string source, required string filename, string font="") {
	var appname = "AnsiLove/C"
	var fileExt = function(required string filename) {
		var last = listLast(arguments.filename, ".")
		if(len(last)) return "." & lCase(last)
	}
	var file = {
		"src":"",
		"dest":"",
		"output":"",
		"error":"",
	}
	file.src = "#arguments.source#.txt"
	file.dest = filenameLessExtension(file.src)
	if(!FileExists(arguments.source)) return "#appname# error: file does not exist '#arguments.source#'";
	fileCopy(arguments.source, file.src);
	fileSetAccessMode(file.src, 664);
	// convert text file CFLF to LF
	try {
		execute
			name=get(myapp).appsFromDOS.file
			arguments="-d #file.src#"
			timeout=5
			variable="file.output"
			errorvariable="file.error";
	}
	catch(any err) {}
	// detect any PCBoard encoding and rename file.src to use the .PCB extension
	try {
		var filehandle = fileOpen(file.src, "read")
		if(left(fileReadLine(filehandle), 3) == "@X0") {
			var dest = file.src & ".pcb";
			fileMove(file.src, dest);
			fileSetAccessMode(dest, 664);
			file.src = "#file.src#.pcb"
		}
	}
	catch(any err) {}
	// set argument string and use it to run ansilove/c
	// -o output filename
	// -f font name
	var argumentString = '"#file.src#" -o #paths.png#'
	if(arguments.font != "") {
		argumentString &= " -f #arguments.font#"
	}
	try {
		execute
			name=get(myapp).appsAnsiLove.file
			arguments="#Trim(argumentString)#"
			timeout=get(myapp).timeoutAnsiLove
			variable="file.output"
			errorvariable="file.error";
	}
	catch(any err) {
		return "#appname# generation error: #cfcatch.message#. #cfcatch.detail#. '#argumentString#'";
	}
	fileSetAccessMode(paths.png, 664);
	if(!FileExists(paths.png)) return "#appname# error: image was not created '#paths.png#'";
	return "#appname# has generated '#paths.png#'";
}

/**
* Scans a file to see its viable usage for a preview, description or document for use on the file details page.
*
* @filename Filename to scan.
* @group_brand_for group_brand_for value used for potential filename matches.
* @group_brand_by group_brand_by value used for potential filename matches.
* @file_zip_content Target image type, either description, document or preview.
* @process Either "description", "document" or "preview"
*/
public string function fileDetermineImages(required string filename, string group_brand_for="", string group_brand_by="", string file_zip_content="", required string process) {
	var genericCases = ""
	var patternList = ""
	var selfCases = ""
	var fileMatch = []
	// replace EOL with ":" so we can handle path names that use spaces and comma characters
	var files = arguments.file_zip_content
	files = replaceNoCase(files,"#chr(13)##chr(10)#",":","all") // cr+lf = windows
	files = replaceNoCase(files,"#chr(10)#",":","all") // lf = linux
	files = replaceNoCase(files,"#chr(13)#",":","all") // cr = others
	switch(arguments.process){
		case "document":
			genericCases = Replace(get(myapp).casesDocument,".","\.","all")
			selfCases = Replace(get(myapp).casesDocument,".","","all")
		break;
		case "preview":
			genericCases = Replace(get(myapp).casesPreview,".","\.","all")
			selfCases = Replace(get(myapp).casesPreview,".","","all")
		break;
		default:
	}
	if(!Len(files) && listFind(selfcases, fileExtension(arguments.filename))) return arguments.filename;
	// determine 'description' uses a unique filename pattern search
	patternList = "#arguments.group_brand_for#:#arguments.group_brand_by#:#ReplaceNocase(arguments.group_brand_for,' ','','all')#"
	patternList &= ":#ReplaceNocase(arguments.group_brand_for,' ','_','all')#:#ReplaceNocase(arguments.group_brand_for,' ','-','all')#:file_id:readme:read_me:read.me:readme!"
	patternList = ListRemoveDuplicates(patternList,":")
	// this corrects a bug whereby archive subdirectories that matched the archive filename would throw invalid matches.
	if(listFirst(files, "/") neq Left(arguments.filename,(Len(arguments.filename)-4))) {
		patternList = listAppend(patternList, Left(arguments.filename,(Len(arguments.filename)-4)), ":")
	}
	loop list="#patternList#" index="local.pattern" delimiters=":" {
		loop list="#genericCases#" index="local.genericCase" delimiters="," {
			fileMatch = REMatchNoCase("#pattern##genericCase#",files);
			if(ArrayLen(fileMatch)) break;
		}
		if(ArrayLen(fileMatch)) break;
	}
	// generic pattern search for file extension if no file has yet been found
	loop list="#genericCases#" index="local.ext" delimiters="," {
		if(ArrayLen(fileMatch)) break;
		fileMatch = REMatchNoCase("#ext#",files);
	}
	// Update 15/05/23, fallback to handle archives with a single file.
	if(!ArrayLen(fileMatch)) {
		var fallback = ListToArray(files,":",false)
		if(Len(fallback) eq 1) return fallback[1];
		return "";
	}
	// fallback hack for when regex matches but files to return the full filename
	if(left(fileMatch[1],1) == ".") {
		var hack = ListContainsNocase(files,"#fileMatch[1]#",":")
		if(hack && len(ListGetAt(files,hack,":"))) {
			fileMatch[1] = ListGetAt(files,hack,":");
		}
	}
	return fileMatch[1];
}

/**
* Extracts and processes images sourced from UUID archives.
*
* @filename Name of file to extract from archive.
* @archivename Filename of source archive.
* @process Either description, document or preview.
* @uuid UUID of the file record.
*/
public string function imageProcess(required string filename, required string archivename, required string process, required string uuid) {
	var debug = false
	var appname = "imageProcess()"
	var random = randomDir()
	var image = {
		"dest":"#get(myapp).fulldirPreview#/#arguments.uuid#",
		"png":"#get(myapp).fulldirPreview#/#arguments.uuid#.png",
		"random":"#random#/#arguments.uuid#",
		"src":"#get(myapp).fulldirfileuuid#/#arguments.uuid#",
	}
	switch(arguments.process) {
		case "preview_image":
		case "preview-text":
			break;
		default:
			throw "#appname# error: the provided arguments.proces must be either 'preview_image' or 'preview-text'. You provided '#arguments.process#'.";
	}
	var result = fileExtractFromArchive(
		filename = "#arguments.filename#",
		source = image.src,
		sourcetype = fileExtension(arguments.archivename),
		destination = random,
		uuid = arguments.uuid);
	if(result == "Nothing to extract or copy.") {
		throw "#appname# error: fileExtractFromArchive() did not extract any files.
		Arguments:
		filename = #arguments.filename#,
		source = #image.src#,
		sourcetype = #fileExtension(arguments.archivename)#,
		destination = #random#,
		uuid = #arguments.uuid#"
	}
	if(arguments.process == "preview_image") {
		var result = fileConvertImage2Png(source="#image.random#");
		if(result does not contain "error") {
			backup("#image.png#")
			fileCopy("#image.random#", "#image.png#");
			fileSetAccessMode("#image.png#", 664);
		}
	} else {
		// used when extracting textfiles from zip and other archives
		backup("#image.png#")
		var result = fileConvertText2Png(source="#image.random#",filename=arguments.filename);
		if(debug) dump(result);
	}
	if(!FileExists(image.png)) return "#appname# working image error: not found #image.png#";
	fileConvertImage2WebP(image.png)
	// file path to the image.png is the expected return for thumbnail generation
	return image.png
}

/**
* Returns the byte size and the MD5 hash string of a file
*
* @source 	Full path to the source file
* @getSize	Also get file size (false improves performance)
*/
public struct function fileHashandSize(required string source, boolean getSize=true) {
	var hash = {
		"md5hash":"",
		"md5hashlength":0,
		"size":"",
		"shahash":"",
		"shahashlength":0,
	}
	if(!FileExists("#arguments.source#")) return hash;
	// save file size information
	if(arguments.getSize) hash.size = GetFileInfo("#arguments.source#").size;
	// obtain md5 hash of local.
	try {
		execute
			name="#get(myapp).appsHash.file#"
			arguments='"#arguments.source#"'
			timeout="15"
			variable="hash.md5hash";
	}
	catch(any err) {}
	// check hash to make sure it is valid
	var md5Len = 32
	if(Len(LCase(Trim(ListFirst(Trim(hash.md5hash),' ')))) == md5Len) hash.md5hash = LCase(Trim(ListFirst(Trim(hash.md5hash),' ')));
	hash.md5hashlength = Len(hash.md5hash)
	// obtain the SHA hash of local file
	try {
		execute
			name="#get(myapp).appsSHA.file#"
			arguments='"#arguments.source#"'
			timeout="15"
			variable="hash.shahash";
	}
	catch(any err) {}
	var shaLen = 96
	if(Len(LCase(Trim(ListFirst(Trim(hash.shahash),' ')))) == shaLen) hash.shahash = LCase(Trim(ListFirst(Trim(hash.shahash),' ')));
	hash.shahashlength = Len(hash.shahash)
	return hash;
}

/**
* Returns the location and name of a usable temporary directory
*/
public string function randomDir() {
	return "#tmpDir##RandRange(100000,999999)#"
}

/**
* Extracts a file from a compressed or stored archive and copies the extracted file to a directory of your choice.
*
* @filename File to extract from archive.
* @source Full path to the source archive.
* @sourcetype Source file extension.
* @destination Full path to the destination.
* @uuid UUID used as a temporary directory.
* @selfcases List of files to duplicate which are not supported archives.
*/
public string function fileExtractFromArchive(
	required string filename,
	required string source,
	string sourcetype="",
	required string destination,
	string uuid="00000000-0000-0000-0000-000000000000",
	string selfcases="") {
		var appname = "fileExtractFromArchive()"
		var archive = {
			"file":arguments.filename,
			"src":ReplaceNoCase(arguments.source,'\','/','all'),
			"dest":ReplaceNoCase(arguments.destination,'\','/','all'),
			"error":false,
			"random":RandRange(100000,999999),
			"temporary":"",
		}
		var zip = function(required struct archive) {
			var debug = false
			switch(debug) {
			case true:
				dump('#get(myapp).appsZipUn.file# -Co "#archive.src#" "#archive.file#" -d "#archive.temporary#"'); // debug arguments
				savecontent variable="local.saveStdout" {
					execute
						name="#get(myapp).appsZipUn.file#"
						arguments='-Co "#archive.src#" "#archive.file#" -d "#archive.temporary#"'
						timeout="#get(myapp).timeoutArchive#"
						variable="local.exeStdout";
				}
				break;
				default:
				try {
					savecontent variable="local.saveStdout" {
						execute
							name="#get(myapp).appsZipUn.file#"
							arguments='-Co "#archive.src#" "#archive.file#" -d "#archive.temporary#"'
							timeout="#get(myapp).timeoutArchive#"
							variable="local.exeStdout";
					}
				}
				catch(type variable) { archive.error = true; }
			}
		}
		var rar = function(required struct archive) {
			// make symbolic link so the source file has a name with the .rar extension
			if(!FileExists("#archive.temporary#.rar")) {
				fileCopy("#archive.src#", "#archive.temporary#.rar");
				fileSetAccessMode("#archive.temporary#.rar", 664);
			}
			archive.file = LCase(archive.file)
			try {
				savecontent variable="local.saveStdout" {
					execute
						name="#get(myapp).appsUnrar.file#"
						arguments='x -cl -y -n "#archive.temporary#.rar" "#archive.file#" "#archive.temporary#"'
						timeout="#get(myapp).timeoutArchive#"
						variable="local.exeStdout";
				}
			}
			catch(type variable) { archive.error = true; }
			// delete symbolic link
			if(FileExists(ExpandPath("#archive.temporary#.rar"))) fileDelete(ExpandPath("#archive.temporary#.rar"));
		}
		var gzip = function(required struct archive) {
			fileCopy("#archive.src#", "#archive.temporary#.gz");
			fileSetAccessMode("#archive.temporary#.gz", 664);
			try {
				savecontent variable="local.saveStdout" {
					execute
						name="#get(myapp).apps7z.file#"
						arguments='x #archive.temporary#.gz -o#archive.temporary#'
						timeout="#get(myapp).timeoutArchive#"
						variable="local.exeStdout";
				}
			}
			catch(type variable) { archive.error = true; }
			if(FileExists("#archive.temporary#/#application.applicationName##archive.random#")) {
				fileMove("#archive.temporary#/#application.applicationName##archive.random#", "#archive.temporary#.tar");
				fileSetAccessMode("#archive.temporary#.tar", 664);
			}
			else if(FileExists("#archive.temporary#/#Reverse(ListRest(Reverse(params.filename),'.'))#")) {
				fileMove("#archive.temporary#/#Reverse(ListRest(Reverse(params.filename),'.'))#", "#archive.temporary#.tar");
				fileSetAccessMode("#archive.temporary#.tar", 664);
			}
			try {
				execute
					name="#get(myapp).apps7z.file#"
					arguments='x #archive.temporary#.tar -i!"#archive.file#" -o#archive.temporary#'
					timeout="#get(myapp).timeoutArchive#"
					variable="local.exeStdout";
			}
			catch(type variable) { archive.error = true; }
		}
		var arc = function(required struct archive) {
			fileCopy("#archive.src#", "#archive.temporary#.arc");
			fileSetAccessMode("#archive.temporary#.arc", 664);
			try {
				execute
					name="#get(myapp).appsArc.file#"
					arguments='x #archive.temporary#.arc #archive.temporary#/#archive.file#'
					timeout="#get(myapp).timeoutArchive#"
					variable="local.exeStdout";
			}
			catch(type variable) { archive.error = true; }
		}
		var tar = function(required struct archive) {
			try {
				execute
					name="#get(myapp).apps7z.file#"
					arguments='x #archive.src# -i!"#archive.file#" -o#archive.temporary#'
					timeout="#get(myapp).timeoutArchive#"
					variable="local.exeStdout";
			}
			catch(type variable) { archive.error = true; }
		}
		var zip7 = function(required struct archive) {
			try {
				execute
					name="#get(myapp).apps7z.file#"
					arguments='x #archive.src# -i!"#archive.file#" -o#archive.temporary#'
					timeout="#get(myapp).timeoutArchive#"
					variable="local.exeStdout";
			}
			catch(type variable) { archive.error = true; }
		}
		var unknown = function(required struct archive) {
			// duplicate files which are not supported archives
			try {
				fileCopy(archive.src, destination);
				fileSetAccessMode(destination, 664);
			}
			catch(any err) {
				var name = ListLast(arguments.filename,'/')
				archive.error = "#appname# error: could not duplicate file '#archive.src#/#archive.file#' (#arguments.sourceType#) to '#archive.temporary#/#name#'";
			}
		}

		archive.temporary = "#tmpDir##archive.random#"
		// make sure source file exists
		if(!FileExists("#archive.src#")) return "#appname# error: could not find '#archive.src#'";
		// create temporary directory for file extraction
		if(!DirectoryExists("#archive.temporary#")) directory action="create" directory="#archive.temporary#" mode="777";
		// extract or duplicate file
		if(arguments.sourceType == 'zip') zip(archive)
		else if(arguments.sourceType == 'rar') rar(archive)
		else if(ReFindNoCase('gz', arguments.sourceType)) gzip(archive)
		else if(ReFindNoCase('arc',arguments.sourceType)) arc(archive)
		else if(ReFindNoCase('tar',arguments.sourceType)) tar(archive)
		else if(ReFindNoCase('7z|arj|lha|lzh',arguments.sourceType)) zip7(archive)
		else if(ListFindNoCase(arguments.selfCases,Trim(arguments.sourceType))) unknown(archive)
		else {
			if(IsArchive(archive.file)) archive.error = "#appname# error: unexpected, could not extract archive type: '#archive.file#' (#arguments.sourceType#)";
			else archive.error = "#appname# error: unexpected, could not duplicate file: '#archive.file#' (#arguments.sourceType#)";
		}
		/* if needed move extracted file to destination */
		if(FileExists("#archive.temporary#/#archive.file#") && !FileExists("#archive.dest#")) {
			if(!DirectoryExists(archive.dest)) directoryCreate('#archive.dest#');
			// occasionally extracted files from archives will not have +w permissions
			execute
					name="chmod"
					arguments='oga+wr "#archive.temporary#/#archive.file#"'
					timeout="#get(myapp).timeoutArchive#"
					variable="local.exeStdout";
			fileMove("#archive.temporary#/#archive.file#", "#archive.dest#/#arguments.uuid#");
		}
		// clean-up temporary directory
		if(DirectoryExists("#archive.temporary#")) cfdirectory(action="delete",recurse="true",directory="#archive.temporary#");
		// if extraction failed, abort and return error
		if(IsBoolean(archive.error) && archive.error) return "#appname# error could not extract '#arguments.filename#' from '#archive.src#'";
		if(archive.error && Len(archive.error)) return archive.error;
		if(FileExists("#archive.dest#/#arguments.uuid#")) return "Successfully extracted or copied '#arguments.filename#' from '#archive.src#/#archive.file# to #archive.dest#'";
		return "Nothing to extract or copy."
}

// /* File Extensions */

/**
* Creates a list of permitted file extensions
*
* @index False returns a list of extensions while True returns a complex list containing the extension and struct key name
*/
private string function _getFileExtAccessor(boolean index=false) {
	var ext = "ext"
	variables.extensions = ""
	loop list="#StructKeyList(get(myapp))#" index="key" delimiters="," {
		if(Left(key,Len(ext)) != ext) continue;
		if(!IsStruct(get(myapp)[key])) continue;
		if(!StructKeyExists(get(myapp)[key],'extensions')) continue;
		if(arguments.index) {
			variables.extensions &= "|#get(myapp)[key].extensions#:#key#";
			continue;
		}
		variables.extensions &= ",#get(myapp)[key].extensions#";
	}
	return extensions;
}

/**
 * Creates a complex list of permitted file extensions that includes the file extension and the referenced struct key name.
 */
private string function _getIndexedExtensions() {
	return _getFileExtAccessor(index="true");
}

/**
 * Returns meta data stored in /config/settings-uploads.cfm about a file extension fetched using the structure key.
 * @id Structure key name (ie 'ext7z').
 */
public struct function getExtensionByKey(required string key) {
	var item = {
		"extensions":"",
		"formal":"",
		"keyname":arguments.key,
		"myappKeys":StructKeyList(get(myapp)),
		"name":"",
		"www":"",
	}
	if(!IsStruct(get(myapp)[arguments.key])) return item;
	if(!StructKeyExists(get(myapp)[arguments.key],"extensions")) return item;
	return get(myapp)[arguments.key];
}

/**
 * Returns meta data stored in /config/settings-uploads.cfm about a file extension fetched using the extension.
 * @extension File name extension (ie ANS).
 */
public struct function getExtension(required string extension) {
	var item = {
		"extensions":"",
		"formal":"",
		"keyname":"",
		"name":"",
		"www":"",
	}
	// search index to match <extension>:[key]
	var index = _getIndexedExtensions()
	var result = ListContainsNocase(index,"#arguments.extension#:","|")
	// if false, try again to match <extension>,<extension>:[key]
	if(!result) result = ListContainsNocase(index,"#arguments.extension#,","|");
	// if search result is positive, then obtain the file extension local.item
	if(result) {
		var name = ListLast(ListGetAt(index,result,"|"),":")
		item = getExtensionByKey(name)
	}
	return item;
}

/**
 * Returns the humanised name of a file extension.
 * @extension File name extension (ie ANS).
 */
public string function getExtensionFormalName(required string extension) {
	return getExtension(arguments.extension).formal;
}

/**
 * Returns the abbreviated name of a file extension.
 * @extension File name extension (ie ANS).
 */
public string function getExtensionShortName(required string extension) {
	return getExtension(arguments.extension).name;
}

/* Platforms & Sections */

/**
 * Returns a formatted name from the file list params `key`
 * @itemName Item name to format
 */
public string function getKeyName(required string itemName) {
	return capitalize(_getMenufileItem("collection",arguments.itemName).name);
}

/**
 * Creates a list of menufile platforms and sections
 *
 * @type Choice of: `platform` or `section`
 */
private string function _getMenufileAccessor(required string type) {
	var accessor = _partialName(arguments.type)
	var names = ""
	loop list="#StructKeyList(get(myapp))#" index="local.key" delimiters="," {
		if(Left(key,Len(accessor)) != accessor) continue;
		if(!IsStruct(get(myapp)[key])) continue;
		if(!StructKeyExists(get(myapp)[key],'name')) continue;
		names &= ",#get(myapp)[key].name#";
	}
	return names;
}

/**
 * Creates an 2D array of menufile platforms and sections suitable for HTML <option> tags
 *
 * @type Choice of: `platform` or `section`
 */
private array function _getMenufileAccessors(required string type) {
	var keys = StructKeyList(get(myapp))
	var file = _partialName(arguments.type)
	var index = 0
	var pairs = arrayNew(2)
	// sort keys (can comment out to disable)
	keys = listSort(keys,"textnocase","asc")
	loop list="#keys#" index="local.key" delimiters="," {
		if(Left(key,Len(file)) != file) continue;
		if(!IsStruct(get(myapp)[key])) continue;
		if(!StructKeyExists(get(myapp)[key],'name')) continue;
		index=index+1
		// key name
		var name = right(key,len(key)-len(file));
		pairs[index][1] = lCase(name)
		// display name
		pairs[index][2] = capitalize(get(myapp)[key].name);
	}
	return pairs;
}

/**
 * Fetches a menufile item from config/settings-menus.cfm
 *
 * @type Choice of: `platform` or `section`
 * @itemName Item name
 */
private struct function _getMenufileItem(required string type, required string itemName) {
	var name = _partialName(arguments.type) & arguments.itemName
	var item = {
		"category":"",
		"description":"",
		"name":"",
		"technical":"",
		"www":"",
	}
	if(!StructKeyExists(get(myapp),'#name#')) return item;
	if(!IsStruct(get(myapp)[name])) return item;
	if(!StructKeyExists(get(myapp)[name],'name')) return item;
	return get(myapp)[name];
}

/**
 * Determines what partial variable name to use when searching for items in config/settings-menus.cfm
 *
 * @type Choice of: `platform` or `section`
 */
private string function _partialName(required string type) {
	switch(arguments.type){
		case "collection":
			return "menufilecollection"
		case "platform":
			return "menufileplatform"
		case "section":
			return "menufilesection"
		default:
			return ""
	}
}

/**
 * Returns a description from the file database column `platform`
 *
 * @itemName Item name
 */
public string function getPlatformDescription(required string itemName) {
	return _getMenufileItem("platform",arguments.itemName).description;
}

/**
 * Returns a formatted name from the file database column `platform`
 *
 * @itemName Item name
 */
public string function getPlatformName(required string itemName, boolean cap=true) {
	if(!arguments.cap) return _getMenufileItem("platform",arguments.itemName).name
	return capitalize(_getMenufileItem("platform",arguments.itemName).name)
}

/**
 * Returns a technical description from the file database column `platform`
 *
 * @itemName Item name
 */
public string function getPlatformTechnical(required string itemName) {
	return _getMenufileItem("platform",arguments.itemName).technical;
}

/**
 * Returns a description from the file database column `section`
 *
 * @itemName Item name
 */
public string function getSectionDescription(required string itemName) {
	return _getMenufileItem("section",arguments.itemName).description;
}

/**
 * Returns a formatted name from the file database column `section`
 *
 * @itemName Item name
 */
public string function getSectionName(required string itemName, boolean cap=true) {
	if(!arguments.cap) return _getMenufileItem("section",arguments.itemName).name
	return capitalize(_getMenufileItem("section",arguments.itemName).name)
}

/**
 * Creates a distinct list of formatted names used by the file database column `platform`
 */
public string function getPlatforms() {
	return _getMenufileAccessor("platform");
}

/**
 * Creates a distinct list of formatted names used by the file database column `section`
 */
public string function getSections() {
	return _getMenufileAccessor("section");
}

/**
 * Creates a distinct array of sorted and formatted 'platform' names and values to be used in HTML <option> tags
 */
public array function getPlatformPairs() {
	return _getMenufileAccessors("platform");
}

/**
 * Creates a distinct array of sorted and formatted 'section' names and values to be used in HTML <option> tags
 */
public array function getSectionPairs() {
	return _getMenufileAccessors("section");
}

/**
 * Creates a SQL statement to use on /models/*.cfm so item names sorted in config/settings-menus.cfm can be applied to CFWheels Form Helpers
 *
 * @type Choice of: `platform` or `section`
 */
public string function setMenufileSQLAccessor(required string type) {
	var sql = {
		"column":"",
		"file":"",
		"list":"",
	}
	switch(arguments.type){
		case "platform":
			sql.column = "platform"
			sql.file = "menufileplatform"
			sql.list = "#getPlatforms()#"
		break;
		case "section":
			sql.column = "section"
			sql.file = "menufilesection"
			sql.list = "#getSections()#"
		break;
		default:
	}
	var sqlStmt = ""
	var cnt = 0
	loop list="#ListSort(sql.list,'textnocase')#" index="item" delimiters="," {
		var finds = StructFindValue(get(myapp),'#item#','all')
		for(var key in finds) {
			if(!StructKeyExists(key,'path')) continue;
			if(Left(key.path,Len(sql.file)+1) != ".#sql.file#") continue;
			cnt=cnt+1
			sqlStmt &= "IF(`#sql.column#`='#LCase(ReplaceNocase(ListFirst(key.path,'.'),'#sql.file#',''))#', '#Capitalize(key.owner.name)#', "
		}
	}
	sqlStmt &= " CONCAT(UPPER(LEFT(`#sql.column#`,1)), RIGHT(`#sql.column#`,LENGTH(`#sql.column#`)-1)  ) #RepeatString(')',cnt)#"
	return sqlStmt;
}

/**
 * Create a SQL statement to be combined with the model property `platformText`
 */
public string function setPlatformNames() {
	return setMenufileSQLAccessor("platform");
}

/**
 * Create a SQL statement to be combined with the model property `sectionText`
 */
public string function setSectionNames() {
	return setMenufileSQLAccessor("section");
}

/* SQL Functions */

private struct function _sqlInitialize(required string statement) {
	var sql = {
		// used by the findAll() or as the default WHERE statement
		"base":arguments.statement,
		// used when section is provided
		"section":{
			"base":arguments.statement,
			"sections":arguments.statement,
			"platforms":arguments.statement,
		},
		// used when platform is provided
		"platform":{
			"base":arguments.statement,
			"sections":arguments.statement,
			"platforms":arguments.statement,
		},
		// used when both secton and platform are provided
		"both":{
			"base":arguments.statement,
			"sections":arguments.statement,
			"platforms":arguments.statement,
		},
	}
	return sql;
}

/**
* Generates SQL file statement based on arguments provided.
*/
public struct function dynamicSqlForFile(required struct params, query listofSections=QueryNew(''), query listofPlatforms=QueryNew(''), string source="") {
	/* determine which records to fetch */
	var sql = {}
	/* Setup dynamic SQL statements based on arguments.params provided */
	switch(arguments.params.key) {
		case "github":
			sql = _sqlInitialize("web_id_github IS NOT NULL") // 04/Feb/2014: Taken out -  AND group_brand_by IS NULL
			break;
		/* COLLECTIONS: Digital & Pixel Art */
		case "visual" :
			sql = _sqlInitialize("(platform = 'image' AND section != 'bbs')")
			sql.section.base=sql.base & " AND section = '#arguments.params.section#'"
			sql.platform.base="platform = '#arguments.params.platform#'"
			sql.platform.sections="platform = '#arguments.params.platform#'"
			sql.both.base="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			break;
		/* COLLECTIONS: Documents & Text Art */
		case "document" :
			sql = _sqlInitialize("(platform = 'ansi' OR platform = 'text' OR platform = 'textamiga' OR platform = 'pdf')")
			sql.section.base=sql.base & " AND section = '#arguments.params.section#'"
			sql.section.platforms=sql.base & " AND section = '#arguments.params.section#'"
			sql.platform.base="platform = '#arguments.params.platform#'"
			sql.platform.sections="platform = '#arguments.params.platform#'"
			sql.both.base="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			sql.both.platforms="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			sql.both.sections="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			break;
		/* COLLECTIONS: Software */
		case "software" :
			// base statement
			sql = _sqlInitialize("(platform = 'Java' OR platform = 'linux' OR platform = 'dos' OR platform = 'php' OR platform = 'windows')")
			sql.section.base=sql.base & " AND section = '#arguments.params.section#'"
			sql.section.platforms=sql.base & " AND section = '#arguments.params.section#'"
			sql.platform.base="platform = '#arguments.params.platform#'"
			sql.platform.sections="platform = '#arguments.params.platform#'"
			sql.both.base="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			break;
		/* COLLECTIONS: All files */
		case "-" : case "" :
			sql = _sqlInitialize("")
			sql.section.base=sql.base & "section = '#arguments.params.section#'"
			sql.section.platforms=sql.base & "section = '#arguments.params.section#'"
			sql.platform.base="platform = '#arguments.params.platform#'"
			sql.platform.sections="platform = '#arguments.params.platform#'"
			sql.both.base="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			sql.both.platforms="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			sql.both.sections="platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
			break;
		/* OPERATOR LINKS: Operator listing disabled */
		case "disabled" :
			sql = _sqlInitialize("deletedat IS NOT NULL AND deletedby IS NOT NULL")
			break;
		/* OPERATOR LINKS: New records waiting for approval */
		case "waitingapproval" :
			sql = _sqlInitialize("deletedat IS NOT NULL AND deletedby IS NULL")
			break;
		/* OPERATOR LINKS: Flagged as a possible infection with a virus or spyware */
		case "virusalert" :
			sql = _sqlInitialize("file_security_alert_url IS NOT NULL")
			break;
		/* Else assume key is an organisation name */
		default: {
			switch(arguments.source) {
				case "o":
					sql = _sqlInitialize("(#sqlOrganisation(deobfuscateURL(arguments.params.key))#)")
					sql.section.base=sql.base & " AND section = '#arguments.params.section#'"
					sql.section.platforms=sql.base & " AND section = '#arguments.params.section#'"
					sql.platform.base=sql.base & " AND platform = '#arguments.params.platform#'"
					sql.platform.sections=sql.base & " AND platform = '#arguments.params.platform#'"
					sql.both.base=sql.base & " AND platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
					sql.both.platforms=sql.base & " AND platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
					sql.both.sections=sql.base & " AND platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
					break;
				case "p":
					sql = _sqlInitialize("(#sqlPerson(deobfuscateURL(arguments.params.key))#)")
					sql.section.base=sql.base & " AND section = '#arguments.params.section#'"
					sql.section.platforms=sql.base & " AND section = '#arguments.params.section#'"
					sql.platform.base=sql.base & " AND platform = '#arguments.params.platform#'"
					sql.platform.sections=sql.base & " AND platform = '#arguments.params.platform#'"
					sql.both.base=sql.base & " AND platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
					sql.both.platforms=sql.base & " AND platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
					sql.both.sections=sql.base & " AND platform = '#arguments.params.platform#' AND section = '#arguments.params.section#'"
					break;
				default:
					sql = _sqlInitialize("#sqlOrganisation(deobfuscateURL(arguments.params.key))#")
					break;
			}
			break;
		}
	}
	/* Set base statements */
	sql.whereState = sql.base
	sql.wherePlatform = sql.base
	sql.whereSection = sql.base
	var whichWhere = function(required struct args) {
		var arg = arguments.args
		// section
		var section = true
		if(!IsQuery(arg.listofSections)) section = false;
		else if(!structKeyExists(arg.listofSections,"section")) section = false;
		else if(!ListFindNocase(valueList(arg.listofSections.section),arg.params.section)) section = false;
		// platform
		var platform = true
		if(!IsQuery(arg.listofPlatforms)) platform = false;
		else if(!structKeyExists(arg.listofPlatforms,"platform")) platform = false;
		else if(!ListFindNocase(valueList(arg.listofPlatforms.platform),arg.params.platform)) platform = false;
		// result
		if(section && platform) return "both"
		if(section) return "section"
		if(platform) return "platform"
		return ""
	}
	var where = whichWhere(arguments)
	switch(where) {
		case "section":
			sql.whereState=sql.section.base
			sql.wherePlatform=sql.section.platforms
			sql.whereSection=sql.section.sections
			return sql;
		case "platform":
			sql.whereState=sql.platform.base
			sql.wherePlatform=sql.platform.platforms
			sql.whereSection=sql.platform.sections
			return sql;
		case "both":
			sql.whereState=sql.both.base
			sql.wherePlatform=sql.both.platforms
			sql.whereSection=sql.both.sections
			return sql;
		default:
			return sql;
	}
}

/**
* Generates SQL file order statement based on arguments provided
*
* @paramOrder Record type either: title, posted, date, publishedby, publishedfor, disabled
*/
public string function dynamicSqlFileOrder(string paramOrder="") {
	switch(arguments.paramOrder){
		case "title":
		case "title_asc":
			return "AZ_SORT ASC, fileName ASC"
		case "title_desc":
			return "AZ_SORT DESC, fileName DESC"
		case "posted_asc":
		case "P;O=D":
			return "ISNULL(createdAt), createdAt ASC"
		case "posted":
		case "posted_desc":
		case "P;O=A":
			return "createdAt DESC, fileName ASC"
		case "size_asc":
		case "S;O=A":
			return "fileSize ASC, fileName ASC"
		case "size_desc":
		case "S;O=D":
			return "fileSize DESC, fileName ASC"
		case "date_asc":
		case "D;O=A":
			return "ISNULL(date_issued_year), date_issued_year ASC, ISNULL(date_issued_month), date_issued_month ASC, ISNULL(date_issued_day), date_issued_day ASC"
		case "date":
		case "date_desc":
		case "D;O=D":
			return "date_issued_year DESC, date_issued_month DESC, date_issued_day DESC"
		case "publishedby":
			return "group_brand_by"
		case "publishedfor":
			return "group_brand_for"
		case "disabled":
			return "deletedAt DESC"
		case "updated":
			return "updatedAt DESC, deletedAt DESC, createdAt DESC"
		case "I;O=D":
			return "record_title DESC group_brand_for DESC group_brand_by DESC"
		case "I;O=A":
			return "record_title ASC group_brand_for ASC group_brand_by ASC"
		case "N;O=D":
			return "fileName DESC"
		case "N;O=A":
			return "fileName ASC"
		default:
			return ""
	}
}

/**
* Generates SQL WHERE statement to find an organisation
*
* @organisation Organisation title
*/
public string function sqlOrganisation(string organisation="") {
	var org = arguments.organisation
	var stmt = "group_brand_for='#org#' OR group_brand_for LIKE '#org#,%' OR group_brand_for LIKE '%, #org#,%' OR group_brand_for LIKE '%, #org#'"
	stmt &= " OR group_brand_by='#org#' OR group_brand_by LIKE '#org#,%' OR group_brand_by LIKE '%, #org#,%' OR group_brand_by LIKE '%, #org#'"
	return stmt;
}

/**
* Generates SQL WHERE statement to find a person
*
* @person Person's name
*/
public string function sqlPerson(string person="") {
	var per = arguments.person
	var stmt = "credit_text='#per#' OR credit_text LIKE '#per#,%' OR credit_text LIKE '%,#per#,%' OR credit_text LIKE '%,#per#' OR credit_program='#per#'"
	stmt &= " OR credit_program LIKE '#per#,%' OR credit_program LIKE '%,#per#,%' OR credit_program LIKE '%,#per#' OR	credit_illustration='#per#'"
	stmt &= " OR credit_illustration LIKE '#per#,%' OR credit_illustration LIKE '%,#per#,%' OR credit_illustration LIKE '%,#per#' OR credit_audio='#per#'"
	stmt &= " OR credit_audio LIKE '#per#,%' OR credit_audio LIKE '%,#per#,%' OR credit_audio LIKE '%,#per#'"
	return stmt;
}

/**
* Applies strict formatting rules to names of Organisations
*
* @organisation Organisation title
*/
public string function organisationFormat(string organisation="") {
	var org = Trim(arguments.organisation)
	org = REReplaceNocase(org,get(myapp).acceptedDirChrs,'','all')
	org = REReplace(org,' (of|in|and|the|to|from|by|on|no)( |$)',' \u\1\2','all')
	org = REReplace(org,'([0-9])(ad)( |$)','\1\U\2\3','all')
	org = REReplaceNoCase(org,' (bbs|ftp|iso)( |$|\,|\.)',' \U\1\2','all')
	org = REReplaceNoCase(org,'(cd|ansi)( |$|\,|\.)','\U\1\2','all')
	org = REReplace(org,'(^| )([a-z])','\1\u\2','all')
	return org;
}

/**
* Applies strict formatting rules to on user submitted strings to protect against Cross Site Scripting
*
* @string String with potential scripts
*/
public string function xssFix(string text="") {
	// https://www.owasp.org/index.php/XSS_(Cross_Site_Scripting)_Prevention_Cheat_Sheet
	var xss = Xmlformat(arguments.text)
	ReplaceNocase(xss,'&apos;','&##x27;','all')
	ReplaceNocase(xss,'/','&##x2F;','all')
	return xss;
}

/* Regular Expression Functions */

/**
* Escapes all Regular Expression special characters [\^$.|?*+() so they are treated as literal characters
*
* @expression Regular expression
*/
public string function obfuscateRegEx(required string expression) {
	return REReplaceNoCase(arguments.expression,'[\[\\|\^|\$|\.|\?|\*|\+|\(|\)]','\\0','all')
}

/**
* Generates a cryptic hash string for use as a user password.
* It reads a key from a remote text file, mixes in a UUID string into the password and then applies a SHA-512 hash to the string.
*
* @uuid A CFML 35-character UUID.
* @password A string used to apply randomisation to the hash.
*/
public string function pwsha512(required string uuid, required string password) {
	var file = loadJSONConfig("wheels")
	if(!len(file)) WriteDump('wheels entry is empty so the encryption output is probably wrong')
	var preperation = ListGetAt(arguments.uuid,4,'-') & ListGetAt(arguments.uuid,1,'-') & file & arguments.password & ListGetAt(arguments.uuid,3,'-') & ListGetAt(arguments.uuid,2,'-')
	file = ""
	var hashed = Hash(preperation, "SHA-512")
	preperation = ""
	return hashed;
}

/**
 * Reads a JSON file and parses to a CFML data structure.
 * Then using a breadcrumb dot notation path it fetches and returns
 * a requested value.
 *
 * Copy of app.cfm loadJSONConfig()
 *
 * @keyPath A dot notation breadcrumb path pointing to a structure key.
 * @path Relative or absolute path to a JSON formatted file.
 */
private any function loadJSONConfig(string keyPath="", string path="../insecure/defacto2.json") {
	// read json file
	var fullPath = expandPath(arguments.path)
	if(!fileExists(fullPath)) return "not found: #fullPath#";
	var json = fileRead(fullPath)
	var data = DeserializeJSON(json)
	json = ""
	if(StructIsEmpty(data)) return ""
	// if no keyPath value is provided, then return the complete data structure
	if(arguments.keyPath == "") return data
	// follow the keyPath breadcrumb trail by searching for it's last key item,
	// i.e if keyPath="google.email.address.from", search for "from".
	// then compare all the structFindKey() path value matches against our keyPath value.
	var keys = listToArray(arguments.keyPath, ".")
	var finds = structFindKey(data, ArrayLast(keys), 'all')
	for (var find in finds) {
		if('.#arguments.keyPath#' == find.path) {
			data = {}
			finds = {}
			return find.value
		}
	}
	data = {}
	finds = {}
	return ""
}

/* Use Feature Queries */

/**
* Checks browser for DNT (do not track) toggle
*/
public boolean function dntUser() {
	if(get("environment") != "production") return false;
	if(!structKeyExists(GetHttpRequestData().headers,"dnt")) return false;
	if(GetHttpRequestData().headers.dnt != 1) return false;
	return true;
}

/**
* Determines if Discord features should be used or ignored
*/
public boolean function useDiscord() {
	if(!StructKeyExists(get(myapp),"discord")) return false;
	if(!StructKeyExists(get(myapp).discord,"account")) return false;
	if(!Len(get(myapp).discord.account)) return false;
	return true;
}

/**
* Determines if FaceBook features should be used or ignored
*/
public boolean function useFaceBook() {
	if(!StructKeyExists(get(myapp),"faceBook")) return false;
	if(!StructKeyExists(get(myapp).faceBook,"account")) return false;
	if(!Len(get(myapp).facebook.account)) return false;
	return true;
}

/**
* Determines if GitHub features should be used or ignored
*/
public boolean function useGitHub() {
	if(!StructKeyExists(get(myapp),"gitHub")) return false;
	if(!StructKeyExists(get(myapp).gitHub,"account")) return false;
	if(!Len(get(myapp).github.account)) return false;
	return true;
}

/**
* Determines if Mastodon features should be used or ignored
*/
public boolean function useMastodon() {
	if(!StructKeyExists(get(myapp),"mastodon")) return false;
	if(!StructKeyExists(get(myapp).mastodon,"account")) return false;
	if(!Len(get(myapp).mastodon.account)) return false;
	return true;
}

/**
* Determines if Twitter features should be used or ignored
*/
public boolean function useTwitter() {
	if(!StructKeyExists(get(myapp),"twitter")) return false;
	if(!StructKeyExists(get(myapp).twitter,"account")) return false;
	if(!Len(get(myapp).twitter.account)) return false;
	return true;
}

/**
* Determines if YouTube features should be used or ignored
*/
public boolean function useYouTube() {
	if(!StructKeyExists(get(myapp),"youTube")) return false;
	if(!StructKeyExists(get(myapp).youTube,"account")) return false;
	if(!Len(get(myapp).youtube.account)) return false;
	return true;
}

/**
* Determines if WordPress features should be used or ignored
*/
public boolean function useWordPress() {
	if(!StructKeyExists(get(myapp),"wordPress")) return false;
	if(!StructKeyExists(get(myapp).wordPress,"account")) return false;
	if(!Len(get(myapp).wordPress.account)) return false;
	return true;
}

/* URL Functions */

private string function _humaniseCrumb(required string key) {
	switch(LCase(arguments.key)) {
		case 'disabled': return arguments.key;
		case 'virusalert': return 'virus alerts';
		case 'waitingapproval': return 'waiting approval';
		default: return ''
	}
}

private string function _mockCrumb(required struct params, required string key) {
	var key = arguments.key
	if(arguments.params.route == 'f' || arguments.params.controller == "File") {
		var crumb = _humaniseCrumb(key)
		if(crumb != '') return crumb
	}
	if(arguments.params.route == 'f') {
		if(key != '-' && key != '') return organisationFormat(deobfuscateURL(key))
		var mock = StructCopy(arguments.params)
		mock.platform = mock.section = "-"
		mock.action = 'list'
		mock.controller = 'File'
		mock.key = key
		mock.route = 'fileFiler'
		var titles = menuTitles(mock)
		return replaceNoCase(titles.header, ' files', '')
	}
	if(arguments.params.controller == "File") {
		var crumb = _humaniseCrumb(arguments.params.key)
		if(crumb != '') return crumb
		var mock = StructCopy(arguments.params)
		mock.platform = mock.section = "-"
		var titles = menuTitles(mock)
		var formatKey = replaceNoCase(titles.header, ' files', '')
		if(formatKey == 'All') return ''
		return formatKey
	}
	return organisationFormat(deobfuscateURL(key))
}

private string function _crumbQuery(required struct params, required number position, required string href) {
	if(!structKeyExists(arguments.params, "platform")) return ""
	if(!structKeyExists(arguments.params, "section")) return ""
	var suffex = ' files'
	var urlQuery = ""
	var args = arguments.params
	var pos = arguments.position
	var link = arguments.href
	if(structKeyExists(args, 'name') || structKeyExists(args, 'output')) {
		urlQuery = 'platform=#args.platform#&amp;section=#args.section#&amp;sort=#args.sort#'
	}
	if(args.platform != "-" && args.section != "-") {
		var queryString = replace(urlQuery, '&amp;section=#args.section#', '&amp;section=-')
		var crumb = appendCrumb(pos, LCase(getPlatformName(args.platform)), '#link#?#queryString#')
		queryString = replace(urlQuery, '&amp;platform=#args.platform#', '&amp;platform=-')
		crumb &= appendCrumb(pos+1, LCase(getSectionName(args.section)) & suffex, '#link#?#queryString#')
		return crumb
	}
	if(args.platform != "-") {
		var queryString = replace(urlQuery, '&amp;section=#args.section#', '&amp;section=-')
		return appendCrumb(pos, LCase(getPlatformName(args.platform)) & suffex, '#link#?#queryString#')
	}
	if(args.section != "-") {
		var queryString = replace(urlQuery, '&amp;platform=#args.platform#', '&amp;platform=-')
		return appendCrumb(pos, LCase(getSectionName(args.section)) & suffex, '#link#?#queryString#')
	}
	return ""
}

/**
* Builds a HTML bread crumb trail for end-user file navigation.
*/
public string function crumbTrail(required struct params, required number position, required string key) {
	var detailRoute = function(required struct params) {
		if(arguments.params.controller != 'file') return ""
		if(arguments.params.action != 'detail') return ""
		switch(params.route) {
			case '': case 'home': case 'f':
				return "f"
			default:
				return ""
		}
	}
	var keyName = arguments.key
	if(!Len(keyName)) return;
	arguments.params.route = detailRoute(arguments.params)
	var args = arguments.params
	var pos = arguments.position
	var formatKey = _mockCrumb(args, keyName)
	var crumbs = ""
	var link = ""
	switch(args.route) {
	case 'f':
		if(structKeyExists(args, "name") && Len(args.name) && args.name != '-') {
			switch(args.src) {
				case 'o': link = URLFor(route='g', orgname=args.name); break;
				case 'p': link = URLFor(route='p', personname=args.name); break;
				default: link = URLFor(route='d', key=args.name); break;
			}
			formatKey = _mockCrumb(args, args.name)
			crumbs &= appendCrumb(pos, formatKey, link)
		} else {
			link = URLFor(route='fileList')
		}
		crumbs &= _crumbQuery(args, pos+1, link)
		link = URLFor(route='f', key=keyName)
		if(isDefined('fileProd') && structKeyExists(fileProd, 'filename') && Len(fileProd.filename)) {
			crumbs &= appendCrumb(pos+2, fileProd.filename, link, true)
		} else if(Len(formatKey)) crumbs &= appendCrumb(pos+2, fileProd.filename, link, true);
		return LCase(crumbs)
	default:
		switch(args.controller) {
			case "Organisation": link = URLFor(route="g", orgname=keyName); break;
			case "Person": link = URLFor(route="p", personname=keyName); break;
			default:
		}
		if(Len(formatKey)) crumbs = appendCrumb(pos, formatKey, link) & _crumbQuery(args, pos+1, link);
		else crumbs &= _crumbQuery(args, pos, link)
		return LCase(crumbs)
	}
}

/**
* Converts a CFWheels URL usable obfuscated string of text into a human readable format
*
* @url URL or URI string
*/
public string function deobfuscateURL(required string url) {
	var words = ""
	var text = ""
	var link = arguments.url
	link = REReplace(link, '-ampersand-', ' & ', 'all')
	link = REReplace(link, '\-', ' ', 'all')
	link = REReplace(link, '\_', '-', 'all')
	link = LCase(link)
	// process words separated by spaces
	loop list="#link#" index="local.word" delimiters="," {
		if(ListFind("in,of,or", word)) {
			words &= ' ' & LCase(word);
			continue;
		}
		if(Len(word) >= 3 && Len(link) > 3 && !ListFind("iso,xxx", word)) {
			words &= ' ' & capitalize(word);
			continue;
		}
		words &= ' ' & UCase(word);
	}
	if(listLen(words, "-") >= 2) {
		// process words divided by dashes
		loop list="#words#" index="local.word" delimiters="-" {
			if(!Len(text)) text = word;
			else text &= '-' & capitalize(word);
		}
	}
	if(listLen(words, "*") >= 2) {
		// process words divided by pluses
		loop list="#words#" index="local.word" delimiters="*" {
			if(!Len(text)) text = word;
			else text &= ', ' & capitalize(word);
		}
	}
	if(!Len(text)) text = words;
	// apply any additional formatting
	return Trim(REReplace(text, 'iso$', 'ISO', 'all'))
}

/**
* Converts a string of text into a CFWheels URL usable format
*
* @url URL or URI string
*/
public string function obfuscateURL(required string url) {
	var link = REReplace(arguments.url, '\-', '_', 'all')
	link = REReplace(link, '\, ', '*', 'all')
	link = REReplace(link, ' \& ', ' ampersand ', 'all')
	link = REReplace(link, ' ([0-9])', '-\1', 'all')
	link = REReplace(link, '[^A-Za-z0-9 \-\+\.\_\*]', '', 'all') // Deletes ALL Character except ...
	link = LCase(link)
	var obfuscate = ""
	loop list="#link#" index="local.part" delimiters=" " {
		obfuscate &= capitalize(part)
	}
	return hyphenize(obfuscate)
}

/**
* Downloads a binary file and saves it locally
*
* @xmlUrl URL linking to the XML document.
* @cleanBOM Attempt to remove Byte-Order-Mark (BOM) which is not compatible with XMLParse()?
*/
public struct function downloadBin(required string url, required string file, required string path="/tmp") {
	var protocol = listFirst(arguments.url,':')
	dump(label='downloadBin() arguments',var=arguments);
	switch(protocol) {
	case 'http': case 'https':
		// retrieve file
		http method="get" url=arguments.url
			file=arguments.file
			path=arguments.path
			getasbinary="auto"
			resolveurl="yes"
			redirect="yes"
			timeout="30"
			result="local.result"
			useragent="#createUserAgent()#" {
				// HTTP compression algorithm decompress
				httpparam type="Header" name="Accept-Encoding" value="deflate;q=0";
				httpparam type="Header" name="TE" value="deflate;q=0";
			}
		if(!structKeyExists(result.responseheader,'status_code')) {
			result.responseheader.status_code = ''
		}
		return result.responseheader
	break;
	case 'ftp':
		var args = {
			"local":'#arguments.path#/#arguments.file#',
			"server":listGetAt(arguments.url, 2, '/'),
			"start":"",
			"length":"",
			"remote":"",
		}
		args.start = len(args.server) + len('ftp://') + 1
		args.length = len(arguments.url) - args.start + 1
		args.remote = mid(arguments.url, args.start, args.length)
		dump(label='FTP protocol arguments',var=args);
		// open anonymous ftp connection
		var ftp = new ftp()
		ftp.setConnection('anonyftp')
		ftp.setServer(args.server)
		ftp.setUsername('anonymous')
		ftp.setPassword('ftp@example.com')
		ftp.setPassive(true) // need true value, but may break very old ftp sites
		ftp.setSecure(false)
		ftp.setTimeout(15)
		dump(label='FTP connection attributes',var=ftp.getAttributes());
		var open = ftp.open()
		dump(label='FTP connection result',var=open.getResult())
		dump(label='FTP connection prefix',var=open.getPrefix())
		open = ftp.listdir(directory=args.remote, name="fileList", stopOnError=false).getResult();
		dump(label='List results',var=open)
		// retrieve file
		open = ftp.getfile(remoteFile=args.remote, localfile=args.local, name="getFile", failIfExists=false, stopOnError=false);
		dump(label='FTP closed result',var=open.getResult())
		dump(label='FTP closed prefix',var=open.getPrefix())
		// mockup http results
		var responseHeader = {
			"error":"",
			"status_code":"",
			"succeeded":"",
		}
		try {
			responseHeader.error = open.getPrefix()['returnValue']
		} catch(any err) {}
		try {
			responseHeader.status_code = open.getPrefix()['errorCode']
		} catch(any err) {}
		try {
			responseHeader.succeeded = open.getPrefix()['succeeded']
		} catch(any err) {}
		dump(responseHeader)
		// close connection
		open = ftp.close();
		return responseHeader
	default:
		var responseHeader = {
			"status_code":"",
		}
		return responseHeader
	}
}

/**
* Downloads a HTML document
*
* @htmlUrl URI to request
*/
public any function downloadHTML(required string htmlUrl, string method="GET") {
	var string = ""
	http method=arguments.method
		url=arguments.htmlUrl
		charset="utf-8"
		resolveurl="yes"
		redirect="yes"
		timeout="30"
		result="local.htmlResult"
		useragent="#createUserAgent()#" {
			// HTTP compression algorithm decompress
			httpparam type="Header" name="Accept-Encoding" value="deflate;q=0";
			httpparam type="Header" name="TE" value="deflate;q=0";
		};
	var okay = 200
	if(htmlResult.status_code != okay) return htmlResult.statuscode
	switch(htmlResult.mimetype) {
		case "application/json":
			return deserializeJSON(htmlResult.filecontent)
		case "application/xhtml+xml":
		case "text/html":
			return HTMLParse(REReplace(trim(htmlResult.filecontent), "^[^<]*", "", "all"))
		case "application/atom+xml":
		case "application/xml":
		case "text/xml":
			return XMLParse(trim(htmlResult.filecontent))
		default:
			return htmlResult.filecontent
	}
}

/**
* Downloads a document from a source online
*
* @url URL linking to the online document.
* @returntype Specify and return a single HTTP reply.
* @etag Hash used for cache checking.
* @ifmodifiedsince Date used for cache checking.
* @timeout Seconds to attempt to load the page.
* @redirect Follow any redirection requests.
*/
public struct function receiveURL(
		string url="",
		string returntype="",
		string etag="",
		string ifmodifiedsince="",
		numeric timeout=10,
		boolean localrequest=false,
		boolean redirect="false")
	{
	var results = {}
	var agent = "Defacto2/local (ignorePersistSession)"
	if(!arguments.localrequest) agent = createUserAgent();
	try {
		http method="get"
			url="#arguments.url#"
			charset="utf-8"
			resolveurl="no"
			redirect="#arguments.redirect#"
			timeout="#arguments.timeout#"
			result="local.result"
			useragent="#agent#" {
				// HTTP compression algorithm decompress
				httpparam type="Header" name="Accept-Encoding" value="deflate;q=0";
				httpparam type="Header" name="TE" value="deflate;q=0";
				if(Len(arguments.etag)) httpparam type="Header" name="If-None-Match" value='"#arguments.etag#"';
				if(Len(arguments.ifmodifiedsince)) httpparam type="Header" name="If-Modified-Since" value='#arguments.ifmodifiedsince#';
		};
	} catch (any err) {
		var error = {}
		error.status_code = 400
		error.status_text = "Cfwheels: #err.message#"
		return error
	}
	// generate return structure
	if(!ListLen(arguments.returntype)) {
		return result;
	}
	loop list="#arguments.returntype#" index="local.type" delimiters="," {
		switch(structKeyExists(result, type)) {
		case true:
			results[type] = result[type]
			break;
		default:
			results[type] = ""
		}
	}
	return results;
}

/* User-agents */

/**
* Creates a user agent used in HTTP requests.
*/
package string function createUserAgent() {
	return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0'
}
</cfscript>