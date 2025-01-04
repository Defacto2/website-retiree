<!---
    Send us files partial view.
	path: views/files/_prod_nav-sendfiles.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="btn-group btn-group-sm btn-group-as-form tablet-hide" title="Go to the file upload form" role="group" data-toggle="tooltip" data-placement="top">
		<button type="submit" aria-label="Send us files" class="btn btn-default" id="upload_btn" formaction="#urlFor(controller='upload',action='index')#" role="group"><i class="fal fa-file-upload fa-lg fa-fw"></i> UPLOADER to include your files</button>
	</div>
</cfoutput>