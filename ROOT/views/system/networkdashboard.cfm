<!---
  	Network dashboard view.
	path: views/system/networkdashboard.cfm

@CFLintIgnore
--->
<cfset icon = '<i class="fal fa-cog fa-fw"></i> '>
<cfoutput>
<div class="row">
	<div class="col-md-6">
		<!--- ifconfig --->
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Internet Protocol configuration</h3>
			</div>
			<div class="panel-body">
				<pre>#ipconfig.cmd#</pre>
				<small>Lists the Internet Protocol (IPv4, IPv6) configurations for each network hardware device operating on the web server</small>
				<br>
				<div class="terminal-mock">
				<cfif Len(ipconfig.console)>
					<p><pre><samp>#XmlFormat(ipconfig.console)#</samp></pre></p>
				<cfelse>
					<p>No IP config information</p>
				</cfif>
				</div>
			</div>
		</div>
	</div>
	<div class="col-md-6">
		<!--- dns lookup --->
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">DNS lookup for #application.domain#</h3>
			</div>
			<div class="panel-body">
				<pre>#dnslookup.cmd#</pre>
				<small>This is the public domain (whois) record for #application.domain#</small>
				<br>
				<div class="terminal-mock">
				<cfif Len(ipconfig.console)>
					<p><pre><samp>#XmlFormat(dnslookup.console)#</samp></pre></p>
				<cfelse>
					<p>No DNS lookup information</p>
				</cfif>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-6">
		<!--- ping --->
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Ping google.com</h3>
			</div>
			<div class="panel-body">
				<pre>#dnslookup.cmd#</pre>
				<small>Determines the round time it takes for a data request to be sent from the #application.domain# web server to google.com and then return the reply</small>
				<br>
				<div class="terminal-mock">
				<cfif Len(ping.console)>
					<p><pre><samp>#XmlFormat(ping.console)#</samp></pre></p>
				<cfelse>
					<p>No DNS lookup information</p>
				</cfif>
				</div>
			</div>
		</div>
	</div>
	<div class="col-md-6">
		<!--- netstat --->
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Netstat</h3>
			</div>
			<div class="panel-body">
				<pre>#netstat.cmd#</pre>
				<small>Determines the round time it takes for a data request to be sent from the #application.domain#</small>
				<br>
				<div class="terminal-mock">
				<cfif Len(netstat.console)>
					<p><pre><samp>#XmlFormat(netstat.console)#</samp></pre></p>
				<cfelse>
					<p>No netstat information</p>
				</cfif>
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>