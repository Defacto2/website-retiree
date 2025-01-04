<!---
	Hardware and system interactions functions
	path: views/helpers-system.cfm

@CFLintIgnore EXCESSIVE_FUNCTIONS,AVOID_USING_CFEXECUTE_TAG,GLOBAL_VAR,UNUSED_LOCAL_VARIABLE,LOCAL_LITERAL_VALUE_USED_TOO_OFTEN
--->
<cfscript>
	var error = "error"
	var applicationDomain = application.domain
	var localHost = cgi.local_host
	var productionHost = application.productionHost
	var httpRefer = cgi.http_referer
	var httpHost = cgi.http_host

	/**
	 * Returns true if server is running on the operating system Windows by Microsoft.
	 */
	variables.isWindows = function() {
		if(server.os.name contains "Windows") return true;
		return false;
	}

	/**
	* Creates an absolute URL to a locally mirrored hosted website.
	*/
	public string function linkExpand(required string uri="", required string key="") {
		var path = arguments.uri
		// trim excess forward slashes
		if(Left(Reverse(path),1) == "/") path = Mid(path,1,Len(path)-1);
		if(arguments.key == "document") {
			if(!Find(":",website.uriRef)) return 'http://#applicationDomain#/waybackdoc/#path#'
			return path
		}
		if(arguments.key == "wayBack") return 'http://#applicationDomain#/waybackweb/#path#'
		return path
	}

	/**
	* Creates a HTML chart using a supplied percentage value.
	* @percentage A number between 0 and 100.
	* @verbose Label to append to the chart.
	*/
	public string function chartbargraph(required string percentage="0", string verbose="free") {
		var html = ""
		var perc = arguments.percentage
		var decimal = 0.01
		if(!IsNumeric(perc)) perc = 1;
		else if(perc lt 1) perc = 1;
		else if (perc gte 100) perc = 100;
		decimal = (perc / 100)
		html = '<div class="bargraphchart"><div class="stretchbarred">'
		html &= '<div class="stretchbargreen" style="width:#(20*decimal)#em;"></div>'
		html &= '</div> #perc#% #arguments.verbose#.</div>'
		return html;
	}

	/*
	 * Layout other
	 */

	/**
	* Determines if a file is allowed to be viewed in the client's browser as a raw file.
	* @string File name.
	*/
	public boolean function useViewFile(required string filename, numeric filesize=0, string platform="") {
		var file = arguments.filename
		var ext = fileExtension(file)
		if(!arguments.filesize) return false;
		if(arguments.platform == "") return false;
		if(IsArchive(file)) return false;
		if(IsProgram(file)) return false;
		// checks
		if(ListFindNoCase("ansi,pcb,text,textamiga",arguments.platform)) return true;
		if(ListFindNoCase("pdf",arguments.platform)) return true;
		if(ListFindNoCase("png,jpg,jpeg,gif",ext)) return true;
		if(ListFindNoCase("htm,html",ext)) return true;
		if(ListFindNoCase(get(myapp).acceptedAudio,ext)) return true;
		if(ListFindNoCase(get(myapp).acceptedVideos,ext)) return true;
		return false;
	}

	/*
	 * User access
	 */

	/**
	* Checks the HTTP referrer value against allowed domains and returns true if valid.
	*/
	public boolean function refererCheck() {
		// if enabled then ignore the source of the download request
		if(get("siteAreas").directDownloads) return true;
		// check if the referral is local
		if(localHost != productionHost) return true;
		if(ListLen(httpRefer,'/') lt 2) return true;
		// check that referrer is from hosted server
		if(ListGetAt(httpRefer,2,'/') == httpHost) return true;
		// download requests from external server referrals are disabled
		return false;
	}

 	/**
 	 * Returns hardware information on the server's CPU
 	 */
 	public struct function serverCPU() {
		var windows = function() {
			try {
	 			// fetch cpu info
	 			exe.args = "cpu get name,CurrentClockSpeed,MaxClockSpeed,NumberOfCores,L2CacheSize,L3CacheSize,Manufacturer /value"
		 		cfexecute(
					variable = "exe.stdout",
					name = get(myapp).appshardwareinfo.file,
					arguments = exe.args,
					timeout = 10
				);
		 		// convert execute reply into a structure
				exe.stdout = Replace(Trim(exe.stdout),Chr(10),'=','all')
				cpu.cache = Trim(ListGetAt(exe.stdout,4,'=')) + Trim(ListGetAt(exe.stdout,6,'=')) & " Kb"
				cpu.cores = Trim(ListGetAt(exe.stdout,14,'='))
				cpu.manufacture = Trim(ListGetAt(exe.stdout,8,'='))
				cpu.name = Trim(ListGetAt(exe.stdout,12,'='))
				cpu.speedmax =  Trim(ListGetAt(exe.stdout,10,'=')) & " MHz"
	 		}
	 		catch(any err) {}
		}
		var cpu = { "cache": "", "cores": 1, "manufacture": "", "name": "", "speedmax": "" }
		var exe = { "args":"", "stdout":"" }
 		if(isWindows()) {
			windows()
			return
	 	}
		// fetch cpu core info
		try {
			exe.args = '"core id" /proc/cpuinfo'
			cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			cpu.cores = ArrayLen(REMatch(":", exe.stdout))
			if(!cpu.cores) cpu.cores = 1;
		}
		catch(any err) {}
		// fetch cpu cache size info
		try {
			exe.args = '-m 1 "cache size" /proc/cpuinfo'
			cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			if(cpu.cores > 1) cpu.cache = Fix(cpu.cores * Val(Trim(ListGetAt(exe.stdout,2,':')))) & " Kb";
			else cpu.cache = Fix(Val(Trim(ListGetAt(exe.stdout,2,':')))) & " Kb";
		}
		catch(any err) {}
		// fetch cpu manufacture info
		try {
			exe.args = '-m 1 vendor_id /proc/cpuinfo'
			cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			cpu.manufacture = Trim(ListGetAt(exe.stdout,2,':'))
		}
		catch(any err) {}
		// fetch cpu name info
		try {
			exe.args = '-m 1 "model name" /proc/cpuinfo'
			cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			cpu.name = Trim(ListGetAt(exe.stdout,2,':'))
		}
		catch(any err) {}
		// fetch cpu speed info
		try {
			exe.args = '-m 1 "cpu MHz" /proc/cpuinfo'
			cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			cpu.speedmax = Fix(cpu.cores * Trim(ListGetAt(exe.stdout,2,':'))) & " MHz"
		}
		catch(any err) {}
	 	return cpu
 	}

	/**
	* Returns usage and free space information on the drive hosting the CFML server.
	*/
 	public struct function serverDisk() {
		var drive = { "free":"", "freepercentage":"", "partition":"", "total":"", "used":"", "usedpercentage":"" }
		var exe = { "args":"/", "stdout":"" }
 		// arguments for disk free utility
 		if(isWindows()) exe.args = ListGetAt(getbasetemplatepath(), 1, '#server.separator.file#'); // return Windows root
 		// fetch drive information using disk free utility
 		try {
	 		cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appsDiskFree.file,
				arguments = exe.args,
				timeout = 10
			);
	 		// convert disk free reply into a structure
	 		exe.stdout = Replace(exe.stdout,' ','|','all')
	 		drive.partition = ReplaceNoCase(ListGetAt(exe.stdout,7,'|'), "on", "")
	 		drive.free = Val(ListGetAt(exe.stdout,10,'|'))
	 		drive.freepercentage = Ceiling((Val(ListGetAt(exe.stdout,10,'|'))/Val(ListGetAt(exe.stdout,8,'|'))*100))
	 		drive.total = Val(ListGetAt(exe.stdout,8,'|'))
	 		drive.used = Evaluate("#drive.total#-#drive.free#")
	 		drive.usedpercentage = Val(Replace(ListGetAt(exe.stdout,11,'|'),'%','','all'))
	 		//drive.reply = exe.stdout // uncomment this to debug
 		}
 		catch(any err) {}
 		return drive
 	}

 	/**
 	 * Returns JAVA server by Oracle information.
 	 */
 	public struct function serverJava() {
 		var java = { "memoryfree":"","memorymax":"","memoryused":"","update":"","version":"" }
 		try {
	 		java.memoryfree = server.java.freeMemory
	 		java.memorymax = server.java.maxMemory
	 		java.memoryused = (server.java.maxMemory-server.java.freeMemory)
	 		java.update = ListGetAt(server.java.version,2,'_')
	 		java.version = "#ListGetAt(server.java.version,2,'.')# #server.java.archModel#-bit (#server.java.vendor#)"
 		}
 		catch(any err) {}
 		return java
 	}

 	/**
 	 * Returns RAM and memory information on the server.
 	 */
 	public struct function serverRAM() {
		var kilo = function(required string value) {
			return Val(Trim(ReplaceNoCase(ListGetAt(arguments.value,2,':'),' kB','')))
		}
		var ram = { "free":"", "freePercent":"", "total":"", "use":"" }
		var exe = { "args":"", "stdout":"" }
 		// fetch free memory physical
 		try {
 			exe.args = '"MemFree" /proc/meminfo'
	 		cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			ram.free = kilo(exe.stdout)
		}
		catch(any err) {}
		// fetch total physical memory
 		try {
 			exe.args = '"MemTotal" /proc/meminfo'
	 		cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appshardwareinfo.file,
				arguments = exe.args,
				timeout = 10
			);
			ram.total = kilo(exe.stdout)
			ram.freePercent = Ceiling(ram.free/ram.total*100)
			ram.use = Fix(ram.total-ram.free)
		}
		catch(any err) {}
	 	return ram
 	}

	/**
	* Returns usage and free space information on the drive hosting the CFML server.
	*/
 	public struct function serverOS() {
		var windows = function() {
	 		// fetch drive information using disk free utility
	 		try {
				exe.args = "os get BuildNumber,Caption,CSDVersion,Version,FreePhysicalMemory,"
				exe.args &= "TotalVisibleMemorySize,TotalVirtualMemorySize,SerialNumber,LastBootUpTime,"
				exe.args &= "InstallDate,FreeVirtualMemory,FreePhysicalMemory,OSArchitecture /value"
		 		cfexecute(
					variable = "exe.stdout",
					name = get(myapp).appshardwareinfo.file,
					arguments = exe.args,
					timeout = 10
				);
		 		sys.exe.stdout = Replace(Trim(exe.stdout),Chr(lineFeed),'=','all')
				sys.caption = Trim(ListGetAt(exe.stdout,4,'='))
				sys.csd = Trim(ListGetAt(exe.stdout,6,'='))
				sys.installed = Trim(ListGetAt(exe.stdout,12,'='))
				sys.architecture = Trim(ListGetAt(exe.stdout,16,'='))
				sys.serial = Trim(ListGetAt(exe.stdout,18,'='))
				sys.version = Trim(ListGetAt(exe.stdout,24,'='))
	 		}
	 		catch(any err) {}
		}
		var sys = { "caption":"", "csd":"", "installed":"",
				"architecture":UCase(server.os.arch), "serial":"", "version":server.os.version }
		var exe = { "args":"", "stdout":"" }
		var lineFeed = 10
 		// arguments for disk free utility
		if(isWindows()) {
			windows()
			return
		}
		// fetch drive information using disk free utility
		try {
			exe.args = "-a"
			cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appsDistro.file,
				arguments = exe.args,
				timeout = 10
			);
			sys.caption = ListLast(ListGetAt(exe.stdout, 1, '#Chr(lineFeed)#'),":") & " "
			sys.caption &= ListLast(ListGetAt(exe.stdout, 3, '#Chr(lineFeed)#'),":") & " "
			sys.caption &= ListLast(ListGetAt(exe.stdout, 4, '#Chr(lineFeed)#'),":")
		}
		catch(any err) {}
 		return sys
 	}

	/**
	 * Returns the time set by the server.
	 */
	public struct function serverTime() {
		var time = {
			"gmt":DateAdd('s',GetTimeZoneInfo().utcTotalOffset,Now())
		}
		return time
	}

	/**
	 * Returns the results of a ifconfig or ipconfig eth0 query on the server
	 */
	public struct function networkIP() {
		var ipconfig = { "console":"", "cmd":"" }
		var exe = { "args":"eth0", "stdout":"" }
		try {
		 	cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appsIP.file,
				arguments = exe.args,
				timeout = 10
			);
			ipconfig.console = exe.stdout
			ipconfig.cmd = "#get(myapp).appsIP.file# #exe.args#"
	 	}
	 	catch(any err) {
	 		ipconfig.console = error
	 	}
	 	return ipconfig
	}

	/**
	 * Returns the results of a server DNS lookup on its own domain
	 */
	public struct function networkDNS() {
		var dns = { "console":"", "cmd":"" }
		var exe = { "args":"-v #application.domain#", "stdout":"" }
		if(isWindows()) exe.args = "#application.domain#";
		try {
		 	cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appsdnslookup.file,
				arguments = exe.args,
				timeout = 10
			);
			dns.console = exe.stdout
			dns.cmd = "#get(myapp).appsdnslookup.file# #exe.args#"
	 	}
	 	catch(any err) {
	 		dns.console = error
	 	}
	 	return dns
	}

	/**
	 * Returns the results of a server ping to google.
	 */
	public struct function networkPing() {
		var ping = { "console":"", "cmd":"" }
		var exe = { "args":"-c 1 www.google.com", "stdout":"" }
		if(isWindows()) exe.args = "www.google.com -n 1";
		try {
		 	cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appsping.file,
				arguments = exe.args,
				timeout = 10
			);
			ping.console = exe.stdout
			ping.cmd = "#get(myapp).appsping.file# #exe.args#"
	 	}
	 	catch(any err) {
	 		ping.console = error
	 	}
	 	return ping
	}

	/**
	 * Returns the results of a server netstat query
	 */
	public struct function networkStat() {
		var netstat = { "console":"", "cmd":"" }
		var exe = { "args":"-lptu", "stdout":"" }
		if(isWindows()) exe.args = "-n -p TCP";
		try {
		 	cfexecute(
				variable = "exe.stdout",
				name = get(myapp).appsnetStat.file,
				arguments = exe.args,
				timeout = 10
			);
			netstat.console = exe.stdout
			netstat.cmd = "#get(myapp).appsnetStat.file# #exe.args#"
	 	}
	 	catch(any err) {
	 		netstat.console = error
	 	}
	 	return netstat
	}
</cfscript>