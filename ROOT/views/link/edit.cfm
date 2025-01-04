<!---
  	Edit a website view.
	path: views/link/edit.cfm

@CFLintIgnore
--->
<cfscript>
	var edits = function() {
		var del = website.deletedAt
		if(Len(del) && Len(website.createdAt) && del == website.createdAt) {
			site.text = " and Approve";
			edit.button = "Approve";
		}
		else if (Len(del)) edit.button = "Restore"
		else edit.button = "Disable"
		if(!Find(":",website.uriref)) {
			site.action = "wayback"
			edit.local = true
		}
	}
	variables.edit = {
		 // shared with _inputPagination.cfm
		"button":"",
		"local":false,
	}
	var site = {
		"action":"visit",
		"text":"",
	}
	edits()
	pageAbout.text = 'Edit a website'
	pageAbout.icon = 'fal fa-external-link'
</cfscript>
<cfoutput>
<div id="uploadController">
	#includePartial("inputPagination")#
	<div class="row">
		<div class="col-sm-6">
			<div class="panel panel-primary">
				<div class="panel-heading"><h3 class="panel-title"><i class="fal fa-plus fa-fw"></i> Link</h3></div>
				<div class="panel-body">
					#includePartial("debugoutput")#
					#includePartial("debugdelete")#
					#startFormTag(controller="link",action="update",key=obfuscateParam(website.id),multipart="false",id="form3")#
						<div class="row">
							<div class="col-lg-6">#includePartial("inputTitle")#</div>
							<div class="col-lg-6">#includePartial("inputURL")#</div>
						</div>
						<cfif variables.edit.local>
							#includePartial("inputDate")#
						</cfif>
						#includePartial("inputCategory")#
						#includePartial("inputComment")#
						#includePartial("inputSubmit")#
						#hiddenFieldTag(name="uuid",value="#website.uuid#")#
						#hiddenFieldTag(name="savefunction",value="#site.text#")#
					#endFormTag()#
				</div>
			</div>
		</div>
		<div class="col-sm-3">
			<div class="panel panel-info">
				<div class="panel-heading"><i class="fal fa-database fa-fw"></i> <b>#website.title#</b></div>
				<div class="panel-body">
					<cfif Len(website.uriref) is 0>
					<cfelseif Len(website.deletedat)>
						<s><code>#LinkTo(text=website.uriref,action='#site.action#',key=obfuscateParam(website.id))#</code></s>
					<cfelse>
						#LinkTo(text=website.uriref,action='#site.action#',key=obfuscateParam(website.id))#
					</cfif>
				</div>
				<ul class="list-group">
					<li class="list-group-item">uuid: <code>#website.uuid#</code></li>
					<li class="list-group-item">id: <code>#website.id#</code></li>
				<cfif Len(website.createdat)>
					<!-- record approved when -->
					<li class="list-group-item">approved: <code>#DateFormat(website.createdat,"full")#</code></li>
				<cfelseif Len(website.createdat)>
					<!-- if not approved display when record was created -->
					<li class="list-group-item">created: <code>#DateFormat(website.createdat,"full")#</code></li>
				</cfif>
				<cfif Len(website.updatedat)>
					<!-- recorded last updated when -->
					<li class="list-group-item">updated: <code>#DateFormat(website.updatedat,"full")# #TimeFormat(website.updatedat,"full")#</code></li>
				</cfif>
				<cfif Len(website.createdat) and Len(website.deletedat)>
					<!-- record waiting for approval -->
					<li class="list-group-item brand-warning"><i class="fal fa-exclamation-circle fa-fw"></i> Not accessible to the public</li>
				<cfelseif Len(website.deletedat)>
					<!-- record soft-deleted when -->
					<li class="list-group-item">deleted: <code class="brand-danger">#DateFormat(website.deletedat,"full")#</code></li>
				</cfif>
				</ul>
			</div>
		</div>
		<cfif !variables.edit.local>
			<div class="col-sm-3">
				<div class="panel panel-info">
					<div class="panel-heading"><i class="fal fa-globe fa-fw"></i> HTTP response</div>
					<div class="panel-body">description: <samp>#website.metadescription#</samp></div>
					<ul class="list-group">
						<li class="list-group-item">status code: <code>#website.httpstatuscode# #website.httpstatustext#</code></li>
						<li class="list-group-item">etag: <code>#website.httplocation#</code></li>
						<li class="list-group-item">last modified: <code>#website.httplastmodified#</code></li>
						<li class="list-group-item">title: <samp>#website.metatitle#</samp></li>
						<li class="list-group-item">authors: <samp>#website.metaauthors#</samp></li>
						<li class="list-group-item">keywords: <samp>#website.metakeywords#</samp></li>
					</ul>
				</div>
			</div>
		</cfif>
	</div>
</cfoutput>