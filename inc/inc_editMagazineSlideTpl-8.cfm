<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getSlideBackgroundImage" datasource="#application.dsn#">
SELECT bgimage FROM magazinSlides
WHERE id = #url.editMagazinSlide# 
</cfquery>

<cfquery name="getIssueID" datasource="#application.dsn#">
SELECT 	K.magazinAusgabeID
FROM 	magazinSlides S LEFT JOIN
		magazinKapitel K ON K.id = S.parent
WHERE 	S.id = #url.editMagazinSlide#
</cfquery>

<cfquery name="getAllSlidesFromIssue" datasource="#application.dsn#">
SELECT 	S.*
FROM 	magazinSlides S LEFT JOIN
		magazinKapitel K ON K.id = S.parent
WHERE 	K.magazinAusgabeID = #getIssueID.magazinAusgabeID# AND
		S.template = 7
GROUP	BY S.id
ORDER	BY S.id
</cfquery>

<cfquery name="getSlideContent" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_8
WHERE slideid = #url.editMagazinSlide#
</cfquery>

<cfoutput>
	<table width="100%">
	<tr>
		<td>
			Layout
		</td>
		<td>
			<select name="setting_layout">
				<option value="0" <cfif getSlideContent.setting_layout EQ 0>selected</cfif>>Artilel-Übersicht, swiper rechts</option>
				<option value="1"<cfif getSlideContent.setting_layout EQ 1>selected</cfif>>Artilel-Übersicht, swiper links</option>
				<option value="2"<cfif getSlideContent.setting_layout EQ 2>selected</cfif>>Artilel-Übersicht2, swiper rechts</option>
				<option value="3"<cfif getSlideContent.setting_layout EQ 3>selected</cfif>>1 Hauptartikel, Artikel-Swiper</option>
				<option value="4"<cfif getSlideContent.setting_layout EQ 4>selected</cfif>>1 Ressort, Artikel-Swiper</option>
				<option value="5"<cfif getSlideContent.setting_layout EQ 5>selected</cfif>>Vollbild, Artikel-Teaser Overlay</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			Artikel
		</td>
		<td>
			<cfloop query="getAllSlidesFromIssue">
				<cfquery name="getSlideContent2" datasource="#application.dsn#">
				SELECT * FROM articles2slides
				WHERE slideid = #url.editMagazinSlide# AND otherslideID = #id#
				</cfquery>
				<input type="checkbox" name="article" value="#id#" <cfif getSlideContent2.recordcount GTE 1>checked</cfif> /> #label#<br/>
			</cfloop>
		</td>
	</tr>
	</table>
</cfoutput>