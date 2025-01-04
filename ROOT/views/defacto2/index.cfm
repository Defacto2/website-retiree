<!---
    Learn about Defacto2 view
	path: views/defacto2/index.cfm

@CFLintIgnore
--->
<cfscript>
	param name="extlink" type="string" default="";
	extlink = ['https://en.wikipedia.org/wiki/IBM_PC_Compatible','https://en.wikipedia.org/wiki/MS-DOS']
	pageAbout.text = 'About #get('siteAreas').titles.df2#'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<div class="readable-text" id="defacto2-controller">
		<!-- Introduction class="readable-text" -->
		<p class="lead text-center">#get('siteAreas').titles.df2# is a website committed to the preservation of the historic PC cracking and warez scene subcultures.</p>
		<div class="panel panel-default">
			<div class="panel-body text-left">
				<p class="lead">Defacto2 is a website committed to preserving the historic PC cracking and warez scene subcultures.
It covers objects including text files, demos, music, art, magazines, and other projects.
While a seldom-discussed subject, this element of the underground computer subculture could be lost and forgotten without a preservation effort.
The nature of robin-hood piracy, with its high churn for participants, means it is a community that is not well documented nor explained.
Unfortunately, some files have comments or imagery that aren't acceptable in a modern context—a possible consequence of the era and the ages of the people involved.</div>
			<div class="list-group">
				<a href="#UrlFor(controller="Defacto2", action="subculture", rel="prefetch", id="GotoNextPage")#" class="list-group-item"><h4 class="list-group-item-heading">What is the Scene?</h4></a>
				<a href="#UrlFor(controller="Defacto2", action="history", rel="prefetch", id="GotoLastPage")#" class="list-group-item"><h4 class="list-group-item-heading">A history of #get('siteAreas').titles.df2#</h4></a>
			</div>
		</div>
		<details class="panel panel-default">
			<summary class="panel-heading">External links</summary>
			<div class="panel-body">
				<ol>
					<cfloop array="#extlink#" index="local.link"><li>#autoLink(link)#</li></cfloop>
				</ol>
			</div>
		</details>
	</div>
</cfoutput>