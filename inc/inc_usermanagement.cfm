<cfprocessingdirective pageencoding="utf-8" />
<style type="text/css">


#activ{
	color:#3F3;
	}

#inactiv{
	color:#0F9;
	}

table tr:nth-child(2n){
	background:#949494;
	}
	
	
table tr:nth-child(2n+1){
	background:#B2B2B2;
	}

#addUser{
	background-color:#E5E5E5;
	letter-spacing:2px;
	list-style-type:none;
	}
	
#addUser:hover{
	-webkit-transition:all ease-in  300ms;
	-moz-transition:all ease-in  300ms;
	background-color:#FEFEFE;
	}	

#add input[type=text],
#add input[type=password]{
	width:100%;	
}
</style>

<!--- rechte für dieses modul: --->
<cfloop array="#session.rechte.module#" index="i">
	<cfif i.id EQ session.moduleid>
		<cfset rightEdit = i.edit />
		<cfset rightDel = i.del />
		<cfset rightAdd = i.add />
		<cfset rightCopy = i.copy />
	</cfif>
</cfloop>
<cfif arrayLen(session.rechte.module) EQ 0>
	<cfset rightEdit = 0 />
	<cfset rightDel = 0 />
	<cfset rightAdd = 0 />
	<cfset rightCopy = 0 />
</cfif>

<!--- -------------- form prozessors ------------------ --->

<!--- login als user --->
<cfif isdefined("url.logInAsUser")>
	<!--- db abfragen (user tabelle) aktive user --->
	<cfquery name="getUser" datasource="#application.dsn#">
	SELECT 	* 
	FROM 	user
	WHERE 	id = #url.logInAsUser#
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
		
		<cfquery name="updateLoggedIn" datasource="#application.dsn#">
		UPDATE 	userLoggedIn
		SET		mandant = <cfqueryparam cfsqltype="cf_sql_integer" value="#getUser.mandant#" />,
				userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getUser.id#" />
		WHERE	sessiontoken = '#session.URLToken#'
		</cfquery>
		
		<!--- <cfcookie name="CFID" value="" expires="now" />
		<cfcookie name="CFTOKEN" value="" expires="now" />
		<cfcookie name="jsessionid" expires="now"/> --->
		<cflocation url="/admin" addtoken="false" />
		<cflocation url="/admin/index.cfm?module=inc_welcome" addtoken="no" />
	</cfif>
</cfif>

<!--- alle users auslesen datasource application --->
<cfquery name="getMandant" datasource="#application.dsn#">
SELECT	*
FROM	mandanten
WHERE 	directoryname = '#session.serverpath#'
</cfquery>
<cfquery name="getAllMandanten" datasource="#application.dsn#">
SELECT	*
FROM	mandanten
</cfquery>
<!--- alle users auslesen datasource application --->
<cfquery name="getUsers" datasource="#application.dsn#">
SELECT	*
FROM	user
<cfif session.admin EQ 0>
	WHERE 	mandant = #getMandant.id#
</cfif>
ORDER	BY mandant
</cfquery>
<!--- alle module auslesen  --->
<cfquery name="getModules" datasource="#application.dsn#">
SELECT	*
FROM	modules
WHERE	id IN (SELECT moduleid FROM mandantenmodules WHERE mandantenid = #getMandant.id#)
</cfquery>
<!---
<!--- aktiver eingeloggter user auslesen datasource application --->
<cfquery name="getCurrentUser" datasource="#application.dsn#">
SELECT * 
FROM user

</cfquery>--->

<!--- user löschen --->
<!--- id des zu löschenden users auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.deluser") AND isNumeric(url.deluser) AND url.deluser GT 0>
	<cfquery name="deluser" datasource="#application.dsn#">
	DELETE
	FROM	user
	WHERE	id = #url.deluser#
	</cfquery>
	<!--- modul-zugehörigkeit löschen --->
	<cfquery name="deluser" datasource="#application.dsn#">
	DELETE
	FROM	usermodules
	WHERE	userid = #url.deluser#
	</cfquery>
	<cfquery name="deluserRights" datasource="#application.dsn#">
	DELETE
	FROM	userrights
	WHERE	userid = #url.deluser#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- user hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewUser" AND isdefined("form.password")>
	<cfif isdefined("form.email") AND isValid('email',form.email) AND form.password NEQ "">
		<cfset actionSuceeded = true />
		<cfquery name="insertuser" datasource="#application.dsn#">
		INSERT	
		INTO	user (vorname,name,email,password,isActive,mandant)
		VALUES(
			'#form.vorname#',
			'#form.name#',
			'#form.email#',
			'#form.password#',
			1,
			'#form.mandantenid#'
		)
		</cfquery>
		<cfquery name="getLatestID" datasource="#application.dsn#">
		SELECT 	MAX(id) as maxi
		FROM	user
		</cfquery>
		<!--- module eintragen --->
		<!--- checken ob module übermittelt wurden --->
		<cfif listLen(form.mod) GT 0>
			<!--- durch die form.mod Liste loopen --->
			<cfloop list="#form.mod#" index="i">
				<!--- db-eintrag in zwischentabelle usermodules ; hier werden usern einzelne module zugeordnet --->
				<cfquery name="insertmodules" datasource="#application.dsn#">
				INSERT	
				INTO	usermodules (userid,moduleid)
				VALUES(
					#getLatestID.maxi#,
					#i#
				)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- rechte eintragen --->
		<!--- alle module auslesen um dadurch zu loopen --->
		<cfquery name="getModulesToLoopThrough" datasource="#application.dsn#">
		SELECT	*
		FROM	modules
		WHERE	id IN (SELECT moduleid FROM usermodules WHERE userid = #getLatestID.maxi#)
		</cfquery>
		<!--- loop through --->
		<cfoutput query="getModulesToLoopThrough">
			<!--- now check for existance of form.right_[moduleid] --->
			<cfif isdefined("form.right_#id#")>
				<!--- set the rights for each module --->
				<cfquery name="getModulesToLoopThrough" datasource="#application.dsn#">
				INSERT
				INTO	userrights(
						userid,
						editright,
						delright,
						addright,
						copyright,
						moduleid
						)
				VALUES(
						#getLatestID.maxi#,
						<cfif listFind(evaluate('form.right_' & id),'edit')>1<cfelse>0</cfif>,
						<cfif listFind(evaluate('form.right_' & id),'del')>1<cfelse>0</cfif>,
						<cfif listFind(evaluate('form.right_' & id),'add')>1<cfelse>0</cfif>,
						<cfif listFind(evaluate('form.right_' & id),'copy')>1<cfelse>0</cfif>,
						#id#
				)
				</cfquery>
			</cfif>
		</cfoutput>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	<cfelse>
		<cfset actionSuceeded = false />
	</cfif>
</cfif>

<!--- user updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedUser" AND isdefined("form.password")>
	<cfif isdefined("form.email") AND isValid('email',form.email) AND form.password NEQ "">
		<cfset actionSuceeded = true />
		<cfquery name="updateUser" datasource="#application.dsn#">
		UPDATE	user
		SET		name = '#form.name#',
				vorname = '#form.vorname#',
				email = '#form.email#',
				password = '#form.password#',
				isActive = #form.active#
		WHERE	id = #form.userid#
		</cfquery>
		<!--- module eintragen --->
		<!--- zuerst alle bisherigen assozioationen löschen --->
		<cfquery name="delUserModules" datasource="#application.dsn#">
		DELETE
		FROM	usermodules
		WHERE	userid = #form.userid#
		</cfquery>
		
		<!--- checken ob module übermittelt wurden --->
		<cfif listLen(form.mod) GT 0>
			<!--- durch die form.mod Liste loopen --->
			<cfloop list="#form.mod#" index="i">
				<!--- db-eintrag in zwischentabelle usermodules --->
				<cfquery name="insertmodules" datasource="#application.dsn#">
				INSERT	
				INTO	usermodules (userid,moduleid)
				VALUES(
					#form.userid#,
					#i#
				)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- rechte eintragen --->
		<!--- erst alle vorhandenen rechte löschen --->
		<cfquery name="getModulesToLoopThrough" datasource="#application.dsn#">
		DELETE
		FROM	userrights
		WHERE	userid = #form.userid#
		</cfquery>
		<!--- alle module auslesen um dadurch zu loopen --->
		<cfquery name="getModulesToLoopThrough" datasource="#application.dsn#">
		SELECT	*
		FROM	modules
		WHERE	id IN (SELECT moduleid FROM usermodules WHERE userid = #form.userid#)
		</cfquery>
		<!--- loop through --->
		<cfoutput query="getModulesToLoopThrough">
			<!--- now check for existance of form.right_[moduleid] --->
			<cfif isdefined("form.right_#id#")>
				<!--- set the rights for each module --->
				<cfquery name="getModulesToLoopThrough" datasource="#application.dsn#">
				INSERT
				INTO	userrights(
						userid,
						editright,
						delright,
						addright,
						copyright,
						moduleid
						)
				VALUES(
						#form.userid#,
						<cfif listFind(evaluate('form.right_' & id),'edit')>1<cfelse>0</cfif>,
						<cfif listFind(evaluate('form.right_' & id),'del')>1<cfelse>0</cfif>,
						<cfif listFind(evaluate('form.right_' & id),'add')>1<cfelse>0</cfif>,
						<cfif listFind(evaluate('form.right_' & id),'copy')>1<cfelse>0</cfif>,
						#id#
				)
				</cfquery>
			</cfif>
		</cfoutput>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	<cfelse>
		<cfset actionSuceeded = false />
	</cfif>
</cfif>

<!--- zu bearbeitenden user aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.edituser") AND isNumeric(url.edituser) AND url.edituser GT 0>
	<cfquery name="editUser" datasource="#application.dsn#">
	SELECT	*
	FROM	user
	WHERE	id = #url.edituser#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Users darstellen --->

<h2>USER Management</h2>



<h4>Jeder Mandant hat eine eigene Page </h4>
<h5>[Page = Serverpath = physikalisches Mandanten Directory auf dem Server]</h5>
<h5>Anmerkung: Es können auch mehrere User den selben Mandant haben (2 User - 1 Page)</h5>
<!---
<cfif isdefined ("form.username") AND isdefined("form.password") AND session.loggedIn EQ TRUE>
<cfoutput> willkommen User  #vorname# !</cfoutput>
	
 </cfif>--->

<br>


<table width="100%">
<tr>
	<td><strong>Mandant</strong></td>
	<td><strong>Vorname</strong></td>
	<td><strong>Nachname</strong></td>
	<td><strong>E-Mail</strong></td>
	<td><strong>user Status</strong></td>
	<td><strong>user löschen ?</strong></td>
	<td><strong>user bearbeiten ?</strong></td>
	<td></td>
	<!--- <cfif session.admin EQ 1><td></td></cfif> --->
</tr>
<cfoutput query="getUsers">
<cfif session.admin EQ 1>
	<cfquery name="getLoggedInUserDetails" datasource="#application.dsn#">
	SELECT 	* 
	FROM 	userloggedin
	WHERE	userid = #id#
	</cfquery>
</cfif>
<cfquery name="getMandantByID" datasource="#application.dsn#">
SELECT	*
FROM	mandanten
WHERE 	id = #mandant#
</cfquery>
<tr>
	<td><cfif getMandantByID.directoryname EQ "">#getMandantByID.firma#<cfelse>#getMandantByID.directoryname#</cfif></td>
	<td>#vorname#</td>
	<td>#name#</td>
	<td>#email#</td>
	<td>
	<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
		<cfif isactive EQ 1>
		<div id="activ">	aktiv</div>
		<cfelse>
		<div id="inactiv">	inaktiv </div>
		</cfif>
	</td>
<!---	.userdel  / .useredit sind funktionen mit der jeweiligen userID die als url. parameter mitgegeben werden--->
	<td>
		<cfif rightDel EQ 1>
		<a href="#cgi.SCRIPT_NAME#?deluser=#id#" onclick="return confirm('Sind Sie sicher?');">
			User löschen
		</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?edituser=#id#">
				User bearbeiten
			</a>
		</cfif>
	</td>
	<td>
		<cfif session.admin EQ 1 AND getLoggedInUserDetails.recordcount EQ 0>
			<a href="#cgi.SCRIPT_NAME#?logInAsUser=#id#">
				als User einloggen
			</a>
		<cfelse>
			User eingeloggt
		</cfif>
	</td>
	<!--- <cfif session.admin EQ 1>
	<td>
		<cfif getLoggedInUserDetails.recordcount EQ 0>
		<span style="color:red;font-weight:normal;">offline</span>
		<cfelse>
		<span style="color:green;font-weight:bold;">online</span>
		</cfif>
	</td>
	</cfif> --->
</tr>
</cfoutput>
</table>
<br/>

<!--- dies erscheint nur wenn neuer user erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addUser") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN
	</cfif>
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewUser" method="post" id="add">
	<table width="70%">
	<tr>
		<td>Vorname</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text"name="vorname" <cfif isdefined("form.vorname")>value="#form.vorname#"</cfif>></td>
	</tr>
	<tr>
		<td>Name</td>
		<td><input type="text"name="name" <cfif isdefined("form.name")>value="#form.name#"</cfif>></td>
	</tr>
	<tr>
		<td>E-Mail</td>
		<td><input type="text"name="email" <cfif isdefined("form.email")>value="#form.email#"</cfif>></td>
	</tr>
	<tr>
		<td>Passwort</td>
		<td><input type="password"name="password"></td>
	</tr>
	<tr>
		<td>Mandant</td>
		<td>
			<cfif session.admin EQ 1>
				<select name="mandantenid">
					<cfloop query="getAllMandanten">
						<option value="#id#">#directoryname#</option>
					</cfloop>
				</select>
			<cfelse>
				#getMandant.directoryname#
				<input type="hidden" name="mandantenid" value="#getMandant.id#" >
			</cfif>
		</td>
	</tr> 
	<tr>
		<td valign="top">
			Module
		</td>
		<td>
			<cfloop query="getModules">
				<input type="checkbox" name="mod" value="#id#" /> #module#<br/>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td valign="top">
			Rechtevergabe auf Modul-Ebene
		</td>
		<td>
			<cfloop query="getModules">
				<strong>#module#</strong><br/>
				<input type="checkbox" name="right_#id#" value="edit" /> Bearbeiten<br/>
				<input type="checkbox" name="right_#id#" value="del" /> Löschen<br/>
				<input type="checkbox" name="right_#id#" value="add" /> Erstellen<br/>
				<input type="checkbox" name="right_#id#" value="copy" /> Kopieren<br/>
			</cfloop>
		</td>
	</tr>
	<tr> <!---  per default wird Modul pagemanagement mitgegeben beim neuen user  --->
		<td><input type="hidden" name="mod" value="#1#" ></td>
		<td> <input type="submit" value="User erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.edituser")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addUser" id="addUser" > + neuer User erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn user bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.edituser") AND isNumeric(url.edituser) AND url.edituser GT 0>
<cfoutput query="editUser">
	<h3>User #name# bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedUser" method="post" id="add">
	<table width="70%">
	<tr>
		<td width="200">Vorname</td>
		<td><input type="text"name="vorname" value="#vorname#"></td>
	</tr>
	<tr>
		<td>Name</td>
		<td><input type="text"name="name" value="#name#"></td>
	</tr>
	<tr>
		<td>E-Mail</td>
		<td><input type="text"name="email" value="#email#"></td>
	</tr>
	<tr>
		<td>Passwort</td>
		<td><input type="password"name="password" value="#password#"></td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
      <cfif isactive EQ 0>  <td>Achtung: inaktive User können sich nicht einloggen!</td></cfif>
	</tr>
	<tr>
		<td>Mandant</td>
		<td>
			#editUser.mandant#
		</td>
	</tr> 
	<tr>
		<td valign="top">
			Module
		</td>
		<td>
			
			<!--- get mandant from userid --->
			<cfquery name="getMandantFromUseriD" datasource="#application.dsn#">
			SELECT	*
			FROM	user
			WHERE 	id = #url.edituser#
			</cfquery>
			
		
			
			<!--- alle module auslesen  --->
			<cfquery name="getModules" datasource="#application.dsn#">
			SELECT	*
			FROM	modules
			WHERE	id IN (SELECT moduleid FROM mandantenmodules WHERE mandantenid = #getMandantFromUseriD.mandant#)
			</cfquery>
		
		
			<cfloop query="getModules">
				<cfquery name="getModules2" datasource="#application.dsn#">
				SELECT	*
				FROM	usermodules
				WHERE	moduleid = #id# AND userid = #editUser.id#
				</cfquery>
				<input type="checkbox" name="mod" value="#id#" <cfif getModules2.recordcount EQ 1>checked="checked"</cfif> /> #module#<br/>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td valign="top">
			Rechtevergabe auf Modul-Ebene
		</td>
		<td>
			<cfloop query="getModules">
				<cfquery name="getUserRights" datasource="#application.dsn#">
				SELECT	*
				FROM	userrights
				WHERE	userid = #editUser.id# AND moduleid = #id#
				</cfquery>
				<strong>#module#</strong><br/>
				<input type="checkbox" name="right_#id#" value="edit" <cfif getUserRights.recordcount EQ 1 AND isdefined("getUserRights.editright") AND getUserRights.editright EQ 1>checked="checked"</cfif> /> Bearbeiten<br/>
				<input type="checkbox" name="right_#id#" value="del" <cfif getUserRights.recordcount EQ 1 AND isdefined("getUserRights.delright")  AND getUserRights.delright EQ 1>checked="checked"</cfif> /> Löschen<br/>
				<input type="checkbox" name="right_#id#" value="add" <cfif getUserRights.recordcount EQ 1 AND isdefined("getUserRights.addright")  AND getUserRights.addright EQ 1>checked="checked"</cfif> /> Erstellen<br/>
				<input type="checkbox" name="right_#id#" value="copy" <cfif getUserRights.recordcount EQ 1 AND isdefined("getUserRights.copyright")  AND getUserRights.copyright EQ 1>checked="checked"</cfif> /> Kopieren<br/>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td>
			<input type="hidden" name="userid" value="#editUser.id#">
		</td>
		<td><input type="submit" value="Änderungen speichern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>