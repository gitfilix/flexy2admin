<cfapplication name="flexy2CMSFEE" sessionmanagement="yes" setclientcookies="yes" sessiontimeout="#createTimeSpan(0,0,40,0)#">

<cfset application.dsn = "atelier_schief_ch">


<cfparam name="session.login" default="0" />
<cfif isdefined("url.login")>
	<cfset session.login = url.login />
	<cfset session.mandant = url.mandant />
	<cfset session.serverpath = url.serverpath />
</cfif>

<cfif isdefined("url.logout")>
	<cfset session.login = false />
	<cfset session.mandant = 0 />
	<cfset session.serverpath = "" />
	<cflocation addtoken="no" url="#cgi.SCRIPT_NAME#">
</cfif>

<cfif session.login EQ 0>
	Sie sind nicht berechtigt!
	<cfabort>
<cfelse>


<cfif isdefined("url.table") AND cgi.SCRIPT_NAME DOES NOT CONTAIN "changePosition.cfm">

	<cfparam name="url.table" default="">
	<cfparam name="url.field" default="">
	<cfparam name="url.mandant" default="0">
	<cfparam name="url.id" default="0">
	
	<cfquery name="getResultSet" datasource="#application.dsn#">
	SELECT 	#url.field#
	FROM	#url.table#
	WHERE	id = #url.id#
	</cfquery>


</cfif>


<cfif isdefined("url.function")>

	<!--- <cfparam name="url.function" default="">
	<cfparam name="url.parentId" default="0">
	<cfparam name="url.actid" default="0">
	<cfparam name="url.mandant" default="0">
	
	<cfquery name="getResultSet" datasource="#application.dsn#">
	SELECT 	#url.field#
	FROM	#url.table#
	WHERE	id = #url.id#
	</cfquery>
 --->

</cfif>


</cfif>