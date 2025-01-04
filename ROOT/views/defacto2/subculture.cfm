<!---
    What is the Scene view
	path: views/defacto2/subculture.cfm

@CFLintIgnore
--->
<cfscript>
	param name="extlink" type="string" default="";
	extlink = ['//en.wikipedia.org/wiki/Computer_art_scene',
		'//en.wikipedia.org/wiki/Trainer_%28games%29',
		'//en.wikipedia.org/wiki/CD/DVD_copy_protection',
		'//en.wikipedia.org/wiki/Software_pirate',
		'//en.wikipedia.org/wiki/Warez',
		'//en.wikipedia.org/wiki/Demoscene',
		'//en.wikipedia.org/wiki/Emulation',
		'//en.wikipedia.org/wiki/Hacker',
		'//en.wikipedia.org/wiki/Module_file',
		'//en.wikipedia.org/wiki/Bbs',
		'//en.wikipedia.org/wiki/Phreaking',
		'//en.wikipedia.org/wiki/Warez',
		'//en.wikipedia.org/wiki/IBM_PC_Compatible',
		'//en.wikipedia.org/wiki/MS-DOS',
		'//en.wikipedia.org/wiki/Shareware',
		'//en.wikipedia.org/wiki/Open-source_software',
		'//www.cow.net/conned/notacon/artscene',
		'//www.bbsdocumentary.com',
		'//www.demoscene.tv',
		'//www.amazon.com/gp/product/3981049403',
		'//roysac.com/learn/default.html',
		'//web.archive.org/web/20130203021420/http://artpacks.scene.org/www/html/intro.html',
		'//flashtro.com',
		'//www.pouet.net',
		'//www.bitfellas.org/news.php',
		'//artcity.bitfellas.org',
		'//www.asciiarena.com',
		'//www.scene.org',
		'//www.chiptune.com',
		'//demozoo.org',
		'//www.filfre.net/2015/12/a-pirates-life-for-me-part-1-dont-copy-that-floppy/',
		'//www.filfre.net/2016/01/a-pirates-life-for-me-part-2-the-scene/',
		'//www.filfre.net',
		'//www.amazon.com/Future-Was-Here-Commodore-Platform/dp/0262535696/ref=sr_1_1',
		'//pc.textmod.es',
		'//16colo.rs',
		'//blocktronics.org',
		'//text-mode.org',
		'//www.asciiarena.se',
		'//eprints.bbk.ac.uk/id/eprint/30956/']
		pageAbout.text = ' What is the Scene?'
		pageAbout.icon = 'fal fa-laptop'
</cfscript>
<cfoutput>
	<div class="readable-text" id="defacto2-controller">
		<p class="lead text-center">Collectively referred to as the Scene.
It is a subculture of different computer activities where participants actively share ideas and creations.</p>
		<div class="panel panel-primary">
			<div class="panel-body">
				<p class="lead">Historically, the Scene consisted of communities of computer users engaged in particular activities but often loosely grouped.</p>
				<p>
The loose grouping of Scene activities comes from the era when the Internet was inaccessible to the general public.
#linkTo(text="Bulletin Board Systems",href="#extlink[10]#")# were the principal means for savvy computer users to connect online, communicate and exchange data.
To encourage more people to use their services, boards often hosted various computer-specific activities and subjects.
It led to online communities engaged in some intertwined topics that evolved, were grouped, and became the Scene.</p>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-save fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading">#linkTo(text="Cracking",href=extlink[3])# and #linkTo(text="Warez",href=extlink[12])#</h4>
Cracking is the art of modifying software for a particular purpose.
It can vary widely from the simple act of creating cheats for video games (#linkTo(text="trainers",href="#extlink[2]#")#) to the removal of sophisticated #linkTo(text="software copy protection",href="#extlink[3]#")#.
<p>
The sharing of software with its copy-protection removed gets defined as #linkTo(text="warez",href="#extlink[5]#")#.
In the early days of microcomputing, the removal of copy protection by cracking software was not unlawful.
However, this has long since changed, and the sharing of commercial software and media for free is illegal.</p>
					</div>
				</div>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-terminal fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading">#linkTo(text="Hacking",href=extlink[8])# <small>h/p/a/v</small></h4>
Hacking should not be confused with software cracking, it is the unorthodox manipulation or exploration of most things computer-related.
Online texts and tools for <u>h</u>acking were often combined with those on <u>p</u>hreaking, <u>a</u>narchy, and computer <u>v</u>irus creation, using the h/p/a/v classification.
Today this grouping has fallen out of favor, especially the modern association of <a href="http://textfiles.com/anarchy/">anarchy text files</a> and computer <a href="http://textfiles.com/virus/">viruses</a> that get easily misconstrued for activities against nation-states.
					</div>
				</div>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-phone-volume fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading">#linkTo(text="Phreaking",href=extlink[11])#</h4>
Phreaking is the redundant and illegal art of land-line telephone network exploitation to obtain free calls. It was used in the <abbr title="Bulletin Board Systems">#linkTo(text="BBS",href="#extlink[10]#")#</abbr> era to avoid the prohibitively expensive costs of time-consuming long-distance calling to network computers.
					</div>
				</div>
				<hr>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-paint-brush fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading lead">#linkTo(text="Art",href=extlink[1])#</h4>
Art is the creation of computer-based artwork using digital media and different techniques.
The most common forms of this medium are pixel, raytracing, ASCII, and <abbr title="American National Standards Institute">ANSI</abbr> art.
					</div>
				</div>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-laptop fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading">#linkTo(text="Demos",href=extlink[6])#</h4>
Participants combine art, music and programming trickery to create a visually appealing, non-interactive computer program demonstration.
					</div>
				</div>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-gamepad fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading">#linkTo(text="Emulation",href=extlink[7])#</h4>
Emulation is the creation of software that simulates hardware to run platform-specific software on different machines.
For example, a Sony PlayStation emulator for Windows enables technically incompatible PlayStation games to play on a Microsoft Windows computer.
</div>
				</div>
				<div class="media">
					<div class="media-left media-top">
<i class='fal fa-music fa-fw'></i>
					</div>
					<div class="media-body">
<h4 class="media-heading">#linkTo(text="Music",href=extlink[9])#</h4>
The creation of computer generated music using tracker modules. Its most well-known genres are chiptunes and modules, which have playlists on Spotify.
					</div>
				</div>
			</div>
			<div class="list-group">
				<a href="#UrlFor(controller="Defacto2",action="index",rel="prefetch",id="GotoPrevPage")#" class="list-group-item">
					<h4 class="list-group-item-heading">What is #get('siteAreas').titles.df2#?</h4></a>
				<a href="#UrlFor(controller="Defacto2",action="history",rel="prefetch",id="GotoNextPage")#" class="list-group-item">
					<h4 class="list-group-item-heading">A history of #get('siteAreas').titles.df2#</h4></a>
			</div>
		</div>
		<div class="panel panel-info">
			<div class="panel-heading lead">The creative Art Scene of today</div>
<div class="list-group">
  <a href="#extlink[30]#" class="list-group-item">
    <h4 class="list-group-item-heading">Demozoo</h4>
    <p class="list-group-item-text">Demozoo is the world's largest database of Scene-produced productions covering all fields, including art, demo, music, people, groups, and BBSes.</p>
  </a>
  <a href="#extlink[24]#" class="list-group-item">
    <h4 class="list-group-item-heading">Pouët <small>Pouet</small></h4>
    <p class="list-group-item-text">Pouet is where the artists of the demoscene hang out online. The 'oldskool pouet.net bbs' is the most active forum on the Scene. Most new demo and intro productions are posted online in their 'Prods' section for peer review and criticism.</p>
  </a>
  <!--- <a href="#extlink[25]#" class="list-group-item">
    <h4 class="list-group-item-heading">BitFellas News</h4>
    <p class="list-group-item-text">A primary aggregation of demo and art related news. Using syndication feeds, Bitfellas powered with articles from major scene websites. It is the best way to keep up with the happenings of the legal scenes.</p>
  </a> --->
  <a href="#extlink[36]#" class="list-group-item">
    <h4 class="list-group-item-heading">Sixteen Colors <small>16colors</small></h4>
    <p class="list-group-item-text">16colors is the online gallery for ASCII, ANSI, and other text-based art forms. It is probably the most active corner on the Internet for ASCII art and its artists.</p>
  </a>
  <a href="#extlink[28]#" class="list-group-item">
    <h4 class="list-group-item-heading">Scene.org</h4>
    <p class="list-group-item-text">Most likely the largest repository of scene art on the Internet. Its primary purpose is to host files, so there is no fluff such as user ratings or reviews. It is an excellent resource when knowing what to find but a little daunting for everyone else.</p>
  </a>
  <a href="#extlink[39]#" class="list-group-item">
    <h4 class="list-group-item-heading">aSCIIaRENA</h4>
    <p class="list-group-item-text">ASCII Arena is where the plain-text arts community hang out and peer review artwork.</p>
  </a>
  <a href="#extlink[38]#" class="list-group-item">
    <h4 class="list-group-item-heading">text-mode.org</h4>
    <p class="list-group-item-text">Is an online gallery that takes classical text art and looks at how it relates to a modern context.</p>
  </a>
</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading lead">Further reading on the history</div>
	<div class="panel-body">
		As of 2022, a couple of professionally published books cover the Scene and its influences on modern online culture.
		<p><a href="/commercial/warez">Warez: The Infrastructure and Aesthetics of Piracy</a> and <a href="/commercial/the-modem-world">The Modem World: A Prehistory of Social Media</a>.</p>
	</div>
	<ul class="list-group">
<li class="list-group-item">
	<p><h4 class="list-group-item-heading"><a href="#extlink[40]#">Warez: The Infrastructure and Aesthetics of Piracy</a></h4>
	<small>Eve, Martin Paul (2021) Warez: The Infrastructure and Aesthetics of Piracy. Earth, Milky Way: punctum books. ISBN 978-1-68571-036-1.</small></p>
	<q>When most people think of digital piracy, the phrases that likely come to mind are “Bittorrent”, “Napster”, and “The Pirate Bay”; the popular manifestations and accessible incarnations of home copyright violation. However, this is a poor reflection of a submerged and elite culture of an underground piracy scene that for several decades has operated on a secretive and hierarchical basis of suppliers, couriers, release groups, and “topsites”. The true “warez scene” as it is known, is undetected by the general public, but well-acquainted with high-level law enforcement. This book offers the first academic study of the gigabytes of digital material surfaced by “The Scene” in the form of ASCII .nfo files and DemoScene executables from the Defacto2 archive, charting the structure, organization, and history of the criminal underground networks that race to release material before their competitors with bleeding-edge technology and connections.</q>
</li>
<li class="list-group-item">
<p><h4 class="list-group-item-heading">A Pirate's Life for Me</h4></p>
<p>Jimmy Maher, published author of #linkTo(text="The Future Was Here: The Commodore Amiga",href="#extlink[34]#")# and #linkTo(text="The Digital Antiquarian",href="#extlink[33]#")#, has written two excellent articles on early pirating and the pirate scenes on both the Apple II and Commodore 64 computers.</p>
<div class="list-group">
	<a href="#extlink[31]#" class="list-group-item">A Pirate's Life for Me, Part 1: Don't Copy That Floppy!</a>
	<a href="#extlink[32]#" class="list-group-item">A Pirate's Life for Me, Part 2: The Scene</a>
</div>
</li>
<li class="list-group-item">
	<p><h4 class="list-group-item-heading"><a href="#extlink[17]#">100 Years of the Computer Art Scene</a></h4>
	<small>Jason Scott and RaD Man</small></p>
	<p>Jason Scott is the producer of the excellent and well-received #linkTo(text="BBS Documentary",href="#extlink[18]#")#,
	whereas Rad Man is the founder of the famous art scene group <abbr title="ANSI Creators in Demand">ACiD</abbr>.
	In April of 2004, they teamed up at the Cleveland Notacon Conference and gave a 50-minute presentation <q>100 Years of the Computer Art Scene</q>.
	The presentation can be downloaded and listened to in MP3 format, plus there is a text transcript available.
	The site also has excellent examples of early computer artwork, from old mainframe printouts to massive modern ANSI.</p>
</li>
<li class="list-group-item">
	<p><h4 class="list-group-item-heading"><a href="#extlink[23]#">Flashtros</a></h4></p>
	A fantastic resource that collects the program source code and art assets of Crack-Intros then recompiles them into a web browser friendly format such as Flash, Java or HTML5.
</li>
<!--- <li class="list-group-item">
	<h4 class="list-group-item-heading"><a href="#extlink[20]#">Freax Volume 1.</a></h4>
	An out of print hardback with an in-depth look at both the historic Commodore 64 and Amiga scenes. With their history, dominance and influence in the greater online community. The book contains a lot of text as well as many photos and is an excellent primer for anyone interested in the subject. TThe Commodore 64 was the pioneering format that introduced many of the concepts taken for granted today, while the Amiga scene evolved those notions and produced an even more professional and competitive outlet.
</li> --->
<li class="list-group-item">
	<p><h4 class="list-group-item-heading"><a href="#extlink[21]#">ASCII Art Academy</a></h4></p>
	A great tutorial and summary on ASCII art scene by the famed Roy of <abbr title="Superior Art Creations">SAC</abbr>. An artist over the years commissioned by numerous respected groups including Razor 1911, Drink or Die, <abbr title="Rise In Superior Couriering">RISC</abbr>, <abbr title="Tristar &amp; Red Sector Inc.">TRSi</abbr>, Deviance, Origin and The Humble Guys. The site also has a large number of links to more detailed web pages that cover the subject of ASCII and ANSI art.
</li>
<li class="list-group-item">
	<p><h4 class="list-group-item-heading"><a href="#extlink[22]#">artpacks.acid.org - introduction</a></h4></p>
	<q>Ever since the days of the IBM PC 8088 and <abbr title="Commodore 64">C64</abbr>, personal computers have been used for much more than word processing and data entry.
	Artists around the world have found computer art to be less expensive and much less restrictive than traditional paint and canvas.</q>
</li>
</ul>
		</div>
		<details class="panel panel-default">
			<summary class="panel-heading">External links</summary>
			<div class="panel-body">
				<ol>
					<cfloop array="#extlink#" index="local.link"><li>#autoLink(link)#</li></cfloop>
				</ol>
			</div>
		</details>
	</div>
</cfoutput>