<!---
    Donation received thank you view
	path: views/defacto2/thankyou.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = ' <span class="mobile-hide">Donate to </span>#get('siteAreas').titles.df2#'
	pageAbout.icon = 'fal fa-gift'
</cfscript>
<cfoutput>
	<div class="readable-text" id="defacto2-controller">
		<h2 class="brand-primary">Thank you very much for your donation.</h2>
		<p class="brand-success">This generous gift will contribute to the on going operations of defacto2.net.</p>
		<div class="well">
			#includePartial('/defacto2/costs')#
		</div>
		<p class="lead text-center">#linkTo(controller="contact",text="Also want to get in contact?")#</p>
	</div>
</cfoutput>