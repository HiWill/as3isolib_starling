/*

as3isolib - An open-source ActionScript 3.0 Isometric Library developed to assist 
in creating isometrically projected content (such as games and graphics) 
targeted for the Flash player platform

http://code.google.com/p/as3isolib/

Copyright (c) 2006 - 3000 J.W.Opitz, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package as3isolibstarling.events
{ 
	import starling.events.Event;

	/**
	 * The IsoEvent class represents the event object passed to the listener for various isometric display events.
	 */
	public class IsoEvent extends Event
	{
		/////////////////////////////////////////////////////////////
		//	CONST
		/////////////////////////////////////////////////////////////
		
		/**
		 * The IsoEvent.INVALIDATE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const INVALIDATE:String = "as3isolib_invalidate";
		
		/**
		 * The IsoEvent.RENDER constant defines the value of the type property of the event object for an iso event.
		 */
		static public const RENDER:String = "as3isolib_render";
		
		/**
		 * The IsoEvent.RENDER_COMPLETE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const RENDER_COMPLETE:String = "as3isolib_renderComplete";
		
		/**
		 * The IsoEvent.MOVE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const MOVE:String = "as3isolib_move";
		
		/**
		 * The IsoEvent.RESIZE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const RESIZE:String = "as3isolib_resize";
		
		/**
		 * The IsoEvent.CHILD_ADDED constant defines the value of the type property of the event object for an iso event.
		 */
		static public const CHILD_ADDED:String = "as3isolib_childAdded";
		
		/**
		 * The IsoEvent.CHILD_REMOVED constant defines the value of the type property of the event object for an iso event.
		 */
		static public const CHILD_REMOVED:String = "as3isolib_childRemoved";
		
		/////////////////////////////////////////////////////////////
		//	DATA
		/////////////////////////////////////////////////////////////
		
		/**
		 * Specifies the property name of the property values assigned in oldValue and newValue.
		 */
		public var propName:String;
		
		/**
		 * Specifies the previous value assigned to the property specified in propName.
		 */
		public var oldValue:Object;
		
		/**
		 * Specifies the new value assigned to the property specified in propName.
		 */
		public var newValue:Object;
		
		/**
		 * Constructor
		 */
		public function IsoEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone ():Event
		{
			var evt:IsoEvent = new IsoEvent(type, bubbles);
			evt.propName = propName;
			evt.oldValue = oldValue;
			evt.newValue = newValue;
			
			return evt;
		}
	}
}