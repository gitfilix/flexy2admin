<cfprocessingdirective pageencoding="utf-8" />

<cfoutput>
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewMagazineChapter" method="post" enctype="multipart/form-data">
		<table width="100%">
		<tr>
			<td>
				Kapitel
			</td>
			<td>
				<input type="text" name="kapitel" />
			</td>
		</tr>
		<tr>
			<td>
				Richtung
			</td>
			<td>
				<input type="radio" name="dir" id="dir1" value="0" checked> horizontal<br/>
				<input type="radio" name="dir" id="dir2" value="1"> vertikal<br/>
			</td>
		</tr>
		<tr>
			<td colspan="6">
				<input type="hidden" name="magazinEditionID" value="#url.magazinAusgabe#" />
				<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			</td>
		</tr>
		</table>
	</form>
</cfoutput>