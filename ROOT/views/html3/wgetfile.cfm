<!---
	HTML 3 wget file example view.
	path: views/html3/wgetfile.cfm

@CFLintIgnore
---><cfparam name="params.key" default="collection"><cfoutput>
<ol><cfloop query="records"><cfif IsNumeric(records.fileSize)><cfset filesizeSum=filesizeSum+records.fileSize><cfelse><cfcontinue /></cfif><cfset fileText = Trim("#truncate(LCase(filenameLessExtension(records.fileName)),19,'.')#.#Left(fileExtension(records.fileName),3)#")><li>#linkTo(text=fileText,route="wgetDownload",slug1=params.action,slug2=params.key,filename="#records.filename#",params="key=#obfuscateParam(records.id)#")#</li></cfloop></ol></cfoutput>