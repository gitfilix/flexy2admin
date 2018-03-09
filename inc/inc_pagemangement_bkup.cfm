<cfprocessingdirective pageencoding="utf-8" />

<link  rel="stylesheet" type="text/css" href="../css/pagemanagement.css"  >

<style>

/* colors für status*/
#activ{
	color:#3F3;
	}

#inactiv{
	color:#9FF;
	}
	
/*:nth-child(2n){*/

table tr{
	background:#949494;
	}
	
table tr:nth-child(2n+1){
	background:#B2B2B2;
	}	
	
#gray1{
	color:#039;
	letter-spacing:2px;
	background:#9A9A9A;
	}

#gray2{
	color:#039;
	letter-spacing:2px;
	background:#B2B2B2;
	}

#gray3{
	color:#039;
	letter-spacing:2px;
	background:#D6D6D6;
	}	
</style>

<!--- -------------- form prozessors ------------------ --->


<!--- alle pages auslesen der Navigation von level0 von themen- und servicenavigation ohne kinder (kinder= parentID > 0)--->
<cfquery name="getRootPages" datasource="#application.dsn#">
SELECT	*
FROM	pages
WHERE	parentID = 0 AND
		mandant = '#session.serverpath#'
ORDER	BY navpos, navorder 
</cfquery>

<!--- page löschen --->
<cfif isdefined("url.delPage") AND isNumeric(url.delPage) AND url.delPage GT 0>
	<cfquery name="delPage" datasource="#application.dsn#">
	DELETE
	FROM	pages
	WHERE	id = #url.delPage#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- page hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewPage" AND isdefined("form.navPos")>
		
		<cfif form.headerbild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="headerbild" destination='#remoteServerPath##session.serverpath#\upload\img\' nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
		
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
			<cfif bildbreite gt 960 >
				<cfimage action="resize" width="960" height="" source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes">
				<!--- This example shows how to crop an image. --->
				<!--- Create a ColdFusion image from an existing JPEG file. --->
				<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" name="myImage">
				<!--- Crop myImage to 100x100 pixels starting at the coordinates (10,10).--->
				<cfset ImageCrop(myImage,0,0,960,200)>
				<!--- Write the result to a file. --->
				<cfimage source="#myImage#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes">
			</cfif>
		<cfelse>
			<cfset serverbildname = "">
		</cfif>
		<cfquery name="insertPage" datasource="#application.dsn#">
		INSERT	
		INTO	pages (parentUser, createdate, isactive, navPos, navTitel, pageTitel, metaTitel, metaKeys, metaDesc, parentID, navorder, headerbild, template, mandant, urlshortcut, templatecolorschema)
		VALUES(
			#session.UserID#,
			#createODBCDateTime(now())#,
			#form.active#,
			#form.navPos#,
			'#form.navTitel#',
			'#form.pageTitel#',
			'#form.metaTitel#',
			'#form.metaKeys#',
			'#form.metaDesc#',
			#form.parentID#,
			<cfif form.order NEQ "">#form.order#<cfelse>NULL</cfif>,
			'#serverbildname#',
			#form.template#,
			'#session.serverpath#',
			'#form.urlshortcut#',
			#form.templatecolor#
		)
		</cfquery>
		<!--- neuste generierte ID auslesen --->
		<cfquery name="getLatestID" datasource="#application.dsn#">
		SELECT MAX(id) as lastID from pages
		WHERE mandant = '#session.serverpath#'
		</cfquery>
		<!--- schauen ob gecheckte sidebars übermittelt wurden --->
		<cfif form.fieldnames contains 'sidebar'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine sidebar gefunden wurde... --->
				<cfif i contains "sidebar">
					<!--- ergänze (bis jetzt leere) sidebar-liste mit form-namen --->
					<cfset sidebarList = ListAppend(sidebarList,i) />
					<!--- evaluiere formfeld ORDER  --->
					<cfset reihenfolge = replaceNoCase(i,'sidebar','order') />
					<!--- speichere sidebar ID in variable --->
					<cfset sidebarID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<!--- in zwischentabelle schreiben --->
					<cfquery name="insertSidebar2Pages" datasource="#application.dsn#">
					INSERT
					INTO	sidebar2pages(pageid,sidebarid,reihenfolge)
					VALUES(
						#getLatestID.lastID#,
						#sidebarID#,
						#orderx#		
					)
					</cfquery>					
				</cfif>
			</cfloop>
		
		</cfif>
	
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	</cfif>

<!--- page updaten --->

<!--- Modul submittedEditedPage --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedPage" AND isdefined("form.navPos")>

		<cfif form.headerbild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="headerbild" destination="#remoteServerPath##session.serverpath#\upload\img\" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
			<cfif bildbreite gt 960 >
				<cfimage action="resize" width="960" height="" source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes">
				<!--- This example shows how to crop an image. --->
				<!--- Create a ColdFusion image from an existing JPEG file. --->
				<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" name="myImage">
				<!--- Crop myImage to 100x100 pixels starting at the coordinates (10,10).--->
				<cfset ImageCrop(myImage,0,0,960,200)>
				<!--- Write the result to a file. --->
				<cfimage source="#myImage#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes">
			</cfif>
		<cfelseif not isdefined("form.delimage")>
			<cfset serverbildname = form.origbild>
		<cfelse>
			<cfset serverbildname = "">
		</cfif>
		
		<cfquery name="updatePage" datasource="#application.dsn#">
		UPDATE	pages
		SET		parentUser = #session.userID#,
				modifydate = #createODBCdateTime(now())#,
				isactive = #form.active#,
				navPos = #form.navPos#,
				navTitel = '#form.navTitel#',
				pageTitel = '#form.pageTitel#',
				metaTitel = '#form.metaTitel#',
				metaKeys = '#form.metaKeys#',
				metaDesc = '#form.metaDesc#',
				parentID = #form.parentID#,
				navorder = #form.reihenfolge#,
				headerbild = '#serverbildname#',
				template = #form.template#,
				urlshortcut = '#form.urlshortcut#',
				templatecolorschema = #form.templatecolor#
		WHERE	id = #form.pageID#
		</cfquery>
		
		
		
		<!--- alle bestehenden einträge aus der zw-tabelle löschen --->
		<cfquery name="deleteAllPreviousSidebarEntries" datasource="#application.dsn#">
		DELETE
		FROM	sidebar2pages
		WHERE	pageid = #form.pageID# 
		</cfquery>
		<!--- hier werden nun alle aktualisierten einträge eruiert und wiederum gespeichert --->
		<!--- schauen ob gecheckte sidebars übermittelt wurden --->
		<cfif form.fieldnames contains 'sidebar'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine sidebar gefunden wurde... --->
				<cfif i contains "sidebar">
					<!--- ergänze (bis jetzt leere) sidebar-liste mit form-namen --->
					<cfset sidebarList = ListAppend(sidebarList,i) />
					<!--- evaluiere formfeld ORDER  --->
					<cfset reihenfolge = replaceNoCase(i,'sidebar','order') />
					<!--- speichere sidebar ID in variable --->
					<cfset sidebarID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<!--- in zwischentabelle schreiben --->
					<cfquery name="insertSidebar2Pages" datasource="#application.dsn#">
					INSERT
					INTO	sidebar2pages(pageid,sidebarid,reihenfolge)
					VALUES(
						#form.pageID#,
						#sidebarID#,
						#orderx#		
					)
					</cfquery>					
				</cfif>
			</cfloop>
		</cfif>
		
		
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- zu bearbeitenden page aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editPage") AND isNumeric(url.editPage) AND url.editPage GT 0>
	<cfquery name="editPage" datasource="#application.dsn#">
	SELECT	*
	FROM	pages
	WHERE	id = #url.editPage# AND
			mandant = '#session.serverpath#'
	</cfquery>
</cfif>

<!---inhalte der page speichern --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewContent">
	<!--- bild upload --->
	<!--- wenn ein bild ausgewählt wurde --->
	<cfif form.bild NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img\" nameconflict="makeunique">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildname = cffile.serverfile>
		<!--- 	wenn bildbreite gt 480 -> bild auf 480 resizen und überschreiben --->
		<cfif bildbreite gt 480 >
			<cfimage action="resize" width="480" height="" source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" overwrite="yes">
		</cfif>
	<cfelse>
		<cfset serverbildname = "">
	</cfif>
	
	<!--- dokument upload  --->
	<!--- wenn ein doc ausgewählt wurde --->
	<cfif form.doc NEQ "">
		<!--- doc auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="doc" destination="#remoteServerPath##session.serverpath#\upload\doc\" nameconflict="makeunique">
		<!--- 	serverdocname in variable speichen --->
		<cfset serverdocname = cffile.serverfile>
	<cfelse>
		<cfset serverdocname = "">
	</cfif>
	
	<cfquery name="insertContent" datasource="#application.dsn#">
		INSERT 	INTO content(
				pageID,
				isActive,
				createdate,
				titel,
				lead,
				fliesstext,
				bildname,
				href,
				hrefLabel,
				doc,
				docLabel,
				hasContact)
		VALUES(
				#form.pageID#,
				#form.active#,
				#createODBCdatetime(now())#,
				'#form.titel#',
				'#form.lead#',
				'#form.text#',
				'#serverbildname#',
				'#form.link#',
				'#form.linklabel#',
				'#serverdocname#',
				'#form.doclabel#',
				#form.hascontact#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!---inhalte der page ändern / updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedContent">
	<!--- bild upload --->
	<!--- wenn ein bild ausgewählt wurde --->
	<cfif form.bild NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img\" nameconflict="makeunique">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\doc\#cffile.serverfile#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildname = cffile.serverfile>
		<!--- 	wenn bildbreite gt 480 -> bild auf 480 resizen und überschreiben --->
		<cfif bildbreite gt 480 >
			<cfimage action="resize" width="480" height="" source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" overwrite="yes">
		</cfif>
	<cfelseif isdefined("delimage")>
		<cfset serverbildname = "">
	<cfelse>
		<cfset serverbildname = form.origbild>
	</cfif>
	
	<!--- dokument upload  --->
	<!--- wenn ein doc ausgewählt wurde --->
	<cfif form.doc NEQ "">
		<!--- doc auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="doc" destination="#remoteServerPath##session.serverpath#\upload\doc\" nameconflict="makeunique">
		<!--- 	serverdocname in variable speichen --->
		<cfset serverdocname = cffile.serverfile>
	<cfelseif isdefined("deldoc")>
		<cfset serverdocname = "">
	<cfelse>
		<cfset serverdocname = form.origdoc>
	</cfif>
	
	<cfquery name="updateContent" datasource="#application.dsn#">
		UPDATE	content
		SET		pageid = #form.pageID#,
				isactive = #form.active#,
				modifydate = #createODBCdatetime(now())#,
				titel = '#form.titel#',
				lead = '#form.lead#',
				fliesstext = '#form.text#',
				bildname = '#serverbildname#',
				href = '#form.link#',
				hreflabel = '#form.linklabel#',
				doc = '#serverdocname#',
				doclabel = '#form.doclabel#',
				hascontact = #form.hascontact#
		WHERE	id = #form.contentid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- content löschen --->
<cfif isdefined("url.delcontent") AND isNumeric(url.delcontent) AND url.delcontent GT 0>
	<cfquery name="delcontent" datasource="#application.dsn#">
	DELETE
	FROM	content
	WHERE	id = #url.delcontent#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Seiten darstellen mit eingerückten kindern --->
<table width="100%">
<tr>
	<td colspan="2" id="gray1"><h4>Seite / Unterseite</h4></td>
	
	<td colspan="3" id="gray2"><h4>Navigation</h4></td>
	
	<td id="gray3"> <h4>Seiteninhalt</h4></td>
	
</tr>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Nav-Pos.</strong></td>
	<td><strong>Bearbeiten</strong></td>
	<td><strong>Löschen</strong></td>
	<td><strong>bearbeiten</strong></td>
</tr>
<cfoutput query="getRootPages">
<cfquery name="getContentsByPageID" datasource="#application.dsn#">
SELECT	*
FROM	content
WHERE	pageid = #id#
</cfquery>
<tr>
	<td>#pagetitel#</td>
	<td>
		<cfif isactive EQ 1>
			<div id="activ">aktiv </div>
		<cfelse>
			<div id="inactiv">inaktiv </div>
		</cfif>
	</td>
	<td>
		<cfif navpos EQ 0>Service-Navigation<cfelse>Themennavigation</cfif>
	</td>
	<td>
		<a href="#cgi.SCRIPT_NAME#?editpage=#id#">
			bearbeiten
		</a>
	</td>
	<td>
		<a href="#cgi.SCRIPT_NAME#?delpage=#id#" onclick="return confirm('Sind Sie sicher?');">
			löschen
		</a>
	</td>
	<td>
		<cfif getContentsByPageID.recordcount GT 0>
		<a href="javascript:$('##inhalte#id#').toggle();void(0);">
			Inhalte
		</a>
		<cfelse>
		<a href="#cgi.SCRIPT_NAME#?action=addContent&pageID=#id#">
			Inhalt +
		</a>
		</cfif>
	</td>
</tr>

<cfif getContentsByPageID.recordcount GT 0>
<tr>
	<td colspan="6">
		<div style="display:none;background-color:##e1e1e1;" id="inhalte#id#">
			<table>
			<cfloop query="getContentsByPageID">
			<tr>
				<td>#titel#</td>
				<td>
					<a href="#cgi.SCRIPT_NAME#?delcontent=#id#" onclick="return confirm('Sind Sie sicher?');">
						löschen
					</a>
				</td>
				<td>
					<a href="#cgi.SCRIPT_NAME#?editcontent=#id#">
						bearbeiten
					</a>
				</td>
			</tr>
			</cfloop>
			</table>
		</div>
	</td>
</tr>
</cfif>
<!---  mögliche kinder abfragen , dafür einen weiteren loop  --->
<cfquery name="getChildPages" datasource="#application.dsn#">
SELECT	*
FROM	pages
WHERE	parentID = #id# AND
		mandant = '#session.serverpath#'
ORDER	BY navorder 
</cfquery>
<!---  wenn resultset grösser 0 dann loope durch die kinder und zeige diese eingerückt  --->
<cfif getChildPages.recordcount GT 0>
<cfloop query="getChildPages">
<cfquery name="getContentsByChildPageID" datasource="#application.dsn#">
SELECT	*
FROM	content
WHERE	pageid = #getChildPages.id#
</cfquery>
	<tr>
		<td style="padding-left:30px;"> &lfloor; #pagetitel#</td>
		<td>
			<cfif isactive EQ 1>
			<div id="activ">aktiv</div>	
			<cfelse>
			 <div id="inactiv">inaktiv</div>	
			</cfif>
		</td>
		<td>&nbsp;
			
		</td>

		<td>
			<a href="#cgi.SCRIPT_NAME#?editpage=#id#">
				bearbeiten
			</a>
		</td>	
		<td>
			<a href="#cgi.SCRIPT_NAME#?delpage=#id#" onclick="return confirm('Sind Sie sicher?');">
				löschen
			</a>
		</td>
		<td>
			<cfif getContentsByChildPageID.recordcount GT 0>
			<a href="javascript:$('##inhalte#id#').toggle();void(0);">
				Inhalte
			</a>
			<cfelse>
			<a href="#cgi.SCRIPT_NAME#?action=addContent&pageID=#id#">
				Inhalt +
			</a>
			</cfif>
		</td>
	</tr>
	<cfif getContentsByChildPageID.recordcount GT 0>
	<tr>
		<td colspan="6">
			<div style="display:none;background-color:##e1e1e1;margin-left:30px;" id="inhalte#id#">
				<table>
				<cfloop query="getContentsByChildPageID">
				<tr>
					<td>#titel#</td>
					<td>
						<a href="#cgi.SCRIPT_NAME#?delcontent=#id#" onclick="return confirm('Sind Sie sicher?');">
							löschen
						</a>
					</td>
					<td>
						<a href="#cgi.SCRIPT_NAME#?editcontent=#id#">
							bearbeiten
						</a>
					</td>
				</tr>
				</cfloop>
				</table>
			</div>
		</td>
	</tr>
	</cfif>
</cfloop>
</cfif>
</cfoutput>
</table>
<br/>

<!--- dies erscheint nur wenn neue page hinzufügen gewählt wurde --->
<cfoutput>
<cfif isdefined("url.action") AND url.action EQ "addPage">
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewPage" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td>Titel</td>
		<td><input type="text" name="pagetitel" <cfif isdefined("form.pagetitel")>value="#form.pagetitel#"</cfif>></td>
	</tr>
	<tr>
		<td>URL-Shortcut</td>
		<td><input type="text" name="urlshortcut" <cfif isdefined("form.urlshortcut")>value="#form.urlshortcut#"</cfif>></td>
	</tr>
	<tr>
		<td>Navigations Position</td>
		<td>
			<input type="radio" name="navPos" value="0" checked="checked"> servicenavigation  &nbsp; &nbsp;
			<input type="radio" name="navPos" value="1"> themennavigation
		</td>
	</tr>
	<tr>
		<td>Navigations Titel</td>
		<td><input type="text" name="navTitel" <cfif isdefined("form.navTitel")>value="#form.navTitel#"</cfif>></td>
	</tr>
	<tr>
		<td>Meta Titel</td>
		<td><input type="text" name="metaTitel" <cfif isdefined("form.metaTitel")>value="#form.metaTitel#"</cfif>></td>
	</tr>
	<tr>
		<td>Meta Keywords</td>
		<td><input type="text" name="metaKeys" <cfif isdefined("form.metaKeys")>value="#form.metaKeys#"</cfif>></td>
	</tr>
	<tr>
		<td>Meta Description</td>
		<td>
<textarea name="metaDesc" rows="1" cols="1" style="width:50%;height:50px;"><cfif isdefined("form.metaDesc")>#form.metaDesc#</cfif></textarea>
		</td>
	</tr>
	<tr>
		<td>Reihenfolge</td>
		<td><input type="text" name="order" <cfif isdefined("form.order")>value="#form.order#"</cfif>></td>
	</tr>
	<tr>
		<td>Trägerseite</td>
		<td>
			<select name="parentID">
				<option value="0">Oberste Ebene</option>
				
					<cfloop query="getRootPages">
						<option value="#ID#">#Pagetitel#</option>
					</cfloop>
				
			</select>
		</td>
	</tr>
	<tr>
		<td>Headerpanel</td>
		<td>
			<input type="file" name="headerbild">
		</td>
	</tr>
	<tr>
		<td>Template</td>
		<td>
			<input type="radio" name="template" value="1" checked="checked"> Template 1  &nbsp; &nbsp;
			<input type="radio" name="template" value="2"> Template 2
			<input type="radio" name="template" value="3"> Template 3 &nbsp; &nbsp;
		</td>
	</tr>
	<tr>
		<td>Template Farbschmema</td>
		<td>
			<input type="radio" name="templatecolor" value="1" checked="checked"> Farbschema rot  &nbsp; &nbsp;
			<input type="radio" name="templatecolor" value="2"> Farbschema blau &nbsp;&nbsp;
			<input type="radio" name="templatecolor" value="3"> Farbschmema grün &nbsp; &nbsp;
		</td>
	</tr>
	<tr>
		<td valign="top">Sidebar Elemente</td>
		<td>
			<cfquery name="getSidebars" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar
			WHERE	parentuser = '#session.serverpath#' AND
					isActive = 1
			</cfquery>
			<table width="100%">
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
			<cfloop query="getSidebars">
			<tr>
				<td width="40">
					<input type="checkbox" name="sidebar#counter#" value="#id#" />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="order#counter#" style="width:40px;" />
				</td>
			</tr>
			<cfset counter = counter + 1 />
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Seite erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editPage")>
	<a href="#cgi.SCRIPT_NAME#?action=addPage">neue Seite erfassen</a>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn Seite bearbeiten gewählt wurde --->
<cfif isdefined("url.editPage") AND isNumeric(url.editPage) AND url.editPage GT 0>
<cfoutput query="editPage">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedPage" method="post" enctype="multipart/form-data">
	<table width="100%">
		<tr>
			<td>
				Last Update
			</td>
			<td>
				<cfquery name="getUpdateUser" datasource="#application.dsn#">
				SELECT 	* 
				FROM 	user
				WHERE 	id = #parentuser#
				</cfquery>
			
				by #getUpdateUser.vorname# #getUpdateUser.name#, #lsdateFormat(modifydate,'DDDD, dd.mm.yyyy')# - #timeformat(modifydate,'HH:mm')#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>Titel</td>
		<td><input type="text" name="pagetitel" value="#pagetitel#"></td>
	</tr>
	<tr>
		<td>URL-Shortcut</td>
		<td><input type="text" name="urlshortcut" <cfif urlshortcut NEQ "">value="#urlshortcut#"</cfif>></td>
	</tr>
	<cfif parentID EQ 0>
	<tr>
		<td>Navigations Position</td>
		<td>
			<input type="radio" name="navPos" value="0" <cfif navpos EQ 0>checked="checked"</cfif>> servicenavigation  &nbsp; &nbsp;
			<input type="radio" name="navPos" value="1" <cfif navpos EQ 1>checked="checked"</cfif>> themennavigation
		</td>
	</tr>
	<cfelse>
	<input type="hidden" name="navpos" value="0" />
	</cfif>
	<tr>
		<td>Navigations Titel</td>
		<td><input type="text" name="navTitel" value="#navTitel#"></td>
	</tr>
	<tr>
		<td>Meta Titel</td>
		<td><input type="text" name="metaTitel" value="#metaTitel#"></td>
	</tr>
	<tr>
		<td>Meta Keywords</td>
		<td><input type="text" name="metaKeys" value="#metaKeys#"></td>
	</tr>
	<tr>
		<td>Meta Description</td>
		<td>
<textarea name="metaDesc" rows="1" cols="1" style="width:50%;height:50px;">#metaDesc#</textarea>
		</td>
	</tr>
	<tr>
		<td>Reihenfolge</td>
		<td><input type="text" name="reihenfolge" value="#navorder#"></td>
	</tr>
	<tr>
		<td>Trägerseite</td>
		<td>
			<cfset t = parentid />
			<select name="parentID">
				<option value="0" <cfif t EQ 0>selected="selected"</cfif>>Oberste Ebene</option>
				<cfloop query="getRootPages">
					<cfif id NEQ editPage.id>
						<option value="#ID#"<cfif t EQ id>selected="selected"</cfif>>#Pagetitel#</option>
					</cfif>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td>Headerbild</td>
		<td>
			<cfif headerbild NEQ "">
			Momentanes Headerbild auf dem Server2: <a href="#session.serverpath#/upload/img/#headerbild#" target="_blank">#headerbild#</a><br/>
			<input type="checkbox" name="delimage" value="#headerbild#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="headerbild">
			<input type="hidden" name="origbild" value="#headerbild#" />
		</td>
	</tr>
	<tr>
		<td>Template</td>
		<td>
			<input type="radio" name="template" value="1" <cfif template EQ 1>checked="checked"</cfif>> Template 1  &nbsp; &nbsp;
			<input type="radio" name="template" value="2" <cfif template EQ 2>checked="checked"</cfif>> Template 2 &nbsp;&nbsp;
			<input type="radio" name="template" value="3" <cfif template EQ 3>checked="checked"</cfif>> Template 3 &nbsp; &nbsp;
		</td>
	</tr>
	<tr>
		<td>Template Farbschmema</td>
		<td>
			<input type="radio" name="templatecolor" value="1" <cfif templatecolorschema EQ 1>checked="checked"</cfif>> Farbschema rot  &nbsp; &nbsp;
			<input type="radio" name="templatecolor" value="2" <cfif templatecolorschema EQ 2>checked="checked"</cfif>> Farbschema blau &nbsp;&nbsp;
			<input type="radio" name="templatecolor" value="3" <cfif templatecolorschema EQ 3>checked="checked"</cfif>> Farbschmema grün &nbsp; &nbsp;
		</td>
	</tr>
	<tr>
		<td valign="top">Sidebar Elemente</td>
		<td>
			<cfquery name="getSidebars" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar
			WHERE	parentuser = '#session.serverpath#' AND
					isActive = 1
			</cfquery>
			<table width="100%">
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
			<cfloop query="getSidebars">
			<cfquery name="getSidebarPerPage" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar2pages
			WHERE	pageid = #url.editpage# AND 
					sidebarID = #id#
			</cfquery>
			<tr>
				<td width="40">
					<input type="checkbox" name="sidebar#counter#" value="#id#" <cfif getSidebarPerPage.recordcount EQ 1>checked="checked"</cfif> />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="order#counter#" style="width:40px;" <cfif getSidebarPerPage.recordcount EQ 1>value="#getSidebarPerPage.reihenfolge#"</cfif> />
				</td>
			</tr>
			<cfset counter = counter + 1 />
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td><input type="hidden" name="pageID" value="#id#"></td>
		<td><input type="submit" value="Seite ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>


<br><br>
<cfif isdefined("url.action") AND url.action EQ "addContent">
	<cfinclude template="inc_addContent.cfm" />
</cfif>

<cfif isdefined("url.editcontent") AND isNumeric(url.editcontent) AND url.editcontent GT 0>
	<cfinclude template="inc_editContent.cfm" />
</cfif>

