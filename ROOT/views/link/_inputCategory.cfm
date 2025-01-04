<!---
  	Link form "Category key" partial view.
	path: views/link/_inputCategory.cfm

@CFLintIgnore
--->
<cfscript>
	param name="categorysort" default="";
</cfscript>
<cfoutput>
	<div class="row">
		<div class="col-sm-6">
			<div class="form-group form-group-sm">
				<label class="control-label text-muted" for="websiteCategoryKey">Category key</label>
				<select class="form-control input-sm" id="websiteCategoryKey" name="website[categorykey]">
					<option value="">&nbsp;</option>
					<cfloop list="#ValueList("categoryKeys.categorykey")#" index="local.catindex">
						<cfif catindex is "-" or catindex is "">
							<cfcontinue>
						</cfif>
						<cfif website.categorykey is catindex><option value="#catindex#" selected>#humanize(catindex)#</option>
						<cfelse><option value="#catindex#">#humanize(catindex)#</option></cfif>
					</cfloop>
				</select>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="form-group form-group-sm">
				<label class="control-label text-muted" for="website-categorysort">Sort key</label>
				<select class="form-control input-sm" id="website-categorysort" name="website[categorysort]">
					<option value="">&nbsp;</option>
					<cfloop query="categorySorts">
						<cfif website.categorysort is categorysort><option value="#categorysort#" selected>#humanize(categorysort)#</option>
						<cfelse><option value="#categorysort#">#humanize(categorysort)#</option></cfif>
					</cfloop>
				</select>
			</div>
		</div>
	</div>
</cfoutput>
