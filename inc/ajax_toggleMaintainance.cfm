<cfquery name="wartungsCheck" datasource="#application.dsn#">
UPDATE	maintainance
SET		maintainance = #url.state#
WHERE 	id = 1
</cfquery>