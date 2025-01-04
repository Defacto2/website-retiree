<!---
  	Critical application paths view.
	path: views/system/pathsdashboard.cfm

@CFLintIgnore
--->
<cfscript>
	var checkClass = function(required string path) {
		if(directoryexists(arguments.path)) return "default"
		if(fileexists(arguments.path)) return "default"
		return "danger"
	}
	var count = function(required string path, string filter="*") {
		if(directoryexists(arguments.path)) {
			return ArrayLen(DirectoryList(absolute_path=arguments.path,listInfo='name',filter=arguments.filter));
		}
		return 0;
	}
	var myapp = "myapp"
	var paths = {
		"base":application.pathServingRoot,
		"root":application.pathWwwRoot,
		"wayback":get(myapp).waybackRoot,
		"temporary":get(myapp).tmpDirectory,
	}
	var keyNames = function(required string name) {
		switch(name){
			case "backup":
				return "Backups"
			case "fileuuid":
				return "File downloads"
			case "test":
				return "Uploader tests"
			case "thumb400":
				return "Thumbnail images"
			case "uploadfiles":
				return "Uploader files"
			case "uploadimg":
				return "Uploader previews"
			case "preview":
				return "Preview images"
			case "images":
				return "Image subdirectories"
		default:
			return titleize(lCase(name))
		}
	}

	var list = function() {
		var arr = []
		var ind = 0
		for(var log in variables.logs) {
			ind++
			arr[ind].output = "";
			arr[ind].listOrdered = []
			arr[ind].name = log[2]
			arr[ind].path = log[3]
			arr[ind].filepartname = log[4]
			arr[ind].filter = log[5]
			if(Len(arr[ind].filter)) {
				arr[ind].listFiles = DirectoryList(absolute_path=arr[ind].path,filter='#arr[ind].filter#')
			}
			else arr[ind].listFiles = DirectoryList(absolute_path=arr[ind].path);
			// Fetch and reorder log files
			for(var path in arr[ind].listFiles) {
				if(!fileExists(path)) continue;
				var info = GetFileInfo(path)
				ArrayAppend(arr[ind].listOrdered,"#DateFormat(info.lastmodified,'YYMMDD')##TimeFormat(info.lastmodified,'HHMMSS')#|#info.lastmodified#|#info.size#|#path#")
			}
			ArraySort(arr[ind].listOrdered, "textnocase", "desc")
		}
		return arr
	}
	var colorText = function(required string date) {
		var fmt = "YYYY-MM-DD"
		var date = DateFormat(arguments.date,fmt)
		var now = DateFormat(Now(),fmt)
		if(date == now) return "brand-success";
		if(DateDiff("ww", date, now) <= 1) return "brand-default"; // with a week
		if(DateDiff("m", date, now) <= 1) return "brand-warning"; // over a week
		if(DateDiff("m", date, now) > 1) return "brand-danger"; // over a month
	}
	var logPanel = function() {
		if(!directoryExists(log.path)) return "danger";
		if(!ArrayLen(log.listOrdered)) return "warning";
		return "info";
	}
</cfscript>
<!--- Key locations --->
<cfoutput><div class="row">
<div class="col-lg-6 col-md-12 gray">
	<div class="panel panel-info">
		<div class="panel-heading"><h3 class="panel-title">Key locations</h3></div>
	<div class="panel-body">Directories containing public facing website assets.</div>
	<table class="table">
	<thead><tr><th colspan="3">Files in key paths</th></tr></thead>
	<tbody>
		<tr><td></td><td>Web root</td><td>#paths.root#</td></tr>
		<tr><td><span class="badge">#count(paths.temporary)#</span></td><td>Temporary</td><td>#paths.temporary#</td></tr>
		<tr><td><span class="badge">#count(paths.wayback)#</span></td><td>Wayback websites</td><td>#paths.wayback#</td></tr>
<cfloop list="#lists.more#" index="local.more">	<cfif Left(more,7) neq "fulldir"><cfcontinue></cfif>
<tr class="brand-#checkClass(get(myapp)[more])#">
<td><span class="badge">#count(get(myapp)[more])#</span></td>
<td>#keyNames(ReplaceNocase(more,'fulldir',''))#</td>
<td>#get(myapp)[more]#</td></tr></cfloop>
	</tbody>
	</table>
	</div>
</div>
<!--- Logfiles --->
<cfloop array="#list()#" index="local.log"><cfset local.cnt=0><cfset age="">
<div class="col-lg-6 col-md-12 gray">
	<div class="panel panel-default">
		<div class="panel-heading"><h3 class="panel-title">#log.Name#</h3></div>
<cfif log.Name eq "Lucee">
	<div class="panel-body">Logfiles for the #log.Name# engine Java framework.</div>
<cfelseif log.Name eq "nginx">
	<div class="panel-body">Logfiles for the #log.Name# frontend web server.</div>
<cfelseif log.Name eq "Apache Tomcat">
	<div class="panel-body">Logfiles for the #log.Name# backend web server.<br><small>empty log files are skipped</small></div>
<cfelse>
	<div class="panel-body">Miscellaneous logfiles.</div>
</cfif>
	<table class="table">
	<thead><tr><th colspan="5"><samp>#log.Path#</samp></th></tr></thead>
	<tbody>
<cfloop array="#log.listOrdered#" index="local.item">
	<cfif !fileExists(ListGetAt(item,4,'|'))><cfcontinue></cfif>
	<cfif Val(ListGetAt(item,3,'|')) eq 0><cfcontinue></cfif>
	<cfset age=colorText(ListGetAt(item,2,'|'))>
	<cfif age eq "brand-warning" || age eq "brand-danger"><cfcontinue></cfif>
	<cfset fileName=ReplaceNoCase(ListGetAt(item,4,'|'),log.path,'')>
	<cfset cnt++>
	<cfif log.name is "Lucee" and fileName is "exception.log"><tr class="warning" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><cfelse><tr style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"></cfif>
		<td class="col-lg-1"><small>#cnt#.</small></td>
		<td class="col-lg-1"><a href="#UrlFor(action="download",key="#log.filepartname#-log-#NumberFormat('#cnt#','0000')#")#"><i class="fal fa-download fa-fw"></i></a></td>
		<td class="col-lg-1"><small><cfif Val(ListGetAt(item,3,'|')) eq 0>empty<cfelse>#humanizeFileSize(Val(ListGetAt(item,3,'|')))#</cfif></small></td>
		<td class="col-lg-2"><small class="#age#">#DateFormat(ListGetAt(item,2,'|'),'DD/MM/YYYY')# #TimeFormat(ListGetAt(item,2,'|'),'hh:mm tt')#</small></td>
		<td><samp><a href="#UrlFor(action="logtailed",key="#log.filepartname#-log-#NumberFormat('#cnt#','0000')#")#">#fileName#</a></samp></td>
	</tr>
</cfloop>
	</tbody>
	</table>
	</div>
</div>
</cfloop></div>
</cfoutput>