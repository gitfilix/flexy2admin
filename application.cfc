<cfcomponent>
	<cfscript>
		this.name = hash( getCurrentTemplatePath() & "3" ); 
		this.sessionManagement = "true";
		this.applicationTimeout = CreateTimeSpan(0,0,30,0);
		this.sessionTimeout = CreateTimeSpan(0,0,30,0);
		this.setClientCookies = "true";
		this.authcookie.timeout = "-1";
		this.setDomainCookies = "true";
		this.sessioncookie.httponly = "true";
		this.sessioncookie.timeout = CreateTimeSpan(0,0,30,0);
		this.datasource = "atelier_schief_ch";
	</cfscript>
	
	<cfif structKeyExists( url, "logout" )>
		<cfset this.sessionTimeout = createTimeSpan( 0, 0, 0, 1 ) />
		<cfset this.applicationTimeout = createTimeSpan( 0, 0, 0, 1 ) />
	</cfif>
	
	<cffunction name="onApplicationStart"> 
		<cfset application.dsn = this.datasource />	
	</cffunction>
	
	<cffunction	name="OnSessionStart" access="public" returntype="void"	output="false" hint="Fires when user session initializes (first fun).">
		<!--- <cfcookie name="CFID" value="#SESSION.CFID#" httponly="true" />
		<cfcookie name="CFTOKEN" value="#SESSION.CFTOKEN#" httponly="true" /> --->
		
		<cfset session.loggedIn = "false">
		<cfset session.module = "inc_login">
		<cfset session.moduleID = "0">
		<cfset session.userid = "0">
		<cfset session.serverpath = "">
		<cfset session.UserPreName = "">
		<cfset session.viewPages = "0">
		<cfset session.admin = "0">
		<cfset session.moduleList = "">
		<cfset session.mandant = "0">
	</cffunction>
	
	<cffunction name="onRequestStart"> 
		<cfargument name="requestname" required="true" />
		<cfset application.timeout = 30 />	
		<cfset var local = {} />
		<cfset remoteServerPath = expandPath('/')>
		
		<!--- schweiz-spezifische formatierungen anwenden (zahlen,daten etc.) --->
		<cfset locale = SetLocale("German (Swiss)")>
		
		<!--- dies ist nur für die pagemanagement-ansicht im flexy --->
		<cfif isdefined("url.viewx")>
			<cfset session.viewPages = url.viewx />
		</cfif>
		
		<!--- login mechan --->
		<cfif isdefined("form.username") AND isdefined("form.password")>
		
			<!--- db abfragen (user tabelle) aktive user --->
			<cfquery name="getUser" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	user
			WHERE 	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.username#" />  AND
					password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.password#" /> AND
					isActive = 1
			</cfquery>
			<!---	wenn die getUser ein recordset von 1 zurückgibt > setze session loggedIn auf True --->
			<!---	set user id = session User ID--->
			<!---	set serverpath variable (mandant-ID) --->	
			<cfif getUser.recordcount EQ 1>
			
				<!--- erst checken ob bereits eingeloggt
				<cfquery name="checkLoggedInUser" datasource="#application.dsn#">
				SELECT	userID
				FROM	userloggedin
				WHERE 	userid = #getUser.id#
				</cfquery>
				
				<cfif checkLoggedInUser.recordcount NEQ 0>
					<cfif not isdefined("url.admin")>
						<cflocation url="/admin/?alreadyLoggedIn" addtoken="no" />
					</cfif>
				</cfif> --->
				
				
				
				
				
				
				
			
			
				<cfset session.loggedIn = true>
				<cfset session.module = "inc_welcome" />
				<cfset session.admin = getUser.isAdmin />
				<cfset session.userID = getUser.ID />
				<!--- temporär in loggedIn Tabelle schreiben
				<cfquery name="insertLoggedIn" datasource="#application.dsn#">
				INSERT
				INTO 	userLoggedIn(
						datumZeit,
						mandant,
						userID,
						sessionToken
						)
				VALUES 	(#createODBCdateTime(now())#,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#getUser.mandant#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.userID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.URLToken#" />
						)
				</cfquery> --->
				<!--- Aktiver User Name auslesen und in variable session.UserPrename speichern--->
				<cfset session.UserPreName = getUser.vorname />
				<cfquery name="getMandant" datasource="#application.dsn#">
				SELECT 	* 
				FROM 	mandanten
				WHERE 	id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getUser.mandant#" />
				</cfquery>
				<cfset session.mandant = getUser.mandant />
				<cfset session.serverpath = getMandant.directoryname />
				
				<cfquery name="getDomainByMandant" datasource="#application.dsn#">
				SELECT 	domain
				FROM 	mandantensprachen
				WHERE 	mandant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.mandant#" />
				</cfquery>

				<cfset session.mandantURL = getDomainByMandant.domain />
				
				<!--- zusätzlich kontrolieren, ob der mandant ein anderes web-root auf dem server hat. wenn ja, die variable entsprechend anpassen --->
				
				
				<cfif getMandant.physicalPathOnServer NEQ remoteServerPath>
					<cfset remoteServerPath = getMandant.physicalPathOnServer />
				</cfif>
				
				<cfquery name="getSettings" datasource="#application.dsn#">
				SELECT 	* 
				FROM 	settings
				WHERE 	mandant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getUser.mandant#" />
				</cfquery>
				<cfset session.lang = getSettings.defaultlang />
				<!--- rechte auf module prüfen und in session-var speichern --->
				<cfset session.moduleList = "" />
				<cfquery name="getUserModules" datasource="#application.dsn#">
				SELECT U.id FROM modules U LEFT JOIN usermodules M ON M.moduleid = U.id
				WHERE M.userid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.userID#" />
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
				<!--- SESSION TIMEOUT TIMER --->
				<cfset currenttime = now() />
				<cfset sesstimeout = dateAdd('n',application.timeout, currenttime) />
				<cfcookie name="servertime"  value="#DateFormat(currentTime, 'yyyy/mm/dd')# #TimeFormat(currentTime, 'HH:mm:ss')#" />
				<cfcookie name="sessiontimeout" value="#DateFormat(sessTimeout, 'yyyy/mm/dd')# #TimeFormat(sessTimeout, 'HH:mm:ss')#" />
				<!--- <cflocation url="/admin" addtoken="no" /> --->
			</cfif>
		</cfif>
		
		<cfif isdefined("url.lang")>
			<cfset session.lang = url.lang />
		</cfif>
		
		<cfquery name="getMandant" datasource="#application.dsn#">
		SELECT 	physicalPathOnServer 
		FROM 	mandanten
		WHERE 	id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.mandant#" />
		</cfquery>
		
		<!--- zusätzlich kontrolieren, ob der mandant ein anderes web-root auf dem server hat. wenn ja, die variable entsprechend anpassen --->
		<cfif getMandant.physicalPathOnServer NEQ remoteServerPath>
			<cfset remoteServerPath = getMandant.physicalPathOnServer />	
		</cfif>
		
		<!--- logout mechan --->
		<cfif isdefined("url.logout") AND url.logout EQ "true">
		<!---session loggedIn false & session-Modul inc_login --->
			<!--- aus temporär-tabelle löschen --->
			<cfquery name="deleteLoggedIn" datasource="#application.dsn#">
			DELETE	
			FROM	userLoggedIn
			WHERE	userid = #session.userID#
			</cfquery>
			<cfset session.loggedIn = false>
			<cfset session.module = "inc_login" />		
			<cfset structDelete(session,'userprename') />
			<cfset structDelete(session,'userid') />
			<cfset structDelete(session,'serverpath') />

			<!--- <cfloop index="local.cookieName" list="cfid,cftoken,cfmagic,SERVERTIME,SESSIONTIMEOUT">
				<!--- Expire this session cookie. --->
				<cfcookie name="#local.cookieName#" value="" expires="now" /> 
			</cfloop> --->
			
			<!--- <cfcookie name="CFID" value="" expires="now" />
			<cfcookie name="CFTOKEN" value="" expires="now" />
			<cfcookie name="jsessionid" expires="now"/> --->
			<cflocation url="/admin" addtoken="false" />
			<!--- auch die FEE masken logouten --->
			<!--- <cfinclude template="/admin/inc/frontendMasks/application.cfm"> --->
		</cfif>
		
		<!--- module instanzieren --->
		<cfif isdefined("url.module") AND session.moduleList NEQ "">
			<!--- erst checken ob überhaupt berechtigt --->
			<!--- aufgerufenes modul auslesen --->
			<cfquery name="getUserModule" datasource="#application.dsn#">
			SELECT	*
			FROM	modules
			WHERE	variable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(url.module,'_')#" />
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
				WHERE	variable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(url.module,'_')#" />
				</cfquery>
				<cfset session.moduleID = getUserModule.id />
			</cfif>
		</cfif>
		
		
		<!--- temporäre tabelle updaten, um aktuelles modul einzutragen --->
		<cfif session.loggedIn EQ true AND cgi.SCRIPT_NAME DOES NOT CONTAIN "inc/">
			<cfquery name="getUserModule" datasource="#application.dsn#">
			UPDATE	userLoggedIn
			SET		module = '#session.module#',
					page = '#cgi.SCRIPT_NAME#<cfif cgi.QUERY_STRING NEQ "">?#cgi.QUERY_STRING#</cfif>'
			WHERE	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.userID#" />
			</cfquery>
			
			<!--- activity log aufzeichnung von form-posts --->
			<cfif structKeyExists(form,'fieldnames')>
				<cfquery name="insertActivity" datasource="#application.dsn#">
				INSERT	
				INTO	useractivitylog(
							datumZeit,
							userID,
							mandant,
							urlx, 
							dumpx, 
							module,
							dumpx2
						)
				VALUES(
					#createODBCDateTime(now())#,
					#session.userID#,
					#session.mandant#,
					'#cgi.SCRIPT_NAME#<cfif cgi.QUERY_STRING NEQ "">?#cgi.QUERY_STRING#</cfif>',
					<cfwddx action="cfml2wddx" input="#form#" output="formularEingaben" />
					'#formularEingaben#',
					#session.moduleID#,
					<cfsavecontent variable="formFormated">
						<cfloop list="#form.fieldnames#" index="i">
							<strong>#i#</strong>: #form[i]#<hr/>
						</cfloop>
					</cfsavecontent>
					'#formFormated#'
				)
				</cfquery>
			</cfif>
			<!--- activity log aufzeichnung der seite --->
			<cfquery name="insertActivityPageRequest" datasource="#application.dsn#">
			INSERT	
			INTO	useractivitylog(
						datumZeit,
						userID,
						mandant,
						urlx,
						module
					)
			VALUES(
				#createODBCDateTime(now())#,
				#session.userID#,
				#session.mandant#,
				'#cgi.SCRIPT_NAME#<cfif cgi.QUERY_STRING NEQ "">?#cgi.QUERY_STRING#</cfif>',
				<cfif isdefined("url.module") AND url.module EQ "inc_welcome">0<cfelse>#session.moduleID#</cfif>
			)
			</cfquery>
		</cfif>
		
		<!--- <cfscript>
			include "application.cfm";
			return true;
		</cfscript> --->
	</cffunction>
	
	
	<cffunction name="onRequest"> 
		<cfargument name="requestname" required="true" />
		<cfscript>
			include arguments.requestname;
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="onRequestEnd"> 
		
	</cffunction>
	
	<cffunction name="onSessionEnd"> 
		<cfargument name="SessionScope" required="true" />
		<cfargument name="ApplicationScope" required="no" />

		<cfquery name="deleteLoggedIn" datasource="#arguments.ApplicationScope.dsn#">
		DELETE	
		FROM	userLoggedIn
		WHERE	userid = #arguments.SessionScope.userid#
		</cfquery>
		
		<!--- <cfloop index="local.cookieName" list="cfid,cftoken,cfmagic,SERVERTIME,SESSIONTIMEOUT">
			<!--- Expire this session cookie. --->
			<cfcookie name="#local.cookieName#" value="" expires="now" /> 
		</cfloop> --->
		
	</cffunction>
	
	<cffunction name="onApplicationEnd"> 
		<cfargument name="appScope" required="true" /> 
	</cffunction>
	
	<cffunction name="onError"> 
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
		<cfset var errortext = "">
	
		<cfdump var="#arguments.exception#" label="Error">
		<cfdump var="#form#" label="Form">
		<cfdump var="#url#" label="URL">
		
		
		<cfsavecontent variable="errortext">
		<cfoutput>
		An error occurred: http://#cgi.server_name##cgi.script_name#?#cgi.query_string#<br />
		Time: #dateFormat(now(), "short")# #timeFormat(now(), "short")#<br />
		
		<cfdump var="#arguments.exception#" label="Error">
		<cfdump var="#form#" label="Form">
		<cfdump var="#url#" label="URL">
		
		</cfoutput>
		</cfsavecontent>
		
		<cfmail to="info@reziprok.ch" from="info@flx-media.ch" subject="Error: #arguments.exception.message#" type="html">
			#errortext#
		</cfmail>
		
		<!--- <cflocation url="error.cfm"> --->
	</cffunction>
	
</cfcomponent>