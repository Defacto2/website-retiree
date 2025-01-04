<!---
	Publications controller file.
	path: controllers/Commercial.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="checkControllerState")
	}

	breadcrumbs &= appendCrumb(2, 'publications', URLFor(route='commercial'))
	title = "error"
	description = "error"

	function bbsTheDocumentary() {
		title = "BBS: The Documentary"
		description = title & " DVD series"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='bbsTheDocumentary'))
	}
	function commodork() {
		title = "Commodork: Sordid Tales from a BBS Junkie"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='commodork'))
	}
	function darkDomain() {
		title = "Dark Domain"
		description = title & ": The Artpacks.acid.org Collection DVD-ROM"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='darkDomain'))
	}
	function demoArtScene() {
		title = "Demoscene: The Art of Real-Time"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='demoArtScene'))
	}
	function digitalcultureindustry() {
		title = "Digital Culture Industry"
		description = title & ": A History of Digital Distribution book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='digitalcultureindustry'))
	}
	function digitialMemories1() {
		title = "Digital Memories: The Best of Commodore 64"
		description = title & " DVD-ROM"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='digitialMemories1'))
	}
	function freaxVol1() {
		title = "Freax: Volume 1"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='freaxVol1'))
	}
	function freaxArtAlbum() {
		title = "Freax: The Art Album"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='freaxArtAlbum'))
	}
	function index() {
		title = "Publications"
		description = "Books, Blu-rays and DVDs series that cover the Scene"
	}
	function mindCandyVol1() {
		title = "MindCandy Volume 1: PC Demos"
		description = title & " DVD documentary"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='mindCandyVol1'))
	}
	function mindCandyVol2() {
		title = "MindCandy Volume 2: Amiga Demos"
		description = title & " DVD documentary"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='mindCandyVol2'))
	}
	function mindCandyVol3() {
		title = "MindCandy Volume 3: PC Demos 2003-09"
		description = title & " DVD documentary"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='mindCandyVol3'))
	}
	function sceenMagazine() {
		title = "Sceen: Magazine"
		description = title & " zine"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='sceenMagazine'))
	}
	function softwarePiracyExposed() {
		title = "Software Piracy Exposed"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='softwarePiracyExposed'))
	}
	function stealThisComputerBook() {
		title = "Steal This Computer Book"
		description = title & " 4.0 book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='stealThisComputerBook'))
	}
	function theModemWorld() {
		title = "The Modem World: A Prehistory of Social Media"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='theModemWorld'))
	}
	function warez() {
		title = "Warez: The Infrastructure and Aesthetics of Piracy"
		description = title & " book"
		breadcrumbs &= appendCrumb(3, LCase(title), URLFor(action='warez'))
	}
}