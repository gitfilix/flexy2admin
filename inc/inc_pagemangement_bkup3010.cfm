<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text='
	<link  rel="stylesheet" type="text/css" href="/admin/css/pagemanagement.css"  />
' />

<cfinclude template="prc_pageprocessing.cfm" />

<!--- pageansicht toggeln --->
<script>
	function toggler(){
		if($('#toggler:checked').val()==1){
			x = 1;
		}
		else{
			x = 0;
		}	
		<cfoutput>location.href='#cgi.SCRIPT_NAME#?viewx='+x;</cfoutput>
	}
</script>
<cfif cgi.QUERY_STRING EQ "" OR isdefined("url.viewx") OR isdefined("url.module") OR isdefined("url.lang")>
	<input type="checkbox" name="toggler" value="1" onchange="toggler()" id="toggler" <cfif session.viewpages EQ 1>checked="checked"</cfif> /> Alle offen anzeigen
</cfif>
<!--- ENDE pageansicht toggeln --->


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
<!--- RECHTE UND MASKENFREIGABEN --->
<cfquery name="getMandantenModules" datasource="#application.dsn#">
SELECT 	* 
FROM 	mandantenmodules
WHERE	mandantenID = '#session.mandant#'
</cfquery>
<cfset MandantenModules = "" />
<cfoutput query="getMandantenModules">
	<cfset MandantenModules = listAppend(MandantenModules,moduleid) />
</cfoutput>
<!--- wenn der mandant dieses users das modul headerpanels hat. der wert 4 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,4)>
	<cfset HasHeaderPanels = true />
<cfelse>
	<cfset HasHeaderPanels = false />
</cfif> 
<!--- wenn der mandant dieses users das modul gallerymanagement hat. der wert 6 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,6)>
	<cfset HasGallery = true />
<cfelse>
	<cfset HasGallery = false />
</cfif> 
<!--- wenn der mandant dieses users das modul teasermanagagement hat. der wert 3 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,3)>
	<cfset HasSidebar = true />
<cfelse>
	<cfset HasSidebar = false />
</cfif> 
<!--- wenn der mandant dieses users das modul closed user gfroup hat. der wert 3 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,13)>
	<cfset hasCUG = true />
<cfelse>
	<cfset hasCUG = false />
</cfif> 
<!--- wenn der mandant dieses users das modul NEWS hat. der wert 9 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,9)>
	<cfset hasNews = true />
<cfelse>
	<cfset hasNews = false />
</cfif> 
<!--- wenn der mandant dieses users das modul TEAM hat. der wert 14 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,14)>
	<cfset hasTeam = true />
<cfelse>
	<cfset hasTeam = false />
</cfif> 
<!--- hier können noch spezifische funktionsfreigaben vergeben werden --->
<!--- ENDE RECHTE UND MASKENFREIGABEN --->


<!--- ---------------------------------------------------------------------------------------------------------- --->
<!--- create function of creating pagerow with content --->
<cffunction name="displayPageWithContents" access="public" returntype="string" output="yes">
	<cfargument name="pageId" required="yes" />
	<cfargument name="level" required="yes" />
	
	<cfquery name="getPage" datasource="#application.dsn#">
	SELECT	*
	FROM	pages
	WHERE	id = #arguments.pageid# AND
			mandant = #session.mandant# AND
			lang = '#session.lang#'
	</cfquery>
	
	<cfoutput query="getPage">
	<tr>
		<td style="padding-left:<cfif arguments.level EQ 1>6<cfelseif arguments.level EQ 2>20<cfelseif arguments.level EQ 3>34<cfelseif arguments.level EQ 3>48<cfelseif arguments.level EQ 4>62<cfelseif arguments.level EQ 5>76</cfif>px;"> <cfif arguments.level GT 1>&lfloor;</cfif> #pagetitel#</td>
		<td>
			<cfif isactive EQ 1>
			<div id="activ">aktiv</div>	
			<cfelse>
			 <div id="inactiv">inaktiv</div>	
			</cfif>
		</td>
		<td>
			#template#
		</td>
		<td>
			<cfif rightEdit EQ 1>
			<a href="#cgi.SCRIPT_NAME#?editpage=#id#">
				bearbeiten
			</a>
			</cfif>
		</td>	
		<td>
			<cfif rightDel EQ 1>
			<a href="#cgi.SCRIPT_NAME#?delpage=#id#" onclick="return confirm('Sind Sie sicher?');">
				löschen
			</a>
			</cfif>
		</td>
		<td>
			<cfif rightCopy EQ 1>
			<a href="#cgi.SCRIPT_NAME#?copypage=#id#">
				kopieren
			</a>
			</cfif>
		</td>
		<td>
			<cfquery name="getContentsByChildPageID" datasource="#application.dsn#">
			SELECT	*
			FROM	content
			WHERE	pageid = #id#
			ORDER	BY reihenfolge
			</cfquery>
			<cfif getContentsByChildPageID.recordcount GT 0>
			<a href="javascript:$('##inhalte#id#a').toggle();void(0);">
				Inhalte
			</a>
			</cfif>&nbsp;
			<cfif rightAdd EQ 1>
			<a href="#cgi.SCRIPT_NAME#?action=addContent&pageID=#id#">
				Inhalt +
			</a>
			</cfif>
			
		</td>
	</tr>
	#displayContents(pageid=arguments.pageid,level=level)#
	</cfoutput>
</cffunction>

<cffunction name="displayContents" access="public" returntype="string">
	<cfargument name="pageId" required="yes" />
	<cfargument name="level" required="yes" />
	
	<cfquery name="getContents" datasource="#application.dsn#">
	SELECT	*
	FROM	content
	WHERE	pageid = #arguments.pageid#
	</cfquery>
	
	<cfif getContents.recordcount GT 0>
		<tr >
			<td colspan="7" <cfif session.viewPages EQ 0>style="display:none;"</cfif> <cfoutput>id="inhalte#arguments.pageid#a"</cfoutput>>
				<div style="background-color:#e2e2e2;">
					<table cellspacing="1" cellpadding="0" width="100% " style="background-color:#F3F3F3">
					<colgroup>
					<col width="" />
					<col width="80" />
					<col width="80" />
					<col width="196" />
					</colgroup>
					<cfoutput query="getContents">
						<tr>
							<td style="padding-right:<cfif arguments.level EQ 1>20<cfelseif arguments.level EQ 2>40<cfelseif arguments.level EQ 3>60<cfelseif arguments.level EQ 3>60<cfelseif arguments.level EQ 4>80<cfelseif arguments.level EQ 5>120</cfif>px; text-align:right;">Inhalt: #titel#</td>
							<td>
								<cfif rightEdit EQ 1>
									<a href="#cgi.SCRIPT_NAME#?editcontent=#id#">
										Inhalt bearbeiten
									</a>
								</cfif>
							</td>
							<td>
								<cfif rightDel EQ 1>
									<a href="#cgi.SCRIPT_NAME#?delcontent=#id#" onclick="return confirm('Sind Sie sicher?');">
										Inhalt löschen
									</a>
								</cfif>
							</td>
							<td>
								<cfif rightCopy EQ 1>
									<a href="#cgi.SCRIPT_NAME#?copycontent=#id#">
										kopieren
									</a>
								</cfif>
							</td>
						</tr>
					</cfoutput>
					</table>	
				</div>
			</td>
		</tr>
	</cfif>
	
</cffunction>

<!--- liste mit allen Seiten darstellen mit eingerückten kindern --->
<cfif cgi.QUERY_STRING EQ "" OR isdefined("url.module") OR isdefined("url.viewx") OR isdefined("url.lang")>

<table width="100%" cellpadding="0" cellspacing="0">
<colgroup>
<col width="320" />
<col width="*" />
<col width="*" />
<col width="80" />
<col width="80" />
<col width="80" />
<col width="120" />
</colgroup>
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Template</strong></td>
	<td><strong>Page</strong></td>
	<td><strong>Löschen</strong></td>
	<td><strong>Kopieren</strong></td>
	<td><strong>Inhalte</strong></td>
</tr>
<cfset posType = 0 />
<cfset pageidx = 0 />
<cfoutput query="getAll5Levels" group="pid">
	<!--- umbruch zw. service- und themennav tabelle --->
	<cfif currentrow EQ 1>
		<tr>
			<td colspan="7" style="background-color:silver;">
				<strong>Service-Navigation</strong>
			</td>
		</tr>
	</cfif>
	<cfif pnavpos NEQ posType AND pnavpos EQ 1>
		<tr>
			<td colspan="7" style="background-color:silver;">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="7" style="background-color:silver;">
				<strong>Themen-Navigation</strong>
			</td>
		</tr>
	</cfif>
	<cfif pnavpos NEQ posType AND pnavpos EQ 2>
		<tr>
			<td colspan="7" style="background-color:silver;">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="7" style="background-color:silver;">
				<strong>Footer-Navigation</strong>
			</td>
		</tr>
	</cfif>
	<cfset posType = pnavpos />
	#displayPageWithContents(pageid=pid,level=1)#
	<cfoutput group="paid">
		<cfif anzahlLevels GTE 2>
			<cfif paid NEQ "">
				#displayPageWithContents(pageid=paid,level=2)#
			</cfif>
			<cfoutput group="pbid">
				<cfif anzahlLevels GTE 3>
					<cfif pbid NEQ "">
						#displayPageWithContents(pageid=pbid,level=3)#
					</cfif>
					<cfoutput group="pcid">
						<cfif anzahlLevels GTE 4>
							<cfif pcid NEQ "">
								#displayPageWithContents(pageid=pcid,level=4)#
							</cfif>
							<cfoutput group="pdid">
								<cfif anzahlLevels EQ 5>
									<cfif pdid NEQ "">
										#displayPageWithContents(pageid=pdid,level=5)#
									</cfif>
								</cfif>
							</cfoutput>
						</cfif>
					</cfoutput>
				</cfif>
			</cfoutput>
		</cfif>
	</cfoutput>
</cfoutput>

</table>
<br/>
</cfif>
<!--- dies erscheint nur wenn neue page hinzufügen gewählt wurde --->
<cfoutput>
<cfif isdefined("url.action") AND url.action EQ "addPage">
	<cfinclude template="inc_addPage.cfm" />
<cfelseif NOT isdefined("url.editPage")>
	<a href="#cgi.SCRIPT_NAME#?action=addPage">neue Seite erfassen</a>
</cfif>
</cfoutput>

<!--- dies erscheint nur wenn Seite bearbeiten gewählt wurde --->
<cfif isdefined("url.editPage") AND isNumeric(url.editPage) AND url.editPage GT 0>
	<cfinclude template="inc_editPage.cfm" />
</cfif>
<br><br>
<cfif isdefined("url.action") AND url.action EQ "addContent">
	<cfinclude template="inc_addContent.cfm" />
</cfif>

<cfif isdefined("url.editcontent") AND isNumeric(url.editcontent) AND url.editcontent GT 0>
	<cfinclude template="inc_editContent.cfm" />
</cfif>