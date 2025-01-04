<!---
	Upload multiple files model file.
	path: models/UploadMultiple.cfc

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
		validatesPresenceOf(properties="comment",
			message="No description was written about the upload.");
		validatesPresenceOf(properties="fileName",
			message="You have not selected a file to upload.");
		beforeSave("newGUID")
	}
}