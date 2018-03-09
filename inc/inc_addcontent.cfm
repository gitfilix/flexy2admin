<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />

<cfquery name="getAlbums" datasource="#application.dsn#">
SELECT	*
FROM	albums
WHERE	mandant = #session.mandant#
</cfquery>

<cfoutput><form action="#cgi.SCRIPT_NAME#?action=submittedNewContent<cfif isdefined('url.parentId')>&fromFEE=true</cfif>" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	
	<tr>
		<td>
			Reihenfolge
		</td>
		<td>
			<input type="text" name="reihenfolge" value="10">
		</td>
	</tr>
	<!--- ---------------- Inhalts Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Titel
		</td>
		<td>
			<input type="text" name="titel">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="">
	</cfif>
	<!--- ---------------- Inhalts Anriss ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_lead' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Anriss
		</td>
		<td>
<textarea name="lead" cols="1" rows="1" style="width:100%;height:120px;"></textarea>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="lead" value="">
	</cfif>
	<!--- ---------------- Inhalts Text ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_fliesstext' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Text
		</td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"></textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'addContent_fliesstext'
			</cfquery>
			<cfset f = "" />
			<cfset cnt = 0 />
			<cfloop query="getmandantenfeldfreigabentoolbar">
				<cfset f = listAppend(f,toolbaritems) />
			</cfloop>
			<script>
			CKEDITOR.replace( 'text',{
				toolbar : [
					[ <cfloop list="#f#" index="i">'#i#'<cfif cnt LT getmandantenfeldfreigabentoolbar.recordcount>,</cfif><cfset cnt = cnt + 1 />	</cfloop> ]
				]
			});
			</script>	
			<!--- ---------------- Bild Legende ---------------- --->
			<cfquery name="mandantenfeldfreigaben" dbtype="query">
			SELECT 	* 
			FROM 	feldfreigaben
			WHERE	fieldName = 'addContent_fliessTextSpalten' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif hasColumns AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			Spalten (nicht in jedem Template verwendbar)<br/>
			<input type="radio" name="columns" value="1" checked="checked" /> volle Breite (Standard)&nbsp;&nbsp;
			<input type="radio" name="columns" value="2" /> 2 Spalten&nbsp;&nbsp;
			<input type="radio" name="columns" value="3" /> 3 Spalten (Standard)&nbsp;&nbsp;
			<cfelse>
			<input type="hidden" name="columns" value="1" />
			</cfif>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="text" value="">
		<input type="hidden" name="columns" value="1">
	</cfif>
	<!--- ---------------- Inhalts Bild ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_bildname' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'editPage_headerBild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px)</td>
		<td>
			<input type="file" name="bild"><br/>
			<!--- ---------------- Bild Legende ---------------- --->
			<cfquery name="mandantenfeldfreigaben" dbtype="query">
			SELECT 	* 
			FROM 	feldfreigaben
			WHERE	fieldName = 'addContent_imageCaption' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			Bild-Legende<br/>
			<textarea name="imagecaption" cols="1" rows="1" style="width:100%;height:50px;"></textarea>
			<br/><br/>
			<cfelse>
				<input type="hidden" name="imagecaption" value="">
			</cfif>
			<!--- ---------------- Bild Position ---------------- --->
			<cfquery name="mandantenfeldfreigaben" dbtype="query">
			SELECT 	* 
			FROM 	feldfreigaben
			WHERE	fieldName = 'addContent_imagePos' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			Bildposition: <br/>
			<input type="radio" name="imagepos" value="0" checked="checked" /> Links&nbsp;&nbsp;
			<input type="radio" name="imagepos" value="1" /> Rechts&nbsp;&nbsp;
			<input type="radio" name="imagepos" value="2" /> volle Breite&nbsp;&nbsp;
			<cfelse>
				<input type="hidden" name="imagepos" value="0">
			</cfif>
			<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="bild" value="">
		<input type="hidden" name="imagepos" value="0">
	</cfif>
	<!--- ---------------- Links ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_href' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasMultilinks AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Links
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showLinks').toggle();">verwalten</a>
		</td>
	</tr>
	</cfif>
	<tr id="showLinks" <cfif hasMultilinks>style="display:none;"</cfif>>
		<td colspan="2">
			<table width="100%">
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			<tr>
				<td>Link (inkl- http://)</td>
				<td>
					<input type="text" name="link">
				</td>
			</tr>
			<cfelse>
			<input type="hidden" name="link" value="">
			</cfif>
			<!--- ---------------- Links ---------------- --->
			<cfquery name="mandantenfeldfreigaben" dbtype="query">
			SELECT 	* 
			FROM 	feldfreigaben
			WHERE	fieldName = 'addContent_hrefLabel' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			<tr>
				<td>Link-Label</td>
				<td>
					<input type="text" name="linklabel">
				</td>
			</tr>
			<cfelse>
			<input type="hidden" name="linklabel" value="">
			</cfif>
			<tr>
				<td colspan="2">
					<table id="sortLinks" width="100%">
					<tbody>
					<tr><td></td></tr>
					</tbody>
					</table>
				</td>
			</tr>
			<cfif hasMultiLinks>
			<tr>
				<td colspan="2">
					<a href="javascript:void(0);" onclick="loadMask('link');">Link erfassen</a>
				</td>
			</tr>	
			</cfif>
			</table>
		</td>
	</tr>
	<!--- ---------------- Doks ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_doc' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasMultiDocs AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Dokumente
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showDocs').toggle();">verwalten</a>
		</td>
	</tr>
	</cfif>
	<tr id="showDocs" <cfif hasMultiDocs>style="display:none;"</cfif>>
		<td colspan="2">
			<table width="100%">
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			<tr>
				<td>Dokument</td>
				<td>
					<input type="file" name="doc">
					<!--- ---------------- Doks ---------------- --->
					<cfquery name="mandantenfeldfreigaben" dbtype="query">
					SELECT 	* 
					FROM 	feldfreigaben
					WHERE	fieldName = 'addContent_docLabel' AND
							mandant = #session.mandant#
					</cfquery>
					<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
					Dokument-Label<br/>
					<input type="text" name="doclabel">
					<cfelse>
					<input type="hidden" name="doclabel" value="">
					</cfif>
				</td>
			</tr>
			<cfelse>
			<input type="hidden" name="doc" value="">
			</cfif>
			<tr>
				<td colspan="2">
					<table id="sortDocs" width="100%">
					<tbody>
					<tr><td></td></tr>
					</tbody>
					</table>
				</td>
			</tr>
			<cfif hasMultiDocs>
			<tr>
				<td colspan="2">
					<a href="javascript:void(0);" onclick="loadMask('dok');">Dokument erfassen</a>
				</td>
			</tr>	
			</cfif>
			</table>
		</td>
	</tr>
	<!--- ---------------- Inhalts Bild ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_hasContact' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasForm AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
		<tr>
			<td>
				Kontakformular einbinden?
			</td>
			<td>
				<input type="radio" name="hascontact" value="0" checked="checked" onclick="showFormOptions('formOptions',0)"> nein &nbsp;&nbsp;	
				<input type="radio" name="hascontact" value="1" onclick="showFormOptions('formOptions',1)"> ja	
				<cfif NOT hasFormCompact AND NOT hasFormFull>
					<input type="hidden" name="hascontact" value="0" /> 
				</cfif>
				<div id="formOptions" style="display:none;">
					Betreff: <input type="text" name="subject" value="" /><br/>
					Empfänger-Email: <input type="text" name="reciever" value="" /> (intern)<br/>
					Absender-Email: <input type="text" name="sender" value="" /><br/>
					Antwort-Email an Benutzer? <input type="radio" name="returnmail" value="0" checked="checked"> nein &nbsp;&nbsp;<input type="radio" name="returnmail" value="1"> ja	<br/>
					Dankes-Text:<br/>
					<textarea name="thankstext"  class="ckeditor" id="thankstext" cols="1" rows="1" style="width:100%;height:100px;"></textarea>
					<script>
						CKEDITOR.replace( 'text');
					</script>	
					<!--- ---------------- Kontakt-Typ ---------------- --->
					<cfquery name="mandantenfeldfreigaben" dbtype="query">
					SELECT 	* 
					FROM 	feldfreigaben
					WHERE	fieldName = 'addContent_contactType' AND
							mandant = #session.mandant#
					</cfquery>
					<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
					Formular-Typ:	<cfif hasFormCompact><input type="radio" name="formtype" value="0" checked="checked"> kompakt &nbsp;&nbsp;</cfif>
									<cfif hasFormFull><input type="radio" name="formtype" value="1"> volles Formular</cfif>
									<cfif NOT hasFormCompact AND NOT hasFormFull>
										<input type="hidden" name="formtype" value="1" /> 
									</cfif>
					<cfelse>
						<input type="hidden" name="formtype" value="1" /> 
					</cfif>
				</div>
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="hascontact" value="0" /> 
		<input type="hidden" name="subject" value="" /> 
		<input type="hidden" name="reciever" value="" /> 
		<input type="hidden" name="sender" value="" /> 
		<input type="hidden" name="formtype" value="1" /> 
		<input type="hidden" name="returnmail" value="0" /> 
		<input type="hidden" name="thankstext" value="" /> 
	</cfif>
	<cfif HasGallery>
	<tr>
		<td>
			Album einbinden?
		</td>
		<td>
			<select name="album" id="album">
				<option value="0" selected="selected">-- bitte wählen --</option>
				<cfloop query="getAlbums">
					<option value="#id#">#albumTitle#</option>
				</cfloop>
			</select>
			<cfif hasGalleryOptions>
				<br/>
				<cfif hasGalleryOptions1>
					<input type="radio" name="albumtype" value="1" checked="checked"> Thumbnail-Liste &nbsp;&nbsp;
				</cfif>
				<cfif hasGalleryOptions2>
					<input type="radio" name="albumtype" value="2"> volles Album&nbsp;&nbsp;
				</cfif>
				<cfif hasGalleryOptions3>
					<input type="radio" name="albumtype" value="3"> auf Inhaltsbild
				</cfif>
				<cfif not hasGalleryOptions1 AND not hasGalleryOptions2 AND not hasGalleryOptions2>
					<input type="hidden" name="albumtype" value="1" />
				</cfif>
			</cfif>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="album" value="0" />
		<input type="hidden" name="albumtype" value="1" />
	</cfif>
	<!--- ---------------- Custom-Include ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addContent_customInclude' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasCustomInclude AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Custom-include (nur für fortgeschrittene)
		</td>
		<td>
			<input type="text" name="custominclude"> (ab /inc/custom/)
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="custominclude" value="">
	</cfif>
	<cfif hasContentConnect>
	<tr>
		<td>Inhalte zu Tab-System verknüpfen</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showContentLinks').toggle();">verwalten</a>
		</td>
	</tr>
	<tr id="showContentLinks" style="display:none;">
		<td>Inhaltselemente auswählen</td>
		<td>
			<!--- alle inhalte auslesen --->
			<cfquery name="getAllContents" datasource="#application.dsn#">
			SELECT 	C.id,C.titel,C.fliesstext
			FROM 	content C LEFT JOIN
					pages P ON C.pageID = P.id
			WHERE 	C.isActive = 1 AND
					P.mandant = #session.mandant# AND
					P.lang = '#session.lang#'
			ORDER	BY C.pageID
			</cfquery>
			<table width="100%">
				<cfloop query="getAllContents">
					<tr>
						<td>
							<input type="checkbox" name="contentLinkID" value="#id#" /> <cfif titel NEQ "">#titel#<cfelse>[kein Titel. ID #id# - <cfif fliesstext GT 20>#left(fliesstext,20)#</cfif>]</cfif><br/>
						</td>
						<td align="right">
							<input type="text" style="width:20px;" name="contentLinkOrder" value="" />
						</td>
					</tr>
				</cfloop>
			</table>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="contentLinkOrder" value="1" />
	</cfif>
	<cfif hasContentTeasers>
		<tr>
			<td>Teasers verknüpfen</td>
			<td>
				<a href="javascript:void(0);" onclick="$('##showContentTeasers').toggle();">verwalten</a>
			</td>
		</tr>
		<tr id="showContentTeasers" style="display:none;">
			<td valign="top">Teaser Elemente</td>
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
				<tr>
					<td width="40">
						<input type="checkbox" name="teaserID" value="#id#" />
					</td>
					<td>
						#titel#
					</td>
					<td align="right" style="width:40px;">
						<input type="text" name="teaserOrder" style="width:40px;" />
					</td>
				</tr>
				<cfset counter = counter + 1 />
				</cfloop>
				</tbody>
				</table>
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="teaserOrder" value="1" />
	</cfif>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" />  
			
			<!--- wenn front-end-editing --->
			<cfif isdefined("url.parentId")>
				<input type="button" value="abbrechen" onclick="parent.$.fancybox.close();">
			<!--- wenn flexy backoffice --->
			<cfelse>
				<input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			</cfif>
			
			<input type="hidden" name="pageid" value="#url.pageid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>
