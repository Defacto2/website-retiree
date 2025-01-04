<!---
    Donate view
	path: views/defacto2/donate.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout['text'] = '<span class="mobile-hide">Help out </span>#get('siteAreas').titles.df2#'
	pageAbout['icon'] = ''
</cfscript>
<cfoutput>
	<h3 class="brand-success text-center"><p>Thankyou!</p>All tips, no matter how large or small, are greatly appreciated and always go to the operations of Defacto2.</h3>
	<div class="readable-text" id="defacto2-controller">
		<div class="text-center">
			<h2 class="brand-primary"><small>Tip with</small>
				<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=PBV5H45GG5L8G" title="Donate with PayPal" tabindex="0">
				<strong>PayPal</strong></a><small> or </small>
				<a href="https://www.buymeacoffee.com/4rtEGvUIY"><strong>Buy.me.a.coffee</strong></a>
			</h1>
			<p>No account or setup is required</p>
		</div>
		<br>
		<div class="well">
			#includePartial('/defacto2/costs')#
		</div>
		<h4>#linkTo(route="contact",text="Get in contact")#</h4>
	</div>
</cfoutput>