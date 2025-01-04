<!---
	'Warez: The Infrastructure and Aesthetics of Piracy view
	path: views/commercial/warez.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Warez: The Infrastructure and Aesthetics of Piracy'
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='theModemWorld')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='mindCandyVol3')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
	</form></cfoutput>
<div id="commercial-controller" class="readable-text">
	<dl itemscope itemtype="https://schema.org/Book" itemid="urn:isbn:978-1-68571-036-1">
		<dt class="hidden">Title</dt>
		<dd class="hidden" itemprop="title">Warez: The Infrastructure and Aesthetics of Piracy
		<dt>Author</dt>
		<dd itemprop="author"><a href="//eve.gd/c-v/">Martin Paul Eve</a>
		<dt>Publisher</dt>
		<dd itemprop="publisher"><a href="https://punctumbooks.com/titles/warez-the-infrastructure-and-aesthetics-of-piracy/">punctum books</a>
		<dt>Publication date</dt>
		<dd><time itemprop="datePublished" datetime="2021-12-15">December 15 2021</time>
		<dt>Size</dt>
		<dd><span itemprop="numberOfPages">444</span> pages</dd>
	</dl>
	<div class="panel panel-default">
		<div class="panel-body">
			<img src="/images/commercial/thumb_warez.jpg" alt="book preview" class="preview commercial-thumb" width="150" height="240">
			<!--- <p id="review-rating">Our Review: <span class="badge">n/a</span></p> --->
			<q>When most people think of digital piracy, the phrases that likely come to mind are “Bittorrent”, “Napster”, and “The Pirate Bay”; the popular manifestations and accessible incarnations of home copyright violation. However, this is a poor reflection of a submerged and elite culture of an underground piracy scene that for several decades has operated on a secretive and hierarchical basis of suppliers, couriers, release groups, and “topsites”. The true “warez scene” as it is known, is undetected by the general public, but well-acquainted with high-level law enforcement. This book offers the first academic study of the gigabytes of digital material surfaced by “The Scene” in the form of ASCII .nfo files and DemoScene executables from the Defacto2 archive, charting the structure, organization, and history of the criminal underground networks that race to release material before their competitors with bleeding-edge technology and connections. Using a combination of traditional and digital reading methodologies, this book presents both the historical structures but also aesthetic strictures of the underground warez scene at the turn of the twenty-first century. As such, this book is also one of the first studies to construct a distant-ethnography from a digital archive, reading from the digital-material traces the contexts and after-images of an otherwise inaccessible digital-cultural sphere. From the technologies of text that it examines, Trading Scenes resurrects a secretive space that has had wide-ranging implications for law, media, and many other areas of contemporary cultural digital life.</q>
		</div>
		<div class="list-group">
			<a href="https://www.amazon.com/Warez-Infrastructure-Martin-Paul-Eve/dp/1685710360" class="list-group-item">
				<h4 class="list-group-item-heading"><i class="fab fa-amazon fa-fw"></i> USD $25 <small>Paperback</small></h4>
			</a>
			<a href="https://www.amazon.co.uk/Warez-Infrastructure-Martin-Paul-Eve/dp/1685710360" class="list-group-item">
				<h4 class="list-group-item-heading"><i class="fab fa-amazon fa-fw"></i> GBP £22 <small>Paperback</small></h4>
			</a>
			<a href="https://library.oapen.org/handle/20.500.12657/52029" class="list-group-item">OAPEN <small>PDF (CC BY-NC-SA 4.0)</small></a>
			<a href="https://eprints.bbk.ac.uk/id/eprint/30956/" class="list-group-item">Birkbeck Institutional Research Online <small>PDF (CC BY-NC-SA 4.0)</small></a>
			<a href="https://www.goodreads.com/book/show/58517606-warez" class="list-group-item">
				<h4 class="list-group-item-heading">Goodreads <small>Community reviews</small></h4>
			</a>
		</div>
	</div>
</div>