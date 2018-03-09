<!--- get normal CMS TExt --->
<cfloop query="getcontent">
	<!---ge-groupter querry da left join--->
	<cfquery name="getAlbumWithImages" datasource="#application.dsn#">
	SELECT A.id as albumid, A.Albumtitle,A.albumdescription,I.*
	FROM	albums A LEFT JOIN albumimages I ON I.albumID = A.id
	WHERE A.id = #albumid#
	</cfquery>
	<!---da groupter output, darf output in output hier abgefragt werden--->
			<cfoutput query="getAlbumWithImages" group="albumid">	
				<div class="textbox"> 
					<h2>#Albumtitle#</h2>
					<br />
					<h3>#albumdescription#</h3>
					<br />
				</div >
		</cfoutput>
</cfloop>





