<!--- INSERT HERE Mandant specific TEMPLATE --->
<!-- outer wrapper-->
<div id="outer-wrap"> 
<!-- inner wrapper-->
<div id="inner-wrap">
	<!--start Themen nav -->
	<div class="units-row">
		<div class="unit-100 themennav">
			<cfinclude template="themennav.cfm">
		</div>
	</div>
	<!--start head logo and service nav  -->
	<div class="units-row">
		<div class="unit-25">
			<cfinclude template="logo.cfm">
		</div>
		<div class="unit-50">
			&nbsp;
		</div>
		<!--- service navigation --->
		<div class="unit-25 servicenav">
			<cfinclude template="servicenav.cfm">
		</div>
	</div>
	<div class="units-row">
		<div class="unit-100 line_thin">
			&nbsp;
		</div>
	</div>
	<!---  subnavigation here  --->
	<div class="units-row">
		<div class="unit-100">
			<cfinclude template="subnav.cfm">
		</div>
	</div>
	<!--content starts here-->
	<div class="units-row">
		<div class="unit-25">
			&nbsp;
		</div>
		<div class="unit-50">
			<!--start content with gallery slider here-->
			<cfinclude template="content.cfm">
		</div>
		<div class="unit-25">
			<cfinclude template="text.cfm">
			
			<br />
			<cfinclude template="text_gal.cfm">
		</div>
	</div>
	<!--footer starts here-->
	<div class="units-row">
		<footer class="footer">
			<cfinclude template="footer.cfm">
		</footer>
	</div>
<!--inner wrapper-->
</div>
<!--outer wrapper end-->
</div>