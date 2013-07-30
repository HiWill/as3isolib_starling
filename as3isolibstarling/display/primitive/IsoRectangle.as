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
	import as3isolibstarling.geom.IsoMath;
	import as3isolibstarling.geom.Pt;
	
	/**
	 * 3D square primitive in isometric space.
	 */
	public class IsoRectangle extends IsoPolygon
	{
		/**
		 * @inheritDoc
		 */
		override protected function validateGeometry ():Boolean
		{
			pts = [];
			pts.push(new Pt(0, 0, 0));
			
			//width x length
			if (width > 0 && length > 0 && height <= 0)
			{
				pts.push(new Pt(width, 0, 0));
				pts.push(new Pt(width, length, 0));
				pts.push(new Pt(0, length, 0));
			}
			
			//width x height
			else if (width > 0 && length <= 0 && height > 0)
			{
				pts.push(new Pt(width, 0, 0));
				pts.push(new Pt(width, 0, height));
				pts.push(new Pt(0, 0, height));
			}
			
			//length x height
			else if (width <= 0 && length > 0 && height > 0)
			{
				pts.push(new Pt(0, length, 0));
				pts.push(new Pt(0, length, height));
				pts.push(new Pt(0, 0, height));
			}
			
			else
				return false;
				
			var pt:Pt;
			for each (pt in pts)
				IsoMath.isoToScreen(pt);
				
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			super.drawGeometry();
			
			//clean up
			geometryPts = [];
		}
		
		/**
		 * Constructor
		 */
		public function IsoRectangle (descriptor:Object = null)
		{
			super(descriptor);
			
			if (!descriptor)
				width = length = height = 0;
		}
	}
}