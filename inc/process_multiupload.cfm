<cffile action="uploadall" destination="#expandPath('/#session.serverpath#/upload/galleries')#" nameconflict="makeunique" />

<cfimage source="#remoteServerPath##session.serverpath#\upload\galleries\#cffile.serverfile#" name="myImage"> 
<cfset bildbreite = ImageGetWidth(myImage) />
<cfset serverbildname = cffile.serverfile>
<cfset serverbildnameThumb = cffile.serverfilename & "_thumb." & cffile.serverfileext>
<cfset normalResizeWidth = "960" />
<cfset thumbResizeWidth = "700" />

<cfif bildbreite gt normalResizeWidth >
	<cfimage action="resize" width="#normalResizeWidth#" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" overwrite="yes">
</cfif>


<cfimage action="resize" width="#thumbResizeWidth#" height="" source="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildname#" destination="#remoteServerPath##session.serverpath#\upload\galleries\#serverbildnameThumb#" overwrite="yes">


<!--- get max reihenfolge der bilder in diesem album --->
<cfquery name="getreihenfolge" datasource="#application.dsn#">
SELECT	MAX(reihenfolge) as maxi
FROM	albumimages
WHERE	albumID = #url.albumid#
</cfquery>

<cfset order = 10 />
<cfif isnumeric(getreihenfolge.maxi)>
	<cfset order = order + 10 />
</cfif>

<cfquery name="insertImage" datasource="#application.dsn#">
INSERT 	INTO albumimages(
		imageTitle,
		imagePath,
		albumID,
		imageThumbPath,
		reihenfolge,
		createDate,
		creator 
		)
VALUES(
		'#cffile.serverfilename#',
		'#serverbildname#',
		#url.albumid#,
		'#serverbildnameThumb#',
		#order#,
		#createODBCdate(now())#,
		#session.UserID#
)
</cfquery>

<!--- write log to filesystem --->
<cfsavecontent variable="dump"><cfdump var="#cffile#"></cfsavecontent>
<cffile action="append" file="#expandPath('/admin/multiuploadLog.htm')#" output="#dump#">