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


<!--- alle Headerpanels auslesen datasource application --->
<cfquery name="get_alldishes" datasource="#application.dsn#">
SELECT	*
FROM	app_dish
WHERE	mandant = #session.mandant#
</cfquery>


<!--- Headerpanel löschen --->
<!--- id des zu löschenden menue auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.deldishes") AND isNumeric(url.deldishes) AND url.deldishes GT 0>
	<cfquery name="del_alldishes" datasource="#application.dsn#">
	DELETE
	FROM	app_dish
	WHERE	id = #url.deldish#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Gericht hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewDish" AND isdefined("form.titel")>
		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#expandpath('/' & session.serverpath & '/upload/img/dish')#" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#expandpath('/' & session.serverpath & '/upload/img/dish/' & cffile.serverfile)#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 960 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/flexslider ablegen --->
			<cfif bildbreite gt 601 >
				<cfimage action="resize" width="600" height="" source="#expandpath('/' & session.serverpath & '/upload/img/dish/' & cffile.serverfile)#" destination="#expandpath('/' & session.serverpath & '/upload/img/dish/' & cffile.serverfile)#" overwrite="yes">
			</cfif>
		<cfelse>
			<cfset serverbildname = "">
		</cfif>
		
		<cfquery name="insertDish" datasource="#application.dsn#">
		INSERT	
		INTO	app_dish (rest_Name,isActive,dish_kind,dish_name,dish_image,dish_image_path,dish_desc,mandant)
		VALUES(
			#form.active#,
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

<!--- Dish updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededitedDish" AND isdefined("form.titel")>

		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#expandpath('/' & session.serverpath & '/upload/img/dish')#" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#expandpath('/' & session.serverpath & '/upload/img/dish/' & cffile.serverfile)#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 601 -> bild auf 600 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/dish ablegen --->
			<cfif bildbreite gt 601 >
				<cfimage action="resize" width="600" height="" source="#expandpath('/' & session.serverpath & '/upload/img/dish/' & cffile.serverfile)#" destination="#expandpath('/' & session.serverpath & '/upload/img/dish/' & cffile.serverfile)#" overwrite="yes">
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

<!--- zu bearbeitendes Geriicht aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editDish") AND isNumeric(url.editHeaderpanels) AND url.editHeaderpanels GT 0>
	<cfquery name="editDish" datasource="#application.dsn#">
	SELECT	*
	FROM	app_dish
	WHERE	id = #url.editDish#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->


<!--- Helptext variable flexyLib initialisieren  --->
<!--- <cfset flexyLib = createObject('component','admin.cfc.flexy') />

 --->

<!--- liste mit allen Headerpannels darstellen --->

<h2>App Menue Management</h2>

<h4>Aktuelle Menue's</h4><br>


<table width="100%">
<tr>
	<td colspan="4">
	<!--- <cfoutput>
			#flexyLib.setHelpText(variable='Headerpanel_Management_desc',type=2,visualType=2)#
	</cfoutput> --->
	</td>
</tr>
<tr>
	<td><strong>Restaurant</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Menue löschen</strong></td>
	<td><strong>Menue bearbeiten ?</strong></td>
</tr>
<cfoutput query="getHeaderpanel">
<tr>
	<td>#rest_name#</td>
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
			<a href="#cgi.SCRIPT_NAME#?deldishes=#id#" onclick="return confirm('Sind Sie sicher?');">
				Gericht löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
		<a href="#cgi.SCRIPT_NAME#?editdish=#id#">
			Gericht bearbeiten
		</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>
<!--- ADD Dis --->
<!--- dies erscheint nur wenn Dish element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addDish") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN !
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewDish" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status:</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td>Gericht Titel</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="dish_name" <cfif isdefined("form.titel")>value="#form.dish-name#"</cfif>></td>
	</tr>
	<tr>
		<td>Beschreibung des Gerichts </td>
		<!---wenn schon ein text existiertm dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="dish_desc" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.dish_desc")>#dish_desc#</cfif></textarea></td>
	</tr>
	<tr>
		<td>Bild</td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr>
	<tr>
		<td>Gericht-Art</td>
		<td><input type="text" name="dish-art" <cfif isdefined("form.dish-art")>value="#form.dish-art#"</cfif>></td>
	</tr>
	<tr>
		<td></td>
		<td>
		
		<input type="submit" value="Gericht erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editDish")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addDish" id="addDish" >+ neues Gericht erfassen +</a>
	</cfif>
</cfif>
</cfoutput>


<!--- HP EDIT  --->

<!--- dies erscheint nur wenn headerpanels bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editdish") AND isNumeric(url.editdish) AND url.editdish GT 0>
<cfoutput query="editDish">
	<h3>Gericht <span class="particular">#dish_name#</span> bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedDish" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>Gericht Titel </td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="dish_name" value="#form.dish-name#"></td>
	</tr>
	<tr>
		<td>Gericht Name</td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="dish_desc"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:100px;">#fliesstext#</textarea></td>
	</tr>
	<tr>
		<td>Bild</td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#/upload/dish/#image#" target="_blank">#image#</a><br/>
			<input type="checkbox" name="delimage" value="#image#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#image#" />
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<!--- hidden id der headerpanels mitgeben für das WHERE statement im SQL EDITheaderpanels  --->
			<input type="hidden" name="app_dishid" value="#id#" />
			<input type="submit" value="Gericht ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>