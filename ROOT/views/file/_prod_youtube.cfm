<!---
    YouTube video partial view.
	path: views/files/_prod_youtube.cfm

@CFLintIgnore
--->
<cfscript>
	var watch = "https://youtube.com/watch?v=#fileProd.web_id_youtube#"
	//var embed = "https://youtube.com/embed/#fileProd.web_id_youtube#?modestbranding=1&amp;rel=0"
</cfscript>
<cfoutput>
	<div class="panel panel-default file-detail-youtube">
		<div class="embed-responsive embed-responsive-16by9">
			<!--- official YouTube embedded player --->
			<!--- <iframe id="ytplayer" class="embed-responsive-item" src="#local.embed#" allowfullscreen></iframe> --->
			<!--- lite youtube embed https://github.com/paulirish/lite-youtube-embed --->
			<lite-youtube videoid="#fileProd.web_id_youtube#" params="modestbranding=1&amp;rel=0" class="embed-responsive-item" style="max-width: unset;background-image: url('https://i.ytimg.com/vi/#fileProd.web_id_youtube#/hqdefault.jpg');">
			</lite-youtube>
		</div>
		<div class="panel-footer"><i class="fab fa-youtube fa-fw"></i><code><a href="#local.watch#">youtube.com/watch?v=#fileProd.web_id_youtube#</a></code></div>
	</div>
</cfoutput>