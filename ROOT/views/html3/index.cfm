<!---
	HTML 3 index view.
	path: views/html3/index.cfm

@CFLintIgnore ---><cfoutput>
<img src="#gif.blank#" alt="Icon"> Name                                      Count  Description<hr><img src="#gif.back#" alt="[DIR]"> <a href="#UrlFor(route='fileList')#">Parent Directory</a>#RepeatString(" ",29)#-   Return to the contemporary HTML5 version of the site
<img src="#gif.dir#" alt="[DIR]"> <a href="#UrlFor(controller='html3', action='art')##link.suffex#">#Capitalize(get("myapp").menu.files.image.name)#</a>#RepeatString(" ",8+Len(get("myapp").menu.files.image.name)-Len(count.art))##count.art#   #get("myapp").menu.files.image.description#
<img src="#gif.dir#" alt="[DIR]"> <a href="#UrlFor(controller='html3', action='documents')##link.suffex#">#Capitalize(get("myapp").menu.files.text.name)#</a>#RepeatString(" ",8+Len(get("myapp").menu.files.text.name)-Len(count.document))##count.document#   #get("myapp").menu.files.text.description#
<img src="#gif.dir#" alt="[DIR]"> <a href="#UrlFor(controller='html3', action='software')##link.suffex#">#Capitalize(get("myapp").menu.files.software.name)#</a>#RepeatString(" ",30+Len(get("myapp").menu.files.software.name)-Len(count.document))##count.software#   #get("myapp").menu.files.software.description#
<img src="#gif.dir#" alt="[DIR]"> <a href="#UrlFor(controller='html3', action='groups')##link.suffex#">by Group</a>#RepeatString(" ",37)#-   List files categorised by group or organisation.
<img src="#gif.dir#" alt="[DIR]"> <a href="#UrlFor(controller='html3', action='platforms')##link.suffex#">by Media platform</a>#RepeatString(" ",28)#-   List files categorised by operating system.
<img src="#gif.dir#" alt="[DIR]"> <a href="#UrlFor(controller='html3', action='categories')##link.suffex#">by Category</a>#RepeatString(" ",34)#-   List files categorised by genre.</cfoutput>