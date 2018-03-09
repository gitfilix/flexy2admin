	<cfprocessingdirective pageencoding="utf-8" />
	
	<script>
	function rewriteURLShortcut(x){
		var filename = x.replace(/[^a-z0-9]/gi, '-').toLowerCase();	
		y = filename.replace(/\-{2,}/g, '');
		z = y.replace(/\s{2,}/g, '');
		$('#urlshortcut').val(z);
	}
	
	function checkFilename(x){
		$.get('/admin/inc/ajax_checkURLShortcut.cfm?filename='+x,function(data){
			if(data.indexOf('1')>-1){
				alert('Dieser Shortcut existiert bereits. Bitte machen Sie ihn eindeutig');
				$('#urlshortcut').focus();
			}
		});		
	}
	</script>
	
	<cfoutput>
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewPage" method="post" enctype="multipart/form-data">
	</cfoutput>
	<cfset flexyLib = createObject('component','admin.cfc.flexy') />
	<table cellspacing="0" cellpadding="0" width="100%">
	<cfoutput>
	<tr>
		<td colspan="2">
			#flexyLib.setHelpText(variable='addPage',type=1,visualType=2)#
		</td>
	</tr>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<!--- ---------------- Seiten Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_pageTitle' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Titel <div style="float:right;">#flexyLib.setHelpText(variable='addPage_titel',type=1,visualType=1)#</div></td>
		<td><input type="text" name="pagetitel"<cfif isdefined("form.pagetitel")>value="#form.pagetitel#"</cfif> onkeyup="rewriteURLShortcut($(this).val());"></td>
	</tr>
	<cfelse>
		<input type="hidden" name="pagetitel" value="">
	</cfif>
	<!--- ---------------- URLShortcut ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_URLShortcut' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>URL-Shortcut <div style="float:right;">#flexyLib.setHelpText(variable='addPage_urlShortcut',type=2,visualType=1)#</div></td>
		<td><input type="text" name="urlshortcut" style="color:grey;font-style:italic;" id="urlshortcut" <cfif isdefined("form.urlshortcut")>value="#form.urlshortcut#"</cfif> onblur="checkFilename($('##urlshortcut').val());" readonly></td>
	</tr>
	<cfelse>
		<input type="hidden" name="urlshortcut" id="urlshortcut" value="">
	</cfif>
	<cfif hasNavtypes>
	<tr>
		<td>Navigations Position</td>
		<td>
			<cfif hasNavtypeService>
				<input type="radio" name="navPos" value="0" checked="checked"> servicenavigation  &nbsp; &nbsp;
			</cfif>
			<cfif hasNavtypeThemen>
				<input type="radio" name="navPos" value="1"> themennavigation
			</cfif>
			<cfif hasNavtypeFooter>
				<input type="radio" name="navPos" value="2"> footernavigation
			</cfif>
			<cfif NOT hasNavtypeService AND NOT hasNavtypeThemen AND NOT hasNavtypeFooter>
				<input type="hidden" name="navpos" value="0" />
			</cfif>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="navpos" value="0" />
	</cfif>
	<!--- ---------------- Navig. Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_navTitle' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Navigations Titel <div style="float:right;">#flexyLib.setHelpText(variable='addPage_navTitel',type=1,visualType=1)#</div></td>
		<td><input type="text" name="navTitel" <cfif isdefined("form.navTitel")>value="#form.navTitel#"</cfif>></td>
	</tr>
	<cfelse>
		<input type="hidden" name="navTitel" value="">
	</cfif>
	<!--- ---------------- Meta Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_metaTitle' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Meta Titel <div style="float:right;">#flexyLib.setHelpText(variable='addPage_metaTitel',type=2,visualType=1)#</div></td>
		<td><input type="text" name="metaTitel" <cfif isdefined("form.metaTitel")>value="#form.metaTitel#"</cfif>></td>
	</tr>
	<cfelse>
		<input type="hidden" name="metaTitel" value="">
	</cfif>
	<!--- ---------------- Meta Keywords ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_metaKeys' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Meta Keywords <div style="float:right;">#flexyLib.setHelpText(variable='addPage_metaKeys',type=1,visualType=1)#</div></td>
		<td><input type="text" name="metaKeys"  <cfif isdefined("form.metaKeys")>value="#form.metaKeys#"</cfif>></td>
	</tr>
	<cfelse>
		<input type="hidden" name="metaKeys" value="">
	</cfif>
	<!--- ---------------- Meta Description ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_metaDesc' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Meta Description <div style="float:right;">#flexyLib.setHelpText(variable='addPage_metaDesc',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="metaDesc" rows="1" cols="1" style="height:50px;"><cfif isdefined("form.metaDesc")>#form.metaDesc#</cfif></textarea>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="metaDesc" value="">
	</cfif>
	<!--- ---------------- Navig Reihenfolge ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_navOrder' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Reihenfolge <div style="float:right;">#flexyLib.setHelpText(variable='addPage_reihenfolge',type=3,visualType=1)#</div></td>
		<td><input type="text" name="reihenfolge" <cfif isdefined("form.order")>value="#form.order#"</cfif>></td>
	</tr>
	<cfelse>
		<input type="hidden" name="reihenfolge">
	</cfif>
	</cfoutput>
	<!--- ---------------- Trägerseite ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_parentID' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
		<tr>
			<td>Trägerseite</td>
			<td>
				<!--- <select name="parentID">
					<option value="0">Oberste Ebene</option>
					
						<cfoutput><cfloop query="getRootPages">
							<option value="#ID#">#Pagetitel#</option>
						</cfloop></cfoutput>
					
				</select><br /> --->
				<!--- Test mit 4 Levels von max 5 --->
			
				<select name="parentID">
					<option value="0">Oberste Ebene</option>	
					<cfoutput query="getAll4Levels" group="pid">
						<cfif anzahlLevels GTE 2>
							<option value="#pID#"><cfif pPagetitel NEQ "">#pPagetitel#<cfelse>#Pid# [kein Titel]</cfif></option>
							<cfoutput group="paid">
								<cfif anzahlLevels GTE 3>
									<cfif paid NEQ "">
										<option value="#paID#"><cfif paPagetitel NEQ "">#paPagetitel#<cfelse>#Paid# [kein Titel]</cfif></option>
									</cfif>
									<cfoutput group="pbid">
										<cfif anzahlLevels GTE 4>
											<cfif pbid NEQ "">
												<option value="#pbID#"><cfif pbPagetitel NEQ "">#pbPagetitel#<cfelse>#Pbid# [kein Titel]</cfif></option>
											</cfif>
											<cfoutput group="pcid">
												<cfif anzahlLevels EQ 5>
													<cfif pcid NEQ "">
														<option value="#pcID#"><cfif pcPagetitel NEQ "">#pcPagetitel#<cfelse>#Pcid# [kein Titel]</cfif></option>									
													</cfif>
												</cfif>
											</cfoutput>	
										</cfif>
									</cfoutput>
								</cfif>
							</cfoutput>
						</cfif>
					</cfoutput>	
				</select>
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="parentID" value="0">
	</cfif>
	<cfoutput>
	<!--- ---------------- Headerbild ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_headerBild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfquery name="mandantenfeldbildsizes" datasource="#application.dsn#">
	SELECT 	resizevalue_width 
	FROM 	feldbildsize
	WHERE	fieldName = 'editPage_headerBild' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Headerbild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px)</td>
		<td>
			<input type="file" name="headerbild">
			<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="headerbild" value="">
		<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
	</cfif>
	<!--- ---------------- Templates ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_template' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasMultiTemplates AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Template</td>
		<td>
			<cfif hasMultiTemplate1>
			<input type="radio" name="template" value="1" checked="checked"> Template 1  &nbsp; &nbsp;
			</cfif>
			<cfif hasMultiTemplate2>
			<input type="radio" name="template" value="2"> Template 2 &nbsp;&nbsp;
			</cfif>
			<cfif hasMultiTemplate3>
			<input type="radio" name="template" value="3"> Template 3 &nbsp; &nbsp;
			</cfif>
			<cfif NOT hasMultiTemplate1 AND NOT hasMultiTemplate2 AND NOT hasMultiTemplate3>
				<input type="hidden" name="template" value="1" />
			</cfif>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="template" value="1" />
	</cfif>
	<!--- ---------------- Farb-Schemen ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'addPage_templatecolorschema' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasColorSchema AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Template Farbschmema</td>
		<td>
			<input type="radio" name="templatecolor" value="1" checked="checked"> Farbschema rot  &nbsp; &nbsp;
			<input type="radio" name="templatecolor" value="2"> Farbschema blau &nbsp;&nbsp;
			<input type="radio" name="templatecolor" value="3"> Farbschmema grün &nbsp; &nbsp;
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="templatecolor" value="1" />
	</cfif>
	<cfif HasSidebar>
	<tr>
		<td valign="top">Sidebar Elemente</td>
		<td>
			<cfquery name="getSidebars" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar
			WHERE	mandant = #session.mandant# AND
					isActive = 1 AND
					teaserposition = 1
			</cfquery>
			<table width="100%" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<th align="left">
						Select
					</th>
					<th align="left">
						Titel
					</th>
					<th align="left">
						Order
					</th>
				</tr>
			</thead>
			<tbody>
			<cfset counter = 1 />
			<cfloop query="getSidebars">
			<tr>
				<td width="40">
					<input type="checkbox" name="sidebar#counter#" value="#id#" />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="order#counter#" style="width:40px;" />
				</td>
			</tr>
			<cfset counter = counter + 1 />
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="order1" value="" />
	</cfif>
	<cfif HasTeasers>
	<tr>
		<td valign="top">Teaser Elemente unten</td>
		<td>
			<cfquery name="getSidebars" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar
			WHERE	mandant = #session.mandant# AND
					isActive = 1 AND
					teaserposition = 2
			</cfquery>
			<table width="100%" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<th align="left">
						Select
					</th>
					<th align="left">
						Titel
					</th>
					<th align="left">
						Order
					</th>
				</tr>
			</thead>
			<tbody>
			<cfset counter = 1 />
			<cfloop query="getSidebars">
			<tr>
				<td width="40">
					<input type="checkbox" name="teaser#counter#" value="#id#" />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="reihenfolge#counter#" style="width:40px;" />
				</td>
			</tr>
			<cfset counter = counter + 1 />
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="reihenfolge1" value="" />
	</cfif>
	<cfif HasHeaderPanels>
	<tr>
		<td valign="top">Headerpanels</td>
		<td>
			<cfquery name="getHeaderpanels" datasource="#application.dsn#">
			SELECT 	*
			FROM	headerpanels
			WHERE	mandant = #session.mandant# AND
					isActive = 1
			</cfquery>
			<table width="100%" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<th align="left">
						Select
					</th>
					<th align="left">
						Titel
					</th>
					<th align="left">
						Order
					</th>
				</tr>
			</thead>
			<tbody>
			<cfset counter = 1 />
			<cfloop query="getHeaderpanels">
			<tr>
				<td width="40">
					<input type="checkbox" name="headerpanel#counter#" value="#id#" />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="sort#counter#" style="width:40px;" />
				</td>
			</tr>
			<cfset counter = counter + 1 />
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="sort1" value="" />
	</cfif>
	<cfif hasCUG>
	<!--- <tr>
		<td valign="top">Closed User Group</td>
		<td>
			<cfquery name="getUserGroups" datasource="#application.dsn#">
			SELECT 	*
			FROM	cugGroups
			WHERE	mandant = #session.mandant# AND
					groupStatus = 1
			</cfquery>
			<table width="100%" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<th align="left">
						Select
					</th>
					<th align="left">
						Benutzergruppe
					</th>
				</tr>
			</thead>
			<tbody>
			<cfloop query="getUserGroups">
				<tr>
					<td width="40">
						<input type="checkbox" name="cuggroups" value="#id#" />
					</td>
					<td>
						#groupName#
					</td>
				</tr>
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr> --->
	
	<input type="hidden" name="cuggroups" value="" />
	</cfif>
	<cfif hasNews>
	<tr>
		<td>
			News publizieren? 
		</td>
		<td>
			<input type="radio" name="showAllNews" value="1"> Ja 
			<input type="radio" name="showAllNews" value="0" checked ="checked"> Nein 
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="showAllNews" value="0">
	</cfif>
	<cfif hasTeam>
	<tr>
		<td>
			Team publizieren?  <div style="float:right;">#flexyLib.setHelpText(variable='addPage_team',type=1,visualType=1)#</div>
		</td>
		<td>
			<input type="radio" name="showTeam" value="1"> Ja 
			<input type="radio" name="showTeam" value="0" checked="checked"> Nein 
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="showTeam" value="0">
	</cfif>
	<tr>
		<td></td>
		<td><input type="submit" value="Seite erfassen"> <input type="button" value="abbrechen" onClick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form></cfoutput>
