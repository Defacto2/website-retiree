<!---
  	Create a website view.
	path: views/link/add.cfm

@CFLintIgnore
--->
<cfscript>
	param name="website.title" default="" type="string";
	param name="website.uriref" default="" type="string";
	param name="website.date_issued_year" default="" type="string";
	param name="website.date_issued_month" default="" type="string";
	param name="website.date_issued_day" default="" type="string";
	param name="website.categorykey" default="" type="string";
	param name="website.categorysort" default="" type="string";
	param name="website.comment" default="" type="string";
	pageAbout.text = 'Include a website'
	pageAbout.icon = 'fal fa-external-link'
</cfscript>
<cfoutput>
<!-- form to add a new website -->
<div id="uploadController" class="panel-limited-double col-lg-6 col-lg-offset-3">
	<div class="panel panel-default">
		<div class="panel-heading"><h3 class="panel-title">Site details</h3></div>
		<div class="panel-body">
			#startFormTag(controller="link",action="new",multipart="false",id="form3")#
				#includePartial("debugoutput")#
				<div class="row">
					<div class="col-sm-6">#includePartial("inputTitle")#</div>
					<div class="col-sm-6">#includePartial("inputURL")#</div>
				</div>
				#includePartial("inputDate")#
				#includePartial("inputCategory")#
				#includePartial("inputComment")#
				#includePartial("inputSubmit")#
			#endFormTag()#
		</div>
	</div>
</div>
</cfoutput>