<!---
  	Sign-in accounts view.
	path: views/operator/signin.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Sign-in'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	#startFormTag(action="signinconnection",id="signin",class="form-horizontal")#
		<cfif flashCount()>
			<div class="alert alert-danger">#flashMessages()#</div>
		</cfif>
		<div class="form-group">
			<label for="operator-username" class="col-md-1 control-label">login</label>
			<div class="col-md-3">
				<input type="input" class="form-control" id="operator-username" name="operator[username]" placeholder="Username" required autofocus>
			</div>
		</div>
		<div class="form-group">
			<label for="operator-password" class="col-md-1 control-label"></label>
			<div class="col-md-3">
				<input type="password" class="form-control" id="operator-password" name="operator[password]" placeholder="Password" required>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-1">
				<button type="reset" class="btn btn-default">Clear</button>
			</div>
			<div class="col-sm-10">
				<button type="submit" class="btn btn-primary">Connect</button>
			</div>
		</div>
	#endFormTag()#
</cfoutput>