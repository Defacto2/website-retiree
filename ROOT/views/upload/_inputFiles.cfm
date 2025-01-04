<!---
  	Send your files "Select or drag some files to upload" partial view.
	path: views/upload/_inputFiles.cfm

@CFLintIgnore
--->
<cfscript>
	param name="debugMode" default=false type="boolean";
	var xht2State = "checked"
	if(params.action == "submit-file") xht2State = ""
</cfscript>
<div class="row">
	<div class="col-sm-12" id="file-label">
		<label for="newFile-fileName" class="control-label lead">
			Select or drag files for upload
		</label>
		<br>
		<small>There is a 100 MB maximum upload size limit</small>
	</div>
</div>
<cfoutput>
<div class="navbar" id="file-container">
	<div class="container-fluid">
		<cfif debugMode>
			<ul>
				<li><strong class="brand-info">Operating in verbose debug mode</strong>, please make sure your browser's web console is open and that its <span style="text-decoration: underline;">JavaScript cache is disabled</span></li>
				<li><small class="brand-primary">Upload.cfc version: #uploadCFCVer#; upload.js version: <span id="uploadjsver">?</span>;</small> <small>onload `xht2State` = #xht2State#; ?debugMode=#params.debugMode#; <span id="uploadjsnotice" class="brand-danger">upload.js is in debug mode? <span id="uploadjsdebug">false</span></span></small></li>
			</ul>
		</cfif>
		<!--- File section --->
		<!--- standard HTML5 submit --->
		<button type="submit" id="upload-files-submit" class="btn btn-primary text-uppercase" style="display:inline">Upload files</button>
		<!--- JavaScript asynchronous upload --->
		<button type="button" id="upload-files-button" class="btn btn-primary text-uppercase" style="display:none" disabled>Upload files</button>
		<!--- HTML5 multiple file upload selection --->
		<input class="btn btn-default navbar-btn" aria-label="Select files for upload" id="select-files-js" name="file0" type="file" style="display:inline" multiple autofocus>
		<!--- User overrides --->
		<div class="navbar-btn navbar-right" role="group" id="abort-container">
			<button type="button" id="abort-button" class="btn btn-danger" style="display:none">Abort transfer</button>
			<button type="reset" id="reset-button" class="btn btn-default">Clear form</button>
		</div>
	</div>
</div>
</cfoutput>
<!--- progress bar --->
<div class="row hidden" id="progress-container">
	<div class="col-sm-12">
		<progress id="progress-bar" max="100" value="0"></progress><br><label for="progress-bar" id="progressBarLabel">Transfer</label> <span id="progressPercentage">0</span>% <span id="progressSpeed"></span>
	</div>
</div>
<hr>