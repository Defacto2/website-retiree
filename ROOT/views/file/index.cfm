<!---
	File contents view.
	path: views/files/index.cfm

@CFLintIgnore
--->
<cfscript>
	var humanize = function(numeric number=0, numeric base=100) {
		return (arguments.number\arguments.base)*arguments.base
	}
	var card = '/file/list?output=card'
	var out = 'output=card'
	var srt = 'sort=date_asc'
	pageAbout['text'] = ' Files'
	pageAbout['icon'] = 'fal fa-folders'
</cfscript>
<cfoutput>
<div class="row files-index">
	<div>
		<ul class="nav nav-pills">
			<li role="presentation">
				<a aria-label="Go to the file upload form" href="#urlFor(controller='upload',action='index')#" id="upload_btn"><i class="fal fa-file-upload fa-fw fa-lg"></i> <strong>Uploader</strong> to include your files</a></li>
			<li role="presentation">
				<a href="/file/list/new"><i class="fal fa-sort-amount-down fa-fw fa-lg"></i> <strong>Newest files</strong> added to the site</a></li>
			<li role="presentation">
				<a class="do-not-sort" href="#card#&platform=-&section=-&sort=date_asc"><strong><i class="fal fa-sort-amount-up fa-fw fa-lg"></i> Oldest known scene files</strong> from <strong>#count.firstYear# onwards</strong></a></li>
			<li role="presentation">
				<a class="do-not-sort" href="#card#&platform=-&section=-&sort=date_desc"><strong><i class="fal fa-sort-amount-down fa-fw fa-lg"></i> Newest scene files</strong></a></li>
		</ul>
	</div>
	<hr>
	<div class="main-items-grid">
		<dl>
			<dt><h2><a href="#card#&platform=-&section=releaseAdvert&#srt#">Cracktros and intros</a></h2></dt>
			<dd><p class="lead">Cracktros are mini adverts created by <a href="/organisation/list/group">cracking groups</a> to announce their releases to the community.
				Initially, these programs were inserted and launched whenever the cracked software was in use.</p>
				We have over <em>#humanize(count.trosWin)# cracktro and crack-intros for <a href="#card#&platform=windows&section=releaseAdvert&#srt#">Windows</a></em> individually itemised for download.<br>
				Another <em>#humanize(count.trosDos)#</em> of these <em>for <a href="#card#&platform=dos&section=releaseAdvert&#srt#">MS-DOS</a></em> are playable in your web browser!<br>
				Also, we hold a collection of <em>#humanize(count.install,10)#</em> <strong><a href="#card#&platform=-&section=releaseinstall&#srt#">scene software installers</a></strong> that complimented the cracktros
				and <em>#humanize(count.demos)#</em> <strong><a href="#card#&platform=-&section=demo&#srt#">demoscene productions</a></strong> to juxapose.</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=-&section=releaseInformation&#srt#">NFO files and scene releases</a></h2></dt>
			<dd><p class="lead">NFO or information text files are generally in every scene release.
				Often, they are stylised with ASCII text art and arranged in a standard format.
				In the early days, these texts included detailed group information, but now they focus more on the cracked software.</p>
				We hold <em>#humanize(count.nfo)# <a href="#card#&platform=-&section=releaseInformation&#srt#">NFO and information texts</a></em>.<br>
				Also, we hold a collection of <em>#humanize(count.nfotool,10)#</em> <strong><a href="#card#&platform=-&section=nfotool&#srt#">NFO viewers and editors</a></strong>.
				<br>
				The <em>#humanize(count.proof,10)#</em> <strong><a href="#card#&platform=-&section=releaseproof&#srt#">group release proofs</a></strong> are to verify the use of retail-ready physical media that's supplied for release.</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=ansi&section=-&#srt#">ANSI art</a></h2></dt>
			<dd><p class="lead">Coloured ANSI text art was commonly used on BBSes for advertising and theming of their sites.</p>
				This collection includes over <em>#humanize(count.ansi)#</em> items used for marketing <strong><a href="#card#&platform=ansi&section=bbs&#srt#">BBSes</a></strong>,
				<strong><a href="#card#&platform=ansi&section=ftp&#srt#">FTP sites</a></strong>,
				<strong><a href="#card#&platform=ansi&section=releaseinformation&#srt#">group NFOs</a></strong> and
				<strong><a href="#card#&platform=ansi&section=logo&#srt#">brand logos</a></strong>.
				<br>Also, there is a collection of <a href="#card#&platform=ansi&section=package&#srt#">ANSI artpacks</a>.</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=dos&section=bbs&#srt#">BBS ads</a></h2></dt>
			<dd><p class="lead">Bulletin Board Systems were a proto-Interweb for online communication and the exchange of files during the 1980s until the mid-1990s.</p>
				This is a collection of <em>#humanize(count.bbs)# files</em>.<br>
				With <em>#humanize(count.bbstro)#</em> <strong><a href="#card#&platform=dos&section=bbs&#srt#">BBStros</a></strong> mostly for MS-DOS.<br>
				Another <em>#humanize(count.bbsansi)#</em> <strong><a href="#card#&platform=ansi&section=bbs&#srt#">ANSI art</a></strong> pieces.<br>
				Many <strong><a href="#card#&platform=image&section=bbs&#srt#">images</a></strong>
				and <em>#humanize(count.bbstext)#</em> <strong><a href="#card#&platform=text&section=bbs&#srt#">text files</a></strong>.<br>
				We also have a large collection of <strong><a href="#card#&platform=-&section=ftp&#srt#">FTP ads</a></strong> plus
				lists of <a href="/organisation/list/bbs">BBS sites</a> and <a href="/organisation/list/ftp">FTP sites</a> are also available.
			</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=-&section=magazine&#srt#">Magazines</a></h2></dt>
			<dd><p class="lead">Before the web and social media existed, groups used to exchange ideas and write articles on their communities in the form of digital magazines and newsletters.</p>
				The <em>#humanize(count.mags,10)# issues</em> for <em>#humanize(count.magPubs,10)# publications</em> are also listed under their <strong><a href="/organisation/list/magazine">publication titles</a></strong>.
			</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=-&section=package&#srt#">Art and file packs</a></h2></dt>
			<dd><p class="lead">File packs are packages of files that share a common theme that people have collected and curated for easy distribution.</p>
				Topics include <a href="#card#&platform=ansi&section=package&#srt#">ANSI art</a>,
				<a href="#card#&platform=text&section=package&#srt#">ASCII art</a>,
				<a href="#card#&platform=text&section=package&#srt#">NFOs+texts</a>,
				<a href="#card#&platform=image&section=package&#srt#">Images</a>,
				<a href="#card#&platform=windows&section=package&#srt#">Windows</a>
				 and <a href="#card#&platform=dos&section=package&#srt#">MS-DOS software</a>.
			</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=database&section=-&#srt#">Databases</a></h2></dt>
			<dd><p class="lead">Scene databases are often once private datasets of cracked software titles, release dates and associated groups.
				Due to their size, these sets are often incomplete and sometimes inaccurate.</p>
				You can also download a live copy of the <a href="/code">Defacto2 database</a> used by this website.
			</dd>
		</dl>
		<dl>
			<dt><h2><a href="#card#&platform=text&section=-&#srt#">Text files and documents</a></h2></dt>
			<dd><p class="lead">The vast majority of scene releases involve text and documents.</p>
				We host <em>#humanize(count.text+count.textAmi,10)# text files</em>.<br>
				Of which, <em>#humanize(count.nfo)# <a href="#card#&platform=-&section=releaseInformation&#srt#">NFO files</a></em> are held.<br>
				Plus the <em>#humanize(count.textAmi,10)#</em> texts created for the <strong><a href="#card#&platform=textamiga&section=-&#srt#">Commodore Amiga</a></strong>.<br>
				There are also more modern document formats such as <strong><a href="#card#&platform=pdf&section=-&#srt#">PDFs</a></strong>, <strong><a href="#card#&platform=markup&section=-&#srt#">HTML websites</a></strong>.<br>
				As well as files covering the former <strong><a href="#card#&platform=-&section=appleii&#srt#">Apple ][</a></strong> and <strong><a href="#card#&platform=-&section=atarist&#srt#">Atari ST</a></strong> scenes.</dd>
		</dl>
		<dl>
			<dt><h2><a href="/file/list/github?output=card&#srt#">GitHub repositories</a></h2></dt>
			<dd><p class="lead">Occasionally, authors of software and applications include the source code of their works.
				They or we submit these sources to <a href="https://github.com">GitHub</a> for easy access and viewability.</p>
				There are <em>#humanize(count.github,10)# programs</em> using source code repos.
				Most of these legacy items are made in <a href="https://cs.lmu.edu/~ray/notes/x86assembly/">x86 Assembly</a> or <a href="https://codedocs.org/what-is/pascal-programming-language">Pascal</a> for MS-DOS or Windows32.
			</dd>
		</dl>
	</div>
	<hr>
	<div class="secondary-items-grid">
		<dl>
			<dt><h3><a href="#card#&platform=-&section=newsmedia&#srt#">Mainstream news</a></h3></dt>
			<dd>Scans and retypes of computer magazines and newspaper articles that attempt to report on the Scene.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=takedown&#srt#">Busts and takedowns</a></h3></dt>
			<dd>Reports and alerts for software pirate arrests and police raids.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=scenerules&#srt#">Community standards</a></h3></dt>
			<dd>Rules and agreed standards for the various divisions of the Scene. </dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=politics&#srt#">Community drama</a></h3></dt>
			<dd>The very competitive scene often has led to online flamewars and occasionally offline conflicts.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=announcements&#srt#">Announcements</a></h3></dt>
			<dd>Public notices and community farewells.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=forsale&#srt#">For sale</a></h3></dt>
			<dd>Adverts for commercial goods and online services, that vary in legality.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=groupapplication&#srt#">Group jobs</a></h3></dt>
			<dd>Calls for new group memberships or employment and tools for possible applicants.
			Sometimes a <strong><a href="#card#&platform=windows&section=groupapplication&#srt#">trial crackme</a></strong> is made to test one's abilty.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=internaldocument&#srt#">Restricted</a></h3></dt>
			<dd>Internal tools and documents that were never intended to be made public, but give a great insight into the operations of scene groups.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=gamehack&#srt#">Game hacks</a></h3></dt>
			<dd>A small collection of hacks, exploits, cheats and trainers for legacy PC games.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=guide&#srt#">Guides and how-tos</a></h3></dt>
			<dd>Texts and guides on how to analyse, patch and crack legacy software.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=programmingtool&#srt#">Computer tools</a></h3></dt>
			<dd>Legacy software to analyse, decrypt, patch and crack other programs.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=ansieditor&#srt#">ANSI tools</a></h3></dt>
			<dd>Legacy software used to create and edit ANSI art files.</dd>
		</dl>
		<dl>
			<dt><h3><a href="#card#&platform=-&section=nfotool&#srt#">NFO tools</a></h3></dt>
			<dd>Legacy software designed to create and edit NFO text files.</dd>
		</dl>
		<dl>
			<dt><h3>Multimedia</h3></dt>
			<dd>
				<ul class="list-unstyled">
				<li class="nowrap"><strong><a href="#card#&platform=image&section=-&#srt#">Images</a></strong> include pixel art, photoshop creations and various photos.</li>
				<li class="nowrap"><strong><a href="#card#&platform=audio&section=-&#srt#">Music</a></strong> tracks found in productions and songs inspired by the Scene.</li>
				<li class="nowrap"><strong><a href="#card#&platform=video&section=-&#srt#">Videos</a></strong> mostly of animated group logos.</li>
				</ul>
			</dd>
		</dl>
	</dd>
	</div>
	<hr>
	<div>
		<dl>
			<dt><h2><a href="#card#&platform=-&section=interview&#srt#">Interviews</a></h2></dt>
			<dd><p class="lead">Discussions with scene members, be prepared for bad speling and typos.
			There are also countless other interviews contained within the numerous <a href="#card#&platform=-&section=magazine&#srt#">magazines</a>.</p>
		</dl>
	</div>
	<div class="secondary-items-grid">

<div class="panel panel-default">
	<div class="panel-heading"><a href="/g/international-network-of-crackers">International Network of Crackers</a> <small>(INC)</small></div>
	<div class="list-group">
	<a href="/f/a62913" class="list-group-item">
		<h4 class="list-group-item-heading">Bar Manager <small>Feb, 1993</small></h4>
		<p class="list-group-item-text">The History and INC Today</p>
	</a>
	<a href="/wayback/scenelink-from-1998-june-25/features/issue/5/ch.html" class="list-group-item">
		<h4 class="list-group-item-heading">Coolhand <small>June, 1998</small></h4>
		<p class="list-group-item-text">Scenelink interview</p>
	</a>
	<a href="/f/a72d0b" class="list-group-item">
		<h4 class="list-group-item-heading">Line Noise <small>March, 1993</small></h4>
		<p class="list-group-item-text">Adrenalin Magazine interview</p>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><a href="/g/fairlight">Fairlight</a> <small>(FLT)</small></div>
	<div class="list-group">
	<a href="/f/ac4680" class="list-group-item">
		<h4 class="list-group-item-heading">Ford Perfect <small>Jan, 1993</small></h4>
		<p class="list-group-item-text">Before the "Incident"...</p>
	</a>
	<a href="/f/ad4af8" class="list-group-item">
		<h4 class="list-group-item-heading">Genesis <small>Oct, 1991</small></h4>
		<p class="list-group-item-text">Software Chronicles Digest interview</p>
	</a>
	</div>
	<div class="panel-heading"><a href="/g/razor-1911">Razor 1911</a> <small>(RZR)</small></div>
	<div class="list-group">
	<a href="/f/ab3914" class="list-group-item">
		<h4 class="list-group-item-heading">Pitbull <small>2005</small></h4>
		<p class="list-group-item-text">The former Razor leader talks about life after being busted</p>
	</a>
	<a href="/f/ac3d0c" class="list-group-item">
		<h4 class="list-group-item-heading">The Renegade Chemist <small>June, 1996</small></h4>
		<p class="list-group-item-text">Spotlight on</p>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><a href="/g/the-dream-team">The Dream Team</a> <small>(TDT)</small></div>
	<div class="list-group">
	<a href="/f/a93a58" class="list-group-item">
		<h4 class="list-group-item-heading">Belgarion <small>Oct, 1991</small></h4>
		<p class="list-group-item-text">Retired THG member and ex-sysop of The Festering Pit BBS</p>
	</a>
	<a href="/f/a729f9" class="list-group-item">
		<h4 class="list-group-item-heading">Hard Core <small>1993</small></h4>
		<p class="list-group-item-text">An interview with the founder</p>
	</a>
	<a href="/f/aa3a34" class="list-group-item">
		<h4 class="list-group-item-heading">T800 <small>Jan, 1996</small></h4>
		<p class="list-group-item-text">Defacto interview</p>
	</a>
	<a href="/f/a1377e" class="list-group-item">
		<h4 class="list-group-item-heading">The Grim Reaper <small>Feb, 1993</small></h4>
		<p class="list-group-item-text">Adrenalin interview</p>
	</a>
	</div>
</div>
<div class="panel panel-default">
	<div class="list-group">
	<a href="/wayback/apollo-x-demo-resources-1999-december-17/bandido.htm" class="list-group-item">
		<h4 class="list-group-item-heading">Bandido <small>1999</small></h4>
		<p class="list-group-item-text">Of Drink or Die and RiSC, Griffiths made global headlines in 2007 after being extradited to the USA despite never visiting the country</p>
	</a>
	<a href="/f/ae2f55" class="list-group-item">
		<h4 class="list-group-item-heading">Bryn Rogers <small>Aug, 2012</small></h4>
		<p class="list-group-item-text">My memories of Lamers of Power</p>
	</a>
	<a href="/wayback/scenelink-from-1998-june-25/features/issue/5/china-interview.html" class="list-group-item">
		<h4 class="list-group-item-heading">ChinaBlue <small>June, 1998</small></h4>
		<p class="list-group-item-text">Retirement and the 'bust or be busted' scene mentality</p>
	</a>
	<a href="/wayback/apollo-x-demo-resources-1999-december-17/marvel.htm" class="list-group-item">
		<h4 class="list-group-item-heading">Marvel <small>July, 1999</small></h4>
		<p class="list-group-item-text">An artist for Future Crew, the most influential demogroup on the PC</p>
	</a>
	<a href="/wayback/scenelink-from-1998-june-25/features/issue/2/deathamnesia.html" class="list-group-item">
		<h4 class="list-group-item-heading">TGK <small>June, 1998</small></h4>
		<p class="list-group-item-text">Scenelink interview about Amnesia</p>
	</a>
	</div>
	</div>
</div>
<hr>
<dl><dt><h2>Operating systems</h2></dt></dl>
<div class="six-item-grid">
	<dl>
		<dt><h3><a href="#card#&platform=dos&section=-&#srt#">DOS</a></h3></dt>
		<dd>Software written for the <a href="https://www.britannica.com/technology/MS-DOS">original x86 operating system</a> and precursor to Microsoft Windows.
			This platform was popular in North America during the 1980s and for much of the world during the first half of the 1990s.</dd>
	</dl>
	<dl>
		<dt><h3><a href="#card#&platform=windows&section=-&#srt#">Windows</a></h3></dt>
		<dd>Windows became the inevitable replacement for MS-DOS on the x86 platform. Most Windows software released in the 1990s and would probably target Windows 95 and 98 while later releases would be for Windows XP or 7.</dd>
	</dl>
	<dl>
		<dt><h3><a href="#card#&platform=mac10&section=-&#srt#">macOS</a></h3></dt>
		<dd>Is the software created for Apple's macOS and earlier OS-X line of operating systems.</dd>
	</dl>
	<dl>
		<dt><h3><a href="#card#&platform=linux&section=-&#srt#">Linux</a></h3></dt>
		<dd>Scene software created for the Linux desktop and server platforms. <small>This software may fail to run on modern distributions</small></dd>
	</dl>
	<dl>
		<dt><h3><a href="#card#&platform=php&section=-&#srt#">Scripts</a></h3></dt>
		<dd>Shell scripts and software created in <a href="https://en.wikipedia.org/wiki/Interpreter_(computing)">interpreted programming languages</a> such as PHP, Perl, TCL, Python and Ruby.</dd>
	</dl>
	<dl>
		<dt><h3><a href="#card#&platform=java&section=-&#srt#">Java</a></h3></dt>
		<dd>Multi-platform applications written in the <a href="https://openjdk.java.net/">Java programming language</a>.</dd>
	</dd>
	</dl>
</div>
	 <hr>
	</div>
</div>
</cfoutput>