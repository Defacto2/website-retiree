<!---
  	Send your files HTML tabs partial view.
	path: views/upload/_navigationtabs.cfm

@CFLintIgnore
---><cfscript>
	var activeTab = function(required string item) {
		if(!StructKeyExists(params,'action')) return "";
		if(arguments.item != params.action) return "";
		return "active";
	}
	var note = 'Please no serial/key generators or non-English files'
	var pouetLink = ReplaceNoCase(get('myapp').other.pouet, 'prod.php?which=', 'prodlist.php')
	if(params.action == 'external') note = 'Have a production on <a href="#get('myapp').other.demozoo#">Demozoo</a> or <a href="#pouetLink#">Pouët</a> that should be on this site?<br>Submit its production ID and we will handle the rest'
</cfscript><cfoutput>
<div class="form-group mobile-hide">
	<ul class="nav nav-tabs">
		<li class="#activeTab('file')#"><a href="#UrlFor(controller="Upload",action="file")#">Note</a></li>
		<li class="#activeTab('external')#"><a href="#UrlFor(controller="Upload",action="external")#">Demozoo, <small>Pouët</small></a></li>
		<li class="#activeTab('intro')#"><a href="#UrlFor(controller="Upload",action="intro")#">Intros, <small>Cracktros</small></a></li>
		<li class="#activeTab('site')#"><a href="#UrlFor(controller="Upload",action="site")#">BBS, FTP <small>Ads</small></a></li>
		<li class="#activeTab('document')#"><a href="#UrlFor(controller="Upload",action="document")#">Documents, <small>NFOs</small></a></li>
		<li class="#activeTab('magazine')#"><a href="#UrlFor(controller="Upload",action="magazine")#">Magazines</a></li>
		<li class="#activeTab('art')#"><a href="#UrlFor(controller="Upload",action="art")#">Art</a></li>
		<li class="#activeTab('other')#"><a href="#UrlFor(controller="Upload",action="other")#"><small>Custom</small></a></li>
	</ul>
</div>
<cfif params.action is "external">
	<div class="container-fluid">
		<div class="navbar-btn navbar-right" role="group">
			<button type="button" id="upload-id-button" class="btn btn-primary text-uppercase" style="display:inline;" disabled="true">Submit ID</button>
			<button type="button" id="reset-id-button" class="btn btn-default">Clear</button>
		</div>
	</div>
</cfif>
<div class="text-center gray-light"><small>#note#</small></div></cfoutput>