<cfprocessingdirective pageencoding="utf-8" />

<!--- form processor UPDATE slide Template 3 
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
	
	<!--- update template 3 --->
	<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
	UPDATE	magazinslidetpl_#form.template#
	SET		titel = '#form.titel#',
			lead = '#form.lead#',
			layoutType = #form.typ#
	WHERE	slideid = #form.slideID#
	</cfquery>
	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>--->
<!---END  form processor UPDATE slide Template 3 --->

<cfquery name="getslideTpl3" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_3
WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl3">
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
		</td>
	</tr> 
	<TR>
		<td>Layout-Type:</td>
		<td>
			<input type="radio" value="1" <cfif layoutType EQ 1>checked</cfif> name="typ"> Text zentriert<br/>
			<input type="radio" value="2" <cfif layoutType EQ 2>checked</cfif> name="typ"> Text oben links<br/>
			<input type="radio" value="3" <cfif layoutType EQ 3>checked</cfif> name="typ"> Text unten rechts<br/>
		</td>
	</TR>
	</table>
</cfoutput>