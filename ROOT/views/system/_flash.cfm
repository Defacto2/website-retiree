<!---
  	CFWheels flash feedback partial view.
	path: views/system/_flash.cfm

@CFLintIgnore
--->
<cfif !flashCount()><cfreturn></cfif>
<cfoutput>
<cfif flashKeyExists('success')>
	<div class="alert alert-success"><i class="fal fa-check fa-fw fa-lg"></i> <b>#stripTags(flashMessages(key="success"))#</b></div>
<cfelseif flashKeyExists('warning')>
	<div class="alert alert-warning"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i> <b>#stripTags(flashMessages(key="warning"))#</b></div>
<cfelseif flashKeyExists('danger')>
	<div class="alert alert-danger"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i> <b>#stripTags(flashMessages(key="danger"))#</b></div>
</cfif></cfoutput>