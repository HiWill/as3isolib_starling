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
package as3isolibstarling.geom
{
	import flash.geom.Point;
	
	/**
	 * Pt is an extension of the flash.geom.Point class providing a z coordinate for 3D pts.
	 */
	public class Pt extends Point
	{		
		///////////////////////////////////////////////
		//	CALCULATIONS
		///////////////////////////////////////////////
		
		/**
		 * Calculates the distance between two given pts.
		 * 
		 * @param ptA The first pt.
		 * @param ptB The second pt.
		 * @return Number The distance between the two pts.
		 */
		static public function distance (ptA:Pt, ptB:Pt):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;
			var tz:Number = ptB.z - ptA.z;
			
			return Math.sqrt(tx * tx + ty * ty + tz * tz);
		}
		
		/**
		 * Calculates the angle in radians between two given pts.
		 * The returned value is relative to the first pt.
		 * The returned value is only relative to rotations in the X-Y plane.
		 * 
		 * @param ptA The first pt.
		 * @param ptB The second pt.
		 * @return Number The angle in radians between the two pts.
		 */
		static public function theta (ptA:Pt, ptB:Pt):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;
			
			var radians:Number = Math.atan(ty / tx);
			if (tx < 0)
				radians += Math.PI;
			
			if (tx >= 0 && ty < 0)
				radians += Math.PI * 2;
				
			return radians;
		}
		
		/**
		 * Calculates the angle in degrees between two given pts.
		 * The returned value is relative to the first pt.
		 * The returned value is only relative to rotations in the X-Y plane.
		 * 
		 * @param ptA The first pt.
		 * @param ptB The second pt.
		 * @return Number The angle in degrees between the two pts.
		 */
		static public function angle (ptA:Pt, ptB:Pt):Number
		{
			return theta(ptA, ptB) * 180 / Math.PI;
		}
		
		/**
		 * Create a new pt relative to the origin pt.
		 * The returned value is relative to the first pt.
		 * The returned value is only relative to rotations in the X-Y plane.
		 * 
		 * @param originPt The pt of origin.
		 * @param radius The distance of the new pt relative to the originPt.
		 * @param theta The angle in radians of the new pt relative to the originPt.
		 * @return Pt The newly created pt.
		 */
		static public function polar (originPt:Pt, radius:Number, theta:Number = 0):Pt
		{
			var tx:Number = originPt.x + Math.cos(theta) * radius;
			var ty:Number = originPt.y + Math.sin(theta) * radius;
			var tz:Number = originPt.z
			
			return new Pt(tx, ty, tz);
		}
		
		/**
		 * Create a new pt between two given pts.
		 * The returned value is relative to the first pt.
		 * If f = 0 then the first pt is returned.
		 * If f = 1 then the second pt is returnd.
		 * 
		 * @param ptA The first pt.
		 * @param ptB The second pt.
		 * @param f The amount of interpolation relative to the first pt.
		 * @return Pt The newly created pt.
		 */
		static public function interpolate (ptA:Pt, ptB:Pt, f:Number):Pt
		{
			if (f <= 0)
				return ptA;
				
			if (f >= 1)
				return ptB;
				
			var nx:Number = (ptB.x - ptA.x) * f + ptA.x;	
			var ny:Number = (ptB.y - ptA.y) * f + ptA.y;	
			var nz:Number = (ptB.z - ptA.z) * f + ptA.z;
			
			return new Pt(nx, ny, nz);
		}
		
		///////////////////////////////////////////////
		//	X, Y, Z
		///////////////////////////////////////////////
		
		/**
		 * Represents the z value in 3D coordinate space.
		 */
		public var z:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		override public function get length ():Number
		{
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone ():Point
		{
			return new Pt(x, y, z);
		}
		
		///////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////
		
		/**
		 * Constructor
		 * 
		 * @param x The x value.
		 * @param y The y value.
		 * @param z The z value.
		 */
		public function Pt (x:Number = 0, y:Number = 0, z:Number = 0)
		{
			super();
			
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		override public function toString ():String
		{
			return "x:" + x + " y:" + y + " z:" + z;
		}
	}
}