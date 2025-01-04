<!---
  	Send your files asynchronous response view.
	path: views/upload/responseasync.cfm

	JS, HTML5 multi-file form uploads.

	"fileProcessed" param is a Upload.cfc > _savefile(params) function return.

@CFLintIgnore
--->
<cfscript>
	param name="fileProcessed" type="struct";
	param name="fileProcessed.errors" type="array";
	param name="fileProcessed.itemNumber" type="numeric" default="-1";
	param name="fileProcessed.clientfile" type="string" default="";
	param name="fileProcessed.filesize" type="numeric" default="-1";
	param name="fileProcessed.contenttype" type="string" default="";
	param name="fileProcessed.contentsubtype" type="string" default="";
	param name="fileProcessed.wassaved" type="boolean" default=false;
	param name="fileProcessed.wasstored" type="boolean" default=false;

	setting requesttimeout="#get('myapp').timeoutUp#";
	header name="Content-Type" value="application/json";
	var cnt=0
	var fpi = fileProcessed
</cfscript>
<cfsavecontent variable="string"><cfoutput>
	"item": #fpi.itemNumber#,
	"name": "#jsonFormat(fpi.clientfile)#",
	"size": #JSStringFormat(fpi.filesize)#,
	"type": "#JSStringFormat('#fpi.contenttype#/#fpi.contentsubtype#')#",
	"wassaved": #fpi.wassaved#,
	"wasstored": #fpi.wasstored#,
	"errors": [
	<cfif arrayLen(fpi.errors)>
		<cfloop array="#fpi.errors#" index="local.errs">
		<cfset cnt++>
		"#JSStringFormat(errs.message)#"<cfif cnt lt arrayLen(fpi.errors)>,</cfif>
		</cfloop>
	</cfif>
	]
</cfoutput></cfsavecontent>
<cfcontent type="application/json"><cfoutput>{#string#}</cfoutput></cfcontent>