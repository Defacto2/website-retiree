<!---
    File details core partial view.
	path: views/files/_prod_core.cfm

@CFLintIgnore
--->
<cfscript>
	var description = function(string text="") {
		if(!len(arguments.text)) return ""
		return autoLink(text=capitalize(removeTags(arguments.text)),relative=false)
	}
	var dateOfPublication = function() {
		if(!Len(fileProd.date_issued_year) && !Len(fileProd.date_issued_month) && !Len(fileProd.date_issued_day)) return "n/a"
		var date = ""
		if(Len(fileProd.date_issued_year)) date &= fileProd.date_issued_year & ' '
		if(Len(fileProd.date_issued_month) && IsNumeric(fileProd.date_issued_month)) date &= MonthAsString(fileProd.date_issued_month) & ' '
		if(Len(fileProd.date_issued_day)) date &= fileProd.date_issued_day
		return trim(date)
	}
	var download = function() {
		var name = "filename=#fileProd.filename#"
		var key = obfuscateParam(fileProd.id)
		if(name contains "&") name = ReplaceNocase(name,'&', '+', 'all');
		var link = "#URLFor(route="d",key=key,params=name)#"
		if(name contains "&") link = ReplaceNocase(link,'=" title=','" title=','first');
		return link;
	}
	var figurePlay = function() {
		figure.text = ""
		figure.icon = ""
		var readable = "pdf,htm,html"
		if(IsVideo(fileProd.filename)) {
			figure.text = "Watch";
			return figure.icon = "play"
		}
		if(_isFileType(fileProd.filename, readable)) {
			figure.text = "Read";
			return figure.icon = "book-open"
		}
		if(useViewFile(fileProd.filename, figure.filesize, fileProd.platform)){
			figure.text = "View in tab";
			return figure.icon = "browser"
		}
	}
	var formatCode = function(string platform) {
		var magic = fileProd.file_magic_type
		if(left(magic,18) eq "ERROR: cannot open") return "error"
		var split = magic.ListtoArray(",",true)
		if(split.first() eq "saved news") return ArrayToList(split.deleteat(1),",");
		if(left(magic,16) eq "Zip archive data") return "Zip archive data"
		return magic;
	}
	var href = function() {
		switch(ListLast(fileProd.filename,'.')) {
			case 'arc': case 'ark':
				return "http://fileformats.archiveteam.org/wiki/ARC_(compression_format)"
			case 'gz': case 'tar.gz':
				return "http://fileformats.archiveteam.org/wiki/Gzip"
			default: // 7z,arj,cab,lha,lzh,rar,tar,zip
				return "http://fileformats.archiveteam.org/wiki/#UCase(ListLast(fileProd.filename,'.'))#"
		}
	}
	var detail = {
		"about":{
			"href":"",
			"display":"none",
		},
		"lastMod":{
			"display":"none",
			"format":"",
		},
		"display":"none",
		"download":{
			"class":"primary",
			"disabled":"",
		}
	}
	var figure = {
		"fileSize":0,
		"icon":"",
		"text":"",
	}
	if(len(fileProd.file_last_modified)) {
		detail.lastMod.format = DateFormat(fileProd.file_last_modified,"medium") & ' ' & TimeFormat(fileProd.file_last_modified,"medium")
		detail.lastMod.display = 'block'
	}
	if(len(fileProd.file_integrity_weak)) detail.display = ''
	if(IsNumeric(fileProd.filesize) && fileProd.filesize) figure.filesize = fileProd.filesize
	if(useViewFile(fileProd.filename, figure.filesize, fileProd.platform)) figurePlay();

	if(Len(fileProd.file_security_alert_url)) {
		detail.download.class = "default"
		detail.download.disabled = "disabled"
	}
	var filedownload = " active"
	var filepanel = "default"
	if(Len(fileProd.file_security_alert_url)) {
		filedownload = ""
		filepanel = "danger"
	}
	var relations = ''
	loop list="#fileProd.list_relations#" delimiters="|" index="local.relation" {
		if(listLen(relation, ";") != 2) continue;
		var key = listGetAt(relation,2,";")
		if(isNumeric(key)) key = obfuscateParam(key)
		relations &= '<span class="nowrap"><i class="fal fa-folder-open fa-fw"></i> '
		relations &= linkTo(text="#capitalize(listGetAt(relation,1,";"))#",route="f",key=key)
		relations &= '</span> &nbsp; '
	}
</cfscript>
<cfoutput>
<span id="shareThisLink" class="hidden">#URLFor(protocol="https",host="defacto2.net",onlyPath=false,route="f",key=obfuscateParam(fileProd.id))#</span>
<form id="downloadLinkForm" action="#download()#" class="hidden"></form>
<form id="viewInTabForm" action="#URLFor(controller='file',action='view',key=obfuscateParam(fileProd.id))#" class="hidden"></form>
<form id="githubForm" action="https://github.com#fileProd.web_id_github#" class="hidden"></form>
	<!--- Download link --->
	<div class="panel panel-#filepanel#">
		<ul class="list-group">
			<cfif opCheck('coop')> &nbsp; <span><kbd class="pull-right text-uppercase">Ctrl+Alt+D</kbd></span></cfif>
			<a href="#URLFor(route='d',key=obfuscateParam(fileProd.id))#" id="downloadLinkRef" class="list-group-item#filedownload#">
			<h4 class="list-group-item-heading"><strong>Download</strong> #fileProd.filename#</h4>
			<p class="list-group-item-text">Size #humanizeFileSize(Val(fileProd.fileSize))#</p>
			</a><cfif Len(fileProd.file_security_alert_url)>
			<li class="list-group-item list-group-item-danger">
				<div><strong>Google has marked this file as malicious or unwanted software</strong></div>
				<div><small>
				Please read the #linkTo(href="#fileProd.file_security_alert_url#",text="VirusTotal report")# before continuing.
				However, if you still wish to obtain this file, you need to paste this exact link into the browser address bar.
				</small></div>
				<code>//#application.domain#/d/#obfuscateParam(fileProd.id)#?#unwantedSoftware#</code>
			</li></cfif>
			<li class="list-group-item">
			<cfif fileProd.platform eq "dos">
				<small>This download is an executable MS-DOS program that <strong>will not run on a modern computer</strong>.</small>
				<small>It needs a DOS emulator such as <a href="https://dosbox-x.com/">DOSBox-X</a>, <a href="https://dosbox-staging.github.io/">Staging</a>;
					or a virtualized MS-DOS or <a href="https://www.freedos.org/">FreeDOS</a> system.</small><br>
			</cfif>
			<cfif fileProd.platform eq "windows">
				<small>This download is a Windows program, but <strong>it should only be run on your computer if you trust it</strong>.</small>
				<small>Instead, run it isolated in <a href="https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview">Windows Sandbox</a>, <a href="https://www.virtualbox.org/">VirtualBox</a> or <a href="https://www.parallels.com/">Parallels</a>.</small><br>
			</cfif>
				<small>Browsers may flag this download as <a href="https://developers.google.com/search/docs/monitor-debug/security/malware##what-is-unwanted-software">unwanted</a> or malicious.
					If unsure, scan it with <a href="https://www.virustotal.com/">VirusTotal</a>.</small>
			</li>
			<li class="list-group-item">
				<small class="font-mono"><span class="gray-light">Last modified</span> <span class="gray">#detail.lastMod.format#</span></small><br>
				<small class="font-mono"><span class="gray-light">&nbsp;MD5 checksum</span> <span class="gray">#fileProd.file_integrity_weak#</span></small><br>
				<small class="font-mono"><span class="gray-light"> &nbsp; &nbsp; Mime type</span> <span class="gray">#formatCode(fileProd.platform)#</span></small>
			</li>
		</ul>
	</div>
	<!--- Date of publication and groups --->
	<div class="panel panel-info">
		<div class="panel-body">
			<h2 class="gray">#dateOfPublication()#</h2>
			<cfif Len(fileProd.group_brand_for) or Len(fileProd.group_brand_by)>
			<div class="lead"><cfif Len(fileProd.group_brand_for)>
			#linkTo(text="#XMLFormat(fileProd.group_brand_for)##initialism.group_brand_for#",route="g",orgname=obfuscateURL(fileProd.group_brand_for))#
			</cfif><cfif Len(fileProd.group_brand_for) and Len(fileProd.group_brand_by)><strong class="gray-light"> + </strong></cfif>
			<cfif Len(fileProd.group_brand_by)>
			#linkTo(text="#XMLFormat(fileProd.group_brand_by)##initialism.group_brand_by#",route="g",orgname=obfuscateURL(fileProd.group_brand_by))#
			</cfif></div></cfif>
			<cfif(len(trim(fileProd.comment)))><div class="gray"><small>#description(fileProd.comment)#</small></div></cfif>
		</div>
		<ul class="list-group">
			<!-- platform, category information -->
			<li class="list-group-item gray">
				<span title="#getPlatformDescription(fileProd.platform)#" class="nowrap">
					#svg(icon='platform-#fileProd.platform#',title='Platforms')#
<cfif fileProd.section eq "package">
	<cfswitch expression="#fileProd.platform#">
	<cfcase value="ansi">ANSI artpack</cfcase>
	<cfcase value="audio">Music pack</cfcase>
	<cfcase value="database">Database or spreadsheet filepack</cfcase>
	<cfcase value="dos">MS-DOS software pack</cfcase>
	<cfcase value="image">Image pack</cfcase>
	<cfcase value="text">ASCII artpack, NFO or text pack</cfcase>
	<cfcase value="windows">Windows software pack</cfcase>
	<cfdefaultcase>Filepack</cfdefaultcase>
	</cfswitch><cfelse>
	#humanizeFileFormat(fileProd.filename,fileProd.platform,false)#</span>
	<span class="gray-light">/</span>
	<span title="#getSectionDescription(fileProd.section)#">#getSectionName(fileProd.section)#</span>
</cfif>
			</li>
			<cfif listLen(fileProd.list_links,"|")>
				<!-- websites -->
				<li class="list-group-item">
					<cfloop list="#fileProd.list_links#" delimiters="|" index="local.link">
						<cfif listLen(link,";") gte 1>
							<span class="nowrap"><i class="fal fa-external-link-square fa-fw"></i> <a href="#listGetAt(link,2,";")#">#listGetAt(link,1,";")#</a></span><span class="left-1em"></span>
						<cfelse>
							<span class="nowrap"><i class="fal fa-external-link-square fa-fw"></i> <a href="#link#">#link#</a></span>
						</cfif>
					</cfloop>
				</li>
			</cfif>
			<cfif len(relations)>
				<!-- links to related productions -->
				<li class="list-group-item">#relations#</li>
			</cfif>
			<li class="list-group-item">
				<!--- share this link --->
				<button id="copyLink" class="btn btn-info" type="button" style="margin-right:1em;">
					<span id="copyLinkIcon"><i class="fal fa-clipboard fa-fw"></i></span> <span id="copyLinkText">Share this link</span></button>
				<!--- view / play in browser --->
				<cfif len(figure.text)><button form="viewInTabForm" id="viewInTab" class="btn btn-default" title="#figure.text#" type="submit" aria-label="view file" style="margin-right:1em;">
					<i class="fal fa-#figure.icon# fa-fw"></i> <span>#figure.text#</span></button></cfif>
				<!--- source code / github --->
				<cfif Len(fileProd.web_id_github)>
					<button form="githubForm" id="viewInTab" class="btn btn-default" type="submit" aria-label="Goto the github repository" style="margin-right:1em;">
					<i class="fab fa-github fa-fw"></i> <span>Source code on GitHub</span></button>
				</cfif>
				<!--- shared links --->
				<cfif Len(fileProd.web_id_youtube)>
					&nbsp;
					<span class="nowrap">
						<i class="fab fa-youtube fa-fw"></i> #linkTo(text="YouTube",href="#get('myapp').youtube.watch##fileProd.web_id_youtube#")#
					</span>
				</cfif>
				<cfif Len(fileProd.web_id_demozoo)>
					&nbsp;
					<span class="nowrap">
						<i class="fal fa-external-link-square fa-fw"></i> #linkTo(text="Demozoo",href="#get('myapp').other.demozoo##fileProd.web_id_demozoo#")#
					</span>
				</cfif>
				<cfif Len(fileProd.web_id_pouet)>
					&nbsp;
					<span class="nowrap">
						<i class="fal fa-external-link-square fa-fw"></i> #linkTo(text="Pouët",href="#get('myapp').other.pouet##fileProd.web_id_pouet#")#
					</span>
				</cfif>
				<cfif Len(fileProd.web_id_16colors)>
					&nbsp;
					<span class="nowrap">
						<i class="fal fa-external-link-square fa-fw"></i> #linkTo(text="Sixteen Colors",href="#get('myapp').other.16colors##fileProd.web_id_16colors#")#
					</span>
				</cfif>
			</li>
			<!--- credits --->
			#includePartial('/file/prod_authors')#
		</ul>
	</div>
</cfoutput>