<!---
  	Statistics template view.
	path: views/system/templateprocess.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="panel panel-info">
		<div class="panel-heading">
			<h3 class="panel-title">#process.legend#</h3>
		</div>
		<!--- processed data output --->
		<div class="panel-body">
			<ul class="statistics columns-list-wide">
				#process.li#
			</ul>
		</div>
	</div>
</cfoutput>