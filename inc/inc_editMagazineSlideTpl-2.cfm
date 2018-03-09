<cfprocessingdirective pageencoding="utf-8" />

<!--- form processor UPDATE slide Template 2 --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedMagazineSlide">
	
	<!--- upload bgimage --->
	<cfset bg = form.origbg />
	<cfif isdefined("form.bgimage") AND form.bgimage NEQ "">
		<cffile action="upload" filefield="bgimage" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset bg = cffile.serverfile />
	</cfif>
	
	<cfquery name="updateMagazineSlide" datasource="#application.dsn#">
	UPDATE	magazinslides
	SET		label = '#form.label#',
			bgimage = '#bg#'
	WHERE	id = #form.slideID#
	</cfquery>
	
	<!--- upload image --->
	<cfset bildx = form.origbild />
	<cfif isdefined("form.bild") AND form.bild NEQ "">
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset bildx = cffile.serverfile />
	</cfif>
	
	<!--- update template 2 --->
	<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
	UPDATE	magazinslidetpl_#form.template#
	SET		titel = '#form.titel#',
			lead = '#form.lead#',
			bild = '#bildx#',
			bildlegende = '#form.caption#',
			ytvideo = '#form.ytcode#'   
	WHERE	slideid = #form.slideID#
	</cfquery>
	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!---END  form processor UPDATE slide Template 2 --->

<cfquery name="getslideTpl2" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_2
WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl2">
	<table width="100%">
	<tr>
		<td>
			Titel:
		</td>
		<td>
			<input type="text" name="titel" id="titel" value="#titel#" />
		</td>
	</tr>
	<tr>
		<td>
			Anriss:
		</td>
		<td>
			<textarea name="lead" id="lead" rows="0" cols="0">#lead#</textarea>
			<script>
				CKEDITOR.replace('lead');
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Bild:
		</td>
		<td>
			<input type="file" name="bild" id="bild" />
			<input type="hidden" name="origbild" id="origbild" value="#bild#" />
			<cfif bild NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#bild#')>
				<img src="/#session.serverpath#/upload/magazine/#bild#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Bild Legende:
		</td>
		<td>
			<textarea name="caption" id="caption" rows="0" cols="0">#bildlegende#</textarea>
			<script>
				CKEDITOR.replace('caption');
			</script>
		</td>
	</tr>
	<tr>
		<td>
			Youtube Video code:
		</td>
		<td>
			<input type="text" name="ytcode" id="ytcode" value="#ytvideo#" />
		</td>
	</tr>
	</table>
</cfoutput>