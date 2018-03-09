<cfoutput><form action="#cgi.SCRIPT_NAME#?action=submittedNewImage" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Bild</td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr>
	<tr>
		<td>
			Titel
		</td>
		<td>
			<input type="text" name="titel">
		</td>
	</tr>
	<tr>
		<td>
			Reihenfolge
		</td>
		<td>
			<input type="text" name="reihenfolge">
		</td>
	</tr>
	<tr>
		<td>
			Legende
		</td>
		<td>
<textarea name="lead" cols="1" rows="1" style="width:100%;height:65px;"></textarea>
		</td>
	</tr>
	<tr>
		<td>
			Fotograf
		</td>
		<td>
			<input type="text" name="owner">
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			<input type="hidden" name="albumid" value="#url.albumid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>