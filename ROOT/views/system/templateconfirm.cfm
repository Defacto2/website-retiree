<!---
  	Rename confirmation view.
	path: views/system/templateconfirm.cfm

@CFLintIgnore
--->
<cfscript>
	param name="formAction" default="";
	param name="formBody" default="";
	param name="formKey" default="";
	param name="formTitle" default="";
</cfscript>
<cfoutput>
<div class="row">
	<div class="col-md-8 col-lg-6 col-md-offset-2 col-lg-offset-3">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title"><strong>#formTitle#</strong></h3>
			</div>
			<div class="panel-body">
				#startFormTag(controller="#params.controller#",action="#formAction#",key="#formKey#",encode=false)#
				<p>Rename <span class="brand-primary">#params.source#</span> to <span class="brand-primary">#params.newName#</span> ?</p>
				<p>Save change to <strong class="brand-warning">#modCnt#</strong> #pluralize(word="record",count=modCnt,returnCount=false)# ?</p>
				<div>#formBody#</div>
				<button type="submit" class="btn btn-primary">Yes</button>
				#hiddenFieldTag(name="source",value="#params.source#")#
				#hiddenFieldTag(name="newName",value="#params.newName#")#
				#endFormTag()#
			</div>
		</div>
	</div>
</div>
</cfoutput>