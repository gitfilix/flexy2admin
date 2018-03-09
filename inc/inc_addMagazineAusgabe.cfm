<cfprocessingdirective pageencoding="utf-8" />

<cfoutput>
<form action="#cgi.SCRIPT_NAME#?action=submittedNewMagazineEdition" method="post" enctype="multipart/form-data">
	
	<script>
		$(function() {
			$( "##datepicker" ).datepicker({
				altField: "##releasedate",
				altFormat: "yy-mm-dd"	
			});
		});
	</script>
	
	<table width="100%">
	<tr>
		<td>
			Ausgabe
		</td>
		<td>
			<input type="text" name="ausgabe" />
		</td>
	</tr>
	<tr>
		<td>
			Status
		</td>
		<td>
			<input type="radio" name="isActive" value="1" checked="checked" /> ja 
			<input type="radio" name="isActive" value="0" /> nein
		</td>
	</tr>
	<tr>
		<td>
			Veröffentlichungsdatum
		</td>
		<td>
			<div id="datepicker"></div>
			<input type="hidden" name="releasedate" id="releasedate" />
		</td>
	</tr>
	<tr>
		<td>
			Orientation
		</td>
		<td>
			<input type="radio" name="orientation" value="1" checked="checked" /> Hoch 
			<input type="radio" name="orientation" value="0" /> Quer 
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="hidden" name="magazinID" value="#url.magazin#" />
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
</form>
</cfoutput>