<!---
  	Accounts form view.
	path: views/operator/form.cfm

@CFLintIgnore
--->
<cfscript>
	var fields = function() {
		var checked = "checked"
		var errors = errorMessagesFor("superUser")
		if(errors contains 'Username') field.user = 'has-error';
		if(errors contains 'Password') field.password = 'has-error';
		if(errors contains 'Email') field.email = 'has-error';
		if(structKeyExists(superUser, 'sysop') and superUser.sysop) {
			field.sysop = checked
			return
		}
		if(structKeyExists(superUser, 'coop') and superUser.coop) {
			field.coop = checked
			return
		}
		field.noop = checked
	}
	var field = {
		"user":"",
		"password":"",
		"email":"",
		"sysop":"",
		"coop":"",
		"noop":""
	}
	fields()
	pageAbout.text = '#humanize(params.action)# user account'
	pageAbout.icon = 'fal fa-address-card fa-fw'
</cfscript>
<cfoutput>
	<cfif IsDefined("superUser") and Len(errorMessagesFor("superUser"))>
		<div class="alert alert-danger">#errorMessagesFor("superUser")#</div>
	<cfelseif flashCount()>
		#includePartial("../system/flash")#
	</cfif>
<div class="col-lg-6 col-lg-offset-3">
	<div class="panel panel-default panel-limited-double">
		<div class="panel-heading text-center">
			<h3 class="panel-title">Account details<cfif params.action is "edit"> for <strong class="brand-primary">#superUser.username#</strong></cfif></h3>
		</div>
		<div class="panel-body">
			<form class="form-horizontal" role="form" method="post" id="form1" action="/operator/save">
			<div class="form-group form-group-sm">
				<fieldset class="#field.user#">
					<label class="col-sm-4 text-right" for="superUser[username]">Sign-in name</label>
					<div class="col-sm-8">
					<input type="text" class="form-control" id="superUser-username" name="superUser[username]" maxlength="255" value="#superUser.username#" placeholder="Login name" autofocus required>
					</div>
				</fieldset>
			</div>
			<div class="form-group form-group-sm">
				<fieldset>
					<label class="col-sm-4 text-right text-muted" for="superUser[displayname]">Display name</label>
					<div class="col-sm-8">
					<input type="text" class="form-control" id="superUser-displayname" name="superUser[displayname]" maxlength="255" value="#superUser.displayname#" placeholder="A user's display name">
					</div>
				</fieldset>
			</div>
			<div class="form-group form-group-sm">
				<fieldset>
					<label class="col-sm-4 text-right text-muted" for="superUser[affiliation]">Group affiliations or website</label>
					<div class="col-sm-8">
					<input type="text" class="form-control" id="affiliation" name="superUser[affiliation]" maxlength="255" value="#superUser.affiliation#" placeholder="#get('siteAreas').titles.df2#">
					</div>
				</fieldset>
			</div>
			<div class="form-group form-group-sm">
				<fieldset class="#field.email#">
					<label class="col-sm-4 text-right" for="superUser[email]">Email address</label>
					<div class="col-sm-8">
					<input type="email" class="form-control" id="superUser-email" name="superUser[email]" maxlength="255" autocomplete="false" value="#superUser.email#" placeholder="email@example.com" required>
					</div>
				</fieldset>
			</div>
			<cfif opCheck('sysop')>
				<div class="form-group form-group-sm">
				<fieldset>
					<label class="col-sm-4 text-right text-primary" for="role-coop">Coordinator role</label>
					<div class="col-sm-8">
						<input type="radio" id="role-coop" name="role" value="coop"#field.coop#>
					</div>
				</fieldset>
				<fieldset>
					<label class="col-sm-4 text-right gray-dark" for="role-noop">No role</label>
					<div class="col-sm-8">
						<input type="radio" id="role-noop" name="role" value="noop"#field.noop#> <small>&nbsp; disable the account</small>
					</div>
				</fieldset>
				<fieldset>
					<label class="col-sm-4 text-right text-warning" for="role-sysop">System operator role</label>
					<div class="col-sm-8">
						<input type="radio" id="role-sysop" name="role" value="sysop"#field.sysop#>
					</div>
				</fieldset>
				</div>
			</cfif>
			<div class="form-group form-group-sm">
				<fieldset class="#field.password#">
				<cfif params.action is "edit">
					<label class="col-sm-4 text-right text-muted" for="passwordmodified">Change sign-in password</label>
					<div class="col-sm-8">
					<p class="help-block"><small>Please make sure the password is a strong, non-dictionary word string. Case matching and non-alphanumeric character support is implemented.</small></p>
					<input type="password" class="form-control" id="passwordmodified" name="passwordmodified" maxlength="255" autocomplete="false" placeholder="Leave empty to keep the existing password">
					</div>
				<cfelse>
					<label class="control-label col-sm-4" for="superUser-password">Secure password for sign-in</label>
					<div class="col-sm-8">
					<p class="help-block"><small>Please make sure the password is a strong, non-dictionary word string. Case matching and non-alphanumeric character support is implemented.</small></p>
					<input type="password" class="form-control" id="superUser-password" name="superUser[password]" maxlength="255" autocomplete="false" required>
					</div>
				</cfif>
				</fieldset>
			</div>
			<div class="form-group">
				<div class="col-sm-4">
					<button type="submit" class="btn btn-block btn-primary text-uppercase">Save <cfif params.action is "new">user<cfelse>changes</cfif></button>
				</div>
				<div class="col-sm-2 col-md-offset-6 text-right">
					<button type="reset" class="btn btn-warning">Reset</button>
				</div>
			</div>
			<cfif !StructKeyExists(params,"previousaction")>
				#hiddenFieldTag(name="previousaction", value="#params.action#")#
			<cfelse>
				#hiddenFieldTag(name="previousaction", value="#params.previousaction#")#
			</cfif>
			#hiddenFieldTag(name="row", value="#params.row#")#
			#hiddenField(objectName="superUser", property="uuid")#
			</form>
		</div>
	</div>
</div>
</cfoutput>