<!---
  	System section disabled view.
	path: views/system/siteareadisabled.cfm

@CFLintIgnore
--->
<cfheader statuscode="403" statustext="Forbidden">
<cfoutput>
	<h1 class="header-operator"><i class="fal fa-exclamation-circle fa-fw"></i> #humanize(params.controller)# section disabled</h1>
	Sorry the section or page you requested has been switched off.
</cfoutput>