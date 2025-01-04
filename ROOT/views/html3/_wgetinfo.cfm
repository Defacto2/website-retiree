<!---
	HTML 3 wget information partial view.
	path: views/html3/_wgetinfo.cfm

@CFLintIgnore
--->
<cfscript>
    var base = "https://defacto2.net"
    var wget = {
        "regex": "#base#/d/",
        "url": "#base#/html3/#params.action#/#params.key#/?#link.wget#"
    }
    wget.options = '-nv -rnd --content-disposition -e "robots=off" --reject="index.html*" --accept-regex="^#wget.regex#*" '
</cfscript><cfoutput><em>#records.recordCount# files listed using <strong>#humanizeFileSize(Val(filesizeSum))#</strong></em>.
<cfif records.recordCount GTE 4><p>To download all these files use this <kbd><a href="https://www.gnu.org/software/wget/">wget</a></kbd> command:<br>
<font color="olive"><kbd>wget #wget.options# "#wget.url#"</kbd></font></p></cfif>
</cfoutput>