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
	<cfset flexyLib = createObject('component','admin.cfc.flexy') />
	<cfset deletePage = flexylib.deleteEntirePage(delpage=url.delpage) />
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- Page kopieren --->
<cfif isdefined("url.action") AND url.action EQ "copyPage">

</cfif>
<!--- Inhalt kopieren --->
<cfif isdefined("url.action") AND url.action EQ "copyContent">

</cfif>

<!--- I STRUKTUR   1. Neue page hinzufügen --->
<!--- ------------------------------------ --->
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
				<!--- <cfset ImageCrop(myImage,0,0,960,200)>
				<!--- Write the result to a file. --->
				<cfimage source="#myImage#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes"> --->
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
		<!--- schauen ob gecheckte teaser unten übermittelt wurden --->
		<cfif form.fieldnames contains 'teaser'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine sidebar gefunden wurde... --->
				<cfif i contains "teaser">
					<!--- ergänze (bis jetzt leere) sidebar-liste mit form-namen --->
					<cfset sidebarList = ListAppend(sidebarList,i) />
					<!--- evaluiere formfeld ORDER  --->
					<cfset reihenfolge = replaceNoCase(i,'teaser','reihenfolge') />
					<!--- speichere sidebar ID in variable --->
					<cfset sidebarID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<!--- in zwischentabelle schreiben --->
					<cfquery name="insertSidebar2Pages" datasource="#application.dsn#">
					INSERT
					INTO	teaser2pages(pageid,sidebarid,reihenfolge)
					VALUES(
						#getLatestID.lastID#,
						#sidebarID#,
						#orderx#		
					)
					</cfquery>					
				</cfif>
			</cfloop>
		</cfif>
		<!--- schauen ob gecheckte teaser unten übermittelt wurden --->
		<cfif form.fieldnames contains 'headerpanel'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine sidebar gefunden wurde... --->
				<cfif i contains "headerpanel">
					<!--- ergänze (bis jetzt leere) sidebar-liste mit form-namen --->
					<cfset sidebarList = ListAppend(sidebarList,i) />
					<!--- evaluiere formfeld ORDER  --->
					<cfset reihenfolge = replaceNoCase(i,'headerpanel','sort') />
					<!--- speichere sidebar ID in variable --->
					<cfset headerpanelID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<!--- in zwischentabelle schreiben --->
					<cfquery name="insertSidebar2Pages" datasource="#application.dsn#">
					INSERT
					INTO	headerpanels2pages(pageid,headerpanelID,reihenfolge)
					VALUES(
						#getLatestID.lastID#,
						#headerpanelID#,
						#orderx#		
					)
					</cfquery>					
				</cfif>
			</cfloop>
		</cfif>
	
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	</cfif>

<!--- 2. bestehende page updaten --->
<!--- -------------------------- --->

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
				<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" name="myImage2">
				<!--- Crop myImage to 100x100 pixels starting at the coordinates (10,10).--->
				<!--- <cfset ImageCrop(myImage2,0,0,960,200)>
				<!--- Write the result to a file. --->
				<cfimage source="#myImage2#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes"> --->
			</cfif>
		<cfelseif not isdefined("form.delimage")>
			<cfset serverbildname = form.origbild>
		<cfelse>
			<!--- <cfset serverbildname = "">  --->
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
						<cfif orderx EQ "">10<cfelse>#orderx#</cfif>	
					)
					</cfquery>					
				</cfif>
			</cfloop>
		</cfif>
		
		<cfquery name="deleteAllPreviousSidebarEntries" datasource="#application.dsn#">
		DELETE
		FROM	teaser2pages
		WHERE	pageid = #form.pageID#
		</cfquery>
		
		<!--- hier werden nun alle aktualisierten einträge eruiert und wiederum gespeichert --->
		<!--- schauen ob gecheckte teasers übermittelt wurden --->
		<cfif form.fieldnames contains 'teaser'>
			<!--- leere liste mit teasers-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine teasers gefunden wurde... --->
				<cfif i contains "teaser">
					<!--- ergänze (bis jetzt leere) teasers-liste mit form-namen --->
					<cfset sidebarList = ListAppend(sidebarList,i) />
					<!--- evaluiere formfeld REIHENFOLGE  --->
					<cfset reihenfolge = replaceNoCase(i,'teaser','reihenfolge') />
					<!--- speichere sidebar ID in variable --->
					<cfset sidebarID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<!--- in zwischentabelle schreiben --->
					<cfquery name="insertSidebar2Pages" datasource="#application.dsn#">
					INSERT 
					INTO	teaser2pages(pageid,sidebarid,reihenfolge)
					VALUES(
						#form.pageID#,
						#sidebarID#,
						<cfif orderx EQ "">10<cfelse>#orderx#</cfif>		
					)
					</cfquery>					
				</cfif>
			</cfloop>
			
		</cfif>
		
		<!--- alle bestehenden einträge aus der zw-tabelle löschen --->
		<cfquery name="deleteAllPreviousSidebarEntries" datasource="#application.dsn#">
		DELETE
		FROM	headerpanels2pages
		WHERE	pageid = #form.pageID#
		</cfquery>
		<!--- schauen ob gecheckte teasers übermittelt wurden --->
		<cfif form.fieldnames contains 'headerpanel'>
			<!--- leere liste mit teasers-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine teasers gefunden wurde... --->
				<cfif i contains "headerpanel">
					<!--- ergänze (bis jetzt leere) teasers-liste mit form-namen --->
					<cfset sidebarList = ListAppend(sidebarList,i) />
					<!--- evaluiere formfeld REIHENFOLGE  --->
					<cfset reihenfolge = replaceNoCase(i,'headerpanel','sort') />
					<!--- speichere sidebar ID in variable --->
					<cfset headerpanelid = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<!--- in zwischentabelle schreiben --->
					
					<cfquery name="insertSidebar2Pages" datasource="#application.dsn#">
					INSERT 
					INTO	headerpanels2pages(pageid,headerpanelid,reihenfolge)
					VALUES(
						#form.pageID#,
						#headerpanelid#,
						<cfif orderx EQ "">10<cfelse>#orderx#</cfif>	
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
				hasContact,
				albumID,
				
				contactType,
				contactReciever,
				contactSender,
				contactSubject,
				
				customInclude,
				imagePos,
				reihenfolge,
				imagecaption,
				fliesstextspalten
				)
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
				#form.hascontact#,
				#form.album#,
				
				#form.formtype#,
				'#form.reciever#',
				'#form.sender#',
				'#form.subject#',
				
				'#form.custominclude#',
				#form.imagepos#,
				#form.reihenfolge#,
				'#form.imagecaption#',
				#form.columns#
		)
		</cfquery>
		
		<cfquery name="getMaxID" datasource="#application.dsn#">
		SELECT	MAX(id) as maxi
		FROM	content
		</cfquery>
		
		
		<!--- weitere links --->
		<!--- first delete all previous link in zwischentabelle --->
		<cfloop from="2" to="50" index="i">
			<!--- wenn neu hinzugefügter link übermittelt wird, durch alle loopen und in db eintragen --->
			<cfif isdefined("form.link" & i)>
				<cfquery name="insertAddedLink" datasource="#application.dsn#">
				INSERT 	
				INTO	links2pages(
							href,
							hreflabel,
							contentid
						)
				VALUES(
					'#evaluate("form.link" & i)#',
					'#evaluate("form.linklabel" & i)#',
					#getMaxID.maxi#
				)
				</cfquery>
			</cfif>
		</cfloop>
		<!--- delete all empty href-fields from db from this contentID --->
		<cfquery name="delLink" datasource="#application.dsn#">
		DELETE
		FROM	links2pages
		WHERE	contentid = #getMaxID.maxi# AND
				(href = '' OR href IS NULL)
		</cfquery>
		
		
		<!--- weitere doks --->
		<cfloop from="2" to="50" index="i">
			<!--- wenn neu hinzugefügtes dokument übermittelt wird, upload und durch alle loopen und in db eintragen --->
			<cfif isdefined("form.doc" & i) AND evaluate("form.doc" & i) NEQ "" AND not isdefined("form.origdoc" & i)>
				<cffile action="upload" filefield="doc#i#" destination="#remoteServerPath##session.serverpath#\upload\doc\" nameconflict="makeunique">
				<cfset serverdocsizeadded = cffile.fileSize>
				<cfset serverdocnameadded = cffile.serverfile>
				<cfquery name="insertAddedDok" datasource="#application.dsn#">
				INSERT 	
				INTO	docs2pages(
							dok,
							doklabel,
							size,
							contentid
						)
				VALUES(
					'#serverdocnameadded#',
					'#evaluate("form.doclabel" & i)#',
					#serverdocsizeadded#,
					#getMaxID.maxi#
				)
				</cfquery>
			</cfif>
		</cfloop>
		
		
		<!--- weitere verlinkte inhaltselemente --->
		<cfif isdefined("form.contentLinkID")>
			<!--- first delete all previous links
			<cfquery name="delLinkedContent" datasource="#application.dsn#">
			DELETE
			FROM	contents2content
			WHERE	mainContentID = #getMaxID.maxi#
			</cfquery> --->
			<cfloop list="#form.contentLinkID#" index="i">
				<cfquery name="insertLinkedContent" datasource="#application.dsn#">
				INSERT
				INTO	contents2content(mainContentID,linkedContentID)
				VALUES(
						#getMaxID.maxi#,
						#i#
				)
				</cfquery>
			</cfloop>
		</cfif>

		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>


<!---II CONTENT der page ändern / updaten --->
<!--- ----------------------------------- --->

<cfif isdefined("url.action") AND url.action EQ "submittedEditedContent">
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
	
	<!--- weitere doks --->
	<cfquery name="delAllDocs" datasource="#application.dsn#">
	DELETE
	FROM	docs2pages
	WHERE	contentid = #form.contentid#
	</cfquery>
	<cfloop from="2" to="50" index="i">
		<!--- wenn neu hinzugefügtes dokument übermittelt wird, upload und durch alle loopen und in db eintragen --->
		<cfif isdefined("form.doc" & i) AND evaluate("form.doc" & i) NEQ "" AND not isdefined("form.origdoc" & i)>
			<cffile action="upload" filefield="doc#i#" destination="#remoteServerPath##session.serverpath#\upload\doc\" nameconflict="makeunique">
			<cfset serverdocsizeadded = cffile.fileSize>
			<cfset serverdocnameadded = cffile.serverfile>
			<cfquery name="insertAddedDok" datasource="#application.dsn#">
			INSERT 	
			INTO	docs2pages(
						dok,
						doklabel,
						size,
						contentid
					)
			VALUES(
				'#serverdocnameadded#',
				'#evaluate("form.doclabel" & i)#',
				#serverdocsizeadded#,
				#form.contentid#
			)
			</cfquery>
		</cfif>
		<!--- wenn bestehdnes dok löschen und kein neues uploaden --->
		<cfif isdefined("form.origdoc" & i) AND isdefined("form.deldoc" & i) AND evaluate("form.doc" & i) EQ "">
			<cfquery name="insertAddedDok" datasource="#application.dsn#">
			DELETE
			FROM	docs2pages
			WHERE	contentid = #form.contentid# AND
					dok = '#evaluate("form.origdoc" & i)#'
			</cfquery>
			<!--- physikalisch löschen  --->
			<cfif fileExists(expandPath('/' & session.serverpath & '/upload/doc/' & evaluate('form.origdoc' & i)))>
				<cffile action="delete" file="#expandPath('/' & session.serverpath & '/upload/doc/' & evaluate('form.origdoc' & i))#" />
			</cfif>
		<!--- update label --->
		<cfelseif isdefined("form.origdoc" & i) AND NOT isdefined("form.deldoc" & i) AND evaluate("form.doc" & i) EQ "">
			<cfquery name="insertAddedDok" datasource="#application.dsn#">
			INSERT 	
			INTO	docs2pages(
						dok,
						doklabel,
						size,
						contentid
					)
			VALUES(
				'#evaluate("form.origdoc" & i)#',
				'#evaluate("form.doclabel" & i)#',
				#evaluate("form.size" & i)#,
				#form.contentid#
			)
			</cfquery>
		</cfif>
	</cfloop>
	
	
	<!--- weitere links --->
	<!--- first delete all previous link in zwischentabelle --->
	<cfquery name="insertAddedDok" datasource="#application.dsn#">
	DELETE
	FROM	links2pages
	WHERE	contentid = #form.contentid#
	</cfquery>
	<cfloop from="2" to="50" index="i">
		<!--- wenn neu hinzugefügter link übermittelt wird, durch alle loopen und in db eintragen --->
		<cfif isdefined("form.link" & i)>
			<cfquery name="insertAddedLink" datasource="#application.dsn#">
			INSERT 	
			INTO	links2pages(
						href,
						hreflabel,
						contentid
					)
			VALUES(
				'#evaluate("form.link" & i)#',
				'#evaluate("form.linklabel" & i)#',
				#form.contentid#
			)
			</cfquery>
		</cfif>
	</cfloop>
	<!--- delete all empty href-fields from db from this contentID --->
	<cfquery name="delLink" datasource="#application.dsn#">
	DELETE
	FROM	links2pages
	WHERE	contentid = #form.contentid# AND
			(href = '' OR href IS NULL)
	</cfquery>
	
	
	<!--- weitere verlinkte inhaltselemente --->
	<cfif isdefined("form.contentLinkID")>
		<!--- first delete all previous links--->
		<cfquery name="delLinkedContent" datasource="#application.dsn#">
		DELETE
		FROM	contents2content
		WHERE	mainContentID = #form.contentid#
		</cfquery> 
		<cfloop list="#form.contentLinkID#" index="i">
			<cfquery name="insertLinkedContent" datasource="#application.dsn#">
			INSERT
			INTO	contents2content(mainContentID,linkedContentID)
			VALUES(
					#form.contentid#,
					#i#
			)
			</cfquery>
		</cfloop>
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
				hascontact = #form.hascontact#,
				albumid = #form.album#,
				
				contactType = #form.formtype#,
				contactReciever = '#form.reciever#',
				contactSender = '#form.sender#',
				contactSubject = '#form.subject#',
				
				customInclude = '#form.customInclude#',
				imagePos = #form.imagepos#,
				reihenfolge = #form.reihenfolge#,
				imagecaption = '#form.imagecaption#',
				fliesstextspalten = #form.columns#
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