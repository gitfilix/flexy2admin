<cfprocessingdirective pageencoding="utf-8" />


<script>

</script>

<!---slides label and slide template chooser--->
<cfoutput>
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewMagazineSlide" method="post" enctype="multipart/form-data">
		<table width="100%">
		<tr>
			<td>Label*</td>
			<td>
				<input type="text" name="label" id="label" />
			</td>
		</tr>
		<tr>
			<td>Template*</td>
			<td>
				<select name="template">
					<option value="0">-- Bitte wählen --</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Hintergrund-Bild</td>
			<td>
				<input type="file" name="bgimage" />
			</td>
		</tr>
		<tr>
			<td>Hintergrund-Farbe</td>
			<td>
				<input type="text" name="bgcolor" id="bgcolor" />
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input type="hidden" name="chapterID" value="#url.magazineChapter#" />
				<input type="submit" value="Slide erstellen" />
			</td>
		</tr>
		</table>
	</form>
</cfoutput>