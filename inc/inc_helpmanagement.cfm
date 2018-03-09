<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />

<!--- gleiches stylesheet wie pabgemanagement  --->



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


<!--- alle helpTextModule auslesen --->
<cfquery name="getModuls" datasource="#application.dsn#">
SELECT	*
FROM	helpTextModule
</cfquery>

<!--- HilfeTextModul löschen --->
<cfif isdefined("url.delModul") AND isNumeric(url.delModul) AND url.delModul GT 0>
	<cfquery name="delModul" datasource="#application.dsn#">
	DELETE
	FROM	helpTextModule
	WHERE	id = #url.delModul#
	</cfquery>
	<!--- alle hilfetexte des helpTextModule ebenfalls aus DB löschen --->
	<cfquery name="deleteImages" datasource="#application.dsn#">
	DELETE
	FROM	helptext
	WHERE	helpTextModulID = #url.delModul#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- I STRUKTUR   1. Neue HilfeTextModul hinzufügen --->
<!--- ------------------------------------ --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewModul">
	<cfquery name="insertModul" datasource="#application.dsn#">
	INSERT	
	INTO	helpTextModule (
			modulTitel,
			modulVariable,
			modulBeschreibung_simple,
			modulBeschreibung_full  
	)
	VALUES(
		'#form.modultitel#',
		#form.moduleid#,
		'#form.beschreibung_simple#',
		'#form.beschreibung_full#'
	)
	</cfquery>	
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- 2. bestehende HilfeTextModul updaten --->
<!--- -------------------------- --->

<!--- Modul submittedEditedModul --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedModul">
	<cfquery name="updateModul" datasource="#application.dsn#">
	UPDATE	helpTextModule
	SET		modulTitel = '#form.modultitel#',
			modulVariable = #form.moduleid#,
			modulBeschreibung_simple = '#form.beschreibung_simple#',
			modulBeschreibung_full = '#form.beschreibung_full#'
	WHERE	id = #form.modid#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no"> 
</cfif>

<!--- zu bearbeitenden HilfeTextModul aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editModul") AND isNumeric(url.editModul) AND url.editModul GT 0>
	<cfquery name="editModul" datasource="#application.dsn#">
	SELECT	*
	FROM	helpTextModule
	WHERE	id = #url.editModul#
	</cfquery>
</cfif>

<!---hilfetexte der helpTextModule speichern --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewHilfeText">
	<cfquery name="insertImage" datasource="#application.dsn#">
	INSERT 	INTO helptext(
			helpTextModulID,
			variable,
			helpText 
			)
	VALUES(
			#form.moduleid#,
			'#form.variable#',
			'#form.helpText#'
	)
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>


<!---II HilfeTextModulbild der helpTextModule ändern / updaten --->
<!--- ----------------------------------- --->

<cfif isdefined("url.action") AND url.action EQ "submittedEditedHelpText">
	
	<cfquery name="updateHilfeText" datasource="#application.dsn#">
		UPDATE	helptext
		SET		helpTextModulID = #form.moduleid#,
				variable = '#form.variable#',
				helpText = '#form.helpText#'
		WHERE	id = #form.helpTextID#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- bild löschen --->
<cfif isdefined("url.delHilfeText") AND isNumeric(url.delHilfeText) AND url.delHilfeText GT 0>
	<cfquery name="delHilfeText" datasource="#application.dsn#">
	DELETE
	FROM	helptext
	WHERE	id = #url.delHilfeText#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Alben darstellen mit eingerückten kindern --->
<cfif not isdefined("url.editModul") AND not isdefined("url.editHelpText")>
<table width="100%">
<tr>
	<td id="gray1"><h4>Modul</h4></td>
	
	<td colspan="2" id="gray2"><h4>Bearbeiten</h4></td>
	
	<td id="gray3"> <h4>Hilfe-Texte</h4></td>
	
</tr>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Bearbeiten</strong></td>
	<td><strong>Löschen</strong></td>
	<td><strong>bearbeiten</strong></td>
</tr>
<cfset moduleidx = 0 />
<cfoutput query="getModuls">
<cfset moduleidx = getModuls.id />
<cfquery name="getImagesByModulID" datasource="#application.dsn#">
SELECT	*
FROM	helptext
WHERE	helpTextModulID = #moduleidx#
</cfquery>
<tr>
	<td>#ModulTitel#</td>
	<td>
		<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?editModul=#moduleidx#">
				bearbeiten
			</a>
		</cfif>
	</td>
	<td>
		<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delModul=#moduleidx#" onclick="return confirm('Sind Sie sicher?\nEs werden alle Hilfe-Texte des Moduls ebenfalls gelöscht');">
				löschen
			</a>
		</cfif>
	</td>
	<td>
		<cfif getImagesByModulID.recordcount GT 0>
		<a href="javascript:$('##hilfetexte#moduleidx#').toggle();void(0);">
			Hilfe-Texte
		</a>
		</cfif>&nbsp;
		<cfif rightAdd EQ 1>
			<a href="#cgi.SCRIPT_NAME#?action=addHelpText&moduleid=#moduleidx#">
				Hilfe-Texte +
			</a>
		</cfif>	
	</td>
</tr>
<cfif getImagesByModulID.recordcount GT 0>
<tr>
	<td colspan="7">
		<div style="display:none;background-color:##e1e1e1;" id="hilfetexte#moduleidx#">
			<table cellspacing="0" cellpadding="0" width="100%">
			<cfloop query="getImagesByModulID">
			<tr>
				
				<td>
					#variable#
				</td>
				
				<td></td>
				<td></td>
				<td>
					<cfif rightDel EQ 1>
						<a href="#cgi.SCRIPT_NAME#?delImage=#id#" onclick="return confirm('Sind Sie sicher?');">
							löschen
						</a>
					</cfif>
				</td>
				<td>
					<cfif rightEdit EQ 1>
						<a href="#cgi.SCRIPT_NAME#?editHelpText=#id#&helpTextID=#moduleidx#">
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
<!--- dies erscheint nur wenn neues HilfeTextModul hinzufügen gewählt wurde --->
<cfoutput>
<cfif isdefined("url.action") AND url.action EQ "addModul">
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewModul" method="post" enctype="multipart/form-data">
	<table cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td>Kategorie Titel</td>
		<td><input type="text" name="modultitel" <cfif isdefined("form.modultitel")>value="#form.modultitel#"</cfif>></td>
	</tr>
	<tr>
		<td>Modul</td>
		<td>
			<cfquery name="Modules" datasource="#application.dsn#">
			SELECT	*
			FROM	modules
			</cfquery>
			<select name="moduleid">
				<cfloop query="Modules">
					<option value="#id#">#module#</option>
				</cfloop>
				<option value="0">-- kein bestendes Modul --</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>Beschreibung simpel</td>
		<td>
			<textarea name="beschreibung_simple"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:80px;"><cfif isdefined("form.beschreibung_simple")>#form.beschreibung_simple#</cfif></textarea>
		</td>
	</tr>
	<tr>
		<td>Volle, technische Beschreibung</td>
		<td>
			<textarea name="beschreibung_full"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.beschreibung_full")>#form.beschreibung_full#</cfif></textarea>
		</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Modul erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editModul")>
	<cfif rightAdd EQ 1>
		<a href="#cgi.SCRIPT_NAME#?action=addModul">neues Modul erfassen</a>
	</cfif>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn Modul bearbeiten gewählt wurde --->
<cfif isdefined("url.editModul") AND isNumeric(url.editModul) AND url.editModul GT 0>
<cfoutput query="editModul">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedModul" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>Kategorie Titel</td>
		<td><input type="text" name="modultitel" value="#modultitel#"></td>
	</tr>
	<tr>
		<td>Modul</td>
		<td>
			<cfquery name="Modules" datasource="#application.dsn#">
			SELECT	*
			FROM	modules
			</cfquery>
			<select name="moduleid">
				<cfloop query="Modules">
					<option value="#id#" <cfif editModul.modulVariable EQ id>selected="selected"</cfif>>#module#</option>
				</cfloop>
				<option value="0" <cfif editModul.modulVariable EQ 0>selected="selected"</cfif>>-- kein bestendes Modul --</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>Beschreibung simpel</td>
		<td>
			<textarea name="beschreibung_simple"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:80px;">#modulBeschreibung_simple#</textarea>
		</td>
	</tr>
	<tr>
		<td>Volle, technische Beschreibung</td>
		<td>
			<textarea name="beschreibung_full"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:120px;">#modulBeschreibung_full#</textarea>
		</td>
	</tr>
	<tr>
		<td><input type="hidden" name="modid" value="#editModul.id#"></td>
		<td><input type="submit" value="Modul ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>


<br><br>
<cfif isdefined("url.action") AND url.action EQ "addHelpText">
	<cfinclude template="inc_addHelpText.cfm" />
</cfif>

<cfif isdefined("url.editHelpText") AND isNumeric(url.editHelpText) AND url.editHelpText GT 0>
	<cfinclude template="inc_editHelpText.cfm" />
</cfif>

