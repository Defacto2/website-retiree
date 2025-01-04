<!---
  	Privacy policy help view.
	path: views/help/privacy.cfm

@CFLintIgnore
--->
<cfscript>
	param name="param.extlink" default="" type="string";
	extlink = [
		'http://twitter.com/privacy',
		'https://docs.lucee.org/reference/tags/application.html',
		'http://www.ghostery.com/',
		'',
		'http://www.ghostery.com/apps/twitter_button',
		'',
		'https://www.eff.org/privacybadger']
	pageAbout.text = 'Privacy policy'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
		<span class="hidden">
			<!--- used by javascript pagination, should be kept hidden --->
			<button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
			<button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='creativeCommons')#"></button>
			<button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='browserSupport')#"></button>
			<button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
		</span>
	</form>
	<div class="readable-text" id="help-controller">
		<p class="lead text-center">We do not track visitors to this site, <small>other than the exceptions listed.</small></p>
		<div class="panel panel-warning">
			<div class="panel-heading lead">Cookies</div>
			<div class="panel-body">
				<p>The web server generates one or two cookies in your web browser, <code>CFID</code> <code>CFTOKEN</code>.</p>
				<p>CFID contains a sequential client identifier.</p>
				<p>CFTOKEN holds a random-number client security token.</p>
				These are temporary and used internally by the web server for maintaining active browser sessions.
			</div>
			<div class="list-group">
				<a href="#extlink[2]#" class="list-group-item">CFID</a>
				<a href="#extlink[2]#" class="list-group-item">CFTOKEN</a>
			</div>
		</div>
		#includePartial('externallinks')#
	</div>
</cfoutput>