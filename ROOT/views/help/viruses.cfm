<!---
  	Why do you offer viruses help view.
	path: views/help/viruses.cfm

@CFLintIgnore
--->
<cfscript>
	param name="param.extlink" default="" type="string";
	extlink = [
		'https://www.virustotal.com/en/file/1cc1d810503a9ae3f065251c3d14c59304e0adea0bdf00d2338686567d8ca936/analysis/1390700598/',
		'https://www.virustotal.com/en/file/6404901762fec0bdee30b9b04a15289c816dac54a7c2aa2434f12e54968d2880/analysis/1391469350/',
		UrlFor(route="f",key="a43f52"),
		UrlFor(route="f",key="ae3d83"),
		UrlFor(route="f",key="a12f23")]
	pageAbout.text = 'Trojans and software viruses'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='keyboard')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='allowedUploads')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
	</span>
  </form>
	<div class="readable-text" id="help-controller">
		<p class="lead text-center">We never intentionally distribute viruses, trojans or any form of malware.</p>
		<p>
		Unfortunately current virus scanning software using their default setups employ a scan and detection technique known as heuristic scanning.
		In addition to the standard scanning for malware code using a blacklist, heuristic scanning looks at the program for malware-like behaviour.
		Many scene intros and cracktros implement self-decrypting and decompressing techniques which unfortunately is standard behaviour for malware that is attempting to infect your system.
		</p>
		<p>
		Scanning for behaviour is never going to be 100% accurate, and an over sensitive heuristic scan can report what are known as false positives.
		Where a scan has incorrectly claimed, there is a potential threat but cannot pinpoint what that threat is and instead gives it a generic name.
		</p>
		<p>
		Some files offered on #get('siteAreas').titles.df2# are listed as a possible virus or trojan threat, and this is why.
		We do not believe they are dangerous, but some virus scanners are reporting otherwise.
		</p>
		<blockquote>
			<p>
				An example of these false positive detections is an installation program Class created in 2000.
				It is compressed and encrypted using an arcane executable package called Shrinker.
				Many virus scanners do not recognise this legacy technique and flag it as suspicious.
			</p>
			<p>
				The #linkTo(text="unmodified version of the Class installer",href=extlink[3])# triggers alerts with #linkTo(text="over 20 virus scanners",href=extlink[1])#.
			</p>
			<p>
				Using #linkTo(text="Deshrink",href=extlink[5])# we #linkTo(text="remove the Shrinker encryption and compression",href=extlink[4])# used on the program executable, and #linkTo(text="there are no virus scanner alerts triggered",href=extlink[2])#.
			</p>
			<footer class="text-left">Real world example</footer>
		</blockquote>
		#includePartial('externallinks')#
	</div>
</cfoutput>