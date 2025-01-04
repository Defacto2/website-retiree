<!---
    External links partial view.
	path: views/files/_prod_nav-links.cfm

@CFLintIgnore
--->
<cfoutput>
	<cfif termforwebsearch != '""'>
	<li role="presentation" title="Search the Demozoo database" data-toggle="tooltip" data-placement="top">
		<a aria-label="Search the Demozoo database" href="https://demozoo.org/search/?q=#termforwebsearch#" id="">
		<i class='fal fa-search-plus fa-fw'></i> Demozoo</a></li>
	<li role="presentation" title="Search on Google" data-toggle="tooltip" data-placement="top">
		<a aria-label="Search on Google" href="https://google.com/search?q=#termforwebsearch#" id="">
		<i class='fal fa-search fa-fw'></i> Google</a></li>
	</cfif>
</cfoutput>