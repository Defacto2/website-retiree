<!---
  	Link form "Published date" partial view.
	path: views/link/_inputDate.cfm

@CFLintIgnore
--->
<cfoutput>
<div class="row">
	<div class="form-group form-group-sm col-sm-12 form-published-date">
		<label for="pubYear-year" class="text-muted">Published date</label>
		<small>
	</div>
	<div class="form-group form-group-sm col-sm-12">
		<div class="col-sm-3">
		<select class="form-control input-sm" id="pubYear-year" name="date_issued_year">
			<option selected="selected" value="">&nbsp;</option>
			<cfloop from="1990" to="#DateFormat(Now(),'YYYY')#" index="local.year">
				<cfif "#website.date_issued_year#" == "#year#"><option value="#year#" selected>#year#</option>
				<cfelse><option value="#year#">#year#</option></cfif>
			</cfloop>
		</select>
		</div>
		<div class="col-sm-4">
		<select class="form-control input-sm" id="pubMonth-month" name="date_issued_month">
			<option selected="selected" value="">&nbsp;</option>
			<cfloop from="1" to="12" index="local.month">
				<cfif website.date_issued_month == month><option value="#month#" selected>#MonthAsString(month)#</option>
				<cfelse><option value="#month#">#MonthAsString(month)#</option></cfif>
			</cfloop>
		</select>
		</div>
		<div class="col-sm-3">
		<select class="form-control input-sm" id="pubDay-day" name="date_issued_day">
			<option selected="selected" value="">&nbsp;</option>
			<cfloop from="1" to="31" index="local.day">
				<cfif website.date_issued_day == day><option value="#day#" selected>#day#</option>
				<cfelse><option value="#day#">#day#</option></cfif>
			</cfloop>
		</select>
		</div>
	</div>
</div>
</cfoutput>