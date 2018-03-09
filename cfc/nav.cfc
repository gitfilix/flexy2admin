<cfcomponent displayname="flexyNavAdmin" output="yes">
	
	<cffunction access="public" name="getUpperNav" returntype="numeric" output="no">
		<cfargument name="id" type="numeric" required="yes" />
		
		<cfquery name="getUpperNav" datasource="#application.dsn#">
		SELECT 	id AS idc,parentID
		FROM	pages
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#" /> <!--- AND visible = <cfqueryparam cfsqltype="cf_sql_numeric" value="1" />  --->
		</cfquery>

		<cfif getUpperNav.recordcount NEQ 0>
			<cfset ret = getUpperNav.parentID />
		<cfelse>
			<cfset ret = -1 />
		</cfif>
		
		<cfreturn ret />
	</cffunction>

	<!--- -------------------------------------------------------------------------------------------------------------------------------------- --->

	
	<cffunction access="public" name="navTree" returntype="string" output="no">
		<cfargument name="id" type="numeric" required="yes" />

		<cfset level = -2 />
		<cfset tree = "" />
		
		<cfif id EQ 0>
			<cfset level = 0 />
			<cfset tree = "" />
		<cfelse>
			<!--- navigationsbaum von id aus berechnen. nicht lachen!!! --->
			<cfquery name="getLevel" datasource="#application.dsn#">
			SELECT 	id AS idc,parentID
			FROM	pages
			WHERE	id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#" /> 
			ORDER	BY navorder ASC
			</cfquery>

			<cfif getLevel.recordcount EQ 0>
				<cfset level = 0/>
				<cfset tree = 0 />
			<cfelseif getLevel.parentID EQ 0>
				<cfset level = 0/>
				<cfset tree = getLevel.idc />
			<cfelse>
				<cfset oben = createObject("component","admin.cfc.nav").getUpperNav(id=getLevel.idc) />
                
				<cfif oben EQ 0>
					<cfset level = 1 />
					<cfset tree = "#oben#,#getLevel.parentID#" />
				<cfelseif oben NEQ -1>
                	
					<cfset oben2 = createObject("component","admin.cfc.nav").getUpperNav(id=oben) />
					<cfif oben2 EQ 0>
						<cfset level = 2 />
						<cfset tree = "#oben#,#getLevel.idc#" />
					<cfelseif oben2 NEQ -1>
						<cfset oben3 = createObject("component","admin.cfc.nav").getUpperNav(id=oben2) />
						<cfif oben3 EQ 0>
							<cfset level = 3 />
							<cfset tree = "#oben2#,#oben#,#getLevel.idc#" />
						<cfelseif oben3 NEQ -1>
							<cfset oben4 = createObject("component","admin.cfc.nav").getUpperNav(id=oben3) />
							<cfif oben4 EQ 0>
								<cfset level = 4 />
								<cfset tree = "#oben4#,#oben3#,#oben2#,#getLevel.idc#" />
							<cfelseif oben4 NEQ -1>
								<cfset oben5 = createObject("component","admin.cfc.nav").getUpperNav(id=oben4) />
								<cfif oben5 EQ 0>
									<cfset level = 5 />
									<cfset tree = "#oben5#,#oben4#,#oben3#,#oben2#,#getLevel.idc#" />
								</cfif>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		
		<cfreturn tree />
	</cffunction>

	<!--- -------------------------------------------------------------------------------------------------------------------------------------- --->
	
	
	<cffunction access="public" name="rewriteLinkById" returntype="string" output="yes">
		<cfargument name="id" type="numeric" required="yes" hint="page id" />
		<cfargument name="news" type="numeric" required="no" default="0" hint="an id" />
		<cfargument name="lang" type="string" required="no" default="#session.lang#" hint="" />
	
		<!--- <cfset application.midfix = application.com.global.getGlobals().midfix /> --->
		<cfset urlpathinfo = "" />
		<cfset breadcrumb = "" />
		<cfset addon = "" />
		
		
		<cfset tree = navtree(id=arguments.id,lang=arguments.lang) />
		
		<cfset langdbl = arguments.lang />
		
        <cfif listLen(tree) NEQ 0>
            <cfloop list="#tree#" index="i">
                <cfquery name="getpagedata" datasource="#application.dsn#">
				SELECT 	* 
				FROM 	pages
				WHERE 	id = #i# AND
						lang = '#langdbl#'
				</cfquery>
				<cfset breadcrumb = ListAppend(breadcrumb,urlencodedformat(getpagedata.urlshortcut),"/") />
            </cfloop>
        </cfif>
		<!--- addon news-name --->
		<cfif arguments.news GT 0>
			<cfquery name="getNews" datasource="#application.dsn#">
			SELECT 	* 
			FROM 	news
			WHERE 	id = #i#
			</cfquery>
			<cfset addon = "/n/" & getNews.urlshortcut />
		</cfif>
		<cfif breadcrumb NEQ "">
			<cfif arguments.id NEQ session.startID OR arguments.news GT 0>
				<cfreturn "/#session.serverpath#/#langdbl#/#breadcrumb##addon#/" />
			<cfelse>
				<cfreturn "/#session.serverpath#/#langdbl#/" />
			</cfif>	
		<cfelse>
			<cfset urladdon = "" />
			<cfif arguments.news NEQ 0>
				<cfset urladdon = listAppend(urladdon,"newsid=#arguments.news#","&") />
			</cfif>				
			<cfif urladdon NEQ "">
				<cfset urladdon = "&" & urladdon />
			</cfif>
			<cfreturn "/#session.serverpath#/index.cfm?id=#arguments.id##urladdon#/" /> 
		</cfif>
	</cffunction>

	<!--- --------------------------------------------------------------------------------------- --->
	
</cfcomponent>