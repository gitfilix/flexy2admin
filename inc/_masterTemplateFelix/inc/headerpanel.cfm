<cfif pageProperties.headerbild NEQ "" OR getHeaderPanels.recordcount GT 0>
<div style="margin-bottom:3em;">

	<cfif pageProperties.headerbild NEQ "">
		<cfoutput><img src="/#session.serverpath#/upload/img/#pageProperties.headerbild#" alt="" /></cfoutput>
	<cfelse>
		 <div class="flexslider">
		     <div class="slides">
		     
			<cfoutput query="getHeaderPanels">
			  <div class="slide">
			   <img src="/#session.serverpath#/upload/img/headerpanel/#image#" />
				<!--- <div style="position:absolute;right:1em;bottom:1em;width:30%;background-color:silver;">
					<strong>hier ein titel1</strong><br />
					Vivamus tristique sollicitudin purus quis rutrum. Aenean nibh leo, venenatis quis dignissim non; tincidunt ut velit. <br/><br/>
					<a href="##">ein Links</a>
				</div> --->
			</div>
			</cfoutput>
		  </div>
		</div>
	</cfif>
</div>
</cfif>
