<cfprocessingdirective pageencoding="utf-8" />

<ul>
	<cfoutput query="getServiceNav">
	<li <cfif id EQ url.id>class="active"</cfif>>
		<a href="/#session.serverpath#/#urlshortcut#/">
			#pagetitel#
		</a>
	</li>
	</cfoutput>
</ul>