<!---
  	List user accounts view.
	path: views/operator/index.cfm

@CFLintIgnore
--->
<cfscript>
	var user
	var users =
		model("User").findAll(
		selected="uuid",
		includeSoftDeletes=true,
		returnAs="query")
	pageAbout.text = 'List user accounts'
	pageAbout.icon = 'fal fa-address-book fa-fw'
</cfscript>
<cfoutput>
#includePartial("../system/flash")#
<div id="operator" class="col-lg-6 col-lg-offset-3 col-md-12">
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title">Users</h3></div>
	<table class="table gray-dark">
	<thead><tr><th></th><th>User</th><th>Display name</th><th>Email</th><th>Affiliations</th></tr></thead>
	<tbody><cfloop query="users">
		<cfset user = model("User").findOneByUUID(value=users.uuid,includeSoftDeletes=true)>
		<tr>
			<td class="col-lg-1 col-md-2"><a href="#UrlFor(route="editUser",key="#user.uuid#",title="Edit")#"><i class="fal fa-edit fa-fw"></i></a>
			<cfif session.op.uuid is user.uuid>
				<span title="System operator role"><i class="fal fa-user-md fa-fw"></i></span>
			<cfelse>
				<span title="Coordinator role"><i class="fal fa-user-cog fa-fw"></i></span>
			</cfif>
			</td>
			<td class="col-lg-1 col-md-2"><strong>#user.username#</strong><cfif Len(user.deletedat)> <em>(disabled)</em></cfif></td>
			<td class="col-lg-2 col-md-4">#user.displayname#</td>
			<td><samp>#autoLink(user.email)#</samp></td>
			<td>#autoLink(user.affiliation)#</td>
		</tr>
	</cfloop></tbody></table>
</div>
</div>
</cfoutput>