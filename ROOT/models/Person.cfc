<!---
	Person model file.
	path: models/Person.cfc

@CFLintIgnore
--->
component
	extends="Model"
	output=false
{
	function config() {
		table("files")
	}

	/**
	* Custom SQL to UNION credit_program, credit_illustration, credit_audio, credit_text
	*/
	function getPeople(string key, boolean includeSoftDeletes) {
		var delete = function(boolean includeSoftDeletes) {
			if(!arguments.includeSoftDeletes) return "AND `deletedat` IS NULL";
			return "";
		}
		var fetches = function(required string key) {
			switch(arguments.key) {
				case 'writers': fetch = "w"; break;
				case 'coders': fetch = "c"; break;
				case 'artists': fetch = "a"; break;
				case 'musicians': fetch = "m"; break;
				default: fetch = "wcam";
			}
		}
		if(!len(arguments.key)) return queryNew("pubCombined");
		var soft = arguments.includeSoftDeletes
		var fetch = fetches(arguments.key)
		savecontent variable="local.sql" {
			if(fetch contains "w") writeOutput(" UNION (SELECT DISTINCT credit_text AS pubCombined FROM files WHERE Length(credit_text) <> 0 #delete(soft)#)");
			if(fetch contains "c") writeOutput(" UNION (SELECT DISTINCT credit_program AS pubCombined FROM files WHERE Length(credit_program) <> 0 #delete(soft)#)");
			if(fetch contains "a") writeOutput(" UNION (SELECT DISTINCT credit_illustration AS pubCombined FROM files WHERE Length(credit_illustration) <> 0 #delete(soft)#)");
			if(fetch contains "m") writeOutput(" UNION (SELECT DISTINCT credit_audio AS pubCombined FROM files WHERE Length(credit_audio) <> 0 #delete(soft)#)");
			writeOutput(" ORDER BY pubCombined")
		}
		// correct SQL syntax
		sql = replaceNoCase(trim(sql),"UNION (SELECT DISTINCT ","(SELECT DISTINCT ","one")
		// execute SQL
		return queryExecute(sql, [], { datasource=get(source) } );
	}

	/**
	* Custom query search for groups using params.key
	*/
	function searchGroups(string term) {
		savecontent variable="local.sql" {
			writeOutput("(SELECT DISTINCT group_brand_for AS tagName FROM files WHERE group_brand_for LIKE '#arguments.term#%'	AND `deletedat` IS NULL)")
			writeOutput(" UNION (SELECT DISTINCT group_brand_by AS tagName FROM files WHERE group_brand_by LIKE '#arguments.term#%' AND `deletedat` IS NULL)")
			writeOutput(" ORDER BY tagName LIMIT 10")
			}
		return queryExecute(sql, [], { datasource=get(source) } );
	}
}