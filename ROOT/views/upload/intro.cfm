<!---
  	Send your files intros, cracktros view.
	path: views/upload/intro.cfm

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout="#get('myapp').timeoutUp#";
	variables.platforms = [["windows","Windows"],["dos","DOS"]]
	param.job = 'code,gfx,music'
	param.fileisIntro = true
</cfscript>
<cfoutput>
<!-- form to upload intro and cracktro files -->
	<div id="uploadController" class="readable-text col-lg-7 col-md-12">
		<div class="panel panel-info">
			#includePartial("inputHeader")#
			<div class="panel-body">
				#includePartial("debugOutput")#
				#startFormTag(action="submitFile",multipart="true",id="form1",autocomplete="on")#
					#includePartial("inputFiles")#
					#includePartial("navigationtabs")#
					#includePartial("inputTitle")#
					#includePartial("inputPlatform")#
					#includePartial("inputPublication")#
					#includePartial("inputDate")#
					#includePartial("inputCredits")#
					#includePartial("inputReferences")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="section",value="releaseadvert")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="intro")#
				#endFormTag()#
				#includePartial("inputAutoclear")#
			</div>
		</div>
	#includePartial("listofuploads")#
	</div>
</cfoutput>