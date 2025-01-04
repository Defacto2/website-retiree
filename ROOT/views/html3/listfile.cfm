<!---
	HTML 3 list files view.
	path: views/html3/listfile.cfm

@CFLintIgnore
---><cfoutput>
<img src="#gif.blank#" alt="Icon"> <a href="#sort.name#">Name</a>                    <a href="#sort.date#">Date published</a>    <a href="#sort.post#">Posted</a>     <a href="#sort.size#">Size</a>  <a href="#sort.desc#">Description</a><hr><img src="#gif.back#" alt="[DIR]"> <a href="#link.parent#">Parent Directory</a>#RepeatString(" ",26)#-
<cfloop query="records"><cfif IsNumeric(records.fileSize)><cfset filesizeSum=filesizeSum+records.fileSize><cfelse><cfcontinue /></cfif><cfset fileText = Trim("#truncate(LCase(filenameLessExtension(records.fileName)),19,'.')#.#Left(fileExtension(records.fileName),3)#")><cfset spacer = Val(23-Len(fileText))><cfif IsValid('integer',html3FileSize(records.fileSize))><cfset sizegap = 7><cfset descgap = 3><cfelse><cfset sizegap = 8><cfset descgap = 2></cfif>#linkIcon(uuid=records.uuid,filename=records.filename,key=obfuscateParam(id))# #linkTo(text=fileText,route='d',key="#obfuscateParam(id)#")##RepeatString(" ",Abs(spacer))# #Trim(includePartial("datepublished"))#  #Trim(includePartial("dateposted"))# #RepeatString(" ",Abs(sizegap-Len(html3FileSize(records.fileSize))))##html3FileSize(records.fileSize)##RepeatString(" ",descgap)##Trim(includePartial("pubedition"))#
</cfloop></cfoutput>