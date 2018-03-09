<cfquery name="getMandanten" datasource="#application.dsn#">
SELECT 	id
FROM	mandanten 
WHERE 	isActive = 1
</cfquery>

<cfset flexyLib = createObject('component','admin.cfc.flexy') />

<cfquery name="getPages" datasource="#application.dsn#">
SELECT 	id
FROM	pages 
WHERE 	mandant NOT IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>)
</cfquery>

<!--- <cfoutput query="getPages">
	<cfset x = flexyLib.deleteEntirePage(delpage=id) />
</cfoutput>  --->

<cfquery name="getUserGroups" datasource="#application.dsn#">
SELECT 	pageid
FROM	usergroups2pages 
WHERE 	pageid NOT IN (SELECT id FROM pages WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>
<cfoutput query="getUserGroups">
	<!--- <cfquery name="delUserGroups" datasource="#application.dsn#">
	DELETE
	FROM	usergroups2pages 
	WHERE 	pageid #pageid#
	</cfquery> --->
</cfoutput>

<cfquery name="getHeaderPages" datasource="#application.dsn#">
SELECT 	pageid
FROM	headerpanels2pages 
WHERE 	pageid NOT IN (SELECT id FROM pages WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>
<cfoutput query="getHeaderPages">
	<!--- <cfquery name="delHeaderPages" datasource="#application.dsn#">
	DELETE
	FROM	headerpanels2pages 
	WHERE 	pageid #pageid#
	</cfquery> --->
</cfoutput>

<cfquery name="getTeasers1" datasource="#application.dsn#">
SELECT 	pageid
FROM	sidebar2pages 
WHERE 	pageid NOT IN (SELECT id FROM sidebar WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>
<cfoutput query="getTeasers1">
	<!--- <cfquery name="delTeasers1" datasource="#application.dsn#">
	DELETE
	FROM	sidebar2pages 
	WHERE 	pageid #pageid#
	</cfquery> --->
</cfoutput>

<cfquery name="getTeasers22" datasource="#application.dsn#">
SELECT 	pageid
FROM	teaser2pages
WHERE 	pageid NOT IN (SELECT id FROM sidebar WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>
<cfoutput query="getTeasers22">
	<!--- <cfquery name="delTeasers22" datasource="#application.dsn#">
	DELETE
	FROM	sidebar2pages 
	WHERE 	pageid #pageid#
	</cfquery> --->
</cfoutput>

<!--- -------------------------------------- --->

<cfquery name="getContent" datasource="#application.dsn#">
SELECT 	id
FROM	content 
WHERE 	pageid NOT IN (SELECT id FROM pages WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>

<!--- <cfoutput query="getContent">

	
	<cfquery name="getTeasers3" datasource="#application.dsn#">
	DELETE
	FROM	teaser2content
	WHERE 	contentid = #id#
	</cfquery>

	<cfquery name="getTeasers34" datasource="#application.dsn#">
	DELETE
	FROM	links2pages
	WHERE 	contentid = #id#
	</cfquery>
	
	<cfquery name="getTeasers35" datasource="#application.dsn#">
	DELETE
	FROM	contents2content
	WHERE 	mainContentID = #id# OR
			linkedContentID = #id#
	</cfquery>
	
	<cfset delContentx = flexyLib.deleteContent(content=id) />
</cfoutput> --->

<!--- -------------------------------------- --->

<cfquery name="getTeasers" datasource="#application.dsn#">
SELECT 	sidebarid
FROM	sidebar2pages 
WHERE 	sidebarID NOT IN (SELECT id FROM sidebar WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>
<cfoutput query="getTeasers">
	<!--- <cfquery name="delTeasers" datasource="#application.dsn#">
	DELETE
	FROM	sidebar2pages 
	WHERE 	sidebarID #sidebarID#
	</cfquery> --->
</cfoutput>

<cfquery name="getTeasers2" datasource="#application.dsn#">
SELECT 	sidebarid
FROM	teaser2pages
WHERE 	sidebarID NOT IN (SELECT id FROM sidebar WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>
<cfoutput query="getTeasers2">
	<!--- <cfquery name="delTeasers2" datasource="#application.dsn#">
	DELETE
	FROM	sidebar2pages 
	WHERE 	sidebarID #sidebarID#
	</cfquery> --->
</cfoutput>

<!--- -------------------------------------- --->

<cfquery name="getHeaders" datasource="#application.dsn#">
SELECT 	headerpanelid
FROM	headerpanels2pages 
WHERE 	headerpanelid NOT IN (SELECT id FROM headerpanels WHERE mandant IN (<cfset cnt = 1 /><cfloop query="getMandanten">#id#<cfif cnt NEQ getMandanten.recordcount>,</cfif><cfset cnt = cnt + 1 /></cfloop>))
</cfquery>

