<cfsilent><!---
  	Search result index view.
	path: views/search/_meta.cfm

@CFLintIgnore
--->
<cfscript>
	var count = 0
	if(IsDefined("results.file") && IsQuery(results.file)) count = results.file.recordCount;
	if(IsDefined("results.link") && IsQuery(results.link)) count = results.link.recordCount;
</cfscript></cfsilent><cfoutput><!-- opensearch.org -->
	<link rel="search" href="/osd.xml" type="application/opensearchdescription+xml" title="#get('siteAreas').titles.df2# search">
<cfif params.controller is "Search">	<link rel="search" href="http://a9.com/-/spec/opensearch/1.1/">
	<meta name="totalResults" content="#count#">
	<meta name="startIndex" content="1">
	<meta name="itemsPerPage" content="#count#"></cfif></cfoutput>