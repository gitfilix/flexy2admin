<cfprocessingdirective pageencoding="utf-8" />

<header id="navtop">
	<cfoutput>
		<a href="/#session.serverpath#" class="logo fleft">
			<img src="/#session.serverpath#/img/logo.png" alt="Designa Studio">
		</a>
	</cfoutput>
	<nav class="fright">
		<ul>
		<cfoutput query="getServiceNav">
			
			<li <cfif id EQ url.id>class="active"</cfif>>
				<a href="<cfif id EQ session.startID>/#session.serverpath#/<cfelse>/#session.serverpath#/#urlshortcut#/</cfif>">
					#pagetitel#
				</a>
			</li><cfif currentrow MOD 2 EQ 0>
				</ul>
				<cfif currentrow NEQ recordcount>
				<ul>
				</cfif>
			</cfif>
			
		</cfoutput>
		<cfquery name="checkForAcceptedLangs" datasource="#application.dsn#">
		SELECT * FROM mandantensprachen
		WHERE mandant = #session.mandant# AND languageParam != '#session.lang#'
		</cfquery>
		<cfif checkForAcceptedLangs.recordcount GT 1>
			
			<ul>
				<cfoutput query="checkForAcceptedLangs">
					<li style="padding-right:1em;">
						<cfif session.lang NEQ languageParam>
							<a href="#cgi.SCRIPT_NAME#?id=#url.id#&lang=#languageParam#" title="#language#">
								#listLast(languageParam,'-')#
							</a>
						<cfelse>
							#listLast(languageParam,'-')#
						</cfif>
					</li>
				</cfoutput>
			</ul>
		</cfif>
	</nav>
</header>