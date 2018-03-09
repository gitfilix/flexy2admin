<!---admintool application.cfm: sessionmanabement und clientcookies yes--->
<!--- <cfapplication name="flexy2CMSx" sessionmanagement="yes" setclientcookies="yes" sessiontimeout="#createTimeSpan(0,0,40,0)#"> --->

<!--- default variablen: --->
<!---session logged in default auf false - timeout 20min--->
<!--- <cfparam name="session.loggedIn" default="false">
<!---default session Modul: inc-login--->
<cfparam name="session.module" default="inc_login">
<cfparam name="session.moduleID" default="0">
<!---  default session user id = 0 --->
<cfparam name="session.userid" default="0">
<!--- die serverpath-variable (für FILE-admin img, doc's der jeweiligen mandanten dynamisch ) initialisieren--->
<cfparam name="session.serverpath" default="">
<!---  default session user PreName = 0 --->
<cfparam name="session.UserPreName" default="">
<!---  default session view ob offen oder zu --->
<cfparam name="session.viewPages" default="0">
<cfparam name="session.admin" default="0">
<cfparam name="session.moduleList" default="">
<cfparam name="session.mandant" default="0"> --->
<!---set application dsn (DataSource Name) SQL connection name--->
<!--- <cfset application.dsn = "atelier_schief_ch"> --->

<!--- <cfset locale = SetLocale("German (Swiss)")> --->

<!--- dies ist nur für die pagemanagement-ansicht im flexy --->
<!--- <cfif isdefined("url.viewx")>
	<cfset session.viewPages = url.viewx />
</cfif> --->

<!--- ab server-Root absoulut path übersetzt --->
 <!---   ist "e:\serverdata\atelier-schief.ch\www\html\" --->
<!--- <cfset remoteServerPath = expandPath('/')> --->

<!--- <!--- login mechan --->
<cfif isdefined("form.username") AND isdefined("form.password")>

	<!--- db abfragen (user tabelle) aktive user --->
	<cfquery name="getUser" datasource="#application.dsn#">
	SELECT 	* 
	FROM 	user
	WHERE 	email = '#form.username#' AND
			password = '#form.password#' AND
			isActive = 1
	</cfquery>
	<!---	wenn die getUser ein recordset von 1 zurückgibt > setze session loggedIn auf True --->
	<!---	set user id = session User ID--->
	<!---	set serverpath variable (mandant-ID) --->	
	<cfif getUser.recordcount EQ 1>
		<cfset session.loggedIn = true>
		<cfset session.module = "inc_welcome" />
		<cfset session.admin = getUser.isAdmin />
		<cfset session.userID = getUser.ID />
		<!--- Aktiver User Name auslesen und in variable session.UserPrename speichern--->
		<cfset session.UserPreName = getUser.vorname />
		<cfquery name="getMandant" datasource="#application.dsn#">
		SELECT 	* 
		FROM 	mandanten
		WHERE 	id = #getUser.mandant#
		</cfquery>
		<cfset session.mandant = getUser.mandant />
		<cfset session.serverpath = getMandant.directoryname />
		<cfquery name="getSettings" datasource="#application.dsn#">
		SELECT 	* 
		FROM 	settings
		WHERE 	mandant = #getUser.mandant#
		</cfquery>
		<cfset session.lang = getSettings.defaultlang />
		<!--- rechte auf module prüfen und in session-var speichern --->
		<cfset session.moduleList = "" />
		<cfquery name="getUserModules" datasource="#application.dsn#">
		SELECT U.id FROM modules U LEFT JOIN usermodules M ON M.moduleid = U.id
		WHERE M.userid = #session.userID#
		</cfquery>
		<cfoutput query="getUserModules">
			<cfset session.moduleList = listAppend(session.moduleList,id) />
		</cfoutput>
		<!--- rechte in struct speichern und als session immer verfügbar haben --->
		<cfset session.rechte = structNew() />
		<cfset session.rechte.module = arrayNew(1) />
		
		<cfset counter = 1>
		<cfloop list="#session.moduleList#" index="i">	
		
			<!--- user rechte --->
			<cfquery name="getUserRights" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	userrights
			WHERE 	moduleID = #i# 
					AND userID = #session.userID#
			</cfquery>
			
			<!--- wenn keine rechte für dieses modul gesetzt --->
			<cfif getUserRights.recordcount EQ 0>
				<cfset session.rechte.module[counter] = structNew() />
				<cfset session.rechte.module[counter].id = i />
				<cfset session.rechte.module[counter].edit = 0 />
				<cfset session.rechte.module[counter].del = 0 />
				<cfset session.rechte.module[counter].add = 0 />
				<cfset session.rechte.module[counter].copy = 0 />
			
			<!--- wenn rechte vorhanden --->
			<cfelse>
				<cfset session.rechte.module[counter] = structNew() />
				<cfset session.rechte.module[counter].id = i />
				<cfset session.rechte.module[counter].edit = getUserRights.editright />
				<cfset session.rechte.module[counter].del = getUserRights.delright />
				<cfset session.rechte.module[counter].add = getUserRights.addright />
				<cfset session.rechte.module[counter].copy = getUserRights.copyright />
			
			</cfif>
			<cfset counter = counter + 1 />
		</cfloop>
	</cfif>
</cfif>

<cfif isdefined("url.lang")>
	<cfset session.lang = url.lang />
</cfif>

<!--- logout mechan --->
<cfif isdefined("url.logout") AND url.logout EQ "true">
<!---session loggedIn false & session-Modul inc_login --->
	<cfset session.loggedIn = false>
	<cfset session.module = "inc_login" />		
	<cfset structDelete(session,'userprename') />
	<cfset structDelete(session,'userid') />
	<cfset structDelete(session,'serverpath') />
	<cfcookie name="CFID" value="" expires="now" />
	<cfcookie name="CFTOKEN" value="" expires="now" />
	<cfcookie name="jsessionid" expires="now"/>
	<cfset application.sessionTimeout = createTimeSpan( 0, 0, 0, 1 ) />
	<!--- auch die FEE masken logouten --->
	<!--- <cfinclude template="/admin/inc/frontendMasks/application.cfm"> --->
</cfif> --->

<!--- <!--- module instanzieren --->
<cfif isdefined("url.module") AND session.moduleList NEQ "">
	<!--- erst checken ob überhaupt berechtigt --->
	<!--- aufgerufenes modul auslesen --->
	<cfquery name="getUserModule" datasource="#application.dsn#">
	SELECT	*
	FROM	modules
	WHERE	variable = "#listLast(url.module,'_')#"
	</cfquery>
	<!--- wenn kein admin --->
	<cfif session.admin EQ 0>
		<!--- wenn das modul existiert --->
		<cfif getUserModule.recordcount EQ 1>
			<!--- checken, ob module-id in session.moduleList --->
			<cfif listFind(session.moduleList,getUserModule.id)>
				<!--- wenn gefunden, module-switch machen --->
				<cfset session.module = url.module />
				<cfset session.moduleID = getUserModule.id />
			<cfelse>
				<!--- ansonsten meldung anzeigen und aborten --->
				Sie sind nicht berechtigt dieses Modul aufzurufen	
				<cfabort>
			</cfif>
		</cfif>
	<!--- wenn admin, dann modul-switch erlauben, auch wenn modul nicht in usermodules gefunden --->
	<cfelse>
		<cfset session.module = url.module />
		<!--- aufgerufenes modul auslesen --->
		<cfquery name="getUserModule" datasource="#application.dsn#">
		SELECT	*
		FROM	modules
		WHERE	variable = "#listLast(url.module,'_')#"
		</cfquery>
		<cfset session.moduleID = getUserModule.id />
	</cfif>
</cfif> --->



