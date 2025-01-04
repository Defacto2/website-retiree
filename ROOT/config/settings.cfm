<!---
	Defacto2 website settings
	path: config/settings.cfm

	MOST CHANGES TO THIS PAGE WILL REQUIRE A RESTART OF APACHE TOMCAT

@CFLintIgnore
--->
<cfscript>
{
	/**
	 * Settings that go in the APPLICATION scope.
	 */
	// IP address of the testing server, used to automatically adjust some configuration settings
	// (these also need to be reconfigured in the app.cfm).
	application.testServer = "localhost"
	application.productionHost = "defacto2"
	// System generated root path
	application.pathWwwRoot = GetDirectoryFromPath(GetBaseTemplatePath())
	// Fully qualified domain name of the hosting server (i.e defacto2.net) or the server IP address.
	if(CGI.server_name == 'localhost') application.domain = "localhost"
	else application.domain = "#server_name#"
	// Regional Settings
	application.locale = "en_US"
	/*
	 * Site controllers
	 */
	// All controllers contained within /controllers/ (except Dev, Wheels and Controller)
	// should be listed here with a Boolean value to set their usage state.
	loc.siteAreas = {
		"commercial":true,
		"contact":true,
		"defacto2":true,
		"file":true,
		"help":true,
		"html3":true,
		"link":true,
		"operator":true,
		"organisation":true,
		"person":true,
		"search":true,
		"system":true,
		"upload":true,
		"home":true,
		// site feature titles
		"titles":{
			"df2":"Defacto2",
			"file":"Files",
			"organisation":"Groups",
			"person":"People",
			"link":"Websites",
			"home":"Home",
			"whowhere":"Connections",
		},
		// Allow file download (i.e defacto2.net/d/abcde) to work from 3rd party websites.
		"directDownloads":true,
		// When false all users will be blocked from accessing the login form.
		"operatorLogin":loadJSONConfig("operator.login"),
		// When running as localhost (Docker) and set to true, everyone is able to access
		// the operator controllers.
		"operatorBypass":loadJSONConfig("operator.bypass"),
	}
	// Instigate siteAreas [do not modify]
	set(siteAreas=loc.siteAreas)
	/*
	 * Email address for receiving notifications on critical web application errors
	 */
	set(errorEmailAddress = loadJSONConfig("email.address.error"))
	set(functionName="sendEmail",
		server=loadJSONConfig("email.server"),
		username=loadJSONConfig("email.username"),
		password=loadJSONConfig("email.password"),
		usetls=true)
	/*
	 * Data source for Cfwheels to use
	 * See app.cfm for the data source configuration
	 */
	set(dataSourceName="defacto")
	// leave these values blank
	set(dataSourceUserName="")
	set(dataSourcePassword="")
	/*
	 * Load application and server settings contained in /config/settings-[file].cfm
	 */
	// Holder for custom settings [do not modify]
	loc.myapp = {}
	// These must be loaded in a specific order.
	include "/config/settings-paths.cfm";
	// Dynamically load the read of the settings-[files].cfm
	var files = directoryList(application.pathWwwRoot & "/config/", false, "name", "settings-*.cfm", "name asc");
	for(var file in files) {
		if(file == "settings-path.cfm") continue;
		include "/config/#file#";
	}
	// Create a container for all the 'myapp' settings
	set(myapp=loc.myapp)
}
</cfscript>