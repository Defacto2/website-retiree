<!---
  	Link form "Title" partial view.
	path: views/link/_inputTitle.cfm

@CFLintIgnore
--->
<cfoutput>
	<div class="form-group form-group-sm">
		<label for="website-title">Title</label><br>
		<input class="form-control input-sm" id="website-title" name="website[title]" maxlength="100" value="#website.title#" placeholder="Example website" required>
	</div>
</cfoutput>