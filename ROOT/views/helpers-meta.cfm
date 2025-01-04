<!---
	HTML <HEAD> & <META> tag functions
	path: views/helpers-dropmetamenus.cfm

@CFLintIgnore VAR_TOO_SHORT,ARG_VAR_MIXED,LOCAL_LITERAL_VALUE_USED_TOO_OFTEN,GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN,EXCESSIVE_FUNCTIONS
--->
<cfscript>
	variables.pad = repeatString(chr(9),1)
	variables.urlRewrite = "/rewrite.cfm"
	variables.format = function(string text="") {
		var lineFeed = 10
		return trim(replace(text, '☻', Chr(lineFeed), "all"))
	}
	private string function hashedJS(string link="") {
		var cs = FileInfo(link).checksum
		if(cs == "") return link
		return "#link#?#cs#"
	}
	variables.scripts = function() {
		var min = ".min"
		var src = ""
		var doseeSrc = ""
		if(cgi.script_name != urlRewrite) {
			min = ""
			src ="/src"
			doseeSrc = "/src/dosee"
		}
		var links = {
			"apiExternal":hashedJS("/javascripts#src#/apis-external#min#.js"),
			"chartjs":"/javascripts/chart.min.js",
			// chiptune
			"chiptune1":"/javascripts/libopenmpt.js",
			"chiptune2":"/javascripts#src#/chiptune2#min#.js",
			"chiptune3":hashedJS("/javascripts/chiptune-ui#min#.js"),
			// clipboard
			"clipboard":"/javascripts/clipboard.min.js",
			// coop
			"coop":hashedJS("/javascripts#src#/operator-dialog#min#.js"),
			// dosee
			"doseeFuncs":hashedJS("/javascripts#doseeSrc#/dosee-functions#min#.js"),
			"doseeLoader":hashedJS("/javascripts#doseeSrc#/dosee-loader#min#.js"),
			"doseeInit":hashedJS("/javascripts#doseeSrc#/dosee-init#min#.js"),
			"doseeD":"/javascripts#doseeSrc#/dosee-sw#min#.js",
			"doseeLibrary1":"/javascripts/browserfs.min.js",
			"doseeLibrary2":"/javascripts/browserfs-zipfs-extras.js",
			"doseeLibrary3":"/javascripts/FileSaver.min.js",
			"doseeLibrary4":"/javascripts/canvas-toBlob.min.js",
			"emularity1":"/files/emularity.zip/dosee-core.js",
			"emularity2":"/files/emularity.zip/dosee-core.mem",
			"emularity3":hashedJS("/files/emularity.zip/g_drive.zip"),
			"emularity4":hashedJS("/files/emularity.zip/s_drive.zip"),
			"emularity5":hashedJS("/files/emularity.zip/u_drive.zip"),
			// font awesome
			"fasvg1":"/javascripts/fontawesome-all.min.js",
			// other
			"functions":hashedJS("/javascripts#src#/functions#min#.js"),
			"headroom":"/javascripts/headroom.min.js",
			"infscroll":"/javascripts/infinite-scroll.pkgd.min.js",
			"liteYT":"/javascripts/lite-yt-embed.min.js",
			"retrotxtcf":hashedJS("/javascripts#src#/retrotxtcf#min#.js"),
			"retrotxtcolor":hashedJS("/javascripts#src#/retrotxt-color#min#.js"),
			// upload
			"upload1":hashedJS("/javascripts#src#/upload#min#.js"),
			"upload2":hashedJS("/javascripts#src#/upload-inputs#min#.js"),
			"upload3":hashedJS("/javascripts#src#/upload-input-references#min#.js"),
			"upload4":hashedJS("/javascripts#src#/upload-input-production-id#min#.js"),
			"upload5":"/javascripts/localforage.min.js",
		}
		return links
	}
	variables.scriptName = cgi.script_name
	variables.httpHost = cgi.http_host
	variables.css = {
		"bootstrap":"/stylesheets/bootstrap.min.css",
		"dosee":hashedJS("/stylesheets/dosee.min.css"),
		"hamburger":"/stylesheets/hamburgers.min.css",
		"layout":hashedJS("/stylesheets/layout.min.css"),
		"liteYT":"/javascripts/lite-yt-embed.min.css",
	}
	variables.load = {
		"chiptunes":false,
		"dosee":false,
		"functions":false,
		"twitter":false,
	}
	variables.js = scripts()
	variables.domain = application.domain
	var uri = {}

	/**
	 * @hint These are all set by param in layout.cfm */
	private void function initializeLayout() {
		uri.1 = params.controller
		uri.2 = params.action
		uri.3 = params.key
		variables.load.chiptunes = loadChiptunes
		variables.load.dosee = loadDOSee
		// the user has disabled DOSee
		if(!dosee.state) variables.load.dosee = false;
		// determine script triggers
		if(uri.1 == 'system') variables.load.functions = true;
		if(uri.1 == 'home') variables.load.functions = true;
		if(opCheck('sysop')) variables.load.functions = true;
	}

	/**
	 * @hint Permit the file to be downloaded */
	private boolean function downloadAllowed(required query prod) {
		switch(arguments.prod["fileSize"]) {
			case "0": case "":
				return false;
			default:
				switch(arguments.prod["file_security_alert_url"]) {
					case "":
						return true;
					default:
						return false;
				}
		}
	}

	/**
	 * @hint Applies background images to file thumbnails, that display when the thumbnail is 404 missing.
	 * @platform The page controller name.
	 */
	private string function missingThumb(string platform="") {
		switch(arguments.platform) {
			case "ansi": case "image": case "pcboard":
				return 'platform-img';
			case "audio":
				return 'platform-audio';
			case "text": case "textamiga":
				return 'platform-text';
			case "video":
				return 'platform-video';
			default:
				return 'platform-file';
		}
	}

	/**
	 * @hint Schema.org linked data */
	private string function schemaLD() localMode="modern" {
		var search = ',"potentialAction":{"@type":"SearchAction","target":"https://#domain#/search/result?query={search_term_string}","query-input":"required name=search_term_string"}'
		if(uri.1 != 'home' && uri.1 != 'search') search = ''
		var schema = '{"@context":"http://schema.org","@type":"Organization","name":"Defacto2","url":"https://#domain#/","logo":"https://#domain#/#get('IMAGEPATH')#/layout/defacto2-floppy_disk_icon-180x180.png",
	"sameAs": ["#variables.urlFacebook#","#variables.urlTwitter#","#variables.urlYouTube#","#variables.urlGitHub#","#variables.urlWordPress#"]},
	{"@context":"http://schema.org","@type":"WebSite","license":"#variables.urlCC#","url": "https://#domain#/"#search#}'
		return schema
	}
	/**
	 * @hint Schema.org group data */
	private string function schemaGroup(struct params={}) localMode="modern" {
		if(uri.1 != "organisation") return ''
		if(!StructKeyExists(params, "orgname")) return ''
		var schema = ',{
		  "@context": "http://schema.org",
		  "@type": "BreadcrumbList",
		  "itemListElement": [{
			    "@type": "ListItem",
			    "position": 1,
			    "item": {
			      "@id": "https://#domain#/organisation/list",
			      "name": "Groups & sites"
			    }
			  },{
			    "@type": "ListItem",
			    "position": 2,
			    "item": {
			      "@id": "https://#domain#/organisation/#params.orgname#",
			      "name": "#title#"
			    }}]}'
		return schema
	}
	/**
	 * @hint Schema.org people data */
	private string function schemaPerson(struct params={}) localMode="modern" {
		if(uri.1 != "person") return ''
		if(!StructKeyExists(params, "personname")) return ''
		var schema = ',{
		  "@context": "http://schema.org",
		  "@type": "BreadcrumbList",
		  "itemListElement": [{
			    "@type": "ListItem",
			    "position": 1,
			    "item": {
			      "@id": "https://#domain#/person/list",
			      "name": "People"
			    }
			  },{
			    "@type": "ListItem",
			    "position": 2,
			    "item": {
			      "@id": "https://#domain#/person/#params.personname#",
			      "name": "#title#"
			    }}]}'
		return schema
	}

	/**
	 * @hint Creates HTML LINKS to locally stored cascading style sheets */
	private string function cssLinks() {
		var links = ''
		// load the following regardless of controller or view
		links &= pad & '<!-- bootstrap --><link rel="stylesheet" href="#css.bootstrap#">☻'
		links &= pad & '<!-- hamburger --><link rel="stylesheet" href="#css.hamburger#">☻'
		links &= pad & '<!-- base layout --><link rel="stylesheet" href="#css.layout#">☻'
		if(uri.1 eq 'file' && uri.2 == 'detail' && (opCheck('coop'))) {
			links &= pad & '<!-- choices.js base --><link rel="stylesheet" href="/stylesheets/base.min.css">☻'
			links &= pad & '<!-- choices.js --><link rel="stylesheet" href="/stylesheets/choices.min.css">☻'
		}
		if(uri.1 eq 'file' && uri.2 == 'detail' && load.dosee) {
			links &= pad & '<!-- dosee --><link rel="stylesheet" href="#css.dosee#">☻'
		}
		if(uri.1 eq 'file' && uri.2 == 'detail' && isDefined("toggle") && toggle.youtube) {
			links &= pad & '<link rel="stylesheet" href="#css.liteYT#"><!-- lite-youtube-embed --></script>☻'
		}
		return format(links)
	}

	/**
	 * @hint Automatically loads JavaScripts within the HEAD tags of the HTML document depending on the controller and action */
	private string function jsHeader() {
		var layout = function() {
			scripts &= pad & '<script defer src="#js.functions#" id="layoutHeadJS"><!-- custom functions --></script>☻'
			scripts &= pad & '<script defer src="#js.fasvg1#"><!-- fontawesome --></script>☻'
		}
		var fileDetail = function() {
			if(uri.1 != "file") return;
			if(uri.2 != "detail") return;
			if(opCheck('coop')) {
				scripts &= pad & '<script defer src="/javascripts/choices.min.js"><!-- text input plugin --></script>☻'
				scripts &= pad & '<script defer src="#js.clipboard#"><!-- clipboard --></script>☻'
				scripts &= pad & '<script defer src="#js.coop#"><!-- operator --></script>☻'
				scripts &= pad & '<script defer src="#js.apiExternal#"><!-- api interactions (coop deferred) --></script>☻'
			} else {
				scripts &= pad & '<script async src="#js.apiExternal#"><!-- api interactions --></script>☻'
			}
			scripts &= pad & '<script defer src="#js.retrotxtcf#"><!-- retrotxtcf --></script>☻'
			scripts &= pad & '<script defer src="#js.retrotxtcolor#"><!-- retrotxt color text --></script>☻'
			if(load.dosee) {
				scripts &= pad & '<script async src="#js.doseeLibrary3#"><!-- dosee filesaver --></script>☻'
				scripts &= pad & '<script async src="#js.doseeLibrary4#"><!-- dosee canvas.toBlob() --></script>☻'
			}
			if(isDefined("toggle") && toggle.youtube) {
				scripts &= pad & '<script async src="#js.liteYT#"><!-- lite-youtube-embed --></script>☻'
			}
		}
		var charts = function() {
			if(!opCheck('coop')) return;
			if(uri.1 != 'system') return;
			if(uri.2 != 'files') return;
			if(uri.3 != 'index') return;
			// stats-upload MUST go before the canvas script!
			scripts &= pad & '<script src="#js.chartjs#"><!-- chart.js --></script>☻'
			scripts &= pad & '<script src="/javascripts/moment.min.js"><!-- moment.js --></script>☻'
			if(scriptName == urlRewrite) {
				scripts &= pad & '<script defer src="/javascripts/operator-charts.min.js"><!-- statistics --></script>☻'
			} else {
				scripts &= pad & '<script defer src="/javascripts/src/operator-charts.js"><!-- statistics --></script>☻'
			}
		}
		var scripts = ''
		layout()
		fileDetail()
		charts()
		return format(scripts)
	}

	/**
	 * @hint Automatically loads JavaScripts at the footer of the HTML document depending on the controller and action */
	private string function jsFooter() {
		var layout = function() {
			scripts &= pad & '<script src="/javascripts/jquery.slim.min.js"><!-- jquery slim for bootstrap v3 --></script>☻'
			scripts &= pad & '<script src="/javascripts/bootstrap.min.js"><!-- bootstrap v3 --></script>☻'
			scripts &= pad & '<script src="#js.headroom#"><!-- hide header on scroll --></script>☻'
		}
		var fileDetail = function() {
			if(uri.1 != "file") return;
			if(uri.2 != "detail") return;
			if(load.dosee) {
				scripts &= pad & '<script src="#js.doseeLoader#"><!-- dosee loader --></script>☻'
				scripts &= pad & '<script src="#js.doseeLibrary1#"><!-- dosee file system --></script>☻'
				scripts &= pad & '<script src="#js.doseeLibrary2#"><!-- dosee zip file system --></script>☻'
				scripts &= pad & '<script src="#js.doseeFuncs#"><!-- dosee functions --></script>☻'
				scripts &= pad & '<script src="#js.doseeInit#"><!-- dosee initialisation --></script>☻'
			}
			if(load.chiptunes) {
				scripts &= pad & '<script src="#js.chiptune3#"><!-- chiptune UI --></script>☻'
				scripts &= pad & '<script src="#js.chiptune2#"><!-- chiptune.js --></script>☻'
				scripts &= pad & '<script src="#js.chiptune1#"><!-- libopenmpt --></script>☻'
			}
		}
		var upload = function() {
			if(uri.1 != 'upload') return;
			if(uri.2 == 'submitFile') return;
			scripts &= pad & '<script defer src="#js.upload5#"><!-- localForage --></script>☻'
			scripts &= pad & '<script defer src="#js.upload1#"><!-- fetch based upload --></script>☻'
			scripts &= pad & '<script defer src="#js.upload2#"><!-- upload form --></script>☻'
			if(uri.2 == 'external') scripts &= '<script defer src="#js.upload4#"><!-- upload external requests --></script>☻'
			else scripts &= pad & '<script defer src="#js.upload3#"><!-- upload references --></script>☻'
		}
		var retrotxtAd = function() {
			if(uri.1 != 'home' && uri.1 != 'file') return;
			if(uri.1 == 'file' && uri.2 != 'detail') return;
			if(scriptName == urlRewrite) {
				scripts &= pad & '<script src="/javascripts/retrotxt-advert.min.js"><!-- retrotxt advert --></script>☻'
				return
			}
			scripts &= pad & '<script src="/javascripts/src/retrotxt-advert.js"><!-- retrotxt advert --></script>☻'
		}
		var coop = function() {
			if(!opCheck('coop')) return;
			scripts &= pad & '<script defer src="' & hashedJS('/javascripts/operator.min.js') & '"><!-- operator funcs --></script>☻'
		}
		var listFiles = function() {
			if(uri.2 != 'fileList' && uri.2 != "list") return;
			if(uri.2 == "list" && uri.1 != "file") return;
			scripts &= pad & '<script src="#js.infscroll#"></script>☻'
			if(scriptName == urlRewrite) {
				scripts &= pad & '<script src="' & hashedJS('/javascripts/infinite-scroll.min.js') & '"><!-- infinite scroll --></script>☻'
				return
			}
			scripts &= pad & '<script src="' & hashedJS('/javascripts/src/infinite-scroll.js') & '"><!-- infinite scroll --></script>☻'
		}
		var footer = function() {
			if(scriptName == urlRewrite) {
				scripts &= pad & '<script src="' & hashedJS('/javascripts/footer.min.js') & '"><!-- end of page scripts --></script>☻'
				return
			}
			scripts &= pad & '<script src="' & hashedJS('/javascripts/src/footer.js') & '"><!-- end of page scripts --></script>☻'
		}
		var scripts = ""
		layout()
		fileDetail()
		upload()
		retrotxtAd()
		coop()
		listFiles()
		footer()
		return format(scripts)
	}

	/**
	 * @hint Inserts <meta> tags into the HEAD to exchange data between CFML and JavaScript using the metaContent() function */
	private string function metaTags() {
		var path = function() {
			if(canonical == '/') return '/home'
			if(canonical != '') return canonical
			if(structKeyExists(params, 'route')) {
				switch(params.route) {
					// TODO handle all other ROUTES
					case 'g': return UrlFor(route=params.route,orgname=params.orgname); break;
					case 'p': return UrlFor(route=params.route,personname=params.personname); break;
					default: return canonical
				}
			}
			if(structKeyExists(params, 'action')) return UrlFor(action=params.action)
			if(structKeyExists(params, 'controller')) return UrlFor(controller=params.controller)
			return canonical
		}
		var fileDetail = function() {
			if(!IsDefined('fileProd')) return;
			if(uri.1 != 'file') return;
			if(uri.2 != 'detail') return;
			scripts = metaProd(scripts)
		}
		var metaCoop = function(string scripts = "") {
			var chart = function() {
				var scripts ='<!-- charts -->☻'
				// `scripts` var set in helpers-meta.cfm
				var file="file"
				// File submissions - per month
				var cnt=12
				for (var i=-11; i<=0; i++) {
					var past = DateAdd("m",i,Now())
					var m = Month(past)
					var y = Year(past)
					scripts &= '<meta name="chart:fspm:#cnt#" content="#model(file).countByMonth(m,y)#">'
					cnt--
				}
				// File submissions - per year
				cnt = 0
				for (i=0;i<=10;i++) {
					cnt = dateFormat(Now(),'yyyy') - i
					scripts &= '<meta name="chart:fspy:#cnt#" content="#model(file).countByYear(cnt)#">'
				}
				// groups with most releases
				cnt = 8
				var data = model(file).topGroups(cnt)
				for (var i=1; i<=cnt; i++) {
					scripts &= '<meta name="chart:group:#i#" content="#data['group_brand_for'][i]#;#data['count'][i]#">'
				}
				// top platforms
				cnt = 5
				var sum = 0
				data = model(file).topPlatforms(cnt)
				var records = model(file).count(includeSoftDeletes=true)
				for (var i=1; i<=cnt; i++) {
					sum += data['count'][i]
					scripts &= '<meta name="chart:platform:#i#" content="#humanizePlatform(data['platform'][i])#;#data['count'][i]#">'
				}
				scripts &= '<meta name="chart:platform:#i#" content="Everything else;#(records-sum)#">'
				// top section
				cnt = 6
				sum = 0
				data = model(file).topSections(cnt)
				for (var i=1; i<=cnt; i++) {
					sum += data['count'][i]
					scripts &= '<meta name="chart:section:#i#" content="#humanizeSection(data['section'][i])#;#data['count'][i]#">'
				}
				scripts &= '<meta name="chart:section:#i#" content="Everything else;#(records-sum)#">'
				return scripts
			}
			var src = arguments.scripts
			src &= '	<!-- page navigation resets -->☻'
			src &= '	<meta name="nav:fo" content="#get(myapp).reset.FileList.output#">☻'
			src &= '	<meta name="nav:fs" content="#get(myapp).reset.FileList.sort#">☻'
			if(!opCheck('coop')) return src
			if(uri.1 != 'system') return src
			if(uri.2 != 'files') return src
			if(uri.3 != 'index') return src
			// Charts
			src &= chart()
			return src
		}
		variables.canonical = path()
		var scripts = ''
		var link = 'https://#domain##canonical#'
		if(domain == 'localhost') link = 'http://#httpHost##canonical#'
		if(Right(link, 6) == '/index') link = Left(link, Len(link) - 6)
		else if(Right(link, 1) == '/') link = Left(link, Len(link) - 1)
		if(robotsNoIndex) scripts &= pad & '<meta name="robots" content="noindex, nofollow">☻'
		if(len(link)) scripts &= pad & '<link rel="canonical" href="#link#">☻'
		if(len(description)) scripts &= pad & '<meta name="description" content="#xssFix(description)#">☻'
		scripts &= pad & '<meta name="theme-color" content="rgb(153, 153, 153)">☻'
		fileDetail()
		if(uri.1 == 'file' && uri.2 == 'detail') scripts = metaFile(scripts)
		if(uri.1 == 'upload' && uri.2 != 'submitFile') scripts = metaUploads(scripts)
		if (opCheck('coop')) scripts = metaCoop(scripts)
		return format(scripts)
	}

	/**
	 * @hint metaTags sub function for a production in file controller and detail action */
	private string function metaProd(string scripts = "") {
		if(!len(fileProd)) return "";

		var title = function() {
			if(fileProd.section == "magazine" && len(fileProd.record_title)) return "#fileProd.group_brand_for#, #fileProd.record_title#"
			if(len(fileProd.record_title)) return fileProd.record_title
			return fileProd.filename
		}
		var description = function() {
			var _for = fileProd.group_brand_for
			var _by = fileProd.group_brand_by
			if(Len(_for) && Len(_by)) {
				return '#XMLFormat(_for)##initialism.group_brand_for# + #XMLFormat(_by)##initialism.group_brand_by#'
			}
			if(Len(_for)) return '#XMLFormat(_for)##initialism.group_brand_for#'
			if(Len(_by)) return '#XMLFormat(_by)##initialism.group_brand_by#'
			return ""
		}
		// twitter:description (capped to 200 characters)
		var twitter = function() {
			desc = description()
			var maxChrs = 200
			if(len(desc) > maxChrs) return truncate(desc,maxChrs);
			// only append a date if it fits
			if(Len(desc) > 189) return desc;
			if(!Len(fileProd.date_issued_year) &&
				!Len(fileProd.date_issued_month) &&
				!Len(fileProd.date_issued_day)) return desc;
			desc = '#desc#, '
			if(Len(fileProd.date_issued_year)) desc &= '#fileProd.date_issued_year# '
			if(Len(fileProd.date_issued_month) && isNumeric(fileProd.date_issued_month)) desc &= '#Left(MonthAsString(fileProd.date_issued_month),3)#. '
			if(Len(fileProd.date_issued_day)) desc &= '#NumberFormat(fileProd.date_issued_day,"00")#'
			return trim(desc);
		}
		// an image for twitter must be less than 1MB and bigger then 280x150px
		var twitterImg = function() {
			if(!FileExists("#get(myapp).fulldirThumb400#/#fileProd.uuid#.png")) return ""
			return 'https://#domain#/#get('imagepath')#/#get(myapp).dirThumb400#/#fileProd.uuid#.png'
		}
		// open graph description (at least 2 sentences long)
		var graph = function() {
			desc = description()
			if(Len(fileProd.date_issued_year) or Len(fileProd.date_issued_month) or Len(fileProd.date_issued_day)) {
				desc &= ' in '
				if(Len(fileProd.date_issued_day)) desc &= '#fileProd.date_issued_day# '
				if(Len(fileProd.date_issued_month) && isNumeric(fileProd.date_issued_month)) desc &= '#MonthAsString(fileProd.date_issued_month)# '
				if(Len(fileProd.date_issued_year)) desc &= '#fileProd.date_issued_year# '
			}
			desc &= ' released this '
			if(len(fileProd.platform) && len(fileProd.section)) desc &= getSectionName(fileProd.section, false) & ' ' & getPlatformName(fileProd.platform) & ' file'
			else if(len(fileProd.platform)) desc &= getPlatformName(fileProd.platform, false)
			else if(len(fileProd.section)) desc &= getSectionName(fileProd.section, false)
			desc &= '. Go view or download ' & title() & ' at Defacto2.'
			return replace(desc,"  "," ","all")
		}
		var graphImg = function() {
			var dir = ""
			if(FileExists("#get(myapp).fulldirPreview#/#fileProd.uuid#.png")) dir = get(myapp).dirPreview
			if(FileExists("#get(myapp).dirThumb400#/#fileProd.uuid#.png")) dir = get(myapp).dirThumb400
			if(dir == "") return ""
			return 'https://#domain#/#get('IMAGEPATH')#/#dir#/#fileProd.uuid#.png'
		}
		var openGraph = { "desc":graph(),"url":''}
		var socialData = {
			"desc":description(),
			"img":graphImg(),
			"title":title(),
		}
		var twitterCard = {
			"desc":twitter(),
			"card":"summary_large_image",
			"img":twitterImg(),
		}
		var initialism = {
			"group_brand_by":groupInitialism(fileProd.group_brand_for),
			"group_brand_for":groupInitialism(fileProd.group_brand_by),
		}
		var scr = arguments.scripts
		scr &= pad & '<!-- twitter cards -->☻'
		// Must be set to a value of “summary_large_image” (REQUIRED)
		scr &= pad & '<meta name="twitter:card" content="#twitterCard.card#">☻'
		// @username for the website used in the card footer.
		scr &= pad & '<meta name="twitter:site" content="@#get(myapp).twitter.account#">☻'
		// A concise title for the related content. (REQUIRED)
		scr &= pad & '<meta name="twitter:title" content="#truncate(socialData["title"],70)#">☻'
		// A description that concisely summarizes the content as appropriate for presentation
		// within a Tweet. You should not re-use the title as the description or use this field
		// to describe the general services provided by the website.
		scr &= pad & '<meta name="twitter:description" content="#twitterCard.desc#" />☻'
		// A URL to a unique image representing the content of the page.
		if(twitterCard["img"] != ""){
			scr &= pad & '<meta name="twitter:image" content="#twitterCard["img"]#">☻'
			scr &= pad & '<meta name="twitter:image:alt" content="Screenshot of the production.">☻'
		}
		scr &= pad & '<!-- open graph -->☻'
		if(Len(canonical)) scr &= pad & '<meta name="og:url" content="https://#domain##canonical#">☻'
		scr &= pad & '<meta name="og:title" content="#socialData["title"]#">☻'
		scr &= pad & '<meta name="og:description" content="#openGraph["desc"]#">☻'
		if(len(socialData["img"])) {
			scr &= pad & '<meta name="og:image" content="#socialData["img"]#">☻'
			scr &= pad & '<meta name="og:image:type" content="image/png">☻'
		}
		return scr
	}

	/**
	 * @hint metaFile sub function for file controller and detail action */
	private string function metaFile(string scripts = "") {
		if(!isDefined('fileProd')) return ""
		if(!len(fileProd)) return "";

		var scr = arguments.scripts
		scr &= pad & '<meta name="file:url" content="#urlFor(route='d',key=obfuscateParam(fileProd.id))#">☻'
		if (opCheck('coop') && structKeyExists(fileProd,"file_last_modified") && fileProd.file_last_modified != '') {
			scr &= pad & '<!-- file modified -->☻'
			scr &= pad & '<meta name="filemod:y" content="#DateFormat(fileProd.file_last_modified,"yyyy")#">☻'
			scr &= pad & '<meta name="filemod:m" content="#DateFormat(fileProd.file_last_modified,"m")#">☻'
			scr &= pad & '<meta name="filemod:d" content="#DateFormat(fileProd.file_last_modified,"d")#">☻'
		}
		if (opCheck('coop')) {
			scr &= pad & '<!-- tags -->☻'
			scr &= pad & '<meta name="tag:platform" content="#LCase(formOnFile.platform)#">☻'
			scr &= pad & '<meta name="tag:label" content="#LCase(formOnFile.section)#">☻'
		}
		if(load.dosee) {
			var gus = false
			var utils = false
			if(params.dosaudio eq 'gus') gus = true;
			if(params.dosutils) utils = true;
			scr &= pad & '<!-- DOSee initialisation options -->☻'
			scr &= pad & '<meta name="dosee:zip:path" content="#JSStringFormat(dos.gamefilepath)#">☻'
			scr &= pad & '<meta name="dosee:run:filename" content="#trim(dos.startExe)#">☻'
			scr &= pad & '<meta name="dosee:capture:filename" content="#dos.pubkey#.png">☻'
			scr &= pad & '<meta name="dosee:utilities" content="#utils#">☻'
			scr &= pad & '<meta name="dosee:audio:gus" content="#gus#">☻'
			scr &= pad & '<meta name="dosee:width:height" content="#JSStringFormat(dos.resolution)#">☻'
			scr &= pad & '<meta name="dosee:filename" content="#trim(JSStringFormat(fileProd.filename))#">☻'
			if (opCheck('coop')) scr &= pad & '<meta name="dosee:spacekey:start" content="false">☻'
		}
		return scr
	}

	/**
	 * @hint metaUploads sub function for upload controller and submit-file action */
	private string function metaUploads(string scripts = "") {
		var scr = arguments.scripts
		scr &= '<!-- platform hints -->☻'
		loop list="#ListSort(getPlatforms(),'textnocase')#" index="local.platform" delimiters="," {
			var search = StructFindValue(get(myapp),'#platform#','all')
			for (var result in search) {
				if(!StructKeyExists(result,'path')) continue;
				if(Left(result.path,Len('menufileplatform')+1) != ".menufileplatform") continue;
				var name = JSStringFormat(LCase(ReplaceNocase(ListFirst(result.path,'.'),'menufileplatform','')))
				var content = JSStringFormat(result.owner.description)
				scr &= pad & '<meta name="hint:platform:#name#" content="#content#">☻'
			}
		}
		scr &= '<!-- section hints -->☻'
		loop list="#ListSort(getSections(),'textnocase')#" index="local.section" delimiters="," {
			var search = StructFindValue(get(myapp),'#section#','all');
			for (result in search) {
				if(!StructKeyExists(result,'path')) continue;
				if(Left(result.path,Len('menufilesection')+1) != ".menufilesection") continue;
				var name = JSStringFormat(LCase(ReplaceNocase(ListFirst(result.path,'.'),'menufilesection','')))
				var content = JSStringFormat(result.owner.description)
				scr &= pad & '<meta name="hint:section:#name#" content="#content#">☻'
			}
		}
		return scr
	}

	/**
	 * @hint Pre-loads CSS, JavaScript assets for modern browsers.
	 * Learn more: https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content
	 */
	private string function preload() {
		var links = ''
		// PreLoad fonts
		links &= pad & '<link rel="preload" href="/files/fonts/Roboto/roboto-light-webfont.woff2" as="font" type="font/woff2" crossorigin>☻'
		links &= pad & '<link rel="preload" href="/files/fonts/Roboto/roboto-lightitalic-webfont.woff2" as="font" type="font/woff2" crossorigin>☻'
		links &= pad & '<link rel="preload" href="/files/fonts/Roboto/robotocondensed-regular-webfont.woff2" as="font" type="font/woff2" crossorigin>☻'
		links &= pad & '<link rel="preload" href="/files/fonts/Roboto/robotomono-regular-webfont.woff2" as="font" type="font/woff2" crossorigin>☻'
		links &= pad & '<link rel="preload" href="/files/fonts/pxplus_ibm_vga8.woff2" as="font" type="font/woff2" crossorigin>☻'
		links &= pad & '<link rel="preload" href="/files/fonts/px437_ibm_iso9.woff2" as="font" type="font/woff2" crossorigin>☻'
		// PreLoad CSS
		links &= pad & '<link rel="preload" href="#css.bootstrap#" as="style">☻'
		links &= pad & '<link rel="preload" href="#css.hamburger#" as="style">☻'
		links &= pad & '<link rel="preload" href="#css.layout#" as="style">☻'
		if(uri.1 eq 'file' && uri.2 == 'detail' && load.dosee) {
			links &= pad & '<link rel="preload" href="#css.dosee#" as="style">☻'
		}
		// PreLoad JavaScript
		if(load.functions) {
			links &= pad & '<link rel="preload" href="#js.functions#" as="script">☻'
		}
		if(opCheck('coop') && uri.1 == 'system' && uri.2 == 'files' && uri.3 == 'index') {
			links &= pad & '<link rel="preload" href="#js.chartjs#" as="script">☻'
		}
		if(uri.1 == 'upload' && uri.2 != 'submitFile') {
			links &= pad & '<link rel="preload" href="#js.upload1#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.upload2#" as="script">☻'
			if(uri.2 eq 'external') links &= pad & '<link rel="preload" href="#js.upload4#" as="script">☻'
			else links &= pad & '<link rel="preload" href="#js.upload3#" as="script">☻'
		}
		if(uri.1 eq 'file' && uri.2 == 'detail') {
			links &= pad & '<link rel="preload" href="#js.retrotxtcf#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.apiExternal#" as="script">☻'
		}
		if(variables.chiptunePath neq "") {
			links &= pad & '<link rel="preload" href="#variables.chiptunePath#" as="audio" type="application/octet-stream">☻'
		}
		// load scripts & functions required for DOSee emulation
		// load scripts required for DOSee emulation
		if(uri.1 eq 'file' && uri.2 == 'detail' && load.dosee) {
			links &= pad & '<!-- preload dosee resources -->☻'
			links &= pad & '<link rel="preload" href="#js.doseeFuncs#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.doseeLoader#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.doseeInit#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.doseeLibrary1#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.doseeLibrary2#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.doseeLibrary3#" as="script">☻'
			links &= pad & '<link rel="preload" href="#js.doseeLibrary4#" as="script">☻'
			if(opCheck('coop')) {
				links &= pad & '<link rel="preload" href="#js.clipboard#" as="script">☻'
				links &= pad & '<link rel="preload" href="#js.coop#" as="script">☻'
			}
		}
		return format(links)
	}
</cfscript>