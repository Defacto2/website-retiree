<!---
	User model file.
	path: models/User.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("users")
		// Required fields
		validatesPresenceOf(properties="username,password,email")
		// Uniqueness of
		validatesUniquenessOf(
			property="email",
			message="Email address is already in use in another account",
			allowBlank=true);
		validatesUniquenessOf(
			property="username",
			message="Sign-in name is already in use in another account",
			allowBlank=true);
		validatesUniquenessOf(
			property="displayname",
			message="Display name is already in use in another account",
			allowBlank=true);
		// Format of
		validatesFormatOf(property="email", type="email",allowBlank=true)
	}
}