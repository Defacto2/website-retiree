<!---
  	Send your files "thumbnail" partial view.
	path: views/upload/_listofthumbs.cfm

@CFLintIgnore
--->
<cfoutput>
	<div id="listthumbnail-container" class="hidden"><!--- none --->
		<div class="panel panel-default">
			<div class="panel-body">
				<img id="newFile-thumbnail1" class="img-thumbnail" title="Thumbnail 1" src="">
				<img id="newFile-thumbnail2" class="img-thumbnail" title="Thumbnail 2" src="">
				<img id="newFile-thumbnail3" class="img-thumbnail" title="Thumbnail 3" src="">
			</div>
		</div>
	</div>
</cfoutput>