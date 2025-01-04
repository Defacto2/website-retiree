<!---
	Upload submission model file.
	path: models/Upload.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("files")
		// Set properties
		property(name="platformText", sql="#setPlatformNames()#")
		property(name="sectionText", sql="#setSectionNames()#")
		// Validation (see Model.cfc for additional functions)
		validate("checkFileExtension")
		validate("checkPreview")
		//validate("checkGroup")
		validatesLengthOf(properties="comment",maximum=limits.comment,allowBlank=true,
			message="Please shorten your notes, #limits.comment# characters is the maximum length allowed.")
		validatesLengthOf(properties="web_id_youtube",type="URL",exactly=limits.youtube, allowBlank=true,
			message="Your YouTube ID is not valid as it needs to be #limits.youtube# characters in length.")
		validatesNumericalityOf(properties="web_id_pouet",onlyInteger=true,greaterThan=0,allowBlank=true,
			message="Your Pouet ID is not valid as all id's must be numeric.")
		validatesNumericalityOf(properties="web_id_demozoo",onlyInteger=true,greaterThan=0,allowBlank=true,
			message="Your Demozoo ID is not valid as all id's must be numeric.")
		validatesPresenceOf(properties="fileName",message="You have not selected a file to upload.")
		validatesUniquenessOf(property="file_integrity_strong",allowBlank=true,when="onCreate",
			message="Thanks, but it seems this file is already on the site.")
		beforeSave("trimThe")
		beforeSave("newGUID")
	}

	/**
	* Custom SQL to get a list of initialisms formatted as 'ABC (Advanced Bitchin Cats)'
	*/
	function getFormattedInitialisms() {
		var initialisms = queryExecute("
			(SELECT CONCAT(initialisms, ' ', '(', pubname, ')') AS pubCombined
			FROM groupnames
			WHERE Length(initialisms) <> 0)
			UNION
			(SELECT DISTINCT group_brand_for AS pubCombined
			FROM files
			WHERE Length(group_brand_for) <> 0)
			UNION
			(SELECT DISTINCT group_brand_by AS pubCombined
			FROM files
			WHERE Length(group_brand_by) <> 0)
			ORDER BY pubCombined
			", [], { datasource = "#get(source)#", result = "result" });
		return initialisms;
	}
}