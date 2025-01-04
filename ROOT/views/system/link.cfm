<!---
  	Manage websites view.
	path: views/system/link.cfm

@CFLintIgnore
--->
<cfscript>
	var scan = function() {
		for(var site in waybackwebsites) {
			if(FileExists("#directory##site.uriref#")) {
				sites.finds++
				sites.found[sites.finds] = {
					"dir"="/#site.uriref#",
					"title"="#site.title#",
					"id"="#site.id#"
				}
				continue;
			} else {
				sites.losses++
				sites.missing[sites.losses] = {
					"dir"="/#site.uriref#",
					"title"="#site.title#"
				};
			}
		}
	}
	var sites = {
		"found":[],
		"finds":0,
		"missing":[],
		"losses":0,
	}
	scan()
	var panel = "info"
	if(arrayLen(sites.missing)) panel = "danger";
	//directory = "null" // uncomment to test errors
</cfscript>
<cfoutput>
<div class="row">
<!---  col-md-offset-3 --->
<div class="col-lg-2">
	<!--- link scheme statistics --->
	<div class="panel panel-info">
		<div class="panel-heading"><h3 class="panel-title">Scheme statistics</h3></div>
		<ul class="list-group">
			<li class="list-group-item"><span class="badge">#schemes.recordCount#</span>Uniform Resource Identifiers</span></li>
<cfloop query="schemes"><li class="list-group-item">
<span class="badge">#model("Link").count(where="uriref LIKE '#schemes.scheme#://%'",includeSoftDeletes=false)#</span> <samp>#schemes.scheme#://</samp></li>
</cfloop>
</ul></div></div>
<div class="col-lg-10">
	<!--- hosted way-back website tests --->
	<div class="panel panel-#panel#">
		<div class="panel-heading">
			<h3 class="panel-title">Hosted wayback websites</h3>
		</div>
		<ul class="list-group">
			<li class="list-group-item"><span>Hosted websites</span> <span><span class="badge">#waybackwebsites.recordCount#</span></span></li>
			<li class="list-group-item list-group-item-#dangerDefault(DirectoryExists(directory))#">
				<span>Home directory</span>
				<p><pre>#directory#</pre></p>
				<cfif !DirectoryExists(directory)><samp><b>directory does not exist!</b></samp>
				<cfelseif ArrayLen(DirectoryList(absolute_path=directory,listInfo="name")) is 0><samp><b>directory is empty!</b></samp>
				</cfif>
			</li>
		</ul>
	<cfif arrayLen(sites.found)>
		<table class="table table-striped table-responsive gray-dark">
			<caption class="brand-success">These websites look to be fine</caption>
			<thead>
				<tr><th></th><th>Title</th><th>Size</th><th>Expected path</th></tr>
			</thead>
			<tbody>
		<cfloop array="#sites.found#" index="local.found">
			<tr>
				<!--- http://192.168.1.252/link/wayback/9b224 --->
				<td><a href="#UrlFor(controller="link", action="wayback", key="#obfuscateParam(found.id)#")#"><i class="fal fa-external-link fa-fw"></i></a></td>
				<td>#found.title#</td>
				<td><small style="white-space:nowrap">#humanizefilesize(GetFileInfo("#directory##found.dir#").Size)#</small></td>
				<td><samp>#found.dir#</samp></td>
			</tr></tbody>
		</cfloop>
		</table>
	</cfif>
	<cfif arrayLen(sites.missing)>
		<table class="table table-striped table-responsive">
			<caption>The following websites cannot be located on the system's hard disk</caption>
			<thead>
				<tr><th>Expected path</th><th>Title</th></tr>
			</thead>
		<cfloop array="#sites.missing#" index="local.missing">
			<tr><td><samp>#missing.dir#</samp></td><td><b><samp class="brand-danger">#missing.title#</samp></b></td></tr>
		</cfloop>
		</table>
	</cfif>
		<div class="panel-body">
			<ul class="columns-list-wide">
				#commandLists#
			</ul>
		</div>
	</div>
</div>
</div>
</cfoutput>