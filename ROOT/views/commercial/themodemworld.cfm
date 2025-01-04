<!---
	'Warez: The Infrastructure and Aesthetics of Piracy view
	path: views/commercial/themodemworld.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'The Modem World: A Prehistory of Social Media'
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(action='index')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(action='warez')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(action='demoArtScene')#"></button>
	</span>
	</form></cfoutput>
<div id="commercial-controller" class="readable-text">
	<dl itemscope itemtype="https://schema.org/Book" itemid="urn:isbn:9780300248142">
		<dt class="hidden">Title</dt>
		<dd class="hidden" itemprop="title">The Modem World: A Prehistory of Social Media
		<dt>Author</dt>
		<dd itemprop="author"><a href="//kevindriscoll.info/">Kevin Driscoll</a>
		<dt>Publisher</dt>
		<dd itemprop="publisher"><a href="//yalebooks.yale.edu/book/9780300248142/modem-world/">Yale University Press</a>
		<dt>Publication date</dt>
		<dd><time itemprop="datePublished" datetime="2022-05-17">May 17 2022</time>
		<dt>Size</dt>
		<dd><span itemprop="numberOfPages">328</span> pages</dd>
	</dl>
	<div class="panel panel-default">
		<div class="panel-body">
			<img src="/images/commercial/thumb_themodemworld.jpg" alt="book preview" class="preview commercial-thumb" width="150" height="240">
			<!--- <p id="review-rating">Our Review: <span class="badge">n/a</span></p> --->
			<p><strong>The untold story about how the internet became social, and why this matters for its future</strong></p>
			<q>Fifteen years before the commercialization of the internet, millions of amateurs across North America created more than 100,000 small-scale computer networks. The people who built and maintained these dial-up bulletin board systems (BBSs) in the 1980s laid the groundwork for millions of others who would bring their lives online in the 1990s and beyond. From ham radio operators to HIV/AIDS activists, these modem enthusiasts developed novel forms of community moderation, governance, and commercialization. The Modem World tells an alternative origin story for social media, centered not in the office parks of Silicon Valley or the meeting rooms of military contractors, but rather on the online communities of hobbyists, activists, and entrepreneurs. Over time, countless social media platforms have appropriated the social and technical innovations of the BBS community. How can these untold stories from the internet’s past inspire more inclusive visions of its future?</q>
		</div>
		<div class="list-group">
			<a href="https://yalebooks.yale.edu/book/9780300248142/the-modem-world/" class="list-group-item">
				<h4 class="list-group-item-heading">Yale University Press, USD $28 <small>Hardcover</small></h4>
			</a>
			<a href="https://www.amazon.com/dp/0300248148" class="list-group-item">
				<h4 class="list-group-item-heading"><i class="fab fa-amazon fa-fw"></i> USD $28 <small>Hardcover</small></h4>
			</a>
			<a href="https://www.goodreads.com/book/show/58616820-the-modem-world" class="list-group-item">
				<h4 class="list-group-item-heading">Goodreads <small>Community reviews</small></h4>
			</a>
			<a href="https://www.wired.com/story/internet-origin-story-bbs/" class="list-group-item">wired.com <small>The Internet Origin Story You Know Is Wrong</small></a>
		</div>
	</div>
</div>