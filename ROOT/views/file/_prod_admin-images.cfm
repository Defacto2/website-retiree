<!---
	Admin upload or replace images, partial view.
	path: views/files/_prod_admin-images.cfm

@CFLintIgnore
--->
<cfif !opCheck('coop')><cfreturn></cfif>
<cfoutput><!--- Images and thumbnail selection --->
#startFormTag(controller="File",action="images",multipart="true",id="form5",params=queryString)#
    <input type="hidden" id="formOnFile-file_zip_content" name="formOnFile[file_zip_content]" class="form-control" value="#formOnFile.file_zip_content#">
    <div class="panel panel-success compact-metadata #highlightWarning(trigger=toggle.previewExists,bg=true)#">
        <div class="panel-heading">
        <cfif image.x400.size eq 0>
            <strong>Create a screenshot &amp; thumbnail</strong>
        <cfelse>
            <strong>Override the screenshot &amp; thumbnail</strong>
        </cfif>
        </div>
        #hiddenFieldTag(name="uuid",value="#fileProd.uuid#")#
        <ul class="list-group">
            <li class="list-group-item">
                <div class="row">
                    <div class="col-lg-6">
                        <button type="reset" class="btn btn-danger text-uppercase">Reset</button>
                    </div>
                    <div class="col-lg-6">
                        <button type="submit" id="saveImages" class="btn btn-block btn-primary text-uppercase" title="Save updates to images and thumbnail">Save</button>
                    </div>
                </div>
            </li>
            <li class="list-group-item">
                <div class="row">
                    <cfif admin.screenshots == 'menu-a'>
                        <div class="form-group col-lg-12">
                            <label for="formOnFile[srcoverwrite]">change the screenshot format</label>
                            <div class="input-group col-lg-12">
                                <input type="text" name="formOnFile[srcoverwrite]" id="formOnFile-srcoverwrite" value="" maxlength="100" class="form-control" placeholder="Ie GIF87 instead of GIF">
                                <input type="hidden" id="formOnFile-preview_image" name="formOnFile[preview_image]" class="form-control" value="#formOnFile.preview_image#">
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <small class="help-block">
                                Occasionally GraphicsMagick incorrectly assigns the wrong format type. To fix this supply an alternative <a href="http://www.graphicsmagick.org/formats.html">supported format</a>.
                            </small>
                        </div>
                    <cfelseif admin.screenshots == 'menu-b'>
                        <div class="form-group col-lg-12">
                            <label for="formOnFile[preview_image]" class="text-success">screenshot filename or URL</label>
                            <div class="input-group" title="screenshot or preview image" data-toggle="tooltip" data-placement="top">
                                <span class="input-group-addon"><i class="fal fa-camera fa-fw fa-lg"></i></span>
                                <input type="text" id="formOnFile-preview_image" maxlength="100" name="formOnFile[preview_image]" class="form-control" value="#formOnFile.preview_image#" placeholder="Images #listChangeDelims(get('myapp').acceptedGraphics, ', ')#">
                                <span class="input-group-btn">
                                    <button type="button" id="commentUrlBtn" class="btn btn-default" data-toggle="tooltip" data-placement="right" title="Fetch a screenshot from the image link in the 'additional notes'" disabled><i class="fal fa-external-link fa-fw fa-lg"></i></button>
                                </span>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <small class="help-block">
                                <cfif !len(formOnFile.filename) or listFindNoCase("text,pcb",formOnFile.platform) and !isArchive(formOnFile.filename)>
                                    Save a <strong>URL</strong> of an online image.
                                <cfelse>
                                    Select and save a filename from the archive or use a <strong>URL</strong> of an image online.
                                </cfif>
                            </small>
                        </div>
                    </cfif>
                    <div class="form-group col-lg-12 no-overflow">
                        <cfif !Len(admin.screenshots)>
                            <label for="filePreviewUpload" class="text-success">upload a screenshot</label>
                        <cfelse>
                            <label for="filePreviewUpload" class="text-success">or upload a screenshot</label>
                        </cfif>
                        <input name="filePreviewUpload" id="filePreviewUpload" type="file" accept="image/*" class="btn btn-block btn-default">
                    </div>
                </div>
            </li>
            <li class="list-group-item">
            <div class="row">
                <cfif image.x400.size eq 0>
                    <div class="col-lg-6 brand-danger"><i class="fal fa-times fa-fw fa-lg"></i><strong>No thumbnail!</strong></div>
                    <div class="col-lg-6">
                        <button class="btn btn-block btn-#image.generate.colour#" type="button" id="refreshThumbsAlt" data-toggle="tooltip" data-placement="bottom" title="Refresh thumbnails, screenshots and information images" #image.generate.status#><i class="fal fa-redo fa-lg"></i> &nbsp; CREATE &nbsp; <kbd class="pull-right text-uppercase">Ctrl+Alt+Z</kbd></button>
                    </div>
                <cfelse>
                    <div class="col-lg-6 col-md-12 file-detail-screenshot">
                        <img src="#admin.400Link##image.x400.disableCache#" alt="#image.x400.text#" class="capture-400x" title="400 x 400 pixel thumbnail preview">
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <p>
                            <a href="#admin.400Link##image.x400.disableCache#" title="Goto the 400x400px thumbnail">View the thumb</a>
                            <div class="font-mono gray"><span class="gray-light">File size</span> #humanizeFileSize(Val(image.x400.size))#</div>
                        </p>
                        <br>
                        <button class="btn btn-block btn-default" type="button" id="refreshThumbsAlt" title="Redo the thumbnail" data-toggle="tooltip" data-placement="right" data-clipboard-target="##rouuid"><i class="fal fa-square fa-fw"></i> REDO without zoom+crop<br><kbd class="pull-right text-uppercase">Ctrl+Alt+Z</kbd></button>
                        <br>
                        <button class="btn btn-block btn-warning" type="button" id="deleteThumbAlt" title="Delete screenshot and thumbnail" data-toggle="tooltip" data-placement="right" data-clipboard-target="##rouuid"><i class="fal fa-times fa-fw"></i> DELETE thumb+preview</button>
                    </div>
                </cfif>
            </div>
            </li>
        </ul>
    </div>
#endFormTag()#
</cfoutput>