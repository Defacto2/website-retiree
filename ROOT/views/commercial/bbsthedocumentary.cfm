<!---
    BBS - The Documentary view
	path: views/commercial/bbsthedocumentary.cfm

@CFLintIgnore
--->
<cfscript>
	var baseLink = "https://archive.org/download/BBS.The.Documentary/BBS.The.Documentary"
	pageAbout.text = 'BBS - The Documentary'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript>
<script type="application/ld+json"> { "@context" : "http://schema.org", "@type" : "Movie", "name" : "BBS - The Documentary", "image" : "https://defacto2.net/images/commercial/thumb_bbsthedocumentary.png", "url" : "http://www.bbsdocumentary.com/", "datePublished" : "2005-05-01", "director" : { "@type" : "Person", "name" : "Jason Scott" }, "review" : { "@type" : "Review", "review-rating" : { "@type" : "Rating", "ratingValue" : "5", "author" : { "@type" : "Person", "name" : "Ben Garrett" } } } } </script>
<cfoutput>
	<form method="post">
		<span class="hidden">
			<!--- used by JS pagination, should be kept hidden --->
			<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
			<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='digitialMemories1')#"></button>
			<button id="GotoNextPage" type="submit" formaction="#URLFor(action='mindCandyVol1')#"></button>
			<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
		</span>
	</form>
	<div id="commercial-controller" class="readable-text">
		#imageTag(source="commercial/thumb_bbsthedocumentary.png", alt="Box preview", class="preview commercial-thumb")#
		<ul>
			<li>All Region DVD (480i NTSC, MPEG-2/Dolby 2.0)</li>
			<li>Running Time. 330 minutes</li>
			<li>Studio. Bovine Ignition Systems (May 1, 2005)</li>
			<li>ASIN. B0009NN6EA</li>
			<li class="padded-top">
				<ul>
					<li class="inline"><a href="http://www.bbsdocumentary.com/">Official website</a> - </li>
					<li class="inline"><a href="http://www.imdb.com/title/tt0460402/">IMDB</a> - </li>
					<li class="inline"><a href="http://www.archive.org/details/BBS.The.Documentary">Internet Archive</a></li>
				</ul>
			</li>
		</ul>
		<div>
			<p id="review-rating">Our Review: <span class="badge">Highly recommended</span></p>
			<div id="reviewBody">
				<p>The objective of a documentary is to cover a particular topic, and it must be able to communicate the subject to people who may have no prior knowledge or have never even heard of it. Further, it also needs to provide explanations in a matter that are entertaining and engaging, and on both counts, this documentary manages to succeed.</p>
				<p>BBS avoids the trap of sounding like a typical technobabble IT video by staying clear of the hard technical sides of the old bulletin board systems. Rather, it covers the people, personalities, communities, and politics that evolved from this new technical, social medium, making it much more palatable and enjoyable viewing.</p>
				<p>Interestingly though this is an independently financed and produced production by the first-time director, Jason Scott of www.textfiles.com fame. While normally I would be wary of such a production, Jason has managed to maintain a certain level quality and professionalism, so that the documentary wouldn't look out of place as a series on a documentary cable channel.</p>
				<p>The DVD itself is also finely constructed and could put a few Hollywood studio releases to shame. The three-disc DVD set comes in a 4-page plastic fold out holder with a slip on cover. Each of the covers has appropriate photos, glossy graphics or text, and it is not a cheap production.</p>
				<p>Now for all the praises I have labelled on this DVD there are also a couple of bad points. Firstly it can drag on a bit, and while we know there is a huge amount of information on this topic to cover, sometimes I found myself wanting to reach for the skip button on my remote. The another problem is purely a superficial one; some the people interviewed are just plain butt ugly. Maybe that is part of the reason these people were attracted to BBSing in the first place. Now I know this might seem a minor point to pick on, but when you have to watch 5 and a half hours of the documentary some of these can start to wear on you a bit.</p>
			</div>
			<ul>
				<li><a href="#baseLink#.ep1_512kb.mp4">Episode 1: <i>Baud</i> the beginnings of the first BBSes, featuring Ward Christensen and Randy Suess</a></li>
				<li><a href="#baseLink#.ep2_512kb.mp4">Episode 2: <i>SysOps and Users</i> experiences from those who used and operated BBSes</a></li>
				<li><a href="#baseLink#.ep3_512kb.mp4">Episode 3: <i>Make it Pay</i> the BBS industry of the 1980s and 90s featuring Philip L. Becker, founder of eSoft</a></li>
				<li><a href="#baseLink#.ep4_512kb.mp4">Episode 4: <i>FidoNet</i> details the largest volunteer-run computer network in history</a></li>
				<li><mark><a href="#baseLink#.ep5_512kb.mp4">Episode 5: <i>Artscene</i> the history of the ANSI Art Scene which thrived in the BBS world</a></mark></li>
				<li><mark><a href="#baseLink#.ep6_512kb.mp4">Episode 6: <i>HPAC (Hacking Phreaking Anarchy Cracking)</i> hear from the users of "underground" BBSes</a></mark></li>
				<li><mark><a href="#baseLink#.ep7_512kb.mp4">Episode 7: <i>No Carrier</i> the end of the dial-up BBS and its integration into the Internet</a></mark></li>
				<li><a href="#baseLink#.ep8_512kb.mp4">Episode 8: <i>Compression</i> the story of the PKWARE/SEA legal battle of the late 1980s</a></li>
				<li><a href="https://archive.org/download/BBS.The.Documentary/BBS.The.Documentary_archive.torrent">All episodes torrent</a></li>
			</ul>
		</div>
	</div>
</cfoutput>