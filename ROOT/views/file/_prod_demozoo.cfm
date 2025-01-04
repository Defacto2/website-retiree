<!---
    Demozoo partial partial view.
	path: views/files/_prod_demozoo.cfm

	Sources data from upload/lookupDemozoo/88915?m=dump , m=extenalUpload, m=title

@CFLintIgnore
--->
<cfoutput>
<div class="panel panel-info hidden" id="demozooContainer">
	<div class="panel-body" id="demozooPanel">
		<span id="demozooIDValue" class="hide-true">#fileProd.web_id_demozoo#</span>
		<a id="demozooProdLink" href="https://demozoo.org/productions/#fileProd.web_id_demozoo#">
			<img id="demozoo-logo" src="/images/layout/demozoo_16x16_logo.png" height="16" width="16" alt="Demzooo" title="Demozoo production information"></a>
		<span id="demozooAuthors"></span>
		<div id="demozooTags"></div>
		<div id="demozooCredits"></div>
		<div><small id="demozooDownloads" class="nowrap"></small></div>
	</div>
</div>
</cfoutput>