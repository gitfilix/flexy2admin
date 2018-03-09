<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getSlideBackgroundImage" datasource="#application.dsn#">
SELECT bgimage FROM magazinSlides
WHERE id = #url.editMagazinSlide#
</cfquery>

<cfquery name="getSlideContent" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_7
WHERE slideid = #url.editMagazinSlide#
</cfquery>

<cfquery name="getAlbums" datasource="#application.dsn#">
SELECT	*
FROM	albums
WHERE	mandant = #session.mandant#
</cfquery>

 <cfoutput>
	<table width="100%">
	<tr>
		<td>
			Layout
		</td>
		<td>
			<select name="setting_layout">
				<option value="0" <cfif getSlideContent.setting_layout EQ 0>selected</cfif>>Bild schmal Links</option>
				<option value="1" <cfif getSlideContent.setting_layout EQ 1>selected</cfif>>Bild breit Links</option>
				<option value="2" <cfif getSlideContent.setting_layout EQ 2>selected</cfif>>Bild oben</option>
				<option value="3" <cfif getSlideContent.setting_layout EQ 3>selected</cfif>>Bild schmal Rechts</option>
				<option value="4" <cfif getSlideContent.setting_layout EQ 4>selected</cfif>>Bild breit Rechts</option>
				<option value="5" <cfif getSlideContent.setting_layout EQ 5>selected</cfif>>Bild unten</option>
				<option value="6" <cfif getSlideContent.setting_layout EQ 6>selected</cfif>>Fullscreen Artikel ohne Bild</option>
				<option value="7" <cfif getSlideContent.setting_layout EQ 7>selected</cfif>>Fullscreen Artikel zentriert</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			Thematischer Titel
		</td>
		<td>
			<input type="text" name="titel_1" id="titel_1" value="#getSlideContent.titel_1#" />
			<table width="100%">
			<tr>
				<td>
					Textfarbe
				</td>
				<td>
					<input type="text" name="setting_titlecolor" id="setting_titlecolor" value="#getSlideContent.setting_titlecolor#" />
				</td>
				<td>
					Animation
				</td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="padding-top:0;">
							<input type="text" name="setting_titleanimation_delay" id="setting_titleanimation_delay" value="#getSlideContent.setting_titleanimation_delay#" style="width:40px;" />
						</td>
						<td style="padding-top:0;">
							<select name="setting_titleanimation">
								<option value="0" <cfif getSlideContent.setting_titleanimation EQ 0>selected</cfif>>keine</option>
								<option value="1" <cfif getSlideContent.setting_titleanimation EQ 1>selected</cfif>>fadeIn</option>
								<option value="2" <cfif getSlideContent.setting_titleanimation EQ 2>selected</cfif>>slideInLeft</option>
								<option value="3" <cfif getSlideContent.setting_titleanimation EQ 3>selected</cfif>>slideInRight</option>
								<option value="4" <cfif getSlideContent.setting_titleanimation EQ 4>selected</cfif>>slideInTop</option>
								<option value="5" <cfif getSlideContent.setting_titleanimation EQ 5>selected</cfif>>slideInBottom</option>
								<option value="6" <cfif getSlideContent.setting_titleanimation EQ 6>selected</cfif>>scaleTextUp</option>
							</select>
						</td>
						<td style="padding-top:0;">
							<input type="text" name="setting_titleanimation_duration" id="setting_titleanimation_duration" value="#getSlideContent.setting_titleanimation_duration#" style="width:40px;" />
						</td>
					</tr>
					</table>
					
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Kommunikativer Titel
		</td>
		<td>
			<input type="text" name="titel_2" id="titel_2" value="#getSlideContent.titel_2#" /><br/>
			Fette Headline (experimental):<br/>
			<input type="radio" name="bigtext" id="bilgtext1" value="0" <cfif getSlideContent.setting_bigtext EQ 0>checked</cfif> /> Nein<br/>
			<input type="radio" name="bigtext" id="bilgtext2" value="1" <cfif getSlideContent.setting_bigtext EQ 1>checked</cfif> /> Ja<br/>
		</td>
	</tr>
	<tr>
		<td>
			Artikel Bild
		</td>
		<td>
			<input type="file" name="bild1" id="bild1" />
			<input type="hidden" name="origbild1" id="origbild1" value="#getSlideContent.bild#" />
			<cfif getSlideContent.bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#getSlideContent.bild#')>
				<img src="/#session.serverpath#/upload/magazine/#getSlideContent.bild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Artikel Bildlegende
		</td>
		<td>
			<textarea name="bild_legenede" id="bild_legenede" rows="0" cols="0">#getSlideContent.bild_legenede#</textarea>
			<script>
				CKEDITOR.replace('bild_legenede');
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Artikel Bild-Quelle / Autor
		</td>
		<td>
			<input type="text" name="bild_quelle" id="bild_quelle" value="#getSlideContent.bild_quelle#" />
		</td>
	</tr>
	<tr>
		<td>
			Artikel Bild-Animation
		</td>
		<td>
			<select name="setting_bildanim">
				<option value="0" <cfif getSlideContent.setting_bildanim EQ 0>selected</cfif>>keine</option>
				<option value="1" <cfif getSlideContent.setting_bildanim EQ 1>selected</cfif>>links/rechts</option>
				<option value="2" <cfif getSlideContent.setting_bildanim EQ 2>selected</cfif>>rechts/links</option>
				<option value="3" <cfif getSlideContent.setting_bildanim EQ 3>selected</cfif>>oben/unten</option>
				<option value="4" <cfif getSlideContent.setting_bildanim EQ 4>selected</cfif>>unten/oben</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			Anriss
		</td>
		<td>
			<textarea name="anriss" id="anriss" rows="0" cols="0">#getSlideContent.anriss#</textarea>
			<script>
				CKEDITOR.replace('anriss');
			</script>
			<table width="100%">
			<tr>
				<td>
					Anrissfarbe
				</td>
				<td>
					<input type="text" name="setting_leadcolor" id="setting_leadcolor" value="#getSlideContent.setting_leadcolor#" />
				</td>
				<td>
					Animation
				</td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="padding-top:0;">
							<input type="text" name="setting_leadanimation_delay" id="setting_leadanimation_delay" value="#getSlideContent.setting_leadanimation_delay#" style="width:40px;" />
						</td>
						<td style="padding-top:0;">
							<select name="setting_leadanimation">
								<option value="0" <cfif getSlideContent.setting_leadanimation EQ 0>selected</cfif>>keine</option>
								<option value="1" <cfif getSlideContent.setting_leadanimation EQ 1>selected</cfif>>fadeIn</option>
								<option value="2" <cfif getSlideContent.setting_leadanimation EQ 2>selected</cfif>>slideInLeft</option>
								<option value="3" <cfif getSlideContent.setting_leadanimation EQ 3>selected</cfif>>slideInRight</option>
								<option value="4" <cfif getSlideContent.setting_leadanimation EQ 4>selected</cfif>>slideInTop</option>
								<option value="5" <cfif getSlideContent.setting_leadanimation EQ 5>selected</cfif>>slideInBottom</option>
								<option value="6" <cfif getSlideContent.setting_leadanimation EQ 6>selected</cfif>>scaleTextUp</option>
							</select>
						</td>
						<td style="padding-top:0;">
							<input type="text" name="setting_leadanimation_duration" id="setting_leadanimation_duration" value="#getSlideContent.setting_leadanimation_duration#" style="width:40px;" />
						</td>
					</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr> 
	<tr>
		<td>
			Text Abschnitt 1
		</td>
		<td>
			<textarea name="textabschnitt_1" id="textabschnitt_1" rows="0" cols="0">#getSlideContent.textabschnitt_1#</textarea>
			<script>
				CKEDITOR.replace('textabschnitt_1');
			</script>
			<table width="100%">
			<tr>
				<td>
					Textfarbe
				</td>
				<td>
					<input type="text" name="setting_textcolor" id="setting_textcolor" value="#getSlideContent.setting_textcolor#" />
				</td>
				<td>
					Animation
				</td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="padding-top:0;">
							<input type="text" name="setting_textanimation_delay" id="setting_textanimation_delay" value="#getSlideContent.setting_textanimation_delay#" style="width:40px;" />
						</td>
						<td style="padding-top:0;">
							<select name="setting_textanimation">
								<option value="0" <cfif getSlideContent.setting_textanimation EQ 0>selected</cfif>>keine</option>
								<option value="1" <cfif getSlideContent.setting_textanimation EQ 1>selected</cfif>>fadeIn</option>
								<option value="2" <cfif getSlideContent.setting_textanimation EQ 2>selected</cfif>>slideInLeft</option>
								<option value="3" <cfif getSlideContent.setting_textanimation EQ 3>selected</cfif>>slideInRight</option>
								<option value="4" <cfif getSlideContent.setting_textanimation EQ 4>selected</cfif>>slideInTop</option>
								<option value="5" <cfif getSlideContent.setting_textanimation EQ 5>selected</cfif>>slideInBottom</option>
								<option value="6" <cfif getSlideContent.setting_textanimation EQ 6>selected</cfif>>scaleTextUp</option>
							</select>
						</td>
						<td style="padding-top:0;">
							<input type="text" name="setting_textanimation_duration" id="setting_textanimation_duration" value="#getSlideContent.setting_textanimation_duration#" style="width:40px;" />
						</td>
					</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr> 
	<tr>
		<td>
			Text Abschnitt 2 Bild:
		</td>
		<td>
			<input type="file" name="textabschnitt_2_bild" id="textabschnitt_2_bild" />
			<input type="hidden" name="origbild2" id="origbild2" value="#getSlideContent.textabschnitt_2_bild#" />
			<cfif getSlideContent.textabschnitt_2_bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#getSlideContent.textabschnitt_2_bild#')>
				<img src="/#session.serverpath#/upload/magazine/#getSlideContent.textabschnitt_2_bild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Text Abschnitt 2
		</td>
		<td>
			<textarea name="textabschnitt_2" id="textabschnitt_2" rows="0" cols="0">#getSlideContent.textabschnitt_2#</textarea>
			<script>
				CKEDITOR.replace('textabschnitt_2');
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Text Abschnitt 3 Bild:
		</td>
		<td>
			<input type="file" name="textabschnitt_3_bild" id="textabschnitt_3_bild" />
			<input type="hidden" name="origbild3" id="origbild3" value="#getSlideContent.textabschnitt_3_bild#" />
			<cfif getSlideContent.textabschnitt_3_bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#getSlideContent.textabschnitt_3_bild#')>
				<img src="/#session.serverpath#/upload/magazine/#getSlideContent.textabschnitt_3_bild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Text Abschnitt 3
		</td>
		<td>
			<textarea name="textabschnitt_3" id="textabschnitt_3" rows="0" cols="0">#getSlideContent.textabschnitt_3#</textarea>
			<script>
				CKEDITOR.replace('textabschnitt_3');
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Youtube Code
		</td>
		<td>
			<input type="text" name="youtube" id="youtube" value="#getSlideContent.youtube#" />
		</td>
	</tr>
	<tr>
		<td>
			Galerie
		</td>
		<td>
			<select name="galerie">
				<option value="0">keine</option>
				<cfloop query="getAlbums">
					<option value="#getAlbums.id#" <cfif getSlideContent.galerie EQ id>selected</cfif>>#getAlbums.albumTitle#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			Animation Galerie / Video Element
		</td>
		<td>
			<input type="radio" name="setting_mediaanimation" id="setting_mediaanimation1" value="0"  <cfif getSlideContent.setting_mediaanimation EQ 0>checked</cfif>> Nein<br/>
			<input type="radio" name="setting_mediaanimation" id="setting_mediaanimation2" value="1"  <cfif getSlideContent.setting_mediaanimation EQ 1>checked</cfif>> Ja<br/>
		</td>
	</tr>
	<tr>
		<td>
			Skin
		</td>
		<td>
			<select name="setting_skin">
				<option value="0" <cfif getSlideContent.setting_skin EQ 0>selected</cfif>>default</option>
				<option value="1" <cfif getSlideContent.setting_skin EQ 1>selected</cfif>>punkrock</option>
				<option value="2" <cfif getSlideContent.setting_skin EQ 2>selected</cfif>>klassisch</option>
				<option value="3" <cfif getSlideContent.setting_skin EQ 3>selected</cfif>>modern</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			Kommentare erlauben
		</td>
		<td>
			<input type="radio" name="setting_allowcomment" id="setting_allowcomment1" value="0" <cfif getSlideContent.setting_allowcomment EQ 0>checked</cfif>> Nein<br/>
			<input type="radio" name="setting_allowcomment" id="setting_allowcomment2" value="1" <cfif getSlideContent.setting_allowcomment EQ 1>checked</cfif>> Ja<br/>
		</td>
	</tr>
	</table>
</cfoutput>