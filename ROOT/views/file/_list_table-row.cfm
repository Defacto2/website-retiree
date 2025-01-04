<!---
	Row item in "table view", partial view.
	path: views/files/_list_table-row.cfm

@CFLintIgnore
--->
<cfscript>
	var fileToDownload = function() {
		var cell = '<td></td>'
		if(collectionFiles.platform eq "dos" or collectionFiles.platform eq "windows") return cell;
		if(downloadAllowed(collectionFiles)) {
			var params = 'filename=#collectionFiles.filename#'
			// colourise filename for operator information
			var attribute = ""
			var class = fileState(collectionFiles)
			if(Len(class)) attribute = ' class="#class#"'
			var dlclass = "brand-default";
			if(collectionFiles.filesize != '' && Len(collectionFiles.file_security_alert_url)) dlclass = "brand-danger";
			var icon = '<i class="fal fa-download fa-fw fa-lg #dlclass#"></i>'
			var link = filedownloadTo(text=icon,title="Download",key=obfuscateParam(collectionFiles.id),params=params)
			cell = '<td#attribute#>#link##canEmulate#</td>'
		}
		return cell
	}
	var groups = function() {
		var fors = ""
		var bys = ""
		try {
			if(params.action != 'info' && Len(collectionFiles.group_brand_for)) {
				var initalism = groupInitialism(collectionFiles.group_brand_for)
				fors = ' '
				fors &= LinkTo(text='#display.group_brand_for#',route='g',orgname=obfuscateURL(collectionFiles.group_brand_for),params=urlParams())
				if(initalism != '') fors &= '<small>#initalism#</small>'
			}
		} catch(any err) {
			fors = 'error #cfcatch.Message#'
		}
		if(Len(collectionFiles.group_brand_by)) {
			var initalism = groupInitialism(collectionFiles.group_brand_by)
			bys = ' '
			bys &= LinkTo(text='#display.group_brand_by#',route='g',orgname=obfuscateURL(collectionFiles.group_brand_by),params=urlParams())
			if(initalism != '') bys &= '<small>#initalism#</small>'
		}
		if(Len(fors) && Len(bys)) {
			return '<span class="nowrap">#fors#</span> <span class="nowrap">#bys#</span>'
		}
		if (Len(fors)) return '<span class="nowrap">#fors#</span>'
		if (Len(bys)) return '<span class="nowrap">#bys#</span>'
	}
	var published = function() {
		if(!len(collectionFiles.date_issued_year)) return;
		var date = '#collectionFiles.date_issued_year#'
		if(Len(collectionFiles.date_issued_month)) date &= ' <small>#MonthAsString(collectionFiles.date_issued_month)#'
		if(Len(collectionFiles.date_issued_day)) date &= ' #collectionFiles.date_issued_day#'
		if(Len(collectionFiles.date_issued_month)) date &= '</small>'
		return date
	}
	var title = function() {
		// linkToDetails is set in the shared list_shared-linkto partial
		var link = linkToDetails & '<br>'
		if(Len(collectionFiles.web_id_github)) link &= ' <small>#linkTo(text="SOURCE CODE",href="https://github.com/#collectionFiles.web_id_github#")# is available:</small> '
		link &= '<code>#display.fileName#</code>'
		return link
	}
	var urlParams = function() {
		var output = params.output ?: "";
		var sort = params.sort ?: "";
		if(output == "") return ""
		if(sort == "") return ""
		return "output=#output#&platform=-&section=-&sort=#sort#"
	}
	var posted = function() {
		if(IsDate(collectionFiles.createdat)) return "<small>#timeAgoInWords(collectionFiles.createdat)# ago</small>"
		return ""
	}
	// clean-up data to be HTML5 friendly
	if(params.controller != "search") {
		display = {} // global
		display.filename = XMLFormat(removeTags(collectionFiles.filename))
		display.group_brand_by = XMLFormat(removeTags(collectionFiles.group_brand_by))
		display.group_brand_for = XMLFormat(removeTags(collectionFiles.group_brand_for))
		// generate file title
		titleLink = XMLFormat(removeTags(fileTitle(collectionFiles)))
	}
	if(!Len(display.filename)) display.filename = "n/a";
	includePartial('../file/list_shared-linkto')
	var canEmulate = ''
	var quoteComment = ''
	var rowAttribute = ''
	if(emulateFile(collectionFiles)) canEmulate = '<br><span title="Can emulate in browser" class="brand-success">&nbsp;#svg(icon='dosee')#</span>'
	if(params.controller == "search" && Len(display.comment)) quoteComment = '</tr><tr><td></td><td colspan="7"><blockquote><small>#display.comment#</small></blockquote></td>'
	// Set an id attribute for the first table row to allow InfiniteScroll to find it
	if(collectionFiles.recordCount == 1) rowAttribute = ' id="tuuid-1_0"'
	if(collectionFiles.group_brand_for == collectionFiles.group_brand_by) collectionFiles.group_brand_by = "";
</cfscript>
<cfoutput>
	<tr class="file-as-text"#rowAttribute#>
		#fileToDownload()#
		<td>#title()#</td>
		<td>#humanizeFileSize(Val(collectionFiles.fileSize))#</td>
		<td>#published()#</td>
		<td>#getSectionName(collectionFiles.section)#</td>
		<td>#svg(icon='platform-#trim(collectionFiles.platform)#')# #humanizeFileFormat(collectionFiles.fileName,collectionFiles.platform)#</td>
		<td>#groups()#</td>
		<td>#posted()#</td>
		<!--- tags used by search --->#quoteComment#
	</tr>
</cfoutput>