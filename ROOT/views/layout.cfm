<cfcontent reset="true">
<!--- Place HTML here that should be used as the default layout of your application --->
<cfscript>
	setting enablecfoutputonly="true";
	param name="params.controller"	type="string" default="";
	param name="params.action"	type="string" default="";
	param name="params.key"		type="string" default="";
	// required by helpers-meta.cfm
	param name="loadChiptunes"	type="boolean" default=false; // toggled in File.cfc
	param name="chiptunePath"	type="string" default=""; 	  //  "
	param name="loadDOSee"		type="boolean" default=false; //  "
	param name="dosee.state"	type="boolean" default=false; // toggled in views/detail.cfm
	// meta-data
	param name="canonical"		type="string" default="";
	param name="description"	type="string" default="";
	param name="robotsNoIndex"	type="boolean" default=false;
	param name="title"			type="string" default="";
	// social and other layout links
	param name="urlCC"			type="string" default="https://creativecommons.org/licenses/by/4.0/";
	param name="urlFacebook"	type="string" default="https://facebook.com/#get(myapp).facebook.account#";
	param name="urlGitHub"		type="string" default=get(myapp).github.repos;
	param name="urlMastodon"	type="string" default=get(myapp).mastodon.profile;
	param name="urlTwitter"		type="string" default="https://twitter.com/#get(myapp).twitter.account#";
	param name="urlYouTube"		type="string" default="https://youtube.com/#get(myapp).youtube.account#";
	param name="urlWordPress"	type="string" default="https://#get(myapp).wordPress.account#.wordpress.com";
	// header
	param name="breadcrumbs"	type="string" default="";
	param name="pageAbout"		type="struct" default=structNew();
	param name="pageAbout.icon" type="string" default="";
	param name="pageAbout.text" type="string" default="";
	var imagepath = "imagepath"
	var siteAreas = "siteAreas"
	var activePage = function(required string item="") {
		var ctrl = params.controller;
		var act = params.action;
		/* automatic selection */
		switch(arguments.item) {
			case ctrl:
			case Left('#ctrl#.#act#', Len(arguments.item)):
				return 'active';
			case 'file.list':
				// manual selection for when automatic doesn't work
				if(ctrl == 'file' && act == 'detail') return 'active';
			case 'donate':
				if(ctrl == 'defacto2' && act == 'donate') return 'active';
			default:
				return "";
		}
	}
	var entities = function() {
		var encoded = false
		loop list="&##|&quot;|&amp;|&lt;|&gt;" index="entity" delimiters="|" {
			if(variables.title contains entity) {
				encoded = true;
				break;
			}
		}
		if(!encoded) variables.title = xssFix(variables.title);
	}
	var unwantedSoftware = function() {
		if(!isDefined("fileProd")) return false
		if(!structKeyExists(fileProd,'file_security_alert_url')) return false
		if(!len(fileProd['file_security_alert_url'])) return false
		return true
	}
	var suppress = function() {
		if(params.controller == "file") return false
		if(params.action != "detail") return false
		if(!isDefined("existsDocumentation")) return false
		if(!existsDocumentation) return false
		return true
	}
	var dns = function() {
		var link = function(string rel) {
			return '<link rel="dns-prefetch" href="//#arguments.rel#">'
		}
		switch(params.controller) {
			case 'file': case 'upload':
				switch(params.action) {
					case 'detail':
						if(isDefined('fileProd') &&	structKeyExists(fileProd, 'web_id_demozoo') && len(fileProd.web_id_demozoo)) return link("demozoo.org");
						if(isDefined('fileProd') &&	structKeyExists(fileProd, 'web_id_pouet') && len(fileProd.web_id_pouet)) return link("pouet.net");
					case 'external':
						return '#link("demozoo.org")##newLine()#	#link("pouet.net")#';
					default:
						return "";
				}
			default: return "";
		}
	}
	var checkRoutes = function() {
		if(get("urlRewriting") == "on") return "";
		return ' <span class="bg-danger text-danger">Routing error, URL rewriting=#get("urlRewriting")#! <a href="/home?reload=development">Try this reload fix.</a></span>'
	}
	var checkPorts = function() {
		var tomcatPort = 8888
		if(cgi.server_port != tomcatPort) return "";
		return ' <strong class="bg-danger text-danger">Server error, using port #tomcatPort# which fails to load any CSS, JS and image assets!</strong>'
	}
	initializeLayout()
	variables.robotsNoIndex = unwantedSoftware()
	entities()
	var embeddedCSS = fileRead(expandPath('stylesheets/layout-error.min.css'))
	var prefetchDNS = dns()
	var checkRoute = checkRoutes()
	var checkPort = checkPorts()
	var svgIcon = "/#get(imagepath)#/layout/defacto2-floppy_disk_icon.svg"
</cfscript>
<cfprocessingdirective
	executionlog=false
	pageEncoding="UTF-8"
	preserveCase=false
	suppressWhiteSpace="#suppress()#"><cfoutput><!DOCTYPE html>
<html lang="en">
<head><!--- free guide to <head> elements - http://gethead.info/ --->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="alternate" href="#urlFor(route='html3')#" type="text/html" title="Link to a Firefox 2.0 (Oct 2006) compatible site that is friendly for legacy systems">
<cfif len(prefetchDNS)>	#prefetchDNS#
</cfif>	<title>#title# | #get(siteAreas).titles.df2#</title>
	#metaTags()#<cfif isDefined("homeFileCount")>
	<meta name="defacto2:file-count" content="#homeFileCount#"></cfif>
	<meta name="monetization" content="$ilp.uphold.com/RpWPnb88yLaF">
<cfif variables.chiptunePath neq "">	<meta name="chiptune-path" content="#variables.chiptunePath#">
</cfif>	<meta name="format-detection" content="telephone=no">
	<meta name="format-detection" content="address=no">
	<!-- schema.org linked data -->
	<script type="application/ld+json">
	[#schemaLD()##schemaGroup(params)##schemaPerson(params)#]
	</script>
	<!-- preload resources -->
	#preload()#
	<!-- bookmark and tab icons -->
	<link rel="icon" type="image/svg+xml" href="#svgIcon#">
	<link rel="icon" type="image/png" href="/#get(imagepath)#/layout/favicon-16x16.png" sizes="16x16">
	<link rel="icon" type="image/png" href="/#get(imagepath)#/layout/favicon-32x32.png" sizes="32x32">
	<link rel="icon" type="image/png" href="/#get(imagepath)#/layout/pwa-192x192.png" sizes="192x192">
	<link rel="apple-touch-icon" href="/#get(imagepath)#/layout/apple-touch-icon-180x180.png" sizes="180x180">
	<link rel="manifest" href="/files/json/site.webmanifest">
	<!-- relationships -->
	<link rel="alternate" href="https://github.com/Defacto2" type="text/html" title="Defacto2 organisation on GitHub">
	<link rel="alternate" href="https://demozoo.org/groups/10000/" type="text/html" title="Defacto2 group profile on Demozoo">
	<link rel="license" href="#urlCC#" title="Creative Commons Licence">
	#includePartial(partial="/search/meta")#	<!-- cascading style sheets -->
	#cssLinks()#<!--- req for when the loading of CSS files fail --->
	<style>#embeddedCSS#</style>
	<!-- javascripts -->
	#jsHeader()#<cfif params.controller eq 'file' and params.action eq 'detail'>
	<!--
	  keyboard shortcuts, press: Ctrl+Alt+
	d  Download file
	i  Items in archive toggle
	p  Play, pause or stop chiptune player
	--></cfif>
</head>
<body><!--- hard code styling into DIV in-case client does not like the CSS in a separate file --->
	<div style="display:none;"><br><br>************************************************</div>
	<div id="browserError" style="padding:1em;background-color:white;display:none;font-size:200%;"><span style="color:red;">* This page is incompatible with your browser &nbsp;*</span><br>* Instead use the textmode edition of the site *<br>* #linkTo(route="html3")#</div>
	<div style="display:none;">************************************************<br><br></div>
	<p id="browserFormError">Unfortunately, this site has restricted functionality as this browser does not support the <a href="https://www.w3schools.com/tags/att_button_formaction.asp">HTML button formaction attribute</a>.</p>
	<p id="browserStoreError">Unfortunately, this site has restricted functionality as this browser has <a href="https://www.w3schools.com/html/html5_webstorage.asp">HTML web storage</a> turned off.</p>
	<cfif opCheck('coop')><!--- Pull-down operator menus --->
	<nav id="systemMenus"><a id="systemtop"></a>#includePartial("/operator/menus")#</nav>
	<header>
		<div id="nav-crumbs" vocab="http://schema.org/" role="navigation" typeof="BreadcrumbList" class="mobile-hide font-mono">
			#appendCrumb(1, 'Defacto2', '/')# #breadcrumbs##checkRoute##checkPort#
		</div>
	</header><cfelse><header id="fixedHeader" class="headroom header-fixed">
		<div id="nav-crumbs" vocab="http://schema.org/" role="navigation" typeof="BreadcrumbList" class="mobile-hide font-mono">
			#appendCrumb(1, 'Defacto2', '/')# #breadcrumbs#
		</div>
	</header></cfif>
	<main class="header-stick">
		<nav>
			<ul class="nav nav-pills nav-stacked nav-sticky">
				<li class="dropdown">
					<a id="hamburgerButton" data-target="##" href="" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" title="More options" aria-label="More options" tabindex="0">
					<span class="hamburger hamburger--stand">
						<span class="hamburger-box">
							<span class="hamburger-inner"></span>
						</span>
					</span><br><small>MENU</small></a>
					<ul class="dropdown-menu" id="hamburgers" aria-labelledby="hamburgerButton">
						<li><a href="#urlFor(route="contact")#"><i class="fal fa-envelope fa-fw"></i> Email and chat</a></li>
						<li><a href="#urlFor(route="help")#"><i class="fal fa-info-circle fa-fw"></i> Help and legal</a></li>
						<li class="mobile-hide"><a href="#urlFor(route="upload")#"><i class="fal fa-file-upload fa-fw"></i> Uploader</a></li>
						<li class="divider"></li>
						<li><a href="#urlFor(route="defacto2")#"><i class="fal fa-graduation-cap fa-fw"></i> About #get(siteAreas).titles.df2#</a></li>
						<li><a href="https://demozoo.org/groups/10000/"><i class="fal fa-external-link-square fa-fw"></i> Demozoo profile</a></li>
						<li class="divider"></li>
						<li><a href="#urlFor(route="linkList")#" id="layoutLink"><i class="fal fa-external-link-square fa-fw"></i> Scene websites</a></li>
						<li><a href="#urlFor(route="commercial")#"><i class="fal fa-book fa-fw"></i> Publications</a></li>
						<li class="divider"></li>
						<li><a href="#urlFor(route="code")#"><i class="fal fa-code-branch fa-fw"></i> Database &amp; GitHub</a></li>
					</ul>
				</li>
				<li class="#activePage('home')#"><a href="#urlFor(route="home")#" id="tabHome" aria-label="#get(siteAreas).titles.home#" title="#get(siteAreas).titles.home#" tabindex="0">
					<i class="fal fa-home fa-2x fa-fw"></i><br><small>HOME</small></a></li>
				<li class="#activePage('file')#"><a href="#urlFor(controller="file",action="index")#" id="tabFiles" aria-label="#get(siteAreas).titles.file#" title="#get(siteAreas).titles.file#" tabindex="0">
					<i class="fal fa-folder fa-2x fa-fw brand-warning"></i><br><small>FILES</small></a></li>
				<li class="#activePage('organisation')#"><a href="#urlFor(route="organisationFilter",key="group")#" id="tabOrganisation" aria-label="#get(siteAreas).titles.organisation#" title="#get(siteAreas).titles.organisation#" tabindex="0">
					<i class="fal fa-users fa-2x fa-fw"></i><br><small>GROUPS</small></a></li>
				<li class="#activePage('person')#"><a href="#urlFor(route="personFilter",key="artists")#" id="tabPerson" aria-label="#get(siteAreas).titles.person#" title="#get(siteAreas).titles.person#" tabindex="0">
					<i class="fal fa-user fa-2x fa-fw"></i><br><small>PEOPLE</small></a></li>
				<li class="#activePage('search')#"><a href="#urlFor(route="s")#" id="tabSearch" aria-label="Search" title="Search" tabindex="0">
					<i class="fal fa-search fa-2x fa-fw"></i><br><small>SEARCH</small></a></li>
				<li class="#activePage('donate')#"><a href="#urlFor(controller="defacto2",action="donate")#" id="tabDonate" aria-label="Donate" title="Donate" tabindex="0"><i class="fal fa-usd-circle fa-2x fa-fw mobile-hide"></i><br><small class="mobile-hide">THANKS</small></a></li>
				<cfif useMastodon()><li><a ref="me" href="#urlMastodon#" aria-label="Mastodon feed" title="Mastodon feed"><i class="fab fa-mastodon fa-lg fa-fw mobile-hide"></i><br><small>Mastodon</small></a></li></cfif>
				<cfif useTwitter()><li><a ref="me" href="#urlTwitter#" aria-label="Twitter feed" title="Twitter feed"><i class="fab fa-twitter fa-lg fa-fw mobile-hide"></i><br><small>Twitter</small></a></li></cfif>
				<cfif useFaceBook()><li><a ref="me" href="#urlFacebook#" aria-label="Facebook page" title="Facebook page"><i class="fab fa-facebook fa-lg fa-fw mobile-hide"></i><br><small>Facebook</small></a></li></cfif>
				<cfif useYouTube()><li><a ref="me" href="#urlYouTube#" aria-label="YouTube channel" title="YouTube channel"><i class="fab fa-youtube fa-lg fa-fw mobile-hide"></i><br><small>YouTube</small></a></li></cfif>
				<li class="mobile-hide"><a href="#urlFor(route="html3")#" aria-label="Text mode" title="Text mode" tabindex="0"><small>TEXT<br>MODE</small></a></li>
			</ul>
		</nav>
		<article class="container-fluid">
			<header>
				<div class="page-header">
				<cfif params.controller neq "file">
					<h1 class="text-center">#pageAbout.text#</h1>
				<cfelseif len(pageAbout.icon) && len(pageAbout.text)>
					<h1><i class="#pageAbout.icon#"></i> #pageAbout.text#</h1>
				<cfelse>
					<h1>#pageAbout.text#</h1>
				</cfif>
				</div>
			</header>
			#includeContent("oneventerrors")#
			#contentForLayout()#
		</article>
	</main>
	<footer>
		<!-- copyright notice -->
		<p class="copyright">
			<span id="copyright-desktop">
				<i class="fal fa-circle fa-fw separator"></i> <a href="#urlFor(controller='Help', action='creativeCommons')#" title="Text and images - Creative Commons BY 4.0"><i class="fab fa-creative-commons"></i><i class="fab fa-creative-commons-by"></i></a>
				<span title='All file downloads are copyright by their authors'><i class="fal fa-copyright fa-fw"></i></span>
				#get(siteAreas).titles.df2# <i class="fal fa-circle fa-fw separator"></i> #(dateFormat(Now(), "YYYY")-1996)# years online
				<i class="fal fa-circle fa-fw separator"></i> <a href="https://www.digitalocean.com/?refcode=a9270bdb9e74" title='Hosted on DigitalOcean'><i class="fab fa-digital-ocean fa-fw"></i></a>
				<a href="https://github.com/bengarrett" title="Coded by Ben Garrett / Ipggi"><i class="fal fa-brackets-curly fa-fw"></i></a>
				<span title="A huge thanks to everyone who has provided files!"><i class="fal fa-heart fa-fw"></i></span>
				<i class="fal fa-circle fa-fw separator"></i> <span title="Time taken to render this page, #((GetTickCount()-Request.tickCount)/1000)# seconds"><i class="fal fa-stopwatch fa-fw"></i></span>
			</span>
			<span id="copyright-mobile"><!--- mobile copyright notice --->
				<a href="#urlFor(controller='Help', action='creativeCommons')#" title="Creative Commons BY 4.0"><i class="fab fa-creative-commons"></i></a>
			</span>
			<cfif get("environment") neq "production"><span id="copyright-env" title="#UCase(get("environment"))# mode"><i class="fal fa-vial"></i></span></cfif>
			<span id="mobile-social" class="mobile-show">
				<cfif useMastodon()>&nbsp; <a aria-label="Mastodon feed" href="#urlMastodon#"><i class="fab fa-mastodon fa-2x"></i></a> &nbsp; </cfif>
				<cfif useTwitter()> &nbsp; <a aria-label="Twitter feed" href="#urlTwitter#"><i class="fab fa-twitter fa-2x"></i></a> &nbsp; </cfif>
				<cfif useFaceBook()> &nbsp; <a aria-label="Facebook page" href="#urlFacebook#"><i class="fab fa-facebook fa-2x"></i></a> &nbsp; </cfif>
				<cfif useYouTube()> &nbsp; <a aria-label="YouTube channel" href="#urlYouTube#"><i class="fab fa-youtube fa-2x"></i></a> &nbsp; </cfif>
			</span><cfif params.controller is "home"><!-- browsers currently viewing the site -->
			<br class="mobile-show">
			<span class="mobile-hide">&nbsp;<i class="fal fa-circle fa-fw separator"></i>&nbsp;</span>
			<span title="Users">
				<i class="fal fa-smile fa-fw"></i> <span id="homecounthumans" class="font-mono">?</span>
			</span>
			<span title="Bots and crawlers">
				<i class="fal fa-analytics fa-fw"></i> <span id="homecountbots" class="font-mono">?</span>
			</span></cfif>
			<i class="fal fa-circle fa-fw separator"></i>
		</p>
	</footer>
	<!-- these javascripts are placed at end of the page for a better user load page experience -->
	#jsFooter()#<cfif CGI.server_name neq "localhost">
	<!-- Cloudflare Web Analytics -->
	<script defer src='https://static.cloudflareinsights.com/beacon.min.js' data-cf-beacon='{"token": "2a75bdb3c9504515bc2a85ba2e0f1459"}'></script>
	<!-- End Cloudflare Web Analytics --></cfif>
</body>
</html>
</cfoutput></cfprocessingdirective>