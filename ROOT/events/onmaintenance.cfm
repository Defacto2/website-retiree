<!---
    Maintenance event
	path: events/onmaintenance.cfm

@CFLintIgnore
--->
<cfscript>
	var timeDown = function() {
		var minutes = 0
		var hours = 0
		try {
			minutes = DateDiff("n",get("myapp").starttime,Now())
			hours = DateDiff("h",get("myapp").starttime,Now())
		}
		catch(any excp) {}
		if(minutes == 1) return minutes & " minute";
		if(minutes lte 59) return minutes & " minutes";
		if(hours == 1) return hours & " hour";
		if(hours gt 1) return hours & " hours";
		return "ERROR"
	}
</cfscript>
<!--- Place HTML here that should be displayed when the application is running in "maintenance" mode. --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<link href="/stylesheets/layout-2019.10.1.min.css" media="all" rel="stylesheet" type="text/css" />
		<style>
			body {font-family: "Roboto";}
		</style>
	</head>
	<body>
		<div class="layout-container">
			<div class="layout-content">
				<h1>🤖 Down for maintenance</h1>
				<div>
					<p>
					<cfoutput>Sorry, <cftry><strong>#get('siteAreas').titles.df2#</strong><cfcatch></strong>this site</cfcatch></cftry> <cftry>(#application.domain#) <cfcatch></cfcatch></cftry>is offline while maintenance work is ongoing.</cfoutput>
					</p>
					<cftry>
					<p>
						The site has been shutdown for <cfoutput>#timeDown()#</cfoutput>. Please try again in a short while.
					</p>
					<cfcatch></cfcatch>
					</cftry>
					<q>beep boop boop bop</q>
				</div>
			</div>
		</div>
	</body>
</html>