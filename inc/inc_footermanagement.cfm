<cfprocessingdirective pageencoding="utf-8" />

<!--- include ck- editor für fliesstext --->
<cfhtmlhead text="
	<script type='text/javascript' src='/admin/js/ckeditor/ckeditor.js'></script>
" />

<!--- FormProzessors --->

<!--- 1. GET ALL footers --->

<cfquery name="getAllFooters" datasource="#application.dsn#">
SELECT 		* 
FROM 		footer
WHERE 		mandant = #session.mandant#

</cfquery>

<!--- 2. Footer löschen --->
<!--- id des zu löschenden footers auslesen und auf isNumeric prüfen und recordcount muss gt 0 sein. --->
<cfif isdefined("url.delfooter") AND isNumeric(url.delfooter) AND url.delfooter GT 0>
	<cfquery name="delfooter" datasource="#application.dsn#">
	DELETE
	FROM	footer
	WHERE	id = #url.delfooter#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>


<!--- 3. Neuer Footer hinzufügen wenn form submitnewFooter und Copyright ausgefüllt wurden. --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewFooter" AND isdefined("form.copyright") >
		
	<!--- 	variable ActionSuceeded TRUE --->
		<cfset actionSuceeded = true />
		
		
		<cfquery name="insertFooter" datasource="#application.dsn#">
		INSERT	
		INTO	Footer (isactive,createDate,copyright,adresse,telnummer,e_mail,aktualisierung,mandant)
		VALUES(
				#form.active#,
				#createODBCdatetime(now())#,
				'#form.copyright#',
				'#form.adresse#',
				'#form.telnummer#',
				'#form.e_mail#',
				#form.aktualisierung#,
				#session.mandant#
				)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no"> 
</cfif>

	<!--- GET selected footer   --->
<cfif isdefined("url.editfooter") AND isNumeric(url.editfooter) AND url.editfooter GT 0 >
	<cfquery name="editfooter" datasource="#application.dsn#">
	
		SELECT 	*
		FROM 	footer
		WHERE 	ID = #url.editfooter#
	
	</cfquery>
</cfif>


<!---  5. Footer editieren wenn  Submited edited Footer	--->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedfooter" >
		<cfset actionSuceeded = true />
		
		<cfquery name="updatefooter" datasource="#application.dsn#">
		UPDATE 	footer
		SET		isactive 		= #form.active#,
				modifydate 		= #createODBCdatetime(now())#,
				copyright 		= '#form.copyright#',
				adresse			= '#form.adresse#',
				telnummer		= '#form.telnummer#',
				e_mail			= '#form.e_mail#',
				aktualisierung	= #form.aktualisierung#
		WHERE 	id 				= #form.footr_id#
		</cfquery>
	
	
	<!--- 	Refresh Page  --->
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no"> 	
	
</cfif>

<!---  6. Footer allen Seiten zuweisen --->
<!--- <cfif isdefined("url.action") AND url.action EQ "allocateall">
	<cfset actionSuceeded = true />
	
	<cfquery name="allocateall" datasource="#application.dsn#">
	INSERT 
	INTO		footer2pages
	VALUES		(
				#form.pageID#,
				#FooterID#,			
	
	</cfquery>

</cfif>
 --->

<!--- END SQL statements --->


<!--- initialisieren von Flexylib helptexts --->
<cfset flexyLib = createObject('component','admin.cfc.flexy') />

<!--- liste mit dem Footer darstellen --->

<h2>Footer Management</h2>

<cfoutput>
<br>
<div style="float:left;">#flexyLib.setHelpText(variable='footer_desc_head',type=1,visualType=2)#</div>
<div style="clear:both;"></div>
<br>
</cfoutput>


<!--- hat der User schon einen Footer dann zeige diesen  --->
<cfif getAllFooters.recordcount NEQ 0>

<h4>Halleluja! Ein Footer ist bereits vorhanden!</h4>
<br>  

<!---wenn kein Footer vorhanden:  Add a NEW Footer function --->
<br> 
<cfoutput>
	<div id="newfooter">
		<a href="#cgi.SCRIPT_NAME#?action=addNewFooter" id="addNewFooter"> + neuer Footer erfassen + </a>
	</div>
</cfoutput>



<br><br>
	<table width="100%">
	<tr>
		<td><strong>Copyright</strong></td>
		<td><strong>Status</strong></td>
		<td><strong>Footer bearbeiten ?</strong></td>
		<td><strong>Footer löschen ?</strong></td>
	</tr>
	<!--- gib  alle Footers des Mandanten aus --->
	<cfoutput query="getAllFooters">
	<tr>
		<td>
		  #copyright#
		</td>
		<td>
		<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
			<cfif isactive EQ 1>
			<div id="activ">	aktiv</div>
			<cfelse>
			<div id="inactiv">	inaktiv </div>
			</cfif>
		</td>
		<td>
		<a href="#cgi.SCRIPT_NAME#?editfooter=#id#" >
			Den Footer bearbeiten
		</a>
		</td>
		<td>
			<a href="#cgi.SCRIPT_NAME#?delfooter=#id#" onclick="return confirm('Sind Sie sicher?');">
			Footer löschen
			</a>
		</td>
	</tr>
	</cfoutput>
	</table>



<cfelse>
<!---wenn kein Footer vorhanden:  Add a NEW Footer function --->
<br> <br>
<cfoutput>
	<div id="newfooter">
		<a href="#cgi.SCRIPT_NAME#?action=addNewFooter" id="addNewFooter">neuer Footer erfassen</a>
	</div>
</cfoutput>

</cfif>

<!--- INPUT for NEW footer --->

	<cfif (isdefined("url.action") AND url.action EQ "addNewFooter")  >
		<cfset actionSuceeded = true />
	<cfoutput>
	
	<!---  OR (isdefined("actionSuceeded") AND actionSuceeded EQ false) --->
		<!--- <cfif isdefined("actionSuceeded") AND actionSuceeded EQ false> --->
		<!--- 	ES IST EIN FEHLER AUFGERTEREN --->
		<!--- </cfif> --->
		<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
		<form action="#cgi.SCRIPT_NAME#?action=submittedNewFooter" method="post" enctype="multipart/form-data">
		<table>
		<th>Footer erfassen:</th>
		<tr>
			<td>Status:<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_status',type=1,visualType=1)#</div></td>
			<td>
				<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
				<input type="radio" name="active" value="0"> inaktiv
			</td>
		</tr>
		<tr>
			<td>
				Copyright:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_copyright',type=1,visualType=1)#</div> 
			</td>
			<td>
				<input type="text" name="copyright"  maxlength="50" <cfif isdefined("form.copyright")>value="#form.copyright#"</cfif>>
			</td>
		</tr>
		<tr>
			<td>
				Adresse:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_address',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input type="text" name="adresse"  maxlength="50" >
			</td>
		</tr>
		<tr>
			<td>
				Telnummer:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_Telnummer',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input type="tel" name="telnummer"  maxlength="16" >
			</td>
		</tr>
		<tr>
			<td>
				e-mail:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_email',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input type="email" name="e_mail"  maxlength="30" >
			</td>
		</tr>
		<tr>
			<td>
				Aktualisierung anzeigen:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_actual',type=1,visualType=1)#</div> 
			</td>
			<td> <!--- aus irgeneeinem Grund muss aktualisierung NO = 2 sein und nich 0 ... . --->
			<input  type="radio" name="aktualisierung"  value="1" checked="checked">Ja
			<input  type="radio" name="aktualisierung"  value="2" > Nein
			</td>
		</tr>
		<tr>
			<td>&nbsp;
				
			</td>
			<td>
		 <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"> 	<input type="submit" value="Footer erfassen">
			</td>
		</table>
		</form>
		
	</cfoutput>
	</cfif>

<!--- EDIT Footer form  --->

<!--- abfrage is editfooter  GT 0  --->

<cfif isdefined("url.editfooter") AND isNumeric(url.editfooter) AND url.editfooter GT 0>
	<cfoutput query="editfooter">
	
	<h2>Footer ändern</h2>
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedfooter" method="post" enctype="multipart/form-data"> 
	<table>
	<th colspan="2">aktueller Footer Nummer #id#</th>
		<tr>
			<td>
				Status:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_status',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
			</td>			
		</tr>
		<tr>
			<td>
				Copyright:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_copyright',type=1,visualType=1)#</div> 
			</td>
			<td>
				<input type="text" name="copyright"  maxlength="50" value="#copyright#">
			</td>
			<td>					
		</tr>
		<tr>
			<td>
				Adresse:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_address',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input type="text" name="adresse"  maxlength="50" value="#adresse#">
			</td>
			<td>					
		</tr>
		<tr>
			<td>
				Telnummer:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_Telnummer',type=1,visualType=1)#</div> 
			</td>
			<td>
				<input type="tel" name="telnummer"  maxlength="16" value="#telnummer#">
			</td>
			<td>					
		</tr>
		<tr>
			<td>
				E-Mail adresse:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_email',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input type="email" name="e_mail"  maxlength="40" value="#e_mail#" >
			</td>
			<td>					
		</tr>
		<tr>
			<td>
				Aktualisierung anzeigen:
				<div style="float:right;">#flexyLib.setHelpText(variable='edit_footer_actual',type=1,visualType=1)#</div> 
			</td>
			<td>
			<input  type="radio" name="aktualisierung"  value="1" <cfif aktualisierung EQ 1>checked="checked" </cfif>>  Ja
			<input  type="radio" name="aktualisierung"  value="2" <cfif aktualisierung EQ 2>checked="checked" </cfif>> Nein
			</td>
			<td>					
		</tr>
		<tr>
			<td>
			<input  type="submit" value="Abbrechen" onClick="location.href='#cgi.SCRIPT_NAME#';">
			</td>
			<td>
			<input type="hidden" name="footr_id" value="#id#" />
			<input  type="submit" value="Änderungen speichern">
			</td>
			<td>					
		</tr>
	</table>
	</form>
	
	</cfoutput>

</cfif>


<!--- 

<h3> Dump SQL</h3>
<cfdump var="#getAllFooters#">
<br><br>
--->
<cfif isdefined("url.editfooter") AND url.editfooter GT 0>
 
<!--- <h3> show Dump Editfooter</h3>
<cfdump var="#editfooter#">  --->

</cfif> 