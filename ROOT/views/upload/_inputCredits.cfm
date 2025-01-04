<!---
  	Send your files "Credits - Multiple names can be separated by a comma" partial view.
	path: views/upload/_inputCredits.cfm

@CFLintIgnore
--->
<cfscript>
	var columnClass = function() {
		if(roles == 2) return "col-lg-6"
		if(roles == 3) return "col-lg-4"
		if(roles == 4) return "col-lg-6"
		return "col-lg-12"
	}
	param name="param.job" default="write,code,gfx,music" type="string";
	var roles = ListLen(param.job)
</cfscript>
<cfoutput>
	<label class="text-muted">Credits <small>- Multiple names can be separated by a comma</small></label>
	<div class="row">
		<div class="#columnClass()#">
		<cfif ListFind(param.job,'write')>
			<div class="form-group">
				<input class="form-control" aria-label="Writers, interviewers or interviewees" id="newFile-credit_text" maxlength="100" name="newFile[credit_text]" placeholder="Writers, interviewers or interviewees" type="text">
			</div>
		</cfif>
		<cfif ListFind(param.job,'code')>
			<div class="form-group">
				<input class="form-control" aria-label="Coders or programmers" id="newFile-credit_program" maxlength="100" name="newFile[credit_program]" placeholder="Coders or programmers" type="text">
			</div>
		</cfif>
	<cfif roles gte 2>
		</div>
		<div class="#columnClass()#">
	</cfif>
		<cfif ListFind(param.job,'gfx')>
			<div class="form-group">
				<input class="form-control" aria-label="Graphic artists or illustrators" id="newFile-credit_illustration" maxlength="100" name="newFile[credit_illustration]" placeholder="Graphic artists or illustrators" type="text">
			</div>
		</cfif>
	<cfif roles is 3>
		</div>
		<div class="#columnClass()#">
	</cfif>
		<cfif ListFind(param.job,'music')>
			<div class="form-group">
				<input class="form-control" aria-label="Musicians" id="newFile-credit_audio" maxlength="100" name="newFile[credit_audio]" placeholder="Musicians" type="text">
			</div>
		</cfif>
		</div>
	</div>
</cfoutput>