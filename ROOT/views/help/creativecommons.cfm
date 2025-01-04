<!---
  	Copyrights and the Creative Commons licence help view.
	path: views/help/creativecommons.cfm

@CFLintIgnore
--->
<cfscript>
	param name="param.extlink" default="" type="string";
	extlink = [
		'//creativecommons.org/licences/by/4.0/',
		'https://archive.apache.org/dist/httpd/',
		'//defacto2.net/f/a92116e',
		'//www.apache.org/licenses/LICENSE-2.0.html',
		'//defacto2.net/images/uuid/original/f139f92c-ac96-486c-a51b-50b19a75397e.webp',
		'//getbootstrap.com/',
		'//cfwheels.org/',
		'//fontawesome.com/license',
		'//scripts.sil.org/OFL',
		'https://github.com/twbs/bootstrap/blob/master/LICENSE',
		'//creativecommons.org/licenses/by/3.0/']
	pageAbout.text = 'Copyrights'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='privacy')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
	</span>
	</form>
	<div class="readable-text" id="help-controller">
		<p>
			<span class="fa-3x fa-as-first-letter"><i class='fab fa-creative-commons'></i><i class='fab fa-creative-commons-by'></i></span>
			<p class="lead">This site uses the Creative Commons Attribution 4.0 International license. It enables you to use our website assets with your projects.</p>
		</p>
		<br>
		<p>
			The <dfn>Creative Commons Attribution 4.0 International license</dfn> applied to #application.domain# is a liberal implementation of copyright.
			You are free to use the original content as is or modify it to your needs.
		</p><p>
		The only requirement we impose is that you attribute, that is give credit to #application.domain# for each piece of content you use.
		This attribution can either be placed on the content itself or distributed in a separate file within the content.
		</p><p>
		You can find more information on our Creative Commons license at the #linkTo(href=extlink[1],text="Creative Commons website")#, containing links to the legal code (full license).
		</p>
		<br>
		<dl>
		<dt>This license coverage includes</dt>
		<dd>
			Website text and database content.<br>
			Images including previews and screenshots.<br>
			Videos hosted on YouTube.<br>
		</dd>
		</dl>
		<dl>
			<dt class="text-danger">The license excludes</dt>
			<dd>All file downloads hosted and served using the <a href="//defacto2.net/d/">defacto2.net/d</a> <small>URL. © by the creators or authors.</small><br>
			Glyphs and fonts named with the <code>fa-</code> prefix is <a href="#extlink[8]#">used under a commercial license</a>. <small>© Fonticons, Inc.</small><br>
			Images and icons contained in <samp>/images/html3/</samp>, <small>are in the public domain and taken from the Apache 1.3.9 icon set.</small></dd>
		</dl>
		<dl>
		<dt class="text-success">Implementation example</dt>
		</dl>
		<p>If using the <a href="#extlink[5]#">screenshot</a> from the <a href="#extlink[3]#">Defacto2 Web-Intro</a>,
		an appropriate attribution would be one of the following:</p>
		<ol>
			<li>Screenshot (<a href="#extlink[3]#">Defacto2</a>)</li>
			<li><a href="#extlink[3]#">Screenshot</a></li>
			<li><a href="#extlink[3]#">Defacto2</a></li>
			<li>Screenshot: defacto2.net/f/a92116e</li>
		</ol>
		<br>
		#includePartial('externallinks')#
	</div>
</cfoutput>