<!---
  	Send your files DEBUG asynchronous response view.
	path: views/upload/responseasyncdebug.cfm

	JS, HTML5 multi-file form uploads.

	"fileProcessed" param is a Upload.cfc > _savefile(params) function return.

@CFLintIgnore
--->
<cfscript>
	var jsonPut = '{"error":"fileProcessed variable is an invalid type"}';
	var debug = function() {
		if(isSimpleValue(fileProcessed)) {
			jsonPut = fileProcessed
			return
		}
		if(!isStruct(fileProcessed)) return;
		if(structKeyExists(gethttprequestdata().headers, "X-File-Count")) {
			xfile = {"fileCount"=gethttprequestdata().headers["X-File-Count"]};
			StructAppend(fileProcessed,xfile);
		}
		if(structKeyExists(gethttprequestdata().headers, "X-File-Name")) {
			xfile = {"fileName"=gethttprequestdata().headers["X-File-Name"]};
			StructAppend(fileProcessed,xfile);
		}
		if(structKeyExists(gethttprequestdata().headers, "X-File-Size")) {
			xfile = {"fileSize"=gethttprequestdata().headers["X-File-Size"]};
			StructAppend(fileProcessed,xfile);
		}
		// fake the results
		StructAppend(fileProcessed,{"wassaved"=true,"wasstored"=true});
		jsonPut = SerializeJSON(fileProcessed);
	}
	debug()
</cfscript>
<cfcontent type="application/json"><cfoutput>#jsonPut#</cfoutput></cfcontent>