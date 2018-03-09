<cfcomponent displayname="flexyFunctions">

	<cffunction name="copyContentByID" returntype="boolean" output="yes" access="public">
		<cfargument name="contentID" type="numeric" required="yes" />
		<cfargument name="parentid" type="numeric" required="no" default="0" />
		<cfargument name="activeContent" type="numeric" required="no" default="0" />
		
		<!--- content auslesen --->
		<cfquery name="getSourceContent" datasource="#application.dsn#">
		SELECT	*
		FROM	content
		WHERE	id = #arguments.contentID#
		</cfquery>
		
		<cfif arguments.parentid GT 0>
			<cfset parentPageID = arguments.parentid />
		<cfelse>
			<cfset parentPageID = getSourceContent.pageid />
		</cfif>
		
		
		<!--- max reihenfolge auselesen --->
		<cfquery name="getMaxReihenfolge" datasource="#application.dsn#">
		SELECT	MAX(reihenfolge) as maxi
		FROM	content
		WHERE	pageid = #getSourceContent.pageid#
		</cfquery>
		<cfif isNumeric(getMaxReihenfolge.maxi)>
			<cfset newReihenfolge = getMaxReihenfolge.maxi + 10 />
		<cfelse>
			<cfset newReihenfolge = 10 />
		</cfif>
		<!--- wenn vorhanden, bild auf dem server kopieren --->
		<cfif getSourceContent.bildname NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/img/#getSourceContent.bildname#'))>
			<cffile action="copy" source="#expandPath('/' & session.serverpath & '/upload/img/' & getSourceContent.bildname)#" destination="#expandPath('/' & session.serverpath & '/upload/img/')#\kopie_#getSourceContent.bildname#" />
			<cfset bild = "kopie_" & getSourceContent.bildname />
		<cfelse>
			<cfset bild = "" />
		</cfif>
		<!--- WICHTIG: DOKUMENTE werden nicht kopiert. hab ich einfach mal so definiert :-) --->
		<!--- neuer content mit identischer parentID und neuer reihenfolge in db schreiben --->
		<cfquery name="insertCopiedContent" datasource="#application.dsn#">
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
				#parentPageID#,
				<cfif arguments.activeContent EQ 1>1<cfelse>0</cfif>,
				#createODBCdatetime(now())#,
				'KOPIE VON: #getSourceContent.titel#',
				'#getSourceContent.lead#',
				'#getSourceContent.fliesstext#',
				'#bild#',
				'#getSourceContent.href#',
				'#getSourceContent.hreflabel#',
				#getSourceContent.hascontact#,
				#getSourceContent.albumid#,
				#getSourceContent.contactType#,
				'#getSourceContent.contactreciever#',
				'#getSourceContent.contactsender#',
				'#getSourceContent.contactsubject#',
				'#getSourceContent.custominclude#',
				#getSourceContent.imagepos#,
				#newReihenfolge#,
				'#getSourceContent.imagecaption#',
				#getSourceContent.fliesstextspalten#
		)
		</cfquery>
		<cfquery name="getMaxID" datasource="#application.dsn#">
		SELECT	MAX(id) as maxi
		FROM	content
		</cfquery>
		<cfset newIDx = getMaxID.maxi />
		
		<!--- tabsystem kopieren --->
		<cfquery name="getTabedContent" datasource="#application.dsn#">
		SELECT	*
		FROM	contents2content
		WHERE	maincontentID = #arguments.contentID#
		</cfquery>
		<cfif getTabedContent.recordcount GT 0>
			<cfoutput query="getTabedContent">
				<cfquery name="insertNewContentLink" datasource="#application.dsn#">
				INSERT
				INTO	contents2content(mainContentId,LinkedContentID)
				VALUES(
						#newIDx#,
						#LinkedContentID#
				)
				</cfquery>
			</cfoutput>
		</cfif>

		<cfreturn true />
	</cffunction>
	
	<!--- =================================================================================== --->


	<cffunction name="copyPageByID" returntype="boolean" access="public" output="yes">
		<cfargument name="pageId" type="numeric" required="yes" />
		
		<!--- page auslesen --->
		<cfquery name="getSourcePage" datasource="#application.dsn#">
		SELECT	*
		FROM	pages
		WHERE	id = #arguments.pageID#
		</cfquery>
		<!--- max reihenfolge auselesen --->
		<cfquery name="getMaxReihenfolge" datasource="#application.dsn#">
		SELECT	MAX(navorder) as maxi
		FROM	pages
		WHERE	parentid = #getSourcePage.parentID#
		</cfquery>
		<cfif isNumeric(getMaxReihenfolge.maxi)>
			<cfset newReihenfolge = getMaxReihenfolge.maxi + 10 />
		<cfelse>
			<cfset newReihenfolge = 10 />
		</cfif>
		<!--- wenn vorhanden, bild auf dem server kopieren --->
		<cfif getSourcePage.headerbild NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/img/#getSourcePage.headerbild#'))>
			<cffile action="copy" source="#expandPath('/' & session.serverpath & '/upload/img/' & getSourcePage.headerbild)#" destination="#expandPath('/' & session.serverpath & '/upload/img/')#\kopie_#getSourcePage.headerbild#" />
			<cfset bild = "kopie_" & getSourcePage.headerbild />
		<cfelse>
			<cfset bild = "" />
		</cfif>
		<cfquery name="insertPage" datasource="#application.dsn#">
		INSERT	
		INTO	pages (parentUser, createdate, isactive, navPos, navTitel, pageTitel, metaTitel, metaKeys, metaDesc, parentID, navorder, headerbild, template, mandant, urlshortcut, templatecolorschema)
		VALUES	(
				#session.userid#,
				#createODBCDateTime(now())#,
				0,
				#getSourcePage.navPos#,
				'KOPIE VON: #getSourcePage.navTitel#',
				'KOPIE VON: #getSourcePage.pageTitel#',
				'KOPIE VON: #getSourcePage.metaTitel#',
				'#getSourcePage.metaKeys#',
				'#getSourcePage.metaDesc#',
				#getSourcePage.parentID#,
				#newReihenfolge#,
				'#bild#',
				#getSourcePage.template#,
				'#session.serverpath#',
				'KOPIE-VON-#getSourcePage.urlshortcut#',
				#getSourcePage.templatecolorschema#
		)
		</cfquery>
		<cfquery name="getMaxID" datasource="#application.dsn#">
		SELECT	MAX(id) as maxi
		FROM	pages
		</cfquery>
		<cfset newID = getMaxID.maxi />
		<!--- copy all contents from this page --->
		<!--- associate headerpanels --->
		<cfquery name="getHeaderpanels" datasource="#application.dsn#">
		SELECT	*
		FROM	headerpanels2pages
		WHERE	pageid = #arguments.pageID#
		ORDER	BY reihenfolge
		</cfquery>
		<cfoutput query="getHeaderpanels">
			<cfquery name="getHeaderpanels" datasource="#application.dsn#">
			INSERT
			INTO	headerpanels2pages(
					pageID,
					headerpanelID,
					reihenfolge 
			)
			VALUES(
					#newID#,
					#headerpanelID#,
					#reihenfolge#
			)
			</cfquery>
		</cfoutput>
		<!--- associate sidebar elems --->
		<cfquery name="getSidebars" datasource="#application.dsn#">
		SELECT	*
		FROM	sidebar2pages
		WHERE	pageid = #arguments.pageID#
		ORDER	BY reihenfolge
		</cfquery>
		<cfoutput query="getSidebars">
			<cfquery name="setSidebars" datasource="#application.dsn#">
			INSERT
			INTO	sidebar2pages(
					pageID,
					sidebarID,
					reihenfolge 
			)
			VALUES(
					#newID#,
					#sidebarID#,
					#reihenfolge#
			)
			</cfquery>
		</cfoutput>
		<!--- associate teaser elems --->
		<cfquery name="getTeasers" datasource="#application.dsn#">
		SELECT	*
		FROM	teaser2pages
		WHERE	pageid = #arguments.pageID#
		ORDER	BY reihenfolge
		</cfquery>
		<cfoutput query="getTeasers">
			<cfquery name="setTeasers" datasource="#application.dsn#">
			INSERT
			INTO	teaser2pages(
					pageID,
					sidebarID,
					reihenfolge 
			)
			VALUES(
					#newID#,
					#sidebarID#,
					#reihenfolge#
			)
			</cfquery>
		</cfoutput>
		
		<cfquery name="getSourceContent" datasource="#application.dsn#">
		SELECT	*
		FROM	content
		WHERE	pageid = #arguments.pageID#
		</cfquery>
		
		<cfoutput query="getSourceContent">
			<cfset copyNow = copyContentByID(contentid=id,parentid=newID,activeContent=1) />
		</cfoutput>
	
		<cfreturn true />
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<!---
	 Copies a directory.
	 v3 mod by Anthony Petruzzi
	 
	 @param source      Source directory. (Required)
	 @param destination      Destination directory. (Required)
	 @param ignore      List of folders, files to ignore. Defaults to nothing. (Optional)
	 @param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
	 @return Returns nothing. 
	 @author Joe Rinehart (joe.rinehart@gmail.com) 
	 @version 3, April 26, 2011 
	--->
	<cffunction name="directoryCopy" output="true">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		<cfargument name="ignore" required="false" type="string" default="">
		<cfargument name="nameconflict" required="true" default="overwrite">
	
		<cfset var contents = "" />
		
		<cfif not(directoryExists(arguments.destination))>
			<cfdirectory action="create" directory="#arguments.destination#">
		</cfif>
		
		<cfdirectory action="list" directory="#arguments.source#" name="contents">
	
		<cfif len(arguments.ignore)>
			<cfquery dbtype="query" name="contents">
			select * from contents where name not in(#ListQualify(arguments.ignore, "'")#)
			</cfquery>
		</cfif>
		
		<cfloop query="contents">
			<cfif contents.type eq "file">
				<cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
			<cfelseif contents.type eq "dir">
				<cfset directoryCopy(arguments.source & "/" & name, arguments.destination & "/" &  name) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="copyDirectory" output="false">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		
		<cfset var uid = CreateUUID()>
		<cfzip file="#expandPath('/admin/inc/')##uid#.zip" recurse="yes" source="#arguments.source#" storePath="yes" />
		<cfzip action="unzip" file="#expandPath('/admin/inc/')##uid#.zip" destination="#arguments.destination#" storePath="yes" />
		<cffile action="delete" file="#expandPath('/admin/inc/')##uid#.zip">
	
	</cffunction>
	
	<!--- =================================================================================== --->
	
	<!--- <cffunction name="insertActivity" output="false">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		
		<!--- activity log aufzeichnung von form-posts --->
		<cfquery name="insertActivity" datasource="#application.dsn#">
		INSERT	
		INTO	useractivitylog(
					datumZeit,
					userID,
					mandant,
					urlx, 
					dumpx, 
					module,
					dumpx2
				)
		VALUES(
			#createODBCDateTime(now())#,
			#session.userID#,
			#session.mandant#,
			'#cgi.SCRIPT_NAME#<cfif cgi.QUERY_STRING NEQ "">?#cgi.QUERY_STRING#</cfif>',
			<cfwddx action="cfml2wddx" input="#form#" output="formularEingaben" />
			'#formularEingaben#',
			#session.moduleID#,
			<cfsavecontent variable="formFormated">
				<cfloop list="#form.fieldnames#" index="i">
					<strong>#i#</strong>: #evaluate("form." & i)#<hr/>
				</cfloop>
			</cfsavecontent>
			'#formFormated#'
		)
		</cfquery>
	
	</cffunction> --->
	
	<!--- =================================================================================== --->
	
	<cffunction name="setHelpText" output="true">
		<cfargument name="variable" required="false" default="" type="string">
		<cfargument name="type" required="no" default="1" type="numeric">
		<cfargument name="visualType" required="no" default="1" type="numeric">
		<cfargument name="catID" required="no" default="0" type="numeric">
		<cfargument name="catType" required="no" default="0" type="numeric">
		
		<cfquery name="getHelpTextModul" datasource="#application.dsn#">
		SELECT	*
		FROM	helpTextModule
		WHERE	id = '#arguments.catID#'
		</cfquery>
		
		<cfquery name="getHelpText" datasource="#application.dsn#">
		SELECT	*
		FROM	helpText
		WHERE	variable = '#arguments.variable#'
		</cfquery>
		
		<cfoutput>
			<cfif arguments.catID NEQ 0>
				<cfif getHelpTextModul.recordcount EQ 1>
					<div style="padding-bottom:30px;margin:1em;position:relative;">
						<div>
							<span> <strong>#getHelpTextModul.ModulTitel#</strong> </span>		
							<cfif arguments.catType EQ 1>
								#getHelpTextModul.modulBeschreibung_simple#
							<cfelse>
								#getHelpTextModul.modulBeschreibung_full#
							</cfif>
						</div>
						<div style="position:absolute;right:10px;top:10px;">
							<div style="float:right;padding-left:10px;">
								<a href="javascript:void(0);" onclick="$(this).parent().parent().prev().toggle();" title="verbergen">
									-
								</a>
							</div>
							<div style="float:right;padding-left:10px;">
								<a href="javascript:void(0);" onclick="$(this).parent().parent().parent().remove();" title="schliessen">
									x
								</a>
							</div>
							<div style="clear:both;"></div>
						</div>
					</div>	
				</cfif>
			<cfelse>
				<cfif getHelpText.recordcount EQ 1>	
					<!--- tooltip = arguments.visualType = 1 --->
					<cfif arguments.visualType EQ 1>
						<div style="position:relative;width:10px;padding:5px;border:1px solid grey;" class="toolTipWrapper">
							<!--- info --->
							<cfif arguments.type EQ 1>
								<span> ? </span>	
							<!--- important --->
							<cfelseif arguments.type EQ 2>
								<span> ! </span>	
							<!--- warning --->
							<cfelseif arguments.type EQ 3>
								<span> * </span>		
							</cfif>
							<div style="display:none;position:absolute;left:-1px;z-index:2;top:25px;width:160px;background-color:<cfif arguments.type EQ 1>white<cfelseif arguments.type EQ 2>orange<cfelseif arguments.type EQ 3>red;color:white</cfif>;border:1px solid black;padding:10px;" class="tooltip">
								<!--- info --->
								<cfif arguments.type EQ 1>
									<span> <strong>Information</strong> </span>	
								<!--- important --->
								<cfelseif arguments.type EQ 2>
									<span> <strong>Wichtig</strong> </span>	
								<!--- warning --->
								<cfelseif arguments.type EQ 3>
									<span> <strong>Warnung</strong> </span>		
								</cfif>
								
								#getHelpText.helptext#
							</div>
						</div>	
					<!--- collapsable panel --->
					<cfelseif arguments.visualType EQ 2>
						<div style="background-color:<cfif arguments.type EQ 1>white<cfelseif arguments.type EQ 2>orange<cfelseif arguments.type EQ 3>red;color:white</cfif>;border:1px solid black;padding:10px;padding-bottom:30px;margin:1em;position:relative;" class="tooltip">
							<div>
								<!--- info --->
								<cfif arguments.type EQ 1>
									<span> <strong>Information</strong> </span>	
								<!--- important --->
								<cfelseif arguments.type EQ 2>
									<span> <strong>Wichtig</strong> </span>	
								<!--- warning --->
								<cfelseif arguments.type EQ 3>
									<span> <strong>Warnung</strong> </span>		
								</cfif>
								#getHelpText.helptext#
							</div>
							<div style="position:absolute;right:10px;top:10px;">
								<div style="float:right;padding-left:10px;">
									<a href="javascript:void(0);" onclick="$(this).parent().parent().prev().toggle();" title="verbergen">
										-
									</a>
								</div>
								<div style="float:right;padding-left:10px;">
									<a href="javascript:void(0);" onclick="$(this).parent().parent().parent().remove();" title="schliessen">
										x
									</a>
								</div>
								<div style="clear:both;"></div>
							</div>
						</div>	
					<!--- lightbox --->
					<cfelseif arguments.visualType EQ 3>
						<a href="##data#getHelpText.id#" style="color:black;text-decoration:none;display:block;position:relative;width:10px;padding:5px;border:1px solid grey;background:none;" class="fancyboxToolTip">
							<!--- info --->
							<cfif arguments.type EQ 1>
								<span> ? </span>	
							<!--- important --->
							<cfelseif arguments.type EQ 2>
								<span> ! </span>	
							<!--- warning --->
							<cfelseif arguments.type EQ 3>
								<span> * </span>		
							</cfif>
						</a>
						<div style="display:none;">
							<div id="data#getHelpText.id#" style="padding:10px;font-size:0.8em;background-color:<cfif arguments.type EQ 1>white<cfelseif arguments.type EQ 2>orange<cfelseif arguments.type EQ 3>red;color:white</cfif>;">
								<!--- info --->
								<cfif arguments.type EQ 1>
									<span> <strong>Information</strong> </span>	
								<!--- important --->
								<cfelseif arguments.type EQ 2>
									<span> <strong>Wichtig</strong> </span>	
								<!--- warning --->
								<cfelseif arguments.type EQ 3>
									<span> <strong>Warnung</strong> </span>		
								</cfif>
								#getHelpText.helptext#
							</div>
						</div>
					<!--- link --->
					<cfelseif arguments.visualType EQ 4>
						<div style="position:relative;color:black;text-decoration:none;display:block;background:none;" class="toolTipWrapper">
							<!--- info --->
							<cfif arguments.type EQ 1>
								<span> <strong>Information</strong> </span>	
							<!--- important --->
							<cfelseif arguments.type EQ 2>
								<span> <strong>Wichtig</strong> </span>	
							<!--- warning --->
							<cfelseif arguments.type EQ 3>
								<span> <strong>Warnung</strong> </span>		
							</cfif>
							<div style="display:none;position:absolute;left:0;z-index:2;top:20px;border:1px solid black;width:160px;padding:0px 10px 0 10px;background-color:<cfif arguments.type EQ 1>white<cfelseif arguments.type EQ 2>orange<cfelseif arguments.type EQ 3>red;color:white</cfif>;" class="tooltip">
								#getHelpText.helptext#
							</div>
						</div>
					</cfif>
				</cfif>
			
			</cfif>
		</cfoutput>
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="generateRandom" output="true">
		<cfargument name="lenofpass" default="12" required="no" />
		
		 <cfscript>
		  var tNumeric=2;
		  var tSpecial=1;
		  var tUppder =2;
		  var tLower = arguments.lenofpass - (tNumeric + tSpecial + tUppder);
		  var charset = ArrayNew(1);
		  var generatedPass = "";

		  charset[1] = "qwertyuiopasdfghjklzxcvbnm";
		  charset[2] = uCase(charset[1]);
		  charset[3] =  "~!@##$%^&*?";
		  charset[4] = "1234567890";
		  for(i=1;i<=tLower;i=i+1)
		  {
		   generatedPass = generatedPass & mid(charset[1],randRange(1,len(charset[1])-1)+1,1);
		  }
		  for(i=1;i<=tUppder;i=i+1)
		  {
		   insertAt = randRange(2,len(generatedPass)-1);  
		   generatedPass = left(generatedPass,insertAt-1) & mid(charset[2],randRange(1,len(charset[2])-1)+1,1) & right(generatedPass,len(generatedPass)-insertAt+1);
		  }
		  for(i=1;i<=tNumeric;i=i+1)
		  {
		   insertAt = randRange(2,len(generatedPass)-1);  
		   generatedPass = left(generatedPass,insertAt-1) & mid(charset[4],randRange(1,len(charset[4])-1)+1,1) & right(generatedPass,len(generatedPass)-insertAt+1);
		  }
		  for(i=1;i<=tSpecial;i=i+1)
		  {
		   insertAt = randRange(2,len(generatedPass)-1);  
		   generatedPass = left(generatedPass,insertAt-1) & mid(charset[3],randRange(1,len(charset[3])-1)+1,1) & right(generatedPass,len(generatedPass)-insertAt+1);
		  }
		</cfscript>
	
		<cfreturn trim(generatedPass) />
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="deleteEntirePage" output="false">
		<cfargument name="delpage" default="0" required="no" />
		
		<cfquery name="delPagex" datasource="#application.dsn#">
		DELETE
		FROM	pages
		WHERE	id = #arguments.delpage#
		</cfquery>
		<!--- alle headerpanels aus page löschen --->
		<cfquery name="delHeaderpanels" datasource="#application.dsn#">
		DELETE
		FROM	headerpanels2pages
		WHERE	pageID = #arguments.delpage#
		</cfquery>
		<!--- alle sidebars aus page löschen --->
		<cfquery name="delHeaderpanels" datasource="#application.dsn#">
		DELETE
		FROM	sidebar2pages
		WHERE	pageID = #arguments.delpage#
		</cfquery>
		<!--- alle teasers aus page löschen --->
		<cfquery name="delHeaderpanels" datasource="#application.dsn#">
		DELETE
		FROM	teaser2pages
		WHERE	pageID = #arguments.delpage#
		</cfquery>
		<!--- alle usergruppen assoziationen löschen --->
		<cfquery name="delUserGroups" datasource="#application.dsn#">
		DELETE
		FROM	usergroups2pages
		WHERE	pageID = #arguments.delpage#
		</cfquery>
		<!--- contents auslesen --->
		<cfquery name="getcontents" datasource="#application.dsn#">
		SELECT	*
		FROM	content
		WHERE	pageid = #arguments.delpage#
		</cfquery>
		<cfloop query="getcontents">
			<cfquery name="getcontent" datasource="#application.dsn#">
			SELECT	*
			FROM	content
			WHERE	id = #id#
			</cfquery>
			<!--- aus contents2content zwischentabelle löschen --->
			<cfquery name="delcontent" datasource="#application.dsn#">
			DELETE
			FROM	contents2content
			WHERE	mainContentID = #id#
			</cfquery>
			<!--- aus links2pages zwischentabelle löschen --->
			<cfquery name="delcontentlinks" datasource="#application.dsn#">
			DELETE
			FROM	links2pages
			WHERE	contentid = #id#
			</cfquery>	
			<!--- bild löschen --->
			<cfif getcontent.bildname NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/img/#getcontent.bildname#'))>
				<cffile action="delete" file="#expandPath('/' & session.serverpath & '/upload/img/' & getcontent.bildname)#" />
			</cfif>
			<!--- alle docs aus zwischentabelle physisch vom server löschen --->
			<!--- erst alle docs auslesen --->
			<cfquery name="getdocs" datasource="#application.dsn#">
			SELECT	*
			FROM	docs2pages
			WHERE	contentid = #id#
			</cfquery>
			<cfif getdocs.recordcount GT 0>
				<!--- durch alle docs loopen und physisch löschen --->
				<cfoutput query="getdocs">
					<cfif dok NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/doc/#dok#'))>
						<cffile action="delete" file="#expandPath('/' & session.serverpath & '/upload/doc/' & dok)#" />
					</cfif>
				</cfoutput>
			</cfif>
			<!--- alle einträge aus docs2pages zwischentabelle löschen --->
			<cfquery name="delcontent2" datasource="#application.dsn#">
			DELETE
			FROM	docs2pages
			WHERE	contentid = #id#
			</cfquery>
			<!--- inhalt definitiv löschen --->	
			<cfquery name="delcontent3" datasource="#application.dsn#">
			DELETE
			FROM	content
			WHERE	id = #id#
			</cfquery>	
		</cfloop>
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="deleteEntireMandant" output="false">
		<cfargument name="delmandant" default="0" required="no" />		
		
		<!--- erst den zu löschenden mandanten auslesen --->
		<cfquery name="getMandantById" datasource="#application.dsn#">
		SELECT	*
		FROM	mandanten
		WHERE	id = #arguments.delmandant#
		</cfquery>
		<!--- get all pages from mandant --->
		<cfquery name="getPagesByMandant" datasource="#application.dsn#">
		SELECT	*
		FROM	pages
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		
		<!--- init component
		<cfset flexyLib = createObject('component','admin.cfc.flexy') /> --->
		<!--- loop through pages and execute deletePage method --->
		<cfoutput query="getPagesByMandant">
			<cfset delPage = deleteEntirePage(delpage=id) />
		</cfoutput>
		<!--- lösche alles aus mandantenmodules tabelle --->
		<cfquery name="delmandantenmodules" datasource="#application.dsn#">
		DELETE
		FROM	mandantenmodules
		WHERE	mandantenid = #arguments.delmandant#
		</cfquery>
		<!--- lösche alle zu diesem mandanten assozierten users --->
		<!--- zuerst lese alle users aus (um ander zwischentabell mit userID zu löschen) --->
		<cfquery name="getAllUsersByMandantenID" datasource="#application.dsn#">
		SELECT	*
		FROM	user
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<cfoutput query="getAllUsersByMandantenID">
			<cfquery name="delusermodules" datasource="#application.dsn#">
			DELETE
			FROM	usermodules
			WHERE	userid = #id#
			</cfquery>
		</cfoutput>
		<!--- nun lösche alle users --->
		<cfquery name="delusermodules2" datasource="#application.dsn#">
		DELETE
		FROM	user
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<!--- jetzt müsste man den ordner löschen --->
		
		<!--- lösche settings-eintrag --->
		<cfquery name="delmandantsettings" datasource="#application.dsn#">
		DELETE
		FROM	settings
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<!--- lösche mandantensprachen --->
		<cfquery name="delmandantensprachen" datasource="#application.dsn#">
		DELETE
		FROM	mandantensprachen
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<!--- lösche bildresize-einträge --->
		<cfquery name="delbildresizes" datasource="#application.dsn#">
		DELETE
		FROM	feldbildsize
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<!--- lösche toolbaritems für wysiwyg editor --->
		<cfquery name="deltoolbaritems" datasource="#application.dsn#">
		DELETE
		FROM	feldtoolbaritems
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<!--- lösche mandanten funktionsfreigaben --->
		<cfquery name="delmandantenfunktionen" datasource="#application.dsn#">
		DELETE
		FROM	mandantenfunktionsfreigaben
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<!--- lösche mandanten startseiten/sprachen --->
		<cfquery name="delmandantenstart" datasource="#application.dsn#">
		DELETE
		FROM	langstartpages2mandanten
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		
		<!--- alle cug-gruppen dieses mandanten auslesen --->
		<cfquery name="getCUGGroups" datasource="#application.dsn#">
		SELECT	*
		FROM	cuggroups
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<cfoutput query="getCUGGroups">
			
			<!--- alle cug-users dieser gruppe lesen --->
			<cfquery name="getCUGUsers" datasource="#application.dsn#">
			SELECT
			FROM	cugusers
			WHERE	groupID = #id#
			</cfquery>
			<cfloop query="getCUGUsers">
				<!--- alle cug-users aus userlog löschen --->
				<cfquery name="delCUGUserLog" datasource="#application.dsn#">
				DELETE
				FROM	cuguserlog
				WHERE	cugUserID = #id#
				</cfquery>
			</cfloop>
			<!--- alle cug-users dieser gruppe löschen --->
			<cfquery name="delCUGUsers" datasource="#application.dsn#">
			DELETE
			FROM	cugusers
			WHERE	groupID = #id#
			</cfquery>
			<!--- zwischentabelle usergroups2pages löschen --->
			<cfquery name="delCUGUsers" datasource="#application.dsn#">
			DELETE
			FROM	usergroups2pages
			WHERE	userGroupID = #id#
			</cfquery>
		</cfoutput>
		<!--- alle cug-gruppen löschen --->
		<cfquery name="delCUGUsers" datasource="#application.dsn#">
		DELETE
		FROM	cuggroups
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		
		
		
		<!--- Löschen aus anderen Modulen --->
		<!--- HeaderPanels --->
		<cfquery name="delHeaderpanels" datasource="#application.dsn#">
		DELETE
		FROM	headerpanels
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		
		
		<!--- news --->
		<cfquery name="delNews" datasource="#application.dsn#">
		DELETE
		FROM	news
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		
		
		<!--- galleries --->
		<cfquery name="getGalleries" datasource="#application.dsn#">
		SELECT 	*
		FROM	albums
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		<cfoutput query="getGalleries">
			<cfquery name="delImages" datasource="#application.dsn#">
			DELETE
			FROM	albumimages
			WHERE	albumid = #id#
			</cfquery>
		</cfoutput>
		
		
		<!--- teasers --->
		<cfquery name="delTeaserSidebars" datasource="#application.dsn#">
		DELETE
		FROM	sidebar
		WHERE	mandant = #arguments.delmandant#
		</cfquery>
		
		<cfset DirectoryDelete(expandPath('/' & getMandantById.directoryname), true) />
		
		<!--- jetzt lösche endgültig den mandanten --->
		<cfquery name="delmandantx" datasource="#application.dsn#">
		DELETE
		FROM	mandanten
		WHERE	id = #arguments.delmandant#
		</cfquery>
		
		
		
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="deleteContent" output="false">
		<cfargument name="content" default="0" required="no" />	
		
		<cfquery name="getcontent" datasource="#application.dsn#">
		SELECT	*
		FROM	content
		WHERE	id = #arguments.content#
		</cfquery>
		
		<!--- ermittelv von contentID aus, welcher serverpfad via pages und dann mandanten tabelle verwendet werden muss, um files vom server zu löschen --->
		<cfquery name="getPage" datasource="#application.dsn#">
		SELECT	M.directoryname as dir
		FROM 	((content c left join pages p on c.pageid = p.id)  LEFT JOIN mandanten M ON M.id = P.mandant)
		WHERE	c.id = #arguments.content#
		</cfquery>
		
		<cfset serverpath = getPage.dir />
		
		<!--- aus contents2content zwischentabelle löschen --->
		<cfquery name="delcontent" datasource="#application.dsn#">
		DELETE
		FROM	contents2content
		WHERE	mainContentID = #arguments.content#
		</cfquery>
		<!--- aus links2pages zwischentabelle löschen --->
		<cfquery name="delcontent" datasource="#application.dsn#">
		DELETE
		FROM	links2pages
		WHERE	contentid = #arguments.content#
		</cfquery>	
		<!--- aus teaser2content zwischentabelle löschen --->
		<cfquery name="delcontentteasers" datasource="#application.dsn#">
		DELETE
		FROM	teaser2content
		WHERE	contentid = #arguments.content#
		</cfquery>	
		<!--- bild löschen --->
		
		<cfif getcontent.bildname NEQ "" AND fileExists(expandPath('/#serverpath#/upload/img/') & getcontent.bildname)>
			<cffile action="delete" file="#expandPath('/' & serverpath & '/upload/img/') & getcontent.bildname#" />
		</cfif>
		
		<cfif getcontent.doc NEQ "" AND fileExists(expandPath('/#serverpath#/upload/doc/') & getcontent.doc)>
			<cffile action="delete" file="#expandPath('/' & serverpath & '/upload/doc/') & getcontent.doc#" />
		</cfif>
		
		<!--- alle docs aus zwischentabelle physisch vom server löschen --->
		<!--- erst alle docs auslesen --->
		<cfquery name="getdocs" datasource="#application.dsn#">
		SELECT	*
		FROM	docs2pages
		WHERE	contentid = #arguments.content#
		</cfquery>
		<cfif getdocs.recordcount GT 0>
			<!--- durch alle docs loopen und physisch löschen --->
			<cfoutput query="getdocs">
				<cfif dok NEQ "" AND fileExists(expandPath('/#serverpath#/upload/doc/') & dok)>
					<cffile action="delete" file="#expandPath('/' & serverpath & '/upload/doc/') & dok#" />
				</cfif>
			</cfoutput>
		</cfif>
		<!--- alle einträge aus docs2pages zwischentabelle löschen --->
		<cfquery name="delcontent" datasource="#application.dsn#">
		DELETE
		FROM	docs2pages
		WHERE	contentid = #arguments.content#
		</cfquery>
		<!--- inhalt definitiv löschen --->	
		<cfquery name="delcontent" datasource="#application.dsn#">
		DELETE
		FROM	content
		WHERE	id = #arguments.content#
		</cfquery>		
		
	</cffunction>	
	
	
	<!--- =================================================================================== --->
	
	<cffunction name="deleteMagazinePage" access="public" returntype="void">
		<cfargument name="magPageId" required="yes" type="numeric">
	
		<cfquery name="delElements" datasource="#application.dsn#">
		DELETE
		FROM	magazininhaltselemente
		WHERE	magazinPageID = #arguments.magPageId#
		</cfquery>
		
		<cfquery name="delMagPage" datasource="#application.dsn#">
		DELETE
		FROM	magazinseiten
		WHERE	id = #arguments.magPageId#
		</cfquery>
		
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="delMagazinSlide" access="public" returntype="void">
		<cfargument name="magSlideId" required="yes" type="numeric">
		<cfargument name="magSlideTemplate" required="yes" type="numeric">
	
		<cfquery name="delMagazinSlide" datasource="#application.dsn#">
		DELETE
		FROM	magazinslidetpl_#arguments.magSlideTemplate#
		WHERE	slideID = #arguments.magSlideId#
		</cfquery>
		
		<cfquery name="delMagSlide" datasource="#application.dsn#">
		DELETE
		FROM	magazinslides
		WHERE	id = #arguments.magSlideId#
		</cfquery>
		
	</cffunction>
	
	<!--- =================================================================================== --->
	
	<cffunction name="delMagChapter" access="public" returntype="void">
		<cfargument name="magChapterId" required="yes" type="numeric">
	
		<cfquery name="getMagPages" datasource="#application.dsn#">
		SELECT	*
		FROM	magazinseiten
		WHERE	parent = #arguments.magChapterId#
		</cfquery>
		
		<cfoutput query="getMagPages">
			<cfset deleteMagazinePage(magPageId=id) />
		</cfoutput>
		
		<cfquery name="delMagPages" datasource="#application.dsn#">
		DELETE
		FROM	magazinkapitel
		WHERE	id = #arguments.magChapterId#
		</cfquery>
		
		
	</cffunction>
	
	<!--- =================================================================================== --->
	
	<cffunction name="delMagEdition" access="public" returntype="string">
		<cfargument name="magEditionId"  required="yes" type="numeric">
	
		<cfquery name="getMagChapters" datasource="#application.dsn#">
		SELECT	*
		FROM	magazinkapitel
		WHERE	magazinAusgabeID = #arguments.magEditionId#
		</cfquery>
		
		<cfoutput query="getMagChapters">
			<cfset delMagChapter(magChapterId=id) />
		</cfoutput>
		
		<cfquery name="delMagEdition" datasource="#application.dsn#">
		DELETE
		FROM	magazinausgaben
		WHERE	id = #arguments.magEditionId#
		</cfquery> 
		
		<cfreturn "x">
	</cffunction>
	
	<!--- =================================================================================== --->
	
	
	<cffunction name="delMag" access="public" returntype="void">
		<cfargument name="magId" required="yes" type="numeric">
	
		<cfquery name="getMagEditions" datasource="#application.dsn#">
		SELECT	*
		FROM	magazinausgaben
		WHERE	magazinID = #arguments.magId#
		</cfquery>
		
		<cfoutput query="getMagEditions">
			<cfset delMagEdition(magEditionId=id) />
		</cfoutput>
		
		<cfquery name="getMag" datasource="#application.dsn#">
		SELECT	*
		FROM	magazin
		WHERE	id = #arguments.magId#
		</cfquery>
		
		<!--- bild löschen --->
		<cfif getMag.image NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/magazine/#getMag.image#'))>
			<cffile action="delete" file="#expandPath('/' & session.serverpath & '/upload/magazine/' & getMag.image)#" />
		</cfif>
		
		<cfquery name="delMag" datasource="#application.dsn#">
		DELETE
		FROM	magazine
		WHERE	id = #arguments.magId#
		</cfquery>
	
	</cffunction>
	
	<!--- =================================================================================== --->
	
</cfcomponent>