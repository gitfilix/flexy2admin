component
{
	this.name = "helloworld";
        this.wschannels = [{name="world" ,cfclistener="myChannelListener"}];
        
        function  onWSAuthenticate(String username, String password, Struct connectionInfo)
	{
	    // Put some authentication logic here
	    // Adding the user name to the connection info
	    connectionInfo.username=username;
	    return true;
        }
}
