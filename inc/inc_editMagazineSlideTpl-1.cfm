<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />


<!--- form processor UPDATE slide Template 1 --->
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
	<cfset bild = form.origbild />
	<cfif isdefined("form.bild") AND form.bild NEQ "">
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset bild = cffile.serverfile />
	</cfif>
	
	<!--- update template 1 --->
	<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
	UPDATE	magazinslidetpl_#form.template#
	SET		titel = '#form.titel#',
			lead = '#form.lead#',
			bild = '#bild#',
			imgpos ='#imgpos#',
			bildlegende = '#form.caption#',
			link = '#form.link#',
			linktitel = '#form.linktitel#',
			video = #form.video#,
			lbbild = '#lbbild#',
			ytvideo = '#form.ytcode#'   
	WHERE	slideid = #form.slideID#
	</cfquery>
	
	<!--- update teasers --->
	<cfif isdefined("form.teaserID")>
		<!--- erst alle teasers löschen --->
		<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
		DELETE	
		FROM	teaser2slides
		WHERE	slideID = #form.slideID#
		</cfquery>
		<!--- insert new submitted teasers --->
		<cfloop from="1" to="#ListLen(form.teaserid)#" index="i">
			<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
			INSERT 
			INTO	teaser2slides (slideID,teaserID,reihenfolge)
			VALUES(
					#form.slideID#,
					#listGetAt(form.teaserid,i)#,
					#listGetAt(form.teaserOrder,i)#
			)
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfdump var="#form#"><cfabort>
	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!---END  form processor UPDATE slide Template 1 --->

<cfquery name="getslideTpl1" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_1
WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl1">
	<table width="100%">
	<tr>
		<td>
			Layout-Type:
		</td>
		<td>
		<select name="setting_layout">
			<option value="0" <cfif getslideTpl1.setting_layout EQ 0>selected</cfif>>Layout 0 Links: Text, Lead, Lightbox - Rechts: Bild Hochformat</option>
			<option value="1" <cfif getslideTpl1.setting_layout EQ 1>selected</cfif>>Layout 1 Links: Bild  - Rechts: Titel Lead</option>
			<option value="2" <cfif getslideTpl1.setting_layout EQ 2>selected</cfif>>Layout 2 Oben: Bild  - Unten:  Titel Lightbox</option>
			<option value="3" <cfif getslideTpl1.setting_layout EQ 3>selected</cfif>>Layout 3 BIG Screen - dezente Lightbox mit Titel lead</option>
		</select>
		</td>
	</tr>
	<tr>
		<td>
			Farbschema-Type (Skin):
		</td>
		<td>
		<select name="setting_skin">
			<option value="0" <cfif getslideTpl1.setting_skin EQ 0>selected</cfif>>ICE-on-Concrete: Text in Cyan auf Dunklem Grund</option>
			<option value="1" <cfif getslideTpl1.setting_skin EQ 1>selected</cfif>>Black is Beautiful: Weisser Text auf Schwarzem Grund</option>
			<option value="2" <cfif getslideTpl1.setting_skin EQ 2>selected</cfif>>Snow-white:  Schwarzer Text, Rote Elemente, Weisser Grund</option>
		</select>
		</td>
	</tr>
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
			Titelfarbe: (HEX-value)
		</td>
		<td>
		<input type="text" name="titlecolor" id="titlecolor" value="#getslideTpl1.titlecolor#" />
		</td>
	</tr>
	<tr>
		<td>
			Lead:
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
			Bild:
		</td>
		<td>
			<input type="file" name="bild" id="bild" />
			<input type="hidden" name="origbild" id="origbild" value="#bild#" />
			<cfif bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#bild#')>
				<img src="/#session.serverpath#/upload/magazine/#bild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>	
		<td>
		Bild Position:
		</td>
		<td>
			<input type="radio" value="0" <cfif getslideTpl1.imgpos EQ 0>checked</cfif> name="imgpos">zentriert (center-center)<br/>
			<input type="radio" value="1" <cfif getslideTpl1.imgpos EQ 1>checked</cfif> name="imgpos">zentriert-oben (center-top)<br/>
			<input type="radio" value="2" <cfif getslideTpl1.imgpos EQ 2>checked</cfif> name="imgpos">zentriert-unten (center-bottom)<br/>
			<input type="radio" value="3" <cfif getslideTpl1.imgpos EQ 3>checked</cfif> name="imgpos">links-oben (left-top)<br/>
			<input type="radio" value="4" <cfif getslideTpl1.imgpos EQ 4>checked</cfif> name="imgpos">links-zentriert (left-center)<br/>
			<input type="radio" value="5" <cfif getslideTpl1.imgpos EQ 5>checked</cfif> name="imgpos">links-unten (left-bottom)<br/>
			<input type="radio" value="6" <cfif getslideTpl1.imgpos EQ 6>checked</cfif> name="imgpos">rechts-oben (right-top)<br/>
			<input type="radio" value="7" <cfif getslideTpl1.imgpos EQ 7>checked</cfif> name="imgpos">rechts-zentriert (right-center)<br/>
			<input type="radio" value="8" <cfif getslideTpl1.imgpos EQ 8>checked</cfif> name="imgpos">rechts-unten (right-bottom)<br/>
		</td>
	</tr> 
	<tr>
		<td>
			Bild Legende:
		</td>
		<td>
			<textarea name="caption" id="caption" rows="0" cols="0">#bildlegende#</textarea>
			
		</td>
	</tr>
	<tr style="background:##484848; color:##EBEBEB;">
		<td>Lightbox</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			Inhalte in Lightbox?
		</td>
		<td>
			<select name="lightboxtype">
			<option value="0" <cfif getslideTpl1.lightboxtype EQ 0>selected</cfif>>Keine weiteren Inhalte, keine Lightbox</option>
			<option value="1" <cfif getslideTpl1.lightboxtype EQ 1>selected</cfif>>Lightbox mit Text, Titel, Bild</option>
			<option value="2" <cfif getslideTpl1.lightboxtype EQ 2>selected</cfif>>Lightbox mit Text, Titel, Video</option>
		</select>
		</td>
	</tr>
	<tr>
		<td>
			Lightbox button Text:
		</td>
		<td>
			<input type="text" name="lightboxbutton" id="lightboxbutton" value="#lightboxbutton#" />
		</td>
	</tr>
	<tr>
		<td>
			Lightbox Titel:
		</td>
		<td>
			<input type="text" name="lightboxtitle" id="lightboxtitle" value="#lightboxtitle#" />
		</td>
	</tr>
	<tr>
		<td>
			Text Lightbox:
		</td>
		<td>
			<textarea name="lightboxtext" id="lightboxtext" rows="0" cols="0">#lightboxtext#</textarea>
			<script>
				CKEDITOR.replace('lightboxtext');
			</script>
		</td>
	</tr>
	<tr>
		<td>
			Bild Lightbox:
		</td>
		<td>
			<input type="file" name="lbbild" id="lbbild" />
			<input type="hidden" name="origlbbild" id="origlbbild" value="#lbbild#" />
			<cfif bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#lbbild#')>
				<img src="/#session.serverpath#/upload/magazine/#lbbild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Video:
		</td>
		<td>
			<select name="video" id="video">
				<option value="1" <cfif video EQ 1>selected</cfif>>Video 1</option>
				<option value="2" <cfif video EQ 2>selected</cfif>>Video 2</option>
				<option value="3" <cfif video EQ 3>selected</cfif>>Video 3</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			Youtube Video code:
		</td>
		<td>
			<input type="text" name="ytcode" id="ytcode" value="#ytvideo#" />
		</td>
	</tr>
	<tr>
		<td>
			Teasers:
		</td>
		<td>
			<cfquery name="getTeasers" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar
			WHERE	mandant = #session.mandant# AND
					isActive = 1 AND
					teaserposition = 2
			</cfquery>

			<table width="100%" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<th align="left">
						Select
					</th>
					<th align="left">
						Titel
					</th>
					<th align="left">
						Order
					</th>
				</tr>
			</thead>
			<tbody>
			<cfset counter = 1 />
			<cfloop query="getTeasers">
				<cfquery name="getTeaser" datasource="#application.dsn#">
				SELECT * FROM teaser2slides WHERE slideID = #url.editMagazinSlide# AND teaserID = #id#
				</cfquery>
				<tr>
					<td width="40">
						<input type="checkbox" name="teaserID" value="#id#" <cfif getTeaser.recordcount NEQ 0>checked="checked"</cfif> />
					</td>
					<td>
						#titel#
					</td>
					<td align="right" style="width:40px;">
						<input type="text" name="teaserOrder" style="width:40px;" <cfif getTeaser.recordcount NEQ 0>value="#getTeaser.reihenfolge#"</cfif> />
					</td>
				</tr>
				<cfset counter = counter + 1 />
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	</table>
</cfoutput>