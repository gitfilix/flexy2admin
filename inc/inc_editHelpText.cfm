
	
<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getHelpTextByID" datasource="#application.dsn#">
SELECT	*
FROM	helptext
WHERE	id = #url.editHelpText#
</cfquery>

<cfoutput query="getHelpTextByID">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedHelpText" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>
			Variable
		</td>
		<td>
			<input type="text" name="variable" value="#variable#">
		</td>
	</tr>
	<tr>
		<td>
			Hilfe-Text
		</td>
		<td>
			<textarea name="helpText"  class="ckeditor" id="helpText" cols="1" rows="1" style="width:100%;height:50px;">#helpText#</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" /> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			<input type="hidden" name="helpTextID" value="#url.editHelpText#" />
			<input type="hidden" name="moduleid" value="#helpTextModulID#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>