<cfoutput query="getcontent">	
		<!---   <cfdump var="#getcontent#">  --->
			  
			<cfif HASCONTACT EQ 1>
				<cfinclude template="contactform.cfm">
			<cfelseif PAGEID EQ 273>
			<!--- include special Content for page-id 273 for Big-picture --->
					<cfinclude template="scpecialcontent.cfm">
			<cfelse>
			<div class="content_big">
				<cfif BILDNAME NEQ "">
					<img src="/#session.serverpath#/upload/img/#bildname#" alt="hi" />
				</cfif>
				<cfif IMAGECAPTION NEQ "">
					<br /> <br /> 
					<p id="pic_desc">#IMAGECAPTION#</p>
				</cfif>
			</div>
		</cfif>
</cfoutput>

<!--- include gallery --->
<div class="gallery_content">
	<cfinclude template="content_flexslider.cfm"> 
</div>