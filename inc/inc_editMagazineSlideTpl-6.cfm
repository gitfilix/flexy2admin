<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="getSlideBackgroundImage" datasource="#application.dsn#">
SELECT bgimage FROM magazinSlides
WHERE id = #url.editMagazinSlide#
</cfquery>

<cfquery name="getSlideContent" datasource="#application.dsn#">
SELECT * FROM magazinslidetpl_6
WHERE slideid = #url.editMagazinSlide#
</cfquery>
<!--- id
slideID
title
lead
targetSlideID
buttontext
titleColor
leadColor
boxed
titlePos
leadPos
titleAnimation
leadAnimation
img
imgpos
setting_layout --->
<cfoutput>
	<table width="100%">
	<tr>
		<td>
			Layout-Type:
		</td>
		<td>
			<input type="radio" value="0" <cfif getSlideContent.setting_layout EQ 0>checked</cfif> name="typ"> Text und Bild zentriert, SplashTeaser Optional<br/>
			<input type="radio" value="1" <cfif getSlideContent.setting_layout EQ 1>checked</cfif> name="typ"> Text und Bild links<br/>
			<input type="radio" value="2" <cfif getSlideContent.setting_layout EQ 2>checked</cfif> name="typ">Bild zentriert, Titel Rechts, Lead links<br/>
			<input type="radio" value="3" <cfif getSlideContent.setting_layout EQ 3>checked</cfif> name="typ">Grosser Titel, kein Bild, kein Lead<br/>
		</td>
	</tr>
	<tr>
		<td>
			Titel:
		</td>
		<td>
			<input type="text" name="title" id="title" value="#getSlideContent.title#" />
		</td>
	</tr>
	<tr>
		<td>
			Titelfarbe:
		</td>
		<td>
		<input type="text" name="titlecolor" id="titlecolor" value="#getSlideContent.titlecolor#" />
		</td>
	</tr>
	<tr>
		<td>
			TitelPostion:
		</td>
		<td>
		<select name="titlePos">
					<option value="0" <cfif getSlideContent.titlePos EQ 0>selected</cfif>>Zentriert</option>
					<option value="1" <cfif getSlideContent.titlePos EQ 1>selected</cfif>>Oben</option>
					<option value="2" <cfif getSlideContent.titlePos EQ 2>selected</cfif>>Links</option>
					<option value="3" <cfif getSlideContent.titlePos EQ 3>selected</cfif>>Rechts</option>
					<option value="4" <cfif getSlideContent.titlePos EQ 4>selected</cfif>>Unten</option>
		</select>
		</td>
	</tr>
	<tr>	
		<td>
			Titel Box:
		</td>
		<td>
			<input type="radio" value="0" <cfif getSlideContent.boxed EQ 0>checked</cfif> name="boxed">no<br/>
			<input type="radio" value="1" <cfif getSlideContent.boxed EQ 1>checked</cfif> name="boxed">yes<br/>
		</td>
	</tr> 
	<tr>	
		<td>
			Titel Box Background Color:
		</td>
		<td>
			<input type="text" name="box_bgcolor" id="box_bgcolor" value="#getSlideContent.box_bgcolor#" />
		</td>
	</tr> 
	<tr>	
		<td>
			Titel Box Transparent Faktor (0.1 - 1.0):
		</td>
		<td>
			<input type="text" name="box_opacity" id="box_opacity" value="#getSlideContent.box_opacity#" style="width:40px;" />
		</td>
	</tr> 
	<tr>
		<td>
			Titel Animation:
		</td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="padding-top:0;">
							<input type="text" name="setting_titleanimation_delay" id="setting_titleanimation_delay" value="#getSlideContent.setting_titleanimation_delay#" style="width:40px;" />
						</td>
						<td style="padding-top:0;">
							<select name="titleanimation">
								<option value="0" <cfif getSlideContent.titleanimation EQ 0>selected</cfif>>keine</option>
								<option value="1" <cfif getSlideContent.titleanimation EQ 1>selected</cfif>>fadeIn</option>
								<option value="2" <cfif getSlideContent.titleanimation EQ 2>selected</cfif>>slideInLeft</option>
								<option value="3" <cfif getSlideContent.titleanimation EQ 3>selected</cfif>>slideInRight</option>
								<option value="4" <cfif getSlideContent.titleanimation EQ 4>selected</cfif>>slideInTop</option>
								<option value="5" <cfif getSlideContent.titleanimation EQ 5>selected</cfif>>slideInBottom</option>
								<option value="6" <cfif getSlideContent.titleanimation EQ 6>selected</cfif>>scaleTextUp</option>
							</select>
						</td>
						<td style="padding-top:0;">
							<input type="text" name="setting_titleanimation_duration" id="setting_titleanimation_duration" value="#getSlideContent.setting_titleanimation_duration#" style="width:40px;" />
						</td>
					</tr>
			</table>
		</td>
	</tr>	
	<tr>
		<td>
			Untertitel:
		</td>
		<td>
			<textarea name="lead" id="lead" rows="0" cols="0">#getSlideContent.lead#</textarea>
		</td>
	</tr>
	<tr>
		<td>
			Untertitelfarbe:
		</td>
		<td>
			<input type="text" name="leadColor" id="leadColor" value="#getSlideContent.leadColor#" />
		</td>
	</tr>
	<tr>
		<td>
			Untertitel Postion:
		</td>
		<td>
		<select name="leadPos">
					<option value="0" <cfif getSlideContent.leadPos EQ 0>selected</cfif>>Zentriert</option>
					<option value="1" <cfif getSlideContent.leadPos EQ 1>selected</cfif>>Oben</option>
					<option value="2" <cfif getSlideContent.leadPos EQ 2>selected</cfif>>Links</option>
					<option value="3" <cfif getSlideContent.leadPos EQ 3>selected</cfif>>Rechts</option>
					<option value="4" <cfif getSlideContent.leadPos EQ 4>selected</cfif>>Unten</option>
		</select>
		</td>
	</tr>
	<tr>
		<td>
			Untertitel Animation
		</td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td style="padding-top:0;">
					<input type="text" name="setting_leadanimation_delay" id="setting_leadanimation_delay" value="#getSlideContent.setting_leadanimation_delay#" style="width:40px;" />
				</td>
				<td style="padding-top:0;">
					<select name="leadanimation">
						<option value="0" <cfif getSlideContent.leadanimation EQ 0>selected</cfif>>keine</option>
						<option value="1" <cfif getSlideContent.leadanimation EQ 1>selected</cfif>>fadeIn</option>
						<option value="2" <cfif getSlideContent.leadanimation EQ 2>selected</cfif>>slideInLeft</option>
						<option value="3" <cfif getSlideContent.leadanimation EQ 3>selected</cfif>>slideInRight</option>
						<option value="4" <cfif getSlideContent.leadanimation EQ 4>selected</cfif>>slideInTop</option>
						<option value="5" <cfif getSlideContent.leadanimation EQ 5>selected</cfif>>slideInBottom</option>
						<option value="6" <cfif getSlideContent.leadanimation EQ 6>selected</cfif>>scaleTextUp</option>
					</select>
				</td>
				<td style="padding-top:0;">
					<input type="text" name="setting_leadanimation_duration" id="setting_leadanimation_duration" value="#getSlideContent.setting_leadanimation_duration#" style="width:40px;" />
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Artikel Bild
		</td> 
		<td>
			<input type="file" name="img" id="img" />
			<input type="hidden" name="origimg" id="origimg" value="#getSlideContent.img#" />
			<cfif getSlideContent.img NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#getSlideContent.img#')>
				<img src="/#session.serverpath#/upload/magazine/#getSlideContent.img#" width="100" />
			</cfif>
		</td>
	</tr>
	<tr>	
		<td>
		Bild Position:
		</td>
		<td>
			<input type="radio" value="0" <cfif getSlideContent.imgpos EQ 0>checked</cfif> name="imgpos">zentriert (center-center)<br/>
			<input type="radio" value="1" <cfif getSlideContent.imgpos EQ 1>checked</cfif> name="imgpos">zentriert-oben (center-top)<br/>
			<input type="radio" value="2" <cfif getSlideContent.imgpos EQ 2>checked</cfif> name="imgpos">zentriert-unten (center-bottom)<br/>
			<input type="radio" value="3" <cfif getSlideContent.imgpos EQ 3>checked</cfif> name="imgpos">links-oben (left-top)<br/>
			<input type="radio" value="4" <cfif getSlideContent.imgpos EQ 4>checked</cfif> name="imgpos">links-zentriert (left-center)<br/>
			<input type="radio" value="5" <cfif getSlideContent.imgpos EQ 5>checked</cfif> name="imgpos">links-unten (left-bottom)<br/>
			<input type="radio" value="6" <cfif getSlideContent.imgpos EQ 6>checked</cfif> name="imgpos">rechts-oben (right-top)<br/>
			<input type="radio" value="7" <cfif getSlideContent.imgpos EQ 7>checked</cfif> name="imgpos">rechts-zentriert (right-center)<br/>
			<input type="radio" value="8" <cfif getSlideContent.imgpos EQ 8>checked</cfif> name="imgpos">rechts-unten (right-bottom)<br/>
		</td>
	</tr> 
	<tr>
		<td>
			Splashteaser:
		</td>
		<td>
			<textarea name="splashtext" id="splashtext" rows="0" cols="0">#getSlideContent.splashtext#</textarea>
		</td>
	</tr>		
	<tr>
		<td>
			Splashteaser Effekt:
		</td>
				<td>
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td style="padding-top:0;">
					<input type="text" name="setting_splashanimation_delay" id="setting_splashanimation_delay" value="#getSlideContent.setting_splashanimation_delay#" style="width:40px;" />
				</td>
				<td style="padding-top:0;">
					<select name="splashanimation">
						<option value="0" <cfif getSlideContent.splashanimation EQ 0>selected</cfif>>keine</option>
						<option value="1" <cfif getSlideContent.splashanimation EQ 1>selected</cfif>>fadeIn</option>
						<option value="2" <cfif getSlideContent.splashanimation EQ 2>selected</cfif>>slideInLeft</option>
						<option value="3" <cfif getSlideContent.splashanimation EQ 3>selected</cfif>>slideInRight</option>
						<option value="4" <cfif getSlideContent.splashanimation EQ 4>selected</cfif>>slideInTop</option>
						<option value="5" <cfif getSlideContent.splashanimation EQ 5>selected</cfif>>slideInBottom</option>
						<option value="6" <cfif getSlideContent.splashanimation EQ 6>selected</cfif>>scaleTextUp</option>
					</select>
				</td>
				<td style="padding-top:0;">
					<input type="text" name="setting_splashanimation_duration" id="setting_splashanimation_duration" value="#getSlideContent.setting_splashanimation_duration#" style="width:40px;" />
				</td>
			</tr>
			</table>
		</td>

	</tr>
	</table>
</cfoutput>