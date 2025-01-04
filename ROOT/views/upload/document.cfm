<!---
  	Send your files documents, NFOs view.
	path: views/upload/document.cfm

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout="#get('myapp').timeoutUp#";
	param.job = 'gfx,write'
</cfscript>
<cfoutput>
<!-- form to upload document files -->
	<div id="uploadController" class="readable-text col-lg-7 col-md-12">
		<div class="panel panel-info">
			#includePartial("inputHeader")#
			<div class="panel-body">
				#includePartial("debugOutput")#
				#startFormTag(action="submitFile",multipart="true",id="form1")#
					#includePartial("inputFiles")#
					#includePartial("navigationtabs")#
					#includePartial("inputTitle")#
					#includePartial("inputPublication")#
					#includePartial("inputDate")#
					#includePartial("inputCredits")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="document")#
				#endFormTag()#
				#includePartial("inputAutoclear")#
			</div>
		</div>
	#includePartial("listofuploads")#
	</div>
</cfoutput>