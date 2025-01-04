<!---
    Parent model file.
	path: models/Model.cfc

	This is the parent model file that all your models should extend.
	You can add functions to this file to make them available in all your models.
	Do not delete this file.

@CFLintIgnore
--->
component
	extends="wheels.Model"
	output=false
{
	variables.source = "dataSourceName"
	variables.limits = {
		"comment":65535,
		"youtube":11,
	}

	/**
	 * Checks against a predetermined list if the file extension is allowed
	 */
	void function checkFileExtension() {
		if(ListFindNoCase(get('myapp').blacklistedExt, this.clientfileext)) {
			addError(property="fileName", message="Uploaded file is not allowed and has been blacklisted.");
		}
	}

	/**
	 * Checks against a predetermined list if the preview image file extension is allowed
	 */
	void function checkPreview() {
		if(!StructKeyExists(this,'upload2')) return;
		if(!Len(this.upload2.serverfullpath)) return;
		if(!IsImageFile(!this.upload2.serverfullpath)) return;
		var msg = "Preview '#this.preview_image#' is not in a valid format. Only the following are accepted, #GetReadableImageFormats()#."
		addError(property="preview_image", message=msg);
	}

	/**
	 * Enforces the file DB requirement that group_brand_by and group_brand_for columns can not both be NULL
	 */
	void function checkGroup() {
		if(Len(this.group_brand_for)) return;
		if(Len(this.group_brand_by)) return;
		addError(property="group_brand_for", message="Group that published this file is required or Group who created this file is required.");
		errorsOn(property="group_brand_by");
	}

	/**
	 * Drops 'The ' prefix from group names that end with ' BBS'
	 */
	void function trimThe() {
		var preBy = trim(this.group_brand_by)
		var preFor = trim(this.group_brand_for)
		var sfx = right(preBy, 4)
		if(left(preBy, 4) == 'The ' && (sfx == ' BBS' || sfx == ' FTP')) {
			var clean = mid(preBy, 4, len(preBy)-3)
			this.group_brand_by = trim(clean)
		}
		sfx = right(preFor, 4)
		if(left(preFor, 4) == 'The ' && (sfx == ' BBS' || sfx == ' FTP')) {
			var clean = mid(preFor, 4, len(preFor)-3)
			this.group_brand_for = trim(clean)
		}
	}

	/**
	 * Creates a new 36 character GUID (8-4-4-16) for an empty `uuid` column
	 */
	void function newGUID() {
		this.uuid = LCase(Insert("-", CreateUUID(), 23))
	}

	void function trim16colors() {
		var host = "16colo.rs"
		var l = len(host)
		var val = trim(this.web_id_16colors)
		if(left(val,7+l) == 'http://' & host) {
			this.web_id_16colors = right(val, len(val)-7-l)
			return
		}
		if(left(val,8+l) == 'https://' & host) {
			this.web_id_16colors = right(val, len(val)-8-l)
			return
		}
		if(len(val) > 1 && left(val,1) != "/") {
			this.web_id_16colors = "/#val#"
		}
	}
	void function trimGithub() {
		var host = "github.com"
		var l = len(host)
		var val = trim(this.web_id_github)
		if(left(val,7+l) == 'http://' & host) {
			this.web_id_github = right(val, len(val)-7-l)
			return
		}
		if(left(val,8+l) == 'https://' & host) {
			this.web_id_github = right(val, len(val)-8-l)
			return
		}
		if(len(val) > 1 && left(val,1) != "/") {
			this.web_id_github = "/#val#"
		}
	}
	void function trimWhitespace() {
		this.record_title = trim(this.record_title)
		this.filename = trim(this.filename)
		this.group_brand_by = trim(this.group_brand_by)
		this.group_brand_for = trim(this.group_brand_for)
		this.credit_text = trim(this.credit_text)
		this.credit_program = trim(this.credit_program)
		this.credit_illustration = trim(this.credit_illustration)
		this.credit_audio = trim(this.credit_audio)
		this.retrotxt_readme=trim(this.retrotxt_readme)
		this.dosee_run_program=trim(this.dosee_run_program)
	}
	void function formatValues() {
		this.section = LCase(this.section)
		this.platform = LCase(this.platform)
		this.uuid = LCase(this.uuid)
		this.deletedby = LCase(this.deletedby)
		this.updatedby = LCase(this.updatedby)
		if(len(this.group_brand_by) > 0) {
			if(trim(this.group_brand_by) == trim(this.group_brand_for)) {
				this.group_brand_by = ""
			}
			if(trim(this.group_brand_for) == "") {
				this.group_brand_for = trim(this.group_brand_by)
				this.group_brand_by = ""
			}
		}
	}
}