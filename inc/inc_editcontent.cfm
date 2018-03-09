

<cfprocessingdirective pageencoding="utf-8" />
<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />

<cfquery name="getContentsByID" datasource="#application.dsn#">
SELECT	*
FROM	content
WHERE	id = #url.editcontent#
</cfquery>

<cfquery name="getAlbums" datasource="#application.dsn#">
SELECT	*
FROM	albums
WHERE	mandant = #session.mandant#
</cfquery>

<cfoutput query="getContentsByID">

<form action="#cgi.SCRIPT_NAME#?action=submittedEditedContent<cfif isdefined('url.parentId')>&fromFEE=true</cfif>" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>
			Reihenfolge
		</td>
		<td>
			<input type="text" name="reihenfolge" value="#reihenfolge#">
		</td>
	</tr>
	<!--- ---------------- Inhalts Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editContent_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Seiten Titel
		</td>
		<td>
			<input type="text" name="titel" value="#titel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="#titel#">
	</cfif>
	<!--- ---------------- Inhalts Anriss ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editContent_lead' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Anriss
		</td>
		<td>
<textarea name="lead" cols="1" rows="1" style="width:100%;height:120px;">#lead#</textarea>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="lead" value="#lead#">
	</cfif>
	<!--- ---------------- Inhalts Text ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editContent_fliesstext' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Fliess-Text
		</td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;">#fliesstext#</textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'editContent_fliesstext'
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
			WHERE	fieldName = 'editContent_fliessTextSpalten' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif hasColumns AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			Spalten (nicht in jedem Template verwendbar)<br/>
			<input type="radio" name="columns" value="1" <cfif fliesstextspalten EQ 1>checked="checked"</cfif> /> volle Breite (Standard)&nbsp;&nbsp;
			<input type="radio" name="columns" value="2" <cfif fliesstextspalten EQ 3>checked="checked"</cfif> /> 2 Spalten&nbsp;&nbsp;
			<input type="radio" name="columns" value="3" <cfif fliesstextspalten EQ 3>checked="checked"</cfif> /> 3 Spalten (Standard)&nbsp;&nbsp;
			<cfelse>
			<input type="hidden" name="columns" value="#fliesstextspalten#" />
			</cfif>
		</td>
	</tr>
	<cfelse>
		<textarea name="text" style="display:none;">#fliesstext#</textarea>
		<input type="hidden" name="columns" value="#fliesstextspalten#">
	</cfif>
	<!--- ---------------- Inhalts Bild ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editContent_bildname' AND
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
			<cfif bildname NEQ "">
				Momentanes Bild auf dem Server: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/img/#bildname#" target="_blank">#bildname#</a><!--- <a href="/#session.serverpath#/upload/img/#bildname#" target="_blank">#bildname#</a> ---><br/>
			<input type="checkbox" name="delimage" value="#bildname#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#bildname#" /><br/>
			<!--- ---------------- Bild Legende ---------------- --->
			<cfquery name="mandantenfeldfreigaben" dbtype="query">
			SELECT 	* 
			FROM 	feldfreigaben
			WHERE	fieldName = 'editContent_imageCaption' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			Bild-Legende<br/>
			<textarea name="imagecaption" cols="1" rows="1" style="width:100%;height:50px;">#imagecaption#</textarea>
			<br/><br/>
			<cfelse>
				<input type="hidden" name="text" value="#imagecaption#">
			</cfif>
			<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
			<!--- ---------------- Bild Position ---------------- --->
			<cfquery name="mandantenfeldfreigaben" dbtype="query">
			SELECT 	* 
			FROM 	feldfreigaben
			WHERE	fieldName = 'editContent_imagePos' AND
					mandant = #session.mandant#
			</cfquery>
			<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
			Bildposition: <br/>
			<input type="radio" name="imagepos" value="0" <cfif imagepos EQ 0>checked="checked"</cfif> /> Links&nbsp;&nbsp;
			<input type="radio" name="imagepos" value="1" <cfif imagepos EQ 1>checked="checked"</cfif> /> Rechts&nbsp;&nbsp;
			<input type="radio" name="imagepos" value="2" <cfif imagepos EQ 2>checked="checked"</cfif> /> volle Breite&nbsp;&nbsp;
			<cfelse>
				<input type="hidden" name="imagepos" value="#imagepos#">
			</cfif>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="bild" value="">
		<input type="hidden" name="imagepos" value="#imagepos#">
		<input type="hidden" name="origbild" value="#bildname#" />
	</cfif>
	<!--- ---------------- Links ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editContent_href' AND
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
					<input type="text" name="link" value="#href#"><br/>
					<!--- ---------------- Links ---------------- --->
					<cfquery name="mandantenfeldfreigaben" dbtype="query">
					SELECT 	* 
					FROM 	feldfreigaben
					WHERE	fieldName = 'editContent_hrefLabel' AND
							mandant = #session.mandant#
					</cfquery>
					<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
					Link-Label<br/>
					<input type="text" name="linklabel" value="#hreflabel#">
					<cfelse>
						<input type="hidden" name="linklabel" value="#hreflabel#">
					</cfif>
				</td>
			</tr>
			<cfelse>
				<input type="hidden" name="link" value="">
			</cfif>
			<cfquery name="getLinksAdded" datasource="#application.dsn#">
			SELECT 	*
			FROM	links2pages
			WHERE	contentid = #url.editcontent#
			</cfquery>
			
				<cfset cnt = 2 />
				<tr>
					<td colspan="2">
						<table id="sortLinks" width="100%">
						<tbody>
						<tr><td></td></tr>
						<cfloop query="getLinksAdded">
							<tr class="linkelem">
								<td>Link (inkl- http://)</td>
								<td>
									<input type="text" name="link#cnt#" value="#href#"><br/>
									Link-Label<br/>
									<input type="text" name="linklabel#cnt#" value="#hreflabel#">
								</td>
							</tr>
							<cfset cnt = cnt + 1 />
						</cfloop>
					</tbody>
					</table>
				</td>
			</tr>
			<cfif hasMultiLinks>
				<tr>
					<td colspan="2">
						<!--- <table id="moreLinks" width="100%" cellpadding="0" cellspacing="0" style="background-color:##949494;">
						<tr style="display:none;"><td></td></tr>
						</table> --->
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
	WHERE	fieldName = 'editContent_doc' AND
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
					<cfif doc NEQ "">
					Momentanes Dokument auf dem Server: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/doc/#doc#" target="_blank">#doc#</a><!--- <a href="/#session.serverpath#/upload/doc/#doc#" target="_blank">#doc#</a> ---><br/>
					<input type="checkbox" name="deldoc" value="#doc#" /> Dokument löschen<br/>
					</cfif>
					<input type="file" name="doc">
					<input type="hidden" name="origdoc" value="#doc#" /><br/>
					<!--- ---------------- Doks ---------------- --->
					<cfquery name="mandantenfeldfreigaben" dbtype="query">
					SELECT 	* 
					FROM 	feldfreigaben
					WHERE	fieldName = 'editContent_docLabel' AND
							mandant = #session.mandant#
					</cfquery>
					<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
						Dokument-Label<br/>
						<input type="text" name="doclabel" value="#doclabel#">
					<cfelse>
						<input type="hidden" name="doclabel" value="">
					</cfif>
				</td>
			</tr>
			<cfelse>			
				<input type="hidden" name="doc" value="">
				<input type="hidden" name="origdoc" value="" />
				<input type="hidden" name="doclabel" value="">
			</cfif>
			<cfquery name="getDocsAdded" datasource="#application.dsn#">
			SELECT 	*
			FROM	docs2pages
			WHERE	contentid = #url.editcontent#
			</cfquery>
			
			<cfset cnt = 2 />
			<tr>
				<td colspan="2">
					<table id="sortDocs" width="100%">
					<tbody>
					<tr><td></td></tr>
					<cfloop query="getDocsAdded">
						<tr class="dokelem">
							<td>Dokument</td>
							<td>
								<cfif dok NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/doc/')  & dok)>
								Momentanes Dokument auf dem Server: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/doc/#dok#" target="_blank">#dok#</a><!--- <a href="/#session.serverpath#/upload/doc/#dok#" target="_blank">#dok#</a> ---><br/>
								<input type="checkbox" name="deldoc#cnt#" title="deldoc" value="#dok#" /> Dokument löschen<br/>
								</cfif>
								<input type="file" name="doc#cnt#" title="doc">
								<input type="hidden" name="origdoc#cnt#" title="origdoc" value="#dok#" /><br/>
								Dokument-Label<br/>
								<input type="text" name="doclabel#cnt#" value="#doklabel#" title="doclabel">
								<input type="hidden" name="size#cnt#" value="#size#" title="size">
							</td>
						</tr>
						<cfset cnt = cnt + 1 />
					</cfloop>
					</tbody>
					</table>
				</td>
			</tr>
			<cfif hasMultiDocs>
			<tr>
				<td colspan="2">
		
					<!--- <table id="moreDoks" width="100%" cellpadding="0" cellspacing="0">
					<tr style="display:none;"><td></td></tr>
					</table> --->
				
					<a href="javascript:void(0);" onclick="loadMask('dok');">Dokument erfassen</a>
				</td>
			</tr>	
			</cfif>
			</table>
		</td>
	</tr>
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editContent_hasContact' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasForm AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Kontakformular einbinden?
		</td>
		<td>
			<input type="radio" name="hascontact" value="0" <cfif hascontact EQ 0>checked="checked"</cfif> onclick="showFormOptions('formOptions',0)"> nein &nbsp;&nbsp;	
			<input type="radio" name="hascontact" value="1" <cfif hascontact EQ 1>checked="checked"</cfif> onclick="showFormOptions('formOptions',1)"> ja	
			<cfif NOT hasFormCompact AND NOT hasFormFull>
				<input type="hidden" name="hascontact" value="0" /> 
			</cfif>
			<div style="<cfif hascontact EQ 0>display:none;</cfif>" id="formOptions">
				<!--- ---------------- Kontakt-Typ ---------------- --->
				<cfquery name="mandantenfeldfreigaben" dbtype="query">
				SELECT 	* 
				FROM 	feldfreigaben
				WHERE	fieldName = 'editContent_contactType' AND
						mandant = #session.mandant#
				</cfquery>
				
				Betreff: <input type="text" name="subject" value="#contactSubject#" /><br/>
				Empfänger-Email: <input type="text" name="reciever" value="#contactReciever#" /> (intern)<br/>
				Absender-Email: <input type="text" name="sender" value="#contactSender#" /><br/>
				Antwort-Email an Benutzer? <input type="radio" name="returnmail" value="0" <cfif contactReturnMail EQ 0>checked="checked"</cfif>> nein &nbsp;&nbsp;<input type="radio" name="returnmail" value="1" <cfif contactReturnMail EQ 1>checked="checked"</cfif>> ja	<br/>
				Dankes-Text:<br/>
				<textarea name="thankstext"  class="ckeditor" id="thankstext" cols="1" rows="1" style="width:100%;height:100px;">#contactThanks#</textarea>
				<script>
				CKEDITOR.replace( 'thankstext',{
					toolbar : [
						[ 'Source','Bold','Italic','Underline','BulletedList','PasteFromWord','Undo','Redo','Link','Unlink','Table','HorizontalRule','FontSize', 'TextColor' ]
					]
				});
				</script>	
				<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
				Formular-Typ:	<cfif hasFormCompact><input type="radio" name="formtype" value="0" <cfif contactType EQ 0 OR NOT hasFormFull>checked="checked"</cfif>> kompakt &nbsp;&nbsp;</cfif>
								<cfif hasFormFull><input type="radio" name="formtype" value="1" <cfif contactType EQ 1 OR NOT hasFormCompact>checked="checked"</cfif>> volles Formular</cfif>
				<cfelse>
					<input type="hidden" name="formtype" value="0" /> 
				</cfif>
			</div>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hascontact" value="0" /> 
		<input type="hidden" name="subject" value="#contactSubject#" />
		<input type="hidden" name="reciever" value="#contactReciever#" /> 
		<input type="hidden" name="sender" value="#contactSender#" /> 
		<input type="hidden" name="formtype" value="0" />
		<input type="hidden" name="returnmail" value="#contactReturnMail#" /> 
		<input type="hidden" name="thankstext" value="#contactThanks#" />   
	</cfif>
	<cfif HasGallery>
	<tr>
		<td>
			Album einbinden?
		</td>
		<td>
			<select name="album" id="album">
				<option value="0">-- bitte wählen --</option>
				<cfloop query="getAlbums">
					<option value="#id#" <cfif getContentsByID.albumID EQ id>selected="selected"</cfif>>#albumTitle#</option>
				</cfloop>
			</select>
			<cfif hasGalleryOptions>
				<br/>
				<cfif hasGalleryOptions1>
					<input type="radio" name="albumtype" value="1" <cfif albumtype EQ 1>checked="checked"</cfif>> Thumbnail-Liste &nbsp;&nbsp;
				</cfif>
				<cfif hasGalleryOptions2>
					<input type="radio" name="albumtype" value="2" <cfif albumtype EQ 2>checked="checked"</cfif>> volles Album&nbsp;&nbsp;
				</cfif>
				<cfif hasGalleryOptions3>
					<input type="radio" name="albumtype" value="3" <cfif albumtype EQ 3>checked="checked"</cfif>> auf Inhaltsbild
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
	WHERE	fieldName = 'editContent_customInclude' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasCustomInclude AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>
			Custom-include (nur für fortgeschrittene)
		</td>
		<td>
			<input type="text" name="custominclude" value="#custominclude#"> (ab /inc/custom/)
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="custominclude" value="#custominclude#">
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
			SELECT 	C.id,C.titel,C.fliesstext,C.pageid
			FROM 	content C LEFT JOIN
					pages P ON C.pageID = P.id
			WHERE 	C.isActive = 1 AND
					P.mandant = #session.mandant# AND
					C.id != #url.editcontent# AND
					P.lang = '#session.lang#'
			ORDER	BY C.pageID
			</cfquery>
			
			<cfquery name="getAllLinkedContents" datasource="#application.dsn#">
			SELECT 	linkedContentID,mainContentID,reihenfolge
			FROM 	contents2content
			WHERE 	mainContentID = #url.editcontent#
			</cfquery>
			<cfset CheckedList = "" />
			<cfset OrderList = "" />
			<cfloop query="getAllLinkedContents">
				<cfif mainContentID EQ url.editcontent>
					<cfset CheckedList = listAppend(CheckedList,linkedContentID) />
					<cfset OrderList = listAppend(OrderList,reihenfolge) />
				</cfif>
			</cfloop>
			<table width="100%">
				<cfloop query="getAllContents">
					<tr>
						<td>
							<input type="checkbox" name="contentLinkID" value="#id#" <cfif listFind(checkedList,id)>checked="checked"</cfif> /> <span <cfif url.editcontent EQ pageid>style="font-weight:bold;"</cfif>><cfif titel NEQ "">#titel#<cfelse>[kein Titel. ID #id# - <cfif fliesstext GT 20>#left(fliesstext,20)#</cfif>]</cfif></strong><br/>
						</td>
						<td align="right">
							<input type="text" style="width:20px;" name="contentLinkOrder" value="<cfif listFind(checkedList,id)>#ListGetAt(OrderList,listFind(checkedList,id))#</cfif>" />
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
			<cfquery name="getTeaser" datasource="#application.dsn#">
			SELECT * FROM teaser2content WHERE contentID = #url.editcontent# AND teaserID = #id#
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
	<cfelse>
		<input type="hidden" name="teaserOrder" value="1" />
	</cfif>
	<tr>
		<td>
			Träger-Seite
		</td>
		<td>
			<cfquery name="getAllPagesExceptMyself" datasource="#application.dsn#">
			SELECT 	*
			FROM 	pages
			WHERE 	lang = '#session.lang#' AND
					id != #url.editcontent# AND
					mandant = #session.mandant#
			ORDER	BY pageTitel
			</cfquery>
			<select name="pageid">
				<cfloop query="getAllPagesExceptMyself">
					<option value="#id#" <cfif id EQ getContentsByID.pageid>selected</cfif>>#pageTitel#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" class="btn-action"/> 
			<!--- wenn front-end-editing --->
			<cfif isdefined("url.parentId")>
				<input class="btn-noaction" type="button" value="abbrechen" onclick="parent.$.fancybox.close();">
			<!--- wenn flexy backoffice --->
			<cfelse>
				<input class="btn-noaction" type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			</cfif>
			<input type="hidden" name="contentid" value="#url.editcontent#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>