<cfif session.admin EQ 1>
	
	<cfquery name="getActivityLog" datasource="#application.dsn#">
	SELECT 	* 
	FROM 	useractivityLog
	ORDER	BY datumZeit DESC
	</cfquery>

	<script>
	function showInputs(x){
		$('#'+x).toggle();	
	}
	</script>
	<table width="100%" style="font-size:11px;">
	<tr>
		<th align="left">Datum / Uhrzeit</th>
		<th align="left">Benutzer (Mandant)</th>
		<th align="left">Modul</th>
		<th align="left">aufgerufene Seite</th>
		<th align="left" colspan="2">Eingaben</th>
	</tr>
	<cfif isdefined("url.showAllActivity")>
		<cfset maxrows = getActivityLog.recordcount />
	<cfelse>
		<cfset maxrows = 50 />
	</cfif>
	<cfoutput query="getActivityLog" startrow="1" maxrows="#maxrows#">
		<tr>
			<cfquery name="getUserDetails" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	user
			WHERE	id = #userID#
			</cfquery>
			<cfquery name="getMandantDetails" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	mandanten
			WHERE	id = #mandant#
			</cfquery>
			<cfquery name="getModuleDetail" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	modules
			WHERE	id = #module#
			</cfquery>
			<td>
				#lsdateFormat(datumZeit,"dd.mm.yyyy")# #timeFormat(datumZeit,"HH:mm")#
			</td>
			<td>
				#getUserDetails.vorname# #getUserDetails.name# (<em>#getMandantDetails.id#</em>)
			</td>
			<td>
				<cfif module EQ 0>
					Login
				<cfelse>
					#getModuleDetail.module#
				</cfif>
			</td>
			<td>
				#replace(urlx,'/admin','')#
			</td>
			
			<td><cfif dumpx NEQ "">
				<a href="javascript:void(0);" onclick="showInputs('inputs#id#');">
					Formulareingaben
				</a> </cfif>
			</td>
			<td><cfif dumpx NEQ "">
				<a href="javascript:void(0);" onclick="showInputs('inputs#id#2');">
					XML
				</a></cfif>
			</td>
			
		</tr>
		<tr>
			<td colspan="100">
				<div id="inputs#id#" style="display:none;">
					<cfif dumpx NEQ "">#dumpx2#</cfif>
				</div>
				<div id="inputs#id#2" style="display:none;">
					<cfif dumpx NEQ "">
						<cfwddx action="wddx2cfml" input="#dumpx#" output="xmlstruct" />
						<cfdump var="#xmlstruct#">
					</cfif>
				</div>
			</td>
		</tr>
	</cfoutput>
	</table>
	<cfif getActivityLog.recordcount GT 50>
		<br/>
		<cfoutput><a href="#cgi.SCRIPT_NAME#?showAllActivity=true">Alle anzeigen</a></cfoutput>
	</cfif>
</cfif>