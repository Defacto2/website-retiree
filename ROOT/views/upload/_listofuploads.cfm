<!---
  	Send your files "Queued upload" partial view.
	path: views/upload/_listofuploads.cfm

@CFLintIgnore
--->
<cfoutput>
	<div id="listupload-container" class="hidden">
		<div class="panel panel-default table-responsive">
			<div class="panel-heading lead">
				Queue<br><small class="text-right" id="status-of-uploads"></small>
			</div>
			<table class="table">
				<tbody id="list-of-uploads"></tbody>
			</table>
		</div>
	</div>
</cfoutput>