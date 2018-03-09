<cfprocessingdirective pageencoding="utf-8" />

<!--- Test mit 4 Levels von max 5 --->
<cfsavecontent variable="parentCode">

	<!--- get all ids underneath a specific pageid for exclusion as a parentID (recurse error) --->	
	<!--- first get level of current pageid --->
	<cfset navcfc = createObject("component","admin.cfc.nav") />
	<cfset getNavTree = navcfc.navtree(id=url.editpage) />
	<cfset level = listLen(getNavTree) />
	<cfset idlist = "" />
	<cfif level EQ 4>
		<cfquery name="get5thLevel" datasource="#application.dsn#">
		SELECT	P.id
		FROM	pages P
		WHERE 	P.parentid = #url.editpage#
		</cfquery>
		<cfoutput query="get5thLevel">
			<cfset idlist = listAppend(idlist,id) />	
		</cfoutput>
	<cfelseif level EQ 3>
		<cfquery name="get4thLevel" datasource="#application.dsn#">
		SELECT	P.id
		FROM	pages P
		WHERE 	P.parentid = #url.editpage#
		</cfquery>
		<cfoutput query="get4thLevel">
			<cfset idlist = listAppend(idlist,id) />	
			<cfquery name="get5thLevel" datasource="#application.dsn#">
			SELECT	P.id
			FROM	pages P
			WHERE 	P.parentid = #id#
			</cfquery>
			<cfloop query="get4thLevel">
				<cfset idlist = listAppend(idlist,id) />	
			</cfloop>
		</cfoutput>
	<cfelseif level EQ 2>
		<cfquery name="get3thLevel" datasource="#application.dsn#">
		SELECT	P.id
		FROM	pages P
		WHERE 	P.parentid = #url.editpage#
		</cfquery>
		<cfoutput query="get3thLevel">
			<cfset idlist = listAppend(idlist,id) />	
			<cfquery name="get4thLevel" datasource="#application.dsn#">
			SELECT	P.id
			FROM	pages P
			WHERE 	P.parentid = #id#
			</cfquery>
			<cfloop query="get4thLevel">
				<cfset idlist = listAppend(idlist,id) />	
				<cfquery name="get5thLevel" datasource="#application.dsn#">
				SELECT	P.id
				FROM	pages P
				WHERE 	P.parentid = #id#
				</cfquery>
				<cfloop query="get5thLevel">
					<cfset idlist = listAppend(idlist,id) />	
				</cfloop>
			</cfloop>
		</cfoutput>
	<cfelseif level EQ 1>
		<cfquery name="get2ndLevel" datasource="#application.dsn#">
		SELECT	P.id
		FROM	pages P
		WHERE 	P.parentid = #url.editpage#
		</cfquery>
		<cfoutput query="get2ndLevel">
			<cfset idlist = listAppend(idlist,id) />	
			<cfquery name="get3thLevel" datasource="#application.dsn#">
			SELECT	P.id
			FROM	pages P
			WHERE 	P.parentid = #url.editpage#
			</cfquery>
			<cfloop query="get3thLevel">
				<cfset idlist = listAppend(idlist,id) />	
				<cfquery name="get4thLevel" datasource="#application.dsn#">
				SELECT	P.id
				FROM	pages P
				WHERE 	P.parentid = #id#
				</cfquery>
				<cfloop query="get4thLevel">
					<cfset idlist = listAppend(idlist,id) />	
					<cfquery name="get5thLevel" datasource="#application.dsn#">
					SELECT	P.id
					FROM	pages P
					WHERE 	P.parentid = #id#
					</cfquery>
					<cfloop query="get5thLevel">
						<cfset idlist = listAppend(idlist,id) />	
					</cfloop>
				</cfloop>
			</cfloop>
		</cfoutput>
	</cfif>
		
	

	<select name="parentID">
		<option value="0">Oberste Ebene</option>	
		<cfoutput query="getAll4Levels" group="pid">
			<cfif anzahlLevels GTE 2>
				<cfif not ListFind(idlist,pid) AND pid NEQ url.editpage>
					<option value="#pID#" <cfif pID EQ editPage.parentID>selected="selected"</cfif>><cfif pPagetitel NEQ "">#pPagetitel#<cfelse>#Pid# [kein Titel]</cfif></option>
				</cfif>
				<cfoutput group="paid">
					<cfif anzahlLevels GTE 3>
						<cfif paid NEQ "" AND not ListFind(idlist,paid) AND paid NEQ url.editpage>
							<option value="#paID#" <cfif paID EQ editPage.parentID>selected="selected"</cfif>><cfif paPagetitel NEQ "">#paPagetitel#<cfelse>#Paid# [kein Titel]</cfif></option>
						</cfif>
						<cfoutput group="pbid">
							<cfif anzahlLevels GTE 4>
								<cfif pbid NEQ "" AND not ListFind(idlist,pbid) AND pbid NEQ url.editpage>
									<option value="#pbID#" <cfif pbID EQ editPage.parentID>selected="selected"</cfif>><cfif pbPagetitel NEQ "">#pbPagetitel#<cfelse>#Pbid# [kein Titel]</cfif></option>
								</cfif>
								<cfoutput group="pcid">
									<cfif anzahlLevels EQ 5>
										<cfif pcid NEQ "" AND not ListFind(idlist,pcid) AND pcid NEQ url.editpage>
											<option value="#pcID#" <cfif pcID EQ editPage.parentID>selected="selected"</cfif>><cfif pcPagetitel NEQ "">#pcPagetitel#<cfelse>#Pcid# [kein Titel]</cfif></option>									
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
</cfsavecontent>

<cfset flexyLib = createObject('component','admin.cfc.flexy') />

<script>
function rewriteURLShortcut(x){
	var filename = x.replace(/[^a-z0-9]/gi, '-').toLowerCase();	
	y = filename.replace(/\-{2,}/g, '');
	z = y.replace(/\s{2,}/g, '');
	$('#urlshortcut').val(z);
}
function infoURL(){
	alert(1);	
}
</script>

<cfoutput query="editPage">
	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedPage" method="post" enctype="multipart/form-data">
	<table width="100%">
	<!--- <tr>
		<td colspan="2">
			#flexyLib.setHelpText(catID=1,catType=1)#
		</td>
	</tr> --->
	<tr>
		<td>
			Last Update
		</td>
		<td>
			<cfquery name="getUpdateUser" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	user
			WHERE 	id = #parentuser#
			</cfquery>
		
			by #getUpdateUser.vorname# #getUpdateUser.name#, #lsdateFormat(modifydate,'DDDD, dd.mm.yyyy')# - #timeformat(modifydate,'HH:mm')#
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td>Status <div style="float:right;">#flexyLib.setHelpText(variable='editPage_status',type=3,visualType=1)#</div></td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<!--- ---------------- Seiten Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_pageTitle' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Titel <div style="float:right;">#flexyLib.setHelpText(variable='editPage_titel',type=1,visualType=1)#</div></td>
		<td><input type="text" name="pagetitel" value="#pagetitel#"></td>
	</tr>
	<cfelse>
		<input type="hidden" name="pagetitel" value="#pagetitel#">
	</cfif>
	<!--- ---------------- URLShortcut ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_URLShortcut' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>URL-Shortcut <div style="float:right;">#flexyLib.setHelpText(variable='editPage_urlShortcut',type=2,visualType=1)#</div></td>
		<td><input type="text" name="urlshortcut" id="urlshortcut" <cfif urlshortcut NEQ "">value="#urlshortcut#"</cfif> readonly></td>
	</tr>
	<cfelse>
		<input type="hidden" name="urlshortcut" id="urlshortcut" <cfif urlshortcut NEQ "">value="#urlshortcut#"</cfif>>
	</cfif>
	<cfif hasNavtypes>
	<tr>
		<td>Navigations Position <div style="float:right;">#flexyLib.setHelpText(variable='editPage_navpos',type=1,visualType=1)#</div></td>
		<td>
			
			<cfif hasNavtypeService>
				<input type="radio" name="navPos" value="0" <cfif navpos EQ 0>checked="checked"</cfif>> servicenavigation  &nbsp; &nbsp;
			</cfif>
			<cfif hasNavtypeThemen>
				<input type="radio" name="navPos" value="1" <cfif navpos EQ 1>checked="checked"</cfif>> themennavigation
			</cfif>
			<cfif hasNavtypeFooter>
				<input type="radio" name="navPos" value="2" <cfif navpos EQ 2>checked="checked"</cfif>> footernavigation
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
	WHERE	fieldName = 'editPage_navTitle' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Navigations Titel <div style="float:right;">#flexyLib.setHelpText(variable='editPage_navTitel',type=1,visualType=1)#</div></td>
		<td><input type="text" name="navTitel" value="#navTitel#"></td>
	</tr>
	<cfelse>
		<input type="hidden" name="navTitel" value="#navTitel#">
	</cfif>
	<!--- ---------------- Meta Titel ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_metaTitle' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Meta Titel <div style="float:right;">#flexyLib.setHelpText(variable='editPage_metaTitel',type=2,visualType=1)#</div></td>
		<td><input type="text" name="metaTitel" value="#metaTitel#"></td>
	</tr>
	<cfelse>
		<input type="hidden" name="metaTitel" value="#metaTitel#">
	</cfif>
	<!--- ---------------- Meta Keywords ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_metaKeys' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Meta Keywords <div style="float:right;">#flexyLib.setHelpText(variable='editPage_metaKeys',type=1,visualType=1)#</div></td>
		<td><input type="text" name="metaKeys" value="#metaKeys#"></td>
	</tr>
	<cfelse>
		<input type="hidden" name="metaKeys" value="#metaKeys#">
	</cfif>
	<!--- ---------------- Meta Description ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_metaDesc' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Meta Description <div style="float:right;">#flexyLib.setHelpText(variable='editPage_metaDesc',type=1,visualType=1)#</div></td>
		<td>
			<textarea name="metaDesc" rows="1" cols="1" style="height:50px;">#metaDesc#</textarea>
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="metaDesc" value="#metaDesc#">
	</cfif>
	<!--- ---------------- Navig Reihenfolge ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_navOrder' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Reihenfolge <div style="float:right;">#flexyLib.setHelpText(variable='editPage_reihenfolge',type=3,visualType=1)#</div></td>
		<td><input type="text" name="reihenfolge" value="#navorder#"></td>
	</tr>
	<cfelse>
		<input type="hidden" name="reihenfolge" value="#navorder#">
	</cfif>
	<!--- ---------------- Trägerseite ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_parentID' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Trägerseite <div style="float:right;">#flexyLib.setHelpText(variable='editPage_parentPage',type=3,visualType=1)#</div></td>
		<td>
			<!--- <cfset t = parentid />
			<select name="parentID2">
				<option value="0" <cfif t EQ 0>selected="selected"</cfif>>Oberste Ebene</option>
				<cfloop query="getRootPages">
					<cfif id NEQ editPage.id>
						<option value="#ID#"<cfif t EQ id>selected="selected"</cfif>>#Pagetitel#</option>
					</cfif>
				</cfloop>
			</select><br/>
			<br/> --->
			#parentCode#
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="parentID" value="#parentID#">
	</cfif>
	<!--- ---------------- Headerbild ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_headerBild' AND
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
		<td>Headerbild (Resize auf #mandantenfeldbildsizes.resizevalue_width#px) <div style="float:right;">#flexyLib.setHelpText(variable='editPage_headerBild',type=1,visualType=1)#</div></td>
		<td>
			<cfif headerbild NEQ "">
			Momentanes Headerbild auf dem Server2: <a href="<cfif session.mandantURL NEQ "">http://www.#session.mandantURL#/<cfelse>/</cfif><cfif session.serverpath NEQ "">#session.serverpath#/</cfif>upload/img/#headerbild#" target="_blank">#headerbild#</a><!--- <a href="/#session.serverpath#/upload/img/#headerbild#" target="_blank">#headerbild#</a> ---><br/>
			<input type="checkbox" name="delimage" value="#headerbild#" /> Bild löschen<br/>
			</cfif>
			<input type="file" name="headerbild"> 
			<input type="hidden" name="origbild" value="#headerbild#" />
			<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="headerbild" value="">
		<input type="hidden" name="origbild" value="#headerbild#" />
		<input type="hidden" name="resizebild" value="#mandantenfeldbildsizes.resizevalue_width#" />
	</cfif>
	<!--- ---------------- Templates ---------------- --->
	<cfquery name="mandantenfeldfreigaben" dbtype="query">
	SELECT 	* 
	FROM 	feldfreigaben
	WHERE	fieldName = 'editPage_template' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasMultiTemplates AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Template <div style="float:right;">#flexyLib.setHelpText(variable='editPage_template',type=1,visualType=1)#</div></td>
		<td>
			<cfif hasMultiTemplate1>
			<input type="radio" name="template" value="1" <cfif template EQ 1>checked="checked"</cfif>> Template 1  &nbsp; &nbsp;
			</cfif>
			<cfif hasMultiTemplate2>
			<input type="radio" name="template" value="2" <cfif template EQ 2>checked="checked"</cfif>> Template 2 &nbsp;&nbsp;
			</cfif>
			<cfif hasMultiTemplate3>
			<input type="radio" name="template" value="3" <cfif template EQ 3>checked="checked"</cfif>> Template 3 &nbsp; &nbsp;
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
	WHERE	fieldName = 'editPage_templatecolorschema' AND
			mandant = #session.mandant#
	</cfquery>
	<cfif hasColorSchema AND mandantenfeldfreigaben.recordcount EQ 1 AND mandantenfeldfreigaben.fieldState EQ 1>
	<tr>
		<td>Template Farbschmema <div style="float:right;">#flexyLib.setHelpText(variable='editPage_colorScheme',type=1,visualType=1)#</div></td>
		<td>
			<input type="radio" name="templatecolor" value="1" <cfif templatecolorschema EQ 1>checked="checked"</cfif>> Farbschema rot  &nbsp; &nbsp;
			<input type="radio" name="templatecolor" value="2" <cfif templatecolorschema EQ 2>checked="checked"</cfif>> Farbschema blau &nbsp;&nbsp;
			<input type="radio" name="templatecolor" value="3" <cfif templatecolorschema EQ 3>checked="checked"</cfif>> Farbschmema grün &nbsp; &nbsp;
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="templatecolor" value="1" />
	</cfif>
	<cfif HasSidebar>
	<tr>
		<td valign="top">Sidebar Elemente <div style="float:right;">#flexyLib.setHelpText(variable='editPage_sidebar',type=1,visualType=1)#</div></td>
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
			<cfquery name="getSidebarPerPage" datasource="#application.dsn#">
			SELECT 	*
			FROM	sidebar2pages
			WHERE	pageid = #url.editpage# AND 
					sidebarID = #id#
			</cfquery>
			<tr>
				<td width="40">
					<input type="checkbox" name="sidebar#counter#" value="#id#" <cfif getSidebarPerPage.recordcount EQ 1>checked="checked"</cfif> />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="order#counter#" style="width:40px;" <cfif getSidebarPerPage.recordcount EQ 1>value="#getSidebarPerPage.reihenfolge#"</cfif> />
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
		<td valign="top">Teaser Elemente unten <div style="float:right;">#flexyLib.setHelpText(variable='editPage_teaser',type=1,visualType=1)#</div></td>
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
			<cfquery name="getSidebarPerPage" datasource="#application.dsn#">
			SELECT 	*
			FROM	teaser2pages
			WHERE	pageid = #url.editpage# AND 
					sidebarID = #id#
			</cfquery>
			<tr>
				<td width="40">
					<input type="checkbox" name="teaser#counter#" value="#id#" <cfif getSidebarPerPage.recordcount EQ 1>checked="checked"</cfif> />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="reihenfolge#counter#" style="width:40px;" <cfif getSidebarPerPage.recordcount EQ 1>value="#getSidebarPerPage.reihenfolge#"</cfif> />
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
		<td valign="top">Headerpanels <div style="float:right;">#flexyLib.setHelpText(variable='editPage_headerpanels',type=1,visualType=1)#</div></td>
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
			<cfquery name="getHeaderpanelsPerPage" datasource="#application.dsn#">
			SELECT 	*
			FROM	headerpanels2pages
			WHERE	pageid = #url.editpage# AND 
					headerpanelid = #id#
			</cfquery>
			<tr>
				<td width="40">
					<input type="checkbox" name="headerpanel#counter#" value="#id#" <cfif getHeaderpanelsPerPage.recordcount EQ 1>checked="checked"</cfif> />
				</td>
				<td>
					#titel#
				</td>
				<td align="right" style="width:40px;">
					<input type="text" name="sort#counter#" style="width:40px;" <cfif getHeaderpanelsPerPage.recordcount EQ 1>value="#getHeaderpanelsPerPage.reihenfolge#"</cfif> />
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
	<cfif hasCUG AND parentid EQ 0>
	<tr>
		<td valign="top">Closed User Group <div style="float:right;">#flexyLib.setHelpText(variable='editPage_cug',type=1,visualType=1)#</div></td>
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
				<cfquery name="getUserGroupsPerPage" datasource="#application.dsn#">
				SELECT 	*
				FROM	usergroups2pages
				WHERE	pageid = #url.editpage# AND 
						usergroupID = #id#
				</cfquery>
				<tr>
					<td width="40">
						<input type="checkbox" name="cuggroups" value="#id#" <cfif getUserGroupsPerPage.recordcount EQ 1>checked="checked"</cfif> />
					</td>
					<td>
						#groupName#
					</td>
				</tr>
			</cfloop>
			</tbody>
			</table>
		</td>
	</tr>
	</cfif>
	<cfif hasNews>
	<tr>
		<td>
			News publizieren?  <div style="float:right;">#flexyLib.setHelpText(variable='editPage_news',type=1,visualType=1)#</div>
		</td>
		<td>
			<input type="radio" name="showAllNews" value="1" <cfif showAllNews EQ 1 >checked="checked"</cfif>> Ja 
			<input type="radio" name="showAllNews" value="0" <cfif showAllNews EQ 0 >checked="checked"</cfif>> Nein 
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="showAllNews" value="0">
	</cfif>
	<cfif hasTeam>
	<tr>
		<td>
			Team publizieren?  <div style="float:right;">#flexyLib.setHelpText(variable='editPage_team',type=1,visualType=1)#</div>
		</td>
		<td>
			<input type="radio" name="showTeam" value="1" <cfif showTeam EQ 1 >checked="checked"</cfif>> Ja 
			<input type="radio" name="showTeam" value="0" <cfif showTeam EQ 0 >checked="checked"</cfif>> Nein 
		</td>
	</tr>
	<cfelse>
		<input type="hidden" name="showTeam" value="0">
	</cfif>
	<tr>
		<td><input type="hidden" name="pageID" value="#url.editpage#"></td>
		<td><input type="submit" value="Seite ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';" ></td>
	</tr>
	</table>
	</form>
</cfoutput>