<!---
    Variables for Application.cfc's "this" scope
	path: config/app.cfm

	Changes to this page require a restart of Lucee/Tomcat

@CFLintIgnore GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN
--->
<cfscript>
	/**
	 * Reads a JSON file and parses to a CFML data structure.
	 * Then using a breadcrumb dot notation path it fetches and returns
	 * a requested value.
	 *
	 * i.e keyPath="email.address.from" would return "defacto2@example.com"
	 * when reading from `defacto2.json`.
	 * {
	 * 	 "email": {
	 * 		"address": {
	 * 				"from": ""
	 * 			}
	 * 		}
	 * }
	 *
	 * @keyPath A dot notation breadcrumb path pointing to a structure key.
	 * @path Relative or absolute path to a JSON formatted file.
	 */
	public any function loadJSONConfig(string keyPath="", string path="../insecure/defacto2.json") {
		// read json file
		var fullPath = expandPath(arguments.path)
		if(!fileExists(fullPath)) return "not found: #fullPath#";
		var json = fileRead(fullPath)
		var data = DeserializeJSON(json)
		json = ""
		if(StructIsEmpty(data)) return ""
		// if no keyPath value is provided, then return the complete data structure
		if(arguments.keyPath == "") return data
		// follow the keyPath breadcrumb trail by searching for it's last key item,
		// i.e if keyPath="google.email.address.from", search for "from".
		// then compare all the structFindKey() path value matches against our keyPath value.
		var keys = listToArray(arguments.keyPath, ".")
		var finds = structFindKey(data, ArrayLast(keys), 'all')
		for (var find in finds) {
			if('.#arguments.keyPath#' == find.path) {
				data = {}
				finds = {}
				return find.value
			}
		}
		data = {}
		finds = {}
		return ""
	}
	// Name of the web application
	// Changing this resets the APPLICATION scope and webapp cache
	this["name"]="Defacto"
	// Data source to MySQL v8 database Docker container
	// https://docs.lucee.org/guides/cookbooks/datasource-define-datasource.html
	this.datasources["defacto"]={
		type: 'mysql'
		, host: '#loadJSONConfig("mysql.host")#'
		, database: '#loadJSONConfig("mysql.database")#'
		, port: 3306
		, username: '#loadJSONConfig("mysql.username")#'
		, password: '#loadJSONConfig("mysql.password")#'
		// optionals
		//, "connectionLimit": 100 // default:-1
		// about maxPerformance: https://github.com/mysql/mysql-connector-j/blob/release/8.0/src/main/resources/com/mysql/cj/configurations/maxPerformance.properties
		, custom: {useConfigs='maxPerformance-8-0'}
	};
	// Web Settings - Performance/Caching
	this["typeChecking"]=true;
	// Settings - Regional
	this["locale"]="en_US";
	this["timezone"]="Etc/UTC";
	// Settings - Charset
	this["charset"].web="UTF-8";
	this["charset"].resource="UTF-8";
	// Settings - Scope
	// Session type either: application | jee
	this["sessionType"]="application";
	this["sessionManagement"]=true;
	this["clientManagement"]=true;
	this["setDomainCookies"]=false;
	this["setClientCookies"]=true;
	cookie name="cfid" value="#session.cfid#" path="/" preserveCase="true" httponly="true" secure="true" samesite="strict";
	cookie name="cftoken" value="#session.cftoken#" path="/" preserveCase="true" httponly="true" secure="true" samesite="strict";
	this["cgiReadOnly"]=true;
	// Session should be always in memory and only used for short-term variables to save memory.
	// createTimeSpan(days, hours, minutes, seconds)
	this["sessionTimeout"]=createTimeSpan(0,0,5,0);
	this["applicationTimeout"]=createTimeSpan(7,0,0,0);
	// Client variables for user browsing location settings etc.
	this["clientTimeout"]=createTimeSpan(0,1,0,0);
	// Storage is either: memory | file | cookie
	this["sessionStorage"]="memory";
	this["clientStorage"]="file";
	// Settings - Scope Dialect CFML
	// Local scope mode, either: classic | modern
	// Setting to modern will break things but it can also be
	// applied to functions. `function test() localMode="modern" {}`
	this["localMode"]="classic";
	// either: standard | strict | small
	this["scopeCascading"]="standard";
	// Settings - Request
	// Request timeout
	this["requestTimeout"]=createTimeSpan(0,0,0,15);
	// Settings - Output
	this["compression"]=false;
	this["suppressRemoteComponentContent"]=false;
	this["bufferOutput"]="true";
	/*
	 * Is the active session a crawler bot or a user?
	 */
	local["botUserAgent"]=false
	loop list="CFSCHEDULE" index="index" delimiters="," {
		if(CGI.http_user_agent contains index) {
			local["botUserAgent"]=true;
			break;
		}
	}
	/*
	 * Adjust the Session timeout depending on the requested page or user
	 */
	// googlebot special session
	if(CGI.http_user_agent contains "Googlebot") {
		this["sessionTimeout"]=createTimeSpan(0,0,0,30);
	}
	// operator time-out
	if(structKeyExists(cookie, "persistSession")) {
		this["sessionTimeout"]=createTimeSpan(0,2,0,0);
	}
</cfscript>