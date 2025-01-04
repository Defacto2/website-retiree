<!---
    Dosee, MS-DOS in JS emulator partial view.
	path: views/files/_prod_dosee.cfm

@CFLintIgnore
--->
<cfscript>
	param name="fileContentList" default="";
	var machineModes = function() {
		params.dosmachine eq "svga"
		switch(params.dosmachine) {
			case "cga":
			case "ega":
			case "vga":
			case "tandy":
				return "640,400"
			case "svga":
				return "640,480"
			case "herc":
				return "720,350"
			default:
				return "640,480"
		}
	}
	var init = function() {
		// Base resolution
		variables.dos.resolution = machineModes()
		// See File.cfc under Detail() function to adjust DOSee selections
		variables.dos.labelCPU = ["<u>automatic</u>","maximum","medium","slow"]
	 	variables.dos.labelAudio = ["Gravis Ultrasound","<u>Sound Blaster 16</u>","Sound Blaster 1.0","Covox","none"]
	 	variables.dos.labelGraphics = ["SuperVGA","<u>VGA</u>","EGA","Tandy","CGA","Hercules"]
	}
	var doseeHeader = function() {
		variables.dosPanel = {
			"class":'panel-default',
			"warning":'',
		}
		if(dos.isBrokenExe) {
			dosPanel.class = 'panel-warning';
			dosPanel.warning = 'This file does not emulate correctly';
			return
		}
		if(dos.isBrokenZip) {
			dosPanel.class = 'panel-info';
			dosPanel.warning = '<small>For compatibility the mounted archive has been re-compressed</small>';
			return
		}
	}
	init()
	doseeHeader()
	var href = '#dos.pubkey#?'
	if(cgi.script_name == '/index.cfm') href = '/index.cfm?'
</cfscript>
<cfoutput>
	<a id="emulator"></a>
	<div class="panel #dosPanel.class#">
		<div class="panel-heading">
			#dosPanel.warning#
			<noscript>This emulator depends on JavaScript, <a href="#XMLFormat(dosee.url)#">please turn off the Software Emulation</a> to improve your experience.</noscript>
			<cfif opCheck('coop')>
				<button type="button" class="btn text-uppercase">Start <kbd class="text-uppercase">Ctrl+Alt+▼</kbd></button>
				&nbsp;
				<button type="button" class="btn text-uppercase">Stop <kbd class="text-uppercase">Ctrl+Alt+End</kbd></button>
			</cfif>
		</div>
		<div class="panel-body">
			<p class="clearfix row">
				<small class="col-lg-6">#svg(icon='dosee')#Emulating <var>#dos.startExe#</var> in DOSee.</small><cfif opCheck('coop')>
				<span class="col-lg-6 text-right"><button type="button" id="doseeCaptureUpload" class="btn btn-primary" title="Capture and upload a screenshot" data-toggle="tooltip" data-placement="top" disabled><i class="fal fa-camera fa-fw fa-lg"></i><i class="fal fa-upload fa-fw fa-lg"></i> &nbsp; <kbd class="text-uppercase">Ctrl+Alt+▲</kbd></button></span></cfif>
			</p>
			<div id="doseeCrashed" class="alert alert-danger" role="alert">Unfortunately the emulator crashed<br><small>This browser may not be capable of running the emulator, you could try <a href="https://www.mozilla.org/en-US/firefox/new/">Firefox</a> or <a href="https://www.google.com/chrome/browser">Chrome</a></small></div>
			<div id="doseeError"></div>
			<div id="doseeContainer">
				<canvas id="doseeCanvas" tabindex="0" style='width:#listFirst(dos.resolution)#px; height:#listLast(dos.resolution)#px'></canvas>
			</div>
			<form method="get">
				<cfif CGI.script_name is "/index.cfm">
					<input type="hidden" name="controller" value="#lCase(params.controller)#">
					<input type="hidden" name="action" value="#lCase(params.action)#">
					<input type="hidden" name="key" value="#lCase(params.key)#">
				</cfif>
				<input type="hidden" name="name" value="#params.name#">
				<cfif len(params.src)>
					<input type="hidden" name="src" value="#params.src#">
				</cfif>
				<input type="hidden" name="platform" value="#params.platform#">
				<input type="hidden" name="section" value="#params.section#">
				<input type="hidden" name="sort" value="#params.sort#">
				<div>
					<!-- Nav tabs -->
					<ul class="nav nav-tabs" role="tablist" id="doseeTabs">
						<li id="doseeInstructTab" role="presentation" class="tabtoggle active"><a href="##doseeInstruct" aria-controls="doseeInstruct" role="tab" data-toggle="tab">Instructions</a></li>
						<li id="doseeHardwareTab" role="presentation" class="tabtoggle"><a href="##doseeHardware" aria-controls="doseeHardware" role="tab" data-toggle="tab">Hardware</a></li>
						<li id="doseeOptionsTab" role="presentation" class="tabtoggle"><a href="##doseeOptions" aria-controls="doseeOptions" role="tab" data-toggle="tab">Options</a></li>
						<li id="doseeHelpTab" role="presentation" class="tabtoggle"><a href="##doseeHelp" aria-controls="doseeHelp" role="tab" data-toggle="tab">Help</a></li>
						<li id="doseeInfoTab" role="presentation" class="tabtoggle"><a href="##doseeInfo" aria-controls="doseeInfo" role="tab" data-toggle="tab">DOSee</a></li>
						<li role="presentation"><a href="##emulator" aria-controls="emulator" title="Anchor browser to emulator" data-toggle="tooltip" data-placement="top"><i class="fal fa-align-center"></i></a></li>
						<li role="presentation" id="doseeFullScreen" class="hide-true"><a href="##emulator" aria-controls="doseeCanvas" title="Go full screen" data-toggle="tooltip" data-placement="top"><i class="fal fa-expand-arrows"></i></a></li>
						<li role="presentation" id="doseeCaptureScreen" class="hide-true"><a href="##emulator" aria-controls="doseeCanvas" title="Capture and save screenshot" data-toggle="tooltip" data-placement="top"><i class="fal fa-camera-alt fa-fw"></i></a></li>
						<li role="presentation" id="doseeReboot" name="doseeReboot" class="hide-true"><a href="##emulator" aria-controls="doseeCanvas" title="Reload the browser tab" data-toggle="tooltip" data-placement="top"><i class="fal fa-redo fa-fw"></i></a></li>
						<li role="presentation" id="doseeExit" class="hide-true"><a href="##emulator" aria-controls="doseeCanvas" title="Stop the emulation" data-toggle="tooltip" data-placement="top"><i class="fal fa-power-off fa-fw"></i></a></li>
						<li role="presentation" id="doseeHalted" class="hide-true"><a class="brand-danger"><i class="fal fa-stop fa-fw"></a></i></li>
					</ul>
					<!-- Tab panes -->
					<div class="tab-content gray-dark" id="doseeTabContent">
						<div role="tabpanel" class="tab-pane active" id="doseeInstruct">
							<!--- Hard code instructions by ID --->
							<p>Use these tabs to make adjustments to the emulation</p>
							<cfif ListFindNocase("a727bca;ad40a2;a82bae;", dos.pubkey,";")>
								<hr><p>When prompted select <kbd>EGA</kbd>.</p>
							<cfelseif ListFindNocase("ae282bc;", dos.pubkey,";")>
								<hr><p class="text-warning">When prompted for <em>Choose Computer</em> <u>DO NOT</u> select <kbd>6</kbd> <em>486DX2/66</em>.</p>
								<p><em>Choose Sounddevice</em> <kbd>1</kbd> <em>Soundplayer LPT1</em></p>
							<cfelseif ListFindNocase("ab1a980;", dos.pubkey,";")>
								<hr><p><em>Want to use last setup</em> <kbd>N</kbd></p>
								<p><em>Select Music device:</em> <kbd>2</kbd> <em>Covox Speech Thing</em></p>
								<p><em>Select port:</em> <kbd>1</kbd> <em>LPT1</em></p>
								<p><em>Select system:</em> <kbd>6</kbd> <em>386 - 33MHz</em></p>
								<p><em>Select video adapter:</em> <kbd>5</kbd> <em>VGA</em></p>
							<cfelseif ListFindNocase("b42e578;", dos.pubkey,";")>
								<hr><p><em>Music Output:</em> <kbd>1</kbd> <em>Covox in LPT1</em></p>
								<p><em>Machine Speed:</em> <kbd>6</kbd> <em>386DX 33</em></p>
								<p><small class="text-warning">Sound Blaster support is broken</small></p>
							<cfelseif ListFindNocase("b530a08;", dos.pubkey,";")>
								<hr><p><em>Select output device</em> <kbd>3</kbd> <em>Sound player, STEREO</em></p>
								<p><small class="text-warning">Sound Blaster support is broken</small></p>
							<cfelseif ListFindNocase("a57c2;", dos.pubkey,";")>
								<hr><p><em>Are you using a PC Speaker</em> <kbd>N</kbd></p>
								<p><em>Soundplayer / Covox speechthing / Disney Sound Source in LPT1</em> <kbd>1</kbd></p>
								<p><em>62799 Hz</em> <kbd>H</kbd></p>
							<cfelseif dos.pubkey eq "ac1f348">
								<hr><p>When prompted type in <kbd>378</kbd> and press <kbd>Enter</kbd> for your <em>outport(in hex)</em></p>
							<cfelseif dos.pubkey eq "a04ed">
								<hr><p>When prompted select <kbd>N</kbd> for <em>special font</em>, <kbd>Y</kbd> <kbd>default colors</kbd> and <kbd>N</kbd> <u>for <kbd>VGA</kbd></u></p>
							<cfelseif !dos.noAudio and listFindNocase(";sb1;sb16;",params.dosaudio,";",true)>
								<hr><p><b>Sound Blaster</b> audio settings, address/port <kbd>220</kbd> <small>IRQ</small> <kbd>7</kbd> <small>DMA</small> <kbd>1</kbd>
									<cfif params.dosaudio is "sb16" or params.dosaudio is ""><em>Sound Blaster 16</em> <small>DMA</small> <kbd>5</kbd></cfif>
								</p>
							<cfelseif params.dosaudio is "gus">
								<hr><p><b>Gravis Ultrasound (GUS)</b> audio settings, port <kbd>240</kbd> <small>IRQ</small> <kbd>5</kbd> <small>DMA</small> <kbd>1</kbd></p>
							<cfelseif params.dosaudio is "covox">
								<hr><p><b>Covox</b> audio settings, port <kbd>LPT1</kbd></p>
								<p><span class="text-muted">Also branded as a</span> <em>DA Converter</em>, <em>Sound Player</em>, <em>Covox Speech Thing</em>, <em>Disney Sound Source</em></p>
							<cfelse>
							</cfif>
							<p id="doseeSlowLoad"><small class="text-warning"> If the emulation is taking too long to load, <a href="#XMLFormat(dosee.url)#">you can turn it off</a>.</small></p>
							<cfif params.dosutils == false>
							<cfset local.dpQryStr = emulatorParams("dosutils","true", cgi.query_string, true)>
							<cfset dpQryStr = emulatorParams("dosautorun","false", dpQryStr, true)>
							<hr>
							<p><small><a href="#href##dpQryStr#">Reload DOSee to launch the DOS prompt</a></small></p>
							<cfelseif len(dos.startExe)>
							<cfset local.dpQryStr = emulatorParams("dosutils","false", cgi.query_string, true)>
							<cfset dpQryStr = emulatorParams("dosautorun","true", dpQryStr, true)>
							<hr>
							<p><small><a href="#href##dpQryStr#">Reload DOSee to autorun <var>#dos.startExe#</var></a></small></p>
							</cfif>
						</div>
						<div role="tabpanel" class="tab-pane" id="doseeHardware">
							<p>Applying changes will reload the page and reboot the emulator</p>
							<hr>
							<!--- CPU --->
							<div class="form-group">
								<label for="inputEmail3" class="col-md-12 col-lg-2 control-label">CPU Speed</label>
								<div class="col-md-12 col-lg-10">
									<div class="radio">
										<label class="radio-inline">
											<input type="radio" name="dosspeed" id="dosspeed2" value="max"> #dos.labelCPU[2]# <small class="text-muted">(80486)</small>
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosspeed" id="dosspeed3" value="386"> #dos.labelCPU[3]# <small class="text-muted">(80386)</small>
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosspeed" id="dosspeed4" value="8086"> #dos.labelCPU[4]# <small class="text-muted">(8086)</small>
										</label>
										<br>
										<label class="radio-inline">
											<input type="radio" name="dosspeed" id="dosspeed1" value="auto"> #dos.labelCPU[1]#
										</label>
									</div>
								</div>
							</div>
							<!--- Graphics/Machine --->
							<div class="form-group">
								<label for="inputEmail3" class="col-md-12 col-lg-2 control-label">Graphics</label>
								<div class="col-md-12 col-lg-10">
									<div class="radio">
										<label class="radio-inline">
											<input type="radio" name="dosmachine" id="dosmachine1" value="svga"> #dos.labelGraphics[1]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosmachine" id="dosmachine2" value="vga"> #dos.labelGraphics[2]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosmachine" id="dosmachine3" value="ega"> #dos.labelGraphics[3]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosmachine" id="dosmachine4" value="tandy"> #dos.labelGraphics[4]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosmachine" id="dosmachine5" value="cga"> #dos.labelGraphics[5]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosmachine" id="dosmachine6" value="herc"> #dos.labelGraphics[6]#
										</label>
									</div>
								</div>
							</div>
							<!--- Audio --->
							<div class="form-group">
								<label for="inputEmail3" class="col-md-12 col-lg-2 control-label">Audio</label>
								<div class="col-md-12 col-lg-10">
									<div class="radio">
										<label class="radio-inline">
											<input type="radio" name="dosaudio" id="dosaudio1" value="gus"> #dos.labelAudio[1]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosaudio" id="dosaudio4" value="covox"> #dos.labelAudio[4]#<small class="text-muted">/Disney Sound Source/DA Converter</small>
										</label>
										<br>
										<label class="radio-inline">
											<input type="radio" name="dosaudio" id="dosaudio2" value="sb16"> #dos.labelAudio[2]#
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosaudio" id="dosaudio3" value="sb1"> #dos.labelAudio[3]#
										</label>
										<br>
										<label class="radio-inline">
											<input type="radio" name="dosaudio" id="dosaudio5" value="none"> #dos.labelAudio[5]#
										</label>
									</div>
								</div>
							</div>
							<!--- Apply --->
							<div class="form-group">
								<div class="col-md-12 col-lg-9">
									<div id="helpBlock" class="help-block">
										<span class="nowrap">
											<i class="fal fa-info-circle"></i> Graphics <a href="http://dosbox.com/wiki/Dosbox.conf##.5Bdosbox.5D"><em>DosBOXWiki Machine</em></a>
										</span>&nbsp;
										<span class="nowrap">
											<i class="fal fa-info-circle"></i> Audio <a href="http://dosbox.com/wiki/Sound"><em>DosBOXWiki Sound</em></a>
										</span>
									</div>
								</div>
								<div class="col-md-12 no-padding">
									<button type="submit" class="btn btn-primary" id="inputHelpBlock" aria-describedby="helpBlock">Apply changes</button>
								</div>
							</div>
						</div>
						<!--- Options --->
						<div role="tabpanel" class="tab-pane" id="doseeOptions">
							<p class="brand-warning">Changes are not applied until the browser tab is reloaded</p>
							<hr>
							<div class="checkbox">
								<label>
									<input type="checkbox" id="doseeAutoRun"> Automatically start DOS emulation
								</label>
							</div>
							<div class="checkbox">
								<label>
									<input type="checkbox" id="doseeAspect">
									Dynamic resizing of the DOSee window <small class="text-muted">Allows for sharper fonts and text</small>
								</label>
							</div>
							<!--- Graphics engine --->
							<hr>
							<div class="form-group">
								<label for="inputEmail3" class="col-sm-12 control-label">SuperVGA real-time graphic effect<br>
									<small class="text-danger" id="svgaEffectsMsg">Only works when Hardware 🡒 Graphics = SuperVGA</small>
									<small class="text-warning hidden" id="highResRequired">The effects only work on DOS software that use 640*480 or higher native resolutions</small>
								</label>
								<div class="col-sm-12">
									<div class="radio">
										<label class="radio-inline">
											<input type="radio" name="dosscale" id="dosscale0" value="none"> None
										</label>
										<br>
										<label class="radio-inline">
											<input type="radio" name="dosscale" id="dosscale5" value="advinterp3x"> Advanced interpolation <small class="text-muted">advinterp3x</small>
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosscale" id="dosscale4" value="hq3x"> High Quality 3 magnification <small class="text-muted">hq3x</small>
										</label>
										<br>
										<label class="radio-inline">
											<input type="radio" name="dosscale" id="dosscale3" value="rgb3x"> RGB <small class="text-muted">rgb3x</small>
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosscale" id="dosscale1" value="super2xsai"> Super scale and interpolation <small class="text-muted">super2xsai</small>
										</label>
										<label class="radio-inline">
											<input type="radio" name="dosscale" id="dosscale2" value="tv3x"> Television <small class="text-muted">tv3x</small>
										</label>
									</div>
								</div>
							</div>
							<div id="helpBlock" class="help-block">
								<p><i class="fal fa-info-circle"></i> <a href="https://dosbox.com/wiki/Scaler">Graphic effect comparisons</a></p>
							</div>
						</div>
						<!--- Help --->
						<div role="tabpanel" class="tab-pane" id="doseeHelp">
							<p>DOS programs need a keyboard for user input<br>Some common keys used in DOS programs</p>
							<p>
								<kbd>E<small>NTER</small> ↵</kbd> to <b>select</b> or continue<br>
								<kbd>E<small>SC</small></kbd> to navigate back or <b>exit</b><br>
								<kbd>←</kbd><kbd>→</kbd> <kbd>↑</kbd><kbd>↓</kbd> are often used to <b>navigate</b> menus
							</p>
							<hr>
							<dl>
							<cfif params.dosspeed neq "max">
								<dt>Emulation too slow?</dt>
								<dd><a href="#href##emulatorParams("dosspeed","max", cgi.query_string, true)#">Set the emulator to use <b>maximum CPU</b> speed</a></dd>
								<br>
							</cfif>
							<cfif params.dosspeed neq "8086">
								<dt>Emulation too fast?</dt>
								<cfif fileProd.date_issued_year lte 1993 or params.dosspeed eq "386">
									<dd><a href="#href##emulatorParams("dosspeed","8086", cgi.query_string, true)#">Set the emulator to use the <b>8086 CPU</b> configuration</a></dd>
								<cfelse>
									<dd><a href="#href##emulatorParams("dosspeed","386", cgi.query_string, true)#">Set the emulator to use the <b>386 CPU</b> configuration</a></dd>
								</cfif>
								<br>
							</cfif>
							<cfif params.dosmachine eq "svga">
								<dt>Experiencing graphic or animation glitches?</dt>
								<dd><a href="#href##emulatorParams("dosmachine","vga", cgi.query_string, true)#">Set the emulator to use <b>VGA only</b> graphics configuration</a></dd>
								<br>
							</cfif>
							<cfif !dos.noAudio>
								<dt>Need to turn off the audio?</dt>
								<dd><a href="#href##emulatorParams("dosaudio","none", cgi.query_string, true)#">Disable sound card support</a></dd>
								<br>
							</cfif>
							</dl>
							<cfif !dos.noAudio>
								<dl>
									<dt>Have no audio?</dt>
									<dd>
										<ol>
										<cfif params.dosaudio neq "gus" and fileProd.date_issued_year gte 1994>
											<li><a href="#href##emulatorParams("dosaudio","gus", cgi.query_string, true)#">Try <b>Gravis Ultrasound</b> hardware</a></li>
										<cfelseif params.dosaudio eq "gus">
											<li><a href="#href##emulatorParams("dosaudio","sb16", cgi.query_string, true)#">Try <b>SoundBlaster 16</b> hardware</a></li>
										<cfelseif fileProd.date_issued_year lte 1993>
											<cfif params.dosaudio neq "sb1">
												<li><a href="#href##emulatorParams("dosaudio","sb1", cgi.query_string, true)#">Try <b>SoundBlaster 1.0</b> hardware</a></li>
											</cfif>
											<cfif params.dosaudio neq "covox">
												<li><a href="#href##emulatorParams("dosaudio","covox", cgi.query_string, true)#">Try <b>Covox Sound Master</b> hardware</a></li>
											</cfif>
										</cfif>
										<li>The song or audio file maybe missing from the program</li>
										<cfif (fileProd.date_issued_year lte 1994 or fileProd.date_issued_year is "")>
											<li><p><u>Audio may not be supported</u><br><small class="help-block">Unlike other systems of the era, audio for DOS was unfortunately complicated for both programmers and end users alike. A lot of early scene software didn't bother including it. While those that did often didn't test it on all the hardware they supposedly supported.</small></p></li>
										</cfif>
										</ol>
									</dd>
								</dl>
								<hr>
							</cfif>
						</div>
						<!--- DOSee info --->
						<div role="tabpanel" class="tab-pane" id="doseeInfo">
							<p>
								<strong><a href="https://github.com/bengarrett/DOSee">DOSee</a></strong> pronounced <em>dos/see</em>, is our emulator used to run MS-DOS based software in your web browser.
							</p>
							<p>
								<strong><a href="https://en.wikipedia.org/wiki/MS-DOS">MS-DOS</a></strong> <em>(Microsoft DOS) was the primary operating system used by PCs during the 1980s to the early 1990s and is the precursor to Microsoft Windows.</em>
							</p>
							<hr>
							<p>
								<strong><a href="https://github.com/bengarrett/DOSee">DOSee</a></strong> is a slimmed down, modified port of <strong>The Emularity</strong>.
							</p>
							<p>
								<strong><a href="https://github.com/db48x/emularity">The Emularity</a></strong> is a multi-platform JavaScript emulator that supports the running of software for legacy computer platforms in a web browser. It is the same platform that's running emulation on the <a href="https://archive.org/">Internet Archive</a>.
							</p>
							<p>
								<strong><a href="https://github.com/dreamlayers/em-dosbox">EM-DOSBox</a></strong> is a discontinued, high-performance JavaScript port of <strong>DOSBox</strong> that is applied by The Emularity for its emulation of the MS-DOS platform.
							</p>
							<p>
								DOSee uses <strong>BrowserFS <a href="https://github.com/jvilk/BrowserFS">ZipFS</a></strong> and <strong><a href="https://github.com/jvilk/browserfs-zipfs-extras">ZipFS Extras</a></strong> to simulate zip file archives as hard disks within EM-DOSBox.
							</p>
							<p>
								<strong><a href="https://dosbox.com/">DOSBox</a></strong> is the most popular MS-DOS emulator in use today and is frequently used by commercial game publishers to run games from their back-catalogues on modern computers.
							</p>
							<hr>
							<p><small><a href="https://github.com/bengarrett/DOSee">DOSee</a><span id="doseeVersion"></span>, built on The Emularity, EM-DOSBox and DOSBox. Capture screenshot and save function built on <a href="https://github.com/eligrey/canvas-toBlob.js">canvas-toBlob.js</a>.</small></p>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</cfoutput>