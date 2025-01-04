<!---
  	Link form new feedback partial view.
	path: views/link/_debugOutput.cfm

@CFLintIgnore
--->
<cfoutput>
	<!-- update status and feedback -->
	<cfif flashKeyExists("danger")>
		<div class="alert alert-danger">
			<span class="alert-link">#flash("danger")#</span>
		</div>
	</cfif>
	<cfif flashKeyExists("success")>
		<div class="alert alert-success">
			<span class="alert-link">#flash("success")#</span>
		</div>
	</cfif>
	<cfif website.errorCount()>
		<!-- processing messages -->
		<div class="alert alert-danger">
			Sorry there is a problem with the website<br>
			<span class="alert-link">#errorMessagesFor(objectName="website")#</span>
		</div>
	</cfif>
</cfoutput>