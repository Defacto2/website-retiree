<!---
	Organisation model file.
	path: models/Organisation.cfc

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
	* SQL WHERE statement attachment for custom SQL and soft deletes.
	*/
	private function _extraWHERE(string key, boolean includeSoftDeletes) {
		// SQL WHERE statement adjustments for organisation filtering
		var filter = function(string key) {
			switch(arguments.key) {
				case "magazine": return "section = 'magazine' AND";
				case "bbs": return "RIGHT(group_brand_for,4) = ' BBS' AND";
				case "ftp": return "RIGHT(group_brand_for,4) = ' FTP' AND";
				// This will only display groups who are listed under group_brand_for.
				// group_brand_by only groups will be ignored
				case "group": return "RIGHT(group_brand_for,4) != ' FTP' AND RIGHT(group_brand_for,4) != ' BBS' AND section != 'magazine' AND";
				default: return ""
			}
		}
		var sql = ""
		if(arguments.includeSoftDeletes) {
			if(Len(filter(arguments.key))) sql = "AND #filter(arguments.key)#";
		}
		else if(Len(filter(arguments.key))) sql = "AND #filter(arguments.key)# `deletedat` IS NULL";
		else sql = "AND `deletedat` IS NULL";
		if(Right(sql,4) == ' AND') sql = Left(sql,(Len(sql)-4));
		return sql;
	}

	/**
	* Custom SQL to UNION group_brand_by and group_brand_for columns
	*/
	function getGroups(string key, boolean includeSoftDeletes) {
		savecontent variable="local.sql" {
			// disable group_brand_by listings for BBS, FTP, group, magazine filters
			if(arguments.key != 'bbs' && arguments.key != 'ftp' && arguments.key != 'group' && arguments.key != 'magazine') {
				writeOutput("(SELECT DISTINCT group_brand_for AS pubCombined FROM files WHERE Length(group_brand_for) <> 0 #_extraWHERE(arguments.key,arguments.includeSoftDeletes)#)")
				writeOutput(" UNION")
				writeOutput(" (SELECT DISTINCT group_brand_by AS pubCombined FROM files WHERE Length(group_brand_by) <> 0 #_extraWHERE(arguments.key,arguments.includeSoftDeletes)#)")
			} else {
				writeOutput(" SELECT DISTINCT group_brand_for AS pubCombined FROM files WHERE Length(group_brand_for) <> 0 #_extraWHERE(arguments.key,arguments.includeSoftDeletes)#")
			}
			writeOutput(" ORDER BY pubCombined")
		}
		return queryExecute(sql, [], { datasource=get(source) } );
	}

	/**
	* Custom SQL to get a list of groups with initialisms formatted as 'Advanced Bitchin Cats (ABC)'
	*/
	function getInitialisms() {
		savecontent variable="local.sql" {
			writeOutput("SELECT pubValue, (SELECT CONCAT(pubCombined, ' ', '(', initialisms, ')') FROM groupnames WHERE pubName = pubCombined AND Length(initialisms) <> 0) AS pubCombined")
			writeOutput(" FROM (SELECT TRIM(group_brand_for) AS pubValue, group_brand_for AS pubCombined FROM files WHERE Length(group_brand_for) <> 0")
			writeOutput(" UNION SELECT TRIM(group_brand_by) AS pubValue, group_brand_by AS pubCombined FROM files WHERE Length(group_brand_by) <> 0) AS pubTbl")
			writeOutput(" ORDER BY pubTbl.pubValue")
		}
		return queryExecute(sql, [], { datasource=get(source) } );
	}

	/**
	* Custom query search for groups using params.key
	*/
	function searchGroups(string term, boolean includeSoftDeletes=false) {
		savecontent variable="local.sql" {
			writeOutput("(SELECT DISTINCT group_brand_for AS tagName FROM files WHERE group_brand_for LIKE '#arguments.term#%' ")
			if(!arguments.includeSoftDeletes) writeOutput(" AND `deletedat` IS NULL");
			writeOutput(" UNION (SELECT DISTINCT group_brand_by AS tagName FROM files WHERE group_brand_by LIKE '#arguments.term#%'")
			if(!arguments.includeSoftDeletes) writeOutput(" AND `deletedat` IS NULL");
			writeOutput(" ORDER BY tagName LIMIT 10")
		}
		return queryExecute(sql, [], { datasource=get(source) } );
	}
}