<!---
    File navigation partial view.
	path: views/files/_prod_navigation.cfm

@CFLintIgnore
--->
<cfscript>
	var disableDownload = function() {
		if(humanizeFileSize(Val(fileProd.fileSize)) == "n/a") return " disabled";
		return ""
	}
	var figurePlay = function() {
		figure.text = "View file in browser"
		figure.icon = "browser"
		if(IsAudio(fileProd.filename)) {
			figure.text = "Play in browser";
			figure.icon = "play"
			return
		}
		if(IsVideo(fileProd.filename)) {
			figure.text = "Play in browser";
			figure.icon = "play"
			return
		}
	}
	var macOS = function() {
		keyboard.ctrl='^'
		keyboard.ctrlAlt='⌘'
		keyboard.alt='⌘'
		keyboard.up='▲'
		keyboard.down='▼'
	}
	var figure = {
		"fileSize":0,
		"icon":"",
		"text":"",
	}
	var keyboard = {
		"ctrl":'Ctrl',
		"ctrlAlt":'Ctrl',
		"alt":'Alt',
		"up":'PgUp',
		"down":'PgDn',
	}
	variables.queryString = "name=#params.name#&src=#params.src#&platform=#params.platform#&section=#params.section#&sort=#params.sort#"
	if(IsNumeric(fileProd.filesize) && fileProd.filesize) figure.filesize = fileProd.filesize
	if(useViewFile(fileProd.filename, figure.filesize, fileProd.platform)) figurePlay();
	if(whoisSystemType(cgi.http_user_agent).platform == 'macOS') macOS();
</cfscript>
<cfoutput>
	<a id="detailbuttons"></a>
	<form method="post">
		<span class="hidden">
			<!--- used by javascript pagination, should be kept hidden --->
			<button id="GotoFirstPage" #nav.btn.first# type="submit" formaction="#URLFor(route='f',key=obfuscateParam(nav.rec.first),params=queryString,rel='nofollow')#"></button>
			<button id="GotoLastPage" #nav.btn.last# type="submit" formaction="#URLFor(route='f',key=obfuscateParam(nav.rec.last),params=queryString,rel='nofollow')#"></button>
		</span>
		<div class="btn-toolbar grouping nav-toolbar-container form-action" role="toolbar">
			<div class="btn-group btn-group-sm" role="group" aria-label="pagination and downloads">
				<button id="GotoPrevPage" #nav.btn.prev# type="submit" data-container="body" class="btn btn-default" rel="prev" formaction="#URLFor(route='f',key=obfuscateParam(nav.rec.prev),params=queryString,rel='nofollow')#" title="Go to the previous file (← arrow key)" role="group" aria-label="previous page">Tap <i class="fal fa-arrow-alt-left fa-lg"></i></button>
				<button id="GotoNextPage" #nav.btn.next# type="submit" data-container="body" class="btn btn-default" rel="next" formaction="#URLFor(route='f',key=obfuscateParam(nav.rec.next),params=queryString,rel='nofollow')#" title="Go to the next file (arrow key →)" role="group" aria-label="next page">Tap <i class="fal fa-arrow-alt-right fa-lg"></i></button>
				<cfif len(figure.text)>
					<!-- view or play file in browser -->
					<button type="submit" data-container="body" class="btn btn-default" id="view_menu" formaction="#URLFor(controller='file',action='view',key=obfuscateParam(fileProd.id))#" title="#figure.text#" data-toggle="tooltip" data-placement="top" role="group" aria-label="view file"><i class="fal fa-#figure.icon# fa-lg"></i></button>
				</cfif>
			</div>
			<!-- links menu -->
			<div class="btn-group btn-group-sm tablet-hide" role="group" aria-label="more links">
				<button type="button" class="btn btn-default" id="links_menu" style="#button.link.style#" disabled>LINKS</button>
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" style="#button.link.style#" title="List related links" data-toggle="tooltip" data-placement="right" role="group">
					<span class="caret"></span>
					<span class="sr-only">Toggle Dropdown</span>
				</button>
				<ul class="dropdown-menu" role="menu" aria-labelledby="links_menu">
					<li>
						<a href="https://defacto2.net#URLFor(onlyPath=true,route="f",key=obfuscateParam(fileProd.id))#"><i class="fal fa-clipboard fa-fw"></i> Share this page</a>
					</li>
					<cfif downloadAllowed(fileProd)>
						<li>
							<a href="https://defacto2.net#URLFor(onlyPath=true,route='d',key=obfuscateParam(fileProd.id))#"><i class="fal fa-file-download fa-fw"></i> Share the download</a>
						</li>
					</cfif>
					<cfif useViewFile(fileProd.filename, figure.filesize, fileProd.platform)>
						<li class="divider"></li>
						<li class="dropdown-header">Export</li>
					</cfif>
					<!--- View file as a raw document in browser --->
					<cfif useViewFile(fileProd.filename, figure.filesize, fileProd.platform)>
						<li><a href="#UrlFor(controller='file',action='view',key=obfuscateParam(fileProd.id))#"><i class="fal fa-browser fa-fw"></i> View in browser</a></li>
					</cfif>
					<!--- scene sites --->
					<cfif Len(fileProd.web_id_pouet) or Len(fileProd.web_id_demozoo)>
						<li class="divider"></li>
						<li class="dropdown-header">Discussions</li>
					</cfif>
					<!-- pouët -->
					<cfif Len(fileProd.web_id_pouet)>
						<li>
							<a href="#get('myapp').other.pouet##fileProd.web_id_pouet#" title="Jump to the discussion on Pouët"><i class="fal fa-comments fa-fw"></i> Pouët</a>
						</li>
					</cfif>
					<!-- demozoo -->
					<cfif Len(fileProd.web_id_demozoo)>
						<li>
							<a href="#get('myapp').other.demozoo##fileProd.web_id_demozoo#" title="Jump to the discussion on Demozoo"><i class="fal fa-comments fa-fw"></i> Demozoo</a>
						</li>
					</cfif>
				</ul>
			</div>
			<!--- display options--->
			<div class="btn-group btn-group-sm btn-group-as-form" role="group" aria-label="display options">
				<button type="submit" data-container="body" class="btn btn-default tablet-hide" formaction="#XMLFormat(youTubeUI.url)#" aria-label="Toggle YouTube videos" title="Toggle YouTube videos" data-toggle="tooltip" data-placement="top" role="group">
					<i class="fab fa-youtube fa-fw fa-lg"></i><i class="fal fa-#youTubeUI.icon# fa-fw fa-lg #youTubeUI.colour#"></i>
				</button>
				 <button type="submit" data-container="body" class="btn btn-default" formaction="#XMLFormat(dosee.url)#" aria-label="Toggle DOSee emulation" title="Toggle DOSee emulation" data-toggle="tooltip" data-placement="top" role="group">
					#svg(icon='dosee',size='lg')#<i class="fal fa-#dosee.icon# fa-fw fa-lg #dosee.colour#"></i>
				 </button>
			</div>
			<cfif opCheck('coop')>
				<!--- operator tools --->
				<form method="post">
					<div class="btn-group btn-group-sm">
						<button type="button" data-container="body" class="btn btn-default" disabled><i class="fal fa-camera fa-lg"></i></button>
						<cfif opCheck('sysop')>
							<button type="submit" id="deleteThumb" data-container="body" class="btn btn-#image.kill.colour#" formaction="#URLFor(controller='file',action='edit',key=obfuscateParam(fileProd.id),params='#image.kill.value#&#queryString#')#" data-toggle="tooltip" data-placement="bottom" title="Delete all images" #image.kill.status#><i class="fal fa-times fa-lg"></i></button>
						</cfif>
						<cfif image.x400.size>
							<button type="submit" id="refresh_thumbs" data-container="body" class="btn btn-#image.regenerate.colour#" formaction="#URLFor(controller='file',action='edit',key=obfuscateParam(fileProd.id),params='#image.regenerate.value#&#queryString#')#" data-toggle="tooltip" data-placement="bottom" title="Refresh thumbnails keeping source aspect ratio" #image.regenerate.status#><i class="fal fa-square fa-lg"></i></button>
						</cfif>
						<cfif image.x400.size eq 0>
							<button type="submit" id="refresh_thumbs" data-container="body" class="btn btn-#image.generate.colour#" formaction="#URLFor(controller='file',action='edit',key=obfuscateParam(fileProd.id),params='#image.generate.value#&#queryString#')#" data-toggle="tooltip" data-placement="bottom" title="Refresh thumbnails, screenshots and information images" #image.generate.status#><i class="fal fa-redo fa-lg"></i></button>
						</cfif>
					</div>
					<!--- record accessibility --->
					<div class="btn-group btn-group-sm btn-group-as-form">
						<button type="submit" id="refresh_archive" class="btn btn-#image.scan.colour#" formaction="#URLFor(controller='file',action='edit',key=obfuscateParam(fileProd.id),params='#image.scan.value#')#" data-toggle="tooltip" data-placement="bottom" title="Refresh archive content" #image.scan.status#>
							<i class="fal fa-archive fa-lg"></i> <i class="fal fa-redo fa-lg"></i> &nbsp; <kbd class="text-uppercase">Ctrl+Alt+P</kbd>
						</button>
					</div>
					<div class="btn-group btn-group-sm btn-group-as-form">
						<button type="submit" id="recordActivation" class="btn btn-#button.activation.colour#" formaction="#URLFor(controller='file',action='edit',key=obfuscateParam(fileProd.id),params='#button.activation.value#')#" data-toggle="tooltip" data-placement="bottom" title="Toggle activation and public access">
							<i class="fal fa-folder fa-lg"></i> <i class="fal fa-#button.activation.icon# fa-lg white"></i> &nbsp; <strong class="text-uppercase">File is #button.activation.text#</strong> &nbsp; <kbd class="text-uppercase">Ctrl+Alt+Equal</kbd>
						</button>
					</div>
					#hiddenFieldTag(name="uuid",value="#fileProd.uuid#")#
					#hiddenFieldTag(name="filename",value="#fileProd.filename#")#
				</form>
				<!--- Permanently Delete dialogue --->
				<cfif Len(fileProd.deletedAt) and opCheck('sysop')>
					<form method="post" class="form-inline">
						<div class="input-group input-group-sm" style="margin-right:0.5em;">
							<span class="input-group-addon">
								<input type="checkbox" name="confirm" value="true"><b class="brand-danger"> Confirm</b>
							</span>
							<span class="input-group-btn">
								<button class="btn btn-default btn-danger" type="submit" formaction="#URLFor(controller="File",action="delete",id="opKillForm")#" data-toggle="tooltip" data-placement="bottom" title="Permanent delete"><i class="fal fa-trash fa-lg"></i></button>
							</span>
						</div>
						#hiddenFieldTag(name="uuid",value="#fileProd.uuid#")#
						<cfif nav.rec.next neq 0>
							#hiddenFieldTag(name="goto",value="#obfuscateParam(nav.rec.next)#")#
						<cfelseif nav.rec.prev neq 0>
							#hiddenFieldTag(name="goto",value="#obfuscateParam(nav.rec.prev)#")#
						</cfif>
					</form>
				</cfif>
			<cfelse>
				<!--- send us files menu --->
				#includePartial('prod_nav-sendfiles')#
			</cfif>
		</div>
	</form>
	<!--- #dump(CLIENT)# #dump(PARAMS)# --->
</cfoutput>