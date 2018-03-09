<cfprocessingdirective pageencoding="utf-8" />

<ul class="block-four">
	<cfoutput query="getThemenNav">
	<li <cfif id EQ url.id>class="active"</cfif> >
		<cfif urlshortcut NEQ "">
			<a href="/#session.serverpath#/#urlshortcut#">
				#pagetitel#
			</a>
		<cfelse>
			<a href="#cgi.SCRIPT_NAME#?id=#id#">
				#pagetitel#
			</a>
		</cfif>
		
		
	</li>
	</cfoutput>
</ul>