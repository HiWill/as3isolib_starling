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
package as3isolibstarling.geom.transformations
{
	import as3isolibstarling.geom.Pt;
	
	/**
	 * The default isometric transformation object that provides the ideal 2:1 x to y ratio.
	 */
	public class DefaultIsometricTransformation implements IAxonometricTransformation
	{
		
		/**
		 * Constructor
		 * 
		 * @param projectValuesToAxonometricAxes A flag indicating whether to compute x, y, z, width, lenght, and height values to the axonometric axes or screen axes.
		 * @param maintainZaxisRatio A flag indicating if the z axis values are to be adjusted to maintain proportions based on the x &amp; axis values. 
		 */
		public function DefaultIsometricTransformation (projectValuesToAxonometricAxes:Boolean = false, maintainZAxisRatio:Boolean = false)
		{
			bAxonometricAxesProjection = projectValuesToAxonometricAxes;
			bMaintainZAxisRatio = maintainZAxisRatio;
		}
		
		private var radians:Number;
		private var ratio:Number = 2;
		
		private var bAxonometricAxesProjection:Boolean;
		private var bMaintainZAxisRatio:Boolean;
		
		private var axialProjection:Number = Math.cos(Math.atan(0.5));
		
		/**
		 * @inheritDoc
		 */
		public function screenToSpace (screenPt:Pt):Pt
		{
			var z:Number = screenPt.z;
			var y:Number = screenPt.y - screenPt.x / ratio + screenPt.z;
			var x:Number = screenPt.x / ratio + screenPt.y + screenPt.z;
			
			if (!bAxonometricAxesProjection && bMaintainZAxisRatio)
				z = z * axialProjection;
			
			if (bAxonometricAxesProjection)
			{
				x = x / axialProjection;
				y = y / axialProjection;
			}
			
			return new Pt(x, y, z);
		}
		
		/**
		 * @inheritDoc
		 */
		public function spaceToScreen (spacePt:Pt):Pt
		{
			if (!bAxonometricAxesProjection && bMaintainZAxisRatio)
				spacePt.z = spacePt.z / axialProjection;
			
			if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * axialProjection;
				spacePt.y = spacePt.y * axialProjection;
			}
			
			var z:Number = spacePt.z;
			var y:Number = (spacePt.x + spacePt.y) / ratio - spacePt.z;
			var x:Number = spacePt.x - spacePt.y;
			
			return new Pt(x, y, z);
		}
	}
}