<cfquery name="insert" datasource="#application.dsn#">
INSERT 	
INTO 	magazininhaltselemente(
		magazinPageID,
		contentType,
		bgcolor,
		content,
		orientation
		)
VALUES(
	#form.pageID#,
	#form.type#,
	'#form.color#',
	NULL,
	<cfif form.orientation EQ 'portrait'>1<cfelse>0</cfif>
)
</cfquery>

<cfquery name="getLatestID" datasource="#application.dsn#">
SELECT	MAX(id) as maxi
FROM	magazininhaltselemente
</cfquery>
<cfset mx = 0 />
<cfset mx2 = 0 />
<cfif getLatestID.maxi EQ "">
	<cfset mx = 1>
<cfelse>
	<cfset mx = getLatestID.maxi>
</cfif>

<cfloop list="galaxyTab,ipad,surface" index="i">

	<cfquery name="insert" datasource="#application.dsn#">
	INSERT 	
	INTO 	magazininhaltselemente_#i#(
			magazinInhaltsElementID,
			<cfif isdefined("form.width")>width,</cfif>
			<cfif isdefined("form.height")>height,</cfif>
			<cfif isdefined("form.posX")>posX,</cfif>
			<cfif isdefined("form.posY")>posY,</cfif>
			<cfif isdefined("form.zIndex")>zIndex,</cfif>
			x
			)
	VALUES(
		#mx#,
		<cfif isdefined("form.width")>#form.width#,</cfif>
		<cfif isdefined("form.height")>#form.height#,</cfif>
		<cfif isdefined("form.posX")>#form.posX#,</cfif>
		<cfif isdefined("form.posY")>#form.posY#,</cfif>
		<cfif isdefined("form.zIndex")>#form.zIndex#,</cfif>
		0
	)
	</cfquery>
	
	<cfif form.device EQ i>
		<cfquery name="getLatestID2" datasource="#application.dsn#">
		SELECT	MAX(id) as maxi
		FROM	magazininhaltselemente_#i#
		</cfquery>
		<cfif getLatestID2.maxi EQ "">
			<cfset mx2 = 1>
		<cfelse>
			<cfset mx2 = getLatestID2.maxi>
		</cfif>
	</cfif>

</cfloop>
<cfoutput>#mx#-#mx2#</cfoutput>
<cfquery name="insert2" datasource="#application.dsn#">
INSERT 	
INTO 	magazininhaltselemente(
		magazinPageID,
		contentType,
		bgcolor,
		content,
		orientation
		)
VALUES(
	#form.pageID#,
	#form.type#,
	'#form.color#',
	NULL,
	<cfif form.orientation EQ 'portrait'>0<cfelse>1</cfif>
)
</cfquery>

<cfquery name="getLatestID" datasource="#application.dsn#">
SELECT	MAX(id) as maxi
FROM	magazininhaltselemente
</cfquery>
<cfif getLatestID.maxi EQ "">
	<cfset mx = 1>
<cfelse>
	<cfset mx = getLatestID.maxi>
</cfif>

<cfloop list="galaxyTab,ipad,surface" index="i">

	<cfquery name="insert" datasource="#application.dsn#">
	INSERT 	
	INTO 	magazininhaltselemente_#i#(
			magazinInhaltsElementID,
			<cfif isdefined("form.width")>width,</cfif>
			<cfif isdefined("form.height")>height,</cfif>
			<cfif isdefined("form.posX")>posX,</cfif>
			<cfif isdefined("form.posY")>posY,</cfif>
			<cfif isdefined("form.zIndex")>zIndex,</cfif>
			x
			)
	VALUES(
		#mx#,
		<cfif isdefined("form.width")>#form.width#,</cfif>
		<cfif isdefined("form.height")>#form.height#,</cfif>
		<cfif isdefined("form.posX")>#form.posX#,</cfif>
		<cfif isdefined("form.posY")>#form.posY#,</cfif>
		<cfif isdefined("form.zIndex")>#form.zIndex#,</cfif>
		0
	)
	</cfquery>

</cfloop>

