<!---
	Database data & GitHub controller file.
	path: controllers/Code.cfc
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

    breadcrumbs &= appendCrumb(2, 'code', URLFor(route='code'))

    function index() {
		title = "Database data &amp; GitHub"
		description = "Application programming interface, source code and data exports"
	}
}