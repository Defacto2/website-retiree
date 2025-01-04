<!---
  	Send your files nonsynchronous response view.
	path: views/upload/responsesync.cfm

	Legacy, single-file HTML form upload.

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout="#get('myapp').timeoutUp#";
	header name="Content-Type" value="text/html";
	var cnt=0
	var fpi = fileProcessed
	pageAbout.text = 'Submit your files'
	pageAbout.icon = 'fal fa-upload'
</cfscript>
<cfcontent><cfoutput>
<div class="col-sm-12">
	<div class="alert alert-info col-lg-6 col-md-12">Thank you for your submission</div>
	<div id="files-received-container" class="col-lg-6 col-md-12">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">File received</h3>
			</div>
			<table class="table" id="list-of-uploads" id="files-received">
				<tr>
					<td>
						<code>#fpi.clientfile#</code>
						<cfif !fpi.wasstored and arrayLen(fpi.errors)>
							<br>
							<small>
								<cfloop array="#fpi.errors#" index="local.errs">#errs.message#</cfloop>
							</small>
						</cfif>
					</td>
					<td><var>#humanizeFileSize(Val(fpi.filesize))#</var></td>
					<td><kbd>#fpi.contenttype#/#fpi.contentsubtype#</kbd></td>
					<cfif !fpi.wasstored>
						<td class="danger"><span class="fal fa-times fa-fw"></span></td>
					<cfelse>
						<td class="success"><span class="fal fa-check fa-fw"></span></td>
					</cfif>
				</tr>
			</table>
		</div>
	</div>
	<div class="col-sm-12">#linkTo(action="file", text="<strong>Return</strong> to the upload form")#</div>
</div>
</cfoutput></cfcontent>