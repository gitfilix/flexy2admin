<cfoutput query="getContent">
<div id="specialcontent">	
		<figure>
			<cfif BILDNAME NEQ "">
					<img src="/#session.serverpath#/upload/img/#bildname#" alt="hi" />
			</cfif>
		</figure>
		<br />
		<p id="pic_desc">#IMAGECAPTION#</p>
</div>
</cfoutput>