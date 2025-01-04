<!---
    Production config
	  path: config/production/settings.cfm

@CFLintIgnore
--->
<cfscript>
  // Enable controllers and functions of the website
  try {
    loc["siteAreas"] = get("siteAreas")
    set(siteAreas=loc.siteAreas)
  }
  catch(any err) {}
</cfscript>