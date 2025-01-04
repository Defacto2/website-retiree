<!---
  	Send your files custom view.
	path: views/upload/other.cfm

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout="#get('myapp').timeoutUp#";
</cfscript>
<cfoutput>
<!-- generic form to upload files -->
	<div id="uploadController" class="readable-text col-lg-7">
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
					#includePartial("inputPlatform")#
					#includePartial("inputReferences")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="other")#
				#endFormTag()#
				#includePartial("inputAutoclear")#
			</div>
		</div>
		#includePartial("listofuploads")#
	</div>
</cfoutput>