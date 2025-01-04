<!---
  	Help index view.
	path: views/help/index.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Help'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
		<span class="hidden">
			<!--- used by javascript pagination, should be kept hidden --->
			<button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='creativeCommons')#"></button>
			<button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
		</span>
	</form>
	<div class="readable-text" id="help-controller">
		<div class="panel panel-default">
			<div class="panel-heading">Links</div>
<div class="list-group">
  <a href="#URLFor(controller="Help", action="creativeCommons")#" class="list-group-item">
    <h4 class="list-group-item-heading">Copyright</h4>
    <p class="list-group-item-text">Learn about the flexable Creative Commons (web)site licence and how to use it.</p>
  </a>
  <a href="#URLFor(controller="Help", action="privacy")#" class="list-group-item">
    <h4 class="list-group-item-heading">Privacy</h4>
    <p class="list-group-item-text">Read our policy with the intent to not track you.</p>
  </a>
  <a href="#URLFor(action="browserSupport")#" class="list-group-item">
    <h4 class="list-group-item-heading">Browsers</h4>
    <p class="list-group-item-text">Which browsers does the site support?</p>
  </a>
  <a href="#URLFor(route="html3")#" class="list-group-item">
    <h4 class="list-group-item-heading">Text mode</h4>
    <p class="list-group-item-text">Visit the low-bandwidth, HTML3 variant of this site.</p>
  </a>
  <a href="#URLFor(controller="Help", action="keyboard")#" class="list-group-item">
    <h4 class="list-group-item-heading">Short-cuts</h4>
    <p class="list-group-item-text">Keyboard pagination navigation short-cuts.</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/Can-I-batch-download-the-files" class="list-group-item">
    <h4 class="list-group-item-heading">Batch downloads</h4>
    <p class="list-group-item-text">Learn how to queue multiple downloads.</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/What-are-DOS-Programs" class="list-group-item">
    <h4 class="list-group-item-heading">DOS programs</h4>
    <p class="list-group-item-text">What are MS-DOS, PC-DOS and other 16-bit era PC applications?</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/How-to-run-DOS-programs" class="list-group-item">
    <h4 class="list-group-item-heading">Run DOS programs</h4>
    <p class="list-group-item-text">Learn to run MS-DOS, PC-DOS and other 16-bit era PC applications on modern systems.</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/What-are-RAR-7z-ZIP-ACE-files" class="list-group-item">
    <h4 class="list-group-item-heading">Compressed files</h4>
    <p class="list-group-item-text">Learn about files using RAR, 7z, ZIP and ACE file extensions.</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/What-are-the-best-tools-for-viewing-and-editing-NFO-DIZ-files" class="list-group-item">
    <h4 class="list-group-item-heading">NFO and DIZ files</h4>
    <p class="list-group-item-text">The best tools for viewing or editing NFO and DIZ files.</p>
  </a>
  <a href="#URLFor(controller="Help",action="viruses")#" class="list-group-item">
    <h4 class="list-group-item-heading">Trojans and software viruses</h4>
    <p class="list-group-item-text">Why do some files trigger virus or threat alerts on modern systems?</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/Troubleshoot-d3drm.dll" class="list-group-item">
    <h4 class="list-group-item-heading">D3DRM.DLL</h4>
    <p class="list-group-item-text">What is it and where can it be safely obtained?</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/Troubleshoot-npmod32.dll" class="list-group-item">
    <h4 class="list-group-item-heading">NPMOD32.DLL</h4>
    <p class="list-group-item-text">What is it and where can it be safely obtained?</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/Troubleshoot-runtime-error-200" class="list-group-item">
    <h4 class="list-group-item-heading">Runtime error 200</h4>
    <p class="list-group-item-text">Learn how to fix this DOS error.</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/Troubleshoot-shrinker.err" class="list-group-item">
    <h4 class="list-group-item-heading">Shinker.err Dispatcher initialization error</h4>
    <p class="list-group-item-text">Learn how to fix this Windows program error.</p>
  </a>
  <a href="#URLFor(controller="Upload",action="index")#" class="list-group-item">
    <h4 class="list-group-item-heading">Send us files</h4>
    <p class="list-group-item-text">Use our upload web application to submit files you think we should host.</p>
  </a>
  <a href="#URLFor(controller="Help",action="allowedUploads")#" class="list-group-item">
    <h4 class="list-group-item-heading">Allowed files</h4>
    <p class="list-group-item-text">A list of permitted file types that the upload web application accepts.</p>
  </a>
  <a href="https://github.com/Defacto2/defacto2-website/wiki/Wanted-uploads" class="list-group-item">
    <h4 class="list-group-item-heading">Wanted files</h4>
    <p class="list-group-item-text">A list of lost files that we are hunting.</p>
  </a>
  <a href="#URLFor(controller="Help",action="categories")#" class="list-group-item">
    <h4 class="list-group-item-heading">Tags and platforms</h4>
    <p class="list-group-item-text">A list metadata tags and platforms used for sorting the file collection.</p>
  </a>
</div>
		</div>
	</div>
</cfoutput>