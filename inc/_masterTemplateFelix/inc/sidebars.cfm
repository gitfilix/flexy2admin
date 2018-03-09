<cfoutput query="getSidebarElems">
	<div class="widget">
		<h2>#titel#</h2>
		<cfif image NEQ "" AND fileExists(expandPath('/#session.serverpath#/upload/img/#image#'))>
			<img src="/#session.serverpath#/upload/img/#image#" alt="#titel#" style="width:100%;" />
		</cfif>
		<p>
			<cfif fliesstext NEQ "" AND fliesstext NEQ "<br />">
				#fliesstext#
			</cfif>
		</p>
		<ul>
			<li><cfif href NEQ "" AND hreflabel NEQ "">
				<a href="#href#" title="#hreflabel#" target="_blank">#hreflabel#</a>
			</cfif></li>
		</ul>
	</div>
</cfoutput>