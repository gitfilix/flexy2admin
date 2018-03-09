<cfcomponent output="yes" displayname="mag_remote"  >

	<cfheader statuscode="200" statustext="OK" />
	<cfcontent reset="true" type="application/javascript" />
	
	<cffunction name="getAllPages" access="remote" returnType="any" returnFormat="plain" output="yes">
		<cfargument name="callback" required="yes" />
		
		<cfsavecontent variable="x">
			<!--- get all elems from db --->
			<cfquery name="getAllElems" datasource="#application.dsn#">
			SELECT	*
			FROM	magazininhaltselemente
			WHERE	magazinPageID = 1 
			</cfquery>
			<cfquery name="getAllElems2" datasource="#application.dsn#">
			SELECT	*
			FROM	magazininhaltselemente
			WHERE	magazinPageID = 2
			</cfquery>
			<cfquery name="getAllElems3" datasource="#application.dsn#">
			SELECT	*
			FROM	magazininhaltselemente
			WHERE	magazinPageID = 3
			</cfquery>
			<div class="page page-1" title="Hollywood Stars">
				<section title="Tim Roth" style="background-image:url('/mirza-in-progress/img/mag_page1.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;" class="mainpage-1">
					<cfoutput query="getAllElems">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</section>
				<div class="subpage subpage-1-1" title="William H. Macy" style="background-image:url('/mirza-in-progress/img/mag_page2.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;">
					<cfoutput query="getAllElems2">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</div>
				<div class="subpage subpage-1-2" title="Vincent Gallo" style="background-image:url('/mirza-in-progress/img/mag_page3.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;">
					<cfoutput query="getAllElems">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</div>
				<div class="subpage subpage-1-3" title="Peter Stormare" style="background-image:url('/mirza-in-progress/img/mag_page4.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;">
					<cfoutput query="getAllElems">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</div>	
			</div> 
			<div class="page page-2" title="The Cure">
				<section title="Tim Roth" style="background-image:url('/mirza-in-progress/img/mag_page6.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;" class="mainpage-2">
					<cfoutput query="getAllElems">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</section>
				<div class="subpage subpage-2-1" title="William H. Macy" style="background-image:url('/mirza-in-progress/img/mag_page5.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;">
					<cfoutput query="getAllElems2">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</div>
				<div class="subpage subpage-2-2" title="Vincent Gallo" style="background-image:url('/mirza-in-progress/img/mag_page5.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;">
					<cfoutput query="getAllElems">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</div>
				<div class="subpage subpage-2-3" title="Peter Stormare" style="background-image:url('/mirza-in-progress/img/mag_page5.jpg');background-attachment:scroll !important;background-size: 800px 1280px;background-repeat: no-repeat;position:relative;">
					<cfoutput query="getAllElems">
						<div class="layoutElem" rel="#id#" style="overflow:scroll;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div>#content#</div></div>
					</cfoutput>
				</div>	
			</div> 
		</cfsavecontent>
		
		<cfset pages = queryNew("html", "varchar")>
		<cfset queryAddRow(pages, 1)>	
		<cfset querySetCell(pages, "html", x, 1)>
		<cfset data = "tabmag" & "(" & serializeJSON(pages) & ")">

		<cfreturn data />
	</cffunction>
	
	
</cfcomponent>