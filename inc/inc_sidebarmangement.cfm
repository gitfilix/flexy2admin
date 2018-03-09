<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />



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


<!--- alle Sidebars auslesen datasource application --->
<cfquery name="getSidebar" datasource="#application.dsn#">
SELECT	*
FROM	sidebar
WHERE	mandant = #session.mandant#
ORDER	BY teaserposition
</cfquery>


<!--- Sidebar löschen --->
<!--- id des zu löschenden sidebars auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.delsidebar") AND isNumeric(url.delsidebar) AND url.delsidebar GT 0>
	<cfquery name="delsidebar" datasource="#application.dsn#">
	DELETE
	FROM	sidebar
	WHERE	id = #url.delsidebar#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Sidebar hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewSidebar" AND isdefined("form.titel")>
		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img" nameconflict="makeunique"> 
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
		
		<cfquery name="insertSidebar" datasource="#application.dsn#">
		INSERT	
		INTO	Sidebar (isactive,createDate, titel,fliesstext, href,hrefLabel,image,teaserposition,mandant)
		VALUES(
			#form.active#,
			#createODBCdatetime(now())#,
			'#form.titel#',
			'#form.text#',
			'#form.hreflink#',
			'#form.linklabel#',
			'#serverbildname#',
			#form.pos#,
			#session.mandant#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Sidebar updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedsidebar" AND isdefined("form.titel")>

		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 220 -> bild auf 220 resizen und überschreiben --->
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" overwrite="yes">
			</cfif>
		<cfelseif isdefined("delimage")>
			<cfset serverbildname = "">
		<cfelse>
			<cfset serverbildname = form.origbild>
		</cfif>
		
		<cfquery name="updatesidebar" datasource="#application.dsn#">
		UPDATE	sidebar
		SET		isactive = #form.active#,
				modifydate = #createODBCdatetime(now())#,
				titel = '#form.titel#',
				fliesstext = '#form.text#',
				href= '#form.hreflink#',
				hreflabel = '#form.linklabel#',
				parentuser = '#session.serverpath#',
				image = '#serverbildname#',
				teaserposition = #form.pos#,
				mandant = #session.mandant#
		WHERE	id = #form.sidebarid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	
</cfif>

<!--- zu bearbeitenden sidebar aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editSidebar") AND isNumeric(url.editSidebar) AND url.editSidebar GT 0>
	<cfquery name="editSidebar" datasource="#application.dsn#">
	SELECT	*
	FROM	sidebar
	WHERE	id = #url.editSidebar#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->

<!--- Helptext variable flexyLib initialisieren  --->
<cfset flexyLib = createObject('component','admin.cfc.flexy') />


<!--- liste mit allen Teasers darstellen --->

<h2>Teaser Management</h2>

<h4>Jede Seite kann verschiedene Elemente aufweisen (rechts oder unten)</h4>

<table width="100%">
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Position</strong></td>
	<td><strong>Teaser löschen ?</strong></td>
	<td><strong>Teaser bearbeiten ?</strong></td>
</tr>
<cfoutput query="getSidebar">
<tr>
	<td>#titel#</td>
	<td>
	<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
		<cfif isactive EQ 1>
		<div id="activ">	aktiv</div>
		<cfelse>
		<div id="inactiv">	inaktiv </div>
		</cfif>
	</td>
	<td>
		<cfif teaserposition EQ 1>
			Sidebar rechts
		<cfelse>
			im Footer
		</cfif>
	</td>
<!---	.sidebardel  / .sidebaredit sind funktionen mit der jeweiligen sidebarID die als url. parameter mitgegeben werden--->
	<td>
		<cfif rightDel EQ 1>
		<a href="#cgi.SCRIPT_NAME#?delsidebar=#id#" onclick="return confirm('Sind Sie sicher?');">
			teaser löschen
		</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
		<a href="#cgi.SCRIPT_NAME#?editsidebar=#id#">
			teaser bearbeiten
		</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>

<!--- dies erscheint nur wenn sidebar element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addSidebar") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewSidebar" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_status',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<!--- TYPE --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addSidebar_pos' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Type <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_type',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="pos" value="1" <cfif (isdefined("form.pos") AND form.pos EQ 1) OR not isdefined("form.pos")>checked="checked"</cfif>> Sidebar  &nbsp; &nbsp;
			<input type="radio" name="pos" value="2" <cfif (isdefined("form.pos") AND form.pos EQ 2)>checked="checked"</cfif>> Bottom
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="pos" value="0">
	</cfif>
	<!--- <tr>
		<td>Type <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_type',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="pos" value="1" checked="checked"> Sidebar  &nbsp; &nbsp;
			<input type="radio" name="pos" value="2"> Bottom
		</td>
	</tr> --->
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addSidebar_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Teaser Titel <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_title',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="">
	</cfif>
	<!--- <tr>
		<td>Teaser Titel <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_title',type=1,visualType=1)#</div></td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>></td>
	</tr> --->
	<!--- Text --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addSidebar_text' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Text <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_text',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#form.fliesstext#</cfif></textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'addSidebar_text'
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
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="text" value="">
	</cfif>
	<!--- <tr>
		<td>Text <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_text',type=1,visualType=1)#</div></td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#fliesstext#</cfif></textarea></td>
	</tr> --->
	<!--- Bild --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addSidebar_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'addSidebar_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px) <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_picture',type=1,visualType=1)#</div></td>
		<td>
			<input type="file" name="bild">
			<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="bild" value="">
		<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
	</cfif>
	<!--- <tr>
		<td>Bild <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_picture',type=1,visualType=1)#</div></td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr> --->
	<!--- Link --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addSidebar_link' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Link (inkl- http://) <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_link',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#form.hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.linklabel")>#form.linklabel#</cfif>">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hreflink" value="">
		<input type="hidden" name="linklabel" value="">
	</cfif>
	<!--- <tr>
		<td>Link (inkl- http://) <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_link',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.hreflabel")>#hreflabel#</cfif>">
		</td>
	</tr> --->
	<tr>
		<td><div style="float:right;">#flexyLib.setHelpText(variable='add_teaser_submit',type=1,visualType=1)#</div></td>
		<td>
		
		<input type="submit" value="Teaser speichern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editsidebar") AND rightAdd EQ 1>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addSidebar" id="addSidebar" > + neues Teaser Element erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn sidebar bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editsidebar") AND isNumeric(url.editsidebar) AND url.editsidebar GT 0>
<cfoutput query="editSidebar">
	<h3>Teaser #titel# bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedSidebar" method="post" enctype="multipart/form-data">
	<table>
	<td colspan="2">
			#flexyLib.setHelpText(variable='Teaser_Management_desc',type=2,visualType=2)#
		</td>
	<tr>
		<td>Status <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_status',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<!--- TYPE --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editSidebar_pos' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Type <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_type',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="pos" value="1 "<cfif teaserposition EQ 1>checked="checked"</cfif>> Sidebar  &nbsp; &nbsp;
			<input type="radio" name="pos" value="2" <cfif teaserposition EQ 2>checked="checked"</cfif>> Bottom
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="pos" value="#teaserposition#">
	</cfif>
	<!--- <tr>
		<td>Seite / Unten:<div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_type',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="pos" value="1" <cfif teaserposition EQ 1>checked="checked"</cfif>> Sidebar  &nbsp; &nbsp;
			<input type="radio" name="pos" value="2" <cfif teaserposition EQ 2>checked="checked"</cfif>> Bottom
		</td>
	</tr> --->
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editSidebar_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Teaser Titel <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_title',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="titel" value="#titel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="#titel#">
	</cfif>
	<!--- <tr>
		<td>Teaser Titel <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_title',type=1,visualType=1)#</div></td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" value="#titel#"></td>
	</tr> --->
	<!--- Text --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editSidebar_text' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Text <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_text',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;">#fliesstext#</textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'editSidebar_text'
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
		</td>
	</tr>
	<cfelse>
		<textarea style="position:absolute;left:-99999px;width:0px;height:0px;" name="text">#fliesstext#</textarea>
	</cfif>
	<!--- <!--- <tr>
		<td>Text <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_text',type=1,visualType=1)#</div></td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;">#fliesstext#</textarea></td>
	</tr> ---> --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editSidebar_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'editSidebar_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px) <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_picture',type=1,visualType=1)#</div></td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#/upload/img/#image#" target="_blank">#image#</a><br/>
			<input type="checkbox" name="delimage" value="#image#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#image#" />
			<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="bild" value="">
		<input type="hidden" name="origbild" value="#image#" />
		<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
	</cfif>
	<!--- <tr>
		<td>Bild <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_picture',type=1,visualType=1)#</div></td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#/upload/img/#image#" target="_blank">#image#</a><br/>
			<input type="checkbox" name="delimage" value="#image#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#image#" />
		</td>
	</tr> --->
	<!--- Link --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editSidebar_link' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Link (inkl. http://www.) <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_link',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hreflink" value="#href#">
		<input type="hidden" name="linklabel" value="#hreflabel#">
	</cfif>
	<!--- <tr>
		<td>Link (inkl. http://www.) <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_link',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr> --->
	<tr>
		<td>
			<div style="float:right;">#flexyLib.setHelpText(variable='edit_teaser_submit',type=1,visualType=1)#</div>
		</td>
		<td>
		
			<!--- hidden id der sidebar mitgeben für das WHERE statement im SQL EDITSIDEBAR  --->
			<input type="hidden" name="sidebarid" value="#id#" />
			<input type="submit" value="Teaser ändern" class="btn-action"> <input type="button" value="abbrechen" class="btn-noaction"onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>