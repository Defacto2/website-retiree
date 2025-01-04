<!---
    Preview screenshot partial view.
	path: views/files/_prod_screenshot.cfm

@CFLintIgnore
--->
<cfscript>
	var link = "/images/#get('myapp').dirPreview#/#fileProd.uuid#"
	var title = "Preview screenshot of the production"
	var exists = fileExists("#get('myapp').fulldirPreview#/#fileProd.uuid#.webp")
</cfscript>
<cfoutput><div class="text-center" style="padding-bottom:1em;">
<a href="#local.link#.png#image.screenshot.disableCache#"><picture>
<cfif local.exists><source srcset="#local.link#.webp#image.screenshot.disableCache#" type="image/webp"></cfif>
<img src="#local.link#.png#image.screenshot.disableCache#" class="img-responsive img-thumbnail" alt="#local.title#" title="#local.title#">
</picture></a>
</div></cfoutput>