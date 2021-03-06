
<!--- 
	We need to pass the Application name to the ColdFusion WebSocket 
	so that it knows which memory space to use. To use this, we'll 
	pass it through with the HTML element. 
--->
<cfset appName = getApplicationMetaData().name />


	
	<!-- Load the demo styles. -->
	<style type="text/css">
		
		div.chatWindow {
			border: 1px solid #666666 ;
			height: 200px ;
			overflow: hidden ;
			position: relative ;
			width: 450px ;
			background-color:white;
			}
			
		ol.chatHistory {
			bottom: 0px ;
			left: 0px ;
			margin: 0px 0px 0px 0px ;
			padding: 0px 0px 0px 0px ;
			position: absolute ;
			right: 0px ;
			}
			
		ol.chatHistory li {
			border-top: 1px solid #CCCCCC ;
			margin: 0px 0px 0px 0px ;
			padding: 5px 5px 5px 5px ;
			}
			
		ol.chatHistory li.event {
			color: #999999 ;
			font-style: italic ;
			}
			
		ol.chatHistory span.handle {
			font-weight: bold ;	
			margin-right: 10px ;	
			}
			
		ol.chatHistory span.message {}
			
		form {
			margin: 10px 0px 0px 0px ;
			}
			
		input.handle {
			font-size: 16px ;
			width: 100px ;
			}
			
		input.message {
			font-size: 16px ;
			width: 275px ;		
			}
			
		input.submit {
			font-size: 16px ;		
			}
		
		p.chatSize {
			color: #999999 ;
			font-size: 13px ;
			font-style: italic ;
			}
		
	</style>
	
	<!--
		Load the script loader and boot-strapping code. In this 
		demo, the "main" JavaScript file acts as a Controller for 
		the following Chat interface.
	-->
	<script 
		type="text/javascript"
		src="/admin/inc/chat/js/lib/require/require.js" 
		data-main="/admin/inc/chat/js/main">
	</script>

	
	<h1>
		Flexy Support-Anfrage
	</h1>
	
	<div class="chatWindow">
		<ol class="chatHistory">
			<!-- Chat history will be populated dynamically. -->
		</ol>
	</div>
	
	<form class="chatMessage">
		<input type="text" name="handle" class="handle" />
		<input type="text" name="message" class="message" />
		<input type="submit" value="Senden" class="submit" />
	</form>
	
	<p class="chatSize">
		Benutzer im Chat: <span class="count">0</span>
	</p>
	




















