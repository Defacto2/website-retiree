<!---
	Menus settings
	path: config/settings-menus.cfm

	1) All "name" values should be singular not plural.
	2) New additions will require a dynamic SQL statement added to the dynamicSqlForFile()
	   function contained in /events/functions.cfm.

@CFLintIgnore VAR_TOO_LONG,GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN
--->
<cfscript>
	loc.myapp.menu = {
		"files":{
			"image":{},
			"text":{},
			"software":{},
		},
		"platform":{}, // TODO search no-case `menufileplatform`
		"section":{}, // TODO " `menufilesection` ..
		"sites":{}, // TODO
	}
	/*
	 * Art & files > Collection menus
	 */
	loc.myapp.menu.files.image = {
		"name" = "digital + pixel art",
		"description" = "Hi-res, raster and pixel images.",
		"technical" = "",
		"www" = "en.wikipedia.org/wiki/Computer_art_scene"
	}
	loc.myapp.menu.files.text = {
		"name" = "document + text art",
		"description" = "Documents using any media format including text files, ASCII and ANSI text art.",
		"technical" = "",
		"www" = ""
	}
	loc.myapp.menu.files.software = {
		"name" = "software",
		"description" = "Applications and programs for any platform.",
		"technical" = "",
		"www" = ""
	}

	/*
	 * HTML3 by Media platform
	 */
	loc.myapp.menufileplatformAnsi = {
		"name" = "ANSI", "category" = "Stylised Text", "description" = "Coloured, text based computer art form widely used on Bulletin Board Systems.", "technical" = "Plain text documents embedded with extended ASCII/IBM code page 437 control codes.", "www" = "en.wikipedia.org/wiki/Ansi_art"
	}
	loc.myapp.menufileplatformAudio = {
		"name" = "music", "category" = "Media", "description" = "Music or audio sound clips.", "technical" = "", "www" = "en.wikipedia.org/wiki/Computer_music"
	}
	loc.myapp.menufileplatformDatabase = {
		"name" = "database", "category" = "Data", "description" = "A somewhat structured collection of data.", "technical" = "Data stored in particular formats including spreadsheets such as Microsoft Excel or databases such as MySQL.", "www" = "en.wikipedia.org/wiki/Database"
	}
	loc.myapp.menufileplatformDos = {
		"name" = "DOS", "category" = "Software", "description" = "Microsoft DOS programs.", "technical" = "Programs that require the use of Microsoft's DOS operating system for x86 compatible CPUs.", "www" = "en.wikipedia.org/wiki/MS-DOS"
	}
	loc.myapp.menufileplatformImage = {
		"name" = "image", "category" = "Media", "description" = "Digital art, pixel art or photos.", "technical" = "", "www" = "en.wikipedia.org/wiki/Computer_art_scene"
	}
	loc.myapp.menufileplatformJava = {
		"name" = "Java", "category" = "Software", "description" = "Java programs.", "technical" = "Programs that require the use of Java.", "www" = "www.java.com"
	}
	loc.myapp.menufileplatformLinux = {
		"name" = "Linux", "category" = "Software", "description" = "Linux programs.", "technical" = "Programs for a Linux compatible operating system.", "www" = "en.wikipedia.org/wiki/Linux"
	}
	loc.myapp.menufileplatformMac10 = {
		"name" = "macOS", "category" = "Software", "description" = "macOS programs.", "technical" = "Programs for Apple's macOS & OS X operating system.", "www" = "en.wikipedia.org/wiki/Mac_os_x"
	}
	loc.myapp.menufileplatformMarkup = {
		"name" = "HTML", "category" = "Document", "description" = "Web pages or documents in HTML format.", "technical" = "Text documents formatted in a mark-up language.", "www" = "en.wikipedia.org/wiki/Markup_language"
	}
	loc.myapp.menufileplatformPcb = {
		"name" = "PCBoard", "category" = "Stylised Text", "description" = "Coloured encoded text mainly used on Bulletin Board Systems.", "technical" = "Plain text documents embedded with PCBoard control codes.", "www" = "wiki.synchro.net/custom:colors##pcboard_wildcat_format"
	}
	loc.myapp.menufileplatformPdf = {
		"name" = "PDF", "category" = "Document", "description" = "A document compiled in PDF (Portable Document Format).", "technical" = "", "www" = "en.wikipedia.org/wiki/Pdf"
	}
	loc.myapp.menufileplatformPhp = {
		"name" = "Script", "category" = "Software", "description" = "Scripts and interpreted programs.", "technical" = "Programs that were created in an interpreted programming language,", "www" = "en.wikipedia.org/wiki/Interpreter_(computing)"
	}
	loc.myapp.menufileplatformText = {
		"name" = "Text or ASCII", "category" = "Document", "description" = "Text documents and text based computer art.", "technical" = "Monochrome text-based art and plain text files that use an ASCII compliant character set.", "www" = "en.wikipedia.org/wiki/Text_file"
	}
	loc.myapp.menufileplatformTextAmiga = {
		"name" = "Text for Amiga", "category" = "Document", "description" = "Text documents and text based computer art for the Amiga.", "technical" = "Monochrome text-based files in a Topaz2 font that use the Latin-1 character set.", "www" = "en.wikipedia.org/wiki/Text_file"
	}
	loc.myapp.menufileplatformVideo = {
		"name" = "video", "category" = "Media", "description" = "A film, video or multimedia animation.", "technical" = "", "www" = "en.wikipedia.org/wiki/Video"
	}
	loc.myapp.menufileplatformWindows = {
		"name" = "Windows", "category" = "Software", "description" = "Microsoft Windows programs.", "technical" = "Programs that require the use of Microsoft's Windows operating system, working on Intel-compatible CPUs.", "www" = "en.wikipedia.org/wiki/Microsoft_Windows"
	}
	/*
	 * HTML3 by Category
	 */
	loc.myapp.menufilesectionAnnouncements = {
		"name" = "announcement", "category" = "News", "description" = "Public announcements by Scene groups and organisations.", "www" = ""
	}
	loc.myapp.menufilesectionAnsiEditor = {
		"name" = "ANSI tool", "category" = "Software", "description" = "Programs that enable you to create and edit ANSI and ASCII art.", "www" = "en.wikipedia.org/wiki/ANSI_art"
	}
	loc.myapp.menufilesectionAppleII = {
		"name" = "Apple II", "category" = "Alternative Scene", "description" = "Files pertaining to the Scene on the Apple II computer platform.", "www" = "en.wikipedia.org/wiki/Apple_II_series"
	}
	loc.myapp.menufilesectionAtariSt = {
		"name" = "Atari ST", "category" = "Alternative Scene", "description" = "Files pertaining to the Scene on the Atari ST computer platform.", "www" = "en.wikipedia.org/wiki/Atari_st"
	}
	loc.myapp.menufilesectionBbs = {
		"name" = "BBS", "category" = "Site", "description" = "Files pertaining to the Scene operating over telephone based BBS (Bulletin Board System) systems.", "www" = "en.wikipedia.org/wiki/Bulletin_board_system"
	}
	// loc.myapp.menufilesectionCommodoreAmiga = {
	// 	"name" = "Commodore Amiga", "category" = "Alternative Scene", "description" = "Files pertaining to the Scene on the Commodore Amiga computer platform.", "www" = "en.wikipedia.org/wiki/Amiga"
	// }
	loc.myapp.menufilesectionDemo = {
		"name" = "demo program", "category" = "Group", "description" = "An artistic multimedia program that is designed to promote a demo group or collective. Depending on the size and length of the piece it can also be known as an intro. Demo groups share the same lineage as the cracking scene, but they have since gone their separate ways.", "www" = "en.wikipedia.org/wiki/Demoscene"
	}
	loc.myapp.menufilesectionFtp = {
		"name" = "FTP", "category" = "Site", "description" = "Files pertaining to the Scene operating over Internet based FTP (File Transfer Protocol) servers.", "www" = "en.wikipedia.org/wiki/File_Transfer_Protocol"
	}
	loc.myapp.menufilesectionGroupApplication = {
		"name" = "group role or job", "category" = "Group", "description" = "Documents used by scene groups to advertise or enrol new members.", "www" = ""
	}
	loc.myapp.menufilesectionGameHack = {
		"name" = "game hack", "category" = "Software", "description" = "Trainers, dox, cheats, and walk-throughs, which include guides, how-to documents and tools to complete games.", "www" = "https://en.wikipedia.org/wiki/Trainer_(games)"
	}
	loc.myapp.menufilesectionGuide = {
		"name" = "guides and how-tos", "category" = "Scene", "description" = "Guides and how-to documents on how to hack and crack or on the workings of the Scene.", "www" = ""
	}
	loc.myapp.menufilesectionInternalDocument = {
		"name" = "restricted", "category" = "Group", "description" = "Documents created by scene groups that were often never intended to be public.", "www" = ""
	}
	loc.myapp.menufilesectionInterview = {
		"name" = "interview", "category" = "News", "description" = "Conversations conducted with scene personalities.", "www" = ""
	}
	loc.myapp.menufilesectionLogo = {
		"name" = "brand art or logo", "category" = "Group", "description" = "Branding logos used by scene groups and organisations.", "www" = ""
	}
	loc.myapp.menufilesectionMagazine = {
		"name" = "magazine", "category" = "News", "description" = "Reports and written articles created by scene members about the Scene.", "www" = "en.wikipedia.org/wiki/E-zine"
	}
	loc.myapp.menufilesectionNewsMedia = {
		"name" = "mainstream news", "category" = "News", "description" = "Mainstream media outlets reports on the Scene.", "www" = ""
	}
	loc.myapp.menufilesectionNfoTool = {
		"name" = "NFO tool", "category" = "Software", "description" = "Programs that enable you to create or view NFO text files.", "www" = ""
	}
	loc.myapp.menufilesectionPackage = {
		"name" = "filepack", "category" = "Data", "description" = "A curated bundle of scene related files stored and distributed in a compressed archive file", "technical" = "Often either ZIP or 7z formats.", "www" = ""
	}
	loc.myapp.menufilesectionPolitics = {
		"name" = "community drama", "category" = "Group", "description" = "Used for anything political that doesn't fall into the other categories. Usually contains documents where people, groups or organisations are complaining.", "www" = ""
	}
	loc.myapp.menufilesectionProgrammingTool = {
		"name" = "computer tool", "category" = "Software", "description" = "Miscellaneous tools including fixes, intro generators and BBS software.", "www" = ""
	}
	loc.myapp.menufilesectionReleaseAdvert = {
		"name" = "cracktro or intro", "category" = "Group", "description" = "A multimedia program that is designed to promote a scene group or organisation. Otherwise known as a cracktro, crack intro or loader.", "www" = "en.wikipedia.org/wiki/Crack_intro"
	}
	loc.myapp.menufilesectionReleaseInformation = {
		"name" = "NFO file or scene release", "category" = "Group", "description" = "A text file or readme used to describe a scene release, group or organisation.", "www" = "en.wikipedia.org/wiki/.nfo"
	}
	loc.myapp.menufilesectionReleaseProof = {
		"name" = "release proof", "category" = "Group", "description" = "Evidence of the source media, usually a photo or scanned image.", "www" = ""
	}
	loc.myapp.menufilesectionReleaseInstall = {
		"name" = "scene software installer", "category" = "Group", "description" = "A program to help an end-user install a scene release.", "www" = ""
	}
	loc.myapp.menufilesectionSceneRules = {
		"name" = "community standard", "category" = "Scene", "description" = "Various codes of conduct and agreements created by scene groups and organisations.", "www" = ""
	}
	loc.myapp.menufilesectionTakedown = {
		"name" = "bust or takedown", "category" = "News", "description" = "First hand accounts and third party reports on the arrest, bust or take-down of an active person in the Scene or a scene organisation.", "www" = "en.wikipedia.org/wiki/Search_and_seizure"
	}
	loc.myapp.menufilesectionForSale = {
		"name" = "for sale", "category" = "Group", "description" = "Adverts for commercial physical goods and online services, varying in legality.", "www" = ""
	}
	/*
	 * Defacto2 / scene sites
	 */
	loc.myapp.menuwwwAnsi = {
		"name" = "ANSI + ASCII art", "description" = "Coloured and Monochrome text based computer art form, widely used on Bulletin Board Systems.", "www" = "en.wikipedia.org/wiki/ANSI_art"
	}
	loc.myapp.menuwwwBBS = {
		"name" = "BBS + FTP site", "description" = "Pre Peer-to-peer (BitTorrent etc.) internet and telephone based BBS sites used for the distribution of scene releases and communication.", "www" = "en.wikipedia.org/wiki/Bulletin_board_system"
	}
	loc.myapp.menuwwwCracktro = {
		"name" = "cracktro art", "description" = " A multimedia program that is designed to promote a scene group or organisation. Otherwise known as a cracktro or loader.", "www" = "en.wikipedia.org/wiki/Crack_intro"
	}
	loc.myapp.menuwwwDisabled = {
		"name" = "disabled", "description" = "List all website entries that have been disabled, most probably due to the site going offline.", "www" = ""
	}
	loc.myapp.menuwwwDocument = {
		"name" = "documentary", "description" = "Scene related documentaries and video fiction.", "www" = ""
	}
	loc.myapp.menuwwwHistory = {
		"name" = "history", "description" = "Websites with a historical focus on the Scene or that are historic relics.", "www" = ""
	}
	loc.myapp.menuwwwMainstream = {
		"name" = "mainstream media", "description" = "Mainstream media and news items.", "www" = "en.wikipedia.org/wiki/Mainstream_media"
	}
	loc.myapp.menuwwwSceneGroup = {
		"name" = "scene group", "description" = "Official active and archived websites that belonging to groups of the warez scene.", "www" = "en.wikipedia.org/wiki/Warez_group"
	}
	loc.myapp.menuwwwStatusErrors = {
		"name" = "status error code", "description" = "List most website entries that have HTTP status codes that do not match 200 OK.", "www" = "www.w3.org/Protocols/rfc2616/rfc2616-sec10.html"
	}
	loc.myapp.menuwwwWikipedia = {
		"name" = "wikipedia", "description" = "Wikipedia entries on scene groups and topics.", "www" = "en.wikipedia.org/wiki/Wikipedia"
	}
</cfscript>
