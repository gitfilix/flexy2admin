<cfprocessingdirective pageencoding="utf-8" />
<div class="subnav">
	<ul>
		<cfoutput query="getsubnav">
		<li <cfif id EQ listLast(session.navtree)>class="sub-active"</cfif>>
			<a href="#trim(application.com.nav.rewriteLinkById(id=id,lang=lang))#">
				#pagetitel#
			</a>
		</li>
		</cfoutput>
	</ul>
</div>