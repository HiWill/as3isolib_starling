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
package as3isolibstarling.display.scene
{
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.display.primitive.IsoPrimitive;
	import as3isolibstarling.geom.IsoMath;
	import as3isolibstarling.geom.Pt;
	import as3isolibstarling.graphics.IStroke;
	import as3isolibstarling.graphics.Stroke;
	
	import flash.display.Graphics;
	
	use namespace as3isolib_internal;
	
	/**
	 * IsoGrid provides a display grid in the X-Y plane.
	 */
	public class IsoGrid extends IsoPrimitive
	{
		////////////////////////////////////////////////////
		//	GRID SIZE
		////////////////////////////////////////////////////
		
		private var gSize:Array = [0, 0];
		
		/**
		 * Returns an array containing the width and length of the grid.
		 */
		public function get gridSize ():Array
		{
			return gSize;
		}
		
		/**
		 * Sets the number of grid cells in each direction respectively.
		 * 
		 * @param width The number of cells along the x-axis.
		 * @param length The number of cells along the y-axis.
		 * @param height The number of cells along the z-axis (currently not implemented).
		 */
		public function setGridSize (width:uint, length:uint, height:uint = 0):void
		{
			if (gSize[0] != width || gSize[1] != length || gSize[2] != height)
			{
				gSize = [width, length, height];
				invalidateSize();
			}
		}
		
		////////////////////////////////////////////////////
		//	CELL SIZE
		////////////////////////////////////////////////////
		
		private var cSize:Number;
		
		/**
		 * @private
		 */
		public function get cellSize ():Number
		{
			return cSize;
		}
		
		/**
		 * Represents the size of each grid cell.  This value sets both the width, length and height (where applicable) to the same size.
		 */
		public function set cellSize (value:Number):void
		{
			if (value < 2)
				throw new Error("cellSize must be a positive value greater than 2");
				
			if (cSize != value)
			{
				cSize = value;
				invalidateSize();
			}
		}
		
		////////////////////////////////////////////////////
		//	SHOW ORIGIN
		////////////////////////////////////////////////////
		
		private var bShowOrigin:Boolean = false;
		private var showOriginChanged:Boolean = false;
		
		/**
		 * The origin indicator located at 0, 0, 0.
		 */
		public function get origin ():IsoOrigin
		{
			if (!_origin)
				_origin = new IsoOrigin();
			
			return _origin;
		}
		
		/**
		 * @private
		 */
		public function get showOrigin ():Boolean
		{
			return bShowOrigin;
		}
		
		/**
		 * Flag determining if the origin is visible.
		 */
		public function set showOrigin (value:Boolean):void
		{
			if (bShowOrigin != value)
			{
				bShowOrigin = value;
				showOriginChanged = true;
				
				invalidateSize();
			}
		}
		
		////////////////////////////////////////////////////
		//	GRID STYLES
		////////////////////////////////////////////////////
		
		public function get gridlines ():IStroke
		{
			return IStroke(strokes[0]);
		}
		
		public function set gridlines (value:IStroke):void
		{
			strokes = [value];
		}
		
		////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoGrid (descriptor:Object = null)
		{
			super(descriptor);
			
			if (!descriptor)
			{
				showOrigin = true;
				gridlines = new Stroke(0, 0xCCCCCC, 0.5);
				
				cellSize = 25;
				setGridSize(5, 5);
			}
		}
		
		private var _origin:IsoOrigin;
		
		/**
		 * @inheritDoc
		 */
		override protected function renderLogic (recursive:Boolean = true):void
		{
			if (showOriginChanged)
			{
				if (showOrigin)
				{
					if (!contains(origin))
						addChildAt(origin, 0);
				}
				
				else
				{
					if (contains(origin))
						removeChild(origin);
				}
				
				showOriginChanged = false;
			}
			
			super.renderLogic(recursive);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var g:Graphics = mainContainer.graphics;
			g.clear();
			
			var stroke:IStroke = IStroke(strokes[0]);
			if (stroke)
				stroke.apply(g);
			
			var pt:Pt = new Pt();
			
			var i:int;
			var m:int = int(gridSize[0]);
			while (i <= m)
			{
				pt = IsoMath.isoToScreen(new Pt(cSize * i));
				g.moveTo(pt.x, pt.y);
				
				pt = IsoMath.isoToScreen(new Pt(cSize * i, cSize * gridSize[1]));
				g.lineTo(pt.x, pt.y);
				
				i++;
			}
			
			i = 0;
			m = int(gridSize[1]);
			while (i <= m)
			{
				pt = IsoMath.isoToScreen(new Pt(0, cSize * i));
				g.moveTo(pt.x, pt.y);
				
				pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], cSize * i));
				g.lineTo(pt.x, pt.y);
				
				i++;
			}
			
			//now add the invisible layer to receive mouse events
			pt = IsoMath.isoToScreen(new Pt(0, 0));
			g.moveTo(pt.x, pt.y);
			g.lineStyle(0, 0, 0);
			g.beginFill(0xFF0000, 0.0);
			
			pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], 0));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], cSize * gridSize[1]));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(0, cSize * gridSize[1]));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(0, 0));
			g.lineTo(pt.x, pt.y);
			g.endFill();
		}
	}
}