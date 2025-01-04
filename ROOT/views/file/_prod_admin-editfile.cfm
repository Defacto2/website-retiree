<!---
	Admin edit file form partial view.
    path: views/files/_prod_admin-editfile.cfm

    Gets submitted to `save()` in controllers/File.cfc

@CFLintIgnore
--->
<cfoutput>
    <div class="panel panel-primary compact-metadata #formDanger([feedback.require.platform,feedback.require.section,feedback.require.filename,feedback.require.for])#">
        <ul class="list-group">
            <li class="list-group-item">
            #hiddenFieldTag(name="uuid",value="#fileProd.uuid#")#
            <div class="row">
                <!--- input-group  --->
                <div class="form-group col-lg-6" title="Reset data changes">
                    <button type="reset" id="form1_reset" class="btn btn-block btn-danger pull-right text-uppercase">Reset <kbd class="pull-right">Ctrl+Alt+X</kbd></button><br>
                </div>
                <div class="form-group col-lg-6" title="Save data changes">
                    <button type="submit" id="saveEditsTop" class="btn btn-block btn-primary text-uppercase">Save <kbd class="pull-right">Ctrl+Alt+S</kbd></button>
                </div>
                <div class="form-group col-md-12 col-lg-4" title="autokey" data-toggle="tooltip" data-placement="bottom">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fal fa-database fa-fw"></i></span>
                        <input id="autokey" type="text" value="#fileProd.id#" readonly="readonly" class="form-control">
                    </div>
                </div>
                <div class="form-group has-info col-md-12 col-lg-8" title="universally unique identifier" data-toggle="tooltip" data-placement="top">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fal fa-database fa-fw"></i></span>
                        <input id="rouuid" type="text" value="#fileProd.uuid#" readonly="readonly" class="form-control">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button" title="Copy uuid" data-toggle="tooltip" data-placement="right" data-clipboard-target="##rouuid"><i class="fal fa-copy fa-fw"></i></button>
                        </span>
                    </div>
                </div>
                <div class="form-group col-lg-12 #highlightWarning(feedback.recommend.title)#">
                    <div class="input-group" title="#admin.title.inputTitle#" data-toggle="tooltip" data-placement="top">
                        <span class="input-group-addon"><i class="fal fa-#admin.title.icon# fa-fw"></i></span>
                        <input type="text" name="formOnFile.record_title" id="formOnFile[record_title]" value="#formOnFile.record_title#" maxlength="100" class="form-control" placeholder="#admin.title.inputPlaceholder#">
                        <span class="input-group-btn">
                            <button type="button" id="autofmt-ed" class="btn btn-default" title="Auto-format the title" data-toggle="tooltip" data-placement="right"><i class="fal fa-edit fa-fw"></i></button>
                        </span>
                    </div>
                </div>
                <div class="form-group col-lg-12 #highlightDanger(feedback.require.filename)#">
                    <div class="input-group" title="filename" data-toggle="tooltip" data-placement="top">
                        <span class="input-group-addon"><i class="fal fa-file-alt fa-fw"></i></span>
                        <input type="text" name="formOnFile.filename" id="formOnFile[filename]" value="#formOnFile.filename#" maxlength="100" class="form-control" placeholder="filename.ext">
                        <span class="input-group-btn">
                            <button type="button" id="autofmt-fn" class="btn btn-default" title="Auto-format the filename" data-toggle="tooltip" data-placement="right"><i class="fal fa-edit fa-fw"></i></button>
                        </span>
                    </div>
                </div>
                <div class="form-group col-lg-12 #highlightDanger(feedback.require.for)#" title="published for" data-toggle="tooltip" data-placement="top">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fal fa-users fa-fw"></i></span>
                        <input type="text" name="formOnFile.group_brand_for" id="formOnFile[group_brand_for]" list="file-group_brand_for-list" maxlength="100" value="#formOnFile.group_brand_for#" class="form-control" placeholder="Primary group or site name">
                        <span class="input-group-btn">
                            <button type="button" id="swapGroups" class="btn btn-default" title="Swap groups" data-toggle="tooltip" data-placement="bottom"><i class="fal fa-redo fa-fw"></i></button>
                            <button type="button" id="autofmt-pf" class="btn btn-default" title="Auto-format the group" data-toggle="tooltip" data-placement="right"><i class="fal fa-edit fa-fw"></i></button>
                        </span>
                    </div>
                    <!--- HTML5 auto-complete data --->
                    <datalist id="file-group_brand_for-list">
                        <cfloop query="groupsDatalist"><option value="#pubCombined#" label="#pubCombined#"></cfloop>
                    </datalist>
                </div>
                <div class="form-group col-lg-12" title="published by" data-toggle="tooltip" data-placement="top">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fal fa-users fa-fw"></i></span>
                        <input type="text" name="formOnFile.group_brand_by" id="formOnFile[group_brand_by]" list="file-group_brand_by-list" maxlength="100" value="#formOnFile.group_brand_by#" class="form-control" placeholder="Optional additional group name">
                        <span class="input-group-btn">
                            <button type="button" id="autofmt-pb" class="btn btn-default" title="Auto-format the group" data-toggle="tooltip" data-placement="right"><i class="fal fa-edit fa-fw"></i></button>
                        </span>
                    </div>
                    <!--- HTML5 auto-complete data --->
                    <datalist id="file-group_brand_by-list">
                        <cfloop query="groupsDatalist"><option value="#pubCombined#" label="#pubCombined#"></cfloop>
                    </datalist>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-lg-12 form-published-date">
                    <label for="pubYear-year" class="text-info">published</label>
                </div>
                <div class="form-group col-lg-4 col-md-2 col-sm-2" title="Published year">
                    <input type="number" class="form-control" id="date_issued_year" name="date_issued_year" value="#fileProd.date_issued_year#" min="#get('myapp').yearStart#" max="#DateFormat(Now(),'YYYY')#" placeholder="Year" aria-label="Published year">
                </div>
                <div class="form-group col-lg-4 col-md-2 col-sm-2" title="Published month">
                    <input type="number" class="form-control" id="date_issued_month" name="date_issued_month" value="#fileProd.date_issued_month#" min="1" max="12" placeholder="Month" aria-label="Published month">
                </div>
                <div class="form-group col-lg-4 col-md-2 col-sm-2" title="Published day">
                    <input type="number" class="form-control" id="date_issued_day" name="date_issued_day" value="#fileProd.date_issued_day#" min="1" max="31" placeholder="Day" aria-label="Published day">
                </div>
                <div class="form-group col-lg-12" id="date-buttons">
                    <small title="Set published date to match the file's last modified date"><a id="btn-last-mod" class="no-href">Set as last modification</a></small>
                    <small title="Blank published dates"><a id="blank-date-button" class="no-href">Reset to blank</a></small>
                </div>
            </div>
            <div class="row">
                <cfset tempCnt = 1>
                <!--- Tag platforms --->
                <div class="col-lg-12 #highlightDanger(feedback.require.platform)#">
                    <div class="nowrap" title="Tag a platform"><label for="formOnFile-platform">tag a platform or the program operating system</label> <kbd class="pull-right text-uppercase">Ctrl+Alt+[</kbd></div>
                    <select id="fofPlatformJS"></select>
                    <div class="hidden">
                    <!--- the Choice.JS frontend interfaces with this standard HTML form --->
                    <!--- blank option --->
                    <label for="platformChoice1" class="radio-inline hidden">
                    <input type="radio" id="platformChoice1" name="formOnFile[platform]" class="hidden" value="" checked>Leave blank</label>
                    <cfloop array="#getPlatformPairs()#" index="local.pair">
                        <cfset tempChecked = "">
                        <cfif pair[1] eq formOnFile.platform><cfset tempChecked = " checked"></cfif>
                        <cfset tempCnt++>
                        <span class="nowrap hidden">
                            <label for="platformChoice#tempCnt#" class="radio-inline" title="#getPlatformDescription(pair[1])#">
                            <input type="radio" id="platformChoice#tempCnt#" name="formOnFile[platform]" value="#pair[1]#"#tempChecked#>#pair[2]#</label>
                        </span>
                    </cfloop>
                    </div>
                </div>
                <!--- Tag sections --->
                <cfset tempCnt = 1>
                <div class="col-lg-12 #highlightDanger(feedback.require.section)#">
                    <div class="nowrap" title="Tag a label, section or category"><label for="formOnFile-section">tag a label</label> <kbd class="pull-right text-uppercase">Ctrl+Alt+]</kbd></div>
                    <select id="fofLabelJS"></select>
                    <div class="hidden">
                    <!--- the Choice.JS frontend interfaces with this standard HTML form --->
                    <!--- blank option --->
                    <label for="sectionChoice1" class="radio-inline">
                    <input type="radio" id="sectionChoice1" name="formOnFile[section]" value="" checked>Leave blank</label>
                    <cfloop array="#getSectionPairs()#" index="local.pair">
                        <cfset tempChecked = "">
                        <cfif pair[1] eq formOnFile.section><cfset tempChecked = " checked"></cfif>
                        <cfset tempCnt++>
                        <span class="nowrap">
                            <label for="sectionChoice#tempCnt#" class="radio-inline" title="#getSectionDescription(pair[1])#">
                            <input type="radio" id="sectionChoice#tempCnt#" name="formOnFile[section]" value="#pair[1]#"#tempChecked#>#pair[2]#</label>
                        </span>
                    </cfloop>
                    </div>
                </div>
            </div>
            </li>
            <li class="list-group-item">
                <label for="formOnFile[credit_text]" class="text-muted">credits</label>
                <div class="row">
                    <div class="form-group col-md-12 col-lg-6">
                        <div class="input-group" title="writers" data-toggle="tooltip" data-placement="top">
                        <span class="input-group-addon">#svg(icon='person-writers')#</span>
                        <input type="text" name="formOnFile.credit_text" id="formOnFile[credit_text]" value="#formOnFile.credit_text#" maxlength="100" class="form-control" placeholder="Writer 1, Writer 2">
                        </div>
                    </div>
                    <div class="form-group col-md-12 col-lg-6">
                        <div class="input-group" title="programmers" data-toggle="tooltip" data-placement="top">
                        <span class="input-group-addon">#svg(icon='person-coders')#</span>
                        <input type="text" name="formOnFile.credit_program" id="formOnFile[credit_program]" value="#formOnFile.credit_program#" maxlength="100" class="form-control" placeholder="Programmer 1, Programmer 2">
                        </div>
                    </div>
                    <div class="form-group col-md-12 col-lg-6">
                        <div class="input-group" title="artists" data-toggle="tooltip" data-placement="top">
                        <span class="input-group-addon">#svg(icon='person-artists')#</span>
                        <input type="text" name="formOnFile.credit_illustration" id="formOnFile[credit_illustration]" value="#formOnFile.credit_illustration#" maxlength="100" class="form-control" placeholder="Artist 1, Artist 2">
                        </div>
                    </div>
                    <div class="form-group col-md-12 col-lg-6">
                        <div class="input-group" title="musicians" data-toggle="tooltip" data-placement="top">
                        <span class="input-group-addon">#svg(icon='person-musicians')#</span>
                        <input type="text" name="formOnFile.credit_audio" id="formOnFile[credit_audio]" value="#formOnFile.credit_audio#" maxlength="100" class="form-control" placeholder="Musician 1, Musician 2">
                        </div>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</cfoutput>