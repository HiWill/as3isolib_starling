package as3isolibstarling.events 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author yf
	 */
	public interface IEventDispatcher 
	{
		 
		function addEventListener (type:String, listener:Function):void

		 
		function dispatchEvent (event:Event) :void;

		 
		function hasEventListener (type:String) : Boolean;

		 
		function removeEventListener(type:String, listener:Function):void
		
	}

}