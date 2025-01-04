<!---
	Search controller file.
	path: controllers/Search.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="checkControllerState")
	}

	variables.singleQuote = chr(39)
	variables.doubleQuote = chr(34)

	function index() {
		redirectTo(route="s");
	}

	breadcrumbs &= appendCrumb(2, 'search', urlFor('s'))
	description = 'Search the Defacto2 database'

	function processurl() {
		param name="params.search" default="";
		param name="params.query" default="";
		var search = params.search
		var query = trim(params.query)
		try {
			query = replace(query,singleQuote,doubleQuote,"all")
		} catch(any err) {
			redirectTo(route="s",params="query=error")
		}
		switch(search.input) {
			case 'files': case 'groups': case 'people': case 'websites': case 'all':
				// replace reserved characters
				query = replace(query,'&',' and ','all')
				query = replace(query,singleQuote,'','all')
				query = replace(query,doubleQuote,"",'all')
				redirectTo(route="s",params="search=#search.input#&query=#query#")
				return;
			default: redirectTo(route="s",params="query=invalid")
		}
	}

	function result() {
		param name="params.query" default="";
		param name="params.key" default="";
		param name="params.search" default="all";
		params.query = URLDecode(params.query)
		var sql = {
			"file":'',
			"groupFor":"",
			"groupBy":"",
			"person":'',
			"web":'',
		}
		variables.searches = {
			"files":false,
			"groups":false,
			"people":false,
			"sites":false,
			"display":{
				"desc":false,
				"filename":false,
			}
		}
		variables.q4_credits = ""
		// limits
		var maxFiles = 500
		variables.minSearchLength = 2
		// strip out any quotations, "search term" or 'search term'
		var st = params.query
		if(Left(st,1) == doubleQuote && Right(st,1) == doubleQuote) params.query = Mid(st,2,Len(params.query)-2)
		if(Left(st,1) == singleQuote && Right(st,1) == singleQuote) params.query = Mid(st,2,Len(params.query)-2)
		// 'path traversal' removal
		if(Left(params.query,2) == './') redirectTo(route="s",params="query=#ReplaceNocase(params.query,'./','')#")
		if(Left(params.query,2) == '.\') redirectTo(route="s",params="query=#ReplaceNocase(params.query,'.\','')#")
		if(Left(params.query,4) == '.%5C') redirectTo(route="s",params="query=#ReplaceNocase(params.query,'.%5C','')#")
		variables.xssCleanedKey = xssFix(params.query)
		params.key = params.query
		var keys = params.key
		switch(params.search) {
			case 'files':
				searches.files = true;
				searches.display.desc = true
				searches.display.filename = true
				breadcrumbs &= 'files'
				description = 'Search the Defacto2 file database'
				break;
			case 'groups':
				searches.groups = true
				breadcrumbs &= 'groups'
				description &= ' for scene groups'
				break;
			case 'people':
				searches.people = true
				breadcrumbs &= 'people'
				description &= ' for scene members'
				break;
			case 'websites':
				searches.sites = true
				breadcrumbs &= 'web sites'
				description = 'Search the Defacto2 web site database'
				break;
			default:
				searches.files = true
				searches.groups = true
				searches.people = true
				searches.display.desc = true
				searches.display.filename = true
				searches.sites = true
		}
		if(len(keys)) breadcrumbs &= ' = #keys#'
		// inject ambiguous comparisons
		if(!IsNumeric(keys)) {
			var terms = _ambiguous(keys)
			if(listLen(terms,'|')) {
				xssCleanedKey = listAppend(xssCleanedKey,terms,'|')
				keys = listAppend(keys,terms,'|')
			}
		}
		// title
		title = "Search"
		if(Len(keys)) title &= "es"
		// create SQL statements
		var key = ""
		loop list=keys index="local.key" delimiters="|" {
			if(len(key) < minSearchLength) continue;
			// file matches
			if(searches.files) {
				// descriptions
				if(searches.display.desc) sql.file &= " OR record_title LIKE '%#key#%' OR comment LIKE '%#key#%'"
				// filenames
				if(searches.display.filename) sql.file &= " OR filename LIKE '%#key#%'"
			}
			// web site links
			if(searches.sites) {
				sql.web &= " OR title LIKE '%#key#%' OR metatitle LIKE '%#key#%' OR comment LIKE '%#key#%' OR uriref LIKE '%#key#%' OR metadescription LIKE '%#key#%'"
			}
			// groups
			if(searches.groups) {
				sql.groupFor &= " OR group_brand_for LIKE '%#key#%'"
				sql.groupBy &= " OR group_brand_by LIKE '%#key#%'"
				// match initialisms and acronyms
				var groups = model("groupnames").findAll(select="pubname",where="initialisms='#Trim(key)#'",returnas="query")
				var list = valueList(groups.pubname)
				for(var value in list) {
					sql.groupFor &= " OR group_brand_for LIKE '%#value#%'"
					sql.groupBy &= " OR group_brand_by LIKE '%#value#%'"
				}
				groups = queryNew("") // empty the query
			}
			// people (authors)
			if(searches.people) {
				sql.person = sql.person & " OR credit_text LIKE '%#key#%' OR credit_program LIKE '%#key#%' OR credit_illustration LIKE '%#key#%' OR credit_audio LIKE '%#key#%'"
			}
		}
		// file & art WHERE SQL clean up
		var or = " OR "
		if(Left(sql.file,4) == or) sql.file = Mid(sql.file,4,Len(sql.file)-3)
		if(Left(sql.web,4) == or) sql.web = Mid(sql.web,4,Len(sql.web)-3)
		if(Left(sql.groupFor,4) == or) sql.groupFor = Mid(sql.groupFor,4,Len(sql.groupFor)-3)
		if(Left(sql.groupBy,4) == or) sql.groupBy = Mid(sql.groupBy,4,Len(sql.groupBy)-3)
		if(Left(sql.person,4) == or) sql.person = Mid(sql.person,4,Len(sql.person)-3)
		/*
		 * SEARCH QUERIES
		 */
		// Empty query containers
		variables.results = {
			"file":QueryNew("id"), // q1
			"files":0, // q1Count
			"link":QueryNew("id"), // q2
			"group":"", // q3
			"people":QueryNew("id"), // q4
			"pouet":QueryNew("id"), // q5
			"demozoo":QueryNew("id"), // q6
			"fileID":QueryNew("id"), // q7
		}
		// Pouet and Demozoo (they ignore min length requirements)
		if(Len(keys) && IsNumeric(keys)) {
			results.pouet = model("files").findOne(
				where="web_id_pouet=#keys#",
				returnAs="query")
			results.demozoo = model("files").findOne(
				where="web_id_demozoo=#keys#",
				returnAs="query")
			results.fileID = model("files").findOne(
				where="id=#keys#",
				returnAs="query")
		} else if(Len(keys) && isValid("guid", keys)) {
			results.fileID = model("files").findOne(
				where="uuid='#keys#'",
				returnAs="query")
		}
		// Enforce minimum search query length
		if(Len(key) < minSearchLength && results.people.recordCount == 0 && results.pouet.recordCount == 0 && results.fileID.recordCount == 0) return;
		// file & art query
		if(Len(Trim(sql.file))) {
			results.file = model("files").findAll(
					where=sql.file,
					orderBy="group_brand_for,group_brand_by",
					maxRows=maxFiles,
					returnAs="query")
			if(results.file.recordCount == maxFiles) {
				results.files = model("files").count(
					where=sql.file,
					orderBy="group_brand_for,group_brand_by",
					maxRows=maxFiles,
					returnAs="query")
			}
		}
		// web sites query
		if(searches.sites) {
			results.link = model("netresources").findAll(
					where=sql.web,
					orderBy="metatitle,title",
					returnAs="query")
		}
		// organisations query
		if(searches.groups) {
			// match groups
			var queryFor = model("files").findAll(
					select="group_brand_for",
					where=sql.groupFor,
					returnAs="query",
					distinct="true")
			var queryBy = model("files").findAll(
					select="group_brand_by",
					where=sql.groupBy,
					returnAs="query",
					distinct="true")
			var list = "#ValueList(queryFor.group_brand_for,';')#;#ValueList(queryBy.group_brand_by,';')#"
			list = cleanlist(list=list,delimiter=";")
			list = ListRemoveDuplicates(list=list,delimiter=";",ignoreCase=true)
			results.group = listSort(list,"text","asc",";")
			list = "" // empty the list
		}
		// persons query
		if(searches.people) {
			results.people = model("files").findAll(
					where=sql.person,
					select="credit_text,credit_program,credit_illustration,credit_audio",
					returnAs="query",
					distinct="true")
			var roles = ""
			for (var person in results.people) {
				roles = ListAppend(roles,person.credit_text)
				roles = ListAppend(roles,person.credit_program)
				roles = ListAppend(roles,person.credit_illustration)
				roles = ListAppend(roles,person.credit_audio)
			}
			roles = cleanList(roles)
			var clone = roles
			var credits = ""
			loop list=xssCleanedKey index="local.clean" delimiters="|" {
				loop list=roles index="local.role" {
					var position = ListContainsNoCase(clone,clean)
					if(position) {
						credits = ListAppend(credits,ListGetAt(clone,position))
						clone = listDeleteAt(clone,position)
						continue;
					}
					break;
				}
			}
			q4_credits = listSort(credits,"text", "asc",";")
			credits = "" // empty the list
		}
		// single record, exact match auto-redirection
		switch(params.search) {
			case 'groups':
				if(listLen(results.group,';') == 1 && listFirst(results.group,';') == params.query) {
					redirectTo(route="g",orgname=obfuscateURL(listFirst(results.group,';')));
				}
				break;
			case 'people':
				if(listLen(q4_credits,';') == 1 && listFirst(q4_credits,';') == params.query) {
					redirectTo(route="p",personname=obfuscateURL(listFirst(q4_credits,';')));
				}
				break;
		}
		if(!listLen(q4_credits,';') && !listLen(results.group,';') && results.link.recordCount == 0 && results.file.recordCount == 0) {
			// pouet match
			if(results.pouet.recordCount == 1 && results.demozoo.recordCount == 0) {
				redirectTo(route="f",key=obfuscateParam(results.pouet.id));
			}
			// demozoo match
			if(results.pouet.recordCount == 0 && results.demozoo.recordCount == 1) {
				redirectTo(route="f",key=obfuscateParam(results.demozoo.id));
			}
			// exact defacto2 id match
			if(results.fileID.recordCount == 1 && opCheck("coop")) {
				redirectTo(route="f",key=obfuscateParam(results.fileID.id));
			}
		}
	}

	// Injects ambiguous terms into the query string
	// So a search for 'Kings Quest I' will also look for 'Kings Quest 1'
	private string function _ambiguous(required string keys) {
		var romans = {'iv':'4','iii':'3','ii':'2','i':'1','viii':'8','vii':'7','vi':'6','v':'5','ix':'9','x':'10'}
		var decimals = {'10':'x','9':'ix','7':'vii','6':'vi','5':'v','4':'iv','3':'iii','2':'ii','1':'i'}
		var symbols = {'and':'&'}
		var terms = ""
		loop list=arguments.keys index="local.key" delimiters="|" {
			// order of these conditionals is important for pattern matching
			loop struct=romans index="local.roman" {
				var term = romans[roman]
				if(key contains ' #roman# ') {
					terms = listAppend(terms,ReplaceNocase(key,' #roman# ',' #term# ','all'),'|')
					continue;
				}
				if(right(key,len(roman)+1) == ' #roman#') {
					terms = listAppend(terms,'#left(key,len(key)-len(term)-1)# #term#','|')
					break;
				}
			}
			loop struct=decimals index="local.decimal" {
				var term = decimals[decimal]
				if(key contains ' #decimal# ') {
					terms = listAppend(terms,ReplaceNocase(key,' #decimal# ',' #term# ','all'),'|')
					continue;
				}
				if(right(key,len(decimal)+1) == ' #decimal#') {
					terms = Reverse(replace(Reverse(key),Reverse(decimal),Reverse(term),'one'))
					break;
				}
			}
			loop struct=symbols index="local.symbol" {
				var term = symbols[symbol]
				if(key contains ' #symbol# ') {
					terms = listAppend(terms,ReplaceNocase(key,'#symbol#','#term#','all'),'|')
					continue;
				}
				if(key contains ' #term# ') {
					terms = listAppend(terms,ReplaceNocase(key,' #term# ',' #symbol# ','all'),'|')
					break;
				}
			}
		}
		return terms
	}
}