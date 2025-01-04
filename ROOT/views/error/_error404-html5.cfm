<!---
    404 Not found view
	path: views/defacto2/_error404-html5.cfm

@CFLintIgnore
--->
 <cfoutput>
	<div id="on-missing-templete">
		<p class="brand-danger"><strong>Sorry the page request does not exist</strong></p>
		<p>
			A non-existent page usually means the link used to arrive here was mistyped or is out of date.<br>
			Maybe you can find what you were attempting to view by using <a href="#urlFor(controller='search',action='result',params='search=all')#">the search engine</a>?
		</p>
	</div>
</cfoutput>