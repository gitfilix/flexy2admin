<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="wartungsCheck" datasource="#application.dsn#">
SELECT * FROM maintainance
WHERE id = 1
</cfquery>
<cfif wartungsCheck.maintainance EQ 1>
	Die Seite wird geradse gewartet. Wir empfehlen einen raschen Abschluss Ihrer Arbeiten und ein schnelles Abmelden am System. <br/>
	Wir werden Sie informieren ab wann der Zugang zum System wieder geöffnet ist.<br/><br/>
	Wir entschuldigen den Umstand und danken für Ihr Verständnis.<br/>
	Das Entwickler-Team
</cfif>