<!---
  	Send your files BBS, FTP ads view.
	path: views/upload/site.cfm

@CFLintIgnore
--->
<cfscript>
	setting requesttimeout="#get('myapp').timeoutUp#";
	param.job = 'write,code,gfx,music'
	param.fileisSite = true
</cfscript>
<cfoutput>
<!-- form to upload bbs/ftp files -->
	<div id="uploadController" class="readable-text col-lg-7 col-md-12">
		<div class="panel panel-info">
			#includePartial("inputHeader")#
			<div class="panel-body">
				#includePartial("debugOutput")#
				#startFormTag(action="submitFile",multipart="true",id="form1")#
					#includePartial("inputFiles")#
					#includePartial("navigationtabs")#
					#includePartial("inputTitle")#
					#includePartial("inputSite")#
					#includePartial("inputPlatform")#
					#includePartial("inputDate")#
					#includePartial("inputCredits")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="site")#
				#endFormTag()#
				#includePartial("inputAutoclear")#
			</div>
		</div>
	#includePartial("listofuploads")#
	</div>
</cfoutput>