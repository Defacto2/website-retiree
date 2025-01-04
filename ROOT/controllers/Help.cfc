<!---
	Help and legal stuff controller file.
	path: controllers/Help.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="checkControllerState,legacyRedirect")
	}

	title = "Help & FAQ"
	breadcrumbs &= appendCrumb(2, 'help', urlFor(route='help'))
	description = 'Help and information on Defacto2'

	/**
	* Redirects legacy controllers and actions to their re-factored destination.
	* See settings-navigation.cfm loc.myapp.re-factored variable.
	*/
	public any function legacyRedirect() {
		param name="params";
		if(StructKeyExists(get(myapp).refactored,params.controller)) {
			for (var redirect in get(myapp).refactored[params.controller]) {
				if (params.action == redirect[1]) redirectTo(action="#redirect[2]#",statusCode="301");
			}
		}
	}

	function allowedUploads() {
		title = "What type of files can I upload?"
		description = "File archives and media formats permitted for submission"
		breadcrumbs &= appendCrumb(3, 'allowed uploads', urlFor(controller='help',action='allowedUploads'))
	}
	function browserSupport() {
		title = "What browsers does this site support?"
		description = "Browser information for the website"
		breadcrumbs &= appendCrumb(3, 'browser support', urlFor(controller='help',action='browserSupport'))
	}
	function categories() {
		title = "Categories used for for sorting and tagging data."
		description = "Categories used for for sorting and tagging data"
		breadcrumbs &= appendCrumb(3, 'data categories', urlFor(controller='help',action='categories'))
	}
	function creativeCommons() {
		title = "What does the Creative Commons site licence mean?"
		description = 'Defacto2 copyrights and information on the Creative Commons licence'
		breadcrumbs &= appendCrumb(3, 'copyrights', urlFor(controller='help',action='creativeCommons'))
	}
	function keyboard() {
		title = "Keyboard input and touch gestures"
		description = "Details on keyboard input and touch gestures used by the site"
		breadcrumbs &= appendCrumb(3, 'keyboard inputs', urlFor(controller='help',action='keyboard'))
	}
	function privacy() {
		title = "Privacy policy"
		description = "The privacy policy of Defacto2 and defacto2.net"
		breadcrumbs &= appendCrumb(3, 'privacy policy', urlFor(controller='help',action='privacy'))
	}
	function viruses() {
		title = "Virus or threat alerts on modern systems?"
		description = "Virus, trojan and malware safety"
		breadcrumbs &= appendCrumb(3, 'viruses &amp; trojans', urlFor(controller='help',action='viruses'))
	}
}