<!---
  	System and software view.
	path: views/system/softwaredashboard.cfm

@CFLintIgnore VAR_TOO_SHORT
--->
<cfscript>
	var humanise = function(string scope="") {
		var name = lCase(arguments.scope)
		switch(name) {
			case 'applicationname': return "Application name";
			case 'testServer': return "Test server";
			case 'productionhost': return "Production host";
			case 'pathwwwroot': return "Path web root";
			case 'pathservingroot': return "Path serving root";
			default: return capitalize(name)
		}
	}

	variables.ram = serverRAM()
	var kilo = 1000
	var memory = {
		"free":ram.free*kilo,
		"java":(ram.use*kilo)-java.memoryused,
		"total":ram.total*kilo,
	}
	var graph = {
		"free":ram.freePercent,
		"java":(java.memoryused/memory.total)*100,
		"system":0,
	}
	graph.system = 100-graph.free-graph.java

	// nginx web server
	var xdata = GetHTTPRequestData().headers
	if(!structKeyExists(xdata,"x-nginx-version")) {
		xdata["x-nginx-version"] = "?.?"
	}

	var drive = serverDisk()

	var cpuTrim = function() {
		if(!Len(cpu.name)) {
			cpu.display = cpu.name;
			return
		}
		cpu.display = ReplaceNoCase(cpu.name, '(TM)', '', 'all')
		cpu.display = ReplaceNoCase(cpu.display, '(R)', '', 'all')
		cpu.speedmaxval = ReplaceNoCase(cpu.speedmax, 'mhz', '', 'all')
		cpu.speedmaxval = round(val(cpu.speedmaxval/cpu.cores))
	}
	variables.cpu = serverCPU()
	cpuTrim()

	var success = '<i class="fal fa-check fa-fw brand-success"></i>'
	var danger = '<i class="fal fa-check fa-fw brand-danger"></i>'
	var warning = '<i class="fal fa-check fa-fw brand-warning"></i>'
	var icon = {
		"host":success,
		"serve":success,
		"env":success,
		"app":success,
	}
	var scopes = structKeyList(application)
	if(application.productionHost != cgi.local_host) icon.host = danger
	if(application.pathServingRoot != GetDirectoryFromPath(GetBaseTemplatePath())) icon.serve = warning
	if(application.domain != cgi.server_name) icon.env = danger
</cfscript>
<cfdbinfo name="dbVersion" datasource="#get('dataSourceName')#" dbname="#get('dataSourceUserName')#" password="get('dataSourcePassword')" type="version" />
<cfoutput>
<div class="row">

<div class="col-lg-3 col-md-6 gray">
	<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Web application configuration</h3>
	</div>
	<div class="panel-body">
	System software tools and dependencies.
	</div>
	<table class="table">
	<thead><tr><th colspan="2">Configurations</th></tr></thead>
	<tbody>
		<tr><td>Name</td><td>#get('siteAreas').titles.df2#</td></tr>
		<tr><td>Scope name</td><td>#application.applicationname#</td></tr>
		<tr><td>Production name</td><td>#cgi.local_host# #icon.host#</td></tr>
		<tr><td>Configured production name</td><td>#application.productionHost#</td></tr>
		<tr><td>Configured Domain</td><td>#application.domain#</td></tr>
		<tr><td>Production domain</td><td>#cgi.server_name# #icon.env#</td></tr>
		<tr><td>Serving root path</td><td>#application.pathServingRoot#</td></tr>
		<tr><td>Configured web root path</td><td>#application.pathWwwRoot#</td></tr>
		<tr><td>Web root path</td><td>#GetDirectoryFromPath(GetBaseTemplatePath())# #icon.serve#</td></tr>
		<tr><td>IP exceptions<br><small>maintenance environment IP exceptions</small></td>
		<td><cfloop list="#get("ipExceptions")#" item="local.exception"><samp class="brand-primary">#exception#</samp><br></cfloop></td></tr>
		<tr><td>Your Internet IP</td><td><samp class="black">#Trim(CGI.remote_addr)#</samp> #icon.app#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Scopes</th></tr></thead>
	<tbody>
	<cfloop list="#structKeyList(application)#" index="local.scope">
	<cfif !isSimpleValue(application[scope])><cfcontinue></cfif>
	<tr><td><span class="nowrap">#humanise(scope)#</span></td><td><samp>#application[scope]#</samp></td></tr></cfloop>
	</tbody>
	</table>
	</div>
</div>
<div class="col-lg-2 col-md-4 gray">
	<div class="panel panel-info">
		<div class="panel-heading"><h3 class="panel-title">Hardware</h3></div>
	<div class="panel-body">Information on the server hardware hosting the site.</div>
	<table class="table">
	<thead><tr><th colspan="2">Host drive</th></tr></thead>
	<tbody>
		<tr><td>Label</td><td>#drive.partition##Server.separator.file#</td></tr>
		<tr><td>Free</td><td>#humanizeFileSize(drive.free*1024)#</td></tr>
		<tr><td>Usable</td><td>#humanizeFileSize(drive.total*1024)#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">CPU</th></tr></thead>
	<tbody>
		<tr><td>Specs</td><td>#cpu.display#</td></tr>
		<tr><td>Cores</td><td>#cpu.cores#</td></tr>
		<tr><td>Cache</td><td>#cpu.cache#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Clock</th></tr></thead>
	<tbody>
		<tr><td>UTC</td><td>#DateFormat(Now(),'DD MMMM YYYY')#, #TimeFormat(Now(),"HH:mm")#</td></tr>
	</tbody>
	</table>
	</div>
</div>
<div class="col-lg-2 col-md-4 gray">
	<div class="panel panel-info">
	<div class="panel-heading">
		<h3 class="panel-title">OS.</h3>
	</div>
	<div class="panel-body">
	The operating system and resource usage.
	</div>
	<table class="table">
	<thead><tr><th colspan="2">#Server.os.name#</th></tr></thead>
	<tbody><tr><td>#os.architecture#</td><td>#os.caption#</td></tr></tbody>
	<thead><tr><th colspan="2">RAM</th></tr></thead>
	<tbody>
		<tr><td>Free</td><td>#humanizeFileSize(memory.free)#</td></tr>
		<tr><td>Usable</td><td>#humanizeFileSize(memory.total)#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Java Virtual RAM</th></tr></thead>
	<tbody>
		<tr><td>Free</td><td>#humanizeFileSize(memory.java-java.memoryused)#</td></tr>
		<tr><td>Usable</td><td>#humanizeFileSize(memory.java)#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Java RAM</th></tr></thead>
	<tbody>
		<tr><td>Free</td><td>#humanizeFileSize(java.memoryfree)#</td></tr>
		<tr><td>Usable</td><td>#humanizeFileSize(java.memorymax)#</td></tr>
	</tbody>
	</table>
	</div>
</div>
<div class="col-lg-2 col-md-4 gray">
	<div class="panel panel-info">
	<div class="panel-heading">
		<h3 class="panel-title">Software</h3>
	</div>
	<div class="panel-body">
	Server database and web hosting software.
	</div>
	<table class="table">
	<thead><tr><th colspan="2">Database</th></tr></thead>
	<tbody>
		<tr><td><a href="//dev.mysql.com/downloads/mysql/">MySQL</a></td><td>v#listFirst(dbVersion.DATABASE_VERSION,"-")#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Frontend web</th></tr></thead>
	<tbody>
		<tr><td><a href="//nginx.org/en/">nginx</a></td><td>v#xdata["x-nginx-version"]#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Backend web</th></tr></thead>
	<tbody>
		<tr><td><a href="//tomcat.apache.org">#ListGetAt(Server.servlet.name,1,'/')#</a></td><td>v#ListGetAt(Server.servlet.name,2,'/')#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Java framework</th></tr></thead>
	<tbody>
		<tr><td><a href="//lucee.org">#Server.coldfusion.productname# engine</a></td><td>v#Server.lucee.version#</td></tr>
		<tr><td>Code name</td><td>#Server.lucee.versionName# (#Server.lucee.state#)</td></tr>
		<tr><td>CFML engine</td><td>#replace(left(Server.coldfusion.productversion,7),',','','all')# v#right(Server.coldfusion.productversion,6)#</td></tr>
		<tr><td>Released</td><td>#DateFormat(Server.lucee['release-date'],'d mmmm yyyy')#</td></tr>
	</tbody>
	</table>
	</div>
</div>
<div class="col-lg-3 col-md-6 gray">
	<div class="panel panel-info">
	<div class="panel-heading">
		<h3 class="panel-title">Software dependencies</h3>
	</div>
	<div class="panel-body">
	System software tools and dependencies.
	</div>
	<table class="table">
	<thead><tr><th colspan="2">CFML framework</th></tr></thead>
	<tbody>
		<tr><td><a href="//cfwheels.org">CFWheels</a></td><td>v#get("version")#</td></tr>
		<tr><td>Environment</td><td>#humanize(get('ENVIRONMENT'))#</td></tr>
	</tbody>
	<thead><tr><th colspan="2">Tools</th></tr></thead>
	<tbody>
		<tr><td><a href="//github.com/ansilove/ansilove">#get('myapp').appsAnsilove.name#</a></td>
			<td class="brand-#dangerDefault(FileExists(paths.8))#">#paths.8#</td></tr>
		<tr><td><a href="//www.graphicsmagick.org">#get('myapp').appsgm.name#</a></td>
			<td class="brand-#dangerDefault(FileExists(paths.9))#">#paths.9#</td></tr>
	</tbody>
	</table>
	</div>
</div>

</div>
<div class="row">
	<!--- dependencies --->
	<div class="col-md-12">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Additional software dependencies</h3>
			</div>
			<div class="panel-body">
		<div class="columns-list">
		<cfloop array="#appGroup#" index="local.group">
			<cfset paneltype = "panel-default">
			<!-- #group.name# logs -->
			<cfif group.testOutput contains "ERROR">
				<cfset paneltype = "panel-danger">
			</cfif>
			<div class="panel #paneltype# nobreak-inside">
				<div class="panel-heading">
					<h3 class="panel-title"><i class="fal fa-file-check"></i>
						<cfif Len(group.name)>#group.name#
						<cfelse>#ListLast(group.file,'/')#</cfif>
					</h3>
				</div>
				<div class="panel-body">
					<cfif group.testOutput contains "ERROR">
						<samp title="ID" class="label label-danger">#LCase(group.regname)# is missing</samp>
					<cfelse>
						<samp title="ID" class="label label-success">#LCase(group.regname)#</samp>
					</cfif>
					<p><pre title="Program location">#group.file#</pre></p>
				</div>
			</div>
		</cfloop>
	</div>
	</cfoutput>
	</div>
	</div>
</div>