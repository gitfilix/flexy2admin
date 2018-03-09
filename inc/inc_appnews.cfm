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


<!--- alle App_news auslesen datasource application --->
<cfquery name="get_allnews" datasource="#application.dsn#">
SELECT	*
FROM	app_news
WHERE	mandant = #session.mandant#
</cfquery>

<!--- alle App_news auslesen datasource application --->
<cfquery name="get_allplaces" datasource="#application.dsn#">
SELECT	*
FROM	app_place
WHERE	place_mandant = #session.mandant#
</cfquery>



<!--- News löschen --->
<!--- id des zu löschenden restaurant auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.delnews") AND isNumeric(url.delnews) AND url.delnews GT 0>
	<cfquery name="del_news" datasource="#application.dsn#">
	DELETE
	FROM	app_news
	WHERE	id = #url.delnews#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- New News hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewNews" AND isdefined("form.news_title")>
		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#expandpath('/' & session.serverpath & '/upload/img/app/news')#" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#expandpath('/' & session.serverpath & '/upload/img/app/news/' & cffile.serverfile)#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 960 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/flexslider ablegen --->
			<cfif bildbreite gt 600 >
				<cfimage action="resize" width="600" height="" source="#expandpath('/' & session.serverpath & '/upload/img/app/news/' & cffile.serverfile)#" destination="#expandpath('/' & session.serverpath & '/upload/img/app/news/' & cffile.serverfile)#" overwrite="yes">
			</cfif>
		<cfelse>
			<cfset serverbildname = "">
		</cfif>
		
		<cfquery name="insertNews" datasource="#application.dsn#">
		INSERT	
		INTO	app_news (isActive,news_title,news_lead,news_text,news_img,mandant, place_id)
		VALUES(
			#form.active#,
			'#form.news_title#',
			'#form.news_lead#',
			'#form.news_text#',
			'#serverbildname#',
			#session.mandant#,
			#form.place#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Dish updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededEditedNews" AND isdefined("form.news_title")>

		<cfset actionSuceeded = true />
		
		<!--- bild upload --->
		<!--- wenn ein bild ausgewählt wurde --->
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#expandpath('/' & session.serverpath & '/upload/img/app/news')#" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#expandpath('/' & session.serverpath & '/upload/img/app/news/' & cffile.serverfile)#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 601 -> bild auf 600 resizen und überschreiben --->
			<!--- 	im jeweiligen mandanten im upload/dish ablegen --->
			<cfif bildbreite gt 600 >
				<cfimage action="resize" width="600" height="" source="#expandpath('/' & session.serverpath & '/upload/img/app/news/' & cffile.serverfile)#" destination="#expandpath('/' & session.serverpath & '/upload/img/app/news/' & cffile.serverfile)#" overwrite="yes">
			</cfif>
		<cfelseif isdefined("delimage")>
			<cfset serverbildname = "">
		<cfelse>
			<cfset serverbildname = form.origbild>
		</cfif>
		
		<cfquery name="updateNews" datasource="#application.dsn#">
		UPDATE	app_news
		SET		isActive = #form.active#,
				news_title = '#form.news_title#',
				news_lead = '#form.news_lead#',
				news_img = '#serverbildname#',
				Mandant =  #session.mandant#, 
				place_id = #form.place#
		WHERE	id = #form.app_newsid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	
</cfif>

<!--- zu bearbeitendes Geriicht aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editNews") AND isNumeric(url.editNews) AND url.editNews GT 0>
	<cfquery name="editNews" datasource="#application.dsn#">
	SELECT	*
	FROM	app_news
	WHERE	id = #url.editNews#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->


<!--- Helptext variable flexyLib initialisieren  --->
<!--- <cfset flexyLib = createObject('component','admin.cfc.flexy') />

 --->

<!--- liste mit allen Headerpannels darstellen --->

<h2>App News Management</h2>

<h4>News und Aktionen für Ihre Beiz</h4><br>


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
	<td><strong>News löschen</strong></td>
	<td><strong>News bearbeiten</strong></td>
</tr>
<cfoutput query="get_allnews">
<tr>
	<td>#news_title#</td>
	<td>
	<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
		<cfif isactive EQ 1>
		<div id="activ">	aktiv</div>
		<cfelse>
		<div id="inactiv">	inaktiv </div>
		</cfif>
	</td>
<!---	vor dem Löschen nochmals return confirm alerten--->
	<td> 
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delnews=#id#" onclick="return confirm('Sind Sie sicher?');">
				News löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
		<a href="#cgi.SCRIPT_NAME#?editnews=#id#">
			News bearbeiten
		</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>
<!--- ADD new news --->
<!--- dies erscheint nur wenn News element erfassen gewählt wurde --->



<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addNews") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN !
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewNews" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status:</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td>News Title</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="news_title" <cfif isdefined("form.news_title")>value="#form.news_title#"</cfif>></td>
	</tr>
	<tr>
		<td>Einleitung</td>
	<!---	wenn der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="news_lead" <cfif isdefined("form.news_lead")>value="#form.news_lead#"</cfif>></td>
	</tr>
	<tr>
		<td>News </td>
		<!---wenn schon ein text existiertm dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="news_text"  class="ckeditor" id="news_text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.news_text")>#news_text#</cfif></textarea></td>
	</tr>
	<tr>
		<td>
			Place:
		</td>
		<td>
			<select name="place">
				<cfloop query="get_allplaces">
					<option value="#id#">#place_name#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td>Bild</td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
		
		<input type="submit" value="News erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editNews")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addNews" id="addNews" >+ News erfassen +</a>
	</cfif>
</cfif>
</cfoutput>


<!--- News EDIT  --->

<!--- dies erscheint nur wenn News  bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editnews") AND isNumeric(url.editnews) AND url.editnews GT 0>
<cfoutput query="editNews">
	<h3>Gericht <span class="particular">#news_title#</span> bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededEditedNews" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>News Title</td>
	<!---	wen der News schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.title --->
		<td><input type="text" name="news_title" value="#news_title#"></td>
	</tr>
	<tr>
		<td>News Lead / Einleitung</td>
	<!---	wen der news_lead schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="news_lead" value="#news_lead#"></td>
	</tr>
	<tr>
		<td>News Text</td>
		<!---wenn schon ein text exisite dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="news_text"  class="ckeditor" id="news_text" cols="1" rows="1" style="width:100%;height:120px;">#news_text#</textarea></td>
	</tr>
	<tr>
		<td>
			Place:
		</td>
		<td>
			<select name="place">
				<cfloop query="get_allplaces">
					<option value="#id#" <cfif id EQ editnews.place_id >selected</cfif>> #place_name#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td>Bild</td>
		<td>
			<cfif news_img NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#//upload/img/app/news/#news_img#" target="_blank">#news_img#</a><br/>
			<input type="checkbox" name="delimage" value="#news_img#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#news_img#" />
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<!--- hidden id der News mitgeben für das WHERE statement im SQL EDITheaderpanels  --->
			<input type="hidden" name="app_newsid" value="#editnews.id#" />
			<input type="submit" value="News ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>