<script>
	var msgHandler = function(aToken)
	{
		    // Get data from the recieved message token
			var msg = aToken.data;
			if(msg instanceof Array){
				var usrtxt=document.getElementById("users");
				usrtxt.innerHTML = "Following users are also logged in: ";
				for (a=0;a< msg.length;a++){
				usrtxt.innerHTML +="<b>" + msg[a] + "</b>  |";
				}
				usrtxt.innerHTML += "<br>";
            }
			else
			{
				// If data is present write it to the div
				var msgtxt=document.getElementById("myDiv");
				msgtxt.innerHTML+= msg + "<br>";
			}
	}

	var defaultmsgHandler = function(aToken)
		{
			    // Get data from the recieved message token
				var data = aToken.data;
				var reqType = aToken.reqType
				if(reqType){
					if(reqType.indexOf("subscribe")!=-1)
					{
						// Now call invoke and invokeAndPublish
						myworld.invoke("invoke","getLoginTime");
						myworld.invokeAndPublish("world","getallclints","getSubInfo");
					}
				}
				if(data)
				{

					// If data is present write it to the div
					var txt=document.getElementById("timeCounter");
					txt.innerHTML= "You have Logged in for <b>" + data + "</b> sec<br>";
				}
	}

	var sayHello = function()
	{
		// Client says Hello World
		message = document.getElementById("message").value;
		myworld.publish("world",message);

		// Clear the tesxt field
		var m = document.getElementById('message');
		m.value="";
	}

	var iAgree = function()
	{
	    var chkbox= document.getElementById("check");
	    uname = document.getElementById("username").value;
		// Calling authenticate from client side. Calling this function will invoke onWSAuthenticate from Application.cfc
	    myworld.authenticate(uname,"password");
		// Explicitly subscribe here
		myworld.subscribe("world",{agree:chkbox.checked},msgHandler);

	}

	var openHandler = function()
	{
		// do nothing
	}

	var errorHandler = function(err)
	{
		var txt=document.getElementById("myDiv");
		txt.innerHTML= "<font size='5' color='red'><b>" + "An error has occured" + "</b></font><br>"
	}

</script>
<cfwebsocket name="myworld" onMessage="defaultmsgHandler" onOpen="openHandler" onError="errorHandler"/>
<table width="600" border="0">
    <tr >
        <td width="240">Hi I am <input  id="username" name="username" type="text" value="admin" >
        </td>
        <td> and <input id="eula" name="eula" type="textarea" value="I accept terms and conditions" >
        </td>
        <td><input  id="check" name="check" type="checkbox" ><input  id="agree" type="button" value="I Agree" onclick="iAgree();"><br><br>
        </td>
    </tr>
    <tr>
        <td align="right"><input  id="message" name="message" type="text" value="" onkeydown="if (event.keyCode == 13) sayHello(); ">
        </td>
        <td>
        </td>
        <td>
        </td>
    </tr>

</table>

<div id="wrapper" style="width:450px; float:left;height:450px;overflow:auto;">

	<div id="timeCounter"  style="text-align: center;width:400px;"></div>
	<div id="userswrapper" style="width:400px; float:left;height:400px;">
		<div id="myDiv" style="background:#C3FDB8;"></div>
	</div>
</div>
<div id="users" style="text-align: left;width:400px;vertical-align:middle;"></div>