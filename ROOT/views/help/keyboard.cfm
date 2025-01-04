<!---
  	Keyboard input and touch gestures help view.
	path: views/help/keyboard.cfm

@CFLintIgnore
--->
<cfscript>
	pageAbout.text = 'Keyboard inputs'
	pageAbout.icon = ''
</cfscript>
<cfoutput>
	<form method="post">
	<span class="hidden">
		<!--- used by javascript pagination, should be kept hidden --->
		<button id="GotoFirstPage" type="submit" formaction="#URLFor(controller='Help',action='index')#"></button>
		<button id="GotoPrevPage" type="submit" formaction="#URLFor(controller='Help',action='browserSupport')#"></button>
		<button id="GotoNextPage" type="submit" formaction="#URLFor(controller='Help',action='viruses')#"></button>
		<button id="GotoLastPage" type="submit" formaction="#URLFor(controller='Help',action='categories')#"></button>
	</span>
	</form>
	<div class="readable-text" id="help-controller">
		<p class="lead">
		#get('siteAreas').titles.df2# supports a couple of shortcuts.
		</p>
		<p>
		Where ever you see the #touchandkeyboardIcons()# icon or browsing the file details, you will be able to use these keyboard interactions.
		</p>
	<div class="media">
	<div class="media-center">
		<kbd><i class='fal fa-arrow-left fa-fw'></i></kbd> <kbd><i class='fal fa-arrow-right fa-fw'></i></kbd>
	</div>
	<div class="media-body">
		<h4 class="media-heading"><strong>Keyboard pagination</strong></h4>
		The left and right arrow keys will cycle through the previous and next pages.
	</div>
	</div>
	<div class="media">
	<div class="media-center">
		<kbd>Ctrl</kbd> <strong>+</strong> <kbd><i class='fal fa-arrow-left fa-fw'></i></kbd> <kbd><i class='fal fa-arrow-right fa-fw'></i></kbd>
	</div>
	<div class="media-body">
		<h4 class="media-heading"><strong>Start and end</strong> on Windows and Linux</h4>
		The control key combined with either the left or right arrow keys will jump to the first and last pages.
	</div>
	</div>
	<div class="media">
	<div class="media-center">
		<kbd><i class='fal fa-angle-up fa-fw fa-lg'></i></kbd> <strong>+</strong> <kbd>⌘</kbd> <strong>+</strong> <kbd><i class='fal fa-arrow-left fa-fw'></i></kbd> <kbd><i class='fal fa-arrow-right fa-fw'></i></kbd>
	</div>
	<div class="media-body">
		<h4 class="media-heading"><strong>Start and end</strong> on macOS</h4>
		The control and the command keys combined with either the left or right arrow keys will jump to the first and last pages.
	</div>
	</div>
</div>
</cfoutput>