<cfprocessingdirective pageencoding="utf-8" />
<div style="width:600px;margin:0 auto;">
<!---wenn username und pw defined ist, und sessionvariable false ist -> fehlermeldung werfen--->
<cfif isdefined("form.username") AND isdefined("form.password") AND session.loggedIn EQ false>
	Versuch fehlgeschlagen. versuchen Sie es erneut.
</cfif>

<cfif wartungscheck.maintainance EQ 1 AND NOT isdefined("url.admin")>
	<div style="background-color:red;color:white;font-weight:bold;padding:1.5em;width:50%;margin-bottom:1.5em;">
		Im Moment sind Wartungsarbeiten im Gange.<br/>Login leider nicht möglich!
	</div>
<cfelseif (wartungscheck.maintainance EQ 1 AND isdefined("url.admin")) OR wartungscheck.maintainance EQ 0>
	<!---login -form:--->
	<cfoutput>
	<div id="login-table" class="login-screen">
		<form action="#cgi.SCRIPT_NAME#<cfif isdefined('url.admin')>?admin</cfif>" method="post">
		<table>
			<thead><h2>Backend-Login</h2></thead>
		<tr>
			<td>Username</td>
			<td><input type="text"name="username"></td> 
		</tr> 
		<tr>
			<td>Passwort</td>
			<td><input type="password"name="password"></td>
		</tr>
		<tr>
			<td></td>
			<td><input class="login-btn" type="submit" value="Start"></td>
		</tr>
		</table>
		</form>
	</div>
	</cfoutput>
</cfif>
</div>
