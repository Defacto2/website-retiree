<!---
  	Send your files "Published date" partial view.
	path: views/upload/_inputDate.cfm

@CFLintIgnore
--->
<cfoutput>
<div class="row">
	<div class="form-group col-lg-12 form-published-date">
		<label for="pubYear-year" class="text-muted">Published date - <small>Leave blank to use file's last modification date</small></label>
	</div>
	<div class="form-group col-lg-4 col-md-5 col-sm-6">
		#buttonTag(class="btn btn-default", id="today-date-button", content="Today", type="button")#
		#buttonTag(class="btn btn-default", id="blank-date-button", content="Blank", type="button", disabled="disabled")#
	</div>
	<div class="form-group col-lg-2 col-md-2 col-sm-2">
		<input type="number" class="form-control" id="newFile-date_issued_year" name="newFile[date_issued_year]" value="" min="#get('myapp').yearStart#" max="#DateFormat(Now(),'YYYY')#" placeholder="Year" aria-label="Published year">
	</div>
	<div class="form-group col-lg-2 col-md-2 col-sm-2">
		<input type="number" class="form-control" id="newFile-date_issued_month" name="newFile[date_issued_month]" value="" min="1" max="12" placeholder="Month" aria-label="Published month">
	</div>
	<div class="form-group col-lg-2 col-md-2 col-sm-2">
		<input type="number" class="form-control" id="newFile-date_issued_day" name="newFile[date_issued_day]" value="" min="1" max="31" placeholder="Day" aria-label="Published day">
	</div>
</div>
</cfoutput>