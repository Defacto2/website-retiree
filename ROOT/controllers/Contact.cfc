<!---
	Email or chat controller file.
	path: controllers/Contact.cfc
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

	breadcrumbs &= appendCrumb(2, 'contact', urlFor('c'))
	description = 'Contact information'
	title = "Contact"
}