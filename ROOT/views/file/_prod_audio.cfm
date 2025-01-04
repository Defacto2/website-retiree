<!---
	In-browser music player partial view.
	path: views/files/_prod_audio.cfm

@CFLintIgnore
--->
<cfscript>
	var audioLink = {
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
				<audio controls loop>
					<source src="#URLFor(argumentCollection=audioLink)#" type="audio/mpeg">
					Your browser does not support the audio player.
				</audio>
				<figcaption>#linkTo(argumentCollection=audioLink)#</figcaption>
			</figure>
		</div>
	</div>
</cfoutput>