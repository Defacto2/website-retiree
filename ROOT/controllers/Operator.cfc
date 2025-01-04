<!---
	Operator controller file.
	path: controllers/Operator.cfc
	status: complete

@CFLintIgnore
--->
component
	extends="Controller"
	output=false
{
	function config() {
		filters(through="_checkLoginAccess", only="signin");
		filters(through="checkControllerState", except="signin,signinconnection,signout,sha512");
		filters(through="coopGiveAccess", except="signin,signinconnection,signout,sha512,edit,save"); // require either coop & sysop to Operator except
		filters(through="sysopGiveAccess", only="index"); // require sysop access
		filters(through="render404",only="_checkLoginAccess");
		// Never display the sha512 controller on the production site as it is a security risk
		if(CGI.local_host == application.productionHost) filters(through="render404",only="sha512");
	}

	variables.title = "Operator"
	variables.breadcrumbs &= appendCrumb(2, 'operator', urlFor(controller='operator',action='index'))
	variables.robotsNoIndex = true

	/*
	 * Check to see if the sign in service is turned on.
	 */
	private any function _checkLoginAccess() {
		param name="params";
		if(!get(siteAreas).operatorLogin) {
			title = "Operator Sign-in Disabled"
			renderView(controller="system",action="siteareadisabled")
		}
	}

	function add() {
		var allusers = model("operator").findAll(returnAs="query",selected="uuid")
		title = "Add User Account"
		breadcrumbs &= appendCrumb(3, 'add', urlFor(controller='operator',action='add'))
		variables.superUser = model("operator").new()
		superUser.deletedat = ""
		superUser.username = ""
		superUser.displayname = ""
		superUser.affiliation = ""
		superUser.email = ""
		superUser.password = ""
		params.row = allusers.recordCount + 1
		renderView(action="form");
	}

	function edit() {
		param name="params";
		param name="params.row" default="";
		if(!opCheck('sysop')) {
			// coops can only edit their own profile
			if(!structKeyExists(session,"op") or session.op.uuid neq params.key) return render404();
		}
		title = "Edit User Account";
		breadcrumbs &= appendCrumb(3, 'edit', urlFor(controller='operator',action='edit'))
		variables.superUser = model("operator").findOneByUUID(value=params.key,includeSoftDeletes=true);
		superUser.password = "" // empty the pass
		if(Len(superUser.username)) breadcrumbs &= '#superUser.username#'
		renderView(action="form");
	}

	function index() {
		title = "List User Accounts"
		breadcrumbs &= "list"
	}

	function signin() {
		// automatic sign-in
		if(get(siteAreas).operatorBypass) {
			// also make sure that the server is localhost (Docker)
			if(application.domain == application.testServer) {
				var operator = model("user").findOne(where="username='admin'")
				session.op.uuid = operator.uuid
				if(Len(operator.displayname)) session.op.name = operator.displayname;
				else session.op.name = operator.username;
				session.op.coop = operator.coop
				session.op.sysop = operator.sysop
				operator = queryNew("") // empty the operator
				cookie name="persistsession" preserveCase="true" value="true" httponly="true" secure="true" expires="#DateAdd('n', 31, Now())#";
			}
		}
		// manual sign-in
		title = "Sign-in"
		breadcrumbs &= appendCrumb(3, 'sign-in', urlFor(controller='operator',action='signin'))
	}

	function signout() {
		if(opCheck('coop')) StructDelete(session,'op');
		redirectTo(controller="operator",action="signin");
	}

	function save() {
		param name="params";
		param name="params.passwordmodified" default="";
		if(!opCheck('sysop')) {
			// coops can only edit their own profile
			if(!structKeyExists(session,"op")) return render404();
			if(session.op.uuid != params.superUser.uuid) return render404();
		}
		title = "Save User Account"
		breadcrumbs &= appendCrumb(3, 'save', urlFor(controller='operator',action='save'))
		// user model from form fields via params
		params.passwordmodified = Trim(params.passwordmodified);
		if(opCheck('sysop') && params.previousaction == "add") {
			variables.superUser = model("operator").new(params.superUser);
		}
		if(params.previousaction == "edit") {
			// fetch record
			variables.superUser = model("operator").findOneByUUID(value=params.superUser.uuid,includeSoftDeletes=true)
			if(Len(params.passwordmodified)) superUser.password = params.passwordmodified;
			params.passwordmodified = ""
			// as a precaution we always hard code the roles to false
			params.superUser.sysop = false
			params.superUser.coop = false
			if(opCheck('sysop')) {
				switch(params.role) {
					case "sysop":
						params.superUser.sysop = true
						superUser.deletedat = "";
					break;
					case "coop":
						params.superUser.coop = true
						superUser.deletedat = "";
					break;
					default:
						// no roll, so we disable login access
						superUser.deletedat = Now();
					break;
				}
			}
			else if(opCheck('coop')) {
				// coop editing self account
				params.superUser.coop = true
				superUser.deletedat = "";
			}
			// apply form params changes to record
			superUser.update(params.superUser);
		}
		// persist new user
		if(superUser.save()) {
			superUser.password = "" // empty the pass
			if(opCheck('sysop')) {
				Evaluate('flashInsert(success="Successfully saved user")');
				redirectTo(action="index");
			}
			// coop editing their own account
			Evaluate('flashInsert(success="Saved your changes")');
			redirectTo(route="editUser",key=params.superUser.uuid);
		}
		superUser = queryNew("") // empty the user
		renderView(action="form");
	}

	function signinconnection() {
		param name="params";
		param name="params.operator.username" default="";
		if(!Len(params.operator.username)) return render404();
		// Make sure this is set to false on a production environment
		var user = model("user").findOne(where="username='#params.operator.username#'")
		if(IsBoolean(user) && !user) {
			// username does not exist
			flashInsert(error="The user does not match");
			redirectTo(controller="operator",action="signin");
		}
		var hash = pwsha512(user.uuid,params.operator.password)
		var user = model("user").findOne(where="username='#params.operator.username#' AND password='#hash#'");
		hash = "" // empty the pass
		if(IsObject(user)) {
			user.password = "" // empty the pass
			if(!user.coop && !user.sysop) {
				flashInsert(error="This account is off")
				redirectTo(controller="operator",action="signin")
			}
			session.op.uuid = user.uuid
			if(Len(user.displayname)) session.op.name = user.displayname;
			else session.op.name = user.username;
			session.op.coop = user.coop
			session.op.sysop = user.sysop
			user = queryNew("") // empty the user
			cookie name="persistsession" preserveCase="true" value="true" httponly="true" secure="true" expires="#DateAdd('n', 31, Now())#";
			redirectTo(controller="system", action="softwaredashboard");
		}
		flashInsert(error="The information does not match")
		redirectTo(controller="operator",action="signin")
	}
}