<cfprocessingdirective pageencoding="utf-8" />


<cfoutput>
<form action="#cgi.SCRIPT_NAME#?action=submittedNewMagazinePage" method="post" enctype="multipart/form-data">
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
		<td colspan="6">
			<input type="hidden" name="magazinChapterID" value="#url.magazineChapter#" />
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
</form>
</cfoutput>