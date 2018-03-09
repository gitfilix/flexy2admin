<cfprocessingdirective pageencoding="utf-8" />

<style type="text/css">

#addMandant input[type=text],
#addMandant textarea,
#addMandant select{
	width:70%;
	}	
</style> 

<!--- rechte für dieses modul: --->
<cfloop array="#session.rechte.module#" index="i">
	<cfif i.id EQ session.moduleid>
		<cfset rightEdit = i.edit />
		<cfset rightDel = i.del />
		<cfset rightAdd = i.add />
		<cfset rightCopy = i.copy />
		<cfbreak>
	</cfif>
</cfloop>
<cfif arrayLen(session.rechte.module) EQ 0>
	<cfset rightEdit = 0 />
	<cfset rightDel = 0 />
	<cfset rightAdd = 0 />
	<cfset rightCopy = 0 />
</cfif>

<!--- -------------- form prozessors ------------------ --->


<!--- alle Mandants auslesen datasource application --->
<cfquery name="getMandant" datasource="#application.dsn#">
SELECT	*
FROM	mandanten
</cfquery>

<!--- alle Module auslesen datasource application --->
<cfquery name="getModuleList" datasource="#application.dsn#">
SELECT	*
FROM	modules
</cfquery>
<cfset moduleList = "" />
<cfloop query="getModuleList">
	<cfset moduleList = listAppend(moduleList,id) />
</cfloop>

<!--- Mandant reindexieren --->
<cfif isdefined("url.delCollection")>
	 <cfindex action="delete" collection="flexy2"  />
</cfif>
<cfif isdefined("url.addCollection")>
	 <cfcollection action="Create" collection="flexy2" engine="solr" path="#expandPath('/mirza-in-progress/collection/')#">
</cfif>
<cfif isdefined("url.reIndex")>
	<cfsetting requesttimeout="3600" />
	
	<cfquery name="URLShortcut" datasource="#application.dsn#">
	SELECT 	directoryname
	FROM	mandanten
	WHERE	id = #url.reIndex#
	</cfquery>
	
	<cfquery name="MyQuery" datasource="#application.dsn#">
		select P.id, C.titel,C.lead,C.fliesstext,C.hrefLabel,C.imagecaption,P.navTitel,P.pageTitel,P.lang
		from content C LEFT JOIN pages P ON C.pageid = P.id 
		where P.mandant = #url.reIndex#
	</cfquery>
	<cfquery name="MyQueryDocs" datasource="#application.dsn#">
		select C.doc,C.doclabel,P.id, C.titel
		from content C LEFT JOIN pages P ON C.pageid = P.id 
		where P.mandant = #url.reIndex# AND C.doc != '' 
	</cfquery>
	
	<!--- <cfindex action="delete" collection="flexy2"  /> --->
	<!--- <cfcollection action="Create" collection="flexy2" engine="solr" path="#expandPath('/' & session.serverpath & '/collection/')#">  --->
	<!--- <cfindex collection="flexy2" action="purge"> --->
	
	<cfindex status="y" collection="flexy2" action="update" type="custom" body="lang,lead,fliesstext,titel,hreflabel,imagecaption,navtitel,pagetitel" query="MyQuery" key="id">
	<cfindex collection="flexy2" action="refresh" key="#expandPath('/' & URLShortcut.directoryname & '/upload/doc/')#" urlpath="http://www.flx-media.ch/#URLShortcut.directoryname#/upload/doc/" extensions=".pdf, .xlsx, .ppt, .docx, .doc"  type="path" status="x">
	<!--- <cfsearch name="searchResults" collection="flexy2" criteria="datum">
	<cfdump var="#searchResults#"> --->
</cfif>

<!--- Mandant löschen --->
<cfif isdefined("url.delmandant") AND isNumeric(url.delmandant) AND url.delmandant GT 0>
	<!--- init component --->
	<cfset flexyLib = createObject('component','admin.cfc.flexy') />
	<!--- execute method --->
	<cfset delMandant = flexyLib.deleteEntireMandant(delmandant=url.delmandant) />
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Mandant hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewMandant" AND isdefined("form.name")>
	<cfset actionSuceeded = true />
	
	<!--- erst checken ob sprache gewählt wurde --->
	<cfif NOT listFind(form.fieldnames,"INITSPRACHE1") OR (form.initSprache1 EQ "" OR form.initSpracheParam1 EQ "")>
		Bitte mind. 1 Sprache wählen
		<cfabort/>
	</cfif>
	
	<cfquery name="insertMandant" datasource="#application.dsn#">
	INSERT	
	INTO	mandanten (
			createdate,
			isactive,
			firma,
			anrede,
			NAME,
			vorname,
			adresse,
			plz,
			ort,
			email,
			tel,
			mobile,
			directoryname,
			navlevels
			)
	VALUES(
			#createodbcdate(now())#,
			#form.active#,
			'#form.firma#',
			#form.anrede#,
			'#form.name#',
			'#form.vorname#',
			'#form.adresse#',
			<cfif form.plz NEQ "">#form.plz#<cfelse>NULL</cfif>,
			'#form.ort#',
			'#form.email#',
			'#form.tel#',
			'#form.mobile#',
			'#form.dir#',
			#form.navlevels#				
	)
	</cfquery>
	
	
	<!--- neuste Mandanten-ID auslesen --->
	<cfquery name="getLatestID" datasource="#application.dsn#">
	SELECT 	MAX(id) as maxi
	FROM	mandanten
	</cfquery>
	<cfset maxMandantID = getLatestID.maxi />
	<!--- module eintragen --->
	<!--- checken ob module übermittelt wurden --->
	<cfif isdefined("form.mod") AND listLen(form.mod) GT 0>
		<!--- durch die form.mod Liste loopen --->
		<cfloop list="#form.mod#" index="i">
			<!--- db-eintrag in zwischentabelle usermodules ; hier werden usern einzelne module zugeordnet --->
			<cfquery name="insertmodules" datasource="#application.dsn#">
			INSERT	
			INTO	mandantenmodules (mandantenid,moduleid)
			VALUES(
				#getLatestID.maxi#,
				#i#
			)
			</cfquery>
		</cfloop>
	</cfif>	
	<!--- funktionsfreigaben --->
	<cfquery name="funktionsfreigaben" datasource="#application.dsn#">
	INSERT 	
	INTO	mandantenfunktionsfreigaben(mandant)
	VALUES(	
			#maxMandantID#
	)
	</cfquery>
	<!--- feldfreigaben --->
		<!--- für pagemanagement --->
		<cfset fieldList = "addPage_pageTitle,addPage_navTitle,addPage_metaTitle,addPage_metaKeys,addPage_metaDesc,addPage_parentID,addPage_navOrder,addPage_headerBild,addPage_Template,addPage_URLShortcut,addPage_templatecolorschema,editPage_pageTitle,editPage_navTitle,editPage_metaTitle,editPage_metaKeys,editPage_metaDesc,editPage_parentID,editPage_navOrder,editPage_headerBild,editPage_template,editPage_URLShortcut,editPage_templatecolorschema,addContent_titel,addContent_lead,addContent_fliesstext,addContent_bildname,addContent_href,addContent_hrefLabel,addContent_doc,addContent_docLabel,addContent_hasContact,addContent_contactType,addContent_customInclude,addContent_imagePos,addContent_imageCaption,addContent_fliessTextSpalten,editContent_titel,editContent_lead,editContent_fliesstext,editContent_bildname,editContent_href,editContent_hrefLabel,editContent_doc,editContent_docLabel,editContent_hasContact,editContent_contactType,editContent_customInclude,editContent_imagePos,editContent_imageCaption,editContent_fliessTextSpalten" />
		<cfloop list="#fieldList#" index="i">
			<cfquery name="feldfreigaben" datasource="#application.dsn#">
			INSERT 	
			INTO	mandantenfeldfreigaben(
					fieldName,
					moduleID,
					mandant,
					fieldState
					)
			VALUES(	
					'#i#',
					1,
					#maxMandantID#,
					<cfif structKeyExists(form,i)>1<cfelse>0</cfif>
			)
			</cfquery>
			
			<!--- <cfif i EQ "addContent_bildname" OR i EQ "editContent_bildname" OR i EQ "editPage_headerbild" OR i EQ "addPage_headerbild"> --->
			<cfif i EQ  "addPage_headerBild" OR i EQ  "editPage_headerBild" OR i EQ "addContent_bildname" OR i EQ "editContent_bildname" OR i EQ "editSidebar_bild" OR i EQ "addSidebar_bild" OR i EQ "editHeaderpanel_bild" OR i EQ "addHeaderpanel_bild" OR i EQ "addNews_bild" OR i EQ "editNews_bild">
				
				<!--- bildresize grössen hinterlegen --->
				<cfquery name="insertResizes" datasource="#application.dsn#">
				INSERT INTO feldbildsize(fieldname,mandant)
				VALUES(
					'#i#',
					#maxMandantID#
				)
				</cfquery>
				
				
				<!--- <cfloop list="#evaluate('form.' & i & '_toolbar')#" index="u">
					<cfquery name="insertToolbarItems" datasource="#application.dsn#">
					INSERT 	
					INTO	feldtoolbaritems(
							feldName,
							toolbarItems,
							mandant
							)
					VALUES(	
							'#i#',
							'#u#',
							#maxMandantID#
					)
					</cfquery>
				</cfloop> --->
			</cfif> 
			
		</cfloop>	
		
		
		
		
		
		
		<!--- weietere feldfreigaben --->
		<!--- <cfset fieldList = "addPage_pageTitle,addPage_navTitle,addPage_metaTitle,addPage_metaKeys,addPage_metaDesc,addPage_parentID,addPage_navOrder,addPage_headerBild,addPage_Template,addPage_URLShortcut,addPage_templatecolorschema,editPage_pageTitle,editPage_navTitle,editPage_metaTitle,editPage_metaKeys,editPage_metaDesc,editPage_parentID,editPage_navOrder,editPage_headerBild,editPage_template,editPage_URLShortcut,editPage_templatecolorschema,addContent_titel,addContent_lead,addContent_fliesstext,addContent_bildname,addContent_href,addContent_hrefLabel,addContent_doc,addContent_docLabel,addContent_hasContact,addContent_contactType,addContent_customInclude,addContent_imagePos,addContent_imageCaption,addContent_fliessTextSpalten,editContent_titel,editContent_lead,editContent_fliesstext,editContent_bildname,editContent_href,editContent_hrefLabel,editContent_doc,editContent_docLabel,editContent_hasContact,editContent_contactType,editContent_customInclude,editContent_imagePos,editContent_imageCaption,editContent_fliessTextSpalten" />
		<cfloop list="#fieldList#" index="i">
			<cfif structKeyExists(form,i)>
				<cfquery name="feldfreigaben" datasource="#application.dsn#">
				INSERT 	
				INTO	mandantenfeldfreigaben(
						fieldName,
						moduleID,
						mandant
						)
				VALUES(	
						'#i#',
						1,
						#maxMandantID#
				)
				</cfquery>
			</cfif>
		</cfloop> --->	
	
	<!--- sprachen --->
	<cfset initdefaultlang = "" />
	<cfloop from="1" to="100" index="i">
		<!--- wenn neu hinzugefügte Sprache übermittelt wird, durch alle loopen und in db eintragen --->
		<cfif isdefined("form.initSprache" & i)>
			<cfif initdefaultlang EQ "">
				<cfset initdefaultlang = evaluate("form.initSpracheParam" & i) />
			</cfif>
			<cfquery name="insertAddedLang" datasource="#application.dsn#">
			INSERT 	
			INTO	mandantensprachen(
					language,
					languageParam,
					mandant,
					isActive,
					domain
					)
			VALUES(
					'#evaluate("form.initSprache" & i)#',
					'#evaluate("form.initSpracheParam" & i)#',
					#getLatestID.maxi#,
					#evaluate("form.status" & i)#,
					'#evaluate("form.domain" & i)#'
			)
			</cfquery>
		</cfif>
	</cfloop>
	
	<!--- verzeichnis anlegen --->
	<!--- erst checken ob verz. existiert --->
	<cfif not directoryExists(expandPath('/') & form.dir)>
		<cfdirectory action="create" directory="#expandPath('/') & form.dir#" />
		<!--- init component --->
		<cfset flexyLib = createObject('component','admin.cfc.flexy') />
		<!--- execute method --->
		<cfset copyMasterTemplateToNewDirectory = flexyLib.copyDirectory(source=expandPath('/admin/inc/_masterTemplateFelix'),destination=expandPath('/') & form.dir) />
		<!--- user erstellen --->
		<!--- erst checken, ob user mit derselben email adresse existiert --->
		<cfquery name="preCheckUserEmail" datasource="#application.dsn#">
		SELECT 	*
		FROM	user
		WHERE	email = '#form.email#'
		</cfquery>
		<!--- wenn kein user ecistiert --->
		<cfif preCheckUserEmail.recordcount EQ 0 AND isValid('email',form.email)>
			<!--- neuen user eintragen und zufälliges pw vergeben --->
			<cfquery name="insertuser" datasource="#application.dsn#">
			INSERT	
			INTO	user (vorname,name,email,password,isActive,mandant)
			VALUES(
				'#form.vorname#',
				'#form.name#',
				'#form.email#',
				'#trim(flexyLib.generateRandom())#',
				1,
				#maxMandantID#
			)
			</cfquery>
			<!--- neuste generierte User-ID auslesen --->
			<cfquery name="getLatestUserID" datasource="#application.dsn#">
			SELECT MAX(id) as lastUserID from user
			</cfquery>
			<!--- startseite für diesen mandanten erstellen --->
			<cfquery name="insertStartPage" datasource="#application.dsn#">
			INSERT	
			INTO	pages (parentUser, createdate, isactive, navPos, navTitel, pageTitel, metaTitel, parentID, navorder, template, mandant, urlshortcut)
			VALUES(
				#getLatestUserID.lastUserID#,
				#createODBCDateTime(now())#,
				#form.active#,
				1,
				'Startpage #form.dir#',
				'Startpage #form.dir#',
				'Startpage #form.dir#',
				0,
				10,
				1,
				#getLatestID.maxi#,
				'startseite-#form.dir#'
			)
			</cfquery>
			<!--- neuste generierte Page-ID auslesen --->
			<cfquery name="getLatestPageID" datasource="#application.dsn#">
			SELECT MAX(id) as lastID from pages
			WHERE mandant = #getLatestID.maxi#
			</cfquery>
			<!--- settings-eintrag anlegen --->
			<cfquery name="setSettings" datasource="#application.dsn#">
			INSERT 	
			INTO 	settings(mandant,defaultlang)
			VALUES(
					#maxMandantID#,
					'#initdefaultlang#'
			)
			</cfquery>
			
			<!--- SprachSpezifische Startseiten definieren --->
			<cfquery name="setStartpageForDefaultLang" datasource="#application.dsn#">
			INSERT 	
			INTO 	langstartpages2mandanten(mandant,lang,startpage)
			VALUES	(	
					#maxMandantID#,
					'#form.initSpracheParam1#',
					#getLatestPageID.lastID#	
			)
			</cfquery>
			
			<!--- dummy content einfügen --->
			<cfquery name="insertDummyContent" datasource="#application.dsn#">
			INSERT 	INTO content(
					pageID,
					isActive,
					createdate,
					titel,
					lead,
					fliesstext,
					reihenfolge
					)
			VALUES(
					#getLatestPageID.lastID#,
					1,
					#createODBCdatetime(now())#,
					'Willkommen auf #form.dir#',
					'Ein Anriss...',
					'<p>Hier kommt der Willkommenstext...</p>',
					10
			)
			</cfquery>
			<!--- xml generieren --->
<!--- <cfxml variable="MyDoc">
<cfoutput>
<flexy_config>
	<serverPath>#form.dir#</serverPath>
	<mandant>#getLatestPageID.maxi#</mandant>
	<startpageID>#getLatestPageID.lastID#</startpageID>
</flexy_config>
</cfoutput>
</cfxml>
			<!--- xml im zielordner speichern --->
			<cfset XMLText=ToString(MyDoc)>
			<cffile action="write" file="#expandPath('/') & form.dir & '\config.xml'#" output="#XMLText#"> --->
			
			<!--- .htaccess dynamisch schreiben --->
			
			<!--- xml im zielordner speichern --->
			<cfsavecontent variable="htaccess">	
RewriteEngine on
RewriteBase /<cfoutput>#form.dir#</cfoutput>

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule .? index.cfm/%{REQUEST_URI} [QSA,L]
			</cfsavecontent>
		<!--- 	<cffile action="write" file="#expandPath('/') & form.dir & '\.htaccess'#" output="#htaccess#" nameconflict="overwrite">  --->
			
			<cflocation url="#cgi.SCRIPT_NAME#?action=createdNewMandantSuccess&mid=#getLatestID.maxi#" addtoken="no">	
		<cfelse>
			Ein user besteht bereits mit dieser E-Mail Adresse. Bitte korrigieren
			<cfabort>
		</cfif>
	<cfelse>
		Das Verzeichnis existiert bereits. Bitte umbenennen.
		<cfabort>
	</cfif>
</cfif>

<!--- Mandant updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededitedMandant" AND isdefined("form.name")>

		<cfset actionSuceeded = true />
		
		<!--- erst checken ob sprache gewählt wurde --->
		<cfif NOT listFind(form.fieldnames,'INITSPRACHE1') OR (listFind(form.fieldnames,'INITSPRACHE1') AND (form.INITSPRACHE1 EQ "" OR form.initSpracheParam1 EQ ""))>
			<cfdump var="#form.fieldnames#">
			Bitte mind. 1 Sprache wählen
			<cfabort>
		</cfif>
		
		<cfquery name="updatemandanten" datasource="#application.dsn#">
		UPDATE	mandanten
		SET		modifydate = #createodbcdate(now())#,
				isactive = #form.active#,
				firma = '#form.firma#',
				anrede = #form.anrede#,
				NAME = '#form.name#',
				vorname = '#form.vorname#',
				adresse = '#form.adresse#',
				plz = <cfif form.plz NEQ "">#form.plz#<cfelse>NULL</cfif>,
				ort = '#form.ort#',
				email = '#form.email#',
				tel = '#form.tel#',
				mobile = '#form.mobile#',
				navlevels = #form.navlevels#
		WHERE	id = #form.mandantenid#
		</cfquery>
		<!--- funktionsfreigaben --->
		
		<cfquery name="funktionsfreigaben" datasource="#application.dsn#" result="xxx">
		UPDATE	mandantenfunktionsfreigaben
		SET		hasTeasers = <cfif isdefined("form.hasTeasers")>1<cfelse>0</cfif>,
				hasContentConnect = <cfif isdefined("form.hasContentConnect")>1<cfelse>0</cfif>,
				hasColumns = <cfif isdefined("form.hasColumns")>1<cfelse>0</cfif>,
				hasColumns2 = <cfif isdefined("form.hasColumns2") AND isdefined("form.hasColumns")>1<cfelse>0</cfif>,
				hasColumns3 = <cfif isdefined("form.hasColumns3") AND isdefined("form.hasColumns")>1<cfelse>0</cfif>,
				hasColumns4 = <cfif isdefined("form.hasColumns4") AND isdefined("form.hasColumns")>1<cfelse>0</cfif>,
				hasForm = <cfif isdefined("form.hasForm")>1<cfelse>0</cfif>,
				hasFormCompact = <cfif isdefined("form.hasFormCompact") AND isdefined("form.hasForm")>1<cfelse>0</cfif>,
				hasFormFull = <cfif isdefined("form.hasFormFull") AND isdefined("form.hasForm")>1<cfelse>0</cfif>,
				hasCustomInclude = <cfif isdefined("form.hasCustomInclude")>1<cfelse>0</cfif>,
				hasMultiTemplates = <cfif isdefined("form.hasMultiTemplates")>1<cfelse>0</cfif>,
				hasMultiTemplate1 = <cfif isdefined("form.hasMultiTemplate1") AND isdefined("form.hasMultiTemplates")>1<cfelse>0</cfif>,
				hasMultiTemplate2 = <cfif isdefined("form.hasMultiTemplate2") AND isdefined("form.hasMultiTemplates")>1<cfelse>0</cfif>,
				hasMultiTemplate3 = <cfif isdefined("form.hasMultiTemplate3") AND isdefined("form.hasMultiTemplates")>1<cfelse>0</cfif>,
				hasColorSchema = <cfif isdefined("form.hasColorSchema")>1<cfelse>0</cfif>,
				hasMultiLinks = <cfif isdefined("form.hasMultiLinks")>1<cfelse>0</cfif>,
				hasMultiDocs = <cfif isdefined("form.hasMultiDocs")>1<cfelse>0</cfif>,
				hasGalleryOptions = <cfif isdefined("form.hasGalleryOptions")>1<cfelse>0</cfif>,
				hasGalleryOptions1 = <cfif isdefined("form.hasGalleryOptions1") AND isdefined("form.hasGalleryOptions")>1<cfelse>0</cfif>,
				hasGalleryOptions2 = <cfif isdefined("form.hasGalleryOptions2") AND isdefined("form.hasGalleryOptions")>1<cfelse>0</cfif>,
				hasGalleryOptions3 = <cfif isdefined("form.hasGalleryOptions3") AND isdefined("form.hasGalleryOptions")>1<cfelse>0</cfif>,
				hasNavtypes = <cfif isdefined("form.hasNavtypes")>1<cfelse>0</cfif>,
				hasNavTypeService = <cfif isdefined("form.hasNavTypeService") AND isdefined("form.hasNavtypes")>1<cfelse>0</cfif>,
				hasNavTypeThemen = <cfif isdefined("form.hasNavTypeThemen") AND isdefined("form.hasNavtypes")>1<cfelse>0</cfif>,
				hasNavTypeFooter = <cfif isdefined("form.hasNavTypeFooter") AND isdefined("form.hasNavtypes")>1<cfelse>0</cfif>,
				hasMultiUploadGallery = <cfif isdefined("form.hasMultiUploadGallery")>1<cfelse>0</cfif>,
				hasContentTeasers = <cfif isdefined("form.hasContentTeasers")>1<cfelse>0</cfif>,
				hasSOLR = <cfif isdefined("form.hasSOLR")>1<cfelse>0</cfif>,
				hasTeamDetail = <cfif isdefined("form.hasTeamDetail")>1<cfelse>0</cfif>
		WHERE	mandant = #form.mandantenid#
		</cfquery>
		<!--- feldfreigaben --->
	
		<!--- erst alle freigaben löschen --->
		<cfquery name="delMandantFeldFreigaben" datasource="#application.dsn#">
		DELETE
		FROM	mandantenfeldfreigaben
		WHERE	mandant = #form.mandantenid#
		</cfquery>
				
		<!--- felder cms --->
		<cfset fieldList_1 = "addPage_pageTitle,addPage_navTitle,addPage_metaTitle,addPage_metaKeys,addPage_metaDesc,addPage_parentID,addPage_navOrder,addPage_headerBild,addPage_Template,addPage_URLShortcut,addPage_templatecolorschema,editPage_pageTitle,editPage_navTitle,editPage_metaTitle,editPage_metaKeys,editPage_metaDesc,editPage_parentID,editPage_navOrder,editPage_headerBild,editPage_template,editPage_URLShortcut,editPage_templatecolorschema,addContent_titel,addContent_lead,addContent_fliesstext,addContent_bildname,addContent_href,addContent_hrefLabel,addContent_doc,addContent_docLabel,addContent_hasContact,addContent_contactType,addContent_customInclude,addContent_imagePos,addContent_imageCaption,addContent_fliessTextSpalten,editContent_titel,editContent_lead,editContent_fliesstext,editContent_bildname,editContent_href,editContent_hrefLabel,editContent_doc,editContent_docLabel,editContent_hasContact,editContent_contactType,editContent_customInclude,editContent_imagePos,editContent_imageCaption,editContent_fliessTextSpalten" />
		
		<!--- felder teasers --->
		<cfset fieldList_3 = "editSidebar_pos,editSidebar_titel,editSidebar_text,editSidebar_bild,editSidebar_link,addSidebar_pos,addSidebar_titel,addSidebar_text,addSidebar_bild,addSidebar_link" />
		
		<!--- felder headerpanels --->
		<cfset fieldList_4 = "addHeaderpanel_titel,addHeaderpanel_text,addHeaderpanel_bild,addHeaderpanel_link,editHeaderpanel_titel,editHeaderpanel_text,editHeaderpanel_bild,editHeaderpanel_link" />
		
		<!--- felder news --->
		<cfset fieldList_9 = "addNews_titel,addNews_text,addNews_bild,addNews_link,editNews_titel,editNews_text,editNews_bild,editNews_link" />
		
		
		
		<!--- durch alle module loopen --->
		<cfloop list="#moduleList#" index="x">
			<cfif isdefined("fieldList_#x#")>
				<cfloop list="#evaluate('fieldList_' & x)#" index="i">
					<cfquery name="feldfreigaben" datasource="#application.dsn#">
					INSERT 	
					INTO	mandantenfeldfreigaben(
							fieldName,
							moduleID,
							mandant,
							fieldState
							)
					VALUES(	
							'#i#',
							#x#,
							#form.mandantenid#,
							<cfif structKeyExists(form,i)>1<cfelse>0</cfif>
					)
					</cfquery>
					<cfif i EQ "addContent_fliesstext" OR i EQ "editContent_fliesstext" OR i EQ "editSidebar_text" OR i EQ "addSidebar_text" OR i EQ "addHeaderpanel_text" OR i EQ "editHeaderpanel_text" OR i EQ "addNews_text" OR i EQ "editNews_text">
					<!--- <cfif i EQ "addContent_fliesstext" OR i EQ "editContent_fliesstext"> --->
						<!--- erst alle freigaben löschen --->
						<cfquery name="delMandantFeldFreigaben" datasource="#application.dsn#">
						DELETE
						FROM	feldtoolbaritems
						WHERE	mandant = #form.mandantenid# AND feldname = '#i#'
						</cfquery>
						<cfif isDefined("form." & i & "_toolbar")>
							<cfloop list="#evaluate('form.' & i & '_toolbar')#" index="u">
								
								<cfquery name="insertToolbarItems" datasource="#application.dsn#">
								INSERT 	
								INTO	feldtoolbaritems(
										feldName,
										toolbarItems,
										mandant
										)
								VALUES(	
										'#i#',
										'#u#',
										#form.mandantenid#
								)
								</cfquery>
							</cfloop>
						</cfif>
						<!--- update imagesize resizer: wenn ein von 4 bildname-felder ausgefüllt worden ist, update table feldbildsize --->
					<cfelseif i EQ  "addPage_headerBild" OR i EQ  "editPage_headerBild" OR i EQ "addContent_bildname" OR i EQ "editContent_bildname" OR i EQ "editSidebar_bild" OR i EQ "addSidebar_bild" OR i EQ "editHeaderpanel_bild" OR i EQ "addHeaderpanel_bild" OR i EQ "addNews_bild" OR i EQ "editNews_bild">
					<!--- <cfelseif i EQ "addContent_bildname" OR i EQ "editContent_bildname" OR i EQ "addpage_headerbild" OR i EQ "editpage_headerbild"> --->
						
						<cfif isDefined("form." & i & "_resize") AND evaluate('form.' & i & '_resize') NEQ "">
							
							<cfquery name="getSizes" datasource="#application.dsn#" > 
							SELECT 	*
							FROM	feldbildsize
							WHERE 	mandant = #form.mandantenid# AND
									fieldname = "#i#"
							</cfquery>
							<cfif getSizes.recordcount EQ 1>
								<cfquery name="insertToolbarItems" datasource="#application.dsn#" > 
								UPDATE 	feldbildsize
								SET 	resizevalue_width = #evaluate('form.' & i & '_resize')#	
								WHERE 	Mandant =	#form.mandantenid# 
								AND		fieldname = "#i#"
								</cfquery>
							<cfelseif getSizes.recordcount EQ 0>
								<cfquery name="insertToolbarItems" datasource="#application.dsn#" > 
								INSERT	
								INTO	feldbildsize(fieldname,resizevalue_width,mandant)
								VALUES(
									'#i#',
									#evaluate('form.' & i & '_resize')#,
									#form.mandantenid#
								) 	
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
						
				</cfloop>	
			</cfif>		
		</cfloop>
		<!--- module eintragen --->
		<!--- zuerst alle bisherigen assozioationen löschen --->
		<cfquery name="delUserModules" datasource="#application.dsn#">
		DELETE
		FROM	mandantenmodules
		WHERE	mandantenid = #form.mandantenid#
		</cfquery>
		<!--- checken ob module übermittelt wurden --->
		<cfif listLen(form.mod) GT 0>
			<!--- durch die form.mod Liste loopen --->
			<cfloop list="#form.mod#" index="p">
				<!--- db-eintrag in zwischentabelle usermodules --->
				<cfquery name="insertmodules" datasource="#application.dsn#">
				INSERT	
				INTO	mandantenmodules (mandantenid,moduleid)
				VALUES(
					#form.mandantenid#,
					#p#
				)
				</cfquery>
			</cfloop>
			<!--- jetzt müsste man die usermodule und rechte anpassen --->
			<!--- alle module lesen --->
			<cfquery name="getAllModules" datasource="#application.dsn#">
			SELECT	id as modID
			FROM	modules
			</cfquery>
			<!--- alle benutzer dieses mandanten auselsen --->
			<cfquery name="getAllUsers" datasource="#application.dsn#">
			SELECT	*
			FROM	user
			WHERE	mandant = #form.mandantenid# 
			</cfquery>
			<!--- durch alle user loopen --->
			<cfloop query="getAllUsers">
				<!--- id zwischenspeichern --->
				<cfset userid = id />
				<!--- durch alle module loopen --->
				<cfoutput query="getAllModules">
					<!--- wenn das modul nicht in der form.mod liste enthalten ist --->
					<cfif NOT listFind(form.mod,modID)>
						<!--- dann lösche alle einträge in der usermodules tabelle --->
						<cfquery name="delUserModules" datasource="#application.dsn#">
						DELETE
						FROM	usermodules
						WHERE	userid = #userid# AND
								moduleid = #modID#
						</cfquery>
						<!--- auch rechte bereinigen --->
						<cfquery name="delUserRights" datasource="#application.dsn#">
						DELETE
						FROM	userrights
						WHERE	userid = #userid# AND
								moduleid = #modID#
						</cfquery>
						
					</cfif>
				</cfoutput>
			</cfloop>
		</cfif>
		<!--- erst alle sprachen löschen --->
		<cfquery name="delLangs" datasource="#application.dsn#">
		DELETE
		FROM	mandantensprachen
		WHERE	mandant = #form.mandantenid#
		</cfquery>
		<!--- durch sprachen loopen und einfügen --->
		<cfloop from="1" to="50" index="i">
			<!--- wenn neu hinzugefügter link übermittelt wird, durch alle loopen und in db eintragen --->
			<cfif isdefined("form.initSprache" & i)>
				<cfquery name="insertAddedLang" datasource="#application.dsn#">
				INSERT 	
				INTO	mandantensprachen(
						language,
						languageParam,
						mandant,
						isActive,
						domain
						)
				VALUES(
						'#evaluate("form.initSprache" & i)#',
						'#evaluate("form.initSpracheParam" & i)#',
						#form.mandantenid#,
						#evaluate("form.status" & i)#,
						'#evaluate("form.domain" & i)#'
				)
				</cfquery>
			</cfif>
		</cfloop>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- zu bearbeitenden mandanten aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editMandant") AND isNumeric(url.editMandant) AND url.editMandant GT 0>
	<cfquery name="editMandant" datasource="#application.dsn#">
	SELECT	*
	FROM	mandanten
	WHERE	id = #url.editMandant#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Users darstellen --->

<h2>Mandanten Management</h2>

<cfif isdefined("url.action") AND url.action EQ "createdNewMandantSuccess">
	<div style="background-color:white;color:red;font-weight:bold;padding:20px;font-size:14px;">
		<!--- Mandant auslesen --->
		<cfquery name="getMandant" datasource="#application.dsn#">
		SELECT	*
		FROM	mandanten
		WHERE	id = #url.mid#
		</cfquery>
		<!--- User auslesen --->
		<cfquery name="getUser" datasource="#application.dsn#">
		SELECT	*
		FROM	user
		WHERE	mandant = #getMandant.id#
		</cfquery>
		
		Der neue Mandant wurde korrekt angelegt!<br/>
		- Neuer Mandant<br/>
		- Neuer User <cfoutput>(#getUser.email# / #trim(getUser.password)#)</cfoutput><br/>
		- Neue Startseite<br/>
		- Neuer Dummy-Inhalt für Startseite<br/>
		- Verzeichnis auf dem Server<br/>
		- Master-Template kopiert<br/>
		<br/>
		
		<cfoutput><a href="http://www.flx-media.ch/#getMandant.directoryname#/" target="_blank">Neuer Mandant aufrufen</a></cfoutput>
	</div>
</cfif>

<table width="100%">
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Mandant löschen ?</strong></td>
	<td><strong>Mandant bearbeiten ?</strong></td>
	<td><strong>Index</strong></td>
</tr>
<cfoutput query="getMandant">
<!--- alle Mandants auslesen datasource application --->
<cfquery name="getMandantenFreigaben" datasource="#application.dsn#">
SELECT	*
FROM	mandantenfunktionsfreigaben
WHERE	mandant = #id#
</cfquery>
<tr>
	<td>#Name# <cfif directoryname NEQ "">(#directoryname#)<cfelse>(standalone Hosting)</cfif> </td>
	<td>
	<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
		<cfif isactive EQ 1>
		<div id="activ">	aktiv</div>
		<cfelse>
		<div id="inactiv">	inaktiv </div>
		</cfif>
	</td>
<!---	.mandantendel  / .mandantenedit sind funktionen mit der jeweiligen mandantenID die als url. parameter mitgegeben werden--->
	<td>
		<cfif rightDel EQ 1>
		<a href="#cgi.SCRIPT_NAME#?delmandant=#id#" onclick="return confirm('Sind Sie sicher? Es werden alle Daten gelöscht (Seuten, Inhalte, Dateien, Benutzer, Module, Mandant)');">
			mandant löschen
		</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
		<a href="#cgi.SCRIPT_NAME#?editmandant=#id#">
			mandant bearbeiten
		</a>
		</cfif>
	</td>
	<td>
		<cfif rightCopy EQ 1 AND getMandantenFreigaben.hasSOLR EQ 1>
		<a href="#cgi.SCRIPT_NAME#?reIndex=#id#">
			Collection neu indexieren
		</a> -
		<a href="#cgi.SCRIPT_NAME#?delCollection=true">
			Collection löschen
		</a> -
		<a href="#cgi.SCRIPT_NAME#?addCollection=true">
			Collection erstellen
		</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>

<!--- dies erscheint nur wenn mandanten element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addMandant") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewMandant" method="post" enctype="multipart/form-data" id="addMandant">
	<table width="100%">
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td>Firma</td>
		<td><input type="text" name="firma" <cfif isdefined("form.firma")>value="#form.firma#"</cfif>></td>
	</tr>
	<tr>
		<td>Anrede</td>
		<td>
			<input type="radio" name="anrede" value="1" checked="checked"> Herr  &nbsp; &nbsp;
			<input type="radio" name="anrede" value="2"> Frau
		</td>
	</tr>
	<tr>
		<td>Name</td>
		<td><input type="text" name="name" <cfif isdefined("form.name")>value="#form.name#"</cfif>></td>
	</tr>
	<tr>
		<td>Vorname</td>
		<td><input type="text" name="vorname" <cfif isdefined("form.name")>value="#form.name#"</cfif>></td>
	</tr>
	<tr>
		<td valign="top">Adresse</td>
		<td><textarea name="adresse"  id="adresse" cols="1" rows="1" style="height:120px;"><cfif isdefined("form.adresse")>#adresse#</cfif></textarea></td>
	</tr>
	<tr>
		<td>PLZ</td>
		<td><input type="text" name="plz" <cfif isdefined("form.plz")>value="#form.plz#"</cfif>></td>
	</tr>
	<tr>
		<td>Ort</td>
		<td><input type="text" name="ort" <cfif isdefined("form.ort")>value="#form.ort#"</cfif>></td>
	</tr>
	<tr>
		<td>Tel</td>
		<td><input type="text" name="tel" <cfif isdefined("form.tel")>value="#form.tel#"</cfif>></td>
	</tr>
	<tr>
		<td>Mobile</td>
		<td><input type="text" name="mobile" <cfif isdefined("form.mobile")>value="#form.mobile#"</cfif>></td>
	</tr>
	<tr>
		<td>E-Mail</td>
		<td><input type="text" name="email" <cfif isdefined("form.email")>value="#form.email#"</cfif>></td>
	</tr>
	<tr>
		<td>Verzeichnis</td>
		<td><input type="text" name="dir" <cfif isdefined("form.dir")>value="#form.dir#"</cfif>><br/>(kann nicht mehr geändert werden)</td>
	</tr>
	<tr>
		<td>Navigations-levels</td>
		<td>
			<select name="navlevels">
				<option value="1">1</option>
				<option value="2" selected="selected">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			</select>
		</td>
	</tr>
	<!--- <tr>
		<td>Domain (ohne www)</td>
		<td><input type="text" name="www" <cfif isdefined("form.www")>value="#form.www#"</cfif>></td>
	</tr> --->
	<tr>
		<td valign="top">Module</td>
		<td>
			<!--- alle module auslesen  --->
			<cfquery name="getModules" datasource="#application.dsn#">
			SELECT	*
			FROM	modules
			</cfquery>
			<cfloop query="getModules">
			<input type="checkbox" name="mod" value="#id#" /> #module# <cfif modultyp EQ 2>(Custom-Modul unter /admin/inc/customModules/#customPfad#)</cfif><br/>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td>
			Sprache(n)
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showLangs').toggle();">verwalten</a>
		</td>
	</tr>
	<tr id="showLangs" style="display:none;">
		<td>&nbsp;</td>
		<td >
			<table width="100%">
			<tr>
				<td colspan="2">
					<table width="100%" id="sortLangs">
					<tbody>
					<tr><td></td></tr>
					<tr class="langelem">
						<td>Sprache</td>
						<td>
							<input type="text" name="initSprache1" value="" title="initSprache" /><br/>
							Sprach-Parameter: <input type="text" name="initSpracheParam1" style="width:100px;" value="" title="initSpracheParam" /> (z.B: ch-de)<br/>
							Domain: <input type="text" name="domain1" style="width:60%;" value="" title="domain" /><br/>
							<input type="radio" name="status1" value="1" checked="checked" /> aktiv&nbsp;&nbsp;
							<input type="radio" name="status1" value="0" checked="checked" /> inaktiv&nbsp;&nbsp;<br/>
						</td>
					</tr>
					</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<a href="javascript:void(0);" onclick="loadMask('lang');">Weitere Sprache erfassen</a>
				</td>
			</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<input type="submit" value="Mandant erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editmandant")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addMandant" id="addMandant" onclick="return confirm('Sind Sie sicher? Es wird ein neuer Mandant inkl. allen Ordner und DB-EInträgen erstellt.')" > + neuer Mandant erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn mandanten bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editmandant") AND isNumeric(url.editmandant) AND url.editmandant GT 0>
<cfoutput query="editMandant">
	<h3>Mandant #name# bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedMandant" method="post" enctype="multipart/form-data" id="addMandant">
	<table width="100%">
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isActive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isActive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>Firma</td>
		<td><input type="text" name="firma" value="#firma#"></td>
	</tr>
	<tr>
		<td>Anrede</td>
		<td>
			<input type="radio" name="anrede" value="1" checked="checked"> Herr  &nbsp; &nbsp;
			<input type="radio" name="anrede" value="2"> Frau
		</td>
	</tr>
	<tr>
		<td>Name</td>
		<td><input type="text" name="name" value="#name#"></td>
	</tr>
	<tr>
		<td>Vorname</td>
		<td><input type="text" name="vorname" value="#vorname#"></td>
	</tr>
	<tr>
		<td valign="top">Adresse</td>
		<td><textarea name="adresse"  id="adresse" cols="1" rows="1" style="height:120px;">#adresse#</textarea></td>
	</tr>
	<tr>
		<td>PLZ</td>
		<td><input type="text" name="plz" value="#plz#"></td>
	</tr>
	<tr>
		<td>Ort</td>
		<td><input type="text" name="ort" value="#ort#"></td>
	</tr>
	<tr>
		<td>Tel</td>
		<td><input type="text" name="tel" value="#tel#"></td>
	</tr>
	<tr>
		<td>Mobile</td>
		<td><input type="text" name="mobile" value="#mobile#"></td>
	</tr>
	<tr>
		<td>E-Mail</td>
		<td><input type="text" name="email" value="#email#"></td>
	</tr>
	<tr>
		<td>Verzeichnis</td>
		<td><input type="text" name="dir" value="#directoryname#" readonly><br/>(kann nicht mehr geändert werden)</td>
	</tr>
	<tr>
		<td>Navigations-levels</td>
		<td>
			<select name="navlevels">
				<option value="1" <cfif navlevels EQ 1>selected="selected"</cfif>>1</option>
				<option value="2" <cfif navlevels EQ 2>selected="selected"</cfif>>2</option>
				<option value="3" <cfif navlevels EQ 3>selected="selected"</cfif>>3</option>
				<option value="4" <cfif navlevels EQ 4>selected="selected"</cfif>>4</option>
				<option value="5" <cfif navlevels EQ 5>selected="selected"</cfif>>5</option>
			</select>
		</td>
	</tr>
	<!--- <tr>
		<td>Domain (ohne www)</td>
		<td><input type="text" name="www" value="#domain#"></td>
	</tr> --->
	<tr>
		<td>
			Module
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showModules').toggle();">verwalten</a>
		</td>
	</tr>
	<tr id="showModules" style="display:none;">
		<td valign="top">Module</td>
		<td>
			<!--- alle module auslesen  --->
			<cfquery name="getModules" datasource="#application.dsn#">
			SELECT	*
			FROM	modules
			</cfquery>
			<cfloop query="getModules">
			<cfquery name="getModules2" datasource="#application.dsn#">
			SELECT	*
			FROM	mandantenmodules
			WHERE	moduleid = #id# AND mandantenid = #url.editMandant#
			</cfquery>
			<input type="checkbox" name="mod" value="#id#" <cfif getModules2.recordcount EQ 1>checked="checked"</cfif> /> #module# <cfif modultyp EQ 2>(Custom-Modul unter /admin/inc/customModules/#customPfad#)</cfif><br/>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td>
			Funktionsfreigaben
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showFunctions').toggle();">verwalten</a>
		</td>
	</tr>
	<tr id="showFunctions" style="display:none;">
		<td valign="top"></td>
		<td>
			<!--- alle module auslesen  --->
			<cfquery name="getFunktionsFreigaben" datasource="#application.dsn#">
			SELECT	*
			FROM	mandantenFunktionsFreigaben
			WHERE	mandant = #url.editmandant#
			</cfquery>
			<cfoutput>
			<table width="100%">
			<tr>
				<td width="220" valign="top">
					Teasers (Page Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasTeasers" value="1" <cfif getFunktionsFreigaben.hasTeasers EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Content-Connect (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasContentConnect" value="1" <cfif getFunktionsFreigaben.hasContentConnect EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Content Teasers (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasContentTeasers" value="1" <cfif getFunktionsFreigaben.hasContentTeasers EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Spalten (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasColumns" value="1" <cfif getFunktionsFreigaben.hasColumns EQ 1>checked="checked"</cfif> onclick="$('##showColumns').toggle();" />
					<div id="showColumns" <cfif getFunktionsFreigaben.hasColumns EQ 0>style="display:none;"</cfif>>
						<input type="checkbox" name="hasColumns2" value="1" <cfif getFunktionsFreigaben.hasColumns2 EQ 1>checked="checked"</cfif> /> 2 Spalten<br/>
						<input type="checkbox" name="hasColumns3" value="1" <cfif getFunktionsFreigaben.hasColumns3 EQ 1>checked="checked"</cfif> /> 3 Spalten<br/>
						<input type="checkbox" name="hasColumns4" value="1" <cfif getFunktionsFreigaben.hasColumns4 EQ 1>checked="checked"</cfif> /> 4 Spalten<br/>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					Formular (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasForm" value="1" <cfif getFunktionsFreigaben.hasForm EQ 1>checked="checked"</cfif> onclick="$('##showForms').toggle();" />
					<div id="showForms" <cfif getFunktionsFreigaben.hasForm EQ 0>style="display:none;"</cfif>>
						<input type="checkbox" name="hasFormCompact" value="1" <cfif getFunktionsFreigaben.hasFormCompact EQ 1>checked="checked"</cfif> /> Kompakt<br/>
						<input type="checkbox" name="hasFormFull" value="1" <cfif getFunktionsFreigaben.hasFormFull EQ 1>checked="checked"</cfif> /> Voll<br/>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					Custom-Includes (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasCustomInclude" value="1" <cfif getFunktionsFreigaben.hasCustomInclude EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Multitemplates (Page Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasMultiTemplates" value="1" <cfif getFunktionsFreigaben.hasMultiTemplates EQ 1>checked="checked"</cfif> onclick="$('##showMultitemplates').toggle();" />
					<div id="showMultitemplates" <cfif getFunktionsFreigaben.hasMultiTemplates EQ 0>style="display:none;"</cfif>>
						<input type="checkbox" name="hasMultiTemplate1" value="1" <cfif getFunktionsFreigaben.hasMultiTemplate1 EQ 1>checked="checked"</cfif> /> Template 1<br/>
						<input type="checkbox" name="hasMultiTemplate2" value="1" <cfif getFunktionsFreigaben.hasMultiTemplate2 EQ 1>checked="checked"</cfif> /> Template 2<br/>
						<input type="checkbox" name="hasMultiTemplate3" value="1" <cfif getFunktionsFreigaben.hasMultiTemplate3 EQ 1>checked="checked"</cfif> /> Template 3<br/>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					Farbschemen (Page Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasColorSchema" value="1" <cfif getFunktionsFreigaben.hasColorSchema EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Multi-Links (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasMultilinks" value="1" <cfif getFunktionsFreigaben.hasMultilinks EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Multi-Dokumente (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasMultiDocs" value="1" <cfif getFunktionsFreigaben.hasMultiDocs EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Galerien Auswahl (Inhalts-Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasGalleryOptions" value="1" <cfif getFunktionsFreigaben.hasGalleryOptions EQ 1>checked="checked"</cfif> onclick="$('##showGalleries').toggle();" />
					<div id="showGalleries" <cfif getFunktionsFreigaben.hasGalleryOptions EQ 0>style="display:none;"</cfif>>
						<input type="checkbox" name="hasGalleryOptions1" value="1" <cfif getFunktionsFreigaben.hasGalleryOptions1 EQ 1>checked="checked"</cfif> /> Thumbnails<br/>
						<input type="checkbox" name="hasGalleryOptions2" value="1" <cfif getFunktionsFreigaben.hasGalleryOptions2 EQ 1>checked="checked"</cfif> /> Full Gallery<br/>
						<input type="checkbox" name="hasGalleryOptions3" value="1" <cfif getFunktionsFreigaben.hasGalleryOptions3 EQ 1>checked="checked"</cfif> /> auf Inhaltsbild<br/>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					Navtypes (Page Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasNavtypes" value="1" <cfif getFunktionsFreigaben.hasNavtypes EQ 1>checked="checked"</cfif> onclick="$('##showNavtypes').toggle();" />
					<div id="showNavtypes" <cfif getFunktionsFreigaben.hasNavtypes EQ 0>style="display:none;"</cfif>>
						<input type="checkbox" name="hasNavtypeService" value="1" <cfif getFunktionsFreigaben.hasNavtypeService EQ 1>checked="checked"</cfif> /> Servicenav<br/>
						<input type="checkbox" name="hasNavtypeThemen" value="1" <cfif getFunktionsFreigaben.hasNavtypeThemen EQ 1>checked="checked"</cfif> /> Themennav<br/>
						<input type="checkbox" name="hasNavtypeFooter" value="1" <cfif getFunktionsFreigaben.hasNavtypeFooter EQ 1>checked="checked"</cfif> /> Footernav<br/>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					Multi-Upload (Galerie Masken)?
				</td>
				<td>
					<input type="checkbox" name="hasMultiUploadGallery" value="1" <cfif getFunktionsFreigaben.hasMultiUploadGallery EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					SOLR Index-Suche
				</td>
				<td>
					<input type="checkbox" name="hasSOLR" value="1" <cfif getFunktionsFreigaben.hasSOLR EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Team-Detailseite
				</td>
				<td>
					<input type="checkbox" name="hasTeamDetail" value="1" <cfif getFunktionsFreigaben.hasTeamDetail EQ 1>checked="checked"</cfif> />
				</td>
			</tr>
			</table>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			Sprache(n)
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showLangs').toggle();">verwalten</a>
		</td>
	</tr>
	<tr id="showLangs" style="display:none;">
		<td>&nbsp;</td>
		<td >
			<table width="100%">
			<tr>
				<td colspan="2">
					<table width="100%" id="sortLangs">
					<tbody>
					<tr><td></td></tr>
					<!--- erst alle sprachen ermitteln --->
					<cfquery name="getLangs" datasource="#application.dsn#">
					SELECT	*
					FROM	mandantensprachen
					WHERE	mandant = #url.editMandant#
					</cfquery>
					<cfset cnt = 1 />
					<cfloop query="getLangs">
						<tr class="langelem">
							<td></td>
							<td>
								<input type="text" name="initSprache#cnt#" value="#language#"  readonly="readonly" /><br/>
								Sprach-Parameter: <input type="text" name="initSpracheParam#cnt#" style="width:100px;" value="#languageParam#"  readonly="readonly" /> (z.B: ch-de)<br/>
								Domain: <input type="text" name="domain#cnt#" value="#domain#" style="width:60%;" /><br/>
								<input type="radio" name="status#cnt#" value="1" <cfif isActive EQ 1>checked="checked"</cfif> /> aktiv&nbsp;&nbsp;
								<input type="radio" name="status#cnt#" value="0" <cfif isActive EQ 0 OR isActive EQ "">checked="checked"</cfif> /> inaktiv&nbsp;&nbsp;<br/>
							</td>
						</tr>
						<cfset cnt = cnt + 1 />
					</cfloop>
					</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<a href="javascript:void(0);" onclick="loadMask('lang');">Weitere Sprache erfassen</a>
				</td>
			</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Feld-Freigaben
		</td>
		<td>
			<a href="javascript:void(0);" onclick="$('##showFieldRights').toggle();">verwalten</a>
		</td>
	</tr>
	<tr id="showFieldRights" style="display:none;">
		<td>&nbsp;</td>
		<td>
			<cfinclude template="inc_mandantenFeldFreigaben.cfm" />
		</td>
	</tr>
	<tr>
		<td><input type="hidden" name="mandantenid" value="#url.editMandant#"></td>
		<td>
			<input type="submit" value="Mandant ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>