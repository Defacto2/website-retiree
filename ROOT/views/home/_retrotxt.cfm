<!---
	RetroTxt from Defacto2 partial view.
	path: views/home/_retrotxt.cfm

@CFLintIgnore
--->
<cfoutput>
<cfscript>
	var retrotxt = {
		"chrome": "https://chrome.google.com/webstore/detail/retrotxt/gkjkgilckngllkopkogcaiojfajanahn",
		"firefox": "https://addons.mozilla.org/en-US/firefox/addon/retrotxt",
		"edge": "https://microsoftedge.microsoft.com/addons/detail/hmgfnpgcofcpkgkadekmjdicaaeopkog",
	}
</cfscript>
	<div class="panel panel-default desktop-only" id="retrotxt-container">
		<div class="panel-body">
		<span id="retrotxt-hide-toggle"><small><a title="Hide RetroTxt information" id="retrotxt_toggle_i"><i class="fal fa-toggle-on gray-darker"></i></a> <a title="Hide RetroTxt information" id="retrotxt_toggle_text">hide</a></small></span>
		<strong id="retrotxt-title">RetroTxt from Defacto2</strong> &nbsp;
		The <a href="https://retrotxt.com" title="Get the source from GitHub" id="retrotxt-gh">open sourced</a> WebExtension to view ANSI, ASCII and NFO files in a browser.
		<span class="nowrap">Addons available from
		<a href="#retrotxt.chrome#" title="Install from the Chrome store" class="rt-black"><i id="retrotxt-gc" class="fab fa-chrome fa-fw"></i>Chrome</a>
		<a href="#retrotxt.edge#" title="Install from the Microsoft store" class="rt-black"><i id="retrotxt-ms" class="fab fa-edge fa-fw"></i>Microsoft</a>
		<a href="#retrotxt.firefox#" title="Install from the Mozilla Add-on page" class="rt-black"><i id="retrotxt-ff" class="fab fa-firefox fa-fw"></i>Firefox</a>
		</span></div>
	</div>
</cfoutput>
