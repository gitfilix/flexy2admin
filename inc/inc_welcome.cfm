<cfprocessingdirective pageencoding="utf-8" />
<cfif session.admin EQ 1>

	<script>
	function wartung(id){
		if($('#'+id).prop('checked')==true){
			$.get('/admin/inc/ajax_toggleMaintainance.cfm',{state:1},function(data){
				alert('Wartungsmodus eingeschaltet');
			});
		}
		else{
			$.get('/admin/inc/ajax_toggleMaintainance.cfm',{state:0},function(data){
				alert('Wartungsmodus ausgeschaltet');
			});
		}	
	}
	</script>
	<table width="100%">
	<tr>
		<th align="left">Benutzer (Mandant)</th>
		<th align="left">Modul</th>
		<th align="left">Gerade aufgerufene Seite</th>
		<th align="left">letzte Aktivität</th>
	</tr>
	<cfoutput query="getLoggedInUsers">
		<tr>
			<cfquery name="getLoggedInUserDetails" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	user
			WHERE	id = #userID#
			</cfquery>
			<cfquery name="getLoggedInMandantDetails" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	mandanten
			WHERE	id = #getLoggedInUserDetails.mandant#
			</cfquery>
			<cfquery name="getLastActivity" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	useractivityLog
			WHERE	userid = #userID#
			ORDER	BY datumZeit DESC
			</cfquery>
			<td>
				#getLoggedInUserDetails.vorname# #getLoggedInUserDetails.name# <br/>(<em>#getLoggedInMandantDetails.directoryname#</em>)
			</td>
			<td>
				#replace(module,'inc_','')#
			</td>
			<td>
				#replace(page,'/admin','')#
			</td>
			<td>
				<cfif getLastActivity.recordcount NEQ 0>vor #dateDiff('n',getLastActivity.datumZeit,now())# Minuten</cfif>
			</td>
		</tr>
	</cfoutput>
	</table>
	<br/>
	Wartungsmodus: <input type="checkbox" name="wartung" id="wartung" value="1" onchange="wartung('wartung');" <cfif wartungsCheck.maintainance EQ 1>checked="checked"</cfif> />
</cfif>