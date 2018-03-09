<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getImageByID" datasource="#application.dsn#">
SELECT	*
FROM	albumimages
WHERE	id = #url.editimage#
</cfquery>

<cfoutput query="getImageByID">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedImage" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Bild</td>
		<td>
			<cfif imagePath NEQ "">
			Momentanes Bild auf dem Server:<a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/galleries/#imagePath#" target="_blank">#imagePath#</a><!--- <a href="/#session.serverpath#/upload/galleries/#imagePath#" target="_blank">#imagePath#</a> ---><br/>
			<!--- EXIF Metadaten auslesen ist noch ein kuules CF -tag --->
			<!--- <cfimage source="http://www.atelier-schief.ch/schmuck-und-kunst/upload/galleries/ob_wood_11.jpg" name="felix">
			<cfdump var="#imagegetexifmetadata(felix)#"> --->
			
			<input type="checkbox" name="delimage" value="#imagePath#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="bild">
			<input type="hidden" name="origbild" value="#imagePath#" />
		</td>
	</tr>
	<tr>
		<td>
			Titel
		</td>
		<td>
			<input type="text" name="titel" value="#imageTitle#">
		</td>
	</tr>
	<tr>
		<td>
			Reihenfolge
		</td>
		<td>
			<input type="text" name="reihenfolge" value="#reihenfolge#">
		</td>
	</tr>
	<tr>
		<td>
			Legende
		</td>
		<td>
<textarea name="lead" cols="1" rows="1" style="width:100%;height:65px;">#imageCaption#</textarea>
		</td>
	</tr>
	<tr>
		<td>
			Fotograf
		</td>
		<td>
			<input type="text" name="owner" value="#imageOwner#">
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" class="btn-action" /> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';" class="btn-noaction"/>
			<input type="hidden" name="imageid" value="#url.editimage#" />
			<input type="hidden" name="albumid" value="#url.albumid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput>