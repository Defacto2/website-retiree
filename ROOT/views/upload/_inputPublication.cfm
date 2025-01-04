<!---
  	Send your files "Publisher" and "Magazine" partial view.
	path: views/upload/_inputPublication.cfm

@CFLintIgnore
--->
<cfscript>
	param name="fileisMag" default=false type="boolean";
	var placeholder = 'Group who published or released this'
	var label = 'Publisher'
	var columnClass = "col-lg-12"
	if(param.fileisMag) {
		placeholder = 'Magazine name or title'
		label = 'Magazine'
	}
	if(!param.fileisMag) columnClass = "col-lg-6"
</cfscript>
<cfoutput>
<div class="row">
	<div class="#columnClass#">
		<div class="form-group" id="publication-container">
			<label for="newFile-group_brand_for" class="control-label">#label#</label><br>
			<input class="form-control" id="newFile-group_brand_for" list="newFile-group_brand_for-list" maxlength="100" name="newFile[group_brand_for]" type="text" value="" placeholder="#placeholder#" required>
		</div>
		<!--- HTML5 auto-complete data --->
		<datalist id="newFile-group_brand_for-list">
			<cfloop query="groupsDatalist"><option value="#pubCombined#" label="#pubCombined#"></cfloop>
		</datalist>
	</div>
	<cfif !param.fileisMag>
		<div class="#columnClass#">
			<div class="form-group">
				<label for="newFile-group_brand_by" class="text-muted">Additional publisher</label><br />
				<input class="form-control" id="newFile-group_brand_by" list="newFile-group_brand_by-list" maxlength="100" name="newFile[group_brand_by]" type="text" value="" placeholder="Group who created this (if different from the publisher)">
			</div>
			<!--- HTML5 auto-complete data --->
			<datalist id="newFile-group_brand_by-list">
				<cfloop query="groupsDatalist"><option value="#pubCombined#" label="#pubCombined#"></cfloop>
			</datalist>
		</div>
	</cfif>
</div>
</cfoutput>