<!---
  	Send your files "summary" partial view.
	path: views/upload/_inputComment.cfm

@CFLintIgnore
--->
<cfscript>
	param name="param.commentReq" default=false type="boolean";
	var commentRequired = ""
	var txtmute = ""
	if(param.commentReq) commentRequired = 'required'
	if(params.action != "file") txtmute = 'text-muted'
</cfscript>
<cfoutput>
	<div class="form-group" id="note-container">
		<label for="new-file-comment" class="control-label #txtmute#">About</label>
		<textarea class="form-control" id="new-file-comment" name="newFile[comment]"
			placeholder="Leave a comment for the file moderator, for a response include some contact details" #commentRequired#></textarea>
	</div>
</cfoutput>