<cfquery name="update" datasource="#application.dsn#">
DELETE	
FROM	magazininhaltselemente
WHERE	id = #form.id#
</cfquery>


<cfloop list="galaxyTab,ipad,surface" index="i">

	<cfquery name="update" datasource="#application.dsn#">
	DELETE	
	FROM	magazininhaltselemente_#i#
	WHERE	magazinInhaltsElementID = #form.id#
	</cfquery>


</cfloop>