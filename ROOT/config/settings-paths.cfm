<!---
	Directories and binary paths
	path: config/settings-paths.cfm

	ALL DIRECTORY PATHS MUST USE A FORWARD SLASH TAIL
	Directory paths must use a forward-slash tail
	GOOD) /var/www/
	BAD)  /var/www

@CFLintIgnore
--->
<cfscript>
	// Web application base location
	application.pathServingRoot = "/var/www/"
	var root = application.pathServingRoot
	var www = application.pathWwwRoot
	// Way-back web local location
	loc.myapp.waybackRoot = "/var/www/wayback/"
	// Temporary directory location
	loc.myapp.tmpDirectory = "/tmp/"
	/*
		Image paths
		These variables should be relative paths from the Image root directory that is set by CFWheels.
		@dirThumb400		400 x 400 sized image thumbnails.
		@dirPreview			Full sized image previews.
	*/
	// Relative paths used by browsers
	loc.myapp.dirThumb400 = "uuid/400x400"
	loc.myapp.dirPreview = "uuid/original"
	// Full paths used by the web application
	loc.myapp.fulldirBackup = www & "files/backups/"
	loc.myapp.fulldirImages = www & "images/"
	loc.myapp.fulldirTest = www & "files/test-uploads/"
	loc.myapp.fulldirThumb400 = loc.myapp.fulldirImages & loc.myapp.dirThumb400
	loc.myapp.fulldirPreview = loc.myapp.fulldirImages & loc.myapp.dirPreview
	/*
	 * File locations
	 */
	/*
		Other read/write file locations
		fulldirFileUuid		UUID named file downloads
	*/
	loc.myapp.fulldirFileUuid = root & "uuid"
	/*
		fulldirUploadFiles	User submitted uploads safe storage.
		fulldirUploadImg	User submitted upload image previews safe storage.
	*/
	loc.myapp.fulldirUploadFiles = root & "incoming/user_submissions/files"
	loc.myapp.fulldirUploadImg = root & "incoming/user_submissions/previews"
	/*
	 * Log file locations
	 */
	// nginx sync
	loc.myapp.logsNginx = {
		"name" = "nginx",
		"filter" = "*.log",
		"dir" = "/var/log/nginx/",
		"displayedfilename" = "nginx"
	}
	// Lucee
	loc.myapp.logsLucee = {
		"name" = "Lucee",
		"dir" = "/opt/lucee/web/logs/",
		"filter" = "*.log",
		"displayedfilename" = "lucee"
	}
	// Apache Tomcat
	loc.myapp.logsTomcat = {
		"name" = "Apache Tomcat",
		"dir" = "/usr/local/tomcat/logs/",
		"filter" = "",
		"displayedfilename" = "tomcat"
	}
	/*
	 * Inhouse Linux terminal binaries
	 */
	/*
	 * 3rd party Linux terminal binaries
	 */
	// 7Z (7Zip) archiver
	loc.myapp.apps7z = {
		"name" = "7Z decompression",
		"file" = "/usr/bin/7z"
	}
	// AnsiLove
	loc.myapp.appsAnsilove = {
		"name" = "AnsiLove/C",
		"file" = "/usr/local/bin/ansilove"
	}
	// ARC archiver
	loc.myapp.appsArc = {
		"name" = "ARC decompression",
		"file" = "/usr/bin/arc"
	}
	// free disk space
	loc.myapp.appsDiskFree = {
		"name" = "Disk free",
		"file" = "/bin/df"
	}
	// distribution
	loc.myapp.appsDistro = {
		"name" = "Linux Standard Base",
		"file" = "/usr/bin/lsb_release"
	}
	// DNS lookup
	loc.myapp.appsDnsLookup = {
		"name" = "DNS Lookup",
		"file" = "/usr/bin/host"
	}
	// duplicate finder
	loc.myapp.appsDupeFinder = {
		"name" = "Fdupes",
		"file" = "/usr/bin/fdupes"
	}
	// file type
	loc.myapp.appsFileType = {
		"name" = "File type",
		"file" = "/usr/bin/file"
	}
	// file type
	loc.myapp.appsFromDOS = {
		"name" = "From DOS",
		"file" = "/usr/bin/fromdos"
	}
	// Graphics Magick
	loc.myapp.appsGM = {
		"name" = "Graphics Magick",
		"file" = "/usr/bin/gm"
	}
	// hardware information
	loc.myapp.appsHardwareInfo = {
		"name" = "Hardware information",
		"file" = "/bin/grep"
	}
	// MD5Sum
	loc.myapp.appsHash = {
		"name" = "MD5Sum",
		"file" = "/usr/bin/md5sum"
	}
	// SHA384
	loc.myapp.appsSHA = {
		"name" = "SHA384Sum",
		"file" = "/usr/bin/sha384sum"
	}
	// IP configuration
	loc.myapp.appsIP = {
		"name" = "IP Configuration",
		"file" = "/sbin/ifconfig"
	}
	// network statistics
	loc.myapp.appsNetstat = {
		"name" = "Netstat",
		"file" = "/bin/netstat"
	}
	// Optimise PNG images
	loc.myapp.appsOptiPng = {
		"name" = "OptiPNG",
		"file" = "/usr/bin/optipng"
	}
	// Netpbm is a collection of 300 converters
	loc.myapp.appsNetpbm = {
		"name" = "Netpbm",
		"file" = "/usr/bin/ilbmtoppm"
	}
	// network ping
	loc.myapp.appsPing = {
		"name" = "Ping",
		"file" = "/bin/ping"
	}
	// symbolic link creator
	loc.myapp.appsSymlink = {
		"name" = "Links",
		"file" = "/bin/ln"
	}
	// pngquant
	loc.myapp.appsPngquant = {
		"name" = "pngquant",
		"file" = "/usr/bin/pngquant"
	}
	// tail
	loc.myapp.appsTail = {
		"name" = "Tail",
		"file" = "/usr/bin/tail"
	}
	// TAR archiver
	loc.myapp.appsTar = {
		"name" = "Tar",
		"file" = "/bin/tar"
	}
	// UNRAR archiver
	loc.myapp.appsUnRar = {
		"name" = "RAR decompression",
		"file" = "/usr/bin/unrar"
	}
	// uptime
	loc.myapp.appsuptime = {
		"name" = "Uptime",
		"file" = "/usr/bin/uptime"
	}
	// Webp image convertor
	loc.myapp.appsWebp = {
		"name" = "CWebP",
		"file" = "/usr/bin/cwebp"
	}
	// ZIP archiver information
	loc.myapp.appsZipInfo = {
		"name" = "ZIP information",
		"file" = "/usr/bin/zipinfo"
	}
	// ZIP Unarchiver
	loc.myapp.appsZipUn = {
		"name" = "ZIP decompression",
		"file" = "/usr/bin/unzip"
	}
</cfscript>