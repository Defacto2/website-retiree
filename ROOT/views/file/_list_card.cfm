<!---
	List files in "cards view", partial view.
	path: views/files/_list_card.cfm

@CFLintIgnore
--->
<cfscript>
	var download = function() {
		var data = {
			"action":"",
			"title":"",
			"disabled":"disabled",
		}
		data.action = filedownloadTo(key=obfuscateParam(collectionFiles.id),format="urlfor",params="filename=#collectionFiles.filename#")
		data.title = "Download #XMLFormat(collectionFiles.filename)# @ #humanizeFileSize(Val(collectionFiles.filesize))#"
		if(collectionFiles.filesize != "" && collectionFiles.file_security_alert_url == "") data.disabled = "";
		return data;
	}
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
	var footer = function() {
		var fors = collectionFiles.group_brand_for
		var bys = collectionFiles.group_brand_by
		var forText = XMLFormat(titleize(fors))
		var byText = XMLFormat(titleize(bys))
		var forLink = ""
		var byLink = ""
		if(Len(fors)) forLink = URLFor(route="g",orgname="#obfuscateURL(fors)#",encode=false,params=urlParams())
		if(Len(bys)) byLink = URLFor(route="g",orgname="#obfuscateURL(bys)#",encode=false,params=urlParams())
		if(params.controller == 'organisation') {
			if(variables.citename == fors && Len(bys)) {
				return urlParamFix(LinkTo(text=byText,"aria-label"=byText,href=byLink))
			}
			if(variables.citename == bys && Len(fors)) {
				return urlParamFix(LinkTo(text=forText,"aria-label"=forText,href=forLink))
			}
			return
		}
		if(Len(fors) && Len(bys)) {
			return urlParamFix(LinkTo(text=byText,"aria-label"=byText,href=byLink))
		}
		if(Len(bys) && Len(fors)) {
			return urlParamFix(LinkTo(text=forText,"aria-label"=forText,href=forLink))
		}
		return
	}
	// colourise filename for operator information
	var formatHeader = function() {
		collectionFiles.uuid = LCase(collectionFiles.uuid)
		card.title = fileTitle(collectionFiles)
		if(collectionFiles.section == 'magazine') card.title = '#collectionFiles.record_title# - #collectionFiles.group_brand_for#'
		titleLink = '<span class="thumb-anchor"></span>'
		writeOutput(includePartial('../file/list_shared-linkto'))
		btnToDetails = urlFor(route="f",key=obfuscateParam(collectionFiles.id),params=linkParams)
		// conditions
		if(Len(collectionFiles.web_id_github)) card.github = true;
		else card.github = false;
		if(emulateFile(collectionFiles)) card.dosee = true;
		else card.dosee = false;
		if(collectionFiles.filesize != "" && Len(collectionFiles.file_security_alert_url)) card.danger = true;
		else card.danger = false;
		card.buttonClass = "btn-default"
		if(opCheck('coop')) {
			card.buttonClass = "btn-#fileState(collectionFiles)#"
			if(card.buttonClass is "btn-") card.buttonClass = "btn-default";
		}
		if(Len(collectionFiles.deletedat)) card.buttonDelete = "softdeleted";
		else card.buttonDelete = '';
		if(Len(card.buttonDelete)) card.buttonDelete = ' ' & card.buttonDelete
	}
	var header = function() {
		if(Len(collectionFiles.group_brand_for)) {
			local.pubForRef = URLFor(route="g",orgname=obfuscateURL(collectionFiles.group_brand_for),params=urlParams())
		}
		if(Len(collectionFiles.group_brand_by)) {
			local.pubByRef = URLFor(route="g",orgname=obfuscateURL(collectionFiles.group_brand_by),params=urlParams())
		}
		local.pubForTxt = XMLFormat(titleize(collectionFiles.group_brand_for))
		local.pubByTxt = XMLFormat(titleize(collectionFiles.group_brand_by))
		if(params.action != "info" && Len(collectionFiles.group_brand_for)) {
			return urlParamFix(LinkTo(text=pubForTxt,"aria-label"=pubForTxt,href=pubForRef))
		}
		if(Len(collectionFiles.group_brand_by)) {
			return urlParamFix(LinkTo(text=pubByTxt,"aria-label"=pubByTxt,href=pubByRef))
		}
		return "Missing info!";
	}
	var publishDate = function() {
		var data = collectionFiles
		var date = ""
		var month = ""
		if(!Len(data.date_issued_year) && !Len(data.date_issued_month) && !Len(data.date_issued_day)) return ""
		if(Len(data.date_issued_year)) date &= ' ' & data.date_issued_year
		if(Len(data.date_issued_month) && IsNumeric(data.date_issued_month)) {
			month = MonthAsString(data.date_issued_month);
			if(len(month) gt 5) month = left(month,3) & "."
			date &= ' ' & month
		}
		if(Len(data.date_issued_day)) date &= ' ' & data.date_issued_day
		return trim(date);
	}

	var card = {
		"buttonClass":'btn-default',
		"buttonDelete":'btn-default',
		"danger":false,
		"dosee":false,
		"id": -1,
		"title": '',
	}

	var fixes = function() {
		if(collectionFiles.group_brand_for == collectionFiles.group_brand_by) collectionFiles.group_brand_by = "";
	}
</cfscript>
<!--- thumbnail container with information and links --->
<cfoutput>
	<cfloop query="collectionFiles">
		<cfset card.id++>
		#fixes()#
		#formatHeader()#
		<!--- thumbnail container for display --->
		<div class="file-as-card file-thumbnail#card.buttonDelete#">
			<cfif params.controller != 'Organisation'><h2 class="thumb-info-text">#header()#</h2></cfif>
			<i id="tuuid-#params.page#_#card.id#" class="uuid">#collectionFiles.uuid#</i>
			<div>
				<!--- thumbnail as background image and link --->
				<div class="capture-400x #missingThumb(collectionFiles.platform)#" id="thumb-#params.page#_#card.id#">
					<!--- database id --->
					<cfif opCheck('sysop')>
						<small class="label label-warning" style="margin-left:0.25em;">#NumberFormat(collectionFiles.id,'00000')#</small>
					</cfif>
					#linkToDetails#
				</div>
				<div class="thumb-icon-links right">
					<!--- links --->
					<form method="post">
						<fieldset class="btn-group btn-group">
						<cfif collectionFiles.platform neq "dos" and collectionFiles.platform neq "windows">
							<cfset local.dlbtn = download()>
							<!--- direct download button --->
							<button type="submit" data-container="body" class="btn btn-default" formaction="#dlbtn.action#" title="#dlbtn.title#" data-toggle="tooltip" data-placement="bottom" #dlbtn.disabled#><i class="fal fa-download fa-fw fa-lg"></i></button>
						</cfif>
							<!--- detail page button --->
							<button type="submit" data-container="body" formmethod="post" class="btn #card.buttonClass#" formaction="#btnToDetails#" title="More information" data-toggle="tooltip" data-placement="right"><i class="fal fa-info-circle fa-fw fa-lg"></i></button>
						</fieldset>
					</form>
					<!--- file type --->
					<span class="label label-info" data-toggle="tooltip" data-placement="top" title="#Replace(humanizeFileFormat(collectionFiles.fileName,collectionFiles.platform),' / ','/')# filed under #Lcase(getSectionName(collectionFiles.section))#">#Replace(humanizeFileFormat(collectionFiles.fileName,collectionFiles.platform),' / ','/')#</span>
					<!--- date --->
					<p><small>#publishDate()#</small></p>
					<!--- additional badges --->
					<div>
						<cfif card.github>
							<!--- github --->
							<span title="Source code is hosted on GitHub" data-toggle="tooltip" data-placement="bottom">
								#svg(icon='github',size='lg',class='fa-border')#
							</span>
						</cfif>
						<cfif card.dosee>
							<!--- emulation --->
							<span title="Can emulate in browser" data-toggle="tooltip" data-placement="bottom">
								#svg(icon='dosee',size='lg',class='fa-border text-success')#
							</span>
						</cfif>
						<cfif card.danger>
							<!--- viruses --->
							<span class="label label-danger" title="This file maybe infected with a potential virus or trojan, please see this report for further information" data-toggle="tooltip" data-placement="bottom">
								<a aria-label="Virus or trojan report" href="#urlFor(href="#collectionFiles.file_security_alert_url#")#"><i class="fal fa-exclamation-circle fa-fw fa-lg" style="color:white;"></i></a>
							</span>
						</cfif>
					</div>
				</div>
			</div>
			<div class="thumb-info">
				<!--- title --->
				<p title="#XMLFormat(card.title)#" class="thumb-info-text">#XMLFormat(card.title)#</p>
				<!--- file name --->
				<cfif Len(collectionFiles.record_title) && Len(collectionFiles.filename)>
					<p class="thumb-info-text"><code>#XMLFormat(collectionFiles.filename)#</code></p>
				</cfif>
				<!--- additional group info when viewing in controller --->
				<p><small>#footer()#</small></p>
			</div>
		</div>
	</cfloop>
</cfoutput>