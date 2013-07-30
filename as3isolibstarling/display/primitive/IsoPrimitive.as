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
package as3isolibstarling.display.primitive
{
	import __AS3__.vec.Vector;
	
	import as3isolibstarling.core.IsoDisplayObject;
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.enum.RenderStyleType;
	import as3isolibstarling.events.IsoEvent;
	import as3isolibstarling.graphics.IFill;
	import as3isolibstarling.graphics.IStroke;
	import as3isolibstarling.graphics.SolidColorFill;
	import as3isolibstarling.graphics.Stroke;
	
	use namespace as3isolib_internal;
	
	/**
	 * IsoPrimitive is the base class for primitive-type classes that will make great use of Flash's drawing API.
	 * Developers should not directly instantiate this class but rather extend it or one of the other primitive-type subclasses.
	 */
	public class IsoPrimitive extends IsoDisplayObject implements IIsoPrimitive
	{
		////////////////////////////////////////////////////////////////////////
		//	CONSTANTS
		////////////////////////////////////////////////////////////////////////
		
		static public const DEFAULT_WIDTH:Number = 25;
		static public const DEFAULT_LENGTH:Number = 25;
		static public const DEFAULT_HEIGHT:Number = 25;
		
		//////////////////////////////////////////////////////
		// STYLES
		//////////////////////////////////////////////////////
		
		private var renderStyle:String = RenderStyleType.SOLID;
		
		/**
		 * @private
		 */
		public function get styleType ():String
		{
			return renderStyle;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set styleType (value:String):void
		{
			if (renderStyle != value)
			{
				renderStyle = value;
				invalidateStyles();
				
				if (autoUpdate)
					render();
			}
		}
		
		//////////////////////////////
		//	MATERIALS
		//////////////////////////////
		
			//	PROFILE STROKE
			//////////////////////////////
		
		private var pStroke:IStroke;
		
		public function get profileStroke ():IStroke
		{
			return pStroke;
		}
		
		public function set profileStroke (value:IStroke):void
		{
			if (pStroke != value)
			{
				pStroke = value;
				invalidateStyles();
				
				if (autoUpdate)
					render();
			}
		}
		
			//	MAIN FILL
			//////////////////////////////
		
		public function get fill ():IFill
		{
			return IFill(fills[0]);
		}
		
		public function set fill (value:IFill):void
		{
			fills = [value, value, value, value, value, value];
		}
		
			//	FILLS
			//////////////////////////////
		
		static protected const DEFAULT_FILL:IFill = new SolidColorFill(0xFFFFFF, 1);
		
		private var fillsArray:Vector.<IFill> = new Vector.<IFill>();
		
		/**
		 * @private
		 */
		public function get fills ():Array
		{
			var temp:Array = [];
			var f:IFill;
			for each (f in fillsArray)
				temp.push(f);
			
			return temp;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set fills (value:Array):void
		{
			if (value)
				fillsArray = Vector.<IFill>(value);
			
			else
				fillsArray = new Vector.<IFill>();
			
			invalidateStyles();
			
			if (autoUpdate)
				render();
		}
		
			//	MAIN STROKE
			//////////////////////////////
		
		public function get stroke ():IStroke
		{
			return IStroke(strokes[0]);
		}
		
		public function set stroke (value:IStroke):void
		{
			strokes = [value, value, value, value, value, value];
		}
		
			//	STROKES
			//////////////////////////////
		
		static protected const DEFAULT_STROKE:IStroke = new Stroke(0, 0x000000);
		
		private var edgesArray:Vector.<IStroke> = new Vector.<IStroke>();
		
		/**
		 * @private
		 */
		public function get strokes ():Array
		{
			var temp:Array = [];
			var s:IStroke;
			for each (s in edgesArray)
				temp.push(s);
			
			return temp;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set strokes (value:Array):void
		{
			if (value)
				edgesArray = Vector.<IStroke>(value);
			
			else
				edgesArray = new Vector.<IStroke>();
			
			invalidateStyles();
			
			if (autoUpdate)
				render();
		}
		
		/////////////////////////////////////////////////////////
		//	RENDER
		/////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override protected function renderLogic (recursive:Boolean = true):void
		{
			if (!hasParent && !renderAsOrphan)
				return;
			
			//we do this before calling super.render() so as to only perform drawing logic for the size or style invalidation, not both.
			if (bSizeInvalidated || bSytlesInvalidated)
			{
				if (!validateGeometry())
					throw new Error("validation of geometry failed.");
				
				drawGeometry();
				validateSize();
				
				bSizeInvalidated = false;
				bSytlesInvalidated = false;
			}
			
			super.renderLogic(recursive);
		}
		
		/////////////////////////////////////////////////////////
		//	VALIDATION
		/////////////////////////////////////////////////////////
		
		
		/**
		 * For IIsoDisplayObject that make use of Flash's drawing API, validation of the geometry must occur before being rendered.
		 * 
		 * @return Boolean Flag indicating if the geometry is valid.
		 */
		protected function validateGeometry ():Boolean
		{
			//overridden by subclasses
			return true;	
		}
		
		/**
		 * @inheritDoc
		 */
		protected function drawGeometry ():void
		{
			//overridden by subclasses
		}
		
		////////////////////////////////////////////////////////////
		//	INVALIDATION
		////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		as3isolib_internal var bSytlesInvalidated:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function invalidateStyles ():void
		{
			bSytlesInvalidated = true;
			
			if (!bInvalidateEventDispatched)
			{
				dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
				bInvalidateEventDispatched = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isInvalidated ():Boolean
		{
			return (bSizeInvalidated || bPositionInvalidated || bSytlesInvalidated);
		}
		
		////////////////////////////////////////////////////////////
		//	CLONE
		////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function clone ():*
		{
			var cloneInstance:IIsoPrimitive = super.clone() as IIsoPrimitive;
			cloneInstance.fills = fills;
			cloneInstance.strokes = strokes
			cloneInstance.styleType = styleType;
			
			return cloneInstance;
		}
		
		////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoPrimitive (descriptor:Object = null)
		{
			super(descriptor);
			
			if (!descriptor)
			{
				width = DEFAULT_WIDTH;
				length = DEFAULT_LENGTH;
				height = DEFAULT_HEIGHT;
			}
		}
		
	}
}