<!---
	List files in "table view", partial view.
	path: views/files/_list_thumb.cfm

@CFLintIgnore
--->
<cfscript>
	var headerCell = {
		"date":'',
		"mark":'text-decoration:underline;',
		"post":'',
		"size":'',
		"title":''
	}
	if(params.sort contains 'title') headerCell.title = headerCell.mark;
	else if(params.sort contains 'posted') headerCell.post = headerCell.mark;
	else if(params.sort contains 'date') headerCell.date = headerCell.mark;
	else if(params.sort contains 'size') headerCell.size = headerCell.mark;
</cfscript>
<cfoutput>
<div class="table-responsive">
	<table id="list-of-files" class="table table-striped">
		<thead>
			<tr>
				<th id="lof-row1"></th>
				<th id="lof-row2"><span style="#headerCell.title#">Title</span> &amp; Filename</th>
				<th id="lof-row3"><span style="#headerCell.size#">Filesize</span></th>
				<th id="lof-row4"><span style="#headerCell.date#">Published</span></th>
				<th id="lof-row5">Software &amp; media</th>
				<th id="lof-row6">Categories</th>
				<th id="lof-row7">Publishers</th>
				<th id="lof-row8"><span style="#headerCell.post#">Posted</span></th>
			</tr>
		</thead>
		<tbody class="files-table"><cfloop query="collectionFiles">
			<cfif params.controller is "search">#formatFiles()#</cfif>
			#includePartial(partial="/file/list_table-row")#</cfloop>
		</tbody>
	</table>
</div>
</cfoutput>