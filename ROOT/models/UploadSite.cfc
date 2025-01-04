<!---
	Upload site model file.
	path: models/UploadSite.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("files")
		// Validation (see Model.cfc for additional functions)
		validate("checkFileExtension");
		validatesLengthOf(properties="comment",maximum=limits.comment,allowBlank=true,
			message="Please shorten your notes, #limits.comment# characters is the maximum length allowed.");
		validatesPresenceOf(properties="fileName",
			message="You have not selected a file to upload.");
		validatesPresenceOf(properties="platform",when="onUpdate");
		validatesPresenceOf(properties="group_brand_for",
			message="The name of the BBS or FTP site is required.");
		validatesUniquenessOf(property="file_integrity_strong",allowBlank=true,when="onCreate",
			message="Thanks, but it seems this file is already on the site.");
		beforeSave("newGUID")
	}
}