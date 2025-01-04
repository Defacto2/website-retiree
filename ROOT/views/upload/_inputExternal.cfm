<!---
  	Send your files "Production ID" partial view.
	path: views/upload/_inputExternal.cfm

@CFLintIgnore
--->
<cfscript>
	var trim = function(required string url) {
		var trimmed = replaceNoCase(arguments.url,"http://","")
		if(trimmed == arguments.url) return replaceNoCase(arguments.url,"https://","");
		return trimmed
	}
</cfscript>
<cfoutput>
	<label for="newFile-web_id_demozoo" class="control-label brand-primary">Production ID</label>
	<div class="row">
		<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
			<div class="input-group">
				<!-- demozoo id input element and validation -->
				<div class="input-group-addon"><img src="/images/layout/demozoo_16x16_logo.png" height="16" width="16" alt="Demozoo"></div>
				<input class="form-control" id="newFile-web_id_demozoo" maxlength="6" name="newFile[web_id_demozoo]" aria-label="Demozoo ID" placeholder="Demozoo ID" type="text" autofocus>
			</div>
		</div>
		<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 col-lg-offset-2 col-md-offset-2">
			<div class="input-group">
				<!-- pouët id input element and validation -->
				<div class="input-group-addon"><img src="/images/layout/pouet_16x16_logo.png" height="16" width="16" alt="Pouët"></div>
				<input class="form-control" id="newFile-web_id_pouet" maxlength="6" name="newFile[web_id_pouet]" aria-label="Pouët ID" placeholder="Pouët ID" type="text">
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-6">
			<p><small class="help-block"><samp>#XMLFormat(trim(get('myapp').other.demozoo))#<mark id="demozoo-mark">0</mark></samp></small></p>
			<p><span class="help-block" id="check-demozoo-span"></span></p>
		</div>
		<div class="col-lg-6">
			<p><small class="help-block"><samp>#XMLFormat(trim(get('myapp').other.pouet))#<mark id="pouet-mark">0</mark></samp></small></p>
			<p><span class="help-block" id="check-pouet-span"></span></p>
		</div>
	</div>
	<hr>
</cfoutput>