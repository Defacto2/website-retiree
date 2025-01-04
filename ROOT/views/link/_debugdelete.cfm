<!---
  	Link form delete confirm partial view.
	path: views/link/_debugdelete.cfm

@CFLintIgnore
--->
<cfscript>
	var newID = function(){
		if(Len(navigation.previous)) return obfuscateParam(navigation.previous);
		if(Len(navigation.next)) return obfuscateParam(navigation.next);
	}
</cfscript>
<cfif Len(website.deletedAt)><cfoutput>
	#startFormTag(controller="link",action="delete",key=params.key,class="form-horizontal")#
	<div class="form-group has-warning form-group-xs">
		<div class="col-sm-4">
			<button type="submit" class="btn btn-danger btn-sm"><i class="fal fa-thumbs-down fa-fw"></i> PERMANENTLY KILL RECORD?</button>
			<div class="checkbox">
				<label class="control-label"><input type="checkbox" class="" name="confirm" value="true"> Check this box to kill the record</label>
			</div>
		</div>
		<div class="col-sm-8">

		</div>
		#hiddenFieldTag(name="uuid",value="#website.uuid#")#
		#hiddenFieldTag(name="title",value="#website.title#")#
		#hiddenFieldTag(name="gotonextid",value="#newID()#")#
	</div>
	#endFormTag()#</cfoutput>
</cfif>