<cfoutput query="getcontent">
	<cfif HASCONTACT EQ 1>
			<cfinclude template="contactform.cfm">
	<cfelse>
	<article class="content">
		<header>
			<!--- Print a Title --->	
			<cfif titel NEQ "">
					<h1>#titel#</h1>
			</cfif>
			
			<!---  PRint the lead --->
			<cfif lead NEQ "">
				<div>
				 	<h2>#lead#</h2>
				</div>	
			<cfelse>
					 <!--- 	 Print some hardcoded Lorem Ipsum ---> 
					Fusce varius purus id mauris feugiat vestibulum. Proin non sem purus, eget fringilla lorem. 
				
			</cfif>
		</header>
		
		 <!--- Show Content Image --->
		 <cfif bildname NEQ "">
			<figure class="image-left">
				<img src="/#session.serverpath#/upload/img/#bildname#" alt="alt tag" >
			</figure> 
		</cfif>
		<!--- Print out Fliesstext --->
		<cfif fliesstext NEQ "" AND fliesstext NEQ "<br>">
				<section>#fliesstext#</section>
		<cfelse>
		<!--- OR: Print some hardcoded LoremIpsum  --->
			 Praesent venenatis egestas enim, et tincidunt velit porta tempor! Quisque eu placerat leo!
		</cfif>
		<!--- Href link  --->
		<cfif href NEQ "">
			<br/><br/>
			<a href="#href#" target="_blank">
				#hreflabel#
			</a>
		</cfif>
		<!--- doc link --->
		<cfif doc NEQ "">
			<br/><br/>
			<a href="/#session.serverpath#/upload/doc/#doc#" target="_blank">
				#doclabel#
			</a><br/><br/>
		</cfif> 
	</article>
	</cfif> 
	<!--- include gallery, if there is one --->
	<cfif albumid NEQ 0>
		<cfinclude template="gallery.cfm">
	</cfif>
</cfoutput>