<!--- check if image and if image is large enough --->
<cfset acceptImage = 1 />
<cfset serverbildname = "">

<cfif form.orientation EQ 1>
	<cfset mode = "portrait">
<cfelse>
	<cfset mode = "landscape">
</cfif>

<cfif isdefined("form.hgimg") AND form.hgimg NEQ "">

	<cfswitch expression="#form.device#">
		<cfcase value="galaxyTab">
			<cfif form.orientation EQ "portrait">
				<cfset imageDefaultHeight = "1280" />
				<cfset imageDefaultWidth = "800" />
			<cfelse>
				<cfset imageDefaultHeight = "800" />
				<cfset imageDefaultWidth = "1280" />
			</cfif>
		</cfcase>
		<cfcase value="ipad">
			<cfif form.orientation EQ "portrait">
				<cfset imageDefaultHeight = "1024" />
				<cfset imageDefaultWidth = "768" />
			<cfelse>
				<cfset imageDefaultHeight = "768" />
				<cfset imageDefaultWidth = "1024" />
			</cfif>
		</cfcase>
		<cfcase value="surface">
			<cfif form.orientation EQ "portrait">
				<cfset imageDefaultHeight = "1366" />
				<cfset imageDefaultWidth = "768" />
			<cfelse>
				<cfset imageDefaultHeight = "768" />
				<cfset imageDefaultWidth = "1366" />
			</cfif>
		</cfcase>
	</cfswitch>
	
	<!--- bild auf den server in relativpfad-folder uploaden --->
	<cffile action="upload" filefield="hgimg" destination="#remoteServerPath##session.serverpath#\upload\img\" nameconflict="makeunique">
	<!--- 	bild in die variable myImage laden --->
	<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#cffile.serverfile#" name="myImage"> 
	<!--- 	bildbreite auslesen und in bildbreite speichern --->
	<cfset bildbreite = ImageGetWidth(myImage) />
	<cfset bildHoehe = ImageGetHeight(myImage) />
	<!--- 	serverbildname in variable speichen --->
	<cfset serverbildname = cffile.serverfile>
	<!--- resize if oversized --->
	<cfif bildbreite gte bildHoehe and bildHoehe gte imageDefaultHeight>
		<cfimage action="resize" width="" height="#imageDefaultHeight#" source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\#form.device & "_" & form.orientation & "_" & serverbildname#" overwrite="yes">
		<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#form.device & "_" & form.orientation & "_" & serverbildname#" name="myImage2"> 
		<cfset ImageCrop(myImage2,0,0,imageDefaultWidth,imageDefaultHeight)>
		<cfimage source="#myImage2#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#form.device & "_" & form.orientation & "_" & serverbildname#" overwrite="yes"> 	
	<cfelseif bildbreite lte bildHoehe and bildHoehe gte imageDefaultHeight>
		<cfimage action="resize" width="#imageDefaultWidth#" height="" source="#remoteServerPath##session.serverpath#\upload\img\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\img\#form.device & "_" & form.orientation & "_" & serverbildname#" overwrite="yes">
		<cfimage source="#remoteServerPath##session.serverpath#\upload\img\#form.device & "_" & form.orientation & "_" & serverbildname#" name="myImage2"> 
		<cfset ImageCrop(myImage2,0,0,imageDefaultWidth,imageDefaultHeight)>
		<cfimage source="#myImage2#" action="write" destination="#remoteServerPath##session.serverpath#\upload\img\#form.device & "_" & form.orientation & "_" & serverbildname#" overwrite="yes"> 	
	<cfelse>
		<!--- <cfset acceptImage = 0 />
		<cfset serverbildname = "">  --->
		<cffile action="rename" source="#expandPath('/mirza-in-progress/upload/img/') & serverbildname#" destination="#expandPath('/mirza-in-progress/upload/img/') & form.device & "_" & mode & "_" & serverbildname#">
	</cfif>
	
<cfelseif isdefined("form.delimage") OR (isdefined("form.hgimg") AND form.hgimg EQ "")>
	<cfset serverbildname = "">
</cfif>

<cfquery name="update" datasource="#application.dsn#">
UPDATE	magazininhaltselemente
SET		<cfif isdefined("form.zIndex")>zIndex = #form.zIndex#,</cfif>
		<cfif isdefined("form.color")>bgcolor = '#form.color#',</cfif>
		<cfif isdefined("form.opacity")>opacity = #form.opacity#,</cfif>
		<cfif isdefined("form.inhalt")>content = '#form.inhalt#',</cfif>
		<cfif isdefined("form.pageID")>magazinPageID = #form.pageID#,</cfif>
		orientation = <cfif form.orientation EQ "landscape">0<cfelse>1</cfif>
		<cfif serverbildname NEQ "">,image = '#form.device & "_" & mode & "_" & serverbildname#'<cfelseif isdefined("form.delimage")>,image = ''</cfif>
WHERE	id = #form.id#
</cfquery>

<cfquery name="update2" datasource="#application.dsn#">
UPDATE	magazininhaltselemente_#form.device#
SET		<cfif isdefined("form.width")>width = #form.width#,</cfif>
		<cfif isdefined("form.height")>height = #form.height#,</cfif>
		<cfif isdefined("form.posX")>posX = #form.posX#,</cfif>
		<cfif isdefined("form.posY")>posY = #form.posY#,</cfif>
		<cfif isdefined("form.zIndex")>zIndex = #form.zIndex#,</cfif>
		x = 0
WHERE	id = #form.resElemID#
</cfquery>



<!--- <cfif NOT isdefined("form.delimage") AND form.hgimg NEQ "">
	<cfset serverbildname = form.device & "_" & form.orientation & "_" & serverbildname>
<cfelse>
	<cfset serverbildname = "">
</cfif> --->



<!--- output responseText for ajax-call: genereated filename of the uploaded file --->
<!--- <cfoutput>
<cfif serverbildname NEQ "" AND acceptImage EQ 1>#serverbildname#<cfelseif acceptImage EQ 0>0</cfif>
</cfoutput> --->
<cfif isdefined("form.hgimg") AND form.hgimg NEQ "" AND serverbildname NEQ "">
	<cfoutput>
		<img src="/mirza-in-progress/upload/img/#serverbildname#" alt="" style="max-width:100%;" />
	</cfoutput>
<cfelse>
	<cfif isdefined("form.inhalt")>
		<cfoutput>#form.inhalt#</cfoutput>
	</cfif>
</cfif>

