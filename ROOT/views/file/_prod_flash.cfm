<!---
    Feedback partial view.
	path: views/files/_prod_flash.cfm

@CFLintIgnore
--->
<cfscript>
	var testFlashMessages = false // set to true to test flash messages
	var dismissButton = function() {
		var now = now()
		var time = "#hour(now)#:#numberFormat(minute(now),'00')#:#numberFormat(second(now),'00')#"
		var button = '<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		button &= '<span aria-hidden="true">&times;</span></button><code class="float-right">#time#</code>'
		return button
	}
	var info = function() {
		return '<i class="fal fa-question-circle fa-fw fa-lg" title="What does this mean?"></i>'
	}
	var appendFlash = function(string text) {
		if(text contains "error") {
			dangers.append(flash(text))
			return
		}
		if(text contains "info") {
			info.append(flash(text))
			return
		}
		success.append(flash(text))
	}
	var tests = function() {
		// test flashes
		flashInsert(error="Test Error")
		flashInsert(info="Test information")
		flashInsert(test="Test others")
		warnings.append("Test warning")
		// test appends
		dangers.append("2nd a test")
		info.append("2nd b test")
		success.append("2nd c test")
		warnings.append("2nd d test")
	}
	var offset = " alert-dismissible"
	if(!opCheck('coop')) offset &= " col-md-8 col-md-offset-2"
	var dangers = []
	var warnings = []
	var info = []
	var success = []
	var none = "none"
	var display = {
		"danger":none,
		"warning":none,
		"info":none,
		"success":none,
	}
	if(testFlashMessages) tests();
	// user feedback
	if(flashKeyExists("missingfile")) dangers.append('<i class="fal fa-exclamation-triangle"></i> #flash("missingfile")#')
	// operator feedback
	if(opCheck('coop')) {
		if(flashKeyExists("debugfail")) dangers.append(flash("debugfail"))
		if(flashKeyExists("debugsuccess")) success.append(flash("debugsuccess"))
		if(Len(feedback.hints)) info.append(feedback.hints)
		if(IsDefined("file") && Len(errorMessagesFor("file"))) dangers.append('</span>There has been a problem processing this file#errorMessagesFor(objectName='file')#')
		if(Len(fileProd.createdat)) {
			if(Len(feedback.require.hint)) dangers.append('</span>You''re missing the following <span class="alert-link">#LCase(Replace(cleanList(feedback.require.hint),",",", ","all"))#</span>')
			if(Len(feedback.recommend.hint)) warnings.append('</span>The following are suggested <span class="alert-link">#LCase(Replace(cleanList(feedback.recommend.hint),",",", ","all"))#</span>')
		}
		loop list=StructKeyList(flash()) index="local.text" {
			appendFlash(text)
		}
	}
	var block = "block"
	if(len(dangers)) display.danger = block
	if(len(info)) display.info = block
	if(len(success)) display.success = block
	if(len(warnings)) display.warning = block
	// remove duplicate listings
	var successes = listToArray(listRemoveDuplicates(arrayToList(success), ',', true))
</cfscript>
<cfoutput>
<div id="flashCollection">
	<div id="flashDangers" class="alert alert-danger #offset#" style="display:#display.danger#;">
		#dismissButton()#
		<cfloop array="#dangers#" item="local.danger">
			<span class="alert-link"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i> #danger#</span><br>
		</cfloop>
	</div>
	<div id="flashWarnings" class="alert alert-warning #offset#" style="display:#display.warning#;">
		#dismissButton()#
		<cfloop array="#warnings#" item="local.warning">
			<span class="alert-link"><i class="fal fa-question-circle fa-fw fa-lg"></i> #warning#</span><br>
		</cfloop>
	</div>
	<div id="flashInfo" class="alert alert-info #offset#" style="display:#display.info#;">
		#dismissButton()#
		<cfloop array="#info#" item="local.info">
			<span class="alert-link"><i class="fal fa-info-circle fa-fw fa-lg"></i> #info#</span><br>
		</cfloop>
	</div>
	<div id="flashSuccess" class="alert alert-success #offset#" style="display:#display.success#;">
		#dismissButton()#
		<cfloop array="#successes#" item="local.success">
			<span class="alert-link"><i class="fal fa-check fa-fw fa-lg"></i> #success#</span><br>
		</cfloop>
	</div>
</div>
</cfoutput>