<!---
	Admin replace download file, partial view.
	path: views/files/_prod_admin-replacefile.cfm

@CFLintIgnore
--->
<cfif !opCheck('coop')><cfreturn></cfif>
<cfoutput>
	#startFormTag(controller="File",action="replace",multipart="true",id="form6",params=queryString)#
	<fieldset id="form6field">
		<div class="panel panel-danger #highlightWarning(trigger=feedback.recommend.title,bg=true)#">
			<div class="panel-heading">Replace or update the file download</div>
			<ul class="list-group no-overflow">
				<li class="list-group-item">
					#hiddenFieldTag(name="uuid",value="#fileProd.uuid#")#
					<div class="row">
						<div class="form-group col-lg-6">
							<button type="reset" id="resetReDownload" class="btn btn-block btn-danger pull-right text-uppercase">Reset</button>
						</div>
						<div class="form-group col-lg-6 eclipse" title="#admin.replace.text#">
							<button type="submit" id="replaceDownload" class="btn btn-block btn-warning text-uppercase eclipse" disabled><i class="fal fa-download fa-fw fa-lg"></i> #admin.replace.button# download</button>
						</div>
					</div>
					<div class="no-overflow">
						<input name="file-replace" id="file-replace" type="file" class="btn btn-default col-lg-12">
					</div>
				</li>
				<li class="list-group-item">
					<p class="checkbox text-center" title="You must check this to #Lcase(admin.replace.text)#">
						<label class="text-warning"><input type="checkbox" id="reDownloadConfirm" class="fa-radio" name="confirm" value="true"><small>You must confirm the #admin.replace.noun#</small></label>
					</p>
				</li>
				<!--- see apis-external.js for the JS code --->
				<li class="list-group-item hidden" id="list-of-external-downloads">
					<p><small class="help-block">Or copy over a file from an <strong>external link</strong></small></p>
				</li>
			</ul>
		</div>
	</fieldset>
	#endFormTag()#
</cfoutput>