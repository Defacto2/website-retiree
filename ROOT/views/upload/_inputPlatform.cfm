<!---
  	Send your files "Platform or operating system" partial view.
	path: views/upload/_inputPlatform.cfm

@CFLintIgnore VAR_TOO_SHORT
--->
<cfscript>
	var useSection = function() {
		if(param.fileisMag) return false;
		if(param.fileisIntro) return false;
		if(param.fileisSite) return false;
		return true;
	}
	param name="param.fileisIntro" default=false type="boolean";
	param name="param.fileisMag" default=false type="boolean";
	param name="param.fileisSite" default=false type="boolean";
	var label = "Platform or operating system"
	var columnWidth = 6
	if(!useSection()) columnWidth = 12;
	if(param.fileisSite) label = "Advert type";
</cfscript>
<cfoutput>
	<div class="row">
		<div class="col-md-#columnWidth# col-sm-12">
			<label for="newFile-platform" class="text-muted">#label#</label>
			<div class="form-group">
				<cfif param.fileisIntro or param.fileisSite or param.fileisMag>
					<label for="platformChoice1" class="radio-inline">
						<input type="radio" id="platformChoice1" name="newFile[platform]" value="" checked>Leave blank <small>or unknown</small></label>
					<label for="platformChoice2" class="radio-inline">
						<input type="radio" id="platformChoice2" name="newFile[platform]" value="dos" title="Microsoft DOS or PC DOS program">MS-DOS <small>app</small></label>
					<label for="platformChoice3" class="radio-inline">
						<input type="radio" id="platformChoice3" name="newFile[platform]" value="windows" title="Microsoft Windows for any edition">Windows <small>app</small></label><cfif param.fileisIntro>
					<label class="radio-inline">
						<a href="#urlFor(controller="upload",action="document")#">Textfiles, documents or NFOs</a>
					</label>
					<label class="radio-inline">
						<a href="#urlFor(controller="upload",action="art")#">Images or photos</a>
					</label></cfif>
					<cfif param.fileisMag>
					<label for="platformChoice4" class="radio-inline">
						<input type="radio" id="platformChoice4" name="newFile[platform]" value="text" title="Text document">Text newsletter</label>
					<cfelseif param.fileisSite>
					<label for="platformChoice4" class="radio-inline">
						<input type="radio" id="platformChoice4" name="newFile[platform]" value="ansi" title="ANSI coloured text">ANSI</label>
					<label for="platformChoice5" class="radio-inline">
						<input type="radio" id="platformChoice5" name="newFile[platform]" value="text" title="ASCII or NFO text">ASCII~NFO</label>
					<label for="platformChoice8" class="radio-inline">
						<input type="radio" id="platformChoice8" name="newFile[platform]" value="textamiga" title="Text for the Commodore Amiga">Amiga~NFO</label>
					<label for="platformChoice6" class="radio-inline">
						<input type="radio" id="platformChoice6" name="newFile[platform]" value="image" title="Image such as GIF, JPEG, PNG">Image</label>
					<label for="platformChoice7" class="radio-inline">
						<input type="radio" id="platformChoice7" name="newFile[platform]" value="video" title="Video media">Video</label>
					</cfif>
				<cfelse>
					<!--- 15/05/23: hard coded fix to not list the Archive platform --->
					<select class="form-control" id="newFile-platform" name="newFile[platform]">
						<option value="">&nbsp;</option>
					<cfif !param.fileisMag and !param.fileisIntro and !param.fileisSite>
						<cfloop query="newFilePlatform"><cfif platform eq "archive"><cfcontinue></cfif>#platform#<option value="#platform#">#platformText#</option></cfloop>
					<cfelse>
						<cfloop array="#variables.platforms#" index="local.platform"><cfif platform eq "archive"><cfcontinue></cfif><option value="#platform[1]#">#platform[2]#</option></cfloop>
					</cfif>
					</select>
				</cfif>
				<p class="help-block" id='newFile-platform-span'></p>
			</div>
		</div>
	<cfif useSection()>
		<div class="col-md-6 col-sm-12">
			<label for="newFile-section" class="text-muted">Tag as</label>
			<div class="form-group">
				<select class="form-control" id="newFile-section" name="newFile[section]">
					<option value="">&nbsp;</option>
					<!--- Do not change the CASING of the option values or JS may break! --->
					<option value="releaseproof">Proof of release</option>
					<cfloop query="newFileSection"><option value="#LCase(section)#">#sectionText#</option></cfloop>
				</select>
				<p class="help-block" id='newFile-section-span'></p>
			</div>
		</div>
	</cfif>
	</div>
</cfoutput>