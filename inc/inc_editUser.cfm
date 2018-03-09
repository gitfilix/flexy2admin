<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getUserByID" datasource="#application.dsn#">
SELECT	*
FROM	cugUsers
WHERE	id = #url.editUser#
</cfquery>

<cfoutput query="getUserByID">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedUser" method="post">
	<table width="100%">
	<tr>
		<td>
			Name
		</td>
		<td>
			<input type="text" name="name" value="#username#">
		</td>
	</tr>
	<tr>
		<td>
			Vorname
		</td>
		<td>
			<input type="text" name="vorname" value="#uservorname#">
		</td>
	</tr>
	<tr>
		<td>
			Tel.
		</td>
		<td>
			<input type="text" name="tel" value="#tel#">
		</td>
	</tr>
	<tr>
		<td>
			E-Mail (= Benutzername)
		</td>
		<td>
			<input type="text" name="email" value="#email#">
		</td>
	</tr>
	<tr>
		<td>
			Passwort
		</td>
		<td>
			<input type="password" name="password" value="#password#">
		</td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="state" value="1"  <cfif isActive EQ 1>checked="checked"</cfif> /> aktiv&nbsp;&nbsp;
			<input type="radio" name="state" value="0" <cfif isActive EQ 0>checked="checked"</cfif> /> inaktiv
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="Benutzer ändern" /> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			<input type="hidden" name="userid" value="#url.editUser#" />
			<input type="hidden" name="userGroupId" value="#url.usergroupid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>