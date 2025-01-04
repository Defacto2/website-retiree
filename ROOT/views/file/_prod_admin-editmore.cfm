<!---
	Admin edit file form partial view.
    path: views/files/_prod_admin-editmore.cfm

    Gets submitted to `save()` in controllers/File.cfc

@CFLintIgnore
--->
<cfoutput>
    <div class="panel panel-primary compact-metadata">
        <ul class="list-group">
            <li class="list-group-item">
                <div class="row">
                    <div class="form-group form-group-sm col-lg-12">
                        <label for="formOnFile[comment]" class="text-info">additional notes</label>
                        <button type="button" id="btn-del-notes" class="btn btn-warning btn-sm pull-right" title="Delete the additional notes" data-toggle="tooltip" data-placement="right"><i class="fal fa-times fa-lg"></i> <span class="text-uppercase">Delete notes</span></button>
                    </div>
                    <div class="form-group form-group-sm col-lg-12 mt-6">
                        <textarea name="formOnFile.comment" id="formOnFile[comment]" class="form-control" rows="2">#formOnFile.comment#</textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-lg-6">
                        <div class="input-group" title="demozoo id (integer)" data-toggle="tooltip" data-placement="top">
                            <span class="input-group-addon"><img src="/images/layout/demozoo_16x16_logo.png" height="16" width="16" alt="Demozoo"></span>
                            <input type="text" name="formOnFile.web_id_demozoo" id="formOnFile[web_id_demozoo]" value="#formOnFile.web_id_demozoo#" maxlength="6" class="form-control" placeholder="/production/">
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <div class="input-group" title="pouët id (integer)" data-toggle="tooltip" data-placement="top">
                            <span class="input-group-addon"><img src="/images/layout/pouet_16x16_logo.png" height="16" width="16" alt="Pouet"></span>
                            <input type="text" name="formOnFile.web_id_pouet" id="formOnFile[web_id_pouet]" value="#formOnFile.web_id_pouet#" maxlength="6" class="form-control" placeholder="/prod.php?which=">
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <div class="input-group" title="github repository id (string)" data-toggle="tooltip" data-placement="top">
                            <span class="input-group-addon"><i class="fab fa-github fa-fw"></i></span>
                            <input type="text" name="formOnFile.web_id_github" id="formOnFile[web_id_github]" value="#formOnFile.web_id_github#" maxlength="1024" class="form-control" placeholder="/">
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <div class="input-group" title="URI for 16colo.rs (string)" data-toggle="tooltip" data-placement="top">
                            <span class="input-group-addon"><img src="/images/layout/16colors.ico" height="16" width="16" alt="16colo.rs"></span>
                            <input type="text" name="formOnFile.web_id_16colors" id="formOnFile[web_id_16colors]" value="#formOnFile.web_id_16colors#" maxlength="1024" class="form-control" placeholder="/pack/name/file.ans">
                        </div>
                    </div>
                </div>
                <div class="row hidden" id="thirdPartyIds">
                    <div class="form-group col-lg-6">
                        <div class="input-group input-group-sm" title="youtube id (string)" data-toggle="tooltip" data-placement="top">
                            <span class="input-group-addon"><i class="fab fa-youtube fa-fw fa-lg"></i></span>
                            <input type="text" name="formOnFile.web_id_youtube" id="formOnFile[web_id_youtube]" value="#formOnFile.web_id_youtube#" maxlength="11" class="form-control" placeholder="/watch?v=">
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <div class="input-group input-group-sm" title="virustotal report (url)" data-toggle="tooltip" data-placement="top">
                            <span class="input-group-addon"><i class="fal fa-exclamation-circle fa-fw fa-lg"></i></span>
                            <input type="url" name="formOnFile.file_security_alert_url" id="formOnFile[file_security_alert_url]" value="#formOnFile.file_security_alert_url#" maxlength="255" class="form-control" placeholder="http://www.virustotal.com/file-scan/report.html?id=0000">
                        </div>
                    </div>
                </div>
                <div id="thirdPartyAll" class=""><small><a class="no-href">Show all third party links</a></small></div>
                <div id="thirdPartyHide" class="hidden"><small><a class="no-href">Hide third party links</a></small></div>
                <div title="Link to other Defacto2 files ( string ; id | string ; id | ... )">
                    <label for="formOnFile[list_relations]" class="text-muted">other associated files</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-addon"><i class="fal fa-external-link fa-fw fa-lg"></i></span>
                        <input type="text" name="formOnFile.list_relations" id="formOnFile[list_relations]" value="#formOnFile.list_relations#" maxlength="255" class="form-control" placeholder="Alternate;a9275ec|Readme;x0128gf">
                    </div>
                </div>
                <div title="Link to other websites ( string ; url | string ; url | ... )">
                    <label for="formOnFile[list_links]" class="text-muted">websites</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-addon"><i class="fal fa-external-link fa-fw fa-lg"></i></span>
                        <input type="text" name="formOnFile.list_links" id="formOnFile[list_links]" value="#formOnFile.list_links#" maxlength="2048" class="form-control" placeholder="Example 1;http://www.example1.com|Example 2;http://www.example2.org">
                    </div>
                </div>
            </li>
            <!--- UPDATE 15/05/23, changed fileContentCount gte to 1 --->
            <cfif !ListFindNoCase("text,pcb",formOnFile.platform) and IsArchive(formOnFile.filename) and fileContentCount gte 1>
                <li class="list-group-item">
                    <div class="form-group form-group-sm">
                        <label for="formOnFile[retrotxt_readme]" class="text-muted">text formatted file to showcase</label>
                        <div class="input-group input-group-sm col-lg-12" title="Disable the display of this showcase text file">
                            <input type="text" name="formOnFile.retrotxt_readme" id="formOnFile[retrotxt_readme]" value="#formOnFile.retrotxt_readme#" maxlength="128" class="form-control #highlightDanger(!feedback.error)#" placeholder="#admin.readme.discover#" #admin.readme.style#>
                            <span class="input-group-addon">
                            <i class="fal fa-times fa-lg"></i> &nbsp; <input type="checkbox" class="fa-radio" name="formOnFile.retrotxt_no_readme" id="formOnFile[retrotxt_no_readme]" value="1" #admin.readme.disable#></span>
                        </div>
                        <cfif !feedback.error>
                            <div class="text-center"><strong><small class="#highlightDanger(false)#">File not found or cannot be extracted from the archive</small></strong></div>
                        </cfif>
                    </div>
                </li>
            </cfif>
            <cfif formOnFile.section is "package" and formOnFile.platform is "ansi">
                <li class="list-group-item">
                    <label class="text-muted">dosee configuration overrides</label>
                    <p><small>ANSI artpacks automatically load the DOSee prompt</small></p>
                </li>
            <cfelseif formOnFile.section is "package" and formOnFile.platform is "dos">
                <li class="list-group-item">
                    <label class="text-muted">dosee configuration overrides</label>
                    <p><small>MS-DOS software packs automatically load the DOSee prompt</small></p>
                </li>
            <cfelseif formOnFile.platform is "dos">
            <li class="list-group-item">
                <label class="text-muted">dosee configuration overrides (leave blank unless needed)</label>
                <div class="form-group col-lg-12">
                    <label for="formOnFile[dosee_incompatible]" class="text-danger checkbox-inline" title="Flag this program as incompatible with DOSBox" data-toggle="tooltip" data-placement="top">
                        <input type="checkbox" name="formOnFile.dosee_incompatible" id="formOnFile[dosee_incompatible]" value="1" #admin.dosee.disable.exe#>
                        <span class="font-lg">Mark this program as incompatible: <code>#admin.dosee.programToRun#</code></span></label>
                    <br>
                    <label for="formOnFile[dosee_load_utilities]" class="text-muted checkbox-inline" title="Load extra utilities and tools for DOS" data-toggle="tooltip" data-placement="top">
                        <input type="checkbox" name="formOnFile.dosee_load_utilities" id="formOnFile[dosee_load_utilities]" value="1" #admin.dosee.utilities#>
                        <span class="font-lg">Load the utilities drive <code>U:</code></span></label>
                    <label for="formOnFile[dosee_no_aspect_ratio_fix]" class="text-muted checkbox-inline" title="Dynamic resizing of the DOSee window for sharper command line text" data-toggle="tooltip" data-placement="top">
                        <input type="checkbox" name="formOnFile.dosee_no_aspect_ratio_fix" id="formOnFile[dosee_no_aspect_ratio_fix]" value="1" #admin.dosee.ratio#>
                        <span class="font-lg">No aspect ratio fix</span></label>
                </div>
                <div id="showDoseeHardware"><small><a class="dosee-link no-href">Configure hardware</a></small></div>
                <div id="hideDoseeHardware" class="hidden"><small><a class="dosee-link no-href">Hide hardware options</a></small></div>
                <div id="DoseeHardware" class="form-group col-lg-12 dosee-hardware hidden">
                    <div class="nowrap" title="CPU model to emulate"><label for="formOnFile[dosee_hardware_cpu]" data-toggle="tooltip" data-placement="top">Intel CPU</label></div>
                    <!--- blank option --->
                    <label for="cpuChoise1" class="radio-inline">
                    <input type="radio" id="cpuChoise1" name="formOnFile[dosee_hardware_cpu]" value=""#admin.dosee.cpu.auto#>Leave blank</label>
                    <label for="cpuChoise2" class="radio-inline" title="DOSBox automatic selection">
                    <input type="radio" id="cpuChoise2" name="formOnFile[dosee_hardware_cpu]" value="auto"#admin.dosee.cpu.auto#>automatic</label>
                    <label for="cpuChoise3" class="radio-inline" title="Intel 80486 (fast)">
                    <input type="radio" id="cpuChoise3" name="formOnFile[dosee_hardware_cpu]" value="486"#admin.dosee.cpu.486#>486</label>
                    <label for="cpuChoise4" class="radio-inline" title="Intel 80386 (medium)">
                    <input type="radio" id="cpuChoise4" name="formOnFile[dosee_hardware_cpu]" value="386"#admin.dosee.cpu.386#>386</label>
                    <label for="cpuChoise5" class="radio-inline" title="Intel 8086 (slow)">
                    <input type="radio" id="cpuChoise5" name="formOnFile[dosee_hardware_cpu]" value="8086"#admin.dosee.cpu.8086#>8086</label>
                </div>
                <div class="form-group col-lg-12 dosee-hardware hidden">
                    <div class="nowrap" title="Audio hardware"><label for="formOnFile[dosee_hardware_audio]" data-toggle="tooltip" data-placement="top">Sound card</label></div>
                    <!--- blank option --->
                    <label for="sfxChoise1" class="radio-inline">
                    <input type="radio" id="sfxChoise1" name="formOnFile[dosee_hardware_audio]" value=""#admin.dosee.sfx.default#>Leave blank</label>
                    <label for="sfxChoise3" class="radio-inline" title="Sound Blaster 16 (stereo, 16bit)">
                    <input type="radio" id="sfxChoise3" name="formOnFile[dosee_hardware_audio]" value="sb16"#admin.dosee.sfx.sb16#>Sound Blaster 16</label>
                    <label for="sfxChoise2" class="radio-inline" title="Gravis Ultrasound (Classic)">
                    <input type="radio" id="sfxChoise2" name="formOnFile[dosee_hardware_audio]" value="gus"#admin.dosee.sfx.gus#>Gravis Ultrasound</label>
                <br>
                    <label for="sfxChoise4" class="radio-inline" title="Sound Blaster 1.0 (mono, 8bit)">
                    <input type="radio" id="sfxChoise4" name="formOnFile[dosee_hardware_audio]" value="sb1"#admin.dosee.sfx.sb1#>Sound Blaster 8</label>
                    <label for="sfxChoise5" class="radio-inline" title="Covox/Disney Sound Source/DA Converter">
                    <input type="radio" id="sfxChoise5" name="formOnFile[dosee_hardware_audio]" value="covox"#admin.dosee.sfx.covox#>Covox</label>
                    <label for="sfxChoise7" class="radio-inline" title="Disable audio hardware emulation">
                    <input type="radio" id="sfxChoise7" name="formOnFile[dosee_hardware_audio]" value="none"#admin.dosee.sfx.none#>silence</label>
                </div>
                <div class="form-group col-lg-12 dosee-hardware hidden">
                    <div class="nowrap" title="Graphics hardware"><label for="formOnFile[dosee_hardware_graphic]" data-toggle="tooltip" data-placement="top">Graphic card</label></div>
                    <!--- blank option --->
                    <label for="gfxChoise1" class="radio-inline">
                    <input type="radio" id="gfxChoise1" name="formOnFile[dosee_hardware_graphic]" value=""#admin.dosee.gfx.auto#>Leave blank</label>
                    <label for="gfxChoise2" class="radio-inline">
                    <input type="radio" id="gfxChoise2" name="formOnFile[dosee_hardware_graphic]" value="svga"#admin.dosee.gfx.svga#>SuperVGA</label>
                    <label for="gfxChoise3" class="radio-inline">
                    <input type="radio" id="gfxChoise3" name="formOnFile[dosee_hardware_graphic]" value="vga"#admin.dosee.gfx.vga#>VGA</label>
                    <label for="gfxChoise4" class="radio-inline" title="SuperVGA with VESA 1.3">
                    <input type="radio" id="gfxChoise4" name="formOnFile[dosee_hardware_graphic]" value="oldvbe"#admin.dosee.gfx.oldvbe#>VESA 1.3</label>
                    <br>
                    <label for="gfxChoise9" class="radio-inline">
                    <input type="radio" id="gfxChoise9" name="formOnFile[dosee_hardware_graphic]" value="ega"#admin.dosee.gfx.ega#>EGA</label>
                    <label for="gfxChoise11" class="radio-inline">
                    <input type="radio" id="gfxChoise11" name="formOnFile[dosee_hardware_graphic]" value="cga"#admin.dosee.gfx.cga#>CGA</label>
                    <label for="gfxChoise10" class="radio-inline">
                    <input type="radio" id="gfxChoise10" name="formOnFile[dosee_hardware_graphic]" value="tandy"#admin.dosee.gfx.tandy#>Tandy</label>
                    <label for="gfxChoise12" class="radio-inline">
                    <input type="radio" id="gfxChoise12" name="formOnFile[dosee_hardware_graphic]" value="herc"#admin.dosee.gfx.herc#>Hercules</label>
                    <br>
                    <label for="gfxChoise5" class="radio-inline" title="Tseng Labs ET3000">
                    <input type="radio" id="gfxChoise5" name="formOnFile[dosee_hardware_graphic]" value="et3000"#admin.dosee.gfx.et3000#>ET3000</label>
                    <label for="gfxChoise6" class="radio-inline" title="Tseng Labs ET4000">
                    <input type="radio" id="gfxChoise6" name="formOnFile[dosee_hardware_graphic]" value="et4000"#admin.dosee.gfx.et4000#>ET4000</label>
                    <label for="gfxChoise7" class="radio-inline" title="Paradise PVGA1A">
                    <input type="radio" id="gfxChoise7" name="formOnFile[dosee_hardware_graphic]" value="paradise"#admin.dosee.gfx.paradise#>Paradise</label>
                    <label for="gfxChoise8" class="radio-inline" title="No-line frame buffer hack">
                    <input type="radio" id="gfxChoise8" name="formOnFile[dosee_hardware_graphic]" value="nolfb"#admin.dosee.gfx.nolfb#>No LFB</label>
                </div>
                <div class="form-group col-lg-12 dosee-hardware hidden">
                    <div class="nowrap" title="Extra RAM hardware and configurations"><label data-toggle="tooltip" data-placement="top">Disable system memory options</label></div>
                    <label for="formOnFile[dosee_no_ems]" class="text-muted checkbox-inline" title="Turn off Expanded Memory emulation" data-toggle="tooltip" data-placement="top">
                        <input type="checkbox" name="formOnFile.dosee_no_ems" id="formOnFile[dosee_no_ems]" value="1" #admin.dosee.disable.ems#>Expanded <em>EMS</em></label>
                    <label for="formOnFile[dosee_no_xms]" class="text-muted checkbox-inline" title="Turn off Extended Memory emulation" data-toggle="tooltip" data-placement="top">
                        <input type="checkbox" name="formOnFile.dosee_no_xms" id="formOnFile[dosee_no_xms]" value="1" #admin.dosee.disable.xms#>Extended <em>XMS</em></label>
                    <label for="formOnFile[dosee_no_umb]" class="text-muted checkbox-inline" title="Turn off Upper Memory Block emulation" data-toggle="tooltip" data-placement="top">
                        <input type="checkbox" name="formOnFile.dosee_no_umb" id="formOnFile[dosee_no_umb]" value="1" #admin.dosee.disable.umb#>Upper Memory Blocks <em>UMB</em></label>
                </div>
                <div class="row form-group form-group-sm">
                    <cfif isArchive(formOnFile.filename) and fileContentCount gte 2>
                        <div class="col-lg-12">
                            <label for="formOnFile[dosee_run_program]" class="text-muted">filename or commands to launch</label>
                            <div class="input-group input-group-sm">
                                <span class="input-group-addon"><i class="fal fa-file fa-fw fa-lg"></i></span>
                                <input type="text" name="formOnFile.dosee_run_program" id="formOnFile[dosee_run_program]" value="#formOnFile.dosee_run_program#" maxlength="255" class="form-control" placeholder="#admin.dosee.programToRun#">
                            </div>
                            <div class="text-center gray"><small>Chain multiple commands using <code>&&</code> separators</small></div>
                        </div>
                    </cfif>
                </div>
            </li>
            <!--- UPDATE 15/05/23, changed fileContentCount gte to 1 --->
            <cfelseif ListFindNoCase("text,pcb",formOnFile.platform) and IsArchive(formOnFile.filename) and fileContentCount gte 1>
                <li class="list-group-item">
                    <div class="row">
                        <div class="form-group form-group-sm col-lg-12">
                            <!--- conditions to add, platform is text, 2 or more files --->
                            <label for="formOnFile[retrotxt_readme]" class="text-muted">text formatted file within #formOnFile.filename# to showcase</label>
                            <input type="text" name="formOnFile.retrotxt_readme" id="formOnFile[retrotxt_readme]" value="#formOnFile.retrotxt_readme#" maxlength="128" class="form-control" placeholder="filename.nfo">
                        </div>
                    </div>
                </li>
            </cfif>
            <li class="list-group-item">
                <div class="row">
                    <div class="form-group col-lg-6">
                        <button type="reset" class="btn btn-block btn-danger text-uppercase">Reset <kbd class="pull-right">Ctrl+Alt+X</kbd></button>
                    </div>
                    <div class="form-group col-lg-6" title="Save data changes">
                        <button type="submit" id="saveEditsBtm" class="btn btn-block btn-primary text-uppercase">Save <kbd class="pull-right">Ctrl+Alt+S</kbd></button>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</cfoutput>