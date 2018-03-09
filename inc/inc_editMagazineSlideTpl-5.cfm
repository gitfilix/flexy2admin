<cfprocessingdirective pageencoding="utf-8" />

<!--- form processor UPDATE slide Template 5 --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedMagazineSlide">
	
	<!--- upload bgimage  --->
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
	
	<!--- upload image chapter 1 --->
	<cfset img = form.origbild_1 />
	<cfif isdefined("form.chapter_1_img") AND form.chapter_1_img NEQ "">
		<cffile action="upload" filefield="chapter_1_img" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset img = cffile.serverfile />
	</cfif>
	
	<!--- update template 5--->
	<cfquery name="updateMagazineSlideTpl5" datasource="#application.dsn#">
	UPDATE	magazinslidetpl_#form.template#
	SET		title = '#form.title#',
			chapter_1_title = '#form.chapter_1_title#',
			chapter_1_desc = '#form.chapter_1_desc#',
			chapter_1_img = '#img#',
			chapter_1_linklabel = '#form.chapter_1_linklabel#',
			chapter_1_link = '#form.chapter_1_link#'   
	WHERE	slideid = #form.slideID#
	</cfquery>
	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!---END  form processor UPDATE slide Template 2 --->

<cfquery name="getslideTpl5" datasource="#application.dsn#">
	SELECT *
	FROM 	magazinslidetpl_5
	WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl5">
	<cfdump var="#getslideTpl5#">
	<table width="100%">
	<tr>
		<td>
			Titel Inhaltsverzeichnis:
		</td>
		<td>
			<input type="text" name="title" id="title" value="#title#" />
		</td>
	</tr>
	<tr>
		<td>
			Kapitel 1 Titel:
		</td>
		<td>
			<input type="text" name="chapter_1_title" id="chapter_1_title" value="#chapter_1_title#" />
		</td>
	</tr>
	<tr>
		<td>
			Kapitel 1 Beschreibung:
		</td>
		<td>
			<textarea name="chapter_1_desc" id="chapter_1_desc" rows="0" cols="0">#chapter_1_desc#</textarea>
			<script>
				CKEDITOR.replace('chapter_1_desc');
			</script>
		</td>
	</tr> 
	<tr>
		<td>
			Kapitel 1 Bild:
		</td>
		<td>
			<input type="file" name="chapter_1_img" id="chapter_1_img" />
			<input type="hidden" name="origbild_1" id="origbild_1" value="#chapter_1_img#" />
			<cfif chapter_1_img NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#chapter_1_img#')>
				<img src="/#session.serverpath#/upload/magazine/#chapter_1_img#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			Link Label:
		</td>
		<td>
			<input type="text" name="chapter_1_linklabel" id="chapter_1_linklabel" value="#chapter_1_linklabel#" />
		</td>
	</tr>
	<tr>
		<td>
			Kapitel (Slide-ID):
		</td>
		<td>
			<input type="text" name="chapter_1_link" id="chapter_1_link" value="#chapter_1_link#" />
		</td>
	</tr>
	</table>
</cfoutput>