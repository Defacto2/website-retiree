<!---
	Admin panel partial view.
	path: views/files/_prod_admin-core.cfm

@CFLintIgnore
--->
<cfoutput>
<!--- LEFT COLUMN --->
#startFormTag(controller="File",action="save",multipart="false",id="form1",params=queryString)#
<div class="col-lg-7 col-md-12 col-sm-12">
#includePartial('/file/prod_admin-editfile')#
<cfif toggle.retrotxt or zipComment.exists>
#includePartial('/file/prod_retrotxt')#
</cfif>
</div>
<!--- RIGHT COLUMN --->
<div class="col-lg-5 col-md-12 col-sm-12">
#includePartial("/file/prod_flash")#
#includePartial('/file/prod_admin-editmore')#
</div>
#endFormTag()#
<div class="col-lg-5 col-md-12 col-sm-12">
#includePartial('/file/prod_admin-images')#
#includePartial('/file/prod_admin-replacefile')#
</div>
</cfoutput>