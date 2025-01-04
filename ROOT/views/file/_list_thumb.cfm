<!---
	List files in "thumbnails view", partial view.
	path: views/files/_list_thumb.cfm

@CFLintIgnore
--->
<cfscript>
	var about = function() {
		switch(collectionFiles.section) {
			case 'magazine':
				return '<div title="#thumb.title#" class="thumb-info-text">#collectionFiles.record_title# - #collectionFiles.group_brand_for#</div>'
			default:
				return '<div title="#thumb.title#" class="thumb-info-text">#thumb.title#</div>'
		}
	}
	var color = function() {
		if(!opCheck('coop')) return "btn-default";
		if(len(fileState(collectionFiles))) return 'btn-#fileState(collectionFiles)#';
		return 'btn-default'
	}
	var download = function() {
		thumb.danger = false
		if(!downloadAllowed(collectionFiles)) return 'disabled';
		if(Len(collectionFiles.file_security_alert_url)) {
			// enforce HTTPS to avoid browser alerts
			collectionFiles.file_security_alert_url = ReplaceNocase(collectionFiles.file_security_alert_url,'http://','https://')
			thumb.danger = true
		}
		return ""
	}
	var header2 = function() {
		if(params.controller == 'Organisation') return;
		var urlParams = function() {
			var output = params.output ?: "";
			var sort = params.sort ?: "";
			if(output == "") return ""
			if(sort == "") return ""
			return "output=#output#&platform=-&section=-&sort=#sort#"
		}
		var urlParamFix = function(string fix) {
			// note: 18/01/2021 URLFor() displays &section=- as §ion=- (§ = section sign)
			return replaceNoCase(fix,"&sect;ion", "&amp;section", "one")
		}
		var fors = collectionFiles.group_brand_for
		var bys = collectionFiles.group_brand_by
		if(params.action != 'info' && Len(fors)) {
			var html = '<a href="#urlParamFix(URLFor(route="g",orgname=obfuscateURL(fors),params=urlParams()))#" '
			html &= 'title="#XMLFormat(titleize(fors))#">#XMLFormat(titleize(fors))#</a>'
			return html;
		}
		if(Len(bys)) return '<a href="#urlParamFix(UrlFor(title=XMLFormat(titleize(bys)),route="g",orgname=obfuscateURL(bys),params=urlParams()))#">#XMLFormat(titleize(bys))#</a>'
	}
	var html = function() {
		if(!StructKeyExists(params,"sort")) return "";
		var header = ""
		switch(params.sort) {
			case "title": case "title_asc": case "title_desc":
				if(collectionFiles.AZ_SORT == "") return "?";
				return XMLFormat(UCase(Left(collectionFiles.AZ_SORT,1)));
			case "posted": case "posted_asc": case "posted_desc":
				if(collectionFiles.createdAt == "") return "Before<br>2006 July";
				header = DateFormat(collectionFiles.createdAt,'YYYY, MMMM, DD')
				return ReplaceNocase(header,',','<br>','first');
			case "date": case "date_asc": case "date_desc":
				if(collectionFiles.date_issued_year == "") return "?";
				return collectionFiles.date_issued_year;
			case "size_asc": case "size_desc":
				if(collectionFiles.fileSize == "") return "n/a";
				if(!collectionFiles.fileSize) return "n/a";
				return humanizeFileSize(Val(collectionFiles.fileSize));
			default: return ""
		}
	}
	var thumbnail = function() {
		thumb.id++
		if(Right(params.output,1) != "-") {
			thumb.active = html()
			if(len(thumb.active) && thumb.active != thumb.previous) {
				writeOutput('<div class="sort-header"><h1>#thumb.active#</h1></div>')
				thumb.previous = thumb.active
			}
		}
		collectionFiles.uuid = LCase(collectionFiles.uuid)
		title()
	}
	var title = function() {
		thumb.title = fileTitleDate(collectionFiles)
		titleLink = '<span class="thumb-anchor" title="#thumb.title#"></span>'
		writeOutput(includePartial('../file/list_shared-linkto'))
		thumb.action = urlFor(route="f",key=obfuscateParam(collectionFiles.id),params=linkParams)
	}
	// set thumbnail vars and classes
	var thumb = {
		"action": '',
		"active": '',
		"container": 'file-thumbnail',
		"danger": false,
		"id": -1,
		"previous": '',
		"title": ''
	}
	if(Len(collectionFiles.deletedat)) thumb.container &= ' softdeleted'
</cfscript>
<!--- thumbnail container with information and links --->
<cfoutput>
	<cfloop query="collectionFiles">
		#thumbnail()#
		<!--- thumbnail container for display --->
		<div class="file-as-thumb #thumb.container#">
		<h2 class="thumb-info-text">#header2()#</h2>
		<!--- thumbnail as background image and link --->
		<i id="tuuid-#params.page#_#thumb.id#" class="uuid">#collectionFiles.uuid#</i>
		<div class="capture-400x #missingThumb(collectionFiles.platform)#" id="thumb-#params.page#_#thumb.id#">#linkToDetails#</div>
		#about()#
		<div class="thumb-file-info">
			<span class="label label-info" title="#Replace(humanizeFileFormat(collectionFiles.fileName,collectionFiles.platform),' / ','/')# filed under #Lcase(getSectionName(collectionFiles.section))#">#Replace(humanizeFileFormat(collectionFiles.fileName,collectionFiles.platform),' / ','/')#</span>
			<cfif emulateFile(collectionFiles)>
				<small class="label label-success" title="Can emulate in browser">#svg(icon='dosee',style='color:white;')#</small>
			<cfelseif opCheck('sysop')>
				<small class="label label-warning">#NumberFormat(collectionFiles.id,'00000')#</small>
			</cfif>
			<cfif Len(collectionFiles.web_id_github)>
				<small class="label label-default" title="Source code is hosted on GitHub">#svg(icon='github')#</small>
			</cfif>
		</div>
		<div class="thumb-icon-links">
			<form method="post">
				<fieldset class="btn-group btn-group">
					<cfif collectionFiles.platform neq "dos" and collectionFiles.platform neq "windows">
					<!--- direct download --->
					<button type="submit" data-container="body" #download()# class="btn btn-default" formaction="#filedownloadTo(key="#obfuscateParam(collectionFiles.id)#",format="urlfor",params="filename=#collectionFiles.filename#")#" data-toggle="tooltip" data-placement="top" title="Download #XMLFormat(collectionFiles.filename)# @ #humanizeFileSize(Val(collectionFiles.filesize))#"><i class="fal fa-download fa-fw fa-lg"></i></button>
					</cfif>
					<!--- detail page --->
					<button type="submit" data-container="body" formmethod="post" class="btn #color()#" formaction="#thumb.action#" title="More information" data-toggle="tooltip" data-placement="top"><i class="fal fa-info-circle fa-fw fa-lg"></i></button>
					<cfif thumb.danger>
						<!--- warning of potential virus --->
						<button type="submit" data-container="body" class="btn btn-danger" formaction="#collectionFiles.file_security_alert_url#" data-toggle="tooltip" data-placement="bottom" title="This file maybe infected with a potential virus or trojan, please see this report for further information"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i></button>
					</cfif>
				</fieldset>
			</form>
		</div>
		</div>
	</cfloop>
</cfoutput>