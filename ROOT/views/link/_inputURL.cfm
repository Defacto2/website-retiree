<!---
  	Link URL partial view.
	path: views/link/_inputURL.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="form-group form-group-sm">
		<label for="websiteUriRef">URL</label><br>
		<input type="text" class="form-control input-sm" id="websiteUriRef" name="website[uriref]" value="#website.uriref#" maxlength="100" placeholder="http://www.example.com" required>
	</div>
</cfoutput>