<cfif isdefined("form.label")>
	<cfquery name="updateLayer" datasource="#application.dsn#">
	UPDATE	magazininhaltselemente
	SET		elemName = '#form.label#'
	WHERE	id = #form.elemID# AND magazinPageID = #form.pageID#
	</cfquery>
<cfelseif isdefined("form.visible")>
	<cfquery name="updateLayer" datasource="#application.dsn#">
	UPDATE	magazininhaltselemente
	SET		isvisible = #form.visible#
	WHERE	id = #form.elemID# AND magazinPageID = #form.pageID#
	</cfquery>
<cfelse>
	<cfset zIndex = (listLen(form.sortlist)*10)+10 />
	<cfloop list="#form.sortlist#" index="i">
		<cfquery name="updateLayers" datasource="#application.dsn#">
		UPDATE	magazininhaltselemente
		SET		zIndex = #zIndex-10#
		WHERE	id = #i# AND magazinPageID = #form.pageID#
		</cfquery>
		<cfset zIndex = zIndex - 10 />
	</cfloop>
</cfif>