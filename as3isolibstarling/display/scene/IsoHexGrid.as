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
	import as3isolibstarling.geom.IsoMath;
	import as3isolibstarling.geom.Pt;
	import as3isolibstarling.graphics.IStroke;
	
	import flash.display.Graphics;
	
	/**
	 * @private
	 */
	public class IsoHexGrid extends IsoGrid
	{
		public function IsoHexGrid (descriptor:Object = null)
		{
			super(descriptor);
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
			
			var pt:Pt;
			var pts:Array = generatePts();
			for each (pt in pts)
				drawHexagon(pt, g);
		}
		
		private function generatePts ():Array
		{
			var pt:Pt;
			var pts:Array = [];
			
			var xOffset:Number = cellSize * Math.cos(Math.PI / 3);
			var yOffset:Number = cellSize * Math.sin(Math.PI / 3);
			
			var i:uint;
			var m:uint = uint(gridSize[0]);
			
			var j:uint;
			var n:uint = uint(gridSize[1]);
			while (j < n)
			{
				i = 0;
				
				while (i < m)
				{
					pt = new Pt();
					pt.x = i * (cellSize + xOffset);
					pt.y = j * yOffset * 2;
					if (i % 2 > 0)
						pt.y += yOffset;
					
					pts.push(pt);
					
					i++;
				}
				
				j++;
			}
			
			return pts;
		}
		
		private function drawHexagon (startPt:Pt, g:Graphics):void
		{
			var pt0:Pt = Pt(startPt.clone());
			var pt1:Pt = Pt.polar(pt0, cellSize, 0);
			var pt2:Pt = Pt.polar(pt1, cellSize, Math.PI / 3);
			var pt3:Pt = Pt.polar(pt2, cellSize, 2 * Math.PI / 3);
			var pt4:Pt = Pt.polar(pt3, cellSize, Math.PI);
			var pt5:Pt = Pt.polar(pt4, cellSize, 4 * Math.PI / 3);
			
			var pt:Pt;
			var pts:Array = new Array(pt0, pt1, pt2, pt3, pt4, pt5);
			
			for each (pt in pts)
				IsoMath.isoToScreen(pt);
			
			g.beginFill(0, 0);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			g.lineTo(pt2.x, pt2.y);
			g.lineTo(pt3.x, pt3.y);
			g.lineTo(pt4.x, pt4.y);
			g.lineTo(pt5.x, pt5.y);
			g.lineTo(pt0.x, pt0.y);
			g.endFill();
		}
	}
}