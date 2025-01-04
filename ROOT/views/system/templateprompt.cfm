<!---
  	Rename confirmation view.
	path: views/system/templateprompt.cfm

@CFLintIgnore
--->
<cfscript>
	param name="rename" type="struct";
	param name="rename.route" default="";
	param name="rename.key" default="";
	param name="rename.count" type="numeric" default=0;
	param name="rename.exists" type="numeric" default=0;
	param name="rename.valueOld" default="";
	param name="rename.valueNew" default="";
	var prompt = 'Rename <span class="brand-primary">#rename.valueOld#</span> to <span class="brand-primary">#rename.valueNew#</span> ?'
	var confirm = 'Save change to <strong class="brand-warning">#rename.count#</strong> #pluralize(word="record",count=rename.count,returnCount=false)# ?'
	if(rename.exists) {
		prompt = 'Rename <span class="brand-primary">#rename.valueOld#</span> and merge it into <span class="brand-primary">#rename.valueNew#</span> with its <strong class="brand-warning">#rename.exists#</strong> existing #pluralize(word="item",count=rename.exists,returnCount=false)# ?'
		confirm = 'Update <strong class="brand-warning">#rename.count#</strong> <span class="brand-primary">#rename.valueOld#</span> #pluralize(word="record",count=rename.count,returnCount=false)# ?'
	}
</cfscript>
<cfoutput>
<div class="row">
	<div class="col-md-8 col-lg-6 col-md-offset-2 col-lg-offset-3">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title"><strong>Confirm update</strong></h3>
			</div>
			<div class="panel-body">
				#startFormTag(route=rename.route,key=rename.key,encode=false)#
				<p>#prompt#</p>
				<p>#confirm#</p>
				<button type="submit" class="btn btn-primary">Yes</button>
				#hiddenFieldTag(name="valueOld",value="#rename.valueOld#")#
				#hiddenFieldTag(name="valueNew",value="#rename.valueNew#")#
				#endFormTag()#
			</div>
		</div>
	</div>
</div>
</cfoutput>