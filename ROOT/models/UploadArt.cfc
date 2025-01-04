<!---
	Upload art submission model file.
	path: models/UploadArt.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("files");
		// Validation (see Model.cfc for additional functions)
		validate("checkFileExtension");
		validatesLengthOf(properties="comment",maximum=limits.comment,allowBlank=true,
			message="Please shorten your notes, #limits.comment# characters is the maximum length allowed.");
		validatesLengthOf(properties="web_id_youtube",type="URL",exactly=limits.youtube, allowBlank=true,
			message="Your YouTube ID is not valid as it needs to be #limits.youtube# characters in length.");
		validatesPresenceOf(properties="fileName",
			message="You have not selected a file to upload.");
		validatesPresenceOf(properties="platform",when="onUpdate");
		validatesPresenceOf(properties="group_brand_for",
			message="Group who published this promotion is required.");
		validatesUniquenessOf(property="file_integrity_strong",allowBlank=true,when="onCreate",
			message="Thanks, but it seems this file is already on the site.");
		beforeSave("newGUID")
	}
}