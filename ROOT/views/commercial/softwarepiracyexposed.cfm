<!---
    Software Piracy Exposed view
	path: views/commercial/softwarepiracyexposed.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Software Piracy Exposed'
	pageAbout.icon = ''
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "Book", "name" : "Software Piracy Exposed", "image" : "https://defacto2.net/images/commercial/thumb_software_piracy_exposed.png", "author" : { "@type" : "Person", "name" : "Ron Honick" }, "datePublished" : "2005-10-07", "publisher" : { "@type" : "Organization", "name" : "Syngress" }, "inLanguage" : "English", "isbn" : "0080489737", "review" : { "@type" : "Review", "review-rating" : { "@type" : "Rating", "ratingValue" : "4" }, "author" : { "@type" : "Person", "name" : "Ben Garrett" } } } </script>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='stealthiscomputerbook')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='freaxVol1')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
	</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_software_piracy_exposed.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>Paperback. 400 pages</li>
		<li>Publisher. Syngress (October 07, 2005)</li>
		<li>ISBN. 0080489737, 9781932266986</li>
		<li class="padded-top">&nbsp;</li>
		<li>&nbsp;</li>
	</ul>
	<p id="review-rating">Our Review: <span class="badge">Recommended</span></p>
	<div class="well" id="reviewBody">
		<p>In 2004 the author meet and later befriended a number of warez scene members at the now famous DEF CON hacker conference.
			This book was written while he loitered within the PC warez scene for a year after that chance meeting.</p>
		<p>The topics covered are more of the technical aspects of the Scene rather than the personalities involved or the group politics.
		So while some of the information is well out of date it could be a worthwhile for those who are interested in learning about scene terminology or it's history as-well as how or why things were conducted in the way they were.</p>
	</div>
	<ul>
		<li class="padded-top"><a rel="nofollow" href="http://amzn.to/2jmC9MR"><i class="fab fa-amazon"></i> USA</a> - Paperback and Kindle. $35-$42 USD.<img src="//ir-na.amazon-adsystem.com/e/ir?t=defacto2&l=as2&o=1&a=1932266984" width="1" height="1" border="0" alt="" class="amazon-track" /></li>
		<li><a href="http://books.google.com/books/about/Software_Piracy_Exposed.html?id=cA3qL9PBR0kC"><i class="fab fa-google-play"></i>  Play Books</a> - EPUB $33 USD.</li>
	</ul>
</div>