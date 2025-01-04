<!---
  	Defacto2 home view.
	path: views/home/index.cfm

@CFLintIgnore
--->
<cfscript>
	param name="params.key" type="string" default="";
	var learnAboutLink = linkTo(text="The Scene",controller="defacto2",action="subculture", rel="prefetch")
	var straightToLink = linkTo(text="The files", controller="file",action="index", rel="prefetch")
	// these variables are needed by the search dialogue partials
	pageAbout.text = ''
	pageAbout.icon = 'fal fa-home'
	var search = {
		"input":"search",
	}
	var loggedInUser = function() {
		if (!isStruct(session) or !StructKeyExists(session,"op") or !StructKeyExists(session.op,"uuid")) return;
		// fetch the account of the logged in user
		return model("operator").findOneByUUID(value=session.op.uuid,returnAs="query")
	}
	var superUser = loggedInUser()
</cfscript>
<cfoutput>

<div class="row" id="welcomeLeadContainer">
  <div id="retrotxt-canvas" style="background-color:inherit;color:##444;">
       ·      ▒██▀ ▀       ▒██▀ ▀              ▀ ▀▒██             ▀ ▀███ ·
       : ▒██▀ ▓██ ▒██▀▀██▓ ▓██▀▀▒██▀▀███ ▒██▀▀██▓ ▓██▀ ▒██▀▀███ ▒██▀▀▀▀▀ :
  · ··─┼─▓██──███─▓██─▄███─███──▓██──███─▓██──────███──▓██──███─▓██──███─┼─·· ·
       │ ███▄▄██▓ ███▄▄▄▄▄▄██▓  ███▄ ███▄███▄▄███ ███▄▄███▄ ███▄███▄▄███ │
 · ··──┼─────────··              defacto2.net                 ··─────────┼──·· ·
       │                                                                 :
       :                  ·· WELCOME TO DEFACTO2 ··                      ·
  </div>
  <div class="col-md-12 col-lg-8 gray-dark">
Defacto2 is a website committed to preserving the historic PC cracking and warez scene subcultures.
It covers digital objects including text files, demos, music, art, magazines, and other projects.
While a seldom-discussed subject, this element of the underground computer subculture could be lost and forgotten without a preservation effort.
The nature of digital piracy, with its high churn for participants, means it is a community that is not well documented nor explained.
<small><a href="/defacto2/subculture">Learn more…</a></small>
<p>Unfortunately, some files have inappropriate or harmful comments or imagery—a possible consequence of the era and the ages of the people involved, often kids.</p>
</div>
</div>

<nav class="hidden-xs navbar navbar-default" id="welcomeNavBar">
	<div class="container-fluid">
		<ul class="nav navbar-nav hidden-sm hidden-md">
			<li>#straightToLink#</li>
			<li>#learnAboutLink#</li>
		</ul>
		#startFormTag(controller="search",action="processurl",method="post",id="search",class="navbar-form navbar-left hidden-sm")#
			<div class="form-group">
				<input name="query" type=search.input class="form-control" placeholder="Search">
				<input name=search.input type="hidden" value="all">
			</div>
			<button type="submit" class="btn btn-default">Submit</button>
		#endFormTag()#
		<cfif IsDefined("superUser")><p class="navbar-text">Signed in as #superUser.username#</p></cfif>
		<p class="navbar-text">#linkTo(text="Recent additions",route="fileFilter",key="new",rel="prefetch",id="homeNewestFiles")#<cfif len(timeAgo)> <small>updated #timeAgo#</small></cfif><small class="hidden-md" id="homeNewFileCount"></small></p>
	</div>
</nav>

<div class="row files-index" id="milestones">
<hr>
<h2>Scene milestones</h2>
<div class="col-md-12 col-lg-8 gray-dark">
In the early days of modern computing, the terms microcomputer and personal computer were interchangeable.
This site defines the <strong>PC</strong> as the Intel-compatible x86 architecture known initially as the
<a href="https://www.intel.com/content/www/us/en/history/virtual-vault/articles/the-8086-and-the-ibm-pc.html">IBM PC</a> but evolved to MS-DOS and Windows.
All other personal computer platforms get referenced as microcomputers.
<br>
These milestones are for the PC underground and cracking scenes.
They are not definitive but are based on the digital artifacts collected.
<br>
The more notable communities on other microcomputer platforms are seldom mentioned here,
including the famed <a href="//www.textfiles.com/artscene/intros/APPLEII/.thumbs.html">Apple II</a>,
<a href="//www.atlantis-prophecy.org/recollection/?load=online_issues&issue=1&sub=article&id=2">Commodore 64</a>,
and <a href="//janeway.exotica.org.uk/search.php?what=0&special=viewed&query=&cat=15&show=25&tags=&effects=&gfxstyles=&collection_category=0&collection=&year=all&soundformat=&bitplanes=0&gfxsize=0&country=&more=show">Commodore Amiga</a>
communities, which were often poorly imitated by the underground communities on the PC.
</div>
<div class="row"></div><br>
<div class="six-item-grid">
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1971</em></h3></div>
	<div class="list-group">
	<a href="https://www.slate.com/articles/technology/the_spectator/2011/10/the_article_that_inspired_steve_jobs_secrets_of_the_little_blue_.html" class="list-group-item">
		<small>October</small> <h4>The Secrets of the Little Blue Box</h4> <p class="list-group-item-text">Esquire October 1971</p>
<small>
Ron Rosenbaum writes the first mainstream article on phone freaks, primarily kids who'd hack and experiment with the global telephone network.
<br>
The piece coins them as phone-<strong>phreaks</strong> and introduces the reader to the kids' use of <strong>pseudonyms</strong> or codenames within their regional <strong>groups</strong> of friends.
It gives an early example of <strong>social engineering</strong>, defines the community of phreakers as the phone-phreak <strong>underground</strong>, and mentions the newer trend of <strong>computer phreaking</strong>, which we call computer hacking today.
</small>
	</a>
	<a href="https://www.intel.com/content/www/us/en/history/museum-story-of-intel-4004.html" class="list-group-item">
		<small>November 15</small> <h4>The first microprocessor</h4> <p class="list-group-item-text">Intel 4004</p>
<small>
Intel advertises the first-to-market general-purpose programmable processor or microprocessor, the 4-bit Intel 4004
</small>
	</a>
	</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1972</em></h3></div>
	<div class="list-group">
	<a href="https://www.intel.com/content/www/us/en/history/virtual-vault/articles/the-8008.html" class="list-group-item">
		<small>April</small> <h4>The first 8-bit microprocessor</h4> <p class="list-group-item-text">Intel 8008</p>
<small>
Intel releases the world's first 8-bit microprocessor, the Intel 8008
</small>
	</a>
	<a href="http://explodingthephone.com" class="list-group-item">
		<small>Early 1972</small> <h4>Blue boxes</h4>
<small>
Inspired by The Secrets of the Little Blue Box article, Steve Wozniak and a teenage Steve Jobs team up to build and sell 40-100, Wozniak-designed blue boxes to the students of Berkeley University.
The devices allowed users to hack and manipulate the electromechanical machines that operated the national telephone network.
</small>
	</a>
	</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1974</em></h3></div>
	<div class="list-group">
	<a href="https://www.intel.com/content/www/us/en/history/virtual-vault/articles/the-8008.html" class="list-group-item">
		<small>April</small> <h4>The first CPU for microcomputers</h4> <p class="list-group-item-text">Intel 8080</p>
<small>
Intel releases the 8-bit 8080 CPU, its second but more successful 8-bit programmable microprocessor.
This CPU became the processing heart of the earliest popular microcomputers, the Altair 8800, the Sol-20 and the IMSAI.
</small>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1975</em></h3></div>
	<div class="list-group">
		<a href="https://americanhistory.si.edu/collections/search/object/nmah_334396" class="list-group-item">
		<small>January</small> <h4>The first popular microcomputer</h4> <p class="list-group-item-text">Altair 8800</p>
<small>The worlds first popular microcomputer appears on the front cover of Popular Electronics in the USA, the Altair 8800 by MITS running an Intel 8080 CPU.</small>
		</a>
		<a href="https://time.com/69316/basic/" class="list-group-item">
			<small>February</small> <h4>The first commercial microcomputer software</h4> <p class="list-group-item-text">Altair BASIC</p>
<small>
Paul Allen and Bill Gates program and sell Altair BASIC for the computer they first saw a month prior.
BASIC (Beginner's All-Purpose Symbolic Instruction Code) was a programming language conceived by John Kemeny and Thomas Jurtz of Dartmouth College in early 1964 to be as approachable as possible.
		</small></a>

		<a href="https://www.computerhistory.org/revolution/personal-computers/17/312/1138" class="list-group-item">
			<small>5 March</small> <h4>The first meeting of the Homebrew Computer Club</h4>
<small>While many technology clubs of this type for sharing ideas were common, this Silicon Valley, Bay Area group became famous for its numerous members who later became industry figures.</small>
</a>
	</div>

	<div class="panel-heading"><h3 class="panel-title"><em>1976</em></h3></div>
	<div class="list-group">
	<a href="https://archive.org/details/hcc0201/Homebrew.Computer.Club.Volume.02.Issue.01.Len.Shustek/page/n1/mode/2up" class="list-group-item">
		<small>January</small> <h4>Software piracy</h4> <p class="list-group-item-text">An Open Letter to Hobbyists</p>
		<small>Bill Gates of <em>Micro-Soft</em> writes a letter to the hobbyists of the Homebrew Computer Club requesting they stop stealing Altair BASIC.</small>
	</a>
	<a href="https://www.computerhistory.org/revolution/personal-computers/17/312/1132" class="list-group-item">
		<small>March</small> <h4>The first Apple computer</h4>
		<small>Steve Wozniak and Steve Jobs debuted the first Apple computer prototype at a meeting of the Homebrew Computer Club.</small>
	</a>
	<a href="https://landley.net/history/mirror/cpm/history.html" class="list-group-item">
		<h4>CP/M operating system</h4>
		<small>
Gary Kildall forms Digital Research to sell his hobbyist operating system, CP/M, for the Intel 8080.
Gary was an occasional consultant for Intel's microprocessor division, which gave him access to hardware and personnel.
CP/M became the first successful microcomputer operating system.
It dominated the remainder of the 1970s and is the default platform for most computers running an Intel 8080, 8085 or its compatible competitor, the Zilog Z-80.</small>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1978</em></h3></div>
	<div class="list-group">
	<a href="https://www.pcworld.com/article/535966/article-7512.html" class="list-group-item">
		<small>June</small> <h4>Intel 8086 CPU</h4>
		<small>
Intel releases the 16-bit programmable microprocessor, the Intel 8086, which is the beginning of the <strong>x86 architecture</strong>.
<br>
Unlike at the start of the decade when Intel broke new ground, this CPU design was a commercial response to market competition.
While code-compatible with the famous Intel 8080, this product failed to dominate in a market saturated with more affordable 8-bit hardware.
		</small>
	</a>
	</div>

	<div class="panel-heading"><h3 class="panel-title"><em>1979</em></h3></div>
	<div class="list-group">
	<a href="https://spectrum.ieee.org/chip-hall-of-fame-intel-8088-microprocessor" class="list-group-item">
		<small>June</small> <h4>Intel 8088 CPU</h4>
		<small>
Intel releases the lesser 16-bit microprocessor, the Intel 8088.
While fully compatible with the earlier Intel 8086 CPU, this model is intentionally "castrated" using an 8-bit external data bus.
The revision is an improvement for some buyers as it needs less expensive support chips on the mainboard and is compatible with the more readily available 8-bit hardware.
Software written for either CPU often gets quoted as 8088/86 compatible.
		</small>
	</a>
	<a href="https://thisdayintechhistory.com/06/18/microsoft-introduces-basic-for-8086/" class="list-group-item">
		<small>June 18</small> <h4>The first commercial software for x86</h4> <p class="list-group-item-text">Microsoft BASIC-86</p>
	</a>
	</div>

	<div class="panel-heading"><h3 class="panel-title"><em>1980</em></h3></div>
	<div class="list-group">
	<a href="https://www.1000bit.it/storia/perso/tim_paterson_e.asp" class="list-group-item">
		<small>August</small> <h4>The first operating system for x86</h4> <p class="list-group-item-text">Seattle Computer Products QDOS</p>
		<small>
Tim Paterson worked on a project at Seattle Computer Products to create an 8086 CPU plugin board for the S-100 bus standard.
Needing an operating system for the 16-bit Intel CPU, he programmed a half-complete, unauthorized clone of the CP/M operating system within four months.
He called it QDOS (Quick and Dirty OS), and it sold few copies.
		</small>
	</a>
	<a href="https://www.1000bit.it/storia/perso/tim_paterson_e.asp" class="list-group-item">
		<small>December</small> <h4>PC-DOS</h4>
		<small>
Seattle Computer Products sells 86-DOS, an almost finished update to QDOS.
It is available under an OEM license and sold to Microsoft for a flat fee.
Under a non-disclosure agreement with IBM, Microsoft rebrands it as PC-DOS on a non-exclusive, per-copy royalty agreement.
		</small>
	</a>
	</div>

</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1981</em></h3></div>
	<div class="list-group">
	<a href="https://www.ibm.com/ibm/history/exhibits/pc25/pc25_birth.html" class="list-group-item">
		<small>August 12</small> <h4>First IBM Personal Computer</h4> <p class="list-group-item-text">IBM PC 5150</p>
		<small>Built on the 4.77 MHz Intel 8088 microprocessor, 16KB of RAM and Microsoft's PC-DOS, this underpowered machine heralds the <strong>PC platform</strong>.</small>
	</a>
<div class="img-screenshot">
	<a title="Rama &amp; Musée Bolo, CC BY-SA 2.0 FR &lt;https://creativecommons.org/licenses/by-sa/2.0/fr/deed.en&gt;, via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:IBM_PC-IMG_7271_(transparent).png">
		<picture title="IBM PC 5150">
		<img width="640" height="416" src="/images/layout/640px-IBM_PC-IMG_7271_(transparent).png" alt="IBM PC 5150" class="img-rounded img-responsive">
		</picture>
	</a>
</div>
	<a href="https://www.pcjs.org/software/pcx86/game/microsoft/adventure/" class="list-group-item">
		<small>August</small><h4>First published PC game</h4><p class="list-group-item-text">IBM's Microsoft Adventure</p><small>A port of the text only Colossal Cave Adventure</small>
	</a>
	</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1982</em></h3></div>
	<div class="list-group">
	<a href="https://betawiki.net/wiki/MS-DOS_1.25" class="list-group-item">
		<small>August</small> <h4>Initial release of MS-DOS</h4>
		<small>Microsoft releases the first edition of MS-DOS v1.25, which is readily available to all OEM computer manufacturers. All prior releases were exclusive to IBM.</small>
	</a>
	<div class="list-group-item text-muted">
		The first set of games gets released on the PC platform that IBM does not publish<br>
		<small>Some early publishers include <a href="//s3data.computerhistory.org/brochures/broderbund.software.1982.102646180.pdf">Brøderbund</a>,
			<a href="//archive.org/details/avalon-hill-game-company-catal-fall-1982">The Avalon Hill Game Company</a>,
			<a href="//archive.org/details/strategic-simulations-inc-summer-1982-catalog/mode/2up">Strategic Simulations, Inc.</a>,
			<a href="//www.uvlist.net/companies/info/1023-Windmill+Software">Windmill Software</a>,
			<a href="//retro365.blog/2019/09/23/bits-from-my-personal-collection-the-original-ibm-pc-and-orion-software/">Orion Software</a> and
			<a href="//www.uvlist.net/companies/info/1029-Spinnaker+Software">Spinnaker Software</a></small>
	</div>
	</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1983</em></h3></div>
	<div class="list-group">
		<a href="/f/ab2edbc" class="list-group-item">
			<h3>Earliest cracked PC game</h3><p class="list-group-item-text">Atarisoft's Galaxian broken by Koyote Kid</p>
<div class="img-screenshot"><picture title="Galaxian broken by Koyote Kid">
	<source srcset="/images/#get(myapp).dirPreview#/cd3d1918-68cc-43fe-8b36-5b82e2776dae.webp" type="image/webp" class="img-rounded img-responsive">
	<img src="/images/#get(myapp).dirPreview#/cd3d1918-68cc-43fe-8b36-5b82e2776dae.png" alt="Galaxian broken screenshot" class="img-rounded img-responsive">
	</picture></div>
		</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1983</em></h3></div>
	<div class="list-group">

	<div class="list-group-item text-muted">
		Some major arcade and videogame publishers of the era release on the PC<br>
		<small><a href="//dfarq.homeip.net/atarisoft-if-you-cant-beat-em-join-em/">Atarisoft</a>,
			<a href="//www.uvlist.net/companies/info/243-Infocom">Infocom</a>,
			<a href="//www.resetera.com/threads/lets-look-back-at-game-company-datasoft.587093/##post-87110411">Datasoft</a>,
			<a href="//www.uvlist.net/companies/info/83-Mattel%20Electronics">Mattel</a> and
			<a href="//www.wired.com/story/sierra-online-ken-williams-interview-memoir/">Sierra On-Line</a></small>
	</div>
	<a href="https://medium.com/geekculture/the-1983-compaq-plus-portable-when-computers-were-glorious-9ddcb8ed9329" class="list-group-item">
		<small>March</small><h4>First popular IBM PC clone</h4> <span class="list-group-item-text">Compaq Portable</span>
	</a>
	<a href="https://github.com/microsoft/MS-DOS/blob/master/v2.0/source/ANSI.txt" class="list-group-item">
		<small>March</small><h4>PC/MS-DOS v2.0 with ANSI.SYS is released</h4><small>Includes for the first time a device driver to view ANSI text</small>
	</a>

	<a href="/f/a91c702" class="list-group-item">
		<small>May 12</small>
		<h3>Earliest unprotect text</h3><p class="list-group-item-text">Directions by Randy Day for unprotecting SPOC the Chess Master<br><code>SPOC.UNP</code></p>
		<small>Unprotects were text documents describing methods to remove software copy protection on floppy disks.
Many authors were legitimate owners who were frustrated that publishers would not permit them to create backup copies of their expensive but fragile 5¼-inch floppy disks for daily driving.</small>
	</a>
	<a href="https://www.poynter.org/reporting-editing/2014/today-in-media-history-in-1983-bill-gates-and-microsoft-introduced-windows/" class="list-group-item">
		<small>10 November</small><h4>Microsoft Windows annoucement</h4>
		<small>In hindsight, this premature announcement aims to keep Microsoft customers from jumping to competitor graphical user interface software.</small>
	</a>
	</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1984</em></h3></div>
	<div class="list-group">
	<div class="list-group-item text-muted">
		<small>
			<a href="//www.polygon.com/a/how-ea-lost-its-soul/">Electronic Arts</a>,
			<a href="//www.ign.com/articles/2010/10/01/the-history-of-activision">Activision</a>,
			<a href="//segaretro.org/IBM_PC">Sega</a> and
			<a href="//corporate-ient.com/microprose/">MicroProse Software (Sid Meier)</a> publish on the platform.</small>
	</div>
	<a href="http://www.sierrahelp.com/Documents/Manuals/Kings_Quest_1_IBM_-_Manual.pdf" class="list-group-item">
		<small>August</small><h4>First 16 color PC game</h4><p class="list-group-item-text">IBM's Kings's Quest</p><small>For the IBM PCjr, a short-lived PC line with custom hardware</small>
	</a>
	<a href="/f/ae2da98" class="list-group-item">
		<small>October 17</small><h3>Earliest information text</h3><p class="list-group-item-text">Zorktools 1.0 <small>(for Infocom game titles)</small> by Software Pirates Inc</p>
		<small>Early releases rarely included accompanying text files unless they were complicated tools or software utilities.</small>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1984</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>October</small><h4>EGA graphics standard</h4></div>
	<a href="https://www.pcjs.org/software/pcx86/demo/ibm/ega/" class="list-group-item">
		<h4>Earliest demonstration on the PC</h4><p class="list-group-item-text">Fantasy Land EGA Demo by IBM</p>
	</a>
	<div class="list-group-item"><h3>Earliest PC groups</h3>
	<div class="list-group">
		<a href="/g/against-software-protection" class="list-group-item">
			<h4>Against Software Protection <small>(ASP)</small></h4>
		</a>
		<a href="/g/software-pirates-inc" class="list-group-item">
			<h4>Software Pirates Inc <small>(SPi)</small></h4>
		</a>
	</div>
	</div>
</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1985</em></h3></div>
	<div class="list-group">
	<a href="/f/aa2be75" class="list-group-item">
		<small>May 26</small><h3>Earliest text loader</h3><p class="list-group-item-text">Bally Midway's Spy Hunter by Imperial Warlords</p>
		<small>Text loaders and ANSI art offer similar results but are different in execution.
Text loaders are binary programs that display text mode characters and colors.
ANSI text required the ANSI.SYS device driver included in PC/MS-DOS 2+ to convert plain text files into onscreen animation and color.</small>
	<div class="img-screenshot"><picture title="Spy Hunder by Imperial Warlords">
	<source width="640" height="350" srcset="/images/#get(myapp).dirPreview#/ee246fa7-0aff-4644-a5b0-f564cebc3961.webp" type="image/webp" class="img-rounded img-responsive">
	<img width="640" height="350" src="/images/#get(myapp).dirPreview#/ee246fa7-0aff-4644-a5b0-f564cebc3961.png" alt="Spy Hunder text title" class="img-rounded img-responsive">
	</picture></div>
</a>
	<a href="https://www.theverge.com/2012/11/20/3671922/windows-1-0-microsoft-history-desktop-gracefully-failed" class="list-group-item">
		<small>20 November</small><h4>Initial release of Microsoft Windows</h4>
<small>
Expensive hardware requirements and a lack of purpose lead to lackluster sales.
It will take a decade and multiple releases before Windows becomes dominant.
</small>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1986</em></h3></div>
	<div class="list-group">
	<a href="/f/a61db76" class="list-group-item">
		<h3>Earliest "DOX"</h3><p class="list-group-item-text">Dam Buster* Documentation by Apocalypse BBS
		<br><code>DAMBUST1.DOC</code></p>
		<small>DOX is an abbreviation for documentation, which are text files that provide instructions on playing more complicated games.
These titles often relied on printed instruction manuals included in the purchased game box to be playable.</small>
<br><small>*Accolade's The Dam Busters</small>
	<div class="img-screenshot"><picture title="Dam Buster documentation">
	<img width="640" height="350" src="/images/#get(myapp).dirThumb400#/a40b90a5-ebf5-448e-8d3f-fffc77b8a47a.png" alt="Dam Buster documentation" class="img-rounded img-responsive">
	</picture></div>
	</a>
	<div class="list-group-item">
		<h4>IBM PC clone sales pickup in Europe</h4>
		<div class="list-group">
			<a href="//www.dosdays.co.uk/computers/Olivetti%20M24/olivetti_m24.php" class="list-group-item">
				Olivetti M24
			</a>
			<a href="//www.dosdays.co.uk/computers/Amstrad%20PC1000/amstrad_pc1000.php" class="list-group-item">
				Amstrad PC1512
			</a>
		</div>
	</div>
	<a href="https://www.mobygames.com/game/dos/mean-18/" class="list-group-item">
		<small>March</small><h4>First 16 color EGA game</h4><p class="list-group-item-text">Accolade's Mean 18</p>
	</a>

</div></div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1986</em></h3></div>
	<div class="list-group">

	<div class="list-group-item"><small>June</small><h3>Earliest PC loaders</h3>
<small>Loaders were named as they would be the first thing to display each time a cracked game is run.
These screens were static images in the early days and sometimes contained ripped screens from other games. Some users found these annoying and a cause of file bloat.</small>
	<div class="list-group">
		<a href="/f/b44cac" class="list-group-item">
			<h4>Atarisoft's Gremlins by Mr. Turbo</h4>
		</a>
		<a href="/f/a83eec" class="list-group-item">
			<h4>Exodus: Ultima 3 by ESP Pirates</h4>
		</a>
		<a href="/f/b33404" class="list-group-item">
			<h4>Sega's Frogger II by SPI <small>(Feb 1987)</small></h4>
		<div class="img-screenshot"><picture title="Frogger II by Software Pirates, Inc.">
		<source width="640" height="400" srcset="/images/#get(myapp).dirPreview#/31f67d26-6549-4066-bf0c-291d33dff5c3.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="640" height="400" src="/images/#get(myapp).dirPreview#/31f67d26-6549-4066-bf0c-291d33dff5c3.png" alt="Frogger II title" class="img-rounded img-responsive">
		</picture></div></a>
	</div>
	</div>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/five-o" class="list-group-item">
			<h4>Five-O</h4>
		</a>
		<a href="/g/boys-from-company-c" class="list-group-item">
			<h4 class="text-right">Boys from Company C <small>(BCC)</small> <small>1988</small> ↩</h4>
		</a>
		<a href="/g/esp-pirates" class="list-group-item">
			<h4>ESP Pirates</h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1987</em></h3></div>
	<div class="list-group">
	<a href="/f/ac21460" class="list-group-item">
		<small>June 22</small><h3>Earliest PC demo</h3><p class="list-group-item-text">3 Dimensional EGA Demonstration</p>
		<small>A demo and a piece of software created purely for aesthetics, usually to show art or animation.
While earlier demonstration software existed on the PC, they were intended for retailers or distributors and usually not given to the public.</small>
	</a>
	<div class="list-group-item"><h4>AdLib audio standard</h4><h4>VGA graphics standard</h4></div>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/boys-from-company-c" class="list-group-item">
			<h4>Boys from Company C <small>(BCC)</small></h4>
		</a>
		<a href="/g/the-firm" class="list-group-item">
			<h4 class="text-right">The Firm <small>1989</small> ↩</h4>
		</a>
		<a href="/g/ptl-club" class="list-group-item">
			<h4>The PTL Club</h4>
		<div class="img-screenshot"><picture title="Jungle Hunt by The PTL Club">
		<source width="320" height="200" srcset="/images/#get(myapp).dirPreview#/c8e21ea0-2f54-11e0-8827-cc1607e15609.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="320" height="200" src="/images/#get(myapp).dirPreview#/c8e21ea0-2f54-11e0-8827-cc1607e15609.png" alt="Jungle Hunt title" class="img-rounded img-responsive">
		</picture></div>
		</a>
		<a href="/g/triad" class="list-group-item">
			<h4 class="text-right">Triad <small>1989</small> ↩</h4>
		</a>
		<a href="/g/canadian-pirates-inc" class="list-group-item">
			<h4>Canadian Pirates Inc <small>CPI</small></h4>
		</a>
		<a href="/g/kgb" class="list-group-item">
			<h4>KGB</h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1988</em></h3></div>
	<div class="list-group">
	<a href="https://forum.winworldpc.com/discussion/comment/174818/##Comment_174818" class="list-group-item">
		<small>March</small><h4>First 32 color VGA game</h4><p class="list-group-item-text">Arcadia's Rockford: The Arcade Game</p>
	</a>
	<a href="/f/b844ef" class="list-group-item">
		<small>April 4</small><h3>Earliest standalone BBS ad</h3><p class="list-group-item-text">Swashbucklers II BBS <code>README.!!!</code></p>
	</a>
	<a href="/f/a53720" class="list-group-item">
		<small>June</small><h3>Earliest ANSI ad</h3><p class="list-group-item-text">Mindscape's Paperboy by BSP <code>SCREEN.ANS</code></p>
	</a>
	<a href="/f/ad417f" class="list-group-item">
		<small>July 30</small><h3>Earliest NFO-like document</h3><p class="list-group-item-text">KOEI's Romance of the Three Kingdoms by BSP</p>
	</a>
	<a href="/f/ab3dc1" class="list-group-item">
		<small>October 6</small><h3>Earliest ASCII art</h3><p class="list-group-item-text">MicroIllusions Fire Power by $print <code>$PRINT.TXT</code></p>
		<div class="img-screenshot"><picture title="Fire Power text file by $print">
		<source width="640" height="336" srcset="/images/#get(myapp).dirPreview#/c8eed455-2f54-11e0-8827-cc1607e15609.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="640" height="336" src="/images/#get(myapp).dirPreview#/c8eed455-2f54-11e0-8827-cc1607e15609.png" alt="Fire Power by $print" class="img-rounded img-responsive">
		</picture></div>
	</a>
	<a href="/f/aa356d" class="list-group-item">
		<small>November 25</small><h3>Earliest scene drama</h3><p class="list-group-item-text">TNWC accusing PTL of stealing a release <code>README.NOW</code>
		<br><small><q>Well unlike PTL I won't sacrifice some game code to put up a fancy title screen for the group that released this (TNWC)</q></small></p>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1988</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/the-grand-council" class="list-group-item">
			<p>Dude Man Dude HQ BBS <small>(313)</small></p>
			<h4>↪ The Grand Council <small>(TGC)</small></h4>
		</a>
		<a href="/g/the-north-west-connection" class="list-group-item">
			<p>The Neutral Zone BBS <small>(206)</small></p>
			<h4>↪ North West Connection <small>(TNWC)</small></h4>
		</a>
		<a href="/g/sprint" class="list-group-item">
			<h4>Sprint</h4>
		</a>
		<a href="/g/triad" class="list-group-item">
			<h4 class="text-right">Triad <small>1989</small> ↩</h4>
		</a>
		<a href="/g/bentley-sidwell-productions" class="list-group-item">
			<h4>Bentley Sidwell Productions <small>(BSP)</small></h4>
		</a>
		<a href="/g/the-firm" class="list-group-item">
			<h4 class="text-right">The Firm <small>1989</small> ↩</h4>
			<div class="img-screenshot"><picture title="The Firm EGA loader screen">
			<source width="640" height="350" srcset="/images/#get(myapp).dirPreview#/c8e9efe4-2f54-11e0-8827-cc1607e15609.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="640" height="350" src="/images/#get(myapp).dirPreview#/c8e9efe4-2f54-11e0-8827-cc1607e15609.png" alt="The Firm EGA loader" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/crackers-in-action" class="list-group-item">
			<h4>Crackers in Action <small>(CIA)</small></h4>
			<div class="img-screenshot"><picture title="Crackers In Action cracktro">
			<source width="320" height="200" srcset="/images/#get(myapp).dirPreview#/c8d85c69-2f54-11e0-8827-cc1607e15609.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="320" height="200" src="/images/#get(myapp).dirPreview#/c8d85c69-2f54-11e0-8827-cc1607e15609.png" alt="CIA cracktro screenshot" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/the-sysops-association-network" class="list-group-item">
			<h4>The Sysops Association Network <small>(TSAN)</small></h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1989</em></h3></div>
	<div class="list-group">
	<a href="http://www.mobygames.com/game/dos/688-attack-sub" class="list-group-item">
		<small>March</small><h4>First 256 color VGA game</h4><p class="list-group-item-text">Electronic Art's 688 Attack Sub</p>
	</a>
	<a href="/f/ad21da8" class="list-group-item">
		<small>March</small><h3>Earliest BBS ANSI loader</h3><p class="list-group-item-text">Rogues Gallery BBS in Long Island, NY <small>(516)</small></p>
		<div class="img-screenshot"><picture title="Rogues Gallery BBS ad">
		<source width="720" height="540" srcset="/images/#get(myapp).dirPreview#/fb0ad430-85c4-45e9-af39-5b56d42c706b.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="720" height="540" src="/images/#get(myapp).dirPreview#/fb0ad430-85c4-45e9-af39-5b56d42c706b.png" alt="Rogues Gallery ad" class="img-rounded img-responsive">
		</picture></div>
	</a>
	<a href="/f/ad3093" class="list-group-item">
		<small>April</small><h3>Earliest PC intro<sup> 7</sup></h3><p class="list-group-item-text">First intro by Sorcerers</p>
		<div class="img-screenshot"><picture title="Summer Holiday intro by Sorcerers">
		<source width="640" height="400" srcset="/images/#get(myapp).dirPreview#/2f21e21d-49e4-41c3-80c9-63fd3fbb4dcf.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="640" height="400" src="/images/#get(myapp).dirPreview#/2f21e21d-49e4-41c3-80c9-63fd3fbb4dcf.png" alt="Summer Holiday intro" class="img-rounded img-responsive">
		</picture></div>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1989</em></h3></div>
	<div class="list-group">
	<a href="/f/b83fd7" class="list-group-item">
		<small>April 29</small><h3>Earliest PC cracktro</h3><p class="list-group-item-text">Mandarin Software's Lombard RAC Rally by Future Brain Inc (FBi)</p>
		<small>An intro or cracktro are small, usually short, demo programs designed to display text with art or animation.
Cracktros specifically promote pirated releases or groups, while intros do not.</small>
	</a>
	<a href="/f/9f5c5" class="list-group-item">
		<small>June 1</small><h4>First issue of Pirate magazine</h4><p class="list-group-item-text">The earliest magazine for the PC scene</p>
	</a>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/the-underground-council" class="list-group-item">
			<h4>The Underground Council <small>(UGC)</small></h4>
		</a>
		<a href="/g/triad" class="list-group-item">
			<h4 class="text-right">Triad <small>1989</small> ↩</h4>
		</a>
		<a href="/g/norwegian-cracking-company" class="list-group-item">
			<h4>Norwegian Cracking Company <small>(NCC)</small></h4>
		</a>
		<a href="/g/international-network-of-crackers" class="list-group-item">
			<h4 class="text-right"><small>1990</small> ↩<br>International Network of Crackers</h4>
		</a>
		<a href="/g/pirates-sick-of-initials" class="list-group-item">
			<h4>Pirates Sick of Initials <small>(PSi)</small></h4>
		</a>
		<a href="/g/triad" class="list-group-item">
			<h4 class="text-right">Triad <small>1990</small> ↩</h4>
		</a>
		<a href="/g/future-brain-inc" class="list-group-item">
			<h4>Future Brain Inc <small>(FBI)</small></h4>
			<div class="img-screenshot"><picture title="Future Brain Inc - The Cycles cracktro">
			<source width="320" height="200" srcset="/images/#get(myapp).dirPreview#/c8d8a620-2f54-11e0-8827-cc1607e15609.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="320" height="200" src="/images/#get(myapp).dirPreview#/c8d8a620-2f54-11e0-8827-cc1607e15609.png" alt="FBI The Cycles cracktro" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/american-pirate-industries" class="list-group-item">
			<h4>American Pirate Industries <small>API</small></h4>
		</a>
		<a href="/g/pirate" class="list-group-item">
			<h4>Pirate</h4>
		</a>
		<a href="/g/international-network-of-crackers" class="list-group-item">
			<h4>International Network of Crackers</h4>
		</a>
		<a href="/g/miami-cracking-machine" class="list-group-item">
			<h4 class="text-center">Miami Cracking Machine <small>(MCM)</small> ⤴</h4>
		</a>
		<a href="/g/new-york-crackers" class="list-group-item">
			<h4 class="text-center">New York Crackers <small>(NYC)</small>+<small>(ECA)</small> ⤴</h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1990</em></h3></div>
	<div class="list-group">
	<a href="/f/ab3945" class="list-group-item">
		<small>Jan 23</small><h4>Use of the ".NFO" file extension</h4><p class="list-group-item-text">Origin System's Knights of Legend by The Humble Guys <code>KNIGHTS.NFO</code></p>
<small>THG cracker Fabulous Furlough maintains Bubble Bobble was the first THG release that used the .NFO file extension.
The date modified timestamps in our copy may be incorrect.
<br>
<q>It happened like this, I'd just used "Unguard" to crack the SuperLock off of Bubble Bobble, and I said "I need some file to put the info about the crack in. Hmmm.. Info, NFO!", and that was it.</q></small>
	</a>
	<a href="/f/ab25f0e" class="list-group-item">
		<small>December 2</small><h3>Earliest PC cracktro with music</h3><p class="list-group-item-text">MicroProse's M1 Tank Platoon by The Cat</p>
		<small>In this example, the term "music" is a loose definition that relies on the horrible internal PC speaker.
By this era, many commercial games supported good audio hardware addons such as the AdLib, MT-32, or Covox.</small>
	<div class="img-screenshot"><picture title="M1 Tank Platroon by The Cat">
	<source width="958" height="719" srcset="/images/#get(myapp).dirPreview#/8a10e5e1-cf7a-4491-b056-897c04125412.webp" type="image/webp" class="img-rounded img-responsive">
	<img width="958" height="719" src="/images/#get(myapp).dirPreview#/8a10e5e1-cf7a-4491-b056-897c04125412.png" alt="M1 Tank Platroon by The Cat" class="img-rounded img-responsive">
	</picture></div>
	</a>
	<div class="list-group-item"><h4>Sound Blaster audio standard</h4></div>
	<a href="https://archive.org/details/vgmuseum_sierra_sierra-90catalog-alt3/page/n21" class="list-group-item">
		<small>Winter</small><h4>First enchanced PC game on CD-ROM</h4><p class="list-group-item-text">Sierra On-Line's Mixed-Up Mother Goose</p>
	</a>
	<div class="img-screenshot"><picture title="Hamburger Heaven BBS menu">
	<source width="640" height="416" srcset="/images/#get(myapp).dirPreview#/41adc216-1a09-4eec-94c0-246d8043e8ef.webp" type="image/webp" class="img-rounded img-responsive">
	<img width="640" height="416" src="/images/#get(myapp).dirPreview#/41adc216-1a09-4eec-94c0-246d8043e8ef.png" alt="Hamburger Heaven BBS menu" class="img-rounded img-responsive">
	</picture></div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1990</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/acid-productions" class="list-group-item">
			<h4>ANSI Creators In Demand <small>(ACiD)</small></h4>
		</a>
		<a href="/g/aces-of-ansi-art" class="list-group-item">
			<h4 class="text-center">Aces of ANSI Art <small>(AAA)</small> ⤴</h4>
		</a>
		<a href="/g/bitchin-ansi-design" class="list-group-item">
			<h4>Bitchin Ansi Design <small>(BAD)</small></h4>
		</a>
		<a href="/g/damn-excellent-ansi-design" class="list-group-item">
			<h4>Damn Excellent ANSI Design <small>(DEAD)</small></h4>
		</a>
		<a href="/g/future-crew" class="list-group-item">
			<h4>Future Crew</h4>
			<div class="img-screenshot"><picture title="The Future Crew Slideshow I">
			<source width="640" height="480" srcset="/images/#get(myapp).dirPreview#/d74ed150-f512-423d-8234-166a86cd95ad.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="640" height="480" src="/images/#get(myapp).dirPreview#/d74ed150-f512-423d-8234-166a86cd95ad.png" alt="Future Crew Slideshow I" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/the-humble-guys" class="list-group-item">
			<h4>The Humble Guys <small>(THG)</small></h4>
		</a>
		<a href="/g/united-software-association" class="list-group-item">
			<h4 class="text-right">United Software Association <small>1991</small> ↩</h4>
		</a>
		<a href="/g/thg-fx" class="list-group-item">
			<h4 class="text-right">THG-FX <small>1991</small> ↩</h4>
		</a>
		<a href="/g/nokturnal-trading-alliance" class="list-group-item">
			<h4 class="text-right">Nokturnal Trading Alliance <small>(NTA) 1991</small> ⇄</h4>
		</a>
		<a href="/g/the-original-funny-guys" class="list-group-item">
			<h4 class="text-right">The Original Funny Guys <small>1992</small> ↩</h4>
		</a>
		<a href="/g/lamers-of-power" class="list-group-item">
			<h4 class="text-right">Lamers of Power <small>1992</small> ↩</h4>
		</a>
		<a href="/g/national-elite-underground-alliance" class="list-group-item">
			<h4>National Elite Underground Alliance <small>(NEUA)</small></h4>
		</a>
		<a href="/g/software-chronicles-digest" class="list-group-item">
			<h4>Software Chronicles Digest <small>(SCD)</small></h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1990</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>More notable groups</small>
	<div class="list-group">
		<a href="/g/razor-1911" class="list-group-item">
			<h4>Razor 1911 <small>(RZR)</small></h4>
			<div class="img-screenshot"><picture title="Razor / Skillion Silent Shadow cracktro">
			<source width="640" height="400" srcset="/images/#get(myapp).dirPreview#/c8d9db5c-2f54-11e0-8827-cc1607e15609.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="640" height="400" src="/images/#get(myapp).dirPreview#/c8d9db5c-2f54-11e0-8827-cc1607e15609.png" alt="Razor / Skillion loader" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/skillion" class="list-group-item">
			<h4 class="text-center">Skillion <small>(SKN)</small> ⤴</h4>
		</a>
		<a href="/g/razordox" class="list-group-item">
			<h4 class="text-right">Razordox <small>1992</small> ↩</h4>
		</a>
		<a href="/g/rom-1911" class="list-group-item">
			<h4 class="text-right">ROM1911 <small>1994</small> ↩</h4>
		</a>
		<a href="/g/razor-1911-cd-division" class="list-group-item">
			<h4 class="text-right">Razor 1911 CD Division <small>1995</small> ↩</h4>
		</a>
		<a href="/g/razor-1911-demo" class="list-group-item">
			<h4 class="text-right">Razor Demo <small>1999</small> ↩</h4>
		</a>
		<a href="/g/public-enemy" class="list-group-item">
			<h4>Public Enemy <small>(PE)</small></h4>
		</a>
		<a href="/g/red-sector-inc" class="list-group-item">
			<h4 class="text-center">Red Sector Inc. <small>(RSI)</small> ⤴</h4>
		</a>
		<a href="/g/tristar-ampersand-red-sector-inc" class="list-group-item">
			<h4 class="text-right">Tristar &amp; Red Sector Inc. <small>(TRSi)</small> ↩</h4>
		</a>
		<a href="/g/the-dream-team" class="list-group-item">
			<h4 class="text-center">The Dream Team <small>(TRSi+TDT) 1991</small> ⤴</h4>
		</a>
		<a href="/g/skid-row" class="list-group-item">
			<h4 class="text-center">Skid Row <small>(TDT+SR) 1991</small> ⤴</h4>
		</a>
		<div class="img-screenshot"><picture title="PE TDT TRSi - The New PC Co-Operation!">
		<source width="640" height="480" srcset="/images/#get(myapp).dirPreview#/0f03674d-d1e3-4608-8f8c-f6bf92d0b902.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="640" height="480" src="/images/#get(myapp).dirPreview#/0f03674d-d1e3-4608-8f8c-f6bf92d0b902.png" alt="PC co-operation cracktro" class="img-rounded img-responsive">
		</picture></div>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1991</em></h3></div>
	<div class="list-group">
	<a href="/f/a41dcd9" class="list-group-item">
		<small>March</small><h4>Earliest BBS VGA loader</h4><p class="list-group-item-text">XTC Systems BBS</p>
	</a>
	<a href="/f/b249b1" class="list-group-item">
		<small>April 12</small><h3>Earliest contemporary cracktro</h3>
		<p class="list-group-item-text">Blues Brothers* by The Dream Team, Tristar & Red Sector Inc. <small> (TDT/TRSi)</small></p>
		<br>
		<small>Programmed by Hard Core, it's the first PC cracktro with listenable music and a modern VGA aesthetic that could hold its own with cracktros on other systems.</small>
		<br>
		<small>*Titus Software's The Blues Brothers.</small>
		<div class="img-screenshot"><picture title="Blues Brothers cracktro from The Dream Team">
		<source width="639" height="399" srcset="/images/#get(myapp).dirPreview#/57d5e22c-a4fe-4f5b-b5ae-a5fa4ddab0e4.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="639" height="399" src="/images/#get(myapp).dirPreview#/57d5e22c-a4fe-4f5b-b5ae-a5fa4ddab0e4.png" alt="Blues Brothers cracktro" class="img-rounded img-responsive">
		</picture></div>
	</a>
	<a href="/f/ae24168" class="list-group-item">
		<small>July</small><h3>Earliest contemporary demo</h3><p class="list-group-item-text">Mental Surgery by Future Crew <small>(FC)</small></p>
	</a>
	<a href="/f/b11acdf" class="list-group-item">
		<small>October 21</small><h3>Earliest elite BBStro</h3><p class="list-group-item-text">Splatterhouse BBS</p>
	</a>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/insane-creators-enterprise" class="list-group-item">
			<h4>Insane Creators Enterprise <small>(iCE)</small></h4>
		</a>
		<a href="/g/licensed-to-draw" class="list-group-item">
			<h4>Licensed to Draw <small>(LTD)</small></h4>
		</a>
		<a href="/g/mirage" class="list-group-item">
			<h4 class="text-right">Mirage <small>1992</small> ↩</h4>
		</a>
		<a href="/g/graphics-rendered-in-magnificence" class="list-group-item">
			<h4>Graphics Rendered in Magnificence <small>(GRiM)</small></h4>
		</a>
		<a href="/g/relentless-pursuit-of-magnificence" class="list-group-item">
			<h4>Relentless Pursuit of Magnificence <small>(RPM)</small></h4>
		</a>
		<a href="/g/silicon-dream-artists" class="list-group-item">
			<h4>Silicon Dream Artists <small>(SDA)</small></h4>
		</a>
		<a href="/g/ultra-tech" class="list-group-item">
			<h4>Ultra Tech</h4>
		</a>
		<a href="/g/pirates-with-attitude" class="list-group-item">
			<h4>Pirates With Attitude <small>(PWA)</small></h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1991</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>More notable groups</small>
	<div class="list-group">
		<a href="/g/fairlight" class="list-group-item">
			<h4>Fairlight <small>(FTL)</small></h4>
		</a>
		<a href="/g/united-software-association" class="list-group-item">
			<h4 class="text-center">United Software Association <small>(USA)</small> ⤴</h4>
		</a>
		<a href="/g/fairlight-dox" class="list-group-item">
			<h4 class="text-right">Fairlight DOX ↩</h4>
		</a>
		<a href="/g/artists-in-revolt" class="list-group-item">
			<h4 class="text-right">Artists In Revolt <small>(AiR) 1992</small> ↩</h4>
		</a>
		<a href="/g/romlight" class="list-group-item">
			<h4 class="text-right">Romlight <small>1996</small> ↩</h4>
		</a>
	</div>
	</div>
</div>
<div class="panel-heading"><h3 class="panel-title"><em>1992</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<div class="img-screenshot"><picture title="Hybrid ANSI logo by Superior Art Creations">
		<source width="640" height="352" srcset="/images/#get(myapp).dirPreview#/89dfd9c4-e5b0-4b1b-bc9c-ff1249b95c83.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="640" height="352" src="/images/#get(myapp).dirPreview#/89dfd9c4-e5b0-4b1b-bc9c-ff1249b95c83.png" alt="Hybrid logo" class="img-rounded img-responsive">
		</picture></div>
		<a href="/g/pyradical" class="list-group-item">
			<h4>Pyradical</h4>
		</a>
		<a href="/g/hybrid" class="list-group-item">
			<h4 class="text-center">↪ Hybrid <small>1993</small></h4>
		</a>
		<a href="/g/eclipse" class="list-group-item">
			<h4 class="text-center">↪ Eclipse <small>1995</small></h4>
		</a>
		<a href="/f/a53f3c" class="list-group-item">
			<h4 class="text-center">↪ Zeus <small>1996</small></h4>
		</a>
		<a href="/g/paradigm" class="list-group-item">
			<h4 class="text-center">↪ Paradigm <small>1996</small></h4>
		</a>
		<a href="/g/superior-art-creations" class="list-group-item">
			<h4>Superior Art Creations <small>(SAC)</small></h4>
		</a>
		<a href="/g/pirates-analyze-warez" class="list-group-item">
			<h4>Pirates Analyze Warez <small>(PWA)</small></h4>
		</a>
		<a href="/g/the-one-and-only" class="list-group-item">
			<h4>The One And Only <small>(TOAO)</small></h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1993</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/the-untouchables" class="list-group-item">
			<h4>The Untouchables <small>(UNT)</small></h4>
		</a>
		<a href="/g/uniq" class="list-group-item">
			<h4 class="text-center">UNiQ ⤴</h4>
		</a>
		<a href="/g/xap" class="list-group-item">
			<h4 class="text-center">XAP ⤴</h4>
		</a>
		<a href="/g/rise-in-superior-couriering" class="list-group-item">
			<h4>Rise in Superior Couriering <small>(RiSC)</small></h4>
		</a>
		<a href="/g/risciso" class="list-group-item">
			<h4 class="text-right">RiSCiSO <small>1998</small> ↩</h4>
		</a>
		<a href="/g/pentagram" class="list-group-item">
			<h4>Pentagram <small>(PTG)</small></h4>
		</a>
		<a href="/g/legend" class="list-group-item">
			<h4 class="text-center">Legend ⤴</h4>
		</a>
		<a href="/g/genesis" class="list-group-item">
			<h4 class="text-right">Genesis <small>1994</small> ↩</h4>
		</a>
		<a href="/g/tdu_jam" class="list-group-item">
			<h4 class="text-right">TDU-Jam <small>1994</small> ↩</h4>
		</a>
		<a href="/g/digital-underground-bbs" class="list-group-item">
			<h4 class="text-center"><small>(TDU) 1990</small> ⤴<br>The Digital Underground BBS</h4>
		</a>
		<a href="/g/drink-or-die" class="list-group-item">
			<h4>Drink or Die <small>(DOD)</small></h4>
		</a>
		<a href="/g/paradox" class="list-group-item">
			<h4>Paradox <small>(PDX)</small></h4>
			<div class="img-screenshot"><picture title="Paradox Dyno Quest cracktro">
			<source width="640" height="480" srcset="/images/#get(myapp).dirPreview#/871fb353-2ba2-4a6f-a04a-65baceebbc8b.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="640" height="480" src="/images/#get(myapp).dirPreview#/871fb353-2ba2-4a6f-a04a-65baceebbc8b.png" alt="Paradox Dyno Quest cracktro" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/scoopex" class="list-group-item">
			<h4>Scoopex</h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1994</em></h3></div>
	<div class="list-group">
	<a href="/f/ab3e0b" class="list-group-item">
		<small>November 17</small><h3>Earliest CD image release</h3>
		<p class="list-group-item-text">Slob Zone by ROM 1911<br>
		<small>Slob Zone was later published as Slob Zone 3D and Deep River's H.U.R.L.</small></p>
	</a>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/request-to-send" class="list-group-item">
			<h4>Request to Send <small>(RTS)</small></h4>
		</a>
	</div>
	</div>
</div>
<div class="panel-heading"><h3 class="panel-title"><em>1995</em></h3></div>
	<div class="list-group">
	<a href="/f/a938e5" class="list-group-item">
		<small>June 4</small><h3>Earliest CD-RIP release</h3>
		<p class="list-group-item-text">Interplay's Virtual Pool CD-Rip by Hybrid</p>
		<small>Due to the potential size of programs distributed on CDs and the high cost of low-capacity hard drives, the sharing of CD games was not desirable.
By mid-1995, some groups started to "rip" out subjective fluff such as intro animations and redistribute the rest of the incomplete but playable game as a "CD-RIP."</small>
	</a>

	<a href="/f/a8177" class="list-group-item">
		<small>Early August</small><h4>Windows 95 warez release</h4>
		<small>Drink or Die became infamous for releasing the to warez scene, a copy of the CD media for the box retail edition of Windows 95, two weeks before the official worldwide release.
The release highlighted a significant problem for software and game publishers: some company employees were either members of these warez groups or receiving kickbacks.
<hr>
<q>Another thing that may raise some questions is that, when you
       are in MS-DOS-SHELL, and you type 'ver', you will see Windows 95.
       [Version 4.00.950] This does not mean Beta 950, this, in fact
       (<em>coming directly from my supplier's mouth at MS</em>*) means that this is
       version 4.0 -ergo- Windows '95.</q>
	   <br>* Microsoft
</small>
	</a>
</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1995</em></h3></div>
	<div class="list-group">
	<a href="https://www.theverge.com/21398999/windows-95-anniversary-release-date-history" class="list-group-item">
		<small>24 August</small><h4>Windows 95 release</h4>
		<small>Microsoft's biggest and most hyped mainstream product release. It was hugely successful in the market and began the transition away from PC/MS-DOS.</small>
		<div class="img-screenshot"><picture title="Windows 95 startup">
		<img width="640" height="480" src="/images/layout/windows-95-startup.png" alt="Windows 95 startup" class="img-rounded img-responsive">
		</picture></div>
	</a>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/hoodlum" class="list-group-item">
			<h4>Hoodlum <small>(HLM)</small></h4>
			<div class="img-screenshot"><picture title="Hoodlum, World Class Rugby 95 cracktro">
			<source width="640" height="480" srcset="/images/#get(myapp).dirPreview#/0eef151c-238c-4a3d-834c-0ed9b816a253.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="640" height="480" src="/images/#get(myapp).dirPreview#/0eef151c-238c-4a3d-834c-0ed9b816a253.png" alt="Hoodlum cracktro" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/prestige" class="list-group-item">
			<h4>Prestige <small>(PSG)</small></h4>
		</a>
		<a href="/g/class" class="list-group-item">
			<h4 class="text-right">Class <small>1996</small> ↩</h4>
		</a>
		<a href="/g/the-week-in-warez" class="list-group-item">
			<h4>The Week In Warez <small>(WWN)</small></h4>
		</a>
		<a href="/g/inquisition" class="list-group-item">
			<h4 class="text-right">Inquisition <small>(INQ)</small> ↩</h4>
		</a>
		<a href="/g/the-naked-truth-magazine" class="list-group-item">
			<h4>The Naked Truth Magazine <small>(NTM)</small></h4>
		</a>
		<a href="/g/reality-check-network" class="list-group-item">
			<h4>Reality Check Network <small>(RCN)</small></h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1996</em></h3></div>
	<div class="list-group">
	<a href="/f/a42df1" class="list-group-item">
		<small>January</small><h3>Group merchandise</h3><p class="list-group-item-text">Razor 1911 - Tenth Anniversary CD-ROM</p>
		<div class="img-screenshot"><picture title="Razor 1911 Volume 1 CD-ROM">
		<source width="766" height="804" srcset="/images/#get(myapp).dirPreview#/b73aa2e5-3a41-486c-8cb8-5585776b2ec1.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="766" height="804" src="/images/#get(myapp).dirPreview#/b73aa2e5-3a41-486c-8cb8-5585776b2ec1.png" alt="Paradigm cracktro" class="img-rounded img-responsive">
		</picture></div>
	</a>
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/standards-of-piracy-association" class="list-group-item">
			<h4>Standards Of Piracy Association <small>(SPA)</small></h4>
		</a>
		<a href="/g/the-faction" class="list-group-item">
			<h4 class="text-center">↪ The Faction <small>1998</small></h4>
		</a>
		<a href="/g/network-software-association" class="list-group-item">
			<h4 class="text-center">↪ <small>(NSA) 2000</small><br>Network Software Association</h4>
		</a>
		<div class="img-screenshot"><picture title="Paradigm's Hoyle Casino 98 cracktro">
		<source width="640" height="480" srcset="/images/#get(myapp).dirPreview#/a6c229c9-c7e4-4b06-b388-f59fa2e876a4.webp" type="image/webp" class="img-rounded img-responsive">
		<img width="640" height="480" src="/images/#get(myapp).dirPreview#/a6c229c9-c7e4-4b06-b388-f59fa2e876a4.png" alt="Paradigm cracktro" class="img-rounded img-responsive">
		</picture></div>
	</div>
	</div>
	</div>
	<div class="panel-heading"><h3 class="panel-title"><em>1997</em></h3></div>
	<div class="list-group">
	<a href="/f/ad40ce" class="list-group-item">
		<small>November 27</small><h3>Earliest ISO release</h3>
		<p class="list-group-item-text">Sierra On-Line's Lords of Magic by CiFE</p>
		<small>An ISO is a file archive of a physical media disk such as a CD or DVD.
The trading of ISOs between individuals happened for years prior.
Still, the formalization of an ISO trading scene for software occurred in late 1997, but it took years before it became a dominant format.</small>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>1997+</em></h3></div>
	<div class="list-group">
	<div class="list-group-item"><small>Notable groups</small>
	<div class="list-group">
		<a href="/g/cd-images-for-the-elite" class="list-group-item">
			<h4>CD Images for the Elite <small>(CiFE) 1997</small></h4>
		</a>
		<a href="/g/divine" class="list-group-item">
			<h4>Divine <small>1997</small></h4>
		</a>
		<a href="/g/fairlight" class="list-group-item">
			<h4>Fairlight <small>1998</small></h4>
			<div class="img-screenshot"><picture title="Fairlight's release 500 from 2002">
			<source width="640" height="480" srcset="/images/#get(myapp).dirPreview#/f68e1bc0-6b26-4b0a-933d-57c096103bf9.webp" type="image/webp" class="img-rounded img-responsive">
			<img width="640" height="480" src="/images/#get(myapp).dirPreview#/f68e1bc0-6b26-4b0a-933d-57c096103bf9.png" alt="Paradigm cracktro" class="img-rounded img-responsive">
			</picture></div>
		</a>
		<a href="/g/scienide" class="list-group-item">
			<h4>Scienide <small>1999</small></h4>
		</a>
		<a href="/g/myth" class="list-group-item">
			<h4>Myth <small>2000</small></h4>
		</a>
		<a href="/g/paradigm" class="list-group-item">
			<h4 class="text-center">Paradigm <small>(PDM)</small> ⤴</h4>
		</a>
		<a href="/g/origin" class="list-group-item">
			<h4 class="text-center">Origin <small>(OGN)</small> ⤴</h4>
		</a>
		<a href="/g/postmortem" class="list-group-item">
			<h4>Postmortem <small>2001</small></h4>
		</a>
		<a href="/g/virility" class="list-group-item">
			<h4>Virility <small>2001</small></h4>
		</a>
		<a href="/" class="list-group-item">
			<h4>Defacto2 <small>(This website) (DF2) 2003</small></h4>
		</a>
		<a href="/g/hoodlum" class="list-group-item">
			<h4>Hoodlum <small>2004</small></h4>
		</a>
		<a href="/g/reloaded" class="list-group-item">
			<h4>Reloaded <small>2004</small></h4>
		</a>
		<a href="/g/rituel" class="list-group-item">
			<h4>Rituel <small>2005</small></h4>
		</a>
		<a href="/g/hatred" class="list-group-item">
			<h4>Hatred <small>2006</small></h4>
		</a>
		<a href="/g/skid-row" class="list-group-item">
			<h4>Skid Row <small>2007</small></h4>
		</a>
	</div>
	</div>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3 class="panel-title"><em>Some notable BBSes</em></h3></div>
	<div class="list-group">
		<div class="list-group-item"><small>Toronto</small></div>
		<a href="/g/beyond-akira-bbs" class="list-group-item">
			<h4 class="text-center">Akira <small>(416)</small></h4>
		</a>
		<div class="list-group-item"><small>Chicago</small></div>
		<a href="/g/bbs_a_holic-bbs" class="list-group-item">
			<h4 class="text-center">BBS-a-holic <small>(708)</small></h4>
		</a>
		<a href="/g/park-central-bbs" class="list-group-item">
			<h4 class="text-center">Park Central <small>(708)</small></h4>
		</a>
		<div class="list-group-item"><small>New York</small></div>
		<a href="/g/cloak-n-dagger-bbs" class="list-group-item">
			<h4 class="text-center">Cloak-n-Dagger <small>(516)</small></h4>
		</a>
		<a href="/g/pits-bbs" class="list-group-item">
			<h4 class="text-center">The Pits <small>(718)</small></h4>
		</a>
		<div class="list-group-item"><small>Philadelphia</small></div>
		<a href="/g/dimention-xxx-bbs" class="list-group-item">
			<h4 class="text-center">Dimention XXX <small>(215)</small></h4>
		</a>
		<div class="list-group-item"><small>Portland</small></div>
		<a href="/g/manhattan-project-bbs" class="list-group-item">
			<h4 class="text-center">Manhattan Project <small>(503)</small></h4>
		</a>
		<div class="list-group-item"><small>Dallas</small></div>
		<a href="/g/midnight-oil-bbs" class="list-group-item">
			<h4 class="text-center">Midnight Oil <small>(214)</small></h4>
		</a>
		<div class="list-group-item"><small>Detroit</small></div>
		<a href="/g/nevada-testing-grounds-bbs" class="list-group-item">
			<h4 class="text-center">Nevada Testing Ground <small>(313)</small></h4>
		</a>
		<div class="list-group-item"><small>Cleveland</small></div>
		<a href="/g/rusty-n-edies-bbs" class="list-group-item">
			<h4 class="text-center">Rusty-n-Edies <small>(216)</small></h4>
		</a>
		<div class="list-group-item"><small>Houston</small></div>
		<a href="/g/silicon-wasteland-bbs" class="list-group-item">
			<h4 class="text-center">Silicon Wasteland <small>(713)</small></h4>
		</a>
		<div class="list-group-item"><small>Vermont</small></div>
		<a href="/g/spyrits-crypt-bbs" class="list-group-item">
			<h4 class="text-center">Spyrits Crypt <small>(802)</small></h4>
		</a>
	</div>
	</div>
	</div>
	<br>
</div>
	#includePartial('retrotxt')#
</cfoutput>