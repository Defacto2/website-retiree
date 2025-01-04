<!---
	Learn about Defacto2 controller file.
	path: controllers/Defacto2.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="checkControllerState")
	}

	title = "What is #get('siteAreas').titles.df2#?"
	breadcrumbs &= appendCrumb(2, 'about', urlFor(route="defacto2"))
	description = "Learn about Defacto2 and the website defacto2.net"

	function counterculture() {
		redirectTo(action="subculture", statusCode="301")
	}
	function donate() {
		title = "Tip"
		description = "Feel good by helping out in keeping Defacto2 online"
		breadcrumbs &= appendCrumb(3, 'donate', urlFor(controller="defacto2", action="donate"))
	}
	function index() {}
	function history() {
		title = "The history of #get('siteAreas').titles.df2#"
		description = "Learn about the origins of Defacto2 and its history"
		breadcrumbs &= appendCrumb(3, 'history', urlFor(controller="defacto2", action="history"))
	}
	function subculture() {
		title = "What is the Scene?"
		description = "Learn about the different communities of the computer underground scene"
		breadcrumbs &= appendCrumb(3, 'subculture', urlFor(controller="defacto2", action="subculture"))
	}
	function thankyou() {
		title = "Thank you"
		breadcrumbs &= appendCrumb(3, 'thank you', urlFor(controller="defacto2", action="thankyou"))
	}
}