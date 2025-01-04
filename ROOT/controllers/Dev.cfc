<!---
	/dev/null redirect controller file.
	path: controllers/Dev.cfc
	status: complete

@CFLintIgnore
--->
component
  extends="Controller"
  output=false
{
  function config() {
    provides("html")
  }

  function null() {
    var db = "?";
    if(structKeyExists(session,"errcnt") &&
      isNumeric(session.errcnt) &&
      session.errcnt > 0) db = session.errcnt;
    header name="Douchebag" value="#db#";
    renderText('<html><body style="text-align:center;"><h1 style="font-size:10000%">🙈</h1><p>controversy is a last resort for the talentless</p></body></html>');
  }
}