<!---
    Freax - The Art Album view
	path: views/commercial/freaxartalbum.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Freax - The Art Album'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "Book", "name" : "Freax - The Art Album", "image" : "https://defacto2.net/images/commercial/thumb_freaxartalbum.png", "author" : { "@type" : "Person", "name" : "Tamás Polgár" }, "datePublished" : "2007-01-01", "publisher" : { "@type" : "Organization", "name" : "CSW-Verlag" }, "inLanguage" : "English", "isbn" : "3981049411", "review" : { "@type" : "Review", "review-rating" : { "@type" : "Rating", "ratingValue" : "3" }, "author" : { "@type" : "Person", "name" : "Ben Garrett" } } } </script>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='digitalcultureindustry')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='commodork')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
	</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_freaxartalbum.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>Hardcover. 296 pages</li>
		<li>Publisher. CSW-Verlag (January 1, 2007)</li>
		<li>ISBN. 3981049411</li>
		<li class="padded-top"><a href="http://freax.intro.hu/">Official website</a></li>
		<li>&nbsp;</li>
	</ul>
	<div>
		<p id="review-rating" >Our Review: <span class="badge">Limited interest</span></p>
	</div>
	<div class="well">
		<p id="reviewBody">The Art Album boasts an extensive visual collection of some of the finest computer graphic art to come from the underground computer art scene.
			This album contains a wide array of art, ranging from pixel drawn graphics, raw ASCII art and its colourful companion, ANSI art, as well as an exclusive set of hand-drawn floppy disk covers made in a time when it was more convenient to trade disks by mail rather than modem.
			Hardware platforms used to create these works include: Amiga, Atari, Commodore 64, IBM PC, and the ZX Spectrum.</p>
	</div>
</div>