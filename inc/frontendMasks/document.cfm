<cfprocessingdirective pageencoding="utf-8" />

<!--- get default serverpath from mandanten-table --->
<cfquery name="getServerpath" datasource="#application.dsn#">
SELECT	directoryname as serverpath
FROM	mandanten
WHERE	id = #url.mandant#
</cfquery>

<!--- set default img-directory --->
<cfset dir = "/" & getServerpath.serverpath & "/upload/doc/" />

<cfif isdefined("form.orig#url.field#")>

	<cfif evaluate('form.' & url.field) NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cfset serverdocname = cffile.serverfile>
	<cfelseif isdefined("del#url.field#")>
		<cfset serverdocname = "">
	<cfelse>
		<cfset serverdocname = evaluate('form.orig' & url.field)>
	</cfif>

	<cfquery name="setResultSet" datasource="#application.dsn#">
	UPDATE	#url.table#
	SET		#url.field# = '#serverdocname#'
	WHERE	id = #url.id#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#?table=#url.table#&field=#url.field#&mandant=#url.mandant#&id=#url.id#&done=true" addtoken="no">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfif isdefined("url.done")>
	<script type="text/javascript">
		window.parent.location.reload();
	</script>
</cfif>

</head>

<body id="bdy">
	<cfoutput>
	<cfif not isdefined("url.done")>
	<form action="#cgi.SCRIPT_NAME#?table=#url.table#&field=#url.field#&mandant=#url.mandant#&id=#url.id#&sent=true" name="frontendform" id="frontendform" method="post" enctype="multipart/form-data" onSubmit="document.getElementById('result').innerHTML='Bitte warten während die Informationen gespeichert werden...';this.style.display='none'">
		Momentan auf dem Server: <a href="#dir##evaluate('getResultSet.' & url.field)#" target="_blank">#evaluate('getResultSet.' & url.field)#</a><br/>
		<input type="checkbox" name="del#url.field#" value="#evaluate('getResultSet.' & url.field)#" /> löschen<br/>
		
		<input type="file" name="#url.field#">
		<input type="hidden" name="orig#url.field#" value="#evaluate('getResultSet.' & url.field)#" />
		<br/><br/>
		<input type="submit" value="Speichern" /> 
	</form>
	<div id="result"></div>
	<cfelse>
		Seite wird neu geladen
	</cfif>
	</cfoutput>
	

</body>
</html>


