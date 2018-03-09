<cfcomponent displayname="mirzainprogessNav" output="yes">
	
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
			<cfset ret = 0 />
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

			<cfif getLevel.parentID EQ 0>
				<cfset level = 0/>
				<cfset tree = getLevel.idc />
			<cfelse>
				<cfset oben = createObject("component","#session.serverpath#.inc.cfc.nav").getUpperNav(id=getLevel.idc) /> 
				<cfif oben EQ 0>
					<cfset level = 1 />
					<cfset tree = "#oben#,#getLevel.parentID#" />
				<cfelseif oben NEQ -1> 	
					<cfset oben2 = createObject("component","#session.serverpath#.inc.cfc.nav").getUpperNav(id=oben) />
					<cfif oben2 EQ 0>
						<cfset level = 2 />
						<cfset tree = "#oben#,#getLevel.idc#" />
					<cfelseif oben2 NEQ -1>
						<cfset oben3 = createObject("component","#session.serverpath#.inc.cfc.nav").getUpperNav(id=oben2) />
						<cfif oben3 EQ 0>
							<cfset level = 3 />
							<cfset tree = "#oben2#,#oben#,#getLevel.idc#" />
						<cfelseif oben3 NEQ -1>
							<cfset oben4 = createObject("component","#session.serverpath#.inc.cfc.nav").getUpperNav(id=oben3) />
							<cfif oben4 EQ 0>
								<cfset level = 4 />
								<cfset tree = "#oben3#,#oben2#,#oben#,#getLevel.idc#" />
							<cfelseif oben4 NEQ -1>
								<cfset oben5 = createObject("component","#session.serverpath#.inc.cfc.nav").getUpperNav(id=oben4) />
								<cfif oben5 EQ 0>
									<cfset level = 5 />
									<cfset tree = "#oben2#,#oben#,#oben3#,#oben4#,#getLevel.idc#" />
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
	
	<cffunction access="public" name="getFullNavTreeRightDependent" returntype="string" output="no">
		<cfargument name="tree" type="string" required="yes" />
		<CFARGUMENT name="usergroup" type="numeric" required="no" default="0" >
		<CFARGUMENT name="parentID" type="numeric" required="yes" >
		<CFARGUMENT name="level" type="numeric" required="yes" >
		<CFARGUMENT name="type" type="numeric" required="no" default=1 >
		<CFARGUMENT name="lang" type="string" required="no" default="#session.lang#" >
		<CFARGUMENT name="mandant" type="numeric" required="no" default="#session.mandant#" >
		<CFARGUMENT name="navpos" type="numeric" required="no" default=0 hint="0=service,1=themen" >
		
		<cfset fullTreeRightDependent = Replace(listAppend(arguments.tree,generateNav(navpos=arguments.navpos,ParentID=arguments.parentid,level=arguments.level,type=arguments.type,usergroup=arguments.usergroup,mandant=arguments.mandant,lang=arguments.lang)),url.id,"<strong>#url.id#</strong>") />

		<cfreturn fullTreeRightDependent />
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
				WHERE 	id = #i#
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
	
	
	<cffunction access="public" name="checkForSecured" returntype="string" output="no">
		<cfargument name="mandant" type="numeric" required="no" default="#session.mandant#" />
		
		<cfquery name="checkForSecured" datasource="#application.dsn#">
		SELECT 	P.id, P.pagetitel, P.navtitel
		FROM	pages P LEFT JOIN usergroups2pages G
				ON G.pageID = P.id
		WHERE	P.mandant = #arguments.mandant#
		GROUP	BY P.id
		ORDER	BY P.id
		</cfquery>
		
		<cfset retList = "" />
		
		<cfif checkForSecured.recordcount NEQ 0>
			<cfoutput query="checkForSecured">
				<cfset retList = listAppend(retList,id) />
			</cfoutput>
		</cfif>
		
		<cfreturn retList />
	</cffunction>

	<!--- -------------------------------------------------------------------------------------------------------------------------------------- --->
	
	
	<cffunction access="public" name="checkPermission" returntype="void" output="yes">
		<cfargument name="pageid" type="numeric" required="yes" />
		<cfargument name="loginState" type="numeric" required="no" default="0" />
		<cfargument name="loginUserGroup" type="numeric" required="no" default="0" />
		
		
		
		<cfset navTreeList = navtree(id=arguments.pageid)>
		<cfset navTreeListBelow = init.GenerateNav(ParentID=arguments.page, level=0, type = 2)>
		
		
		
		
	</cffunction>

	<!--- -------------------------------------------------------------------------------------------------------------------------------------- --->
	
	<cffunction name="GenerateNav" access="public" returntype="any">
		<CFARGUMENT name="usergroup" type="numeric" required="no" default="0" >
		<CFARGUMENT name="parentID" type="numeric" required="yes" >
		<CFARGUMENT name="level" type="numeric" required="yes" >
		<CFARGUMENT name="type" type="numeric" required="no" default=1 hint="1=ul-list,2=comma separated list,3=cf-struct,4=outputTemplate" >
		<CFARGUMENT name="lang" type="string" required="no" default="#session.lang#" >
		<CFARGUMENT name="mandant" type="numeric" required="no" default="#session.mandant#" >
		<CFARGUMENT name="navpos" type="numeric" required="no" default=0 hint="0=service,1=themen" >
		
		<cfquery name="qryNavigation" datasource="#application.dsn#">
		SELECT 	P.id,P.parentID,P.pagetitel as NavDescription,P.navorder,U.userGroupID,P.navpos,P.metadesc
		FROM	pages P LEFT JOIN usergroups2pages U ON U.pageID = P.id
		WHERE	P.mandant = #arguments.mandant# AND P.lang = '#arguments.lang#'
		GROUP 	BY P.id
		ORDER	BY P.id
		</cfquery>
		
		<!--- scoping the variables that need to have their values kept private to a particular instance of the function call... --->
		<CFSET var checkForKids = ""><!--- used to hold temporary check for children --->
		<CFSET var objNav = ""><!--- used to hold temporary subqueries --->
	   
		<!--- On our initial call to this function, we will purge the menustring and grab our navigation source query. --->
		<CFIF arguments.level eq 0>
			<CFSET variables.navigation = qryNavigation>
			<CFSET variables.menustring = "">
			<CFSET variables.menustring2 = "">
			<CFSET variables.menustring3 = "">
			<cfset variables.menustring4 = structNew() />
		</CFIF>
	   
		<!--- Retrieve all nav records from variables.navigation who are the children of our current parent --->
		<!--- Query nof Queries --->
		<CFQUERY name="objNav" dbtype="query">
			select 	* 
			from 	variables.navigation where parentid = <CFQUERYPARAM value="#arguments.parentid#" cfsqltype="CF_SQL_INTEGER"> 
					<cfif arguments.level EQ 0 AND arguments.parentid EQ 0>AND navpos = #arguments.navpos#</cfif>
			order 	by navorder
		</CFQUERY>
		<!--- write our current parent to the menustring... --->
		<CFSET variables.menustring = variables.menustring & "<UL>">
		<cfif arguments.level EQ 0>
			<cfsavecontent variable="variables.menustring3">
				<cfif arguments.navpos EQ 1>
					<UL id='mega-menu'>
				<cfelse>
					<UL>
				</cfif>
			</cfsavecontent>
			<!--- <CFSET variables.menustring3 = variables.menustring3 & "<UL id='mega-menu'>"> --->
		<cfelse>
			<CFSET variables.menustring3 = variables.menustring3 & "<UL>">
		</cfif>
		
		<!--- <cfif arguments.level EQ 1>	
					<cfsavecontent variable="variables.menustring3">
					#variables.menustring3#
					<li style="border:1px solid red;">
						<a href="#trim(application.com.nav.rewriteLinkById(id=objnav.id,lang=arguments.lang))#">
							#objNav.NavDescription#
						</a>
					</li>
					</cfsavecontent>
				</cfif> --->
		
		<!--- loop through this parent's children... --->
		<cfset cnt = 1 />
		<CFLOOP query="objNav">
		
				
				
				<!--- check if allowed without cug login --->	
				<cfquery name="getRight" datasource="#application.dsn#">
				SELECT * FROM usergroups2pages
				WHERE pageid = #objnav.id#
				</cfquery>
				<cfif getRight.recordcount NEQ 0 AND arguments.usergroup GT 0>
					<cfquery name="getRight2" dbtype="query">
					SELECT * FROM getRight
					WHERE usergroupid = #arguments.usergroup#
					</cfquery>
					<cfif getRight2.recordcount GT 0>
						<cfset allowed = 1 />
					<cfelse>
						<cfset allowed = 0 />
					</cfif>	
				<cfelseif getRight.recordcount NEQ 0 AND arguments.usergroup EQ 0>
					<cfset allowed = 0 />
				<cfelse>
					<cfset allowed = 1 />
				</cfif>
				<!--- check for children. If there are any, call this function recursively --->
				<CFQUERY name="checkForKids" dbtype="query">
					select * from variables.navigation where parentid = <CFQUERYPARAM value="#objNav.id#" cfsqltype="CF_SQL_INTEGER"> 
				</CFQUERY>
				<CFIF checkForKids.recordcount gt 0 AND (objNav.userGroupID EQ "" OR objnav.usergroupid EQ arguments.usergroup) AND allowed EQ 1><!--- this child has kids too! add it to the menustring, then make the recursive call... --->
					<CFSET variables.menustring = variables.menustring & "<LI>" & objNav.NavDescription >
					<CFSET variables.menustring2 = listAppend(variables.menustring2,objNav.id) >
					<cfsavecontent variable="variables.menustring3">
						#variables.menustring3#
						<cfif arguments.level EQ 1 AND cnt EQ 1>
							<CFQUERY name="checkForParent" dbtype="query">
								select * from variables.navigation where id = <CFQUERYPARAM value="#objNav.parentid#" cfsqltype="CF_SQL_INTEGER"> 
							</CFQUERY>
							<cfif arguments.navpos EQ 1>
								<li>
									<a href="#trim(application.com.nav.rewriteLinkById(id=objnav.parentid,lang=arguments.lang))#">
										#checkForParent.NavDescription#
									</a>
									<ul>
										<li>
											<div style="padding-left:16px;padding-right:16px;">
												#checkForParent.metadesc#
											</div>
										</li>
									</ul>
								</li>
							</cfif>
						</cfif>
						<li>
						<a href="#trim(rewriteLinkById(id=objnav.id))#" style="<cfif objnav.id EQ listLast(session.navtree)>text-decoration:underline;</cfif><cfif arguments.level EQ 4>padding-left:10px;</cfif>">
							#objNav.NavDescription#
						</a>
					</cfsavecontent>
					<!--- <CFSET GenerateNav(parentID = objNav.ID, level = arguments.level + 1) > --->
					<CFSET GenerateNav(parentID = objNav.ID, level = arguments.level + 1, navpos=arguments.navpos,type=arguments.type,usergroup=arguments.usergroup,mandant=arguments.mandant,lang=arguments.lang,usergroup=arguments.usergroup) >
				
				<CFELSEif allowed EQ 1><!--- this child is childless...just add it to the menustring... --->
					<CFSET variables.menustring = variables.menustring & "<LI>" & objNav.NavDescription >
					<CFSET variables.menustring2 = listAppend(variables.menustring2,objNav.id) >
					
					<cfsavecontent variable="variables.menustring3">
						#variables.menustring3#
						<cfif arguments.level EQ 1 AND cnt EQ 1>
							<CFQUERY name="checkForParent" dbtype="query">
								select * from variables.navigation where id = <CFQUERYPARAM value="#objNav.parentid#" cfsqltype="CF_SQL_INTEGER"> 
							</CFQUERY>
							<cfif arguments.navpos EQ 1>
								<li>
									<a href="#trim(application.com.nav.rewriteLinkById(id=objnav.id,lang=arguments.lang))#">
										#checkForParent.NavDescription#
									</a>
									<ul>
										<li>
											<div style="padding-left:16px;padding-right:16px;">
												#checkForParent.metadesc#
											</div>
										</li>
									</ul>
								</li>
							</cfif>
						</cfif>
						<li>
						<a href="#trim(rewriteLinkById(id=objnav.id))#" style="<cfif objnav.id EQ listLast(session.navtree)>text-decoration:underline;</cfif><cfif arguments.level EQ 3>margin-left:18px;</cfif>">
							#objNav.NavDescription#
						</a>
					</cfsavecontent>
					
				</CFIF>
				<!--- close the list item --->
				<CFSET variables.menustring = variables.menustring & "</LI>">
				<CFSET variables.menustring3 = variables.menustring3 & "</LI>">
				<cfset cnt = cnt + 1 />
		</CFLOOP>
		<!--- close the UL tag --->
		<CFSET variables.menustring = variables.menustring & "</UL>">
		<CFSET variables.menustring3 = variables.menustring3 & "</UL>">
		<!--- return final variable to the caller... --->
		<CFIF arguments.level eq 0>
			<cfif arguments.type EQ 2>
				<CFRETURN variables.menustring2>
			<cfelseif arguments.type EQ 4>
				<CFRETURN variables.menustring3>
			<cfelseif arguments.type EQ 3>
			
				
			
			
				<CFRETURN variables.menustring4>
			<cfelse>
				<CFRETURN variables.menustring>
			</cfif>		
		</CFIF>
	</cffunction>
	
</cfcomponent>