<!---
	Upload demozoo and pouet submissions model file.
	path: models/UploadExternal.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("files")
		// Set properties
		property(name="platformText", sql="#setPlatformNames()#");
		property(name="sectionText", sql="#setSectionNames()#");
		// Validation (see Model.cfc for additional functions)
		validatesLengthOf(properties="comment",maximum=limits.comment,allowBlank=true,
			message="Please shorten your notes, #limits.comment# characters is the maximum length allowed.")
		validatesLengthOf(properties="web_id_youtube",type="URL",exactly=limits.youtube, allowBlank=true,
			message="Your YouTube ID is not valid as it needs to be #limits.youtube# characters in length.")
		validatesNumericalityOf(properties="web_id_pouet",onlyInteger=true,greaterThan=0,allowBlank=true,
			message="Your Pouet ID is not valid as all id's must be numeric.")
		validatesNumericalityOf(properties="web_id_demozoo",onlyInteger=true,greaterThan=0,allowBlank=true,
			message="Your Demozoo ID is not valid as all id's must be numeric.")
		beforeSave("newGUID")
	}
}