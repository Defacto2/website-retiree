<!---
    Current application environment - http://docs.cfwheels.org/docs/switching-environments
	  path: config/environment.cfm

@CFLintIgnore
--->
<cfscript>
  switch(CGI.server_name) {
    case "localhost": // no lucee/cfwheels cache
      return set(environment="development");
    default: // lucee/cfwheels cache
      return set(environment="production");
  }
</cfscript>