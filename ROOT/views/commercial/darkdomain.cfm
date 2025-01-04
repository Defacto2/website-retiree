<!---
    Dark Domain view
	path: views/commercial/darkdomain.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Dark Domain: The Artpacks.acid.org Collection'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "DataCatalog", "name" : "Dark Domain: The Artpacks.acid.org Collection", "image" : "https://defacto2.net/images/commercial/thumb_darkdomain.png", "datePublished" : "2004-01-01", "publisher" : { "@type" : "Organization", "name" : "ACiD Productions" }, "inLanguage" : "English" }</script>
<cfoutput>
<form method="post">
	<span class="hidden">
	<!--- used by javascript pagination, should be kept hidden --->
	<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
	<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='mindCandyVol2')#"></button>
	<button id="GotoNextPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_darkdomain.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>DVD-ROM</li>
		<li>Studio. ACiD Productions, LLC (January 1, 2004)</li>
		<li>ISBN. 0974653705</li>
		<li class="padded-top"><a href="http://cd.textfiles.com/darkdomain/whatisit.html">Acid Productions</a></li>
	</ul>
	<p id="review-rating">Our Review: <span class="badge">n/a</span></p>
	<div class="well">
		<p>With bloodshot eyes, I present to you Dark Domain; the most comprehensive artscene compilation to date</p>
		<p>This library is an accumulation of artistic and literary works born from the creative minds of the IBM-PC underground with pieces dating all the way back to the late 1980s.
			Just as I have spent so many countless late nights maintaining and compiling this collection, so have so many others done the same creating, packaging, trading, viewing and discussing the very elements that make it.</p>
		<p>Dark Domain breaks out into four main sets: artpacks, loaders, mags, and programs.
			Also included is the legacy HTML from the formerly web enabled version of artpacks.acid.org and several other hidden Easter eggs. </p>
	</div>
	<div id="reviewBody">
		<p>We don't have a copy of this product, so there is no review, but this DVD-ROM is a file archive of the once popular artpacks.acid.org website.
			That once was a huge file repository that covered the demo, art (and occasionally cracking) scenes with a wide variety of packs, magazines and miscellaneous files.</p>
		<p>In 2003 it went off line due to excessive bandwidth usage and the costs associated this service, but you can still get the collection mirrored in its entirety on this great DVD.
			The collection is now back online and is hosted by <a href="https://twitter.com/textfiles">Jason Scott</a> at <a href="http://artscene.textfiles.com/">artscene.textfiles.com</a>.</p>
	</div>
	<ul>
		<li><mark><a href="http://artscene.textfiles.com/">artpacks.textfiles.com: The entire collection with a web interface</a></mark></li>
		<li><a href="http://cd.textfiles.com/darkdomain/">cd.textfiles.com: The entire collection without the web interface</a></li>
	</ul>
</div>