<cfquery name="getSettings" datasource="#application.dsn#">
SELECT 	* 
FROM 	settings
WHERE 	mandant = #url.mandant#
</cfquery>

<cfset session.mandant = url.mandant />
<cfset session.lang = getSettings.defaultlang  />
<cfset url.pageid = url.parentId />


	
	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
	<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
	<script src="http://code.jquery.com/jquery-migrate-1.1.1.min.js"></script>
	<script>window.jQuery || document.write('<script src="js/jquery-1.7.2.min.js"><\/script>')</script>
</head>

<body>
	<!--- <cfinclude template="/admin/inc/inc_addContent.cfm"> --->
	
	
</body>
</html>

	
	
	