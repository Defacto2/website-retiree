<!---
    Digital Memories view
	path: views/commercial/digitalmemories1.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Digital Memories: The Best of Commodore 64'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "Movie", "name" : "Digital Memories: The Best of Commodore 64", "image" : "https://defacto2.net/images/commercial/thumb_digitalmemories1.png", "director" : { "@type" : "Person", "name" : "Enno Coners" }, "datePublished" : "2011-3-06", "publisher" : { "@type" : "Organization", "name" : "CSW-Verlag" }, "inLanguage" : "English" } </script>
<cfoutput>
<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='mindCandyVol3')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='bbsTheDocumentary')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_digitalmemories1.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>DVD-ROM</li>
		<li>Studio. CSW-Verlag (March 6, 2006)</li>
		<li>ASIS. B000G1TEU0</li>
		<li>&nbsp;</li>
		<li>&nbsp;</li>
		<li>&nbsp;</li>
	</ul>
	<p id="review-rating">Our Review: <span class="badge">n/a</span></p>
	<div class="well" id="reviewBody">
		<p>The spreading of pirated software in the pioneer days of home computing soon spawned the first digital youth culture.
			Crackers, as they were called, would compete to produce the quickest "crack" of a game. And the best way to gain the appropriate fame and notoriety for this feat was to add an "intro" to the game, showing off their nickname and group name.
			These intros got spread along with these games at schools everywhere throughout the 80s. They were often works of art in themselves, and it wasn't unusual for the intro to be better than the game it preceded.
			They often required enormous programming skills and audiovisual talent. Intros led to a new independent digital artform pushed by competition: the demoscene.</p>
		<p>Demos are music videos without dancers, with no sets and no camera.
			Instead, demos generated realtime calculated animations created by specialists in programming, graphics and sound, pushing the computer to its very limits -- and often making the impossible possible, even on classic computers like the Commodore 64, where demos pushed the computer harder than the games.
			They also borrowed the best music of the genre, often turning an unremarkable game tune into a classic in the process.</p>
		<p>'Digital Memories' is a selection of the best demos for the Commodore 64.
			An exciting retrospective trip through virtual worlds full of effects, bleeps and pixels that is truly multimedia for the 1st digital generation.</p>
	</div>
	<ul>
		<li><a href="http://www.amazon.de/dp/3981049470"><i class="fab fa-amazon"></i> Germany</a> - 11,59&#8364;.</li>
	</ul>
</div>