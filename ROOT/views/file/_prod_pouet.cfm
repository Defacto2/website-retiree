<!---
    Pouet partial view.
	path: views/files/_prod_pouet.cfm

	Sources data from view/upload/lookupDemozoo/88915?m=dump , m=extenalUpload, m=title

@CFLintIgnore
--->
<cfoutput>
<div class="panel panel-info hidden" id="pouetContainer">
	<div class="panel-body" id="pouetPanel">
		<a id="pouetProdLink" href="http://www.pouet.net/prod.php?which=#fileProd.web_id_pouet#"><img id="pouet-logo" src="/images/layout/pouet_16x16_logo.png" height="16" width="16" alt="Pouet" title="Pouet production information"></a>
		<span id="pouetIDValue" class="hide-true">#fileProd.web_id_pouet#</span> &nbsp;
		<span id="pouetVotes" class="nowrap">
			<span title="Positive votes"><i class="fal fa-thumbs-up fa-fw"></i><strong id="pouetVoteUp">?</strong></span>
			<span title="Indifferent votes"><i class="fal fa-meh fa-fw"></i><strong id="pouetVotePiggy">?</strong></span>
			<span title="Negative votes"><i class="fal fa-thumbs-down fa-fw"></i><strong id="pouetVoteDown">?</strong></span>
		</span>
		&nbsp; <span id="pouetVoteAvg" title=""></span>
		<div id="pouetPlacings"></div>
		<small id="pouetCredits"></small>
		<span id="pouetDownloadLinks" class="nowrap"></span>
	</div>
</div>
</cfoutput>