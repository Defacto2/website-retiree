<!---
  	Send your files DEBUG asynchronous response partial view.
	path: views/upload/_debugOutput.cfm

@CFLintIgnore
--->
<cfscript>
	var calculate = function() {
		if(IsDefined("newFile")) errors.file = Len(errorMessagesFor("newFile"))
		if(IsDefined("newSite")) errors.site = Len(errorMessagesFor("newSite"))
	}
	var errorsExist = function() {
		if(fileError()) return true;
		if(siteError()) return true;
		if(flashCount()) return true;
		return false;
	}
	var fileError = function() {
		if(IsDefined("newFile") && errors.file) return true;
		return false
	}
	var siteError = function() {
		if(IsDefined("newSite") && errors.site) return true;
		return false
	}
	var errors = {
		"file":0,
		"site":0,
	}
	calculate()
</cfscript>
<cfif errorsExist()>
	<cfset local.legendText="">
	<cfoutput>
		<cfif fileError()>
			<!-- error messages for file submission -->
			<cfset legendText="There has been a problem with your submission. ">
		<cfelseif siteError()>
			<!-- error messages for link submission -->
			<cfset legendText="There has been a problem with your submission. ">
		</cfif>
		<cfif flashCount()>
			<!-- processing messages -->
			<div class="alert alert-danger">
				<span class="alert-link">#legendText##flash("error")#</span>
			</div>
			<div class="alert alert-warning"><span class="info-link">Go back one page in your browser to return to your submission.</span></div>
		</cfif>
	</cfoutput>
</cfif>

<!-- form feedback messages supplied by upload.js -->
<div id="feedBack" class="alert alert-warning lead text-center hidden" role="alert">
	<!-- place-holder default message -->
</div>