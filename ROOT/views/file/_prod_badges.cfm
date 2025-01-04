<!---
   	Badges and tags partial view.
	path: views/files/_prod_badges.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="pagination-statistics">
		<!-- pagination statistics -->
		<span class="label label-default">#idPosition# of #LCase(pluralize(word="file",count=idCount))#</span>
		<!-- pagination filtering in use -->
		<cfif (Len(tags) and tags neq "-") or params.platform neq "-" or params.section neq "-">
			<span class="label label-warning" data-toggle="tooltip" data-placement="bottom" title="Browsing files tagged with">
				<cfif Len(tags)><i class="fal fa-tags"></i> #LCase(tags)# </cfif>
				<cfif params.platform neq "-"><i class="fal fa-tag"></i> #LCase(getPlatformName(params.platform))#</cfif>
				<cfif params.section neq "-"><i class="fal fa-tag"></i> #LCase(getSectionName(params.section))#</cfif>
			</span>
		</cfif>
	</div>
</cfoutput>