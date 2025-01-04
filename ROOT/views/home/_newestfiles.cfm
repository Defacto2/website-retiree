<!---
	Recent additions partial view.
	path: views/home/_newestfiles.cfm

@CFLintIgnore
--->
<cfscript>
	var title = 'Recent additions'
</cfscript>
<cfoutput>
<div class="panel panel-default mobile-hide" id="new-ups-panel">
	<div class="panel-heading">
		<div class="lead text-center" style="margin-bottom:0.5rem">#linkTo(text=title,route="fileFilter",key="new",rel="prefetch",id="homeNewestFiles")#
		<cfif len(timeAgo)> <small>updated #timeAgo#</small></cfif>
		<small id="homeNewFileCount"></small>
		</div>
	</div>
	<div class="panel-body" id="new-ups-body">
		<div class="row" id="newUpsBodyRow">
			<!-- recent uploads container will be propagated by JS -->
		</div>
	</div>
</div>
</cfoutput>