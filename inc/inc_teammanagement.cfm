<cfprocessingdirective pageencoding="utf-8" />

<!--- gleiches stylesheet wie pabgemanagement  --->
<link  rel="stylesheet" type="text/css" href="/admin/css/pagemanagement.css"  >


<!--- 
<cfdump var="#session.rechte.module#"> --->
<style>
 
/* colors für status*/
#activ{
	color:#3F3;
	}

#inactiv{
	color:#9FF;
	}
	
/*:nth-child(2n){*/

table tr,table tr table tr{
	background:#949494;
	}
	
table td{
	vertical-align:top;
	padding:5px 5px;
	}
	
table td:first-child{
	padding-top:8px;
	}
	
table tr:nth-child(2n+1),table tr:nth-child(2n+1) table tr{
	background:#B2B2B2;
	}	
	
#gray1{
	color:#039;
	letter-spacing:2px;
	background:#9A9A9A;
	}

#gray2{
	color:#039;
	letter-spacing:2px;
	background:#B2B2B2;
	}

#gray3{
	color:#039;
	letter-spacing:2px;
	background:#D6D6D6;
	}	
	
input[type=text],input[type=file],textarea,select{
	width:98%;
	border:1px solid silver;
	padding:2px;	
	font-family:Tahoma, Geneva, sans-serif;
	font-size:13px;
}

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


<!--- alle teamCategories auslesen --->
<cfquery name="getTeamCategories" datasource="#application.dsn#">
SELECT	*
FROM	teamCategories
where	mandant = #session.mandant#
</cfquery>

<!--- TeamCategory löschen --->
<cfif isdefined("url.delTeamCategory") AND isNumeric(url.delTeamCategory) AND url.delTeamCategory GT 0>
	<cfquery name="delTeamCategory" datasource="#application.dsn#">
	DELETE
	FROM	teamCategories
	WHERE	id = #url.delTeamCategory#
	</cfquery>
	<!--- alle teamMembers des teamCategories ebenfalls aus DB löschen --->
	<cfquery name="deleteImages" datasource="#application.dsn#">
	DELETE
	FROM	teammembers
	WHERE	parentCategory = #url.delTeamCategory#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- I STRUKTUR   1. Neue TeamCategory hinzufügen --->
<!--- ------------------------------------ --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewTeamCategory">
	<cfquery name="insertTeamCategory" datasource="#application.dsn#">
	INSERT	
	INTO	teamCategories (
			label,
			isActive,
			mandant,
			lang
	)
	VALUES(
			'#form.label#',
			#form.active#,
			#session.mandant#,
			'#session.lang#'
	)
	</cfquery>	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- 2. bestehende TeamCategory updaten --->
<!--- -------------------------- --->

<!--- Modul submittedEditedTeamCategory --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedTeamCategory">
	<cfquery name="updateTeamCategory" datasource="#application.dsn#">
	UPDATE	teamCategories
	SET		label = '#form.label#',
			isActive = #form.active#
	WHERE	id = #form.catid#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no"> 
</cfif>

<!--- zu bearbeitenden TeamCategory aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editTeamCategory") AND isNumeric(url.editTeamCategory) AND url.editTeamCategory GT 0>
	<cfquery name="editTeamCategory" datasource="#application.dsn#">
	SELECT	*
	FROM	teamCategories
	WHERE	id = #url.editTeamCategory#
	</cfquery>
</cfif>

<!---teamMembers der teamCategories speichern --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewTeamMember">
	<cfif form.bild NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="bild" destination='#remoteServerPath##session.serverpath#\upload\img\team\' nameconflict="makeunique">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\img\team\#cffile.serverfile#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildname = cffile.serverfile>
		<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben neu auf 100 px --->
		<cfif bildbreite gte 100 >
			<cfimage action="resize" width="700" height="" source="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" overwrite="yes">
			<cfimage action="resize" width="320" height="" source="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\team\thumb_#serverbildname#" overwrite="yes">
		<cfelse>
			<cffile action="delete" file="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" />
			<cfset serverbildname = ""> 
		</cfif>
	<cfelse>
		<cfset serverbildname = ""> 
	</cfif>

	<cfquery name="insertTeamMember" datasource="#application.dsn#">
	INSERT 	INTO teammembers(
			isActive,
			teamName,
			teamVorname,
			teamAnrede,
			teamAdresse,
			teamPLZ,
			teamOrt,
			teamLand,
			teamTel,
			teamFax,
			teamEmail,
			teamMobile,
			teamURL,
			teamSkype,
			teamXing,
			teamLinkedIn,
			teamFacebook,
			teamTwitter,
			teamFunktion,
			teamAusbildung,
			teamTestimonial,
			teamBildThumb,
			teamBildBig,
			teamCV,
			teamUrlshortcut,
			parentCategory
			)
	VALUES(
			#form.active#,
			'#form.name#',
			'#form.vorname#',
			#form.anrede#,
			'#form.adresse#',
			<cfif form.plz neq "" and isnumeric(form.plz)>#form.plz#<cfelse>NULL</cfif>,  
			'#form.ort#',
			'#form.strCountryChoice#',
			'#form.tel#',
			'#form.fax#',
			'#form.email#',
			'#form.mobile#',
			'#form.www#',
			'#form.skype#',
			'#form.xing#',
			'#form.linkedin#',
			'#form.facebook#',
			'#form.twitter#',
			'#form.funktion#',
			'#form.ausbildung#',
			'#form.motto#',
			'thumb_#serverbildname#',
			'#serverbildname#',
			'#form.cv#',
			'#form.urlshortcut#',
			#form.catID#
	)
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- ----------------------------------- --->

<cfif isdefined("url.action") AND url.action EQ "submittedEditedTeamMember">
	<cfif form.bild NEQ "">
		<!--- bild auf den server in relativpfad-folder uploaden --->
		<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\img\team\" nameconflict="makeunique">
		<!--- 	bild in die variable myImage laden --->
		<cfimage source="#remoteServerPath##session.serverpath#\upload\img\team\#cffile.serverfile#" name="myImage"> 
		<!--- 	bildbreite auslesen und in bildbreite speichern --->
		<cfset bildbreite = ImageGetWidth(myImage) />
		<!--- 	serverbildname in variable speichen --->
		<cfset serverbildname = cffile.serverfile>
		<!--- 	wenn bildbreite gt 960 -> bild auf 480 resizen und überschreiben --->
		<cfif bildbreite gte 100 >
			<cfimage action="resize" width="700" height="" source="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" overwrite="yes">
			<cfimage action="resize" width="320" height="" source="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\team\thumb_#serverbildname#" overwrite="yes">
		<cfelse>
			<cffile action="delete" file="#remoteServerPath##session.serverpath#\upload\img\team\#serverbildname#" />
			<cfset serverbildname = form.origbild>
		</cfif>
	<cfelseif not isdefined("form.delimage")>
		<cfset serverbildname = form.origbild>
	<cfelse>
		<cfset serverbildname = ""> 
	</cfif>	
	<cfquery name="updateHilfeText" datasource="#application.dsn#">
		UPDATE	teammembers
		SET		isActive = #form.active#,
				teamName = '#form.name#',
				teamVorname = '#form.vorname#',
				teamAnrede = #form.anrede#,
				teamAdresse = '#form.adresse#',
				teamPLZ = <cfif form.plz neq "" and isnumeric(form.plz)>#form.plz#<cfelse>NULL</cfif>,  
				teamOrt = '#form.ort#',
				teamLand = '#form.strCountryChoice#',
				teamTel = '#form.tel#',
				teamFax = '#form.fax#',
				teamEmail = '#form.email#',
				teamMobile = '#form.mobile#',
				teamURL = '#form.www#',
				teamSkype = '#form.skype#',
				teamXing = '#form.xing#',
				teamLinkedIn = '#form.linkedin#',
				teamFacebook = '#form.facebook#',
				teamTwitter = '#form.twitter#',
				teamFunktion = '#form.funktion#',
				teamAusbildung = '#form.ausbildung#',
				teamTestimonial = '#form.motto#',
				teamBildThumb = <cfif serverbildname NEQ "">'thumb_#serverbildname#'<cfelse>NULL</cfif>,
				teamBildBig = '#serverbildname#',
				teamCV = '#form.cv#',
				teamUrlshortcut = '#form.urlshortcut#'
		WHERE	id = #form.teamMemberID#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<cfif isdefined("url.delTeamMember") AND isNumeric(url.delTeamMember) AND url.delTeamMember GT 0>
	<cfquery name="delTeamMember" datasource="#application.dsn#">
	DELETE
	FROM	teammembers
	WHERE	id = #url.delTeamMember#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->

<cfif not isdefined("url.editTeamCategory") AND not isdefined("url.editTeamMember")>
<table width="100%">
<tr>
	<td id="gray1"><h4>Team Kategorie</h4></td>
	
	<td colspan="2" id="gray2"><h4>Bearbeiten</h4></td>
	
	<td id="gray3"> <h4>Team Mitglieder</h4></td>
	
</tr>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Bearbeiten</strong></td>
	<td><strong>Löschen</strong></td>
	<td><strong>bearbeiten</strong></td>
</tr>
<cfset moduleidx = 0 />
<cfoutput query="getTeamCategories">
<cfset moduleidx = getTeamCategories.id />
<cfquery name="getTeamMembersByCategory" datasource="#application.dsn#">
SELECT	*
FROM	teammembers
WHERE	parentCategory = #moduleidx#
</cfquery>
<tr>
	<td>#label#</td>
	<td>
		<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?editTeamCategory=#moduleidx#">
				bearbeiten
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delTeamCategory=#moduleidx#" onclick="return confirm('Sind Sie sicher?\nEs werden alle Team-Mitglieder des Moduls ebenfalls gelöscht');">
				löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif getTeamMembersByCategory.recordcount GT 0>
		<a href="javascript:$('##teamMembers#moduleidx#').toggle();void(0);">
			Team-Mitglieder
		</a>
		</cfif>&nbsp;
		<cfif rightAdd EQ 1>
			<a href="#cgi.SCRIPT_NAME#?action=addTeamMember&teamcategoryID=#moduleidx#">
				Team-Member +
			</a>
		</cfif>	
	</td>
</tr>
<cfif getTeamMembersByCategory.recordcount GT 0>
<tr>
	<td colspan="7">
		<div style="display:none;background-color:##e1e1e1;" id="teamMembers#moduleidx#">
			<table cellspacing="0" cellpadding="0" width="100%">
			<cfloop query="getTeamMembersByCategory">
			<tr>
				<td>
					<cfif teamBildThumb NEQ "">
						<img src="/#session.serverpath#/upload/img/team/#teamBildThumb#" width="50" alt="" />
					</cfif>
				</td>
				<td>
					#teamName#, #teamVorname#
				</td>
				
				<td></td>
				<td></td>
				<td>
					<cfif rightDel EQ 1>
						<a href="#cgi.SCRIPT_NAME#?delTeamMember=#id#" onclick="return confirm('Sind Sie sicher?');">
							löschen
						</a>
					</cfif>
				</td>
				<td>
					<cfif rightEdit EQ 1>
						<a href="#cgi.SCRIPT_NAME#?editTeamMember=#id#&teamMemberID=#moduleidx#">
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
<!--- dies erscheint nur wenn neues TeamCategory hinzufügen gewählt wurde --->
<cfoutput>
<cfif isdefined("url.action") AND url.action EQ "addTeamCategory">
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewTeamCategory" method="post" enctype="multipart/form-data">
	<table cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td>Kategorie Titel</td>
		<td><input type="text" name="label" <cfif isdefined("form.label")>value="#form.label#"</cfif>></td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Team-Kategorie erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editTeamCategory")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addTeamCategory">neue Kategorie erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn Modul bearbeiten gewählt wurde --->
<cfif isdefined("url.editTeamCategory") AND isNumeric(url.editTeamCategory) AND url.editTeamCategory GT 0>
<cfoutput query="editTeamCategory">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedTeamCategory" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Kategorie Titel</td>
		<td><input type="text" name="label" value="#label#"></td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td><input type="hidden" name="catid" value="#id#"></td>
		<td><input type="submit" value="Team-Kategorie ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>


<br><br>
<cfif isdefined("url.action") AND url.action EQ "addTeamMember">
	<cfinclude template="inc_addTeamMember.cfm" />
</cfif>

<cfif isdefined("url.editTeamMember") AND isNumeric(url.editTeamMember) AND url.editTeamMember GT 0>
	<cfinclude template="inc_editTeamMember.cfm" />
</cfif>

