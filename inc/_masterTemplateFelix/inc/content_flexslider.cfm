
<cfloop query="getcontent">
	<!---ge-groupter querry da left join--->
	<cfquery name="getAlbumWithImages" datasource="#application.dsn#">
	SELECT A.id as albumid, A.Albumtitle,A.albumdescription,I.*
	FROM	albums A LEFT JOIN albumimages I ON I.albumID = A.id
	WHERE A.id = #albumid#
	</cfquery>
	<!---da groupter output, darf output in output hier abgefragt werden--->
	<div class="flexslider"> 
		<ul class="slides">
			<cfoutput query="getAlbumWithImages" group="albumid">	
			<cfoutput>
				<li class="slide"> 
					<img src="/#session.serverpath#/upload/galleries/#imagepath#" alt="d" /> 
				</li>
			</cfoutput>
		</cfoutput>
		</ul>
	</div>	
</cfloop>

<!--- <cfdump var="#getAlbumWithImages#"> ---> 