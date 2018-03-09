<cfprocessingdirective pageencoding="utf-8" />

<!--- form processor UPDATE slide Template 1 --->
<cfif isdefined("url.action") AND url.action EQ "submittedEditedMagazineSlide">
	
	<!--- upload bgimage --->
	<cfset bg = form.origbg />
	<cfif isdefined("form.bgimage") AND form.bgimage NEQ "">
		<cffile action="upload" filefield="bgimage" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
		<cfset bg = cffile.serverfile />
	</cfif>
	
	<cfquery name="updateMagazineSlide" datasource="#application.dsn#">
	UPDATE	magazinslides
	SET		label = '#form.label#',
			bgimage = '#bg#',
			parent = #form.parent#,
			reihenfolge = #form.sort#,
			bgcolor = '#form.bgcolor#',
			transitiontype = '#form.setting_slidetransition#'
	WHERE	id = #form.slideID#
	</cfquery>
	
	
	
	<!--- update template 1 --->
	<cfif form.template EQ 1>
		<!--- upload image --->
		<cfset bild = form.origbild />
		<cfif isdefined("form.bild") AND form.bild NEQ "">
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset bild = cffile.serverfile />
		</cfif>
		<!--- upload LightBox image --->
		<cfset lbbild = form.origlbbild />
		<cfif isdefined("form.lbbild") AND form.lbbild NEQ "">
			<cffile action="upload" filefield="lbbild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset lbbild = cffile.serverfile />
		</cfif>
		
		<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		setting_layout = '#form.setting_layout#',
				setting_skin	= '#form.setting_skin#',
				titel = '#form.titel#',
				titlecolor = '#form.titlecolor#',
				lead = '#form.lead#',
				bild = '#bild#',
				imgpos ='#form.imgpos#',
				bildlegende = '#form.caption#',
				lightboxtitle = '#form.lightboxtitle#',
				lightboxbutton = '#form.lightboxbutton#',
				lightboxtext = '#form.lightboxtext#',
				lbbild = '#lbbild#',
				video = #form.video#,
				ytvideo = '#form.ytcode#',
				lightboxtype ='#form.lightboxtype#'  
		WHERE	slideid = #form.slideID#
		</cfquery>
		
		<!--- update teasers --->
		<cfif isdefined("form.teaserID")>
			<!--- erst alle teasers löschen --->
			<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
			DELETE	
			FROM	teaser2slides
			WHERE	slideID = #form.slideID#
			</cfquery>
			<!--- insert new submitted teasers --->
			<cfloop from="1" to="#ListLen(form.teaserid)#" index="i">
				<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
				INSERT 
				INTO	teaser2slides (slideID,teaserID,reihenfolge)
				VALUES(
						#form.slideID#,
						#listGetAt(form.teaserid,i)#,
						#listGetAt(form.teaserOrder,i)#
				)
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
	
	<!--- update template 2 --->
	<cfif form.template EQ 2>
		<!--- upload image --->
		<cfset bildx = form.origbild />
		<cfif isdefined("form.bild") AND form.bild NEQ "">
			<cffile action="upload" filefield="bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset bildx = cffile.serverfile />
		</cfif>
		<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		titel = '#form.titel#',
				lead = '#form.lead#',
				bild = '#bildx#',
				bildlegende = '#form.caption#',
				ytvideo = '#form.ytcode#'   
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 3 --->
	<cfif form.template EQ 3>
		<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		titel = '#form.titel#',
				lead = '#form.lead#',
				layoutType = #form.typ#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 4 --->
	<cfif form.template EQ 4>
		<cfset infobox_1_img = form.orig_infobox_1_img />
		<cfif isdefined("form.infobox_1_img") AND form.infobox_1_img NEQ "">
			<cffile action="upload" filefield="infobox_1_img" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset infobox_1_img = cffile.serverfile />
		</cfif>
		<cfquery name="updateMagazineSlideTpl" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		titel = '#form.titel#',
				infobox_1_title = '#form.infobox_1_title#',
				infobox_1_img = '#infobox_1_img#',
				infobox_1_backtitel = '#form.infobox_1_backtitel#',
				infobox_1_fronttext = '#form.infobox_1_fronttext#',
				infobox_1_backtext = '#form.infobox_1_backtext#',
				infobox_1_hasflip = #form.infobox_1_hasflip#,
				infobox_1_linktitle = '#form.infobox_1_linktitle#'<cfif form.infobox_1_linkslideID NEQ "" AND isNumeric(form.infobox_1_backtext)>,
				infobox_1_linkslideID = #form.infobox_1_linkslideID#</cfif>
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 5 --->
	<cfif form.template EQ 5>
		<cfset img = form.origbild_1 />
		<cfif isdefined("form.chapter_1_img") AND form.chapter_1_img NEQ "">
			<cffile action="upload" filefield="chapter_1_img" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset img = cffile.serverfile />
		</cfif>
		<cfquery name="updateMagazineSlideTpl5" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		title = '#form.title#',
				chapter_1_title = '#form.chapter_1_title#',
				chapter_1_desc = '#form.chapter_1_desc#',
				chapter_1_img = '#img#',
				chapter_1_linklabel = '#form.chapter_1_linklabel#',
				chapter_1_link = '#form.chapter_1_link#'   
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 6 --->
	<cfif form.template EQ 6>
		<cfset img = form.origimg />
		<cfif isdefined("form.img") AND form.img NEQ "">
			<cffile action="upload" filefield="img" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset img = cffile.serverfile />
		</cfif>
		<cfquery name="updateMagazineSlideTpl5" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		title = '#form.title#',
				lead = '#form.lead#',
				splashtext = '#form.splashtext#',
				titleColor = '#form.titlecolor#',
				leadColor = '#form.leadcolor#',
				boxed = #form.boxed#,
				box_bgcolor ='#form.box_bgcolor#',
				box_opacity = <cfqueryparam cfsqltype="cf_sql_float" value="#form.box_opacity#" />,
				titlePos = #form.titlepos#,
				leadPos = #form.leadpos#,
				titleAnimation = #form.titleanimation#,
				leadAnimation = #form.leadanimation#,
				splashanimation = #form.splashanimation#,
				img = '#img#',
				imgpos = #form.imgpos#,
				setting_layout = #form.typ#, 
				setting_leadanimation_delay = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_leadanimation_delay#" />,
				setting_leadanimation_duration = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_leadanimation_duration#" />,
				setting_titleanimation_delay = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_titleanimation_delay#" />,
				setting_titleanimation_duration =  <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_titleanimation_duration#" />,
				setting_splashanimation_delay = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_splashanimation_delay#" />,
				setting_splashanimation_duration =  <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_splashanimation_duration#" />
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 7 --->
	<cfif form.template EQ 7>
		<!--- upload images --->
		<!--- artikel bild upload --->
		<cfset img1 = form.origbild1 />
		<cfif isdefined("form.bild1") AND form.bild1 NEQ "">
			<cffile action="upload" filefield="bild1" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset img1 = cffile.serverfile />
		</cfif>
		<!--- textabschnitt 2 bild upload --->
		<cfset img2 = form.origbild2 />
		<cfif isdefined("form.textabschnitt_2_bild") AND form.textabschnitt_2_bild NEQ "">
			<cffile action="upload" filefield="textabschnitt_2_bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset img2 = cffile.serverfile />
		</cfif>
		<!--- textabschnitt 3 bild upload --->
		<cfset img3 = form.origbild3 />
		<cfif isdefined("form.textabschnitt_3_bild") AND form.textabschnitt_3_bild NEQ "">
			<cffile action="upload" filefield="textabschnitt_3_bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset img3 = cffile.serverfile />
		</cfif>

		<cfquery name="updateMagazineSlideTpl7" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		titel_1 = '#form.titel_1#',
				titel_2 = '#form.titel_2#',
				anriss = '#form.anriss#',
				textabschnitt_1 = '#form.textabschnitt_1#',
				textabschnitt_2 = '#form.textabschnitt_2#',
				textabschnitt_3 = '#form.textabschnitt_3#',
				bild = '#img1#',
				galerie = #form.galerie#,
				youtube = '#form.youtube#',
				bild_legenede = '#form.bild_legenede#',
				bild_quelle = '#form.bild_quelle#',
				setting_layout = #form.setting_layout#,
				setting_bildanim = #form.setting_bildanim#,
				setting_allowcomment = #form.setting_allowcomment#,
				setting_titlecolor = '#form.setting_titlecolor#',
				setting_leadcolor = '#form.setting_leadcolor#',
				setting_textcolor = '#form.setting_textcolor#',
				setting_skin = #form.setting_skin#,
				setting_titleanimation = #form.setting_titleanimation#,
				setting_leadanimation = #form.setting_leadanimation#,
				setting_textanimation = #form.setting_textanimation#,
				setting_mediaanimation = #form.setting_mediaanimation#, 
				textabschnitt_2_bild = '#img2#',
				textabschnitt_3_bild = '#img3#',
				setting_titleanimation_delay = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_titleanimation_delay#" />,
				setting_titleanimation_duration = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_titleanimation_duration#" />,
				setting_leadanimation_delay = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_leadanimation_delay#"/>,
				setting_leadanimation_duration =<cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_leadanimation_duration#"/>,
				setting_textanimation_delay = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_textanimation_delay#"/>,
				setting_textanimation_duration = <cfqueryparam cfsqltype="cf_sql_float" value="#form.setting_textanimation_duration#"/>,
				setting_bigtext = #form.bigtext#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 8 --->
	<cfif form.template EQ 8>
		<cfquery name="updateMagazineSlideTpl8" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		slideID = #form.slideID#,
				setting_layout = #form.setting_layout#
		WHERE	slideid = #form.slideID#
		</cfquery>
		<cfif not isdefined("form.article")>
			<cfquery name="delete" datasource="#application.dsn#">
			DELETE	
			FROM	articles2slides
			WHERE	slideid = #form.slideID#
			</cfquery>
		<cfelse>
			<cfquery name="delete" datasource="#application.dsn#">
			DELETE	
			FROM	articles2slides
			WHERE	slideid = #form.slideID#
			</cfquery>
			<cfloop list="#form.article#" index="i">
				<cfquery name="insert" datasource="#application.dsn#">
				INSERT	
				INTO	articles2slides(slideID,otherSlideID)
				VALUES(
					#form.slideID#,
					#i#
				)
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
	
	<!--- update template 100 --->
	<cfif form.template EQ 100>
		<cfset img = form.origbild />
		<cfif isdefined("form.lb_bild") AND form.lb_bild NEQ "">
			<cffile action="upload" filefield="lb_bild" destination="#remoteServerPath##session.serverpath#\upload\magazine\" nameconflict="makeunique" />
			<cfset img = cffile.serverfile />
		</cfif>	
		<cfquery name="updateMagazineSlideTpl100" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		slideID = #form.slideID#,
				titel = '#form.titel#',
				lead = '#form.lead#',
				TEXT = '#form.text#',
				layout = #form.layout#,
				lb_titel = '#form.lb_titel#',
				lb_text = '#form.lb_text#',
				lb_bild = '#img#',
				lb_bildcaption = '#form.lb_bildcaption#',
				galerie = #form.album#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 101 --->
	<cfif form.template EQ 101>
		
		<cfquery name="updateMagazineSlideTpl101" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		slideID = #form.slideID#,
				titel = '#form.titel#',
				lead = '#form.lead#',
				layout = #form.layout#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 102 --->
	<cfif form.template EQ 102>
		<cfquery name="updateMagazineSlideTpl102" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		slideID = #form.slideID#,
				titel = '#form.titel#',
				lead = '#form.lead#',
				TEXT = '#form.text#',
				layout = #form.layout#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 103 --->
	<cfif form.template EQ 103>
		<cfquery name="updateMagazineSlideTpl103" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		slideID = #form.slideID#,
				titel = '#form.titel#',
				lead = '#form.lead#',
				TEXT = '#form.text#',
				layout = #form.layout#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	<!--- update template 104 --->
	<cfif form.template EQ 104>
		<cfquery name="updateMagazineSlideTpl104" datasource="#application.dsn#">
		UPDATE	magazinslidetpl_#form.template#
		SET		slideID = #form.slideID#,
				lead = '#form.lead#',
				layout = #form.layout#
		WHERE	slideid = #form.slideID#
		</cfquery>
	</cfif>
	
	
	<!--- <script>
		<cfoutput>setTimeout(function(){
			window.parent.slidey.jumpto(0,#form.slideID#)	
		},1500)
		setTimeout(function(){
			location.href='#cgi.SCRIPT_NAME#';
		},1600)</cfoutput>
	</script> --->
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>
<!---END  form processor UPDATE slide Template 1 --->

<cfquery name="getslide" datasource="#application.dsn#">
SELECT * FROM magazinSlides
WHERE id = #url.editMagazinSlide#
</cfquery>

<cfquery name="getAllChaptersFromIssue" datasource="#application.dsn#">
SELECT 	K.* 
FROM 	((magazine M LEFT JOIN 
		magazinAusgaben A ON A.magazinID = M.id) LEFT JOIN
		magazinKapitel K ON K.magazinAusgabeID = A.id) LEFT JOIN
		magazinSlides S ON S.parent = K.id
WHERE 	M.mandant = #session.mandant#
GROUP	BY K.id
ORDER	BY K.id
</cfquery>

<script>

</script>

<cfoutput query="getslide">



	<form action="#cgi.SCRIPT_NAME#?action=submittedEditedMagazineSlide&editMagazinSlide=#url.editMagazinSlide#" method="post" enctype="multipart/form-data">
		<table width="100%">
		<tr>
			<td>Label*</td>
			<td>
				<input type="text" name="label" id="label" value="#label#" />
			</td>
		</tr>
		<tr>
			<td>TrägerKapitel*</td>
			<td>
				<select name="parent" id="parent">
					<cfloop query="getAllChaptersFromIssue">
						<cfif id NEQ "">
							<option value="#id#" <cfif getslide.parent EQ id>selected</cfif>>#kapitel#</option>
						</cfif>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td>Reihenfolge</td>
			<td>
				
				<input type="text" name="sort" id="sort" value="#reihenfolge#" />
			</td>
		</tr>
		<tr style="background:##484848; color:##EBEBEB;">
			<td>Template</td>
			<td>
				#template#
				<input type="hidden" name="template" id="template" value="#template#" />
			</td>
		</tr>
		<tr>
			<td>Hintergrund-Bild</td>
			<td>
				<input type="file" name="bgimage" id="bgimage" />
				<input type="hidden" name="origbg" id="origbg" value="#bgimage#" />
				<cfif bgimage NEQ "" AND fileExists('#remoteServerPath##session.serverpath#\upload\magazine\#bgimage#')>
					Aktuelles Hintergrundbild: <br /><br />
					<img src="/#session.serverpath#/upload/magazine/#bgimage#" width="300" />
				</cfif>
			</td>
		</tr>
		<tr>
			<td>Hintergrund-Farbe</td>
			<td>
				<input type="text" name="bgcolor" id="bgcolor" value="#bgcolor#" />
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfswitch expression="#template#">
					<!--- template 1 --->
					<cfcase value="1">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-1.cfm" />	
					</cfcase>
					<!--- template 2 --->
					<cfcase value="2">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-2.cfm" />	
					</cfcase>
					<!--- template 3 --->
					<cfcase value="3">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-3.cfm" />	
					</cfcase>
					<!--- template 4 --->
					<cfcase value="4">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-4.cfm" />	
					</cfcase>
					<!--- template 5 --->
					<cfcase value="5">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-5.cfm" />	
					</cfcase>
					<!--- template 6 --->
					<cfcase value="6">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-6.cfm" />	
					</cfcase>
					<!--- template 7 --->
					<cfcase value="7">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-7.cfm" />	
					</cfcase>
					<!--- template 8 --->
					<cfcase value="8">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-8.cfm" />	
					</cfcase>
					<!--- template 100 --->
					<cfcase value="100">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-100.cfm" />	
					</cfcase>
					<!--- template 101 --->
					<cfcase value="101">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-101.cfm" />	
					</cfcase>
					<!--- template 102 --->
					<cfcase value="102">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-102.cfm" />	
					</cfcase>
					<!--- template 103 --->
					<cfcase value="103">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-103.cfm" />	
					</cfcase>
					<!--- template 104 --->
					<cfcase value="104">
						<cfinclude template="/admin/inc/inc_editMagazineSlideTpl-104.cfm" />	
					</cfcase>
				</cfswitch>
			</td>
		</tr>
		<tr>
			<td>
				Slide Übergang
			</td>
			<td>
				<select name="setting_slidetransition">
					<option value="default"  <cfif transitiontype EQ "default">selected</cfif>>default</option>
					<option value="linear"  <cfif transitiontype EQ "linear">selected</cfif>>linear</option>
					<option value="cube"  <cfif transitiontype EQ "cube">selected</cfif>>cube</option>
					<option value="page"  <cfif transitiontype EQ "page">selected</cfif>>page</option>
					<option value="fade"  <cfif transitiontype EQ "fade">selected</cfif>>fade</option>
					<option value="zoom"  <cfif transitiontype EQ "zoom">selected</cfif>>zoom</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>
			<input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			</td>
			<td>
				<input type="hidden" value="#url.editMagazinSlide#" name="slideID" />
				<input type="submit" value="ändern" />
			</td>
		</tr>
		</table>
	</form>
</cfoutput>