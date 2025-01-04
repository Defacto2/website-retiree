<!---
  	Send your files "note" view.
	path: views/upload/site.cfm

	This is the index for the upload application.

@CFLintIgnore
--->
<cfscript>
	param name="commentReq" default=true type="boolean";
</cfscript>
<cfsetting requesttimeout="#get('myapp').timeoutUp#">
<cfoutput>
	<div id="uploadController" class="readable-text col-lg-7 col-md-12">
		<p class="lead">Do you have files we should host?</p>
		<div class="panel panel-info">
			#includePartial("inputHeader")#
			<div class="panel-body">
				<div class="row">
					<div class="col-sm-12">
						#includePartial("debugOutput")#
					</div>
				</div>
				#startFormTag(action="submitFile",multipart="true",id="form1",method="post")#
					#includePartial("inputFiles")#
					#includePartial("navigationtabs")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="note")#
				#endFormTag()#
				#includePartial("inputAutoclear")#
			</div>
		</div>
		#includePartial("listofuploads")#
	</div>
</cfoutput>