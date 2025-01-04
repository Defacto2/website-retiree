<!---
  	People item partial view.
	path: views/person/_items.cfm

@CFLintIgnore
--->
<cfoutput>
	<ul>
		<cfscript>
			var cnt=0
			var orderCapitalize = ""
			for(var credit in creditslist) {
				cnt++
				ignore=false
				// get first letter of next list item and compare it to current list item's first letter
				if(cnt+1 > listLen(creditslist)) creditTitle = "#credit#.";
				else if(left(listGetAt(creditslist,cnt+1),1) != left(credit,1)) creditTitle = "#credit#.";
				else creditTitle = "#credit#,";
				creditTitle = titleize(LCase(creditTitle))
				local.firstChar = left(credit,1)
				// don't link to credits that start with a dash or contain a dot.
				// dots are incompatible with CFWheels routing.
				if(firstChar == "-") ignore=true
				else if(credit contains ".") ignore=true // TODO: remove
				if(firstChar != orderCapitalize && !isNumeric(left(credit,1))) {
					orderCapitalize = Left(credit,1)
					writeOutput('<hr>')
				}
				if(ignore) writeOutput('<h2 class="brand-warning">#XMLFormat(Left(creditTitle,Len(creditTitle)-1))#</h2>');
				else writeOutput('<h2>#linkTo(text=XMLFormat(Left(creditTitle,Len(creditTitle)-1)),route="p",personname=obfuscateURL(credit))#</h2>');
			}
		</cfscript>
	</ul>
</cfoutput>