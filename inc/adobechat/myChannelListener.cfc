
component extends="CFIDE.websocket.ChannelListener"
{

	public boolean function allowSubscribe(Struct subscriberInfo)
	{
                 if(subscriberInfo.agree)
			return true;
		 
		 return false;
	}
	
	public any function beforePublish(any message, Struct publisherInfo)
		{
			// Show server time also
			time = DateFormat(now(),"long");
			return message;
		}
		
	public any function beforeSendMessage(any message, Struct publisherInfo)
		{			
			try
			{
			  message  = time & ": <b>" & publisherInfo.connectionInfo.username & "  :</b>" & " <i>" & message & "</i>";
			}
			catch(Any e){
			// do nothing
		        }
		return message;
	      }
}

