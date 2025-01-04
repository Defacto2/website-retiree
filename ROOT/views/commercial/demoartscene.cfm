<!---
    Demoscene: The Art of Real-Time view
	path: views/commercial/demoartscene.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Demoscene: The Art of Real-Time'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "Book", "name" : "Demoscene: The Art of Real-Time", "image" : "https://defacto2.net/images/commercial/thumb_demoartscene.png", "author" : { "@type" : "Person", "name" : "Lassi Tasajärvi" }, "datePublished" : "2004-06-01", "publisher" : { "@type" : "Organization", "name" : "Even Lake Studios" }, "inLanguage" : "English", "isbn" : "952917022X", "review" : { "@type" : "Review", "review-rating" : { "@type" : "Rating", "ratingValue" : "3" }, "author" : { "@type" : "Person", "name" : "Ben Garrett" } } } </script>
<cfoutput>
<form method="post">
	<span class="hidden">
	<!--- used by javascript pagination, should be kept hidden --->
	<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
	<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='darkDomain')#"></button>
	</span>
</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_demoartscene.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>Paperback. 72 pages</li>
		<li>Publisher. Even Lake Studios (June 1, 2004)</li>
		<li>ISBN. 952917022X</li>
		<li class="padded-top"><a href="https://web.archive.org/web/20070203084333/http://www.demoscenebook.com:80/books/">Official website archived</a></li>
		<li><del><a href="http://www.evenlakestudios.com/">Official website</a></del></li>
		<li>&nbsp;</li>
	</ul>
	<p id="review-rating">Our Review: <span class="badge">Limited interest</span></p>
	<div id="reviewBody" class="well">
		<p>This book is the first of its kind dealing with the demoscene and multimedia art created by hacker and cracker artists.</p>
		<p>The demoscene is one of the most interesting phenomena to come out of digital media culture.
			It's a culture created by the first generation of kids who grew up with home computers and computer games in the 1980s.</p>
		<p>Even before Internet use became widespread, thousands of audiovisual works had been globally published and distributed by the demoscene culture.
			This was done using modems and diskettes.</p>
		<p>The demoscene spawned a group of people that have worked in or started companies that played an important and pioneering role in the game, new media, digital graphics and ICT-sector industries in many countries.
			The demoscene was where many digital media artists, electronic music composers, as well as visual club culture and virtual community activists got their start.</p>
		<p>In the 2000s, the demoscene is still an active and productive global network and culture. The book is a long awaited introduction to a phenomenon, whose birth, background and consequences deserve to be widely known and discussed.</p>
	</div>
	<div id="reviewBody">
		<p>This booklet is a small primer for the demo scene with its glorious and in-depth history.
			While it is professionally produced and is quite readable, one gets the feeling that it is just too short.
			It feels the production of this publication has sacrificed style over substance.</p>
	</div>
</div>