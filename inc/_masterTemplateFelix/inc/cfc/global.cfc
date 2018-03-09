<cfcomponent displayname="mirzainprogessGlobal" output="yes">
	
	<cffunction access="public" name="getPageById" returntype="numeric" output="no">
		<cfargument name="id" type="numeric" required="yes" />
		
		<cfquery name="getPageById" datasource="#application.dsn#">
		SELECT 	* from pages
		FROM	pages
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#" />
		</cfquery>

		<cfreturn getPageById />
	</cffunction>

	<!--- -------------------------------------------------------------------------------------------------------------------------------------- --->
	
	
</cfcomponent>