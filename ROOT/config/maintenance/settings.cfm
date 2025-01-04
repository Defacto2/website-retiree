<!---
    Maintenance config
	  path: config/maintenance/settings.cfm

@CFLintIgnore
--->
<cfscript>
  loc.myapp = {
    "starttime":Now(),
  }
  set(myapp=loc.myapp)
</cfscript>