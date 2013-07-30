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
package as3isolibstarling.display.renderers
{
	import as3isolibstarling.bounds.IBounds;
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.display.IIsoView;
	import as3isolibstarling.display.scene.IIsoScene;
	import as3isolibstarling.errors.IsoError;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	/**
	 * @private
	 */
	public class SceneBlittingRenderer implements ISceneRenderer
	{
		////////////////////////////////////////////////////
		//	TARGET BITMAP OBJECT
		////////////////////////////////////////////////////
		
		private var _targetBitmap:Bitmap;
		private var _targetObject:Object
		
		/**
		 * @private
		 */
		public function get target ():Object
		{
			return _targetObject;
		}
		
		public function set target (value:Object):void
		{
			if (_targetObject != value)
			{
				_targetObject = value;
				
				if (_targetObject is Bitmap)
					_targetBitmap = Bitmap(_targetObject);
				
				else if (_targetObject.hasOwnProperty("bitmap"))
					_targetBitmap = Bitmap(_targetObject.bitmap);
				
				else
					throw new IsoError("");
			}
		}
		
		public var view:IIsoView;
		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderScene (scene:IIsoScene):void
		{
			if (!_targetBitmap)
				return;
			
			var sortedChildren:Array = scene.displayListChildren.slice(); //make a copy of the children
			sortedChildren.sort(isoDepthSort); //perform a secondary sort for any hittests
			
			var child:IIsoDisplayObject;
			var i:uint;
			var m:uint = sortedChildren.length;
			while (i < m)
			{
				child = IIsoDisplayObject(sortedChildren[i]);
				if (child.depth != i)
					scene.setChildIndex(child, i);
				
				i++;
			}
			
			var offsetMatrix:Matrix = new Matrix();
			offsetMatrix.tx = view.width / 2 - view.currentX;
			offsetMatrix.ty = view.height / 2 - view.currentY;
			
			var sceneBitmapData:BitmapData = new BitmapData(view.width, view.height, true, 0);
			sceneBitmapData.draw(scene.container, offsetMatrix);
			
			if (_targetBitmap.bitmapData)
				_targetBitmap.bitmapData.dispose();
				
			_targetBitmap.bitmapData = sceneBitmapData;
		}
		
		////////////////////////////////////////////////////
		//	SORT
		////////////////////////////////////////////////////
		
		private function isoDepthSort (childA:Object, childB:Object):int
		{
			var boundsA:IBounds = childA.isoBounds;
			var boundsB:IBounds = childB.isoBounds;
			
			if (boundsA.right <= boundsB.left)
				return -1;
				
			else if (boundsA.left >= boundsB.right)
				return 1;
			
			else if (boundsA.front <= boundsB.back)
				return -1;
				
			else if (boundsA.back >= boundsB.front)
				return 1;
				
			else if (boundsA.top <= boundsB.bottom)
				return -1;
				
			else if (boundsA.bottom >= boundsB.top)
				return 1;
			
			else
				return 0;
		}
	}
}