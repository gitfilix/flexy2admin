<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getOnlineAdmins" datasource="#application.dsn#">
SELECT 	*
FROM	userloggedin
WHERE	userid = 17
</cfquery>

<!--- show chat --->
<cfif getOnlineAdmins.recordcount GT 0>

	<cfinclude template="/admin/inc/chat/index2.cfm" />

<!--- show support form --->
<cfelse>

	<form>
		<input type="text" name="frage" />
	</form>

</cfif>