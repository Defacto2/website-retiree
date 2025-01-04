<!---
	Package or archive content listed as a directory list partial view.
	path: views/files/_prod_archive-dir.cfm

@CFLintIgnore
--->
<cfscript>
	param name="fileContentCount" default="0";
	param name="fileContentList" default="";
	var style = function(string item="") {
		count++
		var file = {
			"id":"",
			"color":"mod1",
			"style":"",
			"textColor":"text-muted",
			"title":"",
		}
		file.id = "FCL" & count
		if(!count MOD 2 && ListLen(fileContentList) > 3) file.color = "mod2";
		if(Right(Trim(arguments.item),1) == "/") {
			file.textColor = "gray-light";
			return file
		}
		// color known filenames
		switch(arguments.item){
			case "scene.org.txt":
				return file;
			case "member.lst":
				file.textColor = "text-info";
				return file;
			default:
		}
		// colour known file extensions
		// see footer.js for coop links
		if(ListFindNocase("exe,com,bat",fileExtension(arguments.item))) {
			file.textColor = "text-primary";
			if(opCheck('coop')) file.title = 'Use as the filename to launch';
			return file
		}
		if(ListFindNocase("nfo,diz,txt,ans,asc,doc",fileExtension(arguments.item))) {
			file.textColor = "text-info";
			if(opCheck('coop')) file.title = 'Use as the text formatted file to showcase';
			return file
		}
		if(ListFindNocase("gif,pcx,png,jpg",fileExtension(arguments.item))) {
			file.textColor = "text-dark";
			return file
		}
		if(ListFindNocase(get(myapp).acceptedArchives,fileExtension(arguments.item))) {
			file.textColor = "text-success";
			return file
		}
		if(ListFindNocase("far,it,mod,mptm,s3m,stm,xm",fileExtension(arguments.item))) {
			file.textColor = "text-dark";
			return file
		}
		return file
	}
	var fixName = function(string item="") {
		var baseName = fileWithoutExtension(fileProd.filename) & "/"
		var lenBase = len(baseName)
		if(lenBase == len(item)) return item;
		if(left(item, lenBase) == baseName) return right(item, len(item)-lenBase);
		return item;
	}
	var count = 0
	var noun = "item"
	if(fileContentCount > 1) noun &= "s";
</cfscript>
<cfoutput>
	<div class="panel panel-default" id="file-archive-panel">
		<div class="panel-heading">
			<span><i class="fal fa-archive fa-fw" title="Archive content"></i> <span id="fileContentCount">#fileContentCount#</span> #noun# in the archive</span><cfif opCheck('coop')> <kbd class="pull-right text-uppercase">Ctrl+Alt+I</kbd></cfif>
		</div>
		<ul class="list-group hidden">
			<a class="list-group-item" id="fapResize">Show more</a>
		</ul>
		<div class="panel-body font-mono" id="file-archive-content">
			<ul id="fileList" class="break-all">
				<cfloop list="#fileContentList#" index="local.item">
					<cfset item = fixName(item)>
					<cfset local.file = style(item)>
					<cfif opCheck('coop')>
						<li id="#file.id#" class="#file.color# #file.textColor#" title="#file.title#">#XmlFormat(item)#</li>
					<cfelse>
						<li id="#file.id#" class="#file.color# #file.textColor#">#XmlFormat(item)#</li>
					</cfif>
				</cfloop>
				<cfif Right(item,3) EQ "...">
					<li class="brand-danger">This list was intentionally cut short to #ListLen(fileContentList)# items to keep the load-times acceptable.</li>
				</cfif>
			</ul>
		</div>
	</div>
</cfoutput>