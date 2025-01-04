<!---
	Application settings
	path: config/settings-application.cfm

@CFLintIgnore
--->
<cfscript>
	/*
	 * Read and set passwords and other sensitive settings
	 */
	// Password for CFWheels reload (required)
	set(reloadPassword = loadJSONConfig("wheels"))
	// Switching environments
	set(allowEnvironmentSwitchViaUrl = true)
	// Maintenance mode IP exceptions
	set(ipExceptions = "127.0.0.1")
	// Restrict IP addresses from downloading files, this is protect the site from malware abuse spam bots such as Clean-MX.
	// To block a range of addresses leave off the appending star values (list 192.168.*.* as 192.168)
	loc.myapp.ipRestrictions = [
		"62.67.194",
		"62.67.240",
		"62.67.241",
		"62.67.242",
		"62.67.243",
		"195.214.79",
		"81.27.124",
		"195.214.79.81",
		"195.214.79",
		"62.67.240.16",
		"62.67.241.16",
		"62.67.194.35"
	]
	/*
	 * URL Rewriting
	 */
	set(obfuscateURLs=false)
	switch(cgi.script_name) {
		case "/index.cfm":
			set(URLRewriting="Off")
			break;
		default:
			set(URLRewriting="On")
	}
	// Cfwheels sends email notification on critical error
	switch(CGI.server_name) {
		case "localhost":
			set(sendEmailOnError=false)
			break;
		default:
			set(sendEmailOnError=true)
	}
	// Controllers to exclude from automated web application error emails
	set(excludeFromErrorEmail= "System,Operator")
	/*
	 * CFWheels Models defaults, overrides
	 */
	set(functionName="findAll",includeSoftDeletes="true")
	set(functionName="findByKey",includeSoftDeletes="true")
	set(functionName="findOne",includeSoftDeletes="true")
	set(functionName="deleteAll",includeSoftDeletes="true")
	set(functionName="deleteByKey",includeSoftDeletes="true")
	set(functionName="deleteOne",includeSoftDeletes="true")
	set(functionName="updateAll",includeSoftDeletes="true")
	set(functionName="updateByKey",includeSoftDeletes="true")
	set(functionName="updateOne",includeSoftDeletes="true")
	// ORM settings
	set(afterFindCallbackLegacySupport=false)
	// Structure of a table to be validated
	loc.myapp.dbTables = "files,groupnames,netresources,users"
	// Name of group_brand_for/group_brand_by organisation name to use exclusively for the testing of files
	loc.myapp.pubNameForTests = "test"
	/*
	 * Miscellaneousness settings
	 */
	var oneMinute = 60
	var fiveMinutes = 300
	var oneHour = 3600
	// Time out (in seconds) for file downloads that are less than 18 MB in size
	loc.myapp.timeoutDown = fiveMinutes
	// Time out (in seconds) for incoming file uploads
	loc.myapp.timeoutUp	= oneHour
	// Time out (in seconds) the for processing time of utilities
	loc.myapp.timeoutArchive = oneMinute
	loc.myapp.timeoutAnsiLove = oneMinute
	loc.myapp.timeoutImage = oneMinute
	// Permitted URI schemes
	// http is unencrypted, https and shttp are encrypted schemes
	loc.myapp.uriSchemes = "http,https"
</cfscript>