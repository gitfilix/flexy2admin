<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />

<style type="text/css">


#activ{
	color:#3F3;
	}

#inactiv{
	color:#0F9;
	}

table tr:nth-child(2n){
	background:#949494;
	}

.particular{
	color:#933 !important;
	}	
	
table tr:nth-child(2n+1){
	background:#B2B2B2;
	}

#addUser{
	background-color:#E5E5E5;
	letter-spacing:2px;
	list-style-type:none;
	}
	
#addUser:hover{
	-webkit-transition:all ease-in  300ms;
	-moz-transition:all ease-in  300ms;
	background-color:#FEFEFE;
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


<!--- alle Places auslesen datasource application --->
<cfquery name="get_allplaces" datasource="#application.dsn#">
SELECT	*
FROM	app_place
WHERE	mandant = #session.mandant#
</cfquery>


<!--- Places löschen --->
<!--- id des zu löschenden menue auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.delplace") AND isNumeric(url.delplace) AND url.delplace GT 0>
	<cfquery name="del_place" datasource="#application.dsn#">
	DELETE
	FROM	app_place
	WHERE	id = #url.delplace#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Place hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewPlace" AND isdefined("form.place_name")>
		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#expandpath('/' & session.serverpath & '/upload/img/app')#" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#expandpath('/' & session.serverpath & '/upload/img/app/' & cffile.serverfile)#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 960 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/flexslider ablegen --->
			<cfif bildbreite gt 600 >
				<cfimage action="resize" width="600" height="" source="#expandpath('/' & session.serverpath & '/upload/img/app/' & cffile.serverfile)#" destination="#expandpath('/' & session.serverpath & '/upload/img/app/' & cffile.serverfile)#" overwrite="yes">
			</cfif>
		<cfelse>
			<cfset serverbildname = "">
		</cfif>
		
		<cfquery name="insertPlace" datasource="#application.dsn#">
		INSERT	
		INTO	app_place (place_name,isActive,place_type,place_address,place_img,mandant)
		VALUES(
			'#form.place_name#',
			#form.active#,
			'#form.place_type#',
			'#form.place_address#',
			'#serverbildname#',
			#session.mandant#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Place updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededEditedPlace" AND isdefined("form.place_name")>

		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#expandpath('/' & session.serverpath & '/upload/img/app')#" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#expandpath('/' & session.serverpath & '/upload/img/app/' & cffile.serverfile)#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 601 -> bild auf 600 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/dish ablegen --->
			<cfif bildbreite gt 600 >
				<cfimage action="resize" width="600" height="" source="#expandpath('/' & session.serverpath & '/upload/img/app/' & cffile.serverfile)#" destination="#expandpath('/' & session.serverpath & '/upload/img/app/' & cffile.serverfile)#" overwrite="yes">
			</cfif>
		<cfelseif isdefined("delimage")>
			<cfset serverbildname = "">
		<cfelse>
			<cfset serverbildname = form.origbild>
		</cfif>
		
		<cfquery name="updatePlaces" datasource="#application.dsn#">
		UPDATE	app_place
		SET		place_name = '#form.place_name#',
				isActive = #form.active#,
				place_type = '#form.place_type#',
				place_address = '#form.place_address#',
				place_img = '#serverbildname#',
				Mandant = #session.mandant#  
		WHERE	id = #form.app_placeid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	
</cfif>

<!--- zu bearbeitender Place aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editPlace") AND isNumeric(url.editPlace) AND url.editPlace GT 0>
	<cfquery name="editPlace" datasource="#application.dsn#">
	SELECT	*
	FROM	app_place
	WHERE	id = #url.editPlace#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->


<!--- Helptext variable flexyLib initialisieren  --->
<!--- <cfset flexyLib = createObject('component','admin.cfc.flexy') />

 --->

<!--- liste mit allen Places darstellen --->

<h2>App Place Management</h2>

<h4>Erfassen Sie hier die Locations</h4><br>


<table width="100%">
<tr>
	<td colspan="4">
	<!--- <cfoutput>
			#flexyLib.setHelpText(variable='Headerpanel_Management_desc',type=2,visualType=2)#
	</cfoutput> --->
	</td>
</tr>
<tr>
	<td><strong>Place</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Place löschen</strong></td>
	<td><strong>Place bearbeiten ?</strong></td>
</tr>
<cfoutput query="get_allplaces">
<tr>
	<td>#place_name#</td>
	<td>
	<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
		<cfif isActive EQ 1>
		<div id="activ">aktiv</div>
		<cfelse>
		<div id="inactiv">inaktiv </div>
		</cfif>
	</td>
<!---	.headerpanelsdel  / .headerpanelsedit sind funktionen mit der jeweiligen headerpanelsID die als url. parameter mitgegeben werden--->
	<td> 
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delplace=#id#" onclick="return confirm('Sind Sie sicher?');">
				Place löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
		<a href="#cgi.SCRIPT_NAME#?editplace=#id#">
			Place bearbeiten
		</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>
<!--- ADD new Place --->
<!--- dies erscheint nur wenn Place element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addPlace") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN !
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewPlace" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status:</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td>Place Name</td>
	<!---	wen der Place schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="place_name" <cfif isdefined("form.place_name")>value="#form.place_name#"</cfif>></td>
	</tr>
	<tr>
		<td>Beschreibung:</td>
	<!---	wen der Place schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><textarea name="place_type"  class="ckeditor" id="place_type" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.place_type")>#place_type#</cfif></textarea></td>
	</tr>
	<tr>
		<td>Adresse (Strasse, Nummer, Ort) </td>
		<!---wenn schon ein text existiertm dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><input type="text" name="place_address"  id="place_address"  style="width:100%;height:120px;"><cfif isdefined("form.place_address")>#place_address#</cfif></td>
	</tr>
	<tr>
		<td>Koordinate Längengrad: (nur Ausgabe) </td>
	<!---	wen die koordinate schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.koordinaten --->
		<td><input type="text" name="coord_long" <cfif isdefined("form.coord_long")>value="#form.coord_long#"</cfif>></td>
	</tr>
	<tr>
		<td>Koordinate Breitengrad:  (nur Ausgabe)</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="coord_lat" <cfif isdefined("form.coord_lat")>value="#form.coord_lat#"</cfif>></td>
	</tr>
	<tr>
		<td>Bild:</td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
		
		<input type="submit" value="Place erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editPlace")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addPlace" id="addPlace" >+ neuer Place erfassen +</a>
	</cfif>
</cfif>
</cfoutput>


<!--- Place EDIT  --->

<!--- dies erscheint nur wenn Place bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editplace") AND isNumeric(url.editplace) AND url.editplace GT 0>
<cfoutput query="editPlace">
	<h3>Place <span class="particular">#place_name#</span> bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededEditedPlace" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>Place Name</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="place_name" value="#place_name#"></td>
	</tr>
	<tr>
		<td>Place Beschreibung</td>
	<!---	wen der Place  schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.place --->
		<td><textarea name="place_type"  class="ckeditor" id="place_type" cols="1" rows="1" style="width:100%;height:100px;">#place_type#</textarea></td>
	</tr>
	<tr>
		<td>Adresse:</td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><input type="text" name="place_address" id="place_address" value="#place_address#"></td>
	</tr>
	<tr>
		<td>Bild:</td>
		<td>
			<cfif place_img NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#/upload/img/app/#place_image#" target="_blank">#place_image#</a><br/>
			<input type="checkbox" name="delimage" value="#place_image#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#place_image#" />
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<!--- hidden id der place ID mitgeben für das WHERE statement im SQL EDITPlace --->
			<input type="hidden" name="app_placeid" value="#id#" />
			<input type="submit" value="Place ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>