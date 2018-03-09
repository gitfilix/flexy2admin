<cfprocessingdirective pageencoding="utf-8" />

<!--- form processor UPDATE slide Template 2 --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedMagazineSlide">

	<!--- upload bgimage --->
	<cfset bg = form.origbg />
	<cfif isdefined("form.bgimage") AND form.bgimage NEQ "">
		<cffile action="upload" filefield="bgimage" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset bg = cffile.serverfile />
	</cfif>
	
	<cfquery name="updateMagazineSlide" datasource="#application.dsn#">
	UPDATE	magazinslides
	SET		label = '#form.label#',
			bgimage = '#bg#'
	WHERE	id = #form.slideID#
	</cfquery>
	
	<!--- upload image --->
	<cfset bildx = form.origbild />
	<cfif isdefined("form.bild") AND form.bild NEQ "">
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset bildx = cffile.serverfile />
	</cfif>
	
	<!--- update template 100 --->
	<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
	UPDATE	magazinslidetpl_#form.template#
	SET		titel = '#form.titel#',
			lead = '#form.lead#',
			bild = '#bildx#',
			bildlegende = '#form.caption#',
			ytvideo = '#form.ytcode#'   
	WHERE	slideid = #form.slideID#
	</cfquery>
	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!---END  form processor UPDATE slide Template 2 --->

<cfquery name="getslideTpl100" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_100
WHERE slideID = #url.editMagazinSlide#
</cfquery>


<cfquery name="getAlbums" datasource="#application.dsn#">
SELECT	*
FROM	albums
WHERE	mandant = #session.mandant#
</cfquery>



<cfoutput query="getslideTpl100">
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
			Text:
		</td>
		<td>
			<textarea name="text" id="text" rows="0" cols="0">#text#</textarea>
			<script>
				CKEDITOR.replace('text',{
					toolbar : [
						[ 'Source', 'Paste', 'PasteFromWord', 'Undo', 'Bold', 'Italic', 'Underline', 'Link', 'Unlink', 'Image', 'Table', 'HorizontalRule', 'Iframe', 'Styles', 'Font', 'FontSize', 'TextColor', 'BGColor', 'Maximize',  ]
					]
				});
			</script>
		</td>
	</tr>
	<tr>
		<td coslpan="2"><strong>Lightbox</strong></td>
	</tr>
	<tr>
		<td>
			Titel:
		</td>
		<td>
			<input type="text" name="lb_titel" id="lb_titel" value="#lb_titel#" />
		</td>
	</tr>
	<tr>
		<td>
			Text:
		</td>
		<td>
			<textarea name="lb_text" id="lb_text" rows="0" cols="0">#lb_text#</textarea>
			<script>
				CKEDITOR.replace('lb_text');
			</script>
		</td>
	</tr>
	<tr>
		<td>
			Bild:
		</td>
		<td>
			<input type="file" name="lb_bild" id="lb_bild" />
			<input type="hidden" name="origbild" id="origbild" value="#lb_bild#" />
			<cfif lb_bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#lb_bild#')>
				<img src="/#session.serverpath#/upload/magazine/#lb_bild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Bild Legende:
		</td>
		<td>
			<input type="text" name="lb_bildcaption" id="lb_bildcaption" value="#lb_bildcaption#" />
		</td>
	</tr>
	<tr>
		<td>
			Layout Typ:
		</td>
		<td>
			<select name="layout">
				<option value="1">Very big short Title - little text</option>
				<option value="2">Long Title - more text</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>Galrier</td>
		<td>
			<select name="album" id="album">
				<option value="0" selected="selected">-- bitte wählen --</option>
				<cfloop query="getAlbums">
					<option value="#id#">#albumTitle#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	</table>
</cfoutput>