<!---
    Websites partial view.
	path: views/files/_prod_nav-websites.cfm

@CFLintIgnore
--->
<cfparam name="websites" default="" type="any">
<cfparam name="fileProd.list_links" default="" type="any">
<cfparam name="fileProd.web_id_github" default="" type="any">
<cfoutput>
<cfif (IsQuery(websites) and websites.recordCount) or listLen(fileProd.list_links,"|") or len(fileProd.web_id_github)>
	<li class="dropdown-header">Websites &amp; Resources</li>
</cfif>
<cfif len(fileProd.web_id_github)>
	<li><a href="#UrlFor(href="#get('myapp').github.repos##fileProd.web_id_github#")#"><i class='fab fa-github fa-fw'></i> GitHub repository</a></li>
</cfif>
<cfif listLen(fileProd.list_links,"|")>
	<!--- websites related to the file --->
	<cfloop list="#fileProd.list_links#" delimiters="|" index="local.link">
		<cfif listLen(link,";") is 2>
			<li><a href="#listGetAt(link,2,";")#"></a><i class='fal fa-external-link fa-fw'></i> #listGetAt(link,1,";")#</li>
		<cfelse>
			<li><a href="#link#"><i class='fal fa-external-link fa-fw'></i> #link#</a></li>
		</cfif>
	</cfloop>
</cfif>
<cfif IsQuery(websites) and websites.recordCount>
	<cfloop query=websites>
		<cfset urlscheme = GetToken(websites.uriref,1,"://")>
		<cfif websites.uriref contains "wikipedia.org">
			<!-- wikipedia -->
			<li><a href="#UrlFor(controller="Link",action="visit",key=obfuscateParam(websites.id))#" title="#Trim('#websites.title# #websites.comment#')#"><i class='fab fa-wikipedia-w fa-fw'></i> #websites.title#</a></li>
		<cfelseif ListFindNocase(get("myapp").acceptedURISchemes,urlscheme) is 0>
			<!-- hosted archive -->
			<li><a href="#UrlFor(controller="Link",action="waybackweb",key=obfuscateParam(websites.id))#" title="#Trim('#websites.title# #websites.comment#')#"><i class='fal fa-hdd fa-fw'></i> Hosted website from #websites.date_issued_year#</a></li>
		<cfelse>
			<!-- websites related to the group -->
			<li><a href="#UrlFor(controller="Link",action="visit",key=obfuscateParam(websites.id))#" title="#Trim('#websites.title# #websites.uriref#')#"><i class='fal fa-external-link fa-fw'></i> #GetToken(websites.uriref,2,"://")#</a></li>
		</cfif>
	</cfloop>
</cfif></cfoutput>