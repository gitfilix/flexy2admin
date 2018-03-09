<cfprocessingdirective pageencoding="utf-8" />

<cfoutput query="editMagazineEdition">
<form action="#cgi.SCRIPT_NAME#?action=submittedEditedMagazineEdition" method="post" enctype="multipart/form-data">
	
	
	<script>
		$(function() {
			$( "##datepicker" ).datepicker({
				altField: "##releasedate",
				altFormat: "yy-mm-dd",
				dateFormat : 'yy-mm-dd',
				defaultDate: "#dateFormat(releasedate,'yyyy-mm-dd')#"
			});
		});
	</script>
	
	<table width="100%">
	<tr>
		<td>
			Ausgabe
		</td>
		<td>
			<input type="text" name="ausgabe" value="#ausgabe#" />
		</td>
	</tr>
	<tr>
		<td>
			Status
		</td>
		<td>
			<input type="radio" name="isActive" value="1" <cfif isActive EQ 1>checked="checked"</cfif> /> ja 
			<input type="radio" name="isActive" value="0" <cfif isActive EQ 0>checked="checked"</cfif> /> nein
		</td>
	</tr>
	<tr>
		<td>
			Veröffentlichungsdatum
		</td>
		<td>
			<div id="datepicker"></div>
			<input type="hidden" name="releasedate" id="releasedate" value="#releasedate#" />
		</td>
	</tr>
	<tr>
		<td>
			Publizieren?
		</td>
		<td>
			<input type="radio" name="publishState" value="1" <cfif publishState EQ 1>checked="checked"</cfif> /> ja 
			 <cfif publishState EQ 0><input type="radio" name="publishState" value="0" <cfif publishState EQ 0>checked="checked"</cfif> /> nein</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Orientation
		</td>
		<td>
			<cfif orientation EQ 1>Hoch<cfelseif orientation EQ 0>Quer</cfif> (kann nicht geändert werden)
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="hidden" name="magazinID" value="#url.editMagazineEdition#" />
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
</form>
</cfoutput>