<!---
  	Manage groups view.
	path: views/admin/organisation.cfm

@CFLintIgnore
--->
<cfscript>
	// list of groups with initalisms
	var listGroups = ""
	for (var group in variables.groups) {
		var combined = group.pubCombined
		if(!Len(Trim(combined))) combined = group.pubValue
		listGroups &= '<li>#linkTo(text="#combined#",route="g",orgname=obfuscateURL(group.pubValue))#</li>'
	}
</cfscript>
<cfoutput>
#includePartial("/system/flash")#
<datalist id="groups"><cfloop index="local.group" list="#groupDatalist#"><option value="#group#"></cfloop></datalist>
	<div class="row">
	<!--- groups --->
	<div class="col-lg-5 col-lg-offset-1 col-md-6 col-sm-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Rename #get('siteAreas').titles.organisation#</h3>
			</div>
			<div class="panel-body">
				#startFormTag(route="groupForm",key="confirm")#
					<div class="form-group form-group-sm">
						<fieldset>
							<label for="renameGroup" class="col-sm-4 control-label">Group</label>
							<div class="col-sm-8">
								<input type="text" class="form-control input-sm" id="renameGroup" name="renameGroup" value="" placeholder="Defacto" autofocus list="groups">
							</div>
						</fieldset>
					</div>
					<div class="form-group form-group-sm">
						<fieldset>
							<label class="col-sm-4 control-label" for="renameTo">Rename to</label>
							<div class="col-sm-8">
								<input type="text" class="form-control input-sm" id="renameTo" name="renameTo" value="" placeholder="Defacto2" list="groups">
							</div>
							<div class="col-sm-12 help-block">Renaming groups changes their URL, <u>this will break links and SEO</u></div>
						</fieldset>
						<button type="submit" class="btn btn-primary">Make changes</button>
						<button type="reset" class="btn btn-default">Clear</button>
					</div>
				#endFormTag()#
			</div>
		</div>
	</div>
	<!--- initialisms --->
	<div class="col-lg-5 col-md-6 col-sm-12">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Modify Initialisms</h3>
			</div>
			<div class="panel-body">
				#startFormTag(route="initalismForm",key="update")#
					<div class="form-group">
						<fieldset>
							<label for="modifyGroup" class="col-sm-4 control-label">Group</label>
							<div class="col-sm-8">
								<input type="text" class="form-control input-sm" id="modifyGroup" name="modifyGroup" value="" placeholder="Defacto2" list="groups">
							</div>
						</fieldset>
					</div>
					<div class="form-group">
						<fieldset>
							<label class="col-sm-4 control-label" for="initialism">New initialism</label>
							<div class="col-sm-8">
								<input type="text" class="form-control input-sm" id="initialism" name="initialism" placeholder="DF2">
							</div>
							<div class="col-sm-12 help-block">To remove an existing initialism leave the <q>New initialism</q> input blank</div>
						</fieldset>
						<button type="submit" class="btn btn-primary">Make changes</button>
						<button type="reset" class="btn btn-default">Clear</button>
					</div>
				#endFormTag()#
			</div>
		</div>
	</div>
</div>
<!--- list groups --->
<div class="row">
	<div class="col-md-12">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Browse #get('siteAreas').titles.organisation#</h3>
			</div>
			<div class="panel-body">
				<ul class="columns-list">#listGroups#</ul>
			</div>
		</div>
	</div>
</div>
</cfoutput>