<!---
    request START event
	path: events/onrequeststart.cfm

@CFLintIgnore
--->
<cfscript>
	var emulator = "emu"
	var youtube = "yt"
	var devNullReq = function() {
		return listFindNoCase(request.nocookies1,CGI.path_info,";")
	}
	var jsonReq = function() {
		if(listLen(CGI.path_info,"/") < 2) return false
		if(!listFindNoCase(request.nocookies2,listGetAt(CGI.path_info,2,"/"),";")) return false
		return true
	}
	var emulate = function() {
		if(cgi.http_user_agent contains "mobile") return 0
		if(cgi.http_user_agent contains "android") return 0
		if(cgi.http_user_agent contains "ios") return 0
		return 1
	}
	var features = function() {
		// Values are boolean Yes/No integers
		// ALSO set values in onsessionstart.cfm
		if(!StructKeyExists(client,"display")) client.display = {}
		if(!StructKeyExists(client.display,emulator)) client.display[emulator] = emulate();
		// embedded YouTube video
		if(!StructKeyExists(client.display,youtube)) client.display[youtube] = 1
		// do not track enabled?
		if(dntUser()) {
			// disable youtube
			if(!StructKeyExists(client.display,youtube)) client.display[youtube] = 0
		}
	}
	// Place code here that should be executed on the "onRequestStart" event.
	// cookie exclusions
	request.nocookies1 = "/dev/null"
	request.nocookies2 = "data-json;update-json;data-json;organisation-json"
	request.tickCount = GetTickCount()
	// uncomment for debugging
	//header name="CGI.path_info" value="#CGI.path_info#";
	/*
	 * Set-up Session extras
	 */
	if(devNullReq() || jsonReq()) {
		this.setClientCookies = false;
	} else {
		features()
	}
	/*
	 * Hacker time-out zone
	*/
	if(!structKeyExists(session,"errcnt")) return;
	if(!isNumeric(session.errcnt)) return;
	if(session.errcnt < 100) return;
	if(CGI.path_info contains "/dev/null") return;
	location(url="https://#application.domain#/dev/null", addtoken=false, statusCode=302);
</cfscript>