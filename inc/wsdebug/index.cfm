<form action="index.cfm?d=durl">
	<input typr="text" name="durl" id="durl" value="">
	<input type="submit" id="wsdebug" value="Debug Url" >
	
	<cfif isDefined("durl") && (len(durl) gt 10)>
		<cfset Application.url = durl>
		<cflocation url="debug.cfm" >
	</cfif>
	
	
</form>