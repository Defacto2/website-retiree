<!---
    Database data & GitHub view.
	path: views/code/index.cfm

@CFLintIgnore
--->
<cfscript>
    var insertLink = "https://defacto2.net/sql/d2-sql-insert.sql"
    var updateLink = "https://defacto2.net/sql/d2-sql-update.sql"
	pageAbout['text'] = ' Database &amp; GitHub'
	pageAbout['icon'] = 'fal fa-code-branch'
</cfscript>
<cfoutput>
    <div class="readable-text" id="defacto2-controller">
        <h3>Database</h3>
        <p class="lead">Defacto2 creates a downloadable daily dump of its
            <a href="https://dev.mysql.com/doc/refman/8.0/en/">MySQL 8</a> database.
            <br><small><a href="https://github.com/Defacto2/database">Instructions for usage</a>.</small>
        </p>
        <div class="panel panel-info">
            <div class="panel-body">
                <h4>Create and Insert</h4>
To create new or remove all existing tables and data, create and insert includes the following statements:<br>
<code>DROP TABLE, CREATE TABLE, INSERT</code>
            </div>
            <div class="list-group">
                <a href="#insertLink#" class="list-group-item"><h4 class="list-group-item-heading"><small>SQL download </small><code class="text-uppercase">d2-sql-insert.sql</code></h4></a>
            </div>
        </div>
        <div class="panel panel-info">
            <div class="panel-body">
                <h4>Replace to update</h4>
To update changed data, replace to update includes the following statement:<br>
<code>REPLACE INTO</code>
            </div>
            <div class="list-group">
                <a href="#updateLink#" class="list-group-item"><h4 class="list-group-item-heading"><small>SQL download </small><code class="text-uppercase">d2-sql-update.sql</code></h4></a>
            </div>
        </div>
        <hr>
        <h3>GitHub</h3>
        <p>Defacto2 has an organization on GitHub where you can find notes and wikis for Defacto2 and repositories for historical scene websites.
        The defacto2.net repository is where <a href="https://github.com/Defacto2/defacto2.net/issues">you can submit issues and feature requests</a> for this website.</p>
        <p class="lead"><a href="https://github.com/defacto2">github.com/defacto2</a></p>
        <hr>
        <h3>Source code</h3>
        <p class="brand-danger lead">Unfortunately, the source code is unavailable.</p>
        <p>Currently, the source code to Defacto2 is not open, but a longer-term goal is to have it publically accessible on <a href="https://github.com/defacto2">GitHub</a>.</p>
        <hr>
        <h3>API</h3>
        <p class="brand-danger lead">Unfortunately, there is no API available.</p>
        <hr>
		<h4>#linkTo(route="contact",text="Want to get in contact?")#</h4>
        <br>
	</div>
</cfoutput>