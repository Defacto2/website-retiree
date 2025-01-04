<!---
  	Send your files Demozoo, Pouet view.
	path: views/upload/external.cfm

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
				#startFormTag(action="submitFile",multipart="false",id="form1")#
					#includePartial("navigationtabs")#
					#includePartial("inputExternal")#
					#includePartial("inputTitle")#
					#includePartial("inputPublication")#
					#includePartial("inputDate")#
					#includePartial("inputCredits")#
					#includePartial("inputPlatform")#
					#includePartial("inputComment")#
					#hiddenFieldTag(name="newFile[uploadtype]",id="newFile-uploadtype",value="external")#
					#hiddenFieldTag(name="newFile[web_id_youtube]",id="newFile-web_id_youtube",value="")#
				#endFormTag()#
			</div>
		</div>
	#includePartial("listofthumbs")#
	</div>
</cfoutput>