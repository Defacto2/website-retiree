<!---
  	Send your files "Title" partial view.
	path: views/upload/_inputTitle.cfm

@CFLintIgnore
--->
<cfscript>
	param name="param.fileisMag" default=false type="boolean";
	var placeholder = 'Simple or descriptive title'
	var label = 'Title'
	if(param.fileisMag) {
		placeholder = 'Issue number or name'
		label = 'Edition'
	}
</cfscript>
<cfoutput>
	<div class="form-group" id="titleContainer">
		<label for="newFile-record_title" class="control-label">#label#</label><br>
		<input class="form-control" id="newFile-record_title" name="newFile[record_title]" maxlength="100" placeholder="#placeholder#" required>
	</div>
</cfoutput>