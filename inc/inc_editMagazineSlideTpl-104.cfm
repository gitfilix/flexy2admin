<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getslideTpl103" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_104
WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl104">
	<table width="100%">
	<tr>
		<td>
			HTML:
		</td>
		<td>
			<textarea name="lead" id="lead" rows="0" cols="0">#lead#</textarea>
			<script>
				CKEDITOR.replace('lead',{
					toolbar : [
						[ 'Source', 'Paste', 'PasteFromWord', 'Undo', 'Bold', 'Italic', 'Underline', 'Link', 'Unlink', 'Image', 'Table', 'HorizontalRule', 'Iframe', 'Styles', 'Font', 'FontSize', 'TextColor', 'BGColor', 'Maximize',  ]
					]
				});
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Layout:
		</td>
		<td>
			<select name="layout">
				<option value="1">Variante 1</option>
				<option value="2">zwöi</option>
				<option value="3">Variante 3</option>
			</select>
		</td>
	</tr>
	</table>
</cfoutput>