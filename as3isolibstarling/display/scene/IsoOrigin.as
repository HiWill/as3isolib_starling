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
	import as3isolibstarling.enum.IsoOrientation;
	import as3isolibstarling.geom.IsoMath;
	import as3isolibstarling.geom.Pt;
	import as3isolibstarling.graphics.IFill;
	import as3isolibstarling.graphics.IStroke;
	import as3isolibstarling.graphics.SolidColorFill;
	import as3isolibstarling.graphics.Stroke;
	import as3isolibstarling.utils.IsoDrawingUtil;
	
	import flash.display.Graphics;
	
	use namespace as3isolib_internal;
	
	/**
	 * IsoOrigin is a visual class that depicts the origin pt (typically at 0, 0, 0) with multicolored axis lines.
	 */
	public class IsoOrigin extends IsoPrimitive
	{
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var pt0:Pt = IsoMath.isoToScreen(new Pt(-1 * axisLength, 0, 0));
			var ptM:Pt;
			var pt1:Pt = IsoMath.isoToScreen(new Pt(axisLength, 0, 0));
			
			var g:Graphics = mainContainer.graphics;
			g.clear();
			
			//draw x-axis
			var stroke:IStroke = IStroke(strokes[0]);
			var fill:IFill = IFill(fills[0]);
			
			stroke.apply(g);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			
			g.lineStyle(0, 0, 0);
			g.moveTo(pt0.x, pt0.y);
			fill.begin(g);
			IsoDrawingUtil.drawIsoArrow(g, new Pt(-1 * axisLength, 0), 180, arrowLength, arrowWidth);
			fill.end(g);
			
			g.moveTo(pt1.x, pt1.y);
			fill.begin(g);
			IsoDrawingUtil.drawIsoArrow(g, new Pt(axisLength, 0), 0, arrowLength, arrowWidth);
			fill.end(g);
			
			//draw y-axis
			stroke = IStroke(strokes[1]);
			fill = IFill(fills[1]);
			
			pt0 = IsoMath.isoToScreen(new Pt(0, -1 * axisLength, 0));
			pt1 = IsoMath.isoToScreen(new Pt(0, axisLength, 0));
			
			stroke.apply(g);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			
			g.lineStyle(0, 0, 0);
			g.moveTo(pt0.x, pt0.y);
			fill.begin(g)
			IsoDrawingUtil.drawIsoArrow(g, new Pt(0, -1 * axisLength), 270, arrowLength, arrowWidth);
			fill.end(g);
			
			g.moveTo(pt1.x, pt1.y);
			fill.begin(g);
			IsoDrawingUtil.drawIsoArrow(g, new Pt(0, axisLength), 90, arrowLength, arrowWidth);
			fill.end(g);
			
			//draw z-axis
			stroke = IStroke(strokes[2]);
			fill = IFill(fills[2]);
			
			pt0 = IsoMath.isoToScreen(new Pt(0, 0, -1 * axisLength));
			pt1 = IsoMath.isoToScreen(new Pt(0, 0, axisLength));
			
			stroke.apply(g);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			
			g.lineStyle(0, 0, 0);
			g.moveTo(pt0.x, pt0.y);
			fill.begin(g)
			IsoDrawingUtil.drawIsoArrow(g, new Pt(0, 0, axisLength), 90, arrowLength, arrowWidth, IsoOrientation.XZ);
			fill.end(g);
			
			g.moveTo(pt1.x, pt1.y);
			fill.begin(g);
			IsoDrawingUtil.drawIsoArrow(g, new Pt(0, 0, -1 * axisLength), 270, arrowLength, arrowWidth, IsoOrientation.YZ);
			fill.end(g);
		}
		
		/**
		 * The length of each axis (not including the arrows).
		 */
		public var axisLength:Number = 100;
		
		/**
		 * The arrow length for each arrow found on each axis.
		 */
		public var arrowLength:Number = 20;
		
		/**
		 * The arrow width for each arrow found on each axis. 
		 * This is the total width of the arrow at the base.
		 */
		public var arrowWidth:Number = 3;
		
		/**
		 * Constructor
		 */
		public function IsoOrigin (descriptor:Object = null)
		{
			super(descriptor);
			
			if (!descriptor || !descriptor.hasOwnProperty("strokes"))
			{
				strokes =
				[
					new Stroke(0, 0xFF0000, 0.75),
					new Stroke(0, 0x00FF00, 0.75),
					new Stroke(0, 0x0000FF, 0.75)
				];
			}
				
			if (!descriptor || !descriptor.hasOwnProperty("fills"))
			{	
				fills =
				[
					new SolidColorFill(0xFF0000, 0.75),
					new SolidColorFill(0x00FF00, 0.75),
					new SolidColorFill(0x0000FF, 0.75)
				]
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width (value:Number):void
		{
			super.width = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set length (value:Number):void
		{
			super.length = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height (value:Number):void
		{
			super.height = 0;
		}
	}
}