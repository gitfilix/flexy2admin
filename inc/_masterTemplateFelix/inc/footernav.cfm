<cfprocessingdirective pageencoding="utf-8" />
<ul>
	<cfoutput query="getFooterNav">
	<li>
		<a href="#trim(application.com.nav.rewriteLinkById(id=id,lang=lang))#">
			#navtitel#
		</a>
	 </li>
	</cfoutput>
</ul>