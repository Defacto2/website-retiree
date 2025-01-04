<!---
	File model file.
	path: models/File.cfc

	***********************************************
	WHEN TESTING MODEL UPDATES AT TERMINAL YOU MUST
	***********************************************
	Refresh the CFWheels environment

	If that doesn't refresh then in a terminal
	> sudo service tomcat8 refresh

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("files");
		// validation on save
		validatesLengthOf(properties="comment",maximum=limits.comment,allowBlank=true,
			message="Please shorten your notes, #limits.comment# characters is the maximum length allowed.");
		validatesLengthOf(properties="web_id_youtube",type="URL",exactly=limits.youtube, allowBlank=true,
			message="Your YouTube ID is not valid as it needs to be #limits.youtube# characters in length.");
		validatesNumericalityOf(properties="web_id_pouet",onlyInteger=true,greaterThan=0,allowBlank=true,
			message="Your Pouet ID is not valid as all id's must be numeric.");
		validatesNumericalityOf(properties="web_id_demozoo",onlyInteger=true,greaterThan=0,allowBlank=true,
			message="Your Demozoo ID is not valid as all id's must be numeric.");
		validatesFormatOf(properties="file_security_alert_url",type="URL",allowBlank=true,
			message="The virus threat URL is not valid.");
		beforeSave("trimThe")
		beforeSave("trim16colors")
		beforeSave("trimGithub")
		beforeSave("trimWhitespace")
		beforeSave("formatValues")
	}

	/**
	 * A custom SELECT query to allow proper alphabetical sorting by customised magazine title and issue, file title or file name
	 */
	function listFilesSortedAZ(
			string where,
			numeric page=1,
			numeric perPage=10,
			string order,
			boolean includeSoftDeletes="false",
			string select="*") {
		// append where statements with argument requests
		var limitfilter = ""
		var selectfilter = arguments.select & ",fileName"
		var wherefilter = ""
		var countfilter = ""
		if(Len(Trim(arguments.where))) {
			countfilter = "WHERE " & Trim(arguments.where)
			countfilter = ReplaceNocase(local.countfilter,"'",'"',"all")
			wherefilter = "AND (" & Trim(arguments.where) & ")"
			wherefilter = ReplaceNocase(wherefilter,"'",'"',"all")
		}
		if(!arguments.includeSoftDeletes) {
			if(len(countfilter)) countfilter = countfilter & " AND deletedat IS NULL";
			else countfilter = countfilter & " WHERE deletedat IS NULL";
			wherefilter = wherefilter & " AND deletedat IS NULL"
		}
		var all = "*"
		if(arguments.select == all) {
			selectfilter = all
			limitfilter = "LIMIT #((arguments.page - 1) * arguments.perPage)#,#arguments.perPage#";
		}
		// total record count for pagination (http://cfwheels.org/docs/1-1/function/setpagination)
		var listAZCount = queryExecute("
			SELECT COUNT(*) AS theCount FROM files #countfilter#
			",[],{ datasource = "#get(source)#", result = "local.result" });
		// custom query that creates a custom column called AZ_SORT that includes a customised magazine title, item title or filename.
		var listAZ = queryExecute("
			SELECT DISTINCT #selectfilter#, Trim(CONCAT(group_brand_for, ' issue ', record_title)) AS AZ_SORT, `section`, `id`
				FROM files
				WHERE section = 'magazine' #ReplaceNocase(wherefilter,"''","'","all")#
			UNION
			SELECT DISTINCT #selectfilter#, Trim(record_title) AS AZ_SORT, `section`, `id`
				FROM files
				WHERE section != 'magazine' AND record_title IS NOT NULL #wherefilter#
			ORDER BY #arguments.order#
			#limitfilter#
			",[],{ datasource = "#get(source)#", result = "local.result" });
		// set pagination variables
		setPagination(totalRecords=listAZCount.theCount, currentPage=arguments.page, perPage=arguments.perPage, handle="query")
		return listAZ;
	}

	/**
	 * Returns the total number of new file records added during a particular month of the year
	 */
	function countByMonth(required numeric month, required numeric year) {
		var query = queryExecute("
			SELECT COUNT(*) AS count
			FROM files
			WHERE YEAR(`createdat`) = #arguments.year# AND MONTH(`createdat`) = #arguments.month#
			", [], { datasource = "#get(source)#",	result = "local.result" });
		return query.count[1];
	}

	/**
	 * Returns the total number of new file records added during a particular year
	 */
	function countByYear(required numeric year) {
		var query = queryExecute("
			SELECT COUNT(*) AS count
			FROM files
			WHERE YEAR(`createdat`) = #arguments.year#
			", [], { datasource = "#get(source)#", result = "local.result" });
		return query.count[1];
	}

	/**
	 * Returns the top 10 groups by number of group_brand_by files
	 */
	function topGroups(numeric limit=10) {
		var query = queryExecute("
			SELECT group_brand_for,COUNT(*) as count FROM files
			GROUP BY group_brand_for ORDER BY count DESC
			LIMIT #arguments.limit#
			", [], { datasource = "#get(source)#", result = "local.result" });
		return query;
	}

	/**
	 * Returns the top 10 file platforms
	 */
	function topPlatforms(numeric limit=10) {
		var query = queryExecute("
			SELECT platform,COUNT(*) as count FROM files
			WHERE platform IS NOT NULL
			GROUP BY platform ORDER BY count DESC
			LIMIT #arguments.limit#
			", [], { datasource = "#get(source)#", result = "local.result" });
		return query;
	}

	/**
	 * Returns the top 10 file sections
	 */
	function topSections(numeric limit=10) {
		var query = queryExecute("
			SELECT section,COUNT(*) as count FROM files
			WHERE section IS NOT NULL
			GROUP BY section ORDER BY count DESC
			LIMIT #arguments.limit#
			", [], { datasource = "#get(source)#", result = "local.result" });
		return query;
	}
}