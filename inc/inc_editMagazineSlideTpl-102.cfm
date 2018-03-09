<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getslideTpl102" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_102
WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl102">
	<table width="100%">
	<tr>
		<td>
			Titel:
		</td>
		<td>
			<input type="text" name="titel" id="titel" value="#titel#" />
		</td>
	</tr>
	<tr>
		<td>
			Anriss:
		</td>
		<td>
			<textarea name="lead" id="lead" rows="0" cols="0">#lead#</textarea>
			<script>
				CKEDITOR.replace('lead');
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Text:
		</td>
		<td>
			<textarea name="text" id="text" rows="0" cols="0">#text#</textarea>
			<script>
				CKEDITOR.replace('text');
			</script>
		</td>
	</tr>
	<tr>
		<td>
			Layout:
		</td>
		<td>
			<select name="layout">
				<option value="1">big lead- little text</option>
				<option value="2">small lead- more text</option>
				<option value="3">small lead- little text </option>
			</select>
		</td>
	</tr>
	</table>
</cfoutput>