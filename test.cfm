
<cfif isdefined("url.sended")>
	
	<cfdump var="#form#">

	
	
	
	<cfset x = "z">
	
	<cfoutput>
		
		
		#form['z']#
		
	</cfoutput>
	
	<hr />
</cfif>



<cfoutput>
<form action="#cgi.SCRIPT_NAME#?sended=true" method="post">
	<input type="text" name="z" value="1" /><br/>
	<input type="submit" value="send" />
</form>
</cfoutput>