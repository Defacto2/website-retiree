<cfscript>
	// Place helper functions here that should be available for use in all view pages of your application.
	// See controllers/Controller.cfc for functions intended for use with controllers
	// See events/functions.cfm for universal functions that work in controllers, models and views
	//
	// Container to load helper functions that are written in CFScript.
	variables.myapp = "myapp"

	// HTML <HEAD> & <META> tag functions
	include template="helpers-meta.cfm";

	// String and other HTML functions
	include template="helpers-string.cfm";

	// Hardware and system interactions functions
	include template="helpers-system.cfm";

	// Drop-down menu functions
	include template="helpers-dropmenus.cfm";

</cfscript>