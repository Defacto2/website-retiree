<!---
    Publications view
	path: views/commercial/index.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = ' <span class="mobile-hide">Publications</span><span class="mobile-show">Goodies</span>'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='theModemWorld')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
  </form>
	<div class="readable-text" id="commercial-controller">
		<p class="mobile-hide lead">You might ask why pay for something that you could probably find online for free?<br></p>
		<p class='mobile-hide'>Well sometimes viewing a disc in the comfort of your lounge room is a lot easier and more convenient than spending hours searching and hunting online.
			Others including myself simply prefer reading printed text on paper rather than the harsher low-resolution computer fonts used on websites.
			Either way, often non-computer mediums are just an easier way of relaying information or displaying media. And let's not forget that many of the items listed below delve into topics that are often only covered to a limited degree online.
		</p>
		<div class="thumb-menu-container row">
			<h3>Contemporary</h3>
			<a href="#urlFor(action="themodemworld")#"><img src="/images/commercial/thumb_themodemworld.jpg" title="The Modem World: A Prehistory of Social Media (2022)" alt="book preview" class="preview commercial-thumb" width="150" height="240"></a>
			<a href="#urlFor(action="warez")#"><img src="/images/commercial/thumb_warez.jpg" title="Warez: The Infrastructure and Aesthetics of Piracy (2021)" alt="book preview" class="preview commercial-thumb" width="150" height="240"></a>
		</div>
		<div class="thumb-menu-container row">
			<h3>Older publications, <small>still in stock and sold by their distributor</small></h3>
			<a href="#urlFor(action="mindCandyVol3")#">#imageTag(source="commercial/thumb_mindcandyvol3.png", alt="Box preview", title="MindCandy Volume 3 (2011)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="digitialMemories1")#">#imageTag(source="commercial/thumb_digitalmemories1.png", alt="Box preview", title="Digital Memories 1 - The Best of Commodore 64 (2006)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="commodork")#">#imageTag(source="commercial/thumb_commodork.png", alt="Box preview", title="Commodork: Sordid Tales from a BBS Junkie (2006)", class="preview commercial-thumb")#</a>
		</div>
		<div class="thumb-menu-container row">
			<a href="#urlFor(action="digitalcultureindustry")#">#imageTag(source="commercial/thumb_digitalcultureindustry.png", alt="Box preview", title="Digital Culture Industry (2013)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="stealthiscomputerbook")#">#imageTag(source="commercial/thumb_stealthiscomputerbook.png", alt="Box preview", title="Steal This Computer Book (2006)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="softwarePiracyExposed")#">#imageTag(source="commercial/thumb_software_piracy_exposed.png", alt="Box preview", title="Software Piracy Exposed (2005)", class="preview commercial-thumb")#</a>
		</div>
		<hr>
		<div class="thumb-menu-container row">
			<h4>Out of print <small>but available digitally gratis</small></h4>
			<a href="#urlFor(action="bbsTheDocumentary")#">#imageTag(source="commercial/thumb_bbsthedocumentary.png", alt="Box preview", title="BBS - The Documentary (2005)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="mindCandyVol1")#">#imageTag(source="commercial/thumb_mindcandyvol1.png", alt="Box preview", title="MindCandy Volume 1 (2003)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="mindCandyVol2")#">#imageTag(source="commercial/thumb_mindcandyvol2.png", alt="Box preview", title="MindCandy Volume 2 (2007)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="darkDomain")#">#imageTag(source="commercial/thumb_darkdomain.png", title="Dark Domain (2004)", alt="Box preview", class="preview commercial-thumb")#</a>
		</div>
		<div class="thumb-menu-container row">
			<h4>Out of print</h4>
			<a href="#urlFor(action="demoArtScene")#">#imageTag(source="commercial/thumb_demoartscene.png", alt="Box preview", title="Demo Artscene (2004)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="freaxArtAlbum")#">#imageTag(source="commercial/thumb_freaxartalbum.png", alt="Box preview", title="Freax - The Art Album (2007)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="freaxVol1")#">#imageTag(source="commercial/thumb_freaxvol1.png", alt="Box preview", title="Freax - The brief history of the demoscene (2005)", class="preview commercial-thumb")#</a>
			<a href="#urlFor(action="sceenMagazine")#">#imageTag(source="commercial/thumb_sceenmagazine.png", alt="Box preview", title="Sceen Magazine (2005, 2007)", class="preview commercial-thumb")#</a>
		</div>
		<hr>
	</div>
</cfoutput>