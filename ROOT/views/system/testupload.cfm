<!---
  	Test file upload view.
	path: views/system/testupload.cfm

@CFLintIgnore
--->
<cfscript>
	var uploadOkay = function() {
		if(IsDefined("uploadedFile") && IsStruct(uploadedFile)) return true;
		return false;
	}
</cfscript>
<cfoutput>
	<div class="panel panel-primary panel-limited-double">
		<div class="panel-heading">
			<h3 class="panel-title">Select and upload file</h3>
		</div>
		<div class="panel-body">
			#startFormTag(controller="System",action="testupload",multipart="true",id="form1")#
			<div class="form-group">
				<label for="fileName">File to analysed</label>
				<input id="fileName" name="fileName" type="file">
				<p class="help-block">Upload a file to learn what information #Server.coldfusion.productname# determines of it.</p>
			</div>
			<button type="submit" class="btn btn-primary">Submit</button>
			#endFormTag()#
		</div>
	</div>
	<div class="panel panel-info panel-limited-double">
		<div class="panel-heading">
			<h3 class="panel-title"><i class="fal fa-info-circle fa-fw fa-lg"></i> Analysed results <cfif uploadOkay()>for <samp>#uploadedFile.clientfile#</samp></cfif></h3>
		</div>
		<table class="table table-condensed  table-striped">
			<cfif IsDefined("uploadedMimeType")>
				<cfif Len(uploadedMimeType)>
					<tr><td>mime type</td><td><samp>#uploadedMimeType#</samp></td></tr>
				<cfelse>
					<tr><td colspan="2"><samp>no results</samp></td></tr>
				</cfif>
			</cfif>
			<cfif uploadOkay()>
				<tr><td>attempted server file</td><td><samp>#uploadedFile.attemptedserverfile#</samp></td></tr>
				<tr><td>server directory</td><td><samp>#uploadedFile.serverdirectory#</samp></td></tr>
				<tr><td>server file</td><td><samp>#uploadedFile.serverfile#</samp></td></tr>
				<tr><td>server file extension</td><td><samp>#uploadedFile.serverfileext#</samp></td></tr>
				<tr><td>server file name</td><td><samp>#uploadedFile.serverfilename#</samp></td></tr>
				<tr><td>client directory</td><td><samp>#uploadedFile.clientdirectory#</samp></td></tr>
				<tr><td>client file</td><td><samp>#uploadedFile.clientfile#</samp></td></tr>
				<tr><td>client file extension</td><td><samp>#uploadedFile.clientfileext#</samp></td></tr>
				<tr><td>client file name</td><td><samp>#uploadedFile.clientfilename#</samp></td></tr>
				<tr><td>content subtype</td><td><samp>#uploadedFile.contentsubtype#</samp></td></tr>
				<tr><td>content type</td><td><samp>#uploadedFile.contenttype#</samp></td></tr>
				<tr><td>date last accessed</td><td><samp>#uploadedFile.datelastaccessed#</samp></td></tr>
				<tr><td>file existed</td><td><samp>#uploadedFile.fileexisted#</samp></td></tr>
				<tr><td>file size</td><td><samp>#uploadedFile.filesize#</samp> <span class="badge">#humanizeFileSize(Val(uploadedFile.filesize))#</span></li>
				<tr><td>file was appended</td><td><samp>#uploadedFile.filewasappended#</samp></td></tr>
				<tr><td>file was over written</td><td><samp>#uploadedFile.filewasoverwritten#</samp></td></tr>
				<tr><td>file was renamed</td><td><samp>#uploadedFile.filewasrenamed#</samp></td></tr>
				<tr><td>file was saved</td><td><samp>#uploadedFile.filewassaved#</samp></td></tr>
				<tr><td>old file size</td><td><samp>#uploadedFile.oldfilesize#</samp></td></tr>
				<tr><td>time created</td><td><samp>#uploadedFile.timecreated#</samp></td></tr>
				<tr><td>time last modified</td><td><samp>#uploadedFile.timelastmodified#</samp></td></tr>
			</cfif>
		</table>
	</div>
</cfoutput>