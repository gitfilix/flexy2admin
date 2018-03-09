<cfoutput><form action="#cgi.SCRIPT_NAME#?action=submittedNewUser" method="post">
	<table width="100%">
	<tr>
		<td>
			Name
		</td>
		<td>
			<input type="text" name="name" <cfif isdefined("form.name") AND form.name NEQ "">value="#form.name#"></cfif>>
		</td>
	</tr>
	<tr>
		<td>
			Vorname
		</td>
		<td>
			<input type="text" name="vorname" <cfif isdefined("form.vorname") AND form.vorname NEQ "">value="#form.vorname#"></cfif>>
		</td>
	</tr>
	<tr>
		<td>
			Tel.
		</td>
		<td>
			<input type="text" name="tel" <cfif isdefined("form.tel") AND form.tel NEQ "">value="#form.tel#"></cfif>>
		</td>
	</tr>
	<tr>
		<td>
			E-Mail (= Benutzername)
		</td>
		<td>
			<input type="text" name="email" <cfif isdefined("form.email") AND form.email NEQ "">value="#form.email#"></cfif>>
		</td>
	</tr>
	<tr>
		<td>
			Passwort
		</td>
		<td>
			<input type="password" name="password" <cfif isdefined("form.password") AND form.password NEQ "">value="#form.password#"></cfif>>
		</td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="state" value="1"  <cfif isdefined("form.state") AND form.state EQ 1>checked="checked"<cfelseif not isdefined("form.state")>checked="checked"</cfif> /> aktiv&nbsp;&nbsp;
			<input type="radio" name="state" value="0" <cfif isdefined("form.state") AND form.state EQ 0>checked="checked"</cfif> /> inaktiv
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="Benutzer speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			<input type="hidden" name="usergroupid" value="#url.usergroupid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>