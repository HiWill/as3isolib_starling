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
package as3isolibstarling.bounds
{
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.geom.Pt;
	
	/**
	 * The IBounds implementation for Primitive-type classes
	 */
	public class PrimitiveBounds implements IBounds
	{
		////////////////////////////////////////////////////////////////
		//	W / L / H
		////////////////////////////////////////////////////////////////
		
		public function get volume ():Number
		{
			return _target.width * _target.length * _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	W / L / H
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get width ():Number
		{
			return _target.width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length ():Number
		{
			return _target.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get height ():Number
		{
			return _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	LEFT / RIGHT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get left ():Number
		{
			return _target.x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get right ():Number
		{
			return _target.x + _target.width;
		}
		
		////////////////////////////////////////////////////////////////
		//	BACK / FRONT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get back ():Number
		{
			return _target.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get front ():Number
		{
			return _target.y + _target.length;
		}
		
		////////////////////////////////////////////////////////////////
		//	BOTTOM / TOP
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get bottom ():Number
		{
			return _target.z;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get top ():Number
		{
			return _target.z + _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	CENTER PT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get centerPt ():Pt
		{
			var pt:Pt = new Pt();
			pt.x = _target.x + _target.width / 2;
			pt.y = _target.y + _target.length / 2;
			pt.z = _target.z + _target.height / 2;
			
			return pt;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPts ():Array
		{
			var a:Array = [];
			
			a.push(new Pt(left, back, bottom));
			a.push(new Pt(right, back, bottom));
			a.push(new Pt(right, front, bottom));
			a.push(new Pt(left, front, bottom));
			
			a.push(new Pt(left, back, top));
			a.push(new Pt(right, back, top));
			a.push(new Pt(right, front, top));
			a.push(new Pt(left, front, top));
			
			return a;
		}
		
		////////////////////////////////////////////////////////////////
		//	COLLISION
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function intersects (bounds:IBounds):Boolean
		{
			if (Math.abs(centerPt.x - bounds.centerPt.x) <= _target.width / 2 + bounds.width / 2 &&
				Math.abs(centerPt.y - bounds.centerPt.y) <= _target.length / 2 + bounds.length / 2 &&
				Math.abs(centerPt.z - bounds.centerPt.z) <= _target.height / 2 + bounds.height / 2)
				
				return true;
			
			else
				return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsPt (target:Pt):Boolean
		{
			if ((left <= target.x && target.x <= right) &&
				(back <= target.y && target.y <= front) &&
				(bottom <= target.z && target.z <= top))
			{
				return true;
			}
			
			else
				return false;
		}
		
		private var _target:IIsoDisplayObject;
		
		////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function PrimitiveBounds (target:IIsoDisplayObject)
		{
			this._target = target;
		}
	}
}