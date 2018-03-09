<html>
	<head>
		
		<style>
			#wrapper {
				width:100%;
				height:100%;				
			}
			
			#messages {
				width: 100%;
				height:85%;
				padding-bottom: 10px;
				overflow: auto;
			}
			
			#newMessage {
				width: 99%;
				background-color: #a5d3e4;
				position: absolute;
				display: compact;
				margin-bottom: 35px;
				bottom:0px;
			}
			
			#userActions {
				width: 99%;
				position: absolute;
				bottom: 0px;
				
			}
			
			#usermsg {
				width: 80%;
				float:left;
				vertical-align: middle;
			}			
		</style>
	</head>
<body>
	<cfwebsocket name="socket"
	             onMessage ="messageHandler"
				 onOpen = "openHandler"
				 onClose = "closeHandler">
	<div id="wrapper">
		<div id="messages">
			
		</div>
		<div id="newMessage">
			<input type = "text" id="usermsg">
			<input type = "button" id="sendmsg" onClick="sendMessage()" value="Send Message" >
		</div>
		<div id="userActions" >
			<input type = "button" id="open" onClick="connect()" value="Open Connection">
			<input type = "button" id="close" onClick="disconnect()" value="Close Connection">
			<input type = "button" id="subscribe" onClick="subscribeToChannel()" value="Subscribe">
			<input type = "button" id="unsubscribe" onClick="unsubscribeFromChannel()" value="Unsubscribe">
		</div>
	</div>			  
</body>
<script type="text/javascript">
			function openHandler() {
				console.log('In open handler');
			}
			function closeHandler() {
				console.log('In close handler');
			}
			
			function messageHandler(msg) {
				if(msg.type == "response")
				{
					console.log('In message handler ' + msg.reqType);
				}
			}
			function connect() {
				socket.openConnection();
			}
			function disconnect() {
				socket.closeConnection();
			}
			function subscribeToChannel() {
				socket.subscribe("myChannel","",myChannelHandler);
			}
			function unsubscribeFromChannel() {
				socket.unsubscribe("myChannel");
			}
			function myChannelHandler(msg) {
				if(msg.type == 'data')
				document.getElementById("messages").innerHTML += msg.data + "<br>";
			}
			function sendMessage() {
				socket.publish("myChannel",document.getElementById("usermsg").value);
				document.getElementById("usermsg").value="";
			}
		</script>
</html>