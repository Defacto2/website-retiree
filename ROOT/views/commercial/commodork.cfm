<!---
    Commodork view
	path: views/commercial/commodork.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Commodork: Sordid Tales from a BBS Junkie'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "Book", "name" : "Commodork: Sordid Tales from a BBS Junkie", "image" : "https://defacto2.net/images/commercial/thumb_commodork.png", "author" : { "@type" : "Person", "name" : "Rob O-Hara" }, "datePublished" : "2006-08-31", "publisher" : { "@type" : "Organization", "name" : "Lulu.com" }, "isbn" : "1847285829", "review" : { "@type" : "Review", "review-rating" : { "@type" : "Rating", "ratingValue" : "4" }, "author" : { "@type" : "Person", "name" : "Ben Garrett" } } } </script>
<cfoutput>
<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='freaxArtAlbum')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='stealthiscomputerbook')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_commodork.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>Paperback. 168> pages</li>
		<li>Publisher. Lulu.com (August 31, 2006)</li>
		<li>ISBN. 1847285829</li>
		<li>&nbsp;</li>
		<li class="padded-top"><a href="http://www.robohara.com/Commodork/">Official website</a></li>
	</ul>
	<p id="review-rating">Our Review: <span class="badge">Recommended</span></p>
	<div class="well" id="reviewBody">
		<p>For nearly two decades, computer-based Bulletin Board Systems were the primary method of communication between computer users.
			As suddenly as they gained popularity, they were made obsolete by the next big thing - a newfangled system called the Internet.
			Commodork: Sordid Tales from a BBS Junkie takes its readers on an exciting journey through the BBS era.
			Through the author's personal tales and adventures, readers will discover more about these amazing times and what it was like to grow up online.
			With tales of copyfests, BBS parties and random acts of online debauchery, those who were there will find themselves reminiscing, while those who weren't will enjoy learning about life "before the 'net."
			You know, back when we used to modem uphill, both ways in the snow.</p>
	</div>
	<ul>
		<li><a href="http://www.robohara.com/Commodork/buy.htm">Official website</a> - Paperback and PDF. $3-$20 USD.</li>
		<li><a rel="nofollow" href="http://amzn.to/2jouihj"><i class="fab fa-amazon"></i> USA</a> - Paperback and Kindle. $5-$15 USD.<img src="https://ir-na.amazon-adsystem.com/e/ir?t=defacto2&l=as2&o=1&a=1847285821" width="1" height="1" border="0" class="amazon-track" />
		<li><a href="http://www.lulu.com/product/paperback/commodork-sordid-tales-from-a-bbs-junkie/458981">LuLu</a> - Paperback. $15 USD.</li>
	</ul>
</div>