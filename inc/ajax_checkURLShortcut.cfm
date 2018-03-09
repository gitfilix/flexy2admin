<cfquery name="getShortcut" datasource="#application.dsn#">
SELECT 	* 
FROM 	pages
WHERE 	urlshortcut = '#url.filename#' AND
		mandant = #session.mandant# AND
		lang = '#session.lang#'
</cfquery>
<cfif getShortcut.recordcount NEQ 0>
	1
<cfelse>
	0
</cfif>