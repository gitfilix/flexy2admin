<cfprocessingdirective pageencoding="utf-8" />


<!--- read the data of template 4 for this slide --->
<cfquery name="getslideTpl4" datasource="#application.dsn#">
	SELECT *
	FROM magazinslidetpl_4
	WHERE slideID = #url.editMagazinSlide#
</cfquery>

<cfoutput query="getslideTpl4">
	<table width="100%">
	<tr>
		<td>
			Template- Layout
		</td>
		<td>
			<img src="../../img/template4.png" width="150" />
		</td>
	</tr>
	<tr>
		<td>
			Slide Titel:
		</td>
		<td>
			<input type="text" name="titel" id="titel" value="#titel#" />
		</td>
	</tr>
	<tr>
		<td>
			Infobox 1 Titel
		</td>
		<td>
			<input type="text" name="infobox_1_title" id="infobox_1_title" value="#infobox_1_title#" />
		</td>
	</tr> 
	<tr>
		<td>
			Infobox 1 Bild:
		</td>
		<td>
			<input type="file" name="infobox_1_img" id="infobox_1_img"  />
			<input type="hidden" name="orig_infobox_1_img" id="infobox_1_img" value="#infobox_1_img#" />
			<cfif infobox_1_img NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#infobox_1_img#')>
				<img src="/#session.serverpath#/upload/magazine/#infobox_1_img#" width="200" />
			</cfif> 
		</td>
	</tr>
	<tr>
		<td>
			Infobox Front-Text:
		</td>
		<td>
			<input type="text" name="infobox_1_fronttext" id="infobox_1_fronttext" value="#infobox_1_fronttext#" />
		</td>
	</tr>
	<tr>
		<td>
			Infobox Flip-Back-Titel:
		</td>
		<td>
			<input type="text" name="infobox_1_backtitel" id="infobox_1_backtitel" value="#infobox_1_backtitel#" />
		</td>
	</tr>
	<tr>
		<td>
			Infobox Flip-Back-Text:
		</td>
		<td>
			<input type="text" name="infobox_1_backtext" id="infobox_1_backtext" value="#infobox_1_backtext#" />
		</td>
	</tr>
	<tr>
		<td>Flip-Effekt:</td>
		<td>
			<input type="radio" value="1" <cfif infobox_1_hasflip EQ 1>checked</cfif> name="infobox_1_hasflip">Ja<br/>
			<input type="radio" value="0" <cfif infobox_1_hasflip EQ 0>checked</cfif> name="infobox_1_hasflip">Nein<br/>
		</td>
	</tr>
	<tr>
		<td>
			Link Titel:
		</td>
		<td>
			<input type="text" name="infobox_1_linktitle" id="infobox_1_linktitle" value="#infobox_1_linktitle#" />
		</td>
	</tr>
	<tr>
		<td>
			Jump to Slide:
		</td>
		<td>
			<input type="text" name="infobox_1_linkslideID" id="infobox_1_linkslideID" value="#infobox_1_linkslideID#" />
		</td>
	</tr>
	</table>
</cfoutput>