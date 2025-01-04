<!---
    Contact view
	path: views/contact/index.cfm

@CFLintIgnore
--->
<cfscript>
	var links = {
		"discord":"#get('myapp').discord.account#",
		"facebook":"https://facebook.com/#get('myapp').facebook.account#",
		"github":"#get('myapp').github.repos#",
		"mastodon":"#get('myapp').mastodon.account#",
		"twitter":"https://twitter.com/#get('myapp').twitter.account#",
	}
	pageAbout['text'] = ' Contact</span>'
	pageAbout['icon'] = 'fal fa-envelope'
</cfscript>
<cfoutput>
	<div class="readable-text">
		<div class="panel panel-info">
			<div class="panel-heading lead">Contact and socials</div>
			<div class="panel-body">
				<h2 class="text-center gray-light"><strong><span>contact</span><span>@</span><span>defacto2</span><span>.</span><span>net</span></strong></h2>
				<p class="text-center gray-light">Email is checked regularly.</p>
			</div>
<div class="list-group">
	<cfif useDiscord()>
	<a rel="me" href="https://discord.io" class="list-group-item" title="Discord">
		<i class="fab fa-discord fa-3x" title="Discord"></i>
		<p class="list-group-item-text">Message <strong>#links.discord#</strong></p>
	</a>
	</cfif>
	<cfif useMastodon()>
	<a rel="me" href="#get('myapp').mastodon.profile#" class="list-group-item" title="Mastodon">
		<i class="fab fa-mastodon fa-3x" title="Mastodon"></i>
		<p class="list-group-item-text">Message <strong>#links.mastodon#</strong></p>
	</a>
	</cfif>
	<cfif UseGitHub()>
	<a rel="me" href="#links.github#" class="list-group-item" title="GitHub">
		<i class="fab fa-github fa-3x" title="GitHub"></i>
		<p class="list-group-item-text">Open sourced tools, issue tickets and suggestions for this website.</p>
	</a>
	</cfif>
	<cfif UseTwitter()>
	<a rel="me" href="#links.twitter#" class="list-group-item" title="Twitter">
		<i class="fab fa-twitter fa-3x" title="Twitter"></i>
		<p class="list-group-item-text">Rarely updated with site feature updates.</p>
	</a>
	</cfif>
	<cfif UseFacebook()>
	<a rel="me" href="#links.facebook#" class="list-group-item" title="Facebook">
		<i class="fab fa-facebook fa-3x" title="Facebook"></i>
		<p class="list-group-item-text">Rarely updated with site feature updates.</p>
	</a>
	</cfif>
	<a href="#URLFor(route="upload")#" class="list-group-item">Suggest and upload files</a>
</div>
</cfoutput>