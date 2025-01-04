<!---
	Upload settings
	path: config/settings-uploads.cfm

@CFLintIgnore
--->
<cfscript>
	/*
	 * Allowed file extensions and file types for file uploads
	 */
	/*
	acceptedArchives		Compressed archives.
							The site application supports: 7-Zip, ARC, ARJ, GNU Zip, LHA/LHarc, Roshal Archive, Tar/Tape Archive, Zip.
	acceptedDirChrs			A regular expression containing valid characters for file and directory names, this should NOT be modified!
							CFWheels v2 routing is incompatible with dots.
							Only permit: A-Z 0-9 - , & [space]
	acceptedAudio			Audio containers.
							The site application supports: Sun audio format, Free Lossless Audio Codec, Musical Instrument Digital Interface, MP3, Ogg, Waveform Audio, Windows Media Audio.
	acceptedChiptunes		Tracked music files (modules).
	acceptedDocuments		Plain text documents.
							ASCII text, ANSI text, BBS captures, BBS file_id.diz, text document, Portable Document Format, NFO document.
	acceptedGraphics		Image and photos.
							Bitmap Image format, Graphics Interchange Format, JPEG, Portable Network Graphics, PC Paintbrush.
	acceptedNoPreviews		File formats that are allowed to be uploaded but the site application can not read to generate a thumbnail or preview.
							Portable Document Format.
	acceptedPrograms		DOS and Windows program files.
							Executable file, Command file.
	acceptedVideos			Video containers.
							Audio Video Interleave, DivX, Flash Video, QuickTime, Moving Picture Experts Group, RealMedia, Windows Media Video, Xvid
	blacklistedExt			File extensions that will always be rejected.
							These formats are used by web applications and can be a security risk if they are permitted onto the site.
	*/
	loc.myapp.acceptedArchives		= "7z,arc,ark,arj,cab,gz,lha,lzh,rar,tar,tar.gz,zip"
	loc.myapp.acceptedDirChrs		= "[^a-z0-9\-\,\& ]"
	loc.myapp.acceptedAudio			= "au,flac,m1a,m2a,mid,midi,mp1,mp2,mp3,mpa,mpga,mpeg,ogg,snd,wav,wave,wma"
	loc.myapp.acceptedChiptunes		= "far,it,mod,mptm,s3m,stm,xm"
	loc.myapp.acceptedDocuments		= "1st,asc,ans,cap,diz,doc,dox,me,nfo,pcb,txt,unp"
	loc.myapp.acceptedGraphics		= "bmp,gif,ico,iff,jpg,jpeg,lbm,pdf,png,pcx"
	loc.myapp.acceptedNoPreviews	= ""
	loc.myapp.acceptedPrograms		= "exe,com"
	loc.myapp.acceptedVideos		= "avi,divx,flv,gt,mov,m4a,m4v,mp4,swf,rm,ram,wmv,xvid"
	// blacklistedExt notes: dbm is ColdFusion server, lex is Lucee extension archive
	loc.myapp.blacklistedExt		= "cfm,cfml,cfc,cgi,dbm,lex,lucee,jsp,php,shtml"
	/*
	 * Allowed URL schemes for Links
	 */
	/*
	acceptedURISchemes		URI scheme is the top level of the uniform resource identifier (URI) naming structure.
	*/
	loc.myapp.acceptedURISchemes	= "http,https,feed,ftp,git,gopher,irc,irc6,magnet,rsync,sftp,ssh,telnet,udp"
	/*
	 * Automatic file types by extension
	 */
	/*
	casesDescriptions		Files extensions that will be used for descriptors, listed in order of preference.
	casesDocument			Files extensions that will be used for documentation, listed in order of preference.
	casesPreview			Files extensions that will be used for previews, listed in order of preference.
	*/
	loc.myapp.casesDescriptions		= "file_id.diz,.diz"
	loc.myapp.casesDocument			= ".ans,.asc,.nfo,.pcb,.txt"
	loc.myapp.casesPreview			= ".ico,.png,.jpg,.gif,.bmp"
	/*
	 * Upload FORM settings
	 */
	/*
	 * Earliest year to display on all date select dialogues
	*/
	loc.myapp.yearStart				= 1980
	/*
	 * File extensions information
	 */
	loc.myapp.ext7z = {
		"name" = "7-Zip", "formal" = "Lempel-Ziv-Markov chain algorithm", "extensions" = "7z", "www" = "en.wikipedia.org/wiki/7z"
	}
	loc.myapp.extANS = {
		"name" = "ANSI", "formal" = "ANSI art", "extensions" = "ANS", "www" = "en.wikipedia.org/wiki/ANSI_art"
	}
	loc.myapp.extArc = {
		"name" = "ARC", "formal" = "System Enhancement Associates ARC", "extensions" = "ARC,ARK", "www" = "en.wikipedia.org/wiki/ARC_(file_format)"
	}
	loc.myapp.extArj = {
		"name" = "ARJ", "formal" = "Archived by Robert Jung", "extensions" = "ARJ", "www" = "en.wikipedia.org/wiki/Arj"
	}
	loc.myapp.extAsc = {
		"name" = "ASC", "formal" = "ASCII art", "extensions" = "ASC", "www" = "en.wikipedia.org/wiki/ASCII_art"
	}
	loc.myapp.extAU = {
		"name" = "AU", "formal" = "Sun Microsystems Audio", "extensions" = "AU,SND", "www" = "en.wikipedia.org/wiki/Au_file_format"
	}
	loc.myapp.extAVI = {
		"name" = "AVI", "formal" = "Audio Video Interleave", "extensions" = "AVI", "www" = "en.wikipedia.org/wiki/Audio_Video_Interleave"
	}
	loc.myapp.extBMP = {
		"name" = "BMP", "formal" = "Bitmap image file", "extensions" = "BMP", "www" = "en.wikipedia.org/wiki/BMP_file_format"
	}
	loc.myapp.extCAB = {
		"name" = "CAB", "formal" = "Microsoft Cabinet archive", "extensions" = "CAB", "www" = "en.wikipedia.org/wiki/Cabinet_(file_format)"
	}
	loc.myapp.extCAP = {
		"name" = "CAP", "formal" = "Telix BBS CAPture", "extensions" = "CAP", "www" = "en.wikipedia.org/wiki/Telix"
	}
	loc.myapp.extCOM = {
		"name" = "COM", "formal" = "MS-DOS binary command", "extensions" = "COM", "www" = "en.wikipedia.org/wiki/COM_file"
	}
	loc.myapp.extDivx = {
		"name" = "DivX", "formal" = "DivX", "extensions" = "DIVX", "www" = "en.wikipedia.org/wiki/Divx"
	}
	loc.myapp.extEXE = {
		"name" = "EXE", "formal" = "MS-DOS, OS/2 or Microsoft Windows binary executable", "extensions" = "EXE", "www" = "en.wikipedia.org/wiki/Exe"
	}
	loc.myapp.extDIZ = {
		"name" = "File_id.diz", "formal" = "Description In Zipfile", "extensions" = "DIZ", "www" = "en.wikipedia.org/wiki/File_id.diz"
	}
	loc.myapp.extFlac = {
		"name" = "Flac", "formal" = "Free Lossless Audio Codec", "extensions" = "FLAC", "www" = "en.wikipedia.org/wiki/Flac"
	}
	loc.myapp.extFlv = {
		"name" = "Flash", "formal" = "Adobe or Macromedia Flash Video", "extensions" = "FLV,SWF", "www" = "en.wikipedia.org/wiki/Flv"
	}
	loc.myapp.extGif = {
		"name" = "GIF", "formal" = "Graphics Interchange Format", "extensions" = "GIF", "www" = "en.wikipedia.org/wiki/Gif"
	}
	loc.myapp.extGZ = {
		"name" = "GZ", "formal" = "GNU Zip", "extensions" = "GZ", "www" = "www.gnu.org/software/gzip"
	}
	loc.myapp.extIco = {
		"name" = "Ico", "formal" = "Windows icon", "extensions" = "ICO", "www" = "en.wikipedia.org/wiki/ICO_(file_format)"
	}
	loc.myapp.extJpeg = {
		"name" = "Jpeg", "formal" = "Joint Photographic Experts Group", "extensions" = "JPG,JPEG", "www" = "en.wikipedia.org/wiki/Jpg"
	}
	loc.myapp.extLha = {
		"name" = "LHA", "formal" = "LHarc", "extensions" = "LHA,LZH", "www" = "en.wikipedia.org/wiki/LHA_(file_format)"
	}
	loc.myapp.extME = {
		"name" = "READ.ME", "formal" = "Read Me document", "extensions" = "ME,1ST", "www" = "en.wikipedia.org/wiki/README"
	}
	loc.myapp.extMidi = {
		"name" = "Midi", "formal" = "Musical Instrument Digital Interface", "extensions" = "MID,MIDI", "www" = "en.wikipedia.org/wiki/Musical_Instrument_Digital_Interface"
	}
	loc.myapp.extMP3 = {
		"name" = "MP3", "formal" = "MPEG Audio Layer I, II, III", "extensions" = "MP1,MP2,MP3,M1A,M2A,MPA", "www" = "en.wikipedia.org/wiki/Mp3"
	}
	loc.myapp.extMP1 = {
		"name" = "MPEG-1", "formal" = "Moving Picture Experts Group 1", "extensions" = "MPEG,MPG,MP1,M1V,MPV", "www" = "en.wikipedia.org/wiki/MPEG-1"
	}
	loc.myapp.extMP2 = {
		"name" = "MPEG-2", "formal" = "Moving Picture Experts Group 2", "extensions" = "M2V,MP2", "www" = "en.wikipedia.org/wiki/MPEG-2"
	}
	loc.myapp.extMP4 = {
		"name" = "MPEG-4", "formal" = "H.264/MPEG-4 Advanced Video Coding", "extensions" = "MP4,M4V,M4A", "www" = "en.wikipedia.org/wiki/MPEG-4_Part_14"
	}
	loc.myapp.extNFO = {
		"name" = "NFO", "formal" = "Information document", "extensions" = "NFO", "www" = "en.wikipedia.org/wiki/.nfo"
	}
	loc.myapp.extOgg = {
		"name" = "Ogg", "formal" = "Ogg Xiph.Org Foundation", "extensions" = "OGG", "www" = "en.wikipedia.org/wiki/Ogg"
	}
	loc.myapp.extPCB = {
		"name" = "PCBoard", "formal" = "PCBoard codes", "extensions" = "PCB", "www" = "wiki.synchro.net/custom:colors##pcboard_wildcat_format"
	}
	loc.myapp.extPCX = {
		"name" = "PCX", "formal" = "PC Paintbrush Personal Computer Exchange", "extensions" = "PCX", "www" = "en.wikipedia.org/wiki/Pcx"
	}
	loc.myapp.extPDF = {
		"name" = "PDF", "formal" = "Portable Document Format", "extensions" = "PDF", "www" = "en.wikipedia.org/wiki/Pdf"
	}
	loc.myapp.extMov = {
		"name" = "QuickTime", "formal" = "Apple QuickTime File Format", "extensions" = "MOV,GT", "www" = "en.wikipedia.org/wiki/.mov"
	}
	loc.myapp.extRar = {
		"name" = "RAR", "formal" = "Roshal ARchive", "extensions" = "RAR", "www" = "www.rarlab.com"
	}
	loc.myapp.extRM = {
		"name" = "Real", "formal" = "RealMedia", "extensions" = "RM,RAM", "www" = "en.wikipedia.org/wiki/Real_media"
	}
	loc.myapp.extPNG = {
		"name" = "PNG", "formal" = "Portable Network Graphics", "extensions" = "PNG", "www" = "en.wikipedia.org/wiki/Portable_Network_Graphics"
	}
	loc.myapp.extTar = {
		"name" = "TAR", "formal" = "Tape ARchive", "extensions" = "TAR", "www" = "en.wikipedia.org/wiki/Tar_(file_format)"
	}
	loc.myapp.extTxt = {
		"name" = "Text", "formal" = "Plain text document", "extensions" = "TXT,DOC", "www" = "en.wikipedia.org/wiki/Doc_file"
	}
	loc.myapp.extWav = {
		"name" = "Wave", "formal" = "Waveform Audio File Format", "extensions" = "WAV,WAVE", "www" = "en.wikipedia.org/wiki/Waveform_Audio_File_Format"
	}
	loc.myapp.extWMA = {
		"name" = "WMA", "formal" = "Windows Media Audio", "extensions" = "WMA", "www" = "en.wikipedia.org/wiki/Windows_Media_Audio"
	}
	loc.myapp.extWMV = {
		"name" = "WMV", "formal" = "Windows Media Video", "extensions" = "WMV", "www" = "en.wikipedia.org/wiki/Windows_Media_Video"
	}
	loc.myapp.extXVid = {
		"name" = "Xvid", "formal" = "Xvid", "extensions" = "XVID", "www" = "en.wikipedia.org/wiki/Xvid"
	}
	loc.myapp.extZip = {
		"name" = "Zip", "formal" = "PKWare PKZip", "extensions" = "ZIP", "www" = "en.wikipedia.org/wiki/ZIP_(file_format)"
	}
</cfscript>
