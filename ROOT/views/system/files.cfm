<!---
  	Records statistics view.
	path: views/system/files.cfm

@CFLintIgnore
--->
<cfscript>
	var publicTotal = model("files").count(includeSoftDeletes=false)
	var statement = dynamicSqlForFile(params={key='disabled'}).WHERESTATE
	var disableTotal = model("Files").count(where=statement,includeSoftDeletes=true)
	var totalFiles = model("files").count(includeSoftDeletes=true)
	var calculate = function() {
		// disabled (hidden from public view) files
		counts.private = val(totalFiles-publicTotal);
		stats.public = (publicTotal / totalFiles) * 100;
		stats.private = ((totalFiles - publicTotal) / totalFiles) * 100;
		stats.approve = (fileStats.waitingapproval / totalFiles) * 100;
		stats.disable = (disableTotal / totalFiles) * 100;
		if(fileStats.waitingapproval) graph.approve = (fileStats.waitingapproval / counts.private) * 100;
		if(disableTotal) graph.disable = (disableTotal / counts.private) * 100;
	}
	var format = function() {
		var mask = '9.9'
		stats.public = NumberFormat(stats.public, mask);
		stats.private = NumberFormat(stats.private, mask);
		stats.approve = NumberFormat(stats.approve, mask);
		stats.disable = NumberFormat(stats.disable, mask);
		mask = '9'
		graph.approve = NumberFormat(graph.approve, mask);
		graph.disable = NumberFormat(graph.disable, mask);
	}
	var round = function(required numeric number) {
		try {
			return numberFormat(argument.number, '0.9');
		} catch("any err") {
			return 1
		}
	}
	var counts = {
		"private":0,
	}
	var stats = {
		"public":0,
		"private":0,
		"approve":0,
		"disable":0,
	}
	var graph = {
		"approve":100,
		"disable":100,
	}
	var drive = serverDisk()
	calculate()
	format()
</cfscript>
<cfoutput>
<div class="row">
	<div class="col-md-4">
		<ul class="gray text-center">
			<li><h1>#totalFiles# file records</h1></li>
			<li>&nbsp;</li>
			<li class="lead">Published files, #publicTotal#</li>
			<li class="lead">Waiting to be published, #fileStats.waitingapproval#</li>
			<li class="lead">Unpublished and not viewable, #disableTotal#</li>
			<li class="lead">#humanizeFileSize(drive.free*1024)# available</li>
			<!--- <cfdump var="#fileStats#"> --->
		</ul>
	</div>
	<div class="col-md-4">
		<canvas id="monthlyChart"></canvas>
	</div>
	<div class="col-md-4">
		<canvas id="yearlyChart"></canvas>
	</div>
</div>
<div class="row"><hr></div>
<div class="row">
	<div class="col-md-4">
		<canvas id="groupChart"></canvas>
	</div>
	<div class="col-md-4">
		<canvas id="typeChart"></canvas>
	</div>
	<div class="col-md-4">
		<canvas id="tagChart"></canvas>
	</div>
</div>
<div class="row"><hr></div>
</cfoutput>