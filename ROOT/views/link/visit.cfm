<!---
  	Jump to website view.
	path: views/link/visit.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="alert alert-info"><i class="fal fa-forward fa-fw"></i> We are forwarding you to the requested link.</div>
	<cflocation addtoken="false" url="#website.uriRef#">
</cfoutput>