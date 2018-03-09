component{

   public function getSubInfo()
   {

	info = ArrayNew(1);
	subInfo = WSGetSubscribers("world");
	getMappings = function(obj){
		ArrayAppend(info,obj["subscriberinfo"]["connectioninfo"]["USERNAME"]);
	};

	ArrayEach(subInfo,getMappings);
	return info;
   }
}