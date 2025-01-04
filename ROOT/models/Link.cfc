<!---
    Link model file.
	path: models/Link.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("netresources")
		// Validation (see Model.cfc for additional functions)
		validate("checkUrlScheme")
		validatesPresenceOf(properties="uriRef",message="You have not included a URI.")
		validatesPresenceOf(properties="title",when="onUpdate",message="You have not included a title.")
		validatesPresenceOf(properties="categorykey",when="onUpdate",message="You have not included a category key.")
		validatesPresenceOf(properties="categorysort",when="onUpdate",message="You have not included a sort category.")
		validatesUniquenessOf(property="uriRef",allowBlank=true,message="The URL is already in our database.")
		beforeSave("newGUID")
	}

	/*
	 * Determines if a supplied URI is valid"
	 */
	function checkUrlScheme() {
		if(!Find('://',this.uriRef,1)) return "";
		if(ListFindNoCase(get("myapp").acceptedURISchemes, ListGetAt(this.uriRef,1,':'))) return "";
		var msg = "The URL scheme '#ListGetAt(this.uriRef,1,':')#://' is invalid. Only the following schemes are accepted: #get("myapp").acceptedURISchemes#."
		// http, https = web and encrypted web
		// ftp, sftp = file transfers and encrypted transfers
		// telnet = remote shell
		// ssh = encrypted remote shell and/or encrypted file transfers
		addError(property="uriRef", message=msg)
	}

	function findSchemes(boolean includeSoftDeletes=false) {
		savecontent variable="local.sql" {
			writeOutput("SELECT DISTINCT LEFT(`uriref`,(POSITION('://' IN `uriref`)-1)) AS `scheme`");
			writeOutput("FROM `netresources`");
			writeOutput("WHERE `uriref` LIKE '%//%'");
			if(!arguments.includeSoftDeletes) writeOutput("AND `deletedat` IS NULL");
		}
		return queryExecute("#sql#",[],{ datasource=get(source), result="local.result" });
	}
}