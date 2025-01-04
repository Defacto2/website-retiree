<!---
	Allowed uploads help view.
	path: views/home/alloweduploads.cfm

@CFLintIgnore
--->
<cfscript>
	var uploads = [
		"acceptedArchives;Archives and Compressed files;",
		"acceptedDocuments;Documents;To upload non-supported documents please archive them first using ZIP before submitting.",
		"acceptedGraphics;Images;",
		"acceptedAudio;Audio;",
		"acceptedVideos;Video;",
		"acceptedPrograms;Program binaries;"]
	pageAbout.text = 'Allowed uploads?'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
    <span class="hidden">
      <!--- used by javascript pagination, should be kept hidden --->
      <button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
      <button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='viruses')#"></button>
      <button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
      <button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
    </span>
  </form>
	<div id="help-controller">
		<p class="lead">The site allows the submission of the archives and media formats which use the following extensions.</p>
		<cfloop array="#uploads#" index="local.upload">
			<div class="col-lg-3 col-md-4 col-sm-5">
			<div class="panel panel-default">
				<div class="panel-heading lead">#ListGetAt(upload,2,";")#</div>
				<cfif ListLen(upload,";") GTE 3>
					<div class="panel-body">#ListGetAt(upload,3,";")#</div>
				</cfif>
<div class="list-group">
<cfloop list="#get(myapp)[ListGetAt(upload,1,';')]#" index="local.item">
<cfset tmp = "ext#item#"><cfif !StructKeyExists(get(myapp),'#tmp#')><cfcontinue></cfif><cfset data = get(myapp)[tmp]>
  <a href="http://#get(myapp)[tmp].www#" class="list-group-item">
    <h4 class="list-group-item-heading">#Replace(get(myapp)[tmp].name,',',', ','all')#</h4>
    <p class="list-group-item-text">
		#get(myapp)[tmp].formal#<br>
		<em>File #pluralize('extension',ListLen(get(myapp)[tmp].extensions),false)#: #get(myapp)[tmp].extensions#</em>
	</p>
  </a>
</cfloop>
</div>
			</div>
			</div>
		</cfloop>
	</div>
</cfoutput>