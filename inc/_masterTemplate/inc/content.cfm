<cfoutput query="getcontent">
	<article>
		<header>
			<h1 style="font-size:1.2em;color:##ccc;">
				<cfif titel NEQ "">
					#titel#
				</cfif>
			</h1>
			<cfif lead NEQ "">
				<div style="font-style:italic;margin-bottom:1.3em;">
				<!---  PRint the lead --->
				 <h5>#lead#</h5>
				 <cfelse>
				 <!--- 	 Print some hardcoded Lorem Ipsum ---> 
				Fusce varius purus id mauris feugiat vestibulum. Proin non sem purus, eget fringilla lorem. 
				</div>
			</cfif>
		</header>
		<cfif bildname NEQ "">
			<figure class="image-left">
				<img src="/#session.serverpath#/upload/img/#bildname#" alt="" style="width:300px;">
			</figure> 
		</cfif>
		
		<cfif fliesstext NEQ "" AND fliesstext NEQ "<br>">
		<!--- Print out Fliesstext --->
			#fliesstext#
		<cfelse>
			<!--- Print some hardcoded LoremIpsum  --->
			Suspendisse potenti.Nullam felis lacus; iaculis eget cursus ac, varius vitae ante. Aliquam malesuada blandit quam, eu malesuada sapien placerat ut. Donec diam massa, euismod sed fermentum ut, viverra nec risus. Praesent auctor varius odio vitae ullamcorper! Curabitur leo urna, tempus at sagittis vel, molestie id est. Praesent venenatis egestas enim, et tincidunt velit porta tempor! Quisque eu placerat leo!
		</cfif>
		
		<cfif href NEQ "">
			<br/><br/>
			<a href="#href#" target="_blank">
				#hreflabel#
			</a>
		</cfif>
		
		<cfif doc NEQ "">
			<br/><br/>
			<a href="/#session.serverpath#/upload/doc/#doc#" target="_blank">
				#doclabel#
			</a><br/><br/>
		</cfif> 
		
	</article>
</cfoutput>