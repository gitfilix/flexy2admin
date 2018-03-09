<cfprocessingdirective pageencoding="utf-8" />
<div class="about-page main grid-wrap">
	<!--- <cfif pageProperties.pageTitel NEQ "">
		<header class="grid col-full">
			<hr>
			<p class="fleft">
				<cfoutput>#pageProperties.pageTitel#</cfoutput>
			</p>
		</header>
	</cfif> --->
	<cfif pageProperties.template EQ 1 OR pageProperties.template EQ 3>
		<aside class="grid col-one-quarter mq2-col-full blog-sidebar">
			<cfinclude template="/#session.serverpath#/inc/sidebars.cfm">
		</aside>
	</cfif>
	<section class="grid col-three-quarters mq2-col-full">
		<cfinclude template="/#session.serverpath#/inc/headerpanel.cfm" />
		
		<cfoutput query="getcontent">
		
			<cfquery name="getVisibleStateInCaseOfTabedView" dbtype="query">
				SELECT * FROM getAllLinkedContentsFromPage
				WHERE	linkedContentID = #id#
			</cfquery>
			 
		
			<article id="content#currentrow#">	
			
				<cfsavecontent variable="mainContentView">
					<cfif titel NEQ "">
						<h2 class="fnc" style="<cfif currentrow EQ 1 OR getVisibleStateInCaseOfTabedView.recordcount EQ 1>border:0;margin-top:0;</cfif>">#titel#</h2>
					</cfif>
					<cfif bildname NEQ "">
						<cfswitch expression="#imagepos#">
							<cfcase value="0">
								<cfif  fliesstextspalten EQ 1>
									<figure style="float:left;margin-right:1.5em;width:30%;">
										<img src="/#session.serverpath#/upload/img/#bildname#" alt="" style="width:300px;">
										<figcaption>
											<span style="font-style:italic;">#imagecaption#</span>
										</figcaption>
									</figure> 
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfif  fliesstextspalten EQ 1>
									<figure style="float:right;margin-left:1.5em;width:30%;">
										<img src="/#session.serverpath#/upload/img/#bildname#" alt="" style="width:300px;">
										<figcaption>
											<span style="font-style:italic;">#imagecaption#</span>
										</figcaption>
									</figure> 
								</cfif>
							</cfcase>
							<cfcase value="2">
								<div style="margin-bottom:1.5em;">
									<img src="/#session.serverpath#/upload/img/#bildname#" alt="" style="width:100%;">
									<span style="font-style:italic;">#imagecaption#</span>
								</div>
							</cfcase>
							<cfdefaultcase>
								<figure style="float:left;margin-right:1.5em;width:30%;">
									<img src="/#session.serverpath#/upload/img/#bildname#" alt="" style="width:300px;">
								</figure> 
							</cfdefaultcase>
						</cfswitch>
					</cfif>
					
					<cfif  fliesstextspalten GT 1 AND imagepos LT 2>
						<figure style="float:<cfif imagepos EQ 0>left<cfelseif imagepos EQ 1>right</cfif>;margin-right:1.5em;width:30%;">
							<img src="/#session.serverpath#/upload/img/#bildname#" alt="" style="width:300px;">
							<figcaption>
								<span style="font-style:italic;">#imagecaption#</span>
							</figcaption>
						</figure> 
					</cfif>
					<cfif lead NEQ "">
						<p class="lead fnc">#lead#</p>
					</cfif>
					<cfif  fliesstextspalten GT 1>
						<div style="clear:both;">&nbsp;</div>
					</cfif>
					<cfif fliesstext NEQ "" AND fliesstext NEQ "<br />">
						<div class="flexyCols-#fliesstextspalten# fnc fnc-content-#id#">
							<p>
								#fliesstext#
							</p>	
						</div>	
						<br/>
					</cfif>
					<cfquery name="getLinksAdded" datasource="#application.dsn#">
					SELECT 	*
					FROM	links2pages
					WHERE	contentid = #id#
					</cfquery>
					<cfif getLinksAdded.recordcount GT 0 OR href NEQ "">
					<br/>
					<h3 style="margin-bottom:0.2em;">Weiterführende Links</h3>
					</cfif>
					<cfif getLinksAdded.recordcount GT 0 OR href NEQ "">
					<ul>
						<cfif href NEQ "">	
							<li>
								<a href="#href#" target="_blank" style="display:block;">
									<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #hreflabel#
								</a>
							</li>
						</cfif>
						<cfif getLinksAdded.recordcount GT 0>
							<cfloop query="getLinksAdded">
								<li>
									<a href="#href#" target="_blank" style="display:block;">
										<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #hreflabel#
									</a>
								</li>
							</cfloop>
						</cfif>
					</ul>
					<br/>
					</cfif>
					<cfquery name="getDocsAdded" datasource="#application.dsn#">
					SELECT 	*
					FROM	docs2pages
					WHERE	contentid = #id#
					</cfquery>
					<cfif getDocsAdded.recordcount GT 0 OR doc NEQ "">
					<br/>
					<h3 style="margin-bottom:0.2em;">Dokumente / Downloads</h3>
					</cfif>
					<cfif getLinksAdded.recordcount GT 0 OR doc NEQ "">
					<ul>
					<cfif doc NEQ "">	
						<li>
							<a href="/#session.serverpath#/upload/doc/#doc#" target="_blank" style="display:block;">
								<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #doclabel#
							</a>
						</li>
					</cfif> 
					<cfif getDocsAdded.recordcount GT 0>
						<cfloop query="getDocsAdded">
							<li>
								<a href="#dok#" target="_blank" style="display:block;">
									<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #doklabel# (#ucase(listLast(getContent.doc,'.'))#, #decimalFormat(size/1000000)# MB.)
								</a>
							</li>
						</cfloop>
					</cfif>
					</ul>	
					<br/>
					</cfif>
					<cfinclude template="/#session.serverpath#/inc/gallery.cfm">	
					<cfif customInclude NEQ "" AND fileExists(expandPath('/#session.serverpath#/inc/custom/' & customInclude))>
						<br/>
						<cfinclude template="/#session.serverpath#/inc/custom/#customInclude#">
					</cfif>	
				</cfsavecontent>
			
				
				<!--- switch between tab and default view --->
				<cfquery name="getAllLinkedContents" datasource="#application.dsn#">
				SELECT 	linkedContentID,mainContentID
				FROM 	contents2content
				WHERE 	mainContentID = #id#
				ORDER	BY reihenfolge
				</cfquery>

				<!--- tabed view --->
				<cfif getAllLinkedContents.recordcount GT 0>
					
					<ul class="tabs clearfix">
						<li class="active">
							<a href="##tab#currentrow#"><cfif getAllLinkedContents.recordcount LTE 2>#titel#<cfelse>1</cfif></a>
						</li>
					
						<cfset cnt = currentrow & "1" />
						<cfset contentStruct = structNew() />
						<cfloop query="getAllLinkedContents">
							<cfquery name="getActivePage" datasource="#application.dsn#">
							SELECT 	*
							FROM 	content
							WHERE 	id = #linkedContentID# AND
									isActive = 1
							</cfquery>
						
							<cfif getActivePage.recordcount EQ 1>
								<li>
									<a href="##tab#cnt#"><cfif getAllLinkedContents.recordcount LTE 2>#getActivePage.titel#<cfelse>#cnt#</cfif></a>
								</li>	
								
								<cfsavecontent variable="contentStruct.id_#linkedContentID#">
									<h2 style="border:0;margin-top:0;">#getActivePage.titel#</h2>
									<cfif getActivePage.bildname NEQ "">
										<cfswitch expression="#getActivePage.imagepos#">
											<cfcase value="0">
												<cfif  getActivePage.fliesstextspalten EQ 1>
													<figure style="float:left;margin-right:1.5em;width:30%;">
														<img src="/#session.serverpath#/upload/img/#getActivePage.bildname#" alt="" style="width:300px;">
														<figcaption>
															<span style="font-style:italic;">#getActivePage.imagecaption#</span>
														</figcaption>
													</figure> 
												</cfif>
											</cfcase>
											<cfcase value="1">
												<cfif  getActivePage.fliesstextspalten EQ 1>
													<figure style="float:right;margin-left:1.5em;width:30%;">
														<img src="/#session.serverpath#/upload/img/#getActivePage.bildname#" alt="" style="width:300px;">
														<figcaption>
															<span style="font-style:italic;">#getActivePage.imagecaption#</span>
														</figcaption>
													</figure> 
												</cfif>
											</cfcase>
											<cfcase value="2">
												<div style="margin-bottom:1.5em;">
													<img src="/#session.serverpath#/upload/img/#getActivePage.bildname#" alt="" style="width:100%;">
													<span style="font-style:italic;">#getActivePage.imagecaption#</span>
												</div>
											</cfcase>
											<cfdefaultcase>
												<figure style="float:left;margin-right:1.5em;width:30%;">
													<img src="/#session.serverpath#/upload/img/#getActivePage.bildname#" alt="" style="width:300px;">
												</figure> 
											</cfdefaultcase>
										</cfswitch>
									</cfif>
									<div class="flexyCols-#getActivePage.fliesstextspalten#">
										<p>
											#getActivePage.fliesstext#
										</p>	
									</div>	
									<!--- wieder entrfernen weil doppelt --->
									<cfquery name="getLinksAdded" datasource="#application.dsn#">
									SELECT 	*
									FROM	links2pages
									WHERE	contentid = #id#
									</cfquery>
									<cfif getLinksAdded.recordcount GT 0 OR getActivePage.href NEQ "">
									<br/>
									<h3 style="margin-bottom:0.2em;">Weiterführende Links</h3>
									</cfif>
									<ul>
										<cfif getActivePage.href NEQ "">	
											<li>
												<a href="#getActivePage.href#" target="_blank" style="display:block;">
													<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #getActivePage.hreflabel#
												</a>
											</li>
										</cfif>
										<cfif getLinksAdded.recordcount GT 0>
											<cfloop query="getLinksAdded">
												<li>
													<a href="#href#" target="_blank" style="display:block;">
														<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #hreflabel#
													</a>
												</li>
											</cfloop>
										</cfif>
									</ul>
									<cfquery name="getDocsAdded" datasource="#application.dsn#">
									SELECT 	*
									FROM	docs2pages
									WHERE	contentid = #getActivePage.id#
									</cfquery>
									<cfif getDocsAdded.recordcount GT 0 OR getActivePage.doc NEQ "">
									<br/>
									<h3 style="margin-bottom:0.2em;">Dokumente / Downloads</h3>
									</cfif>
									<ul>
									<cfif getActivePage.doc NEQ "">	
										<li>
											<a href="/#session.serverpath#/upload/doc/#getActivePage.doc#" target="_blank" style="display:block;">
												<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #getActivePage.doclabel#
											</a>
										</li>
									</cfif> 
									<cfif getDocsAdded.recordcount GT 0>
										<cfloop query="getDocsAdded">
											<li>
												<a href="#dok#" target="_blank" style="display:block;">
													<div style="width: 0; height: 0; border-top: 5px solid transparent;border-bottom: 5px solid transparent;border-left: 5px solid ##0078CF;float:left;margin-top:7px;margin-right:0.5em;"></div> #doklabel# (#ucase(listLast(getContent.doc,'.'))#, #decimalFormat(size/1000000)# MB.)
												</a>
											</li>
										</cfloop>
									</cfif>
									</ul>	
									<!--- <cfinclude template="/#session.serverpath#/inc/template#pageProperties.template#/inc/gallery.cfm">	 --->
									<cfif getActivePage.customInclude NEQ "" AND fileExists(expandPath('/#session.serverpath#/inc/custom/' & getActivePage.customInclude))>
										<br/>
										<cfinclude template="/#session.serverpath#/inc/custom/#getActivePage.customInclude#">
									</cfif>	
									<!--- wieder entrfernen weil doppelt --->
									
									<cfinclude template="/#session.serverpath#/inc/gallery.cfm">	
									
								</cfsavecontent>
								
								<cfset cnt = cnt + 1 />
							</cfif>
						</cfloop>
				
					</ul>
					<div class="tab_container">
					   	<article class="tab_content" id="tab#currentrow#">
							#mainContentView#
						</article>
						<cfset cnt = currentrow & "1" />
						<cfloop query="getAllLinkedContents">
							<cfif isdefined("contentStruct.id_" & linkedContentID)>
								<article class="tab_content" id="tab#cnt#" style="display: none;">
									<p>#evaluate("contentStruct.id_" & linkedContentID)#</p>
								</article>
								<cfset cnt = cnt + 1 />
							</cfif>
						</cfloop>
					</div>
				
				<!--- standard view --->
				<cfelse>
					<cfif getVisibleStateInCaseOfTabedView.recordcount EQ 0>
						#mainContentView#	
					</cfif>
				</cfif>
			</article>
		</cfoutput>
	</section>	
	<cfif pageProperties.template EQ 2 OR pageProperties.template EQ 3>
		<aside class="grid col-one-quarter mq2-col-full blog-sidebar">
			<cfinclude template="/#session.serverpath#/inc/sidebars.cfm">
		</aside>
	</cfif>
</div>