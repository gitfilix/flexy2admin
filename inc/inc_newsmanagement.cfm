<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />

<style type="text/css">
/*
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
	*/
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


<!--- alle Newss auslesen datasource application --->
<cfquery name="getNews" datasource="#application.dsn#">
SELECT	*
FROM	news
WHERE	mandant = #session.mandant#
</cfquery>


<!--- News löschen --->
<!--- id des zu löschenden newss auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.delnews") AND isNumeric(url.delnews) AND url.delnews GT 0>
	<cfquery name="delnews" datasource="#application.dsn#">
	DELETE
	FROM	news
	WHERE	id = #url.delnews#
	</cfquery>
	<!--- weitere tabellen zum bereinigen --->
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- News hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewNews" AND isdefined("form.titel")>
		<cfset actionSuceeded = true />
		
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination='#remoteServerPath##session.serverpath#\upload\news\' nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\news\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
		
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\news\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\news\#serverbildname#" overwrite="yes">
				<!--- This example shows how to crop an image. --->
				<!--- Create a ColdFusion image from an existing JPEG file. --->
				<cfimage source="#remoteServerPath##session.serverpath#\upload\news\#serverbildname#" name="myImage">
				<!--- Crop myImage to 100x100 pixels starting at the coordinates (10,10).--->
				<!--- <cfset ImageCrop(myImage,0,0,960,200)>
				<!--- Write the result to a file. --->
				<cfimage source="#myImage#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes"> --->
			</cfif>
		<cfelse>
			<cfset serverbildname = ""> 
		</cfif>
		
		
		
		<cfquery name="insertNews" datasource="#application.dsn#">
		INSERT	
		INTO	news (isactive,createDate, datum, titel,fliesstext, href,hrefLabel,mandant,image)
		VALUES(
			#form.active#,
			#createODBCdatetime(now())#,
			#createODBCdatetime(now())#,
			'#form.titel#',
			'#form.text#',
			'#form.hreflink#',
			'#form.linklabel#',
			#session.mandant#,
			'#serverbildname#'
		)
		</cfquery>
		
		
		
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- News updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededitedNews" AND isdefined("form.titel")>
		<cfset actionSuceeded = true />
		
		<cfif form.bild NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\news\" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\news\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
			<cfif bildbreite gt form.resizebild >
				<cfimage action="resize" width="#form.resizebild#" height="" source="#remoteServerPath##session.serverpath#\upload\news\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\news\#serverbildname#" overwrite="yes">
				<!--- This example shows how to crop an image. --->
				<!--- Create a ColdFusion image from an existing JPEG file. --->
				<cfimage source="#remoteServerPath##session.serverpath#\upload\news\#serverbildname#" name="myImage2">
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
		
		<cfquery name="updatenews" datasource="#application.dsn#">
		UPDATE	news
		SET		isactive = #form.active#,
				modifydate = #createODBCdatetime(now())#,
				datum = #createODBCdatetime(now())#,
				titel = '#form.titel#',
				fliesstext = '#form.text#',
				href= '#form.hreflink#',
				hreflabel = '#form.linklabel#',
				mandant = #session.mandant#,
				image = '#serverbildname#'
		WHERE	id = #form.newsid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	
</cfif>

<!--- zu bearbeitenden news aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editNews") AND isNumeric(url.editNews) AND url.editNews GT 0>
	<cfquery name="editNews" datasource="#application.dsn#">
	SELECT	*
	FROM	news
	WHERE	id = #url.editNews#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Users darstellen --->

<h2>News Management</h2>

<table width="100%">
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>News löschen ?</strong></td>
	<td><strong>News bearbeiten ?</strong></td>
</tr>
<cfoutput query="getNews">
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
<!---	.newsdel  / .newsedit sind funktionen mit der jeweiligen newsID die als url. parameter mitgegeben werden--->
	<td>
		<cfif rightDel EQ 1>
		<a href="#cgi.SCRIPT_NAME#?delnews=#id#" onclick="return confirm('Sind Sie sicher?');">
			news löschen
		</a>
		</cfif>
	</td>
	<td>
		<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?editnews=#id#">
				news bearbeiten
			</a>
		</cfif>
	</td>
</tr>
</cfoutput>
</table>
<br/>

<!--- dies erscheint nur wenn news element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addNews") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewNews" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addNews_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>News Titel</td>
		<td>
			<input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="">
	</cfif>
	<!--- <tr>
		<td>News Titel</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>></td>
	</tr> --->
	<!--- Text --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addNews_text' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Text</td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#form.fliesstext#</cfif></textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'addNews_text'
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
		<td>Text</td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#fliesstext#</cfif></textarea></td>
	</tr> --->
	<!--- Bild --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addNews_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'addNews_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px)</td>
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
		<td>Bild</td>
		<td>
			<input type="file" name="bild">
		</td>
	</tr> --->
	<!--- Link --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addNews_link' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Link (inkl: http://www.)</td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#form.hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label</td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.linklabel")>#form.linklabel#</cfif>">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hreflink" value="">
		<input type="hidden" name="linklabel" value="">
	</cfif>
	<!--- <tr>
		<td>Link (inkl- http://)</td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label</td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.hreflabel")>#hreflabel#</cfif>">
		</td>
	</tr> --->
	<tr>
		<td></td>

		<td>
		
		<input type="submit" value="News erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editnews")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addNews" id="addNews" > + neuer News-Beitrag erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn news bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editnews") AND isNumeric(url.editnews) AND url.editnews GT 0>
<cfoutput query="editNews">
	<h3>News #titel# bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedNews" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<!--- Titel --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editNews_titel' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>News Titel</td>
		<td>
			<input type="text" name="titel" value="#titel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="titel" value="">
	</cfif>
	<!--- <tr>
		<td>News Titel</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" value="#titel#"></td>
	</tr> --->
	<!--- Text --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editNews_text' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Text</td>
		<td>
			<textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:100px;">#fliesstext#</textarea>
			<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
			SELECT 	*
			FROM	feldtoolbaritems
			WHERE	mandant = #session.mandant# AND feldname = 'editNews_text'
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
		<td>Text</td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:100px;">#fliesstext#</textarea></td>
	</tr> --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editNews_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'editNews_bild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Bild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px)</td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#/upload/news/#image#" target="_blank">#image#</a><br/>
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
		<td>Bild</td>
		<td>
			<cfif image NEQ "">
			Momentanes Bild auf dem Server: <a href="/#session.serverpath#/upload/news/#image#" target="_blank">#image#</a><br/>
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
	WHERE	fieldName = 'editNews_link' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Link (inkl: http://www.)</td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label</td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="hreflink" value="">
		<input type="hidden" name="linklabel" value="">
	</cfif>
	<!--- <tr>
		<td>Link (inkl- http://)</td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label</td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr> --->
	<tr>
		<td></td>
		<td>
			<!--- hidden id der news mitgeben für das WHERE statement im SQL EDITnews  --->
			<input type="hidden" name="newsid" value="#id#" />
			<input type="submit" value="News ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>