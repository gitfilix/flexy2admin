<!--- -------------- form prozessors ------------------ --->
<cfprocessingdirective pageencoding="utf-8" />

<!--- alle pages auslesen der Navigation von level0 von themen- und servicenavigation ohne kinder (kinder= parentID > 0)--->
<cfquery name="getRootPages" datasource="#application.dsn#">
SELECT	*
FROM	pages
WHERE	parentID = 0 AND
		mandant = #session.mandant# AND
		lang = '#session.lang#'
ORDER	BY navpos, navorder 
</cfquery>

<!--- get 4 of 5 levels --->
<cfquery name="getAll4Levels" datasource="#application.dsn#">
SELECT	P.id as pid, P.pagetitel as ppagetitel,P.parentID as pparentid,P.navorder as pnavorder,P.navpos as pnavpos,P.isActive as pisactive,P.template as ptemplate,P.templatecolorschema as ptemplatecolorschema,
		Pa.id as paid, Pa.pagetitel as papagetitel,Pa.parentID as paparentid,Pa.navorder as panavorder,Pa.navpos as panavpos,Pa.isActive as paisactive,Pa.template as patemplate,Pa.templatecolorschema as patemplatecolorschema,
		Pb.id as pbid, Pb.pagetitel as pbpagetitel,Pb.parentID as pbparentid,Pb.navorder as pbnavorder,Pb.navpos as pbnavpos,Pb.isActive as pbisactive,Pb.template as pbtemplate,Pb.templatecolorschema as pbtemplatecolorschema,
		Pc.id as pcid, Pc.pagetitel as pcpagetitel,Pc.parentID as pcparentid,Pc.navorder as pcnavorder,Pc.navpos as pcnavpos,Pc.isActive as pcisactive,Pc.template as pctemplate,Pc.templatecolorschema as pctemplatecolorschema
FROM	((pages P LEFT JOIN 
		pages Pa ON Pa.parentID = P.id) LEFT JOIN
		pages Pb ON Pb.parentID = pa.id) LEFT JOIN
		pages Pc ON Pc.parentID = pb.id
WHERE	P.parentID = 0 AND
		P.mandant = #session.mandant# AND
		P.lang = '#session.lang#'
ORDER	BY P.navpos, P.id, Pa.id, Pb.id, Pc.id
</cfquery>

<!--- get 5 of 5 levels --->
<cfquery name="getAll5Levels" datasource="#application.dsn#">
SELECT	P.id as pid, P.pagetitel as ppagetitel,P.parentID as pparentid,P.navorder as pnavorder,P.navpos as pnavpos,P.isActive as pisactive,P.template as ptemplate,P.templatecolorschema as ptemplatecolorschema,
		Pa.id as paid, Pa.pagetitel as papagetitel,Pa.parentID as paparentid,Pa.navorder as panavorder,Pa.navpos as panavpos,Pa.isActive as paisactive,Pa.template as patemplate,Pa.templatecolorschema as patemplatecolorschema,
		Pb.id as pbid, Pb.pagetitel as pbpagetitel,Pb.parentID as pbparentid,Pb.navorder as pbnavorder,Pb.navpos as pbnavpos,Pb.isActive as pbisactive,Pb.template as pbtemplate,Pb.templatecolorschema as pbtemplatecolorschema,
		Pc.id as pcid, Pc.pagetitel as pcpagetitel,Pc.parentID as pcparentid,Pc.navorder as pcnavorder,Pc.navpos as pcnavpos,Pc.isActive as pcisactive,Pc.template as pctemplate,Pc.templatecolorschema as pctemplatecolorschema,
		Pd.id as pdid, Pd.pagetitel as pdpagetitel,Pd.parentID as pdparentid,Pd.navorder as pdnavorder,Pd.navpos as pdnavpos,Pd.isActive as pdisactive,Pd.template as pdtemplate,Pd.templatecolorschema as pdtemplatecolorschema
FROM	(((pages P LEFT JOIN 
		pages Pa ON Pa.parentID = P.id) LEFT JOIN
		pages Pb ON Pb.parentID = pa.id) LEFT JOIN
		pages Pc ON Pc.parentID = pb.id) LEFT JOIN
		pages Pd ON Pd.parentID = pc.id
WHERE	P.parentID = 0 AND
		P.mandant = #session.mandant# AND
		P.lang = '#session.lang#'
ORDER	BY P.navpos, P.id, Pa.id, Pb.id, Pc.id, Pd.id
</cfquery>

<!--- anzahl berechtigter level eruieren --->
<cfquery name="getAllowdLevels" datasource="#application.dsn#">
SELECT	navlevels
FROM	mandanten
WHERE	id = #session.mandant#
</cfquery>
<cfset anzahlLevels = getAllowdLevels.navlevels />

<!--- page löschen --->
<cfif isdefined("url.delPage") AND isNumeric(url.delPage) AND url.delPage GT 0>
	<cfquery name="getStartpages" datasource="#application.dsn#">
	SELECT	*
	FROM	langstartpages2mandanten
	WHERE	startpage = #url.delpage# AND
			mandant = #session.mandant#
	</cfquery>
	<!--- wenn die page die startseite ist, dann kann sie nicht gelöscht werden --->
	<cfif getStartpages.recordcount EQ 0>
		<!--- init component --->
		<cfset flexyLib = createObject('component','admin.cfc.flexy') />
		<!--- execute method --->
		<cfset delPage = flexyLib.deleteEntirePage(delpage=url.delPage) />
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	<cfelse>
		Diese Seite kann nicht gelöscht werden, solange sie als Startseite benötigt wird. <br/>
		Um dies zu beheben wählen Sie im Modul SETTINGS eine andere Startseite!
		<cfabort>
	</cfif>
</cfif>
<!--- Page kopieren --->
<cfif isdefined("url.copyPage") AND isNumeric(url.copyPage)>
	<!--- init component --->
	<cfset flexyLib = createObject('component','admin.cfc.flexy') />
	<!--- execute method --->
	<cfset copyNow = flexyLib.copyPageByID(pageid=url.copyPage) />
	<!--- redirect to get rid of the url-parameter --->
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- Inhalt kopieren --->
<cfif isdefined("url.copyContent") AND isNumeric(url.copyContent)>
	<!--- init component --->
	<cfset flexyLib = createObject('component','admin.cfc.flexy') />
	<!--- execute method --->
	<cfset copyNow = flexyLib.copyContentByID(contentid=url.copyContent) />
	<!--- redirect to get rid of the url-parameter --->
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
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
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes">
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
		INTO	pages (parentUser, createdate, isactive, navPos, navTitel, pageTitel, metaTitel, metaKeys, metaDesc, parentID, navorder, headerbild, template, mandant, urlshortcut, templatecolorschema,lang,showAllNews,showTeam)
		VALUES(
			#session.UserID#,
			#createODBCDateTime(now())#,
			<cfif NOT isdefined("form.active")>0<cfelse>#form.active#</cfif>,
			<cfif NOT isdefined("form.navPos")>1<cfelse>#form.navPos#</cfif>,
			'#form.navTitel#',
			'#form.pageTitel#',
			'#form.metaTitel#',
			'#form.metaKeys#',
			'#form.metaDesc#',
			#form.parentID#,
			<cfif isdefined("form.order") AND form.order NEQ "">#form.order#<cfelse>NULL</cfif>,
			'#serverbildname#',
			<cfif NOT isdefined("form.template")>1<cfelse>#form.template#</cfif>,
			#session.mandant#,
			'#form.urlshortcut#',
			#form.templatecolor#,
			'#session.lang#',
			<cfif NOT isdefined("form.showAllNews")>0<cfelse>#form.showAllNews#</cfif>,
			<cfif NOT isdefined("form.showTeam")>0<cfelse>#form.showTeam#</cfif>
		)
		</cfquery>
		<!--- neuste generierte ID auslesen --->
		<cfquery name="getLatestID" datasource="#application.dsn#">
		SELECT MAX(id) as lastID from pages
		WHERE mandant = #session.mandant#
		</cfquery>
		<!--- schauen ob gecheckte sidebars übermittelt wurden --->
		<cfif form.fieldnames contains 'sidebar'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset sidebarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfset order = 10 />
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
					<cfif orderx EQ "">
						<cfset orderx = order />
					</cfif>
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
					<cfset order = order + 10 />							
				</cfif>
			</cfloop>
		</cfif>
		<!--- schauen ob gecheckte teaser unten übermittelt wurden --->
		<cfif form.fieldnames contains 'teaser'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset teaserbarList = "" />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfset order = 10 />
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine sidebar gefunden wurde... --->
				<cfif i contains "teaser">
					<!--- ergänze (bis jetzt leere) sidebar-liste mit form-namen --->
					<cfset teaserbarList = ListAppend(teaserbarList,i) />
					<!--- evaluiere formfeld ORDER  --->
					<cfset reihenfolge = replaceNoCase(i,'teaser','reihenfolge') />
					<!--- speichere sidebar ID in variable --->
					<cfset sidebarID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<cfif orderx EQ "">
						<cfset orderx = order />
					</cfif>
					
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
					<cfset order = order + 10 />			
				</cfif>
			</cfloop>
		</cfif>
		<!--- schauen ob gecheckte teaser unten übermittelt wurden --->
		<cfif form.fieldnames contains 'headerpanel'>
			<!--- leere liste mit sidebar-ids anlegen (jetzt noch leer) --->
			<cfset headerbarList = "" />
			<cfset order = 10 />
			<!--- durch alle übermittelten sidebar-checkboxen loopen --->
			<cfloop list="#form.fieldnames#" index="i">
				<!--- wenn eine sidebar gefunden wurde... --->
				<cfif i contains "headerpanel">
					<!--- ergänze (bis jetzt leere) sidebar-liste mit form-namen --->
					<cfset headerbarList = ListAppend(headerbarList,i) />
					<!--- evaluiere formfeld ORDER  --->
					<cfset reihenfolge = replaceNoCase(i,'headerpanel','sort') />
					<!--- speichere sidebar ID in variable --->
					<cfset headerpanelID = evaluate("form." & i) />
					<!--- speichere dazu assozierte reihenfolge in variable --->
					<cfset orderx = evaluate("form." & reihenfolge) />
					<cfif orderx EQ "">
						<cfset orderx = order />
					</cfif>
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
					<cfset order = order + 10 />				
				</cfif>
			</cfloop>
		</cfif>
		<!--- schauen ob gecheckte usergruppen übermittelt wurden --->
		<cfif form.fieldnames contains 'cuggroups'>
			<cfloop list="#form.cuggroups#" index="i">
				<cfquery name="insertCUGGroups" datasource="#application.dsn#">
				INSERT
				INTO	usergroups2pages(pageid,userGroupID)
				VALUES(
					#getLatestID.lastID#,
					#i#	
				)
				</cfquery>					
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
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes">
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
			<cfset serverbildname = "">
		</cfif>
		
		
		
		<cfquery name="updatePage" datasource="#application.dsn#">
		UPDATE	pages
		SET		parentUser = #session.userID#,
				modifydate = #createODBCdateTime(now())#,
				isactive = <cfif NOT isdefined("form.active")>0<cfelse>#form.active#</cfif>,
				navPos = <cfif NOT isdefined("form.navpos")>1<cfelse>#form.navPos#</cfif>,
				navTitel = '#form.navTitel#',
				pageTitel = '#form.pageTitel#',
				metaTitel = '#form.metaTitel#',
				metaKeys = '#form.metaKeys#',
				metaDesc = '#form.metaDesc#',
				parentID = #form.parentID#,
				navorder = <cfif form.reihenfolge NEQ "">#form.reihenfolge#<cfelse>10</cfif>,
				headerbild = '#serverbildname#',
				template = <cfif NOT isdefined("form.template")>1<cfelse>#form.template#</cfif>,
				urlshortcut = '#form.urlshortcut#',
				templatecolorschema = #form.templatecolor#,
				showAllNews = <cfif NOT isdefined("form.showAllNews")>0<cfelse>#form.showAllNews#</cfif>,
				showTeam = <cfif NOT isdefined("form.showTeam")>0<cfelse>#form.showTeam#</cfif>
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
		
		<!--- alle bestehenden einträge aus der zw-tabelle löschen --->
		<cfquery name="deleteAllPreviousCUGGroups" datasource="#application.dsn#">
		DELETE
		FROM	usergroups2pages
		WHERE	pageid = #form.pageID#
		</cfquery>
		<!--- schauen ob gecheckte usergruppen übermittelt wurden --->
		<cfif form.fieldnames contains 'cuggroups' AND form.parentid EQ 0>
			<cfloop list="#form.cuggroups#" index="i">
				<cfquery name="insertCUGGroups" datasource="#application.dsn#">
				INSERT
				INTO	usergroups2pages(pageid,userGroupID)
				VALUES(
					#form.pageID#,
					#i#	
				)
				</cfquery>					
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
			mandant = #session.mandant#
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
		<cfif bildbreite gt form.resizebild >
			<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" overwrite="yes">
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
				fliesstextspalten,
				albumtype,
				
				contactReturnMail,
				contactThanks
				)
		VALUES(
				#form.pageID#,
				<cfif not isdefined("form.active")>0<cfelse>#form.active#</cfif>,
				#createODBCdatetime(now())#,
				'#form.titel#',
				'#form.lead#',
				'#form.text#',
				'#serverbildname#',
				'#form.link#',
				'#form.linklabel#',
				'#serverdocname#',
				'#form.doclabel#',
				<cfif not isdefined("form.hascontact")>0<cfelse>#form.hascontact#</cfif>,
				#form.album#,
				
				<cfif not isdefined("form.formtype")>1<cfelse>#form.formtype#</cfif>,
				'#form.reciever#',
				'#form.sender#',
				'#form.subject#',
				
				'#form.custominclude#',
				<cfif not isdefined("form.imagepos")>0<cfelse>#form.imagepos#</cfif>,
				<cfif not isdefined("form.reihenfolge") OR form.reihenfolge EQ "">10<cfelse>#form.reihenfolge#</cfif>,
				'#form.imagecaption#',
				<cfif not isdefined("form.columns")>1<cfelse>#form.columns#</cfif>,
				<cfif not isdefined("form.albumtype")>3<cfelse>#form.albumtype#</cfif>,
				
				#form.returnmail#,
				'#form.thankstext#'
		)
		</cfquery>
		
		<cfquery name="getMaxID" datasource="#application.dsn#">
		SELECT	MAX(id) as maxi
		FROM	content
		</cfquery>
		
		
		<!--- weitere links --->
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
			<cfset cnt = 1 />
			<cfloop list="#form.contentLinkID#" index="i">
				<cfquery name="insertLinkedContent" datasource="#application.dsn#">
				INSERT
				INTO	contents2content(mainContentID,linkedContentID,reihenfolge)
				VALUES(
						#getMaxID.maxi#,
						#i#,
						<cfif listGetAt(form.contentLinkOrder,cnt) EQ "">10<cfelse>#listGetAt(form.contentLinkOrder,cnt)#</cfif>
				)
				</cfquery>
				<cfset cnt = cnt + 1 />
			</cfloop>
		</cfif>
		<!--- weitere verlinkte teaser-elemente --->
		<cfif isdefined("form.teaserID")>
			<!--- first delete all previous links
			<cfquery name="delLinkedContent" datasource="#application.dsn#">
			DELETE
			FROM	contents2content
			WHERE	mainContentID = #getMaxID.maxi#
			</cfquery> --->
			<cfset cnt = 1 />
			<cfloop list="#form.teaserID#" index="i">
				<cfquery name="insertContentTeasers" datasource="#application.dsn#">
				INSERT
				INTO	teaser2content(contentID,teaserID,reihenfolge)
				VALUES(
						#getMaxID.maxi#,
						#i#,
						<cfif listGetAt(form.teaserOrder,cnt) EQ "">10<cfelse>#listGetAt(form.teaserOrder,cnt)#</cfif>
				)
				</cfquery>
				<cfset cnt = cnt + 1 />
			</cfloop>
		</cfif>
		<!--- dont redirect if frontend-editing --->
		<cfif not isdefined("url.fromFEE")>
			<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
		</cfif>
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
		<cfif bildbreite gt form.resizebild >
			<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" overwrite="yes">
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
			<cfif fileExists('#remoteServerPath##session.serverpath#\upload\doc\' & evaluate('form.origdoc' & i))>
				<cffile action="delete" file="#remoteServerPath##session.serverpath#\upload\doc\#evaluate('form.origdoc' & i)#" />
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
		<cfset cnt = 1 />
		<cfloop list="#form.contentLinkID#" index="i">
			<cfquery name="insertLinkedContent" datasource="#application.dsn#">
			INSERT
			INTO	contents2content(mainContentID,linkedContentID,reihenfolge)
			VALUES(
					#form.contentid#,
					#i#,
					<cfif listGetAt(form.contentLinkOrder,cnt) EQ "">10<cfelse>#listGetAt(form.contentLinkOrder,cnt)#</cfif>
			)
			</cfquery>
			<cfset cnt = cnt + 1 />
		</cfloop>
	<cfelse>
		<cfquery name="delLinkedContent" datasource="#application.dsn#">
		DELETE
		FROM	contents2content
		WHERE	mainContentID = #form.contentid#
		</cfquery> 
	</cfif>

	<!--- weitere verlinkte teasers --->
	<cfif isdefined("form.teaserID")>
		<!--- first delete all previous links--->
		<cfquery name="delLinkedContent" datasource="#application.dsn#">
		DELETE
		FROM	teaser2content
		WHERE	contentID = #form.contentid#
		</cfquery> 
		<cfset cnt = 1 />
		<cfloop list="#form.teaserID#" index="i">
			<cfquery name="insertContentTeasers" datasource="#application.dsn#">
			INSERT
			INTO	teaser2content(contentID,teaserid,reihenfolge)
			VALUES(
					#form.contentid#,
					#i#,
					<cfif listGetAt(form.teaserOrder,cnt) EQ "">10<cfelse>#listGetAt(form.teaserOrder,cnt)#</cfif>
			)
			</cfquery>
			<cfset cnt = cnt + 1 />
		</cfloop>
	<cfelse>
		<cfquery name="delLinkedContent" datasource="#application.dsn#">
		DELETE
		FROM	teaser2content
		WHERE	contentID = #form.contentid#
		</cfquery> 
	</cfif>

		

	<cfquery name="updateContent" datasource="#application.dsn#">
		UPDATE	content
		SET		pageid = #form.pageID#,
				isactive = <cfif not isdefined("form.active")>0<cfelse>#form.active#</cfif>,
				modifydate = #createODBCdatetime(now())#,
				titel = '#form.titel#',
				lead = '#form.lead#',
				fliesstext = '#form.text#',
				bildname = '#serverbildname#',
				href = '#form.link#',
				hreflabel = '#form.linklabel#',
				doc = '#serverdocname#',
				doclabel = '#form.doclabel#',
				hascontact = <cfif not isdefined("form.hascontact")>0<cfelse>#form.hascontact#</cfif>,
				albumid = #form.album#,
					
				contactType = <cfif not isdefined("form.formtype")>0<cfelse>#form.formtype#</cfif>,
				contactReciever = '#form.reciever#',
				contactSender = '#form.sender#',
				contactSubject = '#form.subject#',
				
				customInclude = '#form.customInclude#',
				imagePos = <cfif not isdefined("form.imagepos")>0<cfelse>#form.imagepos#</cfif>,
				reihenfolge = <cfif not isdefined("form.reihenfolge") OR (isdefined("form.reihenfolge") AND form.reihenfolge EQ "")>10<cfelse>#form.reihenfolge#</cfif>,
				imagecaption = '#form.imagecaption#',
				fliesstextspalten = #form.columns#,
				albumtype = <cfif not isdefined("form.albumtype")>3<cfelse>#form.albumtype#</cfif>,
				
				contactReturnMail = #form.returnmail#,
				contactThanks = '#form.thankstext#'
		WHERE	id = #form.contentid#
		</cfquery>
		
		
		<cfif not isdefined("url.fromFEE")>
			<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
		</cfif>
</cfif>

<!--- content löschen --->
<cfif isdefined("url.delcontent") AND isNumeric(url.delcontent) AND url.delcontent GT 0>
	<!--- init component --->
	<cfset flexyLib = createObject('component','admin.cfc.flexy') />
	<!--- execute method --->
	<cfset delContentx = flexyLib.deleteContent(content=url.delcontent) />
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->