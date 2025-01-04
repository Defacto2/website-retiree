<!---
  	Manage people view.
	path: views/admin/person.cfm

@CFLintIgnore
--->
<cfoutput>
#includePartial("/system/flash")#
<datalist id="people"><cfloop index="local.person" list="#distinctList#"><option value="#person#"></cfloop></datalist>
<div class="row">
	<div class="col-lg-5 col-lg-offset-3 col-md-8 col-md-offset-2">
		<!--- rename persons --->
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Modify a person</h3>
			</div>
			<div class="panel-body">
				#startFormTag(route="personForm",key="confirm",class="form-horizontal",role="form")#
					<div class="form-group">
						<fieldset>
							<label class="control-label col-sm-4" for="renamePerson">Person</label>
							<div class="col-sm-7 input-group">
								<span class="input-group-addon"><i class="fal fa-user-circle fa-fw fa-lg"></i></span>
								<input type="text" class="form-control" id="renamePerson" name="renamePerson" value="" autofocus list="people">
							</div>
						</fieldset>
					</div>
					<div class="form-group">
						<fieldset>
							<label class="control-label col-sm-4" for="renameTo">Rename to</label>
							<div class="col-sm-7 input-group">
								<span class="input-group-addon"><i class="fal fa-user-circle fa-fw fa-lg"></i></span>
								<input type="text" class="form-control" id="renameTo" name="renameTo" value="">
							</div>
							<div class="col-sm-12 help-block">
								<p>Valid characters: <samp>Aa-Zz 0-9 - , &amp; . [space]</samp></p>
								<p>Renaming people changes their URL, <u>this will break links and SEO</u></p>
							</div>
						</fieldset>
						<div class="col-sm-12">
							<button type="submit" class="btn btn-primary">Make changes</button>
							<button type="reset" class="btn btn-default">Clear</button>
						</div>
					</div>
				#endFormTag()#
			</div>
		</div>
	</div>
</div>
</cfoutput>