<!---
  	Send your files magazines view.
	path: views/upload/magazine.cfm

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout="#get('myapp').timeoutUp#";
	param.fileisMag = true
	variables.platforms = [["windows","Windows"],["dos","DOS"],["text","Text document"]]
</cfscript>
<cfoutput>
<!-- form to upload magazine issues -->
	<div id="uploadController" class="readable-text col-lg-7 col-md-12">
		<div class="panel panel-info">
			#includePartial("inputHeader")#
			<div class="panel-body">
				#includePartial("debugOutput")#
				#startFormTag(action="submitFile",multipart="true",id="form1")#
					#includePartial("inputFiles")#
					#includePartial("navigationtabs")#
					#includePartial("inputPublication")#
					#includePartial("inputTitle")#
					#includePartial("inputPlatform")#
					#includePartial("inputDate")#
					#includePartial("inputCredits")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="magazine")#
				#endFormTag()#
				#includePartial("inputAutoclear")#
			</div>
		</div>
		#includePartial("listofuploads")#
	</div>
</cfoutput>