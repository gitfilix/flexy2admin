<!--- check if image and if image is large enough --->
<cfset acceptImage = 1 />
<cfif isdefined("form.hg") AND form.hg NEQ "">

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
	<cffile action="upload" filefield="hg" destination="#remoteServerPath##session.serverpath#\upload\img\" nameconflict="makeunique">
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
		<cfset acceptImage = 0 />
		<cfset serverbildname = "">
	</cfif>
	
<cfelseif isdefined("form.delimage") OR form.hg EQ "">
	<cfset serverbildname = "">
</cfif>


<!--- insert into db --->
<cfquery name="upadetPage" datasource="#application.dsn#">
UPDATE	magazinseiten
SET		titel = '#form.titel#',
		autoLaunch = #form.autoLaunch#<cfif serverbildname NEQ "">,
		bgimage_#form.device#_#form.orientation# = '#form.device & "_" & form.orientation & "_" & serverbildname#'</cfif>,
		bgcolor = '#form.color#'
WHERE	id = #form.pageID#
</cfquery>



<!--- insert all other versions --->

<cfif NOT isdefined("form.delimage") AND form.hg NEQ "">
	<cfset serverbildname = form.device & "_" & form.orientation & "_" & serverbildname>
<cfelse>
	<cfset serverbildname = "">
</cfif>



<!--- output responseText for ajax-call: genereated filename of the uploaded file --->
<cfoutput>
<cfif serverbildname NEQ "" AND acceptImage EQ 1>#serverbildname#<cfelseif acceptImage EQ 0>0</cfif>
</cfoutput>