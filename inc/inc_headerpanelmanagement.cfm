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


<!--- alle Headerpanels auslesen datasource application --->
<cfquery name="getHeaderpanel" datasource="#application.dsn#">
SELECT	*
FROM	headerpanels
WHERE	mandant = #session.mandant#
</cfquery>


<!--- Headerpanel löschen --->
<!--- id des zu löschenden headerpanelss auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.delheaderpanels") AND isNumeric(url.delheaderpanels) AND url.delheaderpanels GT 0>
	<cfquery name="delheaderpanels" datasource="#application.dsn#">
	DELETE
	FROM	headerpanels
	WHERE	id = #url.delheaderpanels#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Headerpanel hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewHeaderpanel" AND isdefined("form.titel")>
		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img\headerpanel" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\img\headerpanel\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 960 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/flexslider ablegen --->
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\headerpanel\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\headerpanel\#cffile.serverfile#" overwrite="yes">
			</cfif>
		<cfelse>
			<cfset serverbildname = "">
		</cfif>
		
		<cfquery name="insertHeaderpanel" datasource="#application.dsn#">
		INSERT	
		INTO	headerpanels (isactive,createDate, titel,fliesstext, href,hrefLabel,image,mandant)
		VALUES(
			#form.active#,
			#createODBCdatetime(now())#,
			'#form.titel#',
			'#form.text#',
			'#form.hreflink#',
			'#form.linklabel#',
			'#serverbildname#',
			#session.mandant#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Headerpanel updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededitedHeaderpanel" AND isdefined("form.titel")>

		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img\headerpanel" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\img\headerpanel\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 960 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/flexslider ablegen --->
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\img\headerpanel\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\img\headerpanel\#cffile.serverfile#" overwrite="yes">
			</cfif>
		<cfelseif isdefined("delimage")>
			<cfset serverbildname = "">
		<cfelse>
			<cfset serverbildname = form.origbild>
		</cfif>
		
		<cfquery name="updateheaderpanels" datasource="#application.dsn#">
		UPDATE	headerpanels
		SET		isactive = #form.active#,
				modifydate = #createODBCdatetime(now())#,
				titel = '#form.titel#',
				fliesstext = '#form.text#',
				href= '#form.hreflink#',
				hreflabel = '#form.linklabel#',
				image = '#serverbildname#'
		WHERE	id = #form.headerpanelsid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	
</cfif>

<!--- zu bearbeitenden headerpanels aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editHeaderpanels") AND isNumeric(url.editHeaderpanels) AND url.editHeaderpanels GT 0>
	<cfquery name="editHeaderpanel" datasource="#application.dsn#">
	SELECT	*
	FROM	headerpanels
	WHERE	id = #url.editHeaderpanels#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->


<!--- Helptext variable flexyLib initialisieren  --->
<cfset flexyLib = createObject('component','admin.cfc.flexy') />



<!--- liste mit allen Headerpannels darstellen --->

<h2>Headerpanel Management</h2>

<h4>Jede Seite kann verschiedene Headerpanel-Elemente aufweisen. <br>
Die Reihenfolge der Bilder bestimmt man im Pagemanagement (Page bearbeiten)</h4>

<table width="100%">
<tr>
	<td colspan="4">
	<cfoutput>
			#flexyLib.setHelpText(variable='Headerpanel_Management_desc',type=2,visualType=2)#
	</cfoutput>
	</td>
</tr>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Headerpanel löschen ?</strong></td>
	<td><strong>Headerpanel bearbeiten ?</strong></td>
</tr>
<cfoutput query="getHeaderpanel">
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
<!---	.headerpanelsdel  / .headerpanelsedit sind funktionen mit der jeweiligen headerpanelsID die als url. parameter mitgegeben werden--->
	<td> 
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delheaderpanels=#id#" onclick="return confirm('Sind Sie sicher?');">
				headerpanel löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
		<a href="#cgi.SCRIPT_NAME#?editheaderpanels=#id#">
			headerpanel bearbeiten
		</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>
<!--- ADD Headerpannel --->
<!--- dies erscheint nur wenn headerpanels element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addHeaderpanel") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN !
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewHeaderpanel" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_status',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addHeaderpanel_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Headerpanel Titel <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_title',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="">
	</cfif>
	<!--- <tr>
		<td>Headerpanel Titel <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_title',type=1,visualType=1)#</div></td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>></td>
	</tr> --->
	<!--- Text --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addHeaderpanel_text' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Text <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_text',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#fliesstext#</cfif></textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'addHeaderpanel_text'
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
		<td>Text <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_text',type=1,visualType=1)#</div></td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#fliesstext#</cfif></textarea></td>
	</tr> --->
	<!--- Bild --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addHeaderpanel_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'addHeaderpanel_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px) <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_picture',type=1,visualType=1)#</div></td>
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
		<td>Bild <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_picture',type=1,visualType=1)#</div></td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr> --->
	<!--- Link --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addHeaderpanel_link' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Link (inkl: http://www.) <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_link',type=2,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#form.hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.linklabel")>#linklabel#</cfif>">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hreflink" value="">
		<input type="hidden" name="linklabel" value="">
	</cfif>
	<!--- <tr>
		<td>Link (inkl: http://www.) <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_link',type=2,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='add_headerpannel_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.hreflabel")>#hreflabel#</cfif>">
		</td>
	</tr> --->
	<tr>
		<td><div>#flexyLib.setHelpText(variable='add_headerpannel_submit',type=1,visualType=1)#</div></td>
		<td>
		
		<input type="submit" value="Headerpanel erfassen" class="btn-action"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editheaderpanels")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addHeaderpanel" id="addHeaderpanel" > + neues Headerpanel Element erfassen</a>
	</cfif>
</cfif>
</cfoutput>


<!--- HP EDIT  --->

<!--- dies erscheint nur wenn headerpanels bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editheaderpanels") AND isNumeric(url.editheaderpanels) AND url.editheaderpanels GT 0>
<cfoutput query="editHeaderpanel">
	<h3>Headerpanel <span class="particular">#titel#</span> bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedHeaderpanel" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_status',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editHeaderpanel_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Headerpanel Titel <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_title',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="titel" value="#titel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="#titel#">
	</cfif>
	<!--- <tr>
		<td>Headerpanel Titel <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_title',type=1,visualType=1)#</div></td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" value="#titel#"></td>
	</tr> --->
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editHeaderpanel_text' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Text  <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_text',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:100px;">#fliesstext#</textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'editHeaderpanel_text'
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
	<!--- <tr>
		<td>Text  <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_text',type=1,visualType=1)#</div></td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:100px;">#fliesstext#</textarea></td>
	</tr> --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editHeaderpanel_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'editHeaderpanel_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px) <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_picture',type=2,visualType=1)#</div></td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/img/headerpanel/#image#" target="_blank">#image#</a><br/>
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
		<td>Bild <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_picture',type=2,visualType=1)#</div></td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/img/headerpanel/#image#" target="_blank">#image#</a><br/>
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
	WHERE	fieldName = 'editHeaderpanel_link' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Link (inkl: http://) <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_link',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hreflink" value="#href#">
		<input type="hidden" name="linklabel" value="#hreflabel#">
	</cfif>
	<!--- <tr>
		<td>Link (inkl: http://) <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_link',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_link_label',type=1,visualType=1)#</div></td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr> --->
	<tr>
		<td> <div style="float:right;">#flexyLib.setHelpText(variable='edit_headerpannel_submit',type=1,visualType=1)#</div></td>
		<td>
			<!--- hidden id der headerpanels mitgeben für das WHERE statement im SQL EDITheaderpanels  --->
			<input type="hidden" name="headerpanelsid" value="#editHeaderpanel.id#" />
			<input type="submit" value="Headerpanel ändern" class="btn-action" > <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';" class="btn-noaction">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>