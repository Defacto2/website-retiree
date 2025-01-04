<!---
    HTML3 404 Not found view
	path: views/defacto2/_error404-html3.cfm

@CFLintIgnore
--->
<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<!-- http://www.w3.org/MarkUp/Wilbur/ -->
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <link href="http://#application.domain#">
  <title>Index of /html3/#params.action#<cfif StructKeyExists(params,"key")>/#params.key#</cfif></title>
 </head>
<body>
<h1>Index of /html3<cfif params.action neq "index">/#params.action#</cfif><cfif StructKeyExists(params,"key")>/#params.key#</cfif></h1>
<h2><font color="red">Sorry, something went wrong</font></h2>
	<ul>
		<li>Error 500: Sorry, that caused an unexpected error. Please try again later.</li>
		<li><a href="#urlFor(controller='html3')#">Return to the index page</a></li>
	</ul><pre></cfoutput>
<hr></pre>
<address><cfoutput>Server at #CGI.server_name# port #CGI.server_port# with a load time of #((GetTickCount()-Request.tickCount)/1000)# seconds</cfoutput></address>
</body></html>