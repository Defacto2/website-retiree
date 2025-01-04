<!---
	HTML 3 directory item partial view.
	path: views/html3/_directories.cfm

@CFLintIgnore
--->
<cfscript>
	routeName = function() {
		switch(params.action) {
			case 'categories':
				return 'html3Category'
			case 'groups':
				return 'html3Group'
			case 'platforms':
				return 'html3Platform'
			default:
				return ''
		}
	}
	variables.directories = [1]
	var cnt = 0

	loop list=sort.listOfResults index="local.index" delimiters="|" {
		index = ListLast(index,":")
		cnt++
		directories[cnt] = {
			"href" = "#urlFor(route="#routeName()#", key="#index#")#",
			"description" = "",
			"name" = index,
			"count" = "-"
		}
		try {
			if(params.action == "platforms") {
				directories[cnt].name = getPlatformName(index)
				if(!wgetmode()) {
					directories[cnt].description = getPlatformDescription(index)
					if(Len(getPlatformTechnical(index))) directories[cnt].description &= " " & getPlatformTechnical(index);
					directories[cnt].count = model("Files").count(where="platform='#index#'",includeSoftDeletes=false)
				}
			}
			else if(params.action == "categories") {
				directories[cnt].name = getSectionName(index)
				if(!wgetmode()) {
					directories[cnt].description = getSectionDescription(index)
					directories[cnt].count = model("Files").count(where="section='#index#'",includeSoftDeletes=false)
				}
			}
		}
		catch(any err) {}
		directories[cnt].truncName = capitalize(truncate(directories[cnt].name,44,'..'))
		directories[cnt].truncLen = Val(24-Len(directories[cnt].truncName)-Len(directories[cnt].count))
	}
</cfscript>