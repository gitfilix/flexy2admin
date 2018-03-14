<cfprocessingdirective pageencoding="utf-8" />




<!--- gleiches stylesheet wie pabgemanagement  --->



<!--- 
<cfdump var="#session.rechte.module#"> --->
<style>
 
/* colors für status*/

select{
	width:99%;
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


<!--- alle albums auslesen --->
<cfquery name="getAlbums" datasource="#application.dsn#">
SELECT	*
FROM	albums
WHERE	mandant = #session.mandant#
</cfquery>

<!--- album löschen --->
<cfif isdefined("url.delAlbum") AND isNumeric(url.delAlbum) AND url.delAlbum GT 0>
	<cfquery name="delAlbum" datasource="#application.dsn#">
	DELETE
	FROM	albums
	WHERE	id = #url.delAlbum#
	</cfquery>
	<!--- alle bilder des zu löschenen albums auslesen --->
	<cfquery name="getImages" datasource="#application.dsn#">
	SELECT 	*
	FROM	albumimages
	WHERE	albumID = #url.delAlbum#
	</cfquery>
	<!--- durch alle bilder loopen und physikalisch vom server löschen --->
	<cfoutput query="getImages">
		<cfif fileExists("#remoteServerPath##session.serverpath#\upload\galleries\#imagePath#")>
			<cffile action="delete" file="#remoteServerPath##session.serverpath#\upload\galleries\#imagePath#" />
		</cfif>
		<cfif fileExists("#remoteServerPath##session.serverpath#\upload\galleries\#imageThumbPath#")>
			<cffile action="delete" file="#remoteServerPath##session.serverpath#\upload\galleries\#imageThumbPath#" />
		</cfif>
	</cfoutput>
	<!--- alle bilder des albums ebenfalls aus DB löschen --->
	<cfquery name="deleteImages" datasource="#application.dsn#">
	DELETE
	FROM	albumimages
	WHERE	albumID = #url.delAlbum#
	</cfquery>
	<!--- contents mit assoziertem album bereinigen --->
	<cfquery name="resetGalleryAlbumsAssociatedToContenrs" datasource="#application.dsn#">
	UPDATE	content
	SET		albumid = NULL
	WHERE	albumid = #url.delAlbum#
	</cfquery>
	
	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- I STRUKTUR   1. Neue album hinzufügen --->
<!--- ------------------------------------ --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewAlbum">
		
		<cfif form.albumImage NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="albumImage" destination='#remoteServerPath##session.serverpath#\upload\galleries\' nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
		
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
			<cfif bildbreite gt 960 >
				<cfimage action="resize" width="960" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" overwrite="yes">
				<!--- This example shows how to crop an image. --->
				<!--- Create a ColdFusion image from an existing JPEG file. --->
				<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" name="myImage">
				<!--- Crop myImage to 100x100 pixels starting at the coordinates (10,10).--->
				<!--- <cfset ImageCrop(myImage,0,0,960,200)>
				<!--- Write the result to a file. --->
				<cfimage source="#myImage#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" overwrite="yes"> --->
			</cfif>
		<cfelse>
			<cfset serverbildname = ""> 
		</cfif>
		<cfquery name="insertAlbum" datasource="#application.dsn#">
		INSERT	
		INTO	albums (
				albumTitle,
				albumDescription,
				createDate,
				creator,
				albumImage,
				mandant  
		)
		VALUES(
			'#form.albumtitle#',
			'#form.albumdescription#',
			#createODBCDateTime(now())#,
			#session.UserID#,
			'#serverbildname#',
			#session.mandant#
		)
		</cfquery>	
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	</cfif>

<!--- 2. bestehende album updaten --->
<!--- -------------------------- --->

<!--- Modul submittedEditedAlbum --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedAlbum">

		<cfif form.albumImage NEQ "">
			<!--- bild auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="albumImage" destination="#remoteServerPath##session.serverpath#\upload\galleries\" nameconflict="makeunique">
			<!--- 	bild in die variable myImage laden --->
			<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" name="myImage"> 
			<!--- 	bildbreite auslesen und in bildbreite speichern --->
			<cfset bildbreite = ImageGetWidth(myImage) />
			<!--- 	serverbildname in variable speichen --->
			<cfset serverbildname = cffile.serverfile>
			<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
			<cfif bildbreite gt 300 >
				<cfimage action="resize" width="300" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" overwrite="yes">
				<!--- This example shows how to crop an image. --->
				<!--- Create a ColdFusion image from an existing JPEG file. --->
				<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" name="myImage2">
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
		<cfquery name="updateAlbum" datasource="#application.dsn#">
		UPDATE	albums
		SET		albumTitle = '#form.albumtitle#',
				albumDescription = '#form.albumdescription#',
				modifydate = #createODBCdateTime(now())#,
				albumImage = '#serverbildname#'
		WHERE	id = #form.albumID#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no"> 
</cfif>

<!--- zu bearbeitenden album aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editAlbum") AND isNumeric(url.editAlbum) AND url.editAlbum GT 0>
	<cfquery name="editAlbum" datasource="#application.dsn#">
	SELECT	*
	FROM	albums
	WHERE	id = #url.editAlbum# AND
			mandant = #session.mandant#
	</cfquery>
</cfif>

<!---bilder der albums speichern --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewImage">
	<!--- bild upload --->
	<!--- wenn ein bild ausgewählt wurde --->
	<cfif form.bild NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\galleries\" nameconflict="makeunique">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildname = cffile.serverfile>
		<!--- 	wenn bildbreite gt 480 -> bild auf 480 resizen und überschreiben --->
		<cfif bildbreite gt 1050 >
			<cfimage action="resize" width="1024" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" overwrite="yes">
		</cfif>
	<cfelse>
		<cfset serverbildname = "">
	</cfif>
	
	
	<!--- thumbnail generieren --->
	<!--- wenn ein bild ausgewählt wurde --->
	<cfif form.bild NEQ "">
		
		<!--- 	vorhger upgeloadetes bild in die variable myImage laden um thumbnail zu erstellen --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildnameThumb = cffile.serverfilename & "_thumb." & cffile.serverfileext>
		<!--- 	wenn bildbreite gt 480 -> bild auf 480 resizen und überschreiben --->
		<cfif bildbreite gt 700 >
			<cfimage action="resize" width="700" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildnameThumb#" overwrite="yes">
		</cfif>
	<cfelse>
		<cfset serverbildnameThumb = "">
	</cfif>
		
	<!--- wenn reihenfolge nicht übermittelt, dann höchste reihenfolges dieses albums auslesen --->
	<cfquery name="getMaxOrder" datasource="#application.dsn#">
	SELECT max(reihenfolge) as maxi FROM albumimages
	WHERE albumid = #form.albumid#
	</cfquery>
	<!--- wenn recordcount = 1, dann bestehnde reihenfolge um 10 erhöhen --->
	<cfif isNumeric(getMaxOrder.maxi)>
		<cfset nextOrder = getMaxOrder.maxi + 10 />
	<!--- wenn noch kein bild in diesem album, dann 10 initital setzen --->
	<cfelse>
		<cfset nextOrder = 10 />
	</cfif>
	


<!--- <cfdump var="#form#">
	<cfabort>
	 --->
	
	<cfquery name="insertImage" datasource="#application.dsn#">
		INSERT 	INTO albumimages(
				imageTitle,
				imagePath,
				albumID,
				imageCaption,
				imageThumbPath,
				reihenfolge,
				createDate,
				creator,
				imageOwner 
				)
		VALUES(
				'#form.titel#',
				'#serverbildname#',
				#form.albumid#,
				'#form.lead#',
				'#serverbildnameThumb#',
				<!--- wenn reihenfolge übermittels, diese berücksichtigen, ansonsten den oben kalkulierten wert einfügen --->
				<cfif isNumeric(form.reihenfolge)>#form.reihenfolge#<cfelse>#nextOrder#</cfif>,
				#createODBCdate(now())#,
				#session.UserID#,
				'#form.owner#'
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>


<!---II albumbild der albums ändern / updaten --->
<!--- ----------------------------------- --->

<cfif isdefined("url.action") AND url.action EQ "submittedEditedImage">
	<!--- bild upload --->
	<!--- wenn ein bild ausgewählt wurde --->
	<cfif form.bild NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\galleries\" nameconflict="makeunique">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildname = cffile.serverfile>
		<!--- 	wenn bildbreite gt 1050 -> bild auf 1024 resizen und überschreiben --->
		<cfif bildbreite gt 1050 >
			<cfimage action="resize" width="1024" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" overwrite="yes">
		</cfif>
	<cfelseif isdefined("delimage")>
		<cfset serverbildname = "">
	<cfelse>
		<cfset serverbildname = form.origbild>
	</cfif>
	
	
	<!--- thumb erstellung --->
	<!--- wenn ein bild ausgewählt wurde --->
	<cfif form.bild NEQ "">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildnameThumb = "thumb_" & serverbildname>
		<!--- 	wenn bildbreite gt 480 -> bild auf 480 resizen und überschreiben --->
		<cfif bildbreite gt 700 >
			<cfimage action="resize" width="700" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildnameThumb#" overwrite="yes">
		</cfif>
	<cfelseif isdefined("delimage")>
		<cfset serverbildnameThumb = "">
	<cfelse>
		<cfset serverbildnameThumb = form.origbild>
	</cfif>
	
	
	<!--- wenn reihenfolge nicht übermittelt, dann höchste reihenfolges dieses albums auslesen --->
	<cfquery name="getMaxOrder" datasource="#application.dsn#">
	SELECT max(reihenfolge) as maxi FROM albumimages
	WHERE albumid = #form.albumid# AND id != #form.imageid#
	</cfquery>
	<!--- wenn recordcount = 1, dann bestehnde reihenfolge um 10 erhöhen --->
	<cfif isNumeric(getMaxOrder.maxi)>
		<cfset nextOrder = getMaxOrder.maxi + 10 />
	<!--- wenn noch kein bild in diesem album, dann 10 initital setzen --->
	<cfelse>
		<cfset nextOrder = 10 />
	</cfif>
	
	<cfquery name="updateImage" datasource="#application.dsn#">
		UPDATE	albumimages
		SET		imageTitle = '#form.titel#',
				imagePath = '#serverbildname#',
				imageCaption = '#form.lead#',
				imageThumbPath = '#serverbildnameThumb#',
				reihenfolge = <cfif isNumeric(form.reihenfolge)>#form.reihenfolge#<cfelse>#nextOrder#</cfif>,
				modifyDate = #createODBCdate(now())#,
				imageOwner = '#form.owner#'
		WHERE	id = #form.imageid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- bild löschen --->
<cfif isdefined("url.delimage") AND isNumeric(url.delimage) AND url.delimage GT 0>
	<cfquery name="delimage" datasource="#application.dsn#">
	DELETE
	FROM	albumimages
	WHERE	id = #url.delimage#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->

<!--- initialisieren von Flexylib helptexts --->
<cfset flexyLib = createObject('component','admin.cfc.flexy') />


<div style="float:left;"><cfoutput>#flexyLib.setHelpText(variable='galery_management_description',type=1,visualType=2)#</cfoutput></div>
<div style="clear:both;"></div>


<!--- liste mit allen Alben darstellen mit eingerückten kindern --->
<cfif not isdefined("url.editalbum") AND not isdefined("url.editImage")>
<table width="100%">
<tr>
	<td id="gray1"><h4>Album</h4></td>
	
	<td colspan="2" id="gray2"><h4>Bearbeiten</h4></td>
	
	<td id="gray3"> <h4>Bilder</h4></td>
	
</tr>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Bearbeiten</strong></td>
	<td><strong>Löschen</strong></td>
	<td><strong>bearbeiten</strong></td>
</tr>
<cfset albumIDx = 0 />
<cfoutput query="getAlbums">
<cfset albumIDx = getAlbums.id />
<cfquery name="getImagesByAlbumID" datasource="#application.dsn#">
SELECT	*
FROM	albumimages
WHERE	albumid = #albumIDx#
ORDER BY reihenfolge
</cfquery>
<tr class="album_header_row">
	<td><strong>Album:</strong> #albumtitle#</td>
	<td>
		<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?editalbum=#albumIDx#">
				Album
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delalbum=#albumIDx#" onclick="return confirm('Sind Sie sicher?\nEs werden alle Bilder des Albums ebenfalls gelöscht');">
				löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif getImagesByAlbumID.recordcount GT 0>
		<a href="javascript:$('##bilder#albumIDx#').toggle();void(0);">
			Alle Bilder
		</a>
		</cfif>&nbsp;
		<cfif rightAdd EQ 1>
			<a href="#cgi.SCRIPT_NAME#?action=addImage&albumID=#albumIDx#">
				Bilder +
			</a>
			<cfif hasMultiUploadGallery>
				<a href="javascript:$('##bilderMulti#albumIDx#').toggle();void(0);">
					Bilder ++
				</a>
			</cfif>
		</cfif>	
	</td>
</tr>
<tr>
	<td colspan="76" style="border:0;">
		<div style="display:none;" id="bilderMulti#albumIDx#">
			
			
			<script type="text/javascript">
			function onUploadComplete#getAlbums.id#(){
				location.href='#cgi.SCRIPT_NAME#?openGallery=#getAlbums.id#';
			}
			</script>
			
			<div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_multiupload',type=1,visualType=2)#</div>
			<cffileupload url="inc/prc_process_multiupload.cfm?#urlEncodedFormat(session.urlToken)#&albumid=#albumIDx#&requestTimeout=300" style="width:100%;" maxfileselect="70" onuploadcomplete="onUploadComplete#getAlbums.id#" extensionfilter="*.jpg, *.png, *.gif" maxuploadsize="20"  />
			<!--- <br />
			<a href="/admin/multiuploadLog.htm" target="_blank">Logfile des Uploads</a> --->
		</div>
	<!--- </td>
	<td> /td> --->
</tr>
<cfif getImagesByAlbumID.recordcount GT 0>
<tr>
	<td colspan="7" style="border:0;">
		<div style="<cfif isdefined("url.openGallery") AND url.openGallery EQ getAlbums.id>display:block;<cfelse>display:none;</cfif>" id="bilder#albumIDx#">
			<table cellspacing="0" cellpadding="0" width="100%">
			<cfloop query="getImagesByAlbumID">
			<tr class="album_image_row">
				<cfif imageThumbPath NEQ "">
				<td class="album_thumb_pix">
					<img src="http://www.#session.mandantURL#/#session.serverpath#/upload/galleries/#imageThumbPath#" max-width=100px;  />
				</td>
				</cfif>
				<td><strong><cfif imageTitle NEQ "">#imageTitle#<cfelse>[kein Titel]</cfif></strong><br/>#imagecaption#</td>
				<td>#reihenfolge#</td>
				<td>
					<cfif rightDel EQ 1>
						<a href="#cgi.SCRIPT_NAME#?delImage=#id#" onclick="return confirm('Sind Sie sicher?');">
							löschen
						</a>
					</cfif>
				</td>
				<td>
					<cfif rightEdit EQ 1>
						<a href="#cgi.SCRIPT_NAME#?editImage=#id#&albumid=#albumIDx#">
							bearbeiten
						</a>
					</cfif>
				</td>
			</tr>
			</cfloop>
			</table>
			
		</div>
	</td>
</tr>
</cfif>
</cfoutput>
</table>
</cfif>
<!--- dies erscheint nur wenn neues album hinzufügen gewählt wurde --->
<cfoutput>
<cfif isdefined("url.action") AND url.action EQ "addAlbum">
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewAlbum" method="post" enctype="multipart/form-data">
	<table cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td>Titel <div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_title',type=1,visualType=1)#</div></td>
		<td><input type="text" name="albumtitle" <cfif isdefined("form.albumtitle")>value="#form.albumtitle#"</cfif>></td>
	</tr>
	<tr>
		<td>Beschreibung <div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_description',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="albumdescription" id="" rows="1" cols="1" style="width:100%;height:120px;"></textarea>
		</td>
	</tr>
	<tr>
		<td>Album-Bild <div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_Albumbild',type=1,visualType=1)#</div></td>
		<td><input type="file" name="albumImage" id="albumImage"></td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Album erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editAlbum")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addAlbum">neues Album erfassen</a>
	</cfif>
	<cfelse>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn Album bearbeiten gewählt wurde --->
<cfif isdefined("url.editAlbum") AND isNumeric(url.editAlbum) AND url.editAlbum GT 0>
<cfoutput query="editAlbum">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedAlbum" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Titel <div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_title',type=1,visualType=1)#</div></td>
		<td><input type="text" name="albumtitle" value="#albumtitle#"></td>
	</tr>
	<tr>
		<td>Beschreibung <div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_description',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="albumdescription" id="" rows="1" cols="1" style="width:100%;height:120px;">#albumdescription#</textarea>
		</td>
	</tr>
	<tr>
		<td>Album-Bild <div style="float:right;">#flexyLib.setHelpText(variable='edit_gallery_Albumbild',type=1,visualType=1)#</div></td>
		<td>
			<cfif albumimage NEQ "">
			Momentanes Albumbild auf dem Server: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/galleries/#albumimage#" target="_blank">#albumimage#</a><!--- <a href="/#session.serverpath#/upload/galleries/#albumimage#" target="_blank">#albumimage#</a> ---><br/>
			<input type="checkbox" name="delimage" value="#albumimage#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="albumimage">
			<input type="hidden" name="origbild" value="#albumimage#" />
		</td>
	</tr>
	<tr>
		<td><input type="hidden" name="albumID" value="#id#"></td>
		<td><input type="submit" value="Album ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>


<br><br>
<cfif isdefined("url.action") AND url.action EQ "addImage">
	<cfinclude template="inc_addImage.cfm" />
</cfif>

<cfif isdefined("url.editImage") AND isNumeric(url.editImage) AND url.editImage GT 0>
	<cfinclude template="inc_editImage.cfm" />
</cfif>

