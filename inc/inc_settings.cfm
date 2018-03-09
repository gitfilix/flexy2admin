<cfprocessingdirective pageencoding="utf-8" />



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


<!--- alle Settings auslesen datasource application --->
<cfquery name="getSettings" datasource="#application.dsn#">
SELECT	*
FROM	settings
WHERE	mandant = #session.mandant#
</cfquery>

<cfquery name="getPages" datasource="#application.dsn#">
SELECT	*
FROM	pages
WHERE	mandant = #session.mandant#
</cfquery>

<cfquery name="getLangs" datasource="#application.dsn#">
SELECT	*
FROM	mandantensprachen
WHERE	mandant = #session.mandant#
</cfquery>




<!--- Settings updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededitedSettings">
	<cfset actionSuceeded = true />
	
	
	<!--- erst alle einträge in zw-tabelle löschen --->
	<cfquery name="delLangs" datasource="#application.dsn#">
	DELETE
	FROM	langstartpages2mandanten
	WHERE	mandant = #session.mandant#
	</cfquery>
	<cfloop query="getLangs">
		<cfif isdefined("form.startseite-" & languageParam)>
			<cfquery name="insertLangStartPages" datasource="#application.dsn#">
			INSERT
			INTO  	langstartpages2mandanten(
					mandant,
					lang,
					startpage
			)
			VALUES(
					#session.mandant#,
					'#languageParam#',
					#form['startseite-' & languageParam]#
			)
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfquery name="updatesettings" datasource="#application.dsn#">
	UPDATE	settings
	SET		defaultlang = '#form.defaultlang#'
	WHERE	mandant = #session.mandant#
	</cfquery>
	<!--- <!--- update config.xml --->
	<cffile action="read" file="#expandPath('/') & session.serverpath & '\config.xml'#" variable="myxml">
	<cfset mydoc = XmlParse(myxml)>
	<cfset bar = xmlSearch(mydoc,"/flexy_config/..")>
	<cfset bar[1].flexy_config.startpageID.xmlText = form.startseite>
	<!--- xml im zielordner speichern --->
	<cfset XMLText=ToString(bar[1])>
	<cffile action="write" file="#expandPath('/') & session.serverpath & '\config.xml'#" output="#XMLText#" nameconflict="overwrite"> --->
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
<cfelse>
	<!--- <cffile action="read" file="#expandPath('/') & session.serverpath & '\config.xml'#" variable="myxml">
	<cfset MyXMLDoc = xmlParse(myxml)> 
	<cfset startID = MyXMLDoc.flexy_config.startpageID.xmlText /> --->
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->

<!--- Helptext variable flexyLib initialisieren  --->
<cfset flexyLib = createObject('component','admin.cfc.flexy') />

<!--- liste mit allen Einstellungen darstellen --->
	<h2>Settings</h2>

	
<cfoutput query="getSettings">
	<h3>Settings  bearbeiten</h3>
	<!--- #remoteServerPath# --->
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedSettings" method="post" enctype="multipart/form-data">
	<table width="50%">
	<tr>
		<td colspan="2">
			#flexyLib.setHelpText(variable='settings_startpage',type=2,visualType=2)#
		</td>
	</tr>
	<tr>
		<td>
			Default-Sprache <div style="float:right;">#flexyLib.setHelpText(variable='settings_default_lang',type=1,visualType=1)#</div>
		</td>
		<td>
			<select name="defaultlang">
				<cfloop query="getLangs">
					<option value="#languageParam#">#language#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<cfloop query="getLangs">
	<tr>
		<td>Startseite #language#<div style="float:right;">#flexyLib.setHelpText(variable='settings_startpage',type=1,visualType=1)#</div></td>
		<td>
			<select name="startseite-#languageParam#">
				<cfquery name="getPages" datasource="#application.dsn#">
				SELECT	*
				FROM	pages
				WHERE	mandant = #session.mandant# AND
						lang = '#languageParam#'
				</cfquery>
				<cfloop query="getPages">
				
					<cfquery name="getLangStartpages" datasource="#application.dsn#">
					SELECT	*
					FROM	langstartpages2mandanten
					WHERE	mandant = #session.mandant# AND lang = '#lang#'
					</cfquery>
				
					<option value="#id#" <cfif getLangStartpages.recordcount GT 0 AND id EQ getLangStartpages.startpage>selected</cfif>>#navtitel#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<!--- <tr>
		<td>Standard Sprache</td>
		<td>
			<!--- <cfquery name="getLangs" datasource="#application.dsn#">
			SELECT	*
			FROM	mandantensprachen
			WHERE	mandant = #session.mandant#
			</cfquery>
			<select name="langs">
				<cfloop query="getLangs">
					<option value="#id#" <cfif id EQ getSettings.defaultlang>selected</cfif>>#language#</option>
				</cfloop>
			</select> --->
			
		</td>
	</tr> --->
	</cfloop>
	<tr>
		<td colspan="2">
			<input type="submit" value="Settings ändern" class="btn-action"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';" class="btn-noaction">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
