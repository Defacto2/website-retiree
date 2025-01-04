<!---
	Routing - https://guides.cfwheels.org/docs/routing
	path: config/routes.cfm

@CFLintIgnore GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN
--->
<cfscript>
// mapFormat: This is useful for providing formats via URL like json, xml, pdf, etc.
// Set to false to disable automatic .[format] generation for resource based routes.
mapper(mapFormat=false)
	// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
	// This way you don't need to explicitly add a route every time you create a new action in a controller.
	// Enabling wildcard breaks Defacto2 site functionality and navigation.
	//.wildcard()

	// Controller maps. These must be listed before all named routes.

	// MENU
	// Email or chat
	.resources(name='contact', nested=true)
		.collection()
		.get('index')
		.end()
	.end()
	// Help and legal stuff
	.resources(name='help', nested=true)
		.collection()
		// get
		.get(name='cc', to='help##creativeCommons')
		.get('index')
		.get('allowedUploads')
		.get('browserSupport')
		.get('categories')
		.get('keyboard')
		.get('privacy')
		.get('viruses')
		// post (used by keyboard page examples)
		.post(name='cc', to='help##creativeCommons')
		.post('index')
		.post('allowedUploads')
		.post('browserSupport')
		.post('categories')
		.post('keyboard')
		.post('privacy')
		.post('viruses')
		.end()
	.end()
	// Send us youre files (uploads)
	.resources(name='upload', nested=true)
		.collection()
		// get
		.get('index')
		.get('art')
		.get('document')
		.get('external')
		.get('file')
		.get('intro')
		.get('magazine')
		.get('other')
		.get('site')
		.get('submitFile') // allow for CURL submission
		// post
		.post('index')
		.post('submitFile')
		// json output
		.get(name='lookupDemozoo', pattern='lookup-demozoo/[key]')
		.get(name='lookupPouet', pattern='lookup-pouet/[key]')
		.get(name='lookupYouTube', pattern='lookup-you-tube/[key]')
		.end()
	.end()
	// Learn about Defacto2
	.resources(name='defacto2', nested=true)
		.collection()
		.get('index')
		.get('donate')
		.get('history')
		.get('subculture')
		.end()
	.end()
	// Publications
	.resources(name='commercial', nested=true)
		.collection()
		.get(name='index')
		.post(name='index')
		.get(name='bbsTheDocumentary')
		.post(name='bbsTheDocumentary')
		.get(name='commodork')
		.post(name='commodork')
		.get(name='darkDomain')
		.post(name='darkDomain')
		.get(name='demoArtScene')
		.post(name='demoArtScene')
		.get(name='digitalCultureIndustry')
		.post(name='digitalCultureIndustry')
		.get(name='digitialMemories1')
		.post(name='digitialMemories1')
		.get(name='freaxArtAlbum')
		.post(name='freaxArtAlbum')
		.get(name='freaxVol1')
		.post(name='freaxVol1')
		.get(name='mindCandyVol1')
		.post(name='mindCandyVol1')
		.get(name='mindCandyVol2')
		.post(name='mindCandyVol2')
		.get(name='mindCandyVol3')
		.post(name='mindCandyVol3')
		.get(name='sceenMagazine')
		.post(name='sceenMagazine')
		.get(name='softwarePiracyExposed')
		.post(name='softwarePiracyExposed')
		.get(name='stealThisComputerBook')
		.post(name='stealThisComputerBook')
		.get(name='theModemWorld')
		.post(name='theModemWorld')
		.get(name='warez')
		.post(name='warez')
		.end()
	.end()
	// API, code and data
	.resources(name='code', nested=true)
		.collection()
		.get(name='index')
		.end()
	.end()

	// HOME
	.resources(name='home', nested=true)
		.collection()
		.get('index')
		.post('countbots')
		.post('counthumans')
		.post('recentfiles')
		.end()
	.end()
	// FILES
	.post(name='fprocess', pattern='edit/[key]', to='file##edit')
	.get(name='fprocess', pattern='edit/[key]', to='file##edit')
	.resources(name='file', nested=true)
		.collection()
		// get
		.get('index')
		.get('list')
		.get(name='adjustdisplay')
		.get(name='httprequest', pattern='httprequest') // replace file from an external link
		.get(name='edit', pattern='edit', to='file##edit')
		.get(name='raw', pattern='raw/[key]')
		.get(name='view', pattern='view/[key]')
		// post
		.post(name='adjustdisplay')
		.post(name='list', pattern='list/waitingapproval', to='file##list')
		.post('delete')
		.post(name='edit', pattern='edit', to='file##edit')
		.post('replace')
		.post('save')
		.post('images')
		.post(name='view', pattern='view/[key]')
		.end()
	.end()
	// GROUPS
	.resources(name='organisation', nested=true)
		.collection()
		.get('list')
		.post(name='list', pattern='list/[key]', to='organisation##list')
		.end()
	.end()
	.resources(name='group', controller='organisation', nested=true)
		.collection()
		.get('index')
		.end()
	.end()
	// PEOPLE
	.resources(name='person', nested=true)
		.collection()
		.get('list')
		.post(name='list', pattern='list/[key]', to='person##list')
		.end()
	.end()
	// SEARCH
	.resources(name='search', nested=true)
		.collection()
		.post('processurl')
		.get('result')
		.end()
	.end()
	// WEBSITES / LINK
	.resources(name='link', nested=true)
		.collection()
		// get
		.get('index')
		.get('add')
		.get(name='edit', pattern='edit/[key]', to='link##edit')
		.get('list')
		.get(name='operator', pattern='operator/[key]', to='link##operator')
		.get(name='visit', pattern='visit/[key]', to='link##visit')
		.get(name='waybackweb', pattern='waybackweb/[key]', to='link##wayback')
		// post
		.post(name='delete', pattern='delete/[key]', to='link##delete')
		.post(name='edit', pattern='edit/[key]', to='link##edit')
		.post(name='httpreset', pattern='httpreset/[key]', to='link##httpreset')
		.post('list')
		.post(name='operator', pattern='operator/[key]', to='link##operator')
		.post('new')
		.post(name='update', pattern='update/[key]', to='link##update')
		.end()
	.end()
	// HTML3
	.resources(name='html3', nested=true)
		.collection()
		.get('index')
		.get(name='art', to='html3##art')
		.get('categories')
		.get(name='documents', to='html3##documents')
		.get('groups')
		.get('notfound')
		.get('platforms') // empty value listed
		.get('software')
		.get('testhtml3error')
		.end()
	.end()
	// ADMIN / OPERATOR
	.resources(name='operator', nested=true)
		.collection()
		// get
		.get('index')
		.get('add')
		.get(name='edit')
		.get('signin')
		.get('signout')
		// post
		.post('index')
		.post('save')
		.post('signin')
		.post('signinconnection')
		.post('signout')
		.end()
	.end()
	// Admin / DATABASE
	.resources(name='admin', nested=true)
		// get
		.get(name='dashboard', pattern='admin/dashboard')
		.get(name='link', pattern='admin/link')
		.get(name='organisation', pattern='admin/organisation')
		.get(name='person', pattern='admin/person')
		// post
		.post(name='dashboard', pattern='admin/dashboard')
		.post(name='organisation', pattern='admin/organisation')
		.post(name='person', pattern='admin/person')
	.end()
	// SYSTEM
	.resources(name='system', nested=true)
		// get
		.collection()
		.get('cachereset')
		.get(name='download', pattern='download/[key]')
		.get(name='files', pattern='files/[key]', to='system##files')
		.post('link')
		.get('logs')
		.get(name='logtailed', pattern='logtailed/[key]')
		.get('networkdashboard')
		.get('notfound') // custom site-wide 404 page
		.get('pathsdashboard')
		.get(name='sessions', pattern='sessions/[key]')
		.post(name='sessions', pattern='sessions/[key]')
		.get('softwaredashboard')
		.post('softwaredashboard')
		.get('testhtml3error')
		.get('testhtml5error')
		.get('testupload')
		// post
		.post('serverfreeram') // json
		.post('serverfreehd') // json
		.post('templateconfirm')
		.post('testupload')
		.end()
	.end()

	// Named GET filter routes
	.get(name='editUser', pattern='operator/edit/[key]', to='operator##edit')
	.get(name='fileFilter', pattern='file/list/[key]', to='file##list', key='key')
	.get(name='html3Category', pattern='html3/category/[key]', to='html3##category')
	.get(name='html3Group', pattern='html3/group/[key]', to='html3##group')
	.get(name='html3Platform', pattern='html3/platform/[key]', to='html3##platform')
	.get(name='linkFilter', pattern='link/list/[key]', to='link##list')
	.get(name='organisationFilter', pattern='organisation/list/[key]', to='organisation##list')
	.get(name='personFilter', pattern='person/list/[key]', to='person##list')
	.get(name='wgetDownload', pattern='html3/[slug1]/[slug2]/[filename]', to='file##download', key='filename')

	// Named GET index routes
	.get(name='code', to='code##index')
	.get(name='commercial', to='commercial##index')
	.get(name='contact', to='contact##index')
	.get(name='defacto2', to='defacto2##index')
	.get(name='help', to='help##index')
	.get(name='html3', to='html3##index')
	.get(name='upload', to='upload##file')

	// Named GET list routes
	.get(name='fileList', pattern='file/list', to='file##list')
 	.get(name='linkList', pattern='link/list', to='link##list')
 	.get(name='personList', pattern='person/list', to='person##list')

	// Named POST routes
	.post(name='editUser', pattern='operator/edit/[key]', to='operator##edit')
	.post(name='linkOperator', pattern='link/operator/[function]/[key]/[uuid]', to='link##operator')
	.post(name='personList', pattern='person/list', to='person##list')

	.post(name='personForm', pattern='admin/person/[key]', to="admin##person", key="key")
	.post(name='groupForm', pattern='admin/organisation/[key]', to="admin##organisation", key="key")
	.post(name='initalismForm', pattern='admin/initialism/[key]', to="admin##initialism", key="key")

	// Alias GET routes
	.get(name='c', to='contact##index')
	.get(name='f', pattern='f/[key]', to='file##detail', key='key')
	.get(name='g', pattern='g/[orgname]', to='organisation##fileList', key='orgname')
	.get(name='p', pattern='p/[personname]', to='person##fileList', key='personname')
	.get(name='s', pattern='search/result', to='search##result')
	// Alias for GET download routes
	.get(name='d', pattern='d/[key]', to='file##download', key='key')
	.get(name='chiptune', pattern='d/[key].chiptune', to='file##download', key='key')

	// Alias POST routes
	.post(name='d', pattern='d/[key]', to='file##download', key='key')
	.post(name='f', pattern='f/[key]', to='file##detail', key='key')

	.get(name='fileDetailLegacy', pattern='file/detail/[key]', to='file##detail', key='key')

	// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
	.get(name='home', to='home##index')
	.root(to="home##index")
.end();
</cfscript>