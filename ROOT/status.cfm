<cfcontent reset="true"><cfprocessingdirective suppressWhiteSpace = "true"><cfsilent>
    <!--- /status.cfm --->
    <cfscript>
        statusCode = 200
        statusText = "OK"
        userAgent = CGI.httpUserAgent
    </cfscript>
    <!--- used by Docker Compose to check the Tomcat status and CFML abilities --->
    <cfheader name="Content-Type" value="text/plain; charset=utf-8" />
    <cfheader name="Expires" value="#GetHttpTimeString(Now())#" />
    <cfheader statusCode="#statusCode#" value="#statusText#" /><!---
    <cfheader name="X-ServerName" value="#CGI.server_name#" />
    <cfheader name="X-AppDomain" value="#application.domain#" />--->
</cfsilent><cfoutput>#statusCode# #statusText##chr(13)##userAgent##chr(13)#🂡</cfoutput></cfprocessingdirective>