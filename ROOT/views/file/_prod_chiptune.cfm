<!---
	Chiptune, JS music player partial view.
	path: views/files/_prod_chiptune.cfm

@CFLintIgnore
--->
<cfscript>
	var chiptuneLink = {
		"text":fileProd.filename,
		"route":"d",
		"key":obfuscateParam(fileProd.id),
		"params":"filename=#fileProd.filename#",
	}
</cfscript>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title"><i class="fal fa-music fa-fw"></i> #fileProd.record_title#</h3>
		</div>
		<div class="panel-body">
			<figure>
				<div id="chiptune-controls" class="text-center">
					<a id="pause" class="no-href"><div id="chiptunePause" class="hidden"><i class="fal fa-play fa-fw"></i> Pausing chiptune</div></a>
					<a id="play" class="no-href"><div id="chiptunePlay" class="hidden"><i class="fal fa-pause fa-fw"></i> Playing chiptune</div></a>
					<a id="stop" class="no-href"><div id="chiptuneStop"><i class="fal fa-boombox fa-fw"></i> &nbsp; Play the chiptune</div></a>
				</div>
				<figcaption class="text-right">#linkTo(argumentCollection=chiptuneLink)#</figcaption>
			</figure>
		</div>
	</div>
</cfoutput>