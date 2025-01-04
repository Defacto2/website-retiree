<!---
  	Link form "Notes" view.
	path: views/link/_inputComment.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="form-group form-group-sm">
		<label for="website-comment" class="text-muted">Notes</label>
		<textarea class="form-control input-sm" id="website-comment" name="website[comment]" cols="2" placeholder="A comment or note about the website.">#website.comment#</textarea>
	</div>
</cfoutput>