<!---
  	Database dashboard view.
	path: views/admin/dashboard.cfm

@CFLintIgnore
--->
<cfdbinfo name="dbVersion" datasource="#get('dataSourceName')#" dbname="#get('dataSourceUserName')#" password="get('dataSourcePassword')" type="version" />
<cfoutput>
<div class="row">
	<div class="col-lg-6 col-md-10 col-sm-12 col-lg-offset-3">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Database source and tables</h3>
			</div>
			<table class="table gray-dark">
				<thead>
				<tr><td class="col-lg-3 col-md-4 col-sm-5">Datasource name</td><td><b class="brand-primary">#get("dataSourceName")#</b></td></tr>
				</thead>
				<tbody>
				<tr><td>Database product name</td><td>#dbVersion.DATABASE_PRODUCTNAME#</td></tr>
				<tr><td>MySQL version</td><td>v#listFirst(dbVersion.DATABASE_VERSION,"-")#</td></tr>
				<tr><td>#dbVersion.DRIVER_NAME# driver</td><td>v#replaceNoCase(listFirst(dbVersion.DRIVER_VERSION, " "),"mysql-connector-java-","")#</td></tr>
				<tr><td>Java database connectivity</td><td>v#dbVersion.JDBC_MAJOR_VERSION#.#dbVersion.JDBC_MINOR_VERSION#</td></tr>
				</tbody>
				<thead>
					<th>Table</th><th>Records</th>
				</thead>
				<cfloop list="#get(myapp).dbTables#" index="local.table">
					<cftry>
						<cfset local.tables[table] = model("#table#").new()>
						<tr>
							<td><small><samp>#get("dataSourceName")#.</samp></small><samp>#UCase(table)#</samp>
						</td><td>
							<i class="fal fa-check fa-fw fa-lg brand-success"></i> #tables[table].Count()#
						</td></tr>
						<cfcatch>
							<tr class="error">
								<td><samp>#get("dataSourceName")#.#UCase(table)#</samp>
							</td><td>Table missing!</td></tr>
						</cfcatch>
						</cftry>
				</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</div>
</cfoutput>