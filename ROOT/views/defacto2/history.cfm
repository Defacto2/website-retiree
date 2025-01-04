<!---
    The history of Defacto2 view
	path: views/defacto2/history.cfm

@CFLintIgnore
--->
<cfscript>
	param name="artpacks" type="string" default="https://files.scene.org/view/demos/groups/defacto2/artpacks";
	param name="intros" type="string" default="https://files.scene.org/browse/demos/groups/defacto2/intros/";
	param name="musictrack" type="string" default="https://files.scene.org/browse/demos/groups/defacto2/music/";
	param name="musicchip" type="string" default="https://files.scene.org/browse/demos/groups/defacto2/zalza/";
	var site = get('siteAreas').titles.df2
	pageAbout.text = 'Our history'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<div class="readable-text" id="defacto2-controller">
		<p class="lead text-center">Defacto founded in late February or early March of 1996,<br>as an electronic magazine that wrote about the Scene subculture.</p>
		<div class="panel panel-default">
			<div class="panel-heading lead">Defacto <small>from 1996</small></div>
			<div class="panel-body">
First known as <dfn>#linkTo(text="Defacto", route="g", orgname="defacto")#</dfn>, we were founded by a group of individuals as a side project for the group <dfn>#linkTo(text="Sodom", route="g", orgname="sodom")#</dfn>. The intention was to create an electronic magazine that reported on the daily happenings of the Scene. And to fill the gap left by an earlier publication #linkTo(text="Reality Check Network", route="g", orgname="reality-check-network")# that had called it quits. While our magazine never gained the same cult following that <abbr title="Reality Check Network">RCN</abbr> commanded, it was considered a decent alternative. After eight public issues, Defacto vanished but later returned with a new format and a new name Defacto 2.
			</div>
			<div class="list-group">
				<a href="#URLFor(route="g",orgname="defacto")#" class="list-group-item">
					Collection of magazines
				</a>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading lead">Defacto 2 Magazine <small>from 1997</small></div>
			<div class="panel-body">
				The first <dfn>#linkTo(text="Defacto 2", route="g", orgname="defacto2")#</dfn> was a monthly magazine published in an ASCII text format. The publication only released three issues, but these were considered an improvement over the earlier Defacto magazine due to their extensive articles and collections of interviews with scene personalities.
			</div>
			<div class="list-group">
				<a href="#URLFor(route="g",orgname="defacto2",params="section=magazine")#" class="list-group-item">
					Collection of magazines
				</a>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading lead">Defacto2 Art Group</div>
			<div class="panel-body">
				<p>
Due to time constraints, the Defacto 2 magazine stopped, but the brand continued. It moved into a moderately successful art group for the Scene. As an art group, Defacto2 operated as a collective of digital artists who did gratis commissions for groups as well as unrelated non-scene art. These works included web pages, logos and NFO files.
				</p><p>
Initially, lead by #linkTo(text="Ipggi", route="p", personname="ipggi")# and later by #linkTo(text="Seffren", route="p", personname="seffren")# the group was unique in that it didn't demand membership exclusivity. Many of our members were also co-members with other popular groups of the time such as #linkTo(text="X-Pression", route="g", orgname="x_pression-design")# and #linkTo(text="Superior Art Creations", route="g", orgname="superior-art-creations")#.
				</p><p>
While you can find some of our work below under Defacto2 Art Packs, many of our members were involved in side projects that would be familiar to participants of the Scene during the late 1990s and early 2000s. #linkTo(text="Antibody's", route="p", personname="antibody")# ASCII header for #linkTo(text="Class", route="g", orgname="class")#, for example, can be seen all their <abbr title="information file">NFO</abbr>s from 1998 until their retirement. So if you ever see the tag code <abbr title="Defacto2"><code>[df2]</code></abbr> contained within an old <abbr title="information file">NFO</abbr> or release package, the chances are that one of our members probably did it.
				</p><p>
Unfortunately, after three years of sporadic releases, the art group was put to rest on the 31st December 1999 with one final release, Art Pack Issue Five. Seffren, the leader, had decided it was time to move on from the Scene to try some new things in life.
				</p>
			</div>
			<div class="list-group">
				<a href="https://demozoo.org/groups/10000/" class="list-group-item">Defacto2 on Demozoo</a>
				<a href="#intros#" class="list-group-item">Defacto2 Design <em>Promotion Intros</em></a>
				<a href="#musictrack#" class="list-group-item">Defacto2 Design <em>Tracker Music</em></a>
				<a href="#musicchip#" class="list-group-item">Defacto2 Design <em>Chip Music by Zalza</em></a>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading lead">Defacto2 Art Packs</div>
			<div class="panel-body">
				<div class="col-md-6 col-lg-6">
					<div class="panel panel-default">
						<div class="panel-heading">Art Pack Issue One - 'Beginning'</div>
						<div class="list-group">
							<p class="list-group-item">Published on the 10th of January 1998</p>
							<p class="list-group-item">
								#imageTag(source="defacto2/thumb_pack1a.png", alt="Pack preview", class="screen-shot")#
								#imageTag(source="defacto2/thumb_pack1b.png", alt="Pack preview", class="screen-shot")#
							</p>
							<a href="#artpacks#/df2pack01.zip" class="list-group-item">Download</a>
						</div>
					</div>
				</div>
				<div class="col-md-6 col-lg-6">
				<div class="panel panel-default">
					<div class="panel-heading">Art Pack Issue Two - '01001'</div>
					<div class="list-group">
						<p class="list-group-item">Published on the 1st of May 1998</p>
						<p class="list-group-item">
							#imageTag(source="defacto2/thumb_pack2a.png", alt="Pack preview", class="screen-shot")#
							#imageTag(source="defacto2/thumb_pack2b.png", alt="Pack preview", class="screen-shot")#
						</p>
						<a href="#artpacks#/df2pack02.zip" class="list-group-item">Download</a>
					</div>
				</div>
				</div>
				<div class="col-md-6 col-lg-6">
				<div class="panel panel-default">
					<div class="panel-heading">Art Pack Issue Three - 'Heaven'</div>
					<div class="list-group">
						<p class="list-group-item">Published on the 2nd of July 1999</p>
						<p class="list-group-item">
							#imageTag(source="defacto2/thumb_pack3a.png", alt="Pack preview", class="screen-shot")#
							#imageTag(source="defacto2/thumb_pack3b.png", alt="Pack preview", class="screen-shot")#
						</p>
						<a href="#artpacks#/df2pack3.zip" class="list-group-item">Download</a>
					</div>
				</div>
				</div>
				<div class="col-md-6 col-lg-6">
				<div class="panel panel-default">
					<div class="panel-heading">Art Pack Issue Four - 'Bird'</div>
					<div class="list-group">
						<p class="list-group-item">Published on the 14th of October 1999</p>
						<p class="list-group-item">
							#imageTag(source="defacto2/thumb_pack4a.png", alt="Pack preview", class="screen-shot")#
							#imageTag(source="defacto2/thumb_pack4b.png", alt="Pack preview", class="screen-shot")#
						</p>
						<a href="#artpacks#/df2pack04.zip" class="list-group-item">Download</a>
					</div>
				</div>
				</div>
				<div class="col-md-6 col-lg-6 col-md-offset-3 col-lg-offset-3">
				<div class="panel panel-default">
					<div class="panel-heading">Art Pack Issue Five - 'Millennium'</div>
					<div class="list-group">
						<p class="list-group-item">Published on the 31st of December 1999</p>
						<p class="list-group-item">
							#imageTag(source="defacto2/thumb_pack5a.png", alt="Pack preview", class="screen-shot")#
							#imageTag(source="defacto2/thumb_pack5b.png", alt="Pack preview", class="screen-shot")#
						</p>
						<a href="#artpacks#/df2000.zip" class="list-group-item">Download</a>
					</div>
				</div>
				</div>
			</div>
			<div class="list-group">
				<a href="#URLFor(controller="Defacto2", action="index", rel="prefetch", id="GotoFirstPage")#" class="list-group-item">
					<h4 class="list-group-item-heading">What is #get('siteAreas').titles.df2#?</h4>
				</a>
				<a href="#URLFor(controller="Defacto2", action="subculture", rel="prefetch", id="GotoPrevPage")#" class="list-group-item">
					<h4 class="list-group-item-heading">What is the Scene?</h4>
				</a>
			</div>
		</div>
	</div>
</cfoutput>