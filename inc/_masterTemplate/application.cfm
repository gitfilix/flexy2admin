<!--- Application für webdesign flx --->
<!--- erst mandant auselsen auf basis ersten ordners ab root --->

<cfif listFirst(cgi.SCRIPT_NAME,'/') NEQ "index.cfm">
	<cfquery name="getMandant" datasource="atelier_schief_ch">
	SELECT * FROM mandanten
	WHERE directoryname = '#listFirst(cgi.SCRIPT_NAME,'/')#'
	</cfquery>
<cfelse>
	<cfquery name="getMandant" datasource="atelier_schief_ch">
	SELECT 	M.* 
	FROM	mandantensprachen S LEFT JOIN 
			mandanten M ON M.id = S.mandant
	WHERE 	domain = '#replace(cgi.SERVER_NAME,'www.','')#'
	</cfquery>
</cfif>

<cfapplication name="#replace(getMandant.directoryname,'-','','ALL')#" sessionmanagement="yes" setclientcookies="yes" sessiontimeout="#createTimeSpan(0,0,40,0)#">

<cfparam name="session.startID" default="0" />
<cfparam name="session.serverpath" default="" />
<cfparam name="session.mandant" default="0" />
<cfparam name="session.adminSession" default="0" />
<cfparam name="application.anzahlLevels" default="2" />
<cfparam name="session.cugLoggedIn" default="0" />
<cfparam name="session.securedPageIdList" default="" />
<cfset application.dsn = "atelier_schief_ch" />

<cfif listFirst(cgi.SCRIPT_NAME,'/') NEQ "index.cfm">
	<cfset session.serverpath = listFirst(cgi.SCRIPT_NAME,'/') />
<cfelse>
	<cfset session.serverpath = getMandant.directoryname />
</cfif>

<!--- <cferror type="exception" mailto="info@reziprok.ch" template="/#session.serverpath#/error.cfm" /> --->
<cfset session.mandant = getMandant.id />
<!--- set default-language session --->
<cfquery name="getDefaultLanguage" datasource="#application.dsn#">
SELECT * FROM settings
WHERE mandant = #session.mandant#
</cfquery>
<cfparam name="session.lang" default="#getDefaultLanguage.defaultlang#" />
<!--- sprachspezifische startseite --->
<cfquery name="getDefaultLanguage" datasource="#application.dsn#">
SELECT * FROM langstartpages2mandanten
WHERE mandant = #session.mandant# AND lang = '#session.lang#'
</cfquery>
<cfset session.startID = getDefaultLanguage.startpage />
<cfparam name="url.id" default="#session.startID#" />
<cfif not isnumeric(url.id)>
	<cfset url.id = session.startID />
</cfif>
<cfparam name="session.navtree"	default="#session.startID#" />
<cfparam name="session.fullNavTree"	default="#session.navtree#" />

<!--- sprach-wechsel --->
<cfif isdefined("url.lang")>
	<cfquery name="checkForAcceptedLangs" datasource="#application.dsn#">
	SELECT * FROM mandantensprachen
	WHERE mandant = #session.mandant# AND languageParam = '#url.lang#'
	</cfquery>
	<cfif checkForAcceptedLangs.recordcount EQ 1>
		<cfset session.lang = url.lang />
		<cfquery name="getLanguageDependentStartpage" datasource="#application.dsn#">
		SELECT * FROM langstartpages2mandanten
		WHERE mandant = #session.mandant# AND lang = '#session.lang#'
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#?id=#getLanguageDependentStartpage.startpage#" addtoken="no" statuscode="301" />
	</cfif>
</cfif>
<!--- set adminSession for FEE --->
<cfif isdefined("url.adminSession")>
	<cfset session.adminSession = url.adminSession />
	<cfif url.adminSession EQ 0>
		<cflocation addtoken="no" url="#cgi.SCRIPT_NAME#" />
	</cfif>
</cfif>
<!--- anzahl berechtigter levels auslesen --->
<cfquery name="getAllowdLevels" datasource="#application.dsn#">
SELECT	navlevels
FROM	mandanten
WHERE	id = #session.mandant#
</cfquery>
<cfset application.anzahlLevels = getAllowdLevels.navlevels />
<cfset application.com.global	= createObject("component","#session.serverpath#.inc.cfc.global") />

<!--- login cug-user --->
<cfif isdefined("form.cugusername") AND isdefined("form.cugpassword")>
	<!--- db abfragen (user tabelle) aktive user --->
	<cfquery name="getUser" datasource="#application.dsn#">
	SELECT 	* 
	FROM 	cugUsers
	WHERE 	email = '#form.cugusername#' AND
			password = '#form.cugpassword#' AND
			isActive = 1
	</cfquery>
	<!---	wenn die getUser ein recordset von 1 zurückgibt > setze session loggedIn auf True --->
	<cfif getUser.recordcount EQ 1>
		<cfset session.cugLoggedIn = 1 />
		<cfset session.cug = structNew() />
		<cfset session.cug.name = getUser.username />
		<cfset session.cug.vorname = getUser.uservorname />
		<cfset session.cug.id = getUser.id />
		<cfset session.cug.groupid = getUser.groupId />
		<!--- in log tabelle eintragen --->
		<cfquery name="insertUserLog" datasource="#application.dsn#">
		INSERT
		INTO 	cugUserLog(cuguserid,logginDate)
		VALUES(
				#session.cug.id#,
				#createODBCdatetime(now())#
		)
		</cfquery>
		<cflocation addtoken="no" url="#cgi.SCRIPT_NAME#?loggedIn=true" />
	<cfelse>
		<cflocation addtoken="no" url="#cgi.SCRIPT_NAME#?loggedIn=false" />
 	</cfif>
</cfif>
<!--- cug logoff --->
<cfif isdefined("url.cuglogoff") AND url.cuglogoff EQ "true">
	<cfset session.cugLoggedIn = 0 />
	<cfif structKeyExists(session,'cug')>
		<cfset structDelete(session.cug,"groupid") />
		<cfset structDelete(session.cug,"id") />
		<cfset structDelete(session.cug,"name") />
		<cfset structDelete(session.cug,"vorname") />
	</cfif>
	<cflocation addtoken="no" url="#cgi.SCRIPT_NAME#?loggedOff=true" />
</cfif>

<cfif session.cugLoggedIn EQ 1>
	<cfquery name="getSecuredPages" datasource="#application.dsn#">
	SELECT 	P.id, P.pagetitel, P.navtitel
	FROM	pages P LEFT JOIN usergroups2pages G
			ON G.pageID = P.id AND P.mandant = #session.mandant# AND P.isActive = 1 AND P.lang = '#session.lang#'
	WHERE	G.userGroupId = #session.cug.groupid#
	GROUP	BY P.id
	ORDER	BY P.id
	</cfquery>
	<cfset session.securedPageIdList = "" />
	<cfoutput query="getSecuredPages">
		<cfset session.securedPageIdList = listAppend(session.securedPageIdList,id) />
	</cfoutput>
<cfelse>
	<cfquery name="getSecuredPages" datasource="#application.dsn#">
	SELECT 	P.id, P.pagetitel, P.navtitel
	FROM	pages P LEFT JOIN usergroups2pages G
			ON G.pageID = P.id
	WHERE	P.mandant = #session.mandant# AND P.isActive = 1 AND P.lang = '#session.lang#'
	GROUP	BY P.id
	ORDER	BY P.id
	</cfquery>
	<cfset session.securedPageIdList = "" />
	<cfoutput query="getSecuredPages">
		<cfset session.securedPageIdList = listAppend(session.securedPageIdList,id) />
	</cfoutput>
</cfif>
<!--- UDF: user defined function
Get url id from shortcut and use as argument  --->
<cffunction name="getIDfromURLShortcut" access="private" returntype="numeric">
	<cfargument name="urlShortcut" type="string" />
	
	<cfquery name="getIDfromURLShortcut" datasource="#application.dsn#">
	SELECT * FROM pages
	WHERE urlshortcut = '#arguments.urlShortcut#' AND mandant = #session.mandant# AND lang = '#session.lang#'
	</cfquery>
	
	<cfif getIDfromURLShortcut.recordcount EQ 1>
		<cfset retVar = getIDfromURLShortcut.id />
	<cfelse>
		<cfset retVar = session.startID />
	</cfif>
	
	<cfreturn retVar />  
</cffunction>

<cfset pathInfo = cgi.PATH_INFO />
<cfif listLen(pathInfo,'/') GTE 3 AND listGetAt(pathInfo,2,'/') NEQ "index.cfm">
	<cfset url.id = getIDfromURLShortcut(urlShortcut=listLast(pathinfo,'/')) />
</cfif>

<cfset application.com = structNew() />
<cfset application.com.nav	= createObject("component","#session.serverpath#.inc.cfc.nav2") />

<cfif isnumeric(url.id)>
	<cfset session.navtree	= application.com.nav.navtree(id=url.id) />
<cfelse>	
	<cfset session.navtree	= session.startID />
</cfif>

<cfif session.cugLoggedIn EQ 1>
	<cfset session.fullNavTree = application.com.nav.getFullNavTreeRightDependent(tree=session.navtree,mandant=session.mandant,navpos=1,lang=session.lang,usergroup=session.cug.groupid,type=2,parentid=url.id,level=0) />
<cfelse>
	<cfset session.fullNavTree = application.com.nav.getFullNavTreeRightDependent(tree=session.navtree,mandant=session.mandant,navpos=1,lang=session.lang,usergroup=0,type=2,parentid=url.id,level=0) />
</cfif>

<!--- redirect id-based urls to rewrites equivalent (if existing) --->
<cfif ListLen(cgi.QUERY_STRING,'&') EQ 1 AND listFirst(cgi.QUERY_STRING,'=') EQ "id">
	
	<cfset urlpathinfo = "" />
	<cfset breadcrumb = "" />
	
	<cfparam name="breadcrumb" default="" />
	<cfloop list="#session.navtree#" index="i">
		<cfquery name="getpagedata" datasource="#application.dsn#">
		SELECT * FROM pages
		WHERE id = #i#
		</cfquery>
		<cfset breadcrumb = ListAppend(breadcrumb,urlencodedformat(getpagedata.urlshortcut),"/") />
	</cfloop>
	<cfif breadcrumb NEQ "">
		<cfheader statuscode="301" statustext="Moved permanently" />
		<cfheader name="location" value="http://#cgi.server_name#/#session.serverpath#/#session.lang#/#breadcrumb#" />
		<cfabort />
	</cfif>
</cfif>

<cfquery name="checkExistingID" datasource="#application.dsn#">
SELECT * FROM pages
WHERE id = '#url.id#'
</cfquery>

<cfif checkExistingID.recordcount EQ 0>
	<cfset url.id = session.startID />
	<cflocation url="/" addtoken="no" statuscode="301">
</cfif>