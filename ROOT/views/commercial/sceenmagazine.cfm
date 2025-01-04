<!---
    Sceen - Magazine view
	path: views/commercial/sceenmagazine.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Sceen - Magazine for Digital Extravaganza'
	pageAbout.icon = 'fal fa-shopping-bag'
</cfscript><cfoutput>
<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='freaxVol1')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='mindCandyVol2')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
</form>
<div id="commercial-controller" class="readable-text">
	#imageTag(source="commercial/thumb_sceenmagazine.png", alt="Box preview", class="preview commercial-thumb")#</cfoutput>
	<ul>
		<li>Magazine (English).</li>
		<li class="padded-top"><a href="https://web.archive.org/web/20090129051232/http://sceen.org/microsite/">Official website archived</a></li>
		<li><del><a href="http://sceen.org/microsite/">Official website</a></del></li>
		<li class="padded-top">&nbsp;</li>
	</ul>
	<p id="review-rating">Our Review: <span class="badge">n/a</span></p>
	<div class="well" id="reviewBody">
		<p>SCEEN 'magazine for digital extravaganza' is an international magazine for digital arts and culture between pop and sub, high and low, on and off.
			SCEEN compiles a fine selection of stories and projects / artist features from such areas as Creative Coding, Demoscene, Machinima, Micromusic, Netaudio, VJing, 2D/3D Animation, Motiongraphics, Game and Media Arts.</p>
		<p>SCEEN #1 SEPTEMBER 05: Demoscene: Breakpoint 2005, Scene.org Awards 2004, Shizzle (Pokmon mini hacking), Mobile Mayhem (realtime demos on cellphones) Machinima: Reviews, Animation for the Nation, Person 2184, Engine, Play/Pause Game Art: John Paul Bichard's Evidencia Series, i am 8-bit Netaudio: Netlabel Feature, Monotonik, Stadtgrn Micromusic: Mikro-K Trainers, Lektrogirl's High 5 3D Animation: Amondo VGRemixing: Nostalgia with a Substance VJing: SAS21, Effekt</p>
		<p>SCEEN #2 2007: Featured Artists: VJ/DJ/AV ensemble ADDICTIVE TV (UK), generative artists MARIUS WATZ (NO) and LIA (AT), 3D animator and film maker ROBERT SEIDEL (DE), Wiimote DJ/VJ DAITO MANABE (JP), the STRUKT VJs (AT), ASD (GR), 8-bit/reggae crossover artist DISRUPT/JAHTARI.ORG, the 4 kilobytes microfilm coder MINAS (DE), the Tekken theatre performers from GOD'S ENTERTAINMENT (AT) and many, many more.</p>
	</div>
</div>