<!---
	Operator model file.
	path: models/Operator.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("users")
		// Set properties
		property(name="uuid", guid="true")
		// Validation (see Model.cfc for additional functions)
		validatesFormatOf(property="email",type="email",allowBlank=true)
		validatesPresenceOf(properties="username,password,email")
		validatesUniquenessOf(property="email",
			message="Email address is already in use in another account",allowBlank=true)
		validatesUniquenessOf(property="displayname",
			message="Display name is already in use in another account",allowBlank=true)
		validatesUniquenessOf(property="username",
			message="Username is already in use in another account",allowBlank=true)
		// Callbacks
		beforeSave("newUUID")
		beforeSave("saltPassword")
	}

	/**
	 * Applies a SHA-256 algorithm specified by FIPS-180-2 hash to the string
	 */
	function saltPassword() {
		if(this.hasChanged("password")) this.password = pwsha512(this.uuid,this.password);
	}

	function newUUID() {
		if(this.uuid == "") newGUID();
	}
}