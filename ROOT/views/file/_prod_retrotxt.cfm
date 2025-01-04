<!---
    RetroTxtCF partial view.
	path: views/files/_prod_retrotxt.cfm

	MS-DOS, Codepage 437, plain-text to HTML converter.

@CFLintIgnore
--->
<cfscript>
	// determine column width of the text file
	var stats = function(filename) {
		var opened = fileOpen(filename, "read", retro.characterSet)
		// determine column width of file
		while(!FileIsEOF(opened))
		{
			retro.lineOfText = rTrim(FileReadLine(opened))
			retro.lineLength = len(retro.lineOfText)
			retro.lineCount++
			if(retro.lineLength > retro.columns) retro.columns = retro.lineLength;
		}
		FileClose(opened);
	}
	var footer = function() {
		if(!retroTxt.exists) return "";
		if(len(fileProd.retrotxt_readme)) return fileProd.retrotxt_readme;
		return findTextfile(fileProd);
	}
	var linefeed = Chr(10)
	var columns = {
		"default":80,
		"fileID":42, // default is 40 but this allows for 2 character padding
		"maximum":300,
		"fontWidth":16, // pixels
	}
	var retro = {
		"characterSet": "windows-1252",
		"columns": columns.default,
		"lineOfText": '',
		"footer": fileProd.filename,
		"lineCount": 0,
		"lineLength": 0,
		"openedFile": '',
		"pxs" = {},
	}
	var rawtext = ""
	retro.footer = footer()
	// display text file
	if(retroTxt.exists) {
		stats(retroTxt.file)
		if(fileProd.platform == "textamiga") {
			rawtext = fileRead(retroTxt.file,"iso-8859-1");
		} else {
			rawtext = _retrotxt(fileRead(retroTxt.file,retro.characterSet),true);
		}
	}
	// display appended zip comment
	var ansiEsc = "←["
	if(retroTxt.exists && zipComment.exists) {
		var txt = _retrotxt(fileRead(zipComment.file,retro.characterSet),true);
		if(left(trim(txt),2) != ansiEsc) {
			rawtext &= RepeatString(NewLine(), 3) & " ══[ ZIP comment attached to #fileProd.filename# ]══" & RepeatString(NewLine(), 1)
			rawtext &= txt
		}
		txt = ""
	}
	// only display zip comment
	if(!retroTxt.exists && zipComment.exists) {
		stats(zipComment.file)
		retro.footer = "ZIP comment attached to #fileProd.filename#"
		rawtext &= _retrotxt(fileRead(zipComment.file,retro.characterSet),true);
	}
	if(!retroTxt.exists && !zipComment.exists) {
		rawtext = "File not found"
	}
	// correct any document malfunctions
	rawtext = replace(rawtext, '♪#linefeed#', linefeed, 'all')
	rawtext = replace(rawtext, '#linefeed#♪', linefeed, 'all')
	if(retro.columns > columns.maximum) retro.columns = columns.default;
	if(retro.columns <= columns.fileID) retro.columns = columns.fileID;
	if (rawtext.findOneOf(ansiEsc) > 0) {
		rawtext = replace(rawtext, '#chr(27)#[', ansiEsc, 'all')
	}
</cfscript>
<cfoutput>
	<!--- DOS (CP-437) text to HTML conversion --->
	<div id="retrotxt-viewer" style="max-width:#(columns.fontWidth*retro.columns)#px;">
		<menu id="dos-font-menu">
			<a id="config-menu">[<span id="config-menu-status">+</span>] Configuration</a>
			<a id="copy-canvas">Copy text</a>
			<ul id="config-menu-options" class="hide-true">
				<li class="text-left">Colour: <a id="dosfont-white">White</a> &nbsp;<a id="dos-font-dos">DOS</a> &nbsp;<a id="dos-font-modern">Modern</a> &nbsp;<a id="dos-font-green">Green</a> &nbsp;<a id="dos-font-black">Black</a></li>
				<li class="mobile-hide text-left">Position: <a id="retrotxt-left">[Left  &nbsp;]</a> &nbsp; <a id="retrotxt-centre">[ Centre ]</a></li>
				<cfif fileProd.platform eq "textamiga">
					<li id="dosfont-list" class="text-left">Font: <a id="dosFontTopaz2">Topaz2</a></li>
				<cfelse>
					<li id="dosfont-list" class="text-left">Font: <a id="dos-font-vga8">VGA</a> <a id="dos-font-mcga">ISO</a> <a id="dos-font-monospace">Monospace</a></li>
				</cfif>
				<li class="mobile-hide mcga">
					<small><span id="retrotxt-branding"></span>, also available on
					<i class="fab fa-chrome"></i> <a href="https://chrome.google.com/webstore/detail/retrotxt/gkjkgilckngllkopkogcaiojfajanahn" title="Install from the Chrome store">Chrome</a>
					<i class="fab fa-firefox"></i> <a href="https://addons.mozilla.org/en-US/firefox/addon/retrotxt" title="Install from the Firefox Add-ons">Firefox</a></small>
					<i class="fab fa-edge"></i> <a href="https://microsoftedge.microsoft.com/addons/detail/retrotxt/hmgfnpgcofcpkgkadekmjdicaaeopkog" title="Install from Edge Add-ons">Edge</a></small>
				</li>
			</ul>
		</menu>
		<!--- Do not apply XmlFormat here or PCBoard rendering will break
			  Instead it is applied to the arguments.text of _retrotxt() in File.cfc --->
		<div id="retrotxt-canvas">#rawtext#</div>
		<footer id="retrotxt-foot">#XmlFormat(retro.footer)# <span id="full-font-size">#retro.columns#x#retro.lineCount#</span> <span id="full-font-container"><span id="full-font-name">Font</span></span></footer>
	</div>
	<span id="retrotxtCalcCols" class="hide">#retro.columns#</span>
</cfoutput>