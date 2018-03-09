<cfoutput>
<form action="#cgi.SCRIPT_NAME#?action=submittedNewMagazine" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>
			Titel
		</td>
		<td>
			<input type="text" name="titel" />
		</td>
	</tr>
	<tr>
		<td>
			Status
		</td>
		<td>
			<input type="radio" name="isActive" value="1" checked="checked" /> aktiv 
			<input type="radio" name="isActive" value="0" /> inaktiv 
		</td>
	</tr>
	<tr>
		<td>
			Public?
		</td>
		<td>
			<input type="radio" name="isPublic" value="1" /> Ja 
			<input type="radio" name="isPublic" value="0" checked="checked" /> Nein 
		</td>
	</tr>
	<tr>
		<td>
			Bezahlt?
		</td>
		<td>
			<input type="radio" name="paid" value="1" /> Ja 
			<input type="radio" name="paid" value="0" checked="checked" /> Nein 
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
</form>
</cfoutput>