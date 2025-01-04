<!---
  	Search "groups" partial view.
	path: views/search/_listorganisations.cfm

@CFLintIgnore
--->
<cfscript>
	// order groups by match priority
	var begin = ""
	var exact = ""
	var match = ""
	var skip = ""
	var words = ""
	var keyCnt = listLen(xssCleanedKey, '|')
	loop list=xssCleanedKey index='local.key' delimiters='|' {
		var cnt=0 // reset count for skip listFind
		loop list=results.group index='local.group' delimiters=';' {
			cnt++
			if(keyCnt > 1 && listFindNoCase(skip, cnt)) continue;
			var keyLen = len(key)
			var left = left(group, keyLen+1)
			var right = right(group, keyLen+1)
			// handle any initialisms
			grpInitialism = trim(groupInitialism(group))
			if(len(grpInitialism)) {
				if(grpInitialism == '(#key#)' || grpInitialism contains '(#key#/' || grpInitialism contains '/#key#)' || grpInitialism == '[#key#]' || grpInitialism contains '[#key#/' || grpInitialism contains '/#key#]' || grpInitialism contains '/#key#/') {
					exact = listAppend(exact, group, ';')
					skip = listAppend(skip, cnt);
					continue;
				}
			}
			// handle group name
			// exact match
			if(group == key) {
				exact = listAppend(exact, group, ';')
				skip = listAppend(skip, cnt);
				continue;
			}
			// begins with match
			if(left == '#key# ' || left == '#key#-' || left == '#key#,') {
				begin = listAppend(begin, group, ';')
				skip = listAppend(skip, cnt);
				continue;
			}
			// whole word match
			if(right == ' #key#' || right == '-#key#'
				|| group contains ' #key# ' || group contains ' #key#,' || group contains ', #key# ' || group contains ', #key#,'
				|| group contains ' #key#-' || group contains '-#key# ' || group contains '-#key#-'
				|| group contains ' #key#.') {
				words = listAppend(words, group, ';')
				skip = listAppend(skip, cnt);
				continue;
			}
			// substring matches
			if(keyCnt > 1) {
				// avoid the expensive contain search if it isn't needed
				if(group contains key){
					match = listAppend(match, group, ';')
					skip = listAppend(skip, cnt)
				}
				continue;
			}
			match = listAppend(match, group, ';')
		}
	}
	//dump(exact);dump(words);dump(match);
	// remove duplicates
	if(keyCnt > 1) {
		exact = listRemoveDuplicates(exact, ';', true)
		begin = listRemoveDuplicates(begin, ';', true)
		words = listRemoveDuplicates(words, ';', true)
		match = listRemoveDuplicates(match, ';', true)
	}

	var hrz = false // use cnt to determine if we add a <hr> seperator tag
	hrz = drillDown(exact, hrz)
	hrz = drilldown(begin, hrz)
	hrz = drilldown(words, hrz)
	drillDown(match, hrz)

	private boolean function drillDown(required string groups, boolean separator=false) {
		if(!listLen(arguments.groups, ';')) return false
		var cnt=0
		if(!arguments.separator) WriteOutput('<div class="#variables.class.group#" id="organisation-drill-down">');
		else WriteOutput('<hr><div class="#variables.class.group#" id="organisation-drill-down">')
		var sep = arguments.separator
		var listGroups = listSort(arguments.groups, 'text', 'asc', ';')
		loop list=listGroups index='local.initialism' delimiters=';' {
			cnt = cnt+1
			var cited = initialism
			loop list=xssCleanedKey index='local.key' delimiters='|' {
				var initals = groupInitialism(initialism)
				//if(cited does not contain key && trim(initals) does not contain key) continue;
				sep = true
				WriteOutput('<!-- organisation result #cnt#. -->')
				WriteOutput('<div>')
				var html = '<h2>'
				if(cnt == 1) html = '<h2 class="row-first-item">'
				// allow the HTML to break coop groups over seperate lines
				cited = replaceNoCase(cited, ', ', '|', 'all')
				var cites = 0
				loop list=cited index='local.coop' delimiters='|' {
					var marked = variables.cite(coop)
					cites=cites+1
					if(cites == 1) html &= '<i class="fal fa-angle-right fa-xs fw-fw gray"></i> ';
					else html &= ' <span class="gray">-</span> ';
					html &= '<a href="#UrlFor(route='g',orgname=obfuscateURL(initialism))#">#marked#</a>'
				}
				if(len(initals)) html &= '<span class="gray">#variables.cite(lCase(initals))#</span>';
				WriteOutput(html & '</h2></div>')
				break; // once match is found, end xssCleanedKey loop
			}
		}
		WriteOutput('</div>')
		return sep
	}
</cfscript>