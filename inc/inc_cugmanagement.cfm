<cfprocessingdirective pageencoding="utf-8" />

<!--- gleiches stylesheet wie pabgemanagement  --->
<link  rel="stylesheet" type="text/css" href="/admin/css/pagemanagement.css"  >


<!--- 
<cfdump var="#session.rechte.module#"> --->
<style>
 
/* colors für status*/
#activ{
	color:#3F3;
	}

#inactiv{
	color:#9FF;
	}
	
/*:nth-child(2n){*/

table tr,table tr table tr{
	background:#949494;
	}
	
table td{
	vertical-align:top;
	padding:5px 5px;
	}
	
table td:first-child{
	padding-top:8px;
	}
	
table tr:nth-child(2n+1),table tr:nth-child(2n+1) table tr{
	background:#B2B2B2;
	}	
	
#gray1{
	color:#039;
	letter-spacing:2px;
	background:#9A9A9A;
	}

#gray2{
	color:#039;
	letter-spacing:2px;
	background:#B2B2B2;
	}

#gray3{
	color:#039;
	letter-spacing:2px;
	background:#D6D6D6;
	}	
	
input[type=text],input[type=file],input[type=password],textarea,select{
	width:98%;
	border:1px solid silver;
	padding:2px;	
	font-family:Tahoma, Geneva, sans-serif;
	font-size:13px;
}

select{
	width:99%;
}
</style>


<!--- rechte für dieses modul: --->
<cfloop array="#session.rechte.module#" index="i">
	<cfif i.id EQ session.moduleid>
		<cfset rightEdit = i.edit />
		<cfset rightDel = i.del />
		<cfset rightAdd = i.add />
		<cfset rightCopy = i.copy />
		<cfbreak>
	</cfif>
</cfloop>
<cfif arrayLen(session.rechte.module) EQ 0>
	<cfset rightEdit = 0 />
	<cfset rightDel = 0 />
	<cfset rightAdd = 0 />
	<cfset rightCopy = 0 />
</cfif>

<!--- -------------- form prozessors ------------------ --->


<!--- alle userGroups auslesen --->
<cfquery name="getUserGroups" datasource="#application.dsn#">
SELECT	*
FROM	cugGroups
WHERE	mandant = #session.mandant#
</cfquery>

<!--- gruppe löschen --->
<cfif isdefined("url.delUserGroup") AND isNumeric(url.delUserGroup) AND url.delUserGroup GT 0>
	<cfquery name="delUserGroup" datasource="#application.dsn#">
	DELETE
	FROM	cugGroups
	WHERE	id = #url.delUserGroup#
	</cfquery>
	<!--- alle user des userGroups ebenfalls aus DB löschen --->
	<cfquery name="deleteImages" datasource="#application.dsn#">
	DELETE
	FROM	cugUsers
	WHERE	groupID = #url.delUserGroup#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- I STRUKTUR   1. Neue gruppe hinzufügen --->
<!--- ------------------------------------ --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewUserGroup">
		<cfquery name="insertGroup" datasource="#application.dsn#">
		INSERT	
		INTO	cugGroups(
				groupName,
				groupStatus,
				mandant
		)
		VALUES(
			'#form.usergroupname#',
			#form.state#,
			#session.mandant#
		)
		</cfquery>	
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	</cfif>

<!--- 2. bestehende gruppe updaten --->
<!--- -------------------------- --->

<!--- Modul submittedEditedUserGroup --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedUserGroup">

		<cfquery name="updateGroup" datasource="#application.dsn#">
		UPDATE	cugGroups
		SET		groupName = '#form.usergroupname#',
				groupStatus = #form.state#
		WHERE	id = #form.userGroupID#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no"> 
</cfif>

<!--- zu bearbeitende gruppe aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editUserGroup") AND isNumeric(url.editUserGroup) AND url.editUserGroup GT 0>
	<cfquery name="editUserGroup" datasource="#application.dsn#">
	SELECT	*
	FROM	cugGroups
	WHERE	id = #url.editUserGroup# AND
			mandant = #session.mandant#
	</cfquery>
</cfif>

<!---user der userGroups speichern --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewUser">

	<cfquery name="insertUser" datasource="#application.dsn#">
		INSERT 	INTO cugUsers(
				username,
				uservorname,
				tel,
				email,
				PASSWORD,
				isActive,
				groupId 
				)
		VALUES(
				'#form.name#',
				'#form.vorname#',
				'#form.tel#',
				'#form.email#',
				'#form.password#',
				#form.state#,
				#form.usergroupid#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>


<!---II user der userGroups ändern / updaten --->
<!--- ----------------------------------- --->

<cfif isdefined("url.action") AND url.action EQ "submittedEditedUser">
	
	<cfquery name="updateUser" datasource="#application.dsn#">
		UPDATE	cugUsers
		SET		userName = '#form.name#',
				uservorname = '#form.vorname#',
				tel = '#form.tel#',
				email = '#form.email#',
				password = '#form.password#',
				isActive = #form.state#
		WHERE	id = #form.userid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- User löschen --->
<cfif isdefined("url.delUser") AND isNumeric(url.delUser) AND url.delUser GT 0>
	<cfquery name="delUser" datasource="#application.dsn#">
	DELETE
	FROM	cugUsers
	WHERE	id = #url.delUser#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Alben darstellen mit eingerückten kindern --->
<cfif not isdefined("url.editUserGroup") AND not isdefined("url.editUser")>
<table width="100%">
<tr>
	<td id="gray1"><h4>Benutzergruppe</h4></td>
	
	<td colspan="2" id="gray2"><h4>Bearbeiten</h4></td>
	
	<td id="gray3"> <h4>Benutzer</h4></td>
	
</tr>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Bearbeiten</strong></td>
	<td><strong>Löschen</strong></td>
	<td><strong>bearbeiten</strong></td>
</tr>
<cfset userGroupIDx = 0 />
<cfoutput query="getUserGroups">
<cfset userGroupIDx = getUserGroups.id />
<cfquery name="getUsersByUserGroupID" datasource="#application.dsn#">
SELECT	*
FROM	cugUsers
WHERE	groupID = #userGroupIDx#
</cfquery>
<tr>
	<td>#groupName#</td>
	<td>
		<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?editUserGroup=#userGroupIDx#">
				bearbeiten
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delUserGroup=#userGroupIDx#" onclick="return confirm('Sind Sie sicher?\nEs werden alle Bilder des Albums ebenfalls gelöscht');">
				löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif getUsersByUserGroupID.recordcount GT 0>
		<a href="javascript:$('##user#userGroupIDx#').toggle();void(0);">
			Benutzer
		</a>
		</cfif>&nbsp;
		<cfif rightAdd EQ 1>
			<a href="#cgi.SCRIPT_NAME#?action=addUser&userGroupID=#userGroupIDx#">
				Benutzer +
			</a>
		</cfif>	
	</td>
</tr>
<cfif getUsersByUserGroupID.recordcount GT 0>
<tr>
	<td colspan="7">
		<div style="display:none;background-color:##e1e1e1;" id="user#userGroupIDx#">
			<table cellspacing="0" cellpadding="0" width="100%">
			<cfloop query="getUsersByUserGroupID">
			<tr>
				<td><strong><cfif username NEQ "">#username#, #uservorname#<cfelse>[kein Titel]</cfif></strong><br/>#tel#</td>
				
				<td>
					<cfif rightDel EQ 1>
						<a href="#cgi.SCRIPT_NAME#?delUser=#id#" onclick="return confirm('Sind Sie sicher?');">
							löschen
						</a>
					</cfif>
				</td>
				<td>
					<cfif rightEdit EQ 1>
						<a href="#cgi.SCRIPT_NAME#?editUser=#id#&userGroupID=#userGroupIDx#">
							bearbeiten
						</a>
					</cfif>
				</td>
			</tr>
			</cfloop>
			</table>
		</div>
	</td>
</tr>
</cfif>
</cfoutput>
</table>
</cfif>
<!--- dies erscheint nur wenn neue gruppe hinzufügen gewählt wurde --->
<cfoutput>
<cfif isdefined("url.action") AND url.action EQ "addUserGroup">
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewUserGroup" method="post" enctype="multipart/form-data">
	<table cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td>Benutzergruppe</td>
		<td><input type="text" name="usergroupname" <cfif isdefined("form.usergroupname")>value="#form.usergroupname#"</cfif>></td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="state" value="1"  <cfif isdefined("form.state") AND form.state EQ 1>checked="checked"<cfelseif not isdefined("form.state")>checked="checked"</cfif> /> aktiv&nbsp;&nbsp;
			<input type="radio" name="state" value="0" <cfif isdefined("form.state") AND form.state EQ 0>checked="checked"</cfif> /> inaktiv
		</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Benutzergruppe erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editUserGroup")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addUserGroup">neue Benutzergruppe erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn Album bearbeiten gewählt wurde --->
<cfif isdefined("url.editUserGroup") AND isNumeric(url.editUserGroup) AND url.editUserGroup GT 0>
<cfoutput query="editUserGroup">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedUserGroup" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Benutzergruppe</td>
		<td><input type="text" name="usergroupname" value="#groupName#"></td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="state" value="1" <cfif groupStatus EQ 1>checked="checked"</cfif> /> aktiv&nbsp;&nbsp;
			<input type="radio" name="state" value="0" <cfif groupStatus EQ 0>checked="checked"</cfif> /> inaktiv
		</td>
	</tr>
	<tr>
		<td><input type="hidden" name="userGroupID" value="#id#"></td>
		<td><input type="submit" value="Benutzergruppe ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>


<br><br>
<cfif isdefined("url.action") AND url.action EQ "addUser">
	<cfinclude template="inc_addUser.cfm" />
</cfif>

<cfif isdefined("url.editUser") AND isNumeric(url.editUser) AND url.editUser GT 0>
	<cfinclude template="inc_editUser.cfm" />
</cfif>

