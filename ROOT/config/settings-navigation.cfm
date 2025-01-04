<!---
	Default settings for page navigation and data filtering
	path: config/settings-navigation.cfm

@CFLintIgnore
--->
<cfscript>
	/*
	 * Generic page formatting option
	 * @maxPageItems Maximum permitted items, per-page.
	 * @displayValues List of items display format. text only or thumbnails with text.
	 * @orderValues List of permitted items ordering options.
	 */
	loc.myapp.maxPageItems = 150
	loc.myapp.displayValues	= "card,text,thumb,thumb-"
	loc.myapp.orderValues = "title_asc,title_desc,size_asc,size_desc,date_asc,date_desc,posted_asc,posted_desc"
	/*
		New connection and new session defaults.
		DO NOT CHANGE THE STRUCTURE NAMES AS THEIR USAGE ARE NOT ERROR CHECKED
		@FileList.output must be a value from loc.myapp.displayValues.
		@FileList.sort must be a value from loc.myapp.orderValues.
		@FileList.perpage must be a a value from loc.myapp.maxPageItems.
	 */
	loc.myapp.reset = {
		"FileList":{
			"output":"card",
			"sort":"date_asc",
			"perpage":1,
		},
	}
	/*
	 * Re-factored legacy controllers and action redirection.
	 * myapp.refactored must be a 2 dimension array. The 1st array contains a key that is used with the fileFilter route.
	 * It should also be removed from the myapp.fileValues variable. he 2nd array should be a : delimiter list with 2 values, the redirection destination platform value (or - to ignore) and the section value (or - to ignore).
	 *  @files files controller ('QuickLinks' keys)
	 *  @help help controller
	 */
	loc.myapp.refactored = {
		"files":[],
		"help":[],
		files[1] = [ 'intro','-:releaseAdvert' ],
		files[2] = [ 'filepack','-:filepack' ],
		files[3] = [ 'magazine','-:magazine' ],
		files[4] = [ 'nfo','-:releaseInformation' ],
		files[5] = [ 'nfotool','-:nfotool' ],
		help[1] = [ 'filePlatformsAndFormats','categories' ]
	}
</cfscript>