<!---
	Admin overlay, file partial view.
	path: views/files/_prod_admin.cfm

@CFLintIgnore
--->
<cfscript>
	param name="filecontentcount" default=0;
	var checked = "checked"
	var credits = function() {
		if(!ListLen(fileProd.credit_text) && !ListLen(fileProd.credit_program)
			&& !ListLen(fileProd.credit_illustration) && !ListLen(fileProd.credit_audio)) return;
		admin.show.credits = true
	}
	var readmeDiscovery = function() {
		if(formOnFile.retrotxt_no_readme != 1) {
			if(formOnFile.retrotxt_readme == "") admin.readme.discover = findTextfile(fileProd);
			return;
		}
		admin.readme.disable = checked
		admin.readme.style = ' style="text-decoration: line-through;"'
	}
	var dosee = function() {
		if(!formOnFile.platform == "dos") return;
		if(len(fileProd.dosee_run_program)) admin.dosee.programToRun = fileProd.dosee_run_program;
		else admin.dosee.programToRun = emulatorBinary(fileProd);
		if(IsBoolean(fileProd.dosee_no_aspect_ratio_fix) && fileProd.dosee_no_aspect_ratio_fix == 1) admin.dosee.ratio = checked;
		if(IsBoolean(fileProd.dosee_no_ems) && fileProd.dosee_no_ems == 1) admin.dosee.disable.ems = checked;
		if(IsBoolean(fileProd.dosee_no_xms) && fileProd.dosee_no_xms == 1) admin.dosee.disable.xms = checked;
		if(IsBoolean(fileProd.dosee_no_umb) && fileProd.dosee_no_umb == 1) admin.dosee.disable.umb = checked;
		if(IsBoolean(fileProd.dosee_incompatible) && fileProd.dosee_incompatible == 1) admin.dosee.disable.exe = checked;
		if(IsBoolean(fileProd.dosee_load_utilities) && fileProd.dosee_load_utilities == 1) admin.dosee.utilities = checked;
		switch(fileProd.dosee_hardware_graphic) {
			case "svga": admin.dosee.gfx.svga = checked; break;
			case "vga": admin.dosee.gfx.vga = checked; break;
			case "ega": admin.dosee.gfx.ega = checked; break;
			case "tandy": admin.dosee.gfx.tandy = checked; break;
			case "cga": admin.dosee.gfx.cga = checked; break;
			case "herc": admin.dosee.gfx.herc = checked; break;
			case "et3000": admin.dosee.gfx.et3000 = checked; break;
			case "et4000": admin.dosee.gfx.et4000 = checked; break;
			case "paradise": admin.dosee.gfx.paradise = checked; break;
			case "nolfb": admin.dosee.gfx.nolfb = checked; break;
			case "oldvbe": admin.dosee.gfx.oldvbe = checked; break;
			default: admin.dosee.gfx.auto = checked; break;
		}
		switch(fileProd.dosee_hardware_audio) {
			case "gus": admin.dosee.sfx.gus = checked; break;
			case "sb16": admin.dosee.sfx.sb16 = checked; break;
			case "sb1": admin.dosee.sfx.sb1 = checked; break;
			case "covox": admin.dosee.sfx.covox = checked; break;
			case "none": admin.dosee.sfx.none = checked; break;
			default: admin.dosee.sfx.default = checked; break;
		}
		switch(fileProd.dosee_hardware_cpu) {
			case "486": admin.dosee.cpu.486 = checked; break;
			case "386": admin.dosee.cpu.386 = checked; break;
			case "8086": admin.dosee.cpu.8086 = checked; break;
			case "auto": admin.dosee.cpu.auto = checked; break;
			default: admin.dosee.cpu.auto = checked; break;
		}
	}
	var screenshots = function() {
		if(IsGraphic(formOnFile.filename)) return 'menu-a';
		if(formOnFile.platform == 'image') return 'menu-a';
		if(!ListFindNoCase("text,pcb",formOnFile.platform)) return 'menu-b';
		if(IsArchive(formOnFile.filename)) return 'menu-b';
		return ""
	}
	var title = function() {
		if(formOnFile.section != 'magazine') return;
		admin.title.inputPlaceholder = 'Magazine issue or volume number'
		admin.title.inputTitle = "issue or volume"
		admin.title.icon = 'newspaper'
	}
	var upload = function() {
		if(fileProd.fileSize != "") return;
		if(Val(fileProd.fileSize)) return;
		admin.replace.button = "Upload"
		admin.replace.noun = "submission"
		admin.replace.text = "Add a file for download"
	}

	variables.admin = {
		"400Link":"/images/#get('myapp').dirThumb400#/#fileProd.uuid#.png",
		"dosee": {
			"programToRun":"",
			"disable": {
				"ems":"",
				"exe":"",
				"umb":"",
				"xms":"",
			},
			"ratio":"",
			"utilities":"",
			"gfx": {
				"auto":"",
				"svga":"",
				"vga":"",
				"ega":"",
				"tandy":"",
				"cga":"",
				"herc":"",
				"et3000":"",
				"et4000":"",
				"paradise":"",
				"nolfb":"",
				"oldvbe":"",
			},
			"sfx": {
				"gus":"",
				"sb16":"",
				"sb1":"",
				"covox":"",
				"none":"",
				"default":"",
			},
			"cpu": {
				"486":"",
				"386":"",
				"8086":"",
				"auto":"",
			}
		},
		"readme": {
			"disable":"",
			"discover":"",
			"style":"",
		},
		"replace": {
			"button":"Replace",
			"noun":"replacement",
			"text":"Replace the file download",
		},
		"screenshots": screenshots(),
		"title": {
			"inputPlaceholder":"Title",
			"inputTitle":"title",
			"icon":"folder-open",
		},
	}

	upload()
	credits()
	readmeDiscovery()
	if(flashKeyExists('extractDOSTextError')) {
		feedback.error = false
	}
	dosee()
</cfscript>