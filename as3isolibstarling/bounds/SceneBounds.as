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
	import as3isolibstarling.display.scene.IIsoScene;
	import as3isolibstarling.geom.Pt;

	/**
	 * The IBounds implementation for IIsoScene implementors.
	 */
	public class SceneBounds implements IBounds
	{
		public function get volume ():Number
		{
			return width * length * height;
		}
		
		////////////////////////////////////////////////////////////////
		//	W / L / H
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get width ():Number
		{
			return _right - _left;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length ():Number
		{
			return _front - _back;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get height ():Number
		{
			return _top - _bottom;
		}
		
		////////////////////////////////////////////////////////////////
		//	LEFT / RIGHT
		////////////////////////////////////////////////////////////////
		
		private var _left:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get left ():Number
		{
			return _left;
		}
		
		private var _right:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get right ():Number
		{
			return _right;
		}
		
		////////////////////////////////////////////////////////////////
		//	BACK / FRONT
		////////////////////////////////////////////////////////////////
		
		private var _back:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get back ():Number
		{
			return _back;
		}
		
		private var _front:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get front ():Number
		{
			return _front;
		}
		
		////////////////////////////////////////////////////////////////
		//	TOP / BOTTOM
		////////////////////////////////////////////////////////////////
		
		private var _bottom:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get bottom ():Number
		{
			return _bottom;
		}
		
		private var _top:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get top ():Number
		{
			return _top
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
			pt.x = (_right - _left) / 2;
			pt.y = (_front - _back) / 2;
			pt.z = (_top - _bottom) / 2;
			
			return pt;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPts ():Array
		{
			var a:Array = [];
			
			a.push(new Pt(_left, _back, _bottom));
			a.push(new Pt(_right, _back, _bottom));
			a.push(new Pt(_right, _front, _bottom));
			a.push(new Pt(_left, _front, _bottom));
			
			a.push(new Pt(_left, _back, _top));
			a.push(new Pt(_right, _back, _top));
			a.push(new Pt(_right, _front, _top));
			a.push(new Pt(_left, _front, _top));
			
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
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsPt (target:Pt):Boolean
		{
			if ((_left <= target.x && target.x <= _right) &&
				(_back <= target.y && target.y <= _front) &&
				(_bottom <= target.z && target.z <= _top))
			{
				return true;
			}
			
			else
				return false;
		}
		
		////////////////////////////////////////////////////////////////
		//	_target
		////////////////////////////////////////////////////////////////
		
		private var _target:IIsoScene;
		
		////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function SceneBounds (target:IIsoScene)
		{
			this._target = target;
			calculateBounds();					
		}
		
		////////////////////////////////////////////////////////////////
		//	EXCLUDE ANIMATED
		////////////////////////////////////////////////////////////////
		
		private var excludeAnimated:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function get excludeAnimatedChildren ():Boolean
		{
			return excludeAnimated;
		}
		
		/**
		 * Flag indicating to exclude animated child objects when calculating the scene's bounds.
		 */
		public function set excludeAnimatedChildren (value:Boolean):void
		{
			excludeAnimated = value;
			calculateBounds();
		}
		
		private function calculateBounds ():void
		{
			var child:IIsoDisplayObject;
			for each (child in _target.displayListChildren)
			{
				if (excludeAnimated && child.isAnimated)
					continue;	
				
				if (isNaN(_left) || child.isoBounds.left < _left)
					_left = child.isoBounds.left;
				
				if (isNaN(_right) || child.isoBounds.right > _right)
					_right = child.isoBounds.right;
				
				if (isNaN(_back) || child.isoBounds.back < _back)
					_back = child.isoBounds.back;
				
				if (isNaN(_front) || child.isoBounds.front > _front)
					_front = child.isoBounds.front;
					
				if (isNaN(_bottom) || child.isoBounds.bottom < _bottom)
					_bottom = child.isoBounds.bottom;
					
				if (isNaN(_top) || child.isoBounds.top > _top)
					_top = child.isoBounds.top;
			}
			
			if (isNaN(_left))
				_left = 0;
				
			if (isNaN(_right))
				_right = 0;
			
			if (isNaN(_back))
				_back = 0;
			
			if (isNaN(_front))
				_front = 0;
			
			if (isNaN(_bottom))
				_bottom = 0;
				
			if (isNaN(_top))
				_top = 0;
		}
	}
}