<!---
  	Remote API error view.
	path: views/system/errorrestapi.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="alert alert-danger" role="alert">The remote API request failed!</div>
	<div class="panel panel-info">
		<div class="panel-heading">
			<h3 class="panel-title"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i> HTTP request</h3>
		</div>
		<ul class="list-group">
			<li class="list-group-item">
				URL: <code>#errordata.uri#</code>
			</li>
			<li class="list-group-item">
				Authorization: <code>#errordata.authorization#</code>
			</li>
		</ul>
	</div>
	<div class="panel panel-warning">
		<div class="panel-heading">
			<h3 class="panel-title"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i> HTTP response</h3>
		</div>
		<ul class="list-group">
			<li class="list-group-item">
				Status code: <code>#errordata.statuscode#</code>
			</li>
			<li class="list-group-item">
				Error detail: <code>#errordata.errordetail#</code>
			</li>
		</ul>
	</div>
</cfoutput>