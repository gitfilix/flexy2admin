<cfprocessingdirective pageencoding="utf-8" />

<cfif isdefined("form.formfield")>
	<cfquery name="getResultSet" datasource="#application.dsn#">
	UPDATE	#url.table#
	SET		#url.field# = '#form.formfield#'
	WHERE	id = #url.id#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#?table=#url.table#&field=#url.field#&mandant=#url.mandant#&id=#url.id#&done=true" addtoken="no">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.1.1.min.js"></script>
<script>window.jQuery || document.write('<script src="js/jquery-1.7.2.min.js"><\/script>')</script>
<cfif isdefined("url.done")>
	<script type="text/javascript">
		window.parent.location.reload();
	</script>
</cfif>

<script>
$(document).ready(function(e){
	$(document).bind("contextmenu",function(e){
		  return false;
	});
});
</script>

</head>

<body id="bdy">
	<cfoutput>
	<cfif not isdefined("url.done")>
	<form action="#cgi.SCRIPT_NAME#?table=#url.table#&field=#url.field#&mandant=#url.mandant#&id=#url.id#&sent=true" name="frontendform" id="frontendform" method="post" onsubmit="document.getElementById('result').innerHTML='Bitte warten während die Informationen gespeichert werden...';this.style.display='none'">
		<textarea name="formfield"  id="text" cols="1" rows="1" style="width:100%;height:220px;">#evaluate("getResultSet." & url.field)#</textarea>		
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


