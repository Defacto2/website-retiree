<!---
	What browsers does this site support help view.
	path: views/help/browsersupport.cfm

@CFLintIgnore
--->
<cfscript>
	param name="param.extlink" default="" type="string";
	variables.extlink = [
		'http://www.w3.org/TR/xhtml1/',
		'http://www.w3.org/Style/CSS/',
		'http://www.css3.info/preview/rounded-border/',
		URLFor(route="html3")]
	var userBrowser = whoisSystemType(cgi.http_user_agent).browser
	var userPlatform = whoisSystemType(cgi.http_user_agent).platform
	var icon = ""
	switch(userBrowser) {
		case 'chrome': icon = 'chrome'; break;
		case 'edge': icon = 'edge'; break;
		case 'firefox': icon = 'firefox'; break;
		case 'safari': icon = 'safari'; break;
		default: icon = 'browser'
	}
	pageAbout.text = 'Browser support?'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
	  <span class="hidden">
	    <!--- used by javascript pagination, should be kept hidden --->
	    <button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
	    <button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='privacy')#"></button>
	    <button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='keyboard')#"></button>
	    <button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
	  </span>
	</form>
	<div class="readable-text" id="help-controller">
		<p class="lead">#get('siteAreas').titles.df2# is built on HTML5 &amp; CSS3.</p>
		<p>It uses responsive design so it should work correctly on any current desktop, tablet or mobile browser.</p>
		<p>We have a low-bandwidth, #linkTo(text="HTML3 edition",href=extlink[4])# of #get('siteAreas').titles.df2# that makes the site's files accessible on legacy browsers and operating systems.</p>
		<br>
		<div class="panel panel-info">
			<div class="panel-heading lead">This browser reports the following user agent</div>
			<div class="panel-body">
				<cfif Len(userBrowser) or Len(userPlatform)>
					<span class="fa-3x fa-as-first-letter"><i class='fab fa-#icon#'></i></span>
					<p>It looks like you're running
					<cfif Len(userBrowser)>#userBrowser#<cfif Len(userPlatform)> on #userPlatform#</cfif>.
					<cfelseif Len(userPlatform)>#userPlatform#.</cfif></p>
				</cfif>
				<p><code>#cgi.http_user_agent#.</code></p>
			</div>
		</div>
		<br>
		#includePartial('externallinks')#
	</div>
</cfoutput>