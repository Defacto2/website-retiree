<!---
    Donate costs partial view
	path: views/defacto2/_costs.cfm

@CFLintIgnore
--->
<cfscript>
  var cost1 = 240               // digitalocean hosting charge
  var cost2 = cost1*(20/100)    // backup is 20% of hosting charge
  var cost3 = (cost1+cost2)/10  // gst is 10% of digitalocean total
  var cost4 = 9.95              // domain hosting renewal
  var cost0 = cost1+cost2+cost3+cost4
</cfscript>
<cfoutput><h2><small>The annual cost is</small> <b class="brand-danger"><small>USD $ </small>#cost0#</b></h2>
<br>
<ul class="list-group">
    <li class="list-group-item"><b class="brand-danger">$#cost1#</b><br><small>file downloads, database and website hosting</small></li>
    <li class="list-group-item"><b class="brand-danger">$#cost2#</b><br><small>backups</small></li>
    <li class="list-group-item"><b class="brand-danger">$#cost3#</b><br><small>value added tax</small></li>
    <li class="list-group-item"><b class="brand-danger">$#cost4#</b><br><small>domain name</small></li>
</ul></cfoutput>
<p><small>Last updated May 2022</small></p>
