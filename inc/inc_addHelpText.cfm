<cfoutput><form action="#cgi.SCRIPT_NAME#?action=submittedNewHilfeText" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>
			Variable
		</td>
		<td>
			<input type="text" name="variable">
		</td>
	</tr>
	<tr>
		<td>
			Hilfe-Text
		</td>
		<td>
			<textarea name="helpText"  class="ckeditor" id="helpText" cols="1" rows="1" style="width:100%;height:500px;"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			<input type="hidden" name="moduleid" value="#url.moduleid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>