<!---
	HTML 3 layout
	path: views/html3/layout.cfm

@CFLintIgnore
--->
<cfprocessingdirective suppressWhiteSpace = "no"><cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<!-- http://www.w3.org/MarkUp/Wilbur/ -->
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="description" content="A Firefox 2.0 (Oct 2006) compatible page that is friendly for legacy systems inc. Windows 98, NT 4, OS X v10.2">
  <link href="/" rev="HTML5" title="Standard website">
  <meta name="robots" content="noindex, nofollow">
  <title>Index of #pathDir()#</title>
 </head>
<body>
<h2>Index of #pathDir()#</h2><cfif IsDefined("records")>#includePartial("wgetinfo")#</cfif><cfif flashKeyExists("missingfile")>
<p>#flash("missingfile")#</p></cfif><cfif !wgetmode()><pre>#Trim(contentForLayout())#</pre><cfelse>#Trim(contentForLayout())#</cfif></cfoutput>
<hr>
<em><cfoutput>#get('siteAreas').titles.df2# Server at #cgi.server_name# port #cgi.server_port# with a load time of #((GetTickCount()-Request.tickCount)/1000)# seconds<cfif wgetmode()> (wget mode)</cfif></cfoutput></em>
</body></html></cfprocessingdirective>