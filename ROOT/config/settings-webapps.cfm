<!---
	Web site settings
	path: config/settings-webapps.cfm

@CFLintIgnore
--->
<cfscript>
	var webapps = {
		"discord":{
			"account":"defacto2##2067",
		},
		"facebook":{
			"account":"Defacto2",
		},
		"github":{
			"account":"defacto2",
			"repos":"https://github.com/defacto2?tab=repositories",
		},
		"google":{
			// used by the upload form to ping the YouTube API
			"apiKey":"",
		},
		"mastodon":{
			"account":"@defacto2@mas.to",
			"profile":"https://mas.to/@defacto2",
		},
		"other":{
			// only include links that are accessed by both views and controllers
			"16colors":"https://16colo.rs/",
			"demozoo":"https://demozoo.org/productions/",
			"pouet":"https://www.pouet.net/prod.php?which=",
		},
		"twitter":{
			// unique ID used by the Twitter embedded timelines widget
			"account":"Defacto2",
		},
		"youtube":{
			"account":"defacto2",
			"watch":"https://www.youtube.com/watch?v=",
			// used to query the API for the validity of a video ID
			"lookup":"",
		},
		"wordpress":{
			"account":"defacto2",
		}
	}
	var youtubeV3 = function(required struct webapps) {
		var key = arguments?.webapps?.google?.apiKey ?: "";
		if(key == "") return ""
		// YouTube API v3
		return "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#arguments.webapps.google.apiKey#&q="
	}
	webapps.youtube.lookup = youtubeV3(webapps)
	loc.myapp.append(webapps)
</cfscript>