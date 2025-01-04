<!---
  	Send your files "BBS or FTP site name" partial view.
	path: views/upload/_inputSite.cfm

@CFLintIgnore
--->
<cfscript>
	param name="fileisMag" default=false type="boolean";
	var placeholder = 'The site this release is advertising'
	var label = 'BBS or FTP site name'
</cfscript>
<cfoutput>
	<div class="form-group" id="publication-container">
		<label for="newFile-group_brand_for" class="control-label">#label#</label>
		<p class="help-block">You need append either 'BBS' or 'FTP' to the name, ie <i>Fast Action BBS</i>.</p>
		<input class="form-control" id="newFile-group_brand_for" list="newFile-group_brand_for-list" maxlength="100" name="newFile[group_brand_for]" type="text" value="" placeholder="#placeholder#" required>
	</div>
	<!--- HTML5 auto-complete data --->
	<datalist id="newFile-group_brand_for-list">
		<cfloop query="groupsDatalist"><option value="#pubCombined#" label="#pubCombined#"></cfloop>
	</datalist>
</cfoutput>