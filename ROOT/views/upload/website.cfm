<!---
  	Upload website view.
	path: views/upload/website.cfm

	This view is not public facing.

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Submit a website link or web resource'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<!-- form to submit website links -->
	<div id="uploadController">
	#includePartial("debugOutput")#
	<div class="panel panel-primary panel-limited-double">
		<div class="panel-heading"><i class="fal fa-external-link-square"></i># Link details</div>
		<div class="panel-body">
			#startFormTag(action="submitWebsite",id="form1")#
				<div class="form-group">
					<label for="newSite-uriRef">URL of the web link. <span class='asterisk'>*</span></label>
					<input class="form-control" id="newSite-uriRef" maxlength="255" name="newSite[uriRef]" type="url" placeholder="http://#application.domain#" required>
				</div>
				<div class="form-group">
					<label for="newSite-uriRef">Title of the web link.</label>
					<input class="form-control" id="newSite-title" maxlength="255" name="newSite[title]" type="text" placeholder="#get('siteAreas').titles.df2#">
				</div>
				<div class="form-group">
					<label for="newSite-comment">About this link.</label>
					<textarea class="form-control" id="newSite-comment" name="newSite[comment]" placeholder="A comment or a description"></textarea>
				</div>
				<button type="submit" class="btn btn-default">Send link</button> <span class="asterisk">*</span> required field.
			#endFormTag()#
		</div>
		</div>
	</div>
</cfoutput>