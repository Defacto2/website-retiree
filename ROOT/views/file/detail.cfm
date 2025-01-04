<!---
    Detail file view.
	path: views/files/detail.cfm

@CFLintIgnore
--->
<cfscript>
	// params
	param name="fileContentList" default="";
	param name="params.name" default="";
	param name="params.platform" default="";
	param name="params.section" default="";
	param name="params.sort" default="";
	if(len(fileProd) is 0) { return render404();}
	// local vars
	var myapp = "myapp"
	var coop = "coop"
	var default = "default"
	var disabled = "disabled"
	var filePackaged = IsArchive(fileProd.filename)
	var imageFilename = "/#fileProd.uuid#.png"
	var getPosition = function() {
		// save file detail navigation position
		// used by other closures, so this needs to remain at top
		if(!len(params.name)) return "";
		if(!len(params.platform)) return "";
		if(!len(params.section)) return "";
		if(!len(params.sort)) return "";
		return "&name=#params.name#&platform=#params.platform#&section=#params.section#&sort=#params.sort#"
	}
	var positionQuery = getPosition()
	// closures
	var badges = function() {
		// prod_badges.cfm category tags
		variables.tags = ""
		switch(params.src) {
			case "o": case "p":
				tags = organisationFormat(deobfuscateURL(params.name)); break;
			case "": case "f":
				tags = getKeyName(params.name); break;
			default:
				tags = params.name
		}
	}
	var cacheDisable = function(required date lastMod) {
		return "?" & DateFormat(arguments.lastMod,"YYYYMMDD") & "." & TimeFormat(arguments.lastMod,"HHMMss")
	}
	var coopActivation = function() {
		if(!opCheck(coop)) return;
		button.activation = {
			"colour" = 'danger',
			"icon" = 'minus-square',
			"text" = 'unpublished',
			"value" = 'enablefile=1',
		}
		if(!Len(Trim(fileProd.deletedAt))){
			button.activation.colour = 'success'
			button.activation.icon = 'plus-square'
			button.activation.text = 'published'
			button.activation.value = 'disablefile=1'
		}
	}
	var coopAlerts = function() {
		if(!opCheck(coop)) return;
		var alert = function() {
			if(fileProd.group_brand_for == test) return ' Test file cannot be approved'
			if(fileProd.group_brand_by == test) return ' Test file cannot be approved'
			return '<i class="fal fa-folder fa-fw fa-lg"></i> The file is inactive'
		}
		var test = get(myapp).pubNameForTests
		if(Len(fileProd.createdat) && Len(fileProd.deletedat) && !Len(fileProd.deletedby)){
			feedback.hints = alert()
		}
		if(feedback.require.fail){
			/* record 'cannot approve' notice */
			if(Len(feedback.hints)) feedback.hints &= '</span> but <strong>this record has red highlighted fields that need fixing</strong>'
		}
		feedback.hints = capitalize(feedback.hints)
	}
	var coopArchive = function() {
		if(!opCheck(coop)) return;
		image.scan = {
			"colour"=default,
			"status"=disabled,
			"value"='rescanpackage=0'
		}
		if(filePackaged) {
			if(!ListLen(fileContentList)) image.scan.colour = 'primary'
			image.scan.status = ''
			image.scan.value = 'rescanpackage=1'
		}
	}
	var warning = function() {
		image.kill.colour = 'warning'
		image.kill.status = ''
		image.kill.value = 'killimages=1'
	}
	var coopDeleteImages = function() {
		if(!opCheck(coop)) return
		image.kill = {
			"colour"=default,
			"status"=disabled,
			"value"='killimages=0'
		}
		if(image.x400.size) warning();
		if(image.screenshot.size) warning();
	}
	var coopErrors = function() {
		if(!opCheck(coop)) return;
		// css variables used by the dialog to highlight validation errors
		feedback.require.platform = !Len(fileProd.platform)
		feedback.require.section = !Len(fileProd.section)
		feedback.require.filename = !Len(fileProd.filename)
		feedback.require.for = !Len(fileProd.group_brand_for)
		if (feedback.require.for == true && fileProd.group_brand_for == "Change_Me") {
			feedback.require.for = false
		}
		feedback.recommend.download = true
		feedback.recommend.zip = true
		// download
		if(fileProd.fileSize == "") feedback.recommend.download = false
		else if(!fileProd.fileSize) feedback.recommend.download = false
		// archive content
		if(filePackaged) {
			feedback.recommend.zip = Len(fileProd.file_zip_content)
		}
		// title, if missing the filename will be used as a title
		// except for magazines where the title is recommended as it is used as the issue/volumne value
		feedback.recommend.title = false
		if(fileProd.section == 'magazine') {
			feedback.recommend.title = Len(fileProd.record_title)
		}
		// required and recommended statuses
		feedback.require.fail = ArrayLen(StructFindValue(feedback.require,false,'one'))
		feedback.recommend.fail = ArrayLen(StructFindValue(feedback.recommend,false,'one'))
	}
	var coopImageCache = function() {
		if(!opCheck(coop)) return;
		if(toggle.previewFlagged){
			try {
				var info = GetFileInfo(get(myapp).fulldirPreview & imageFilename)
				image.screenshot.size = info.size
				image.screenshot.disableCache = cacheDisable(info.lastmodified)
			} catch(any err) {}
		}
		if(toggle.thumb400) {
			try {
				var info = GetFileInfo(get(myapp).fulldirThumb400 & imageFilename)
				image.x400.size = info.size
				image.x400.text = "the cloudfare or browser cache is dated"
				image.x400.disableCache = cacheDisable(info.lastmodified)
			} catch(any err) {
				image.x400.text = "getFileInfo error"
			}
		}
	}
	var coopScreenshots = function() {
		if(!opCheck(coop)) return;
		var primary = function() {
			if(!image.x400.size) image.generate.colour = 'primary'
			image.generate.status = ''
			image.generate.value = 'generateimages=1'
		}
		// post screen capture generation
		image.generate = {
			"colour"=default,
			"status"=disabled,
			"value"='generateimages=0',
		}
		if(filePackaged && ListLen(fileContentList)) {
			primary()
			return
		}
		if(filePackaged) return;
		if(isProgram(fileProd.filename)) return;
		if(isAudio(fileProd.filename)) return;
		if(IsNoPreview(fileProd.filename)) return;
		if(fileProd.filesize == "") return;
		primary()
	}
	var coopThumbs = function() {
		if(!opCheck(coop)) return;
		image.regenerate = {
			"colour"=default,
			"status"=disabled,
			"value"='regeneratethumbs=0'
		}
		if(image.x400.size) {
			image.regenerate.colour = default
			image.regenerate.status = ''
			image.regenerate.value = 'regeneratethumbs=1'
		}
	}
	var coopTimestamps = function() {
		if(!opCheck(coop)) return;
		if(Len(fileProd.deletedat) && fileProd.deletedat != uuidNulled()){
			whois.del = model("users").findOneByUuid(value=fileProd.deletedby,includeSoftDeletes=true,returnAs="query")
		}
		if(Len(fileProd.updatedby) && fileProd.updatedby != uuidNulled()){
			whois.update = model("users").findOneByUuid(value=fileProd.updatedby,includeSoftDeletes=true,returnAs="query")
		}
	}
	var coopTips = function() {
		if(!opCheck(coop)) return;
		if(feedback.require.fail) {
			if(feedback.require.filename) feedback.require.hint &= "filename, ";
			if(feedback.require.platform) feedback.require.hint &= "tag platform, ";
			if(feedback.require.section) feedback.require.hint &= "tag section, ";
			if(feedback.require.for) feedback.require.hint &= "published for, ";
			if(Len(feedback.recommend.hint)) feedback.require.hint = Left(feedback.require.hint,Len(feedback.require.hint)-2) & "";
		}
		if(!feedback.recommend.fail) return;
		if(toggle.previewFlagged && toggle.thumb400) return;
		if(!toggle.previewFlagged && IsGraphic(fileProd.fileName)){
			feedback.recommend.hint &= "preview, "
		}
		if(filePackaged && !feedback.recommend.zip){
			feedback.recommend.hint &= "package item count, "
		}
		if(fileProd.section == 'magazine' && !feedback.recommend.title){
			feedback.recommend.hint &= "magazine issue or volume, "
		}
		if(!toggle.thumb400){
			feedback.recommend.hint &= "thumbnails preview, "
		}
		if(!feedback.recommend.download){
			feedback.recommend.hint &= "a file to download hosted on this server, "
		}
		// this must be last
		if(Len(feedback.recommend.hint)){
			feedback.recommend.hint = Left(feedback.recommend.hint,Len(feedback.recommend.hint)-2) & ""
		}
	}
	var doseeApp = function() {
		var enable = function() {
			dosee.state	= true
			dosee.value	= 0
			dosee.icon = 'plus-square'
			if(loadDOSee) dosee.colour = 'brand-success'
		}
		// check to see if DOSee emulation is enabled by user
		if(loadDOSee) dosee.colour = 'brand-danger'
		dosee.icon	= 'minus-square'
		if(!StructKeyExists(client,"display")) enable()
		if(!StructKeyExists(client.display,"emu")) enable()
		if(client.display['emu'] == 1) enable()
		var args = 'id=settings&emulation=#dosee.value#&obfuscatedKey=#obfuscateParam(fileProd.id)#'
		if(len(params.src)) args = listInsertAt(args,2,"src=#params.src#","&");
		if(len(positionQuery)) args &= positionQuery;
		dosee.url = URLFor(controller='file',action='adjustdisplay',params=args)
		if(!dosee.state || !loadDOSee) toggle.dosee = false
	}
	var initialisms = function() {
		variables.initialism = {
			"group_brand_by":groupInitialism(fileProd.group_brand_by),
			"group_brand_for":groupInitialism(fileProd.group_brand_for),
		}
	}
	var linksPulldown = function() {
		var green = "border-color:##5cb85c;"
		var gby = deobfuscateURL(fileProd.group_brand_by)
		var gfor = deobfuscateURL(fileProd.group_brand_for)
		var where = ""
		var sel = "id,categorysort,comment,date_issued_day,date_issued_month,date_issued_year,title,uriRef"
		if(Len(gfor)) {
			where = "title LIKE '#Trim(gfor)# %' OR title = '#Trim(gfor)#'"
			if(Len(gby)) {
				where = "(#where# OR title LIKE '#Trim(gby)# %' OR title = '#Trim(gby)#')"
			}
		}
		else if(Len(gby)) where = "(title LIKE '#Trim(gby)# %' OR title = '#Trim(fileProd.group_brand_by)#')"
		if(Len(where)) {
			websites = model("Link").findAll(select=sel,where=where,order="uriref DESC",returnAs="query",includeSoftDeletes="false")
		}
		else websites = model("Link").findAll(select=sel,maxRows="0");
		if(websites.recordCount) button.link.style = green
		if(Len(fileProd.web_id_pouet)) button.link.style = green
		if(Len(fileProd.web_id_demozoo)) button.link.style = green
		if(Len(fileProd.web_id_github)) button.link.style = green
		if(Len(fileProd.list_links)) button.link.style = green
	}
	var navigation = function() {
		variables.idPosition = variables.idPosition ?: 1;
		variables.idCount = variables.idCount ?: 1;
		variables.nav.btn = { "prev":"","next":"","first":"","last":"",}
		if(!Len(nav.rec.prev)) nav.btn.prev = disabled
		if(!Len(nav.rec.next)) nav.btn.next = disabled
		if(!Len(nav.rec.first)) nav.btn.first = disabled
		if(!Len(nav.rec.last)) nav.btn.last = disabled
	}
	var zipCommentApp = function() {
		zipComment.exists = FileExists(zipComment.file)
	}
	var retroTxtApp = function() {
		if(isBoolean(fileProd.retrotxt_no_readme) && fileProd.retrotxt_no_readme) {
			toggle.retrotxt = false
			return
		}
		retroTxt.exists = FileExists(retroTxt.file)
		// determine if file is plain text and can be used as a source
		// 'with escape sequences' usually means ANSI control codes
		if(right(retroTxt.mime,21) == "with escape sequences") return;
		if(isDocument(fileProd.filename) && fileProd.platform != "ansi") toggle.retrotxt = true;
		else if(left(retroTxt.mime,13) == "ISO-8859 text" && !isAnsi(fileProd.filename)) toggle.retrotxt = true;
		else if(left(retroTxt.mime,27) == "Non-ISO extended-ASCII text") toggle.retrotxt = true;
		else if(left(retroTxt.mime,10) == "ASCII text") toggle.retrotxt = true;
		else if((fileProd.platform == "text" || fileProd.platform == "textamiga") && retroTxt.mime == "" && IsArchive(fileProd.fileName) == false) {
			toggle.retrotxt = true; // special case where textfiles have unusual file extensions
		}
		if(toggle.retrotxt && !retroTxt.exists) {
			// if the uuid.txt file does not exists, but toggle.retrotxt is true,
			// then display the file download in retrotxt
			retroTxt.file = retroTxt.path
			// confirm the source text file exists
			toggle.retrotxt = FileExists(retroTxt.file)
		}
		if(toggle.retrotxt) {
			retroTxt.exists = true;
			return;
		}
		// otherwise if retroTxt.file exists, use that as the source
		if(filePackaged && retroTxt.exists) {
			toggle.retrotxt = true;
			return
		}
		// invalid user supplied filename
		if(fileProd.retrotxt_no_readme == 1) return;
		if(!filePackaged) return;
		if(retroTxt.exists) return;
		if(!len(fileProd.retrotxt_readme)) return;
		variables.feedback.error = false
	}
	var chiptune = function() {
		if (IsChiptune(fileProd.filename)) {
			toggle.chiptune = true
			return
		}
		var path = "/#fileProd.uuid#.chiptune"
		toggle.chiptune = FileExists(get(myapp).fulldirFileUuid & path)
	}
	var screenshots = function() {
		var path = "/#fileProd.uuid#.png"
		toggle.previewExists = FileExists(get(myapp).fulldirPreview & path)
		toggle.previewFlagged = toggle.previewExists
		if(opCheck(coop)) {
			toggle.thumb400 = FileExists(get(myapp).fulldirThumb400 & path)
		}
	}
	var textInBrowser = function() {
		if(fileProd.section == "nfotool") return true;
		if(fileProd.section == "releaseinformation") return true;
		if(fileProd.platform == "text") return true;
		if(fileProd.platform == "textamiga") return true;
		return false
	}
	var title = function() {
		var text = function() {
			if(fileProd.section == "magazine" && len(fileProd.record_title)) {
				return "#fileProd.group_brand_for#, #fileProd.record_title#"
			}
			if(Len(fileProd.record_title)) return fileProd.record_title
			return fileProd.filename
		}
		var glyph = function() {
			if(Len(fileProd.createdat) && Len(fileProd.deletedat) && !Len(fileProd.deletedby)) {
				return 'fal fa-folder brand-warning'
			}
			if (Len(fileProd.createdat) && Len(fileProd.deletedat)) {
				return 'fal fa-folder brand-danger'
			}
			return 'fal fa-folder-open'
		}
		var html = '<span>#XMLFormat(removeTags(text(),""))#</span>'
		// append publishers
		if(len(fileProd.group_brand_for) && fileProd.section != "magazine") {
			html &= '<small><small>'
			if(len(fileProd.group_brand_by)) html &= ' &nbsp; for'
			else html &= ' &nbsp; by'
			html &= "</small> #fileProd.group_brand_for##initialism.group_brand_for#</small>"
		}
		if(len(fileProd.group_brand_by)) {
			html &= " &nbsp; <small><small>by</small> #fileProd.group_brand_by##initialism.group_brand_by#</small> "
		}
		// append source code notice
		if(len(fileProd.web_id_github)) {
			html &= ' <small>+ #linkTo(text="SOURCE CODE",href="https://github.com/#fileProd.web_id_github#")#</small>'
		}
		pageAbout.icon = glyph()
		pageAbout.text = html
	}
	var youtube = function() {
		// check to see if youtube player is enabled by user
		var ui = {
			"colour":'',
			"icon":'minus-square',
			"state":false,
			"url":'',
			"value":1,
		}
		if(Len(fileProd.web_id_youtube)) ui.colour = 'brand-danger';
		if(!structKeyExists(client,"display") || !structKeyExists(client.display,"yt") || client.display['yt'] == 1) {
			ui.state = true
			ui.value = 0
			ui.icon	= 'plus-square'
			if(Len(fileProd.web_id_youtube)) ui.colour = 'brand-success';
		}
		var args = 'id=settings&youtubeplayer=#ui.value#&obfuscatedKey=#obfuscateParam(fileProd.id)#'
		if(len(params.src)) args = listInsertAt(args,2,"src=#params.src#","&");
		if(len(positionQuery)) args &= positionQuery;
		ui.url = URLFor(controller='file',action='adjustdisplay',params=args)
		variables.youTubeUI = ui
		if(ui.state && Len(fileProd.web_id_youtube)) toggle.youtube = true;
	}
	// shared vars
	variables.button = {
		"link":{
			"style":"",
		},
		"activation":{
			"colour":"",
			"icon":"",
			"value":"",
		},
	}
	variables.column = {
		"left":"col-lg-4 col-md-6 col-sm-12",
		"middle":"col-lg-2 col-md-6 col-sm-12",
		"right":"col-lg-6 col-md-12 col-sm-12",
	}
	variables.dosee = {
		"colour":'',
		"icon":'',
		"state":false,
		"value":1,
		"url":'',
	}
	variables.feedback = {
		"error":true,
		"hints":"",
		"require":{
			"filename":"",
			"for":"",
			"hint":"",
			"section":"",
			"platform":"",
			"fail":false,
		},
		"recommend":{
			"download":"",
			"hint":"",
			"title":"",
			"zip":"",
			"fail":false,
		},
	}
	variables.image = {
		"screenshot":{
			"size":0,
			"disableCache":"",
		},
		"x400":{
			"size":0,
			"text":'',
			"disableCache":"",
		},
		// coop
		"generate":{
			"colour":"",
			"status":"",
			"value":"",
		},
		"regenerate":{
			"colour":"",
			"status":"",
			"value":"regeneratethumbs=0",
		},
		"kill":{
			"colour":"",
			"status":"",
			"value":"killimages=0",
		},
		"scan":{
			"colour":"",
			"status":"",
			"value":"rescanpackage=0",
		}
	}
	variables.zipComment = {
		"exists":false,
		"file":"#get(myapp).fulldirfileuuid#/#fileProd.uuid#_zipcomment.txt",
	}
	variables.retroTxt = {
		"exists":false,
		"path":"#get(myapp).fulldirfileuuid#/#fileProd.uuid#",
		"file":"#get(myapp).fulldirfileuuid#/#fileProd.uuid#.txt",
		"mime":trim(fileProd.file_magic_type),
	}
	variables.whois = {
		"del":{
			"username":"",
		},
		"update":{
			"username":"",
		},
	}
	variables.toggle = {
		"audio":IsAudio(fileProd.filename),
		"inBrowserText":textInBrowser(),
		"chiptune":false,
		"dosee":loadDOSee,
		"credits":false,
		"retrotxt":false,
		"thumb400":false,
		"youtube":false,
		"zipComment":false,
	}
	if(fileProd.group_brand_for == fileProd.group_brand_by) fileProd.group_brand_by = "";
	// breadcrumb navigation
	breadcrumbs &= crumbTrail(params, 1, params.key)
	chiptune()
	screenshots()
	youtube()
	retroTxtApp()
	zipCommentApp()
	if(toggle.inBrowserText && toggle.retrotxt) {
		// disable screenshot when the file is text and RetroTxt is in use
		toggle.previewFlagged = false;
	}
	doseeApp()
	coopImageCache()
	linksPulldown()
	navigation()
	initialisms()
	badges()
	title()
	coopScreenshots()
	coopThumbs()
	coopDeleteImages()
	coopArchive()
	coopActivation()
	coopTimestamps()
	coopErrors()
	coopTips()
	coopAlerts()
</cfscript>
<cfoutput><cfif opCheck(coop)>#includePartial("/file/prod_admin")#</cfif>
<span id="youtubeIDValue" class="hidden">#fileProd.web_id_youtube#</span>
<div class="contain" id="file-detail">
	<!--- Pagination --->
	#includePartial("/file/prod_navigation")#
	<cfif !opCheck(coop)>
	<!--- Statistics --->
	#includePartial("/file/prod_badges")#
	<!--- Flash messages --->
	#includePartial("/file/prod_flash")#
	</cfif>
	<!--- Details --->
	<!--- production info from 3rd party APIs --->
	<div id="float-container">
	<div id="file-detail-container-text img-responsive">
	<!--- File information --->
	<div class="row">
	<!--- LEFT pane --->
		<div class="#column.left#">
			#includePartial('/file/prod_core')#
			<cfif toggle.audio>
			#includePartial('/file/prod_audio')#
			</cfif>
			<cfif toggle.chiptune>
			#includePartial('/file/prod_chiptune')#
			</cfif>
			<cfif toggle.dosee>
			#includePartial('/file/prod_dosee')#
			<cfelseif toggle.youtube>
			#includePartial('/file/prod_youtube')#
			<cfelseif toggle.previewFlagged>
			#includePartial('/file/prod_screenshot')#
			</cfif>
		</div>
	<!-- CENTER pane -->
		<div class="#column.middle#">
			<cfif opCheck(coop)>
			<div class="row"><div class="col-lg-12"><div class="thumbnail">
				<a href="#admin.400Link##image.x400.disableCache#" class="thumbnail" style="background-color:##eee">
				<img width="400" height="400" src="#admin.400Link##image.x400.disableCache#" alt="#image.x400.text#" class="capture-400x" title="400 x 400 pixel thumbnail preview">
				</a>
				<div class="caption">400px thumbnail, size #humanizeFileSize(Val(image.x400.size))#</div>
			</div></div></div></cfif>
			<cfif Len(trim(fileProd.file_zip_content))>
			#includePartial('/file/prod_archive-dir')#
			</cfif>
			#includePartial("/file/prod_pouet")#
			#includePartial("/file/prod_demozoo")#
		</div>
	<!--- RIGHT pane --->
		<div class="visible-md-block"></div>
		<div class="#column.right#">
	<!--- Operator editing dialogues --->
			<cfif opCheck(coop)>
			#includePartial("/file/prod_admin-core")#
			<cfelseif toggle.retrotxt or zipComment.exists>
			#includePartial('/file/prod_retrotxt')#
			</cfif>
		</div>
	</div>
	</div>
</div>
</cfoutput>