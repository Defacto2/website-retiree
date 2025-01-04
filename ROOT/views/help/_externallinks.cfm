<!---
	Help external links partial view.
	path: views/home/_externallinks.cfm
	note: the details element relies on CSS for open/closing effects.
@CFLintIgnore
--->
<details class="panel panel-default">
	<summary class="panel-heading">External links</summary>
	<div class="panel-body">
		<ol>
			<cfoutput>
				<cfloop array="#extlink#" index="local.link">
					<cfif Len(Trim(local.link)) is 0><cfcontinue></cfif>
					<li>#autoLink(local.link)#</li>
				</cfloop>
			</cfoutput>
		</ol>
	</div>
</details>