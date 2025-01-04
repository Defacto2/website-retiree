
<!---
  	The upload form does not work partial view.
	path: views/upload/_warning.cfm

@CFLintIgnore
--->
<cfif get('environment') eq 'development'>
	<p class="text-warning"><mark>The upload form does not work in the cfwheels development environment</mark></p>
</cfif>