<!---
    Request SESSION start
	path: events/onsessionstart.cfm

@CFLintIgnore
--->
<cfscript>
	/*
	 * Values are boolean Yes/No integers
	 * ALSO set values in onrequeststart.cfm
	 */
	try { session.errcnt = 0 }
	catch(any err) {}
	try {
		client.display = {
			"yt":1
		}
		if(dntUser()) {
			// disable YouTube
			client.display.yt = 0
		}
	}
	catch(any err) {}
</cfscript>