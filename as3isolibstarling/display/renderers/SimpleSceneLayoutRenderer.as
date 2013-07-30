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
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.display.scene.IIsoScene;

	public class SimpleSceneLayoutRenderer implements ISceneLayoutRenderer
	{
		/**
		 * Array of propert names to sort scene's children by.  The default value is <code>["y", "x", "z"]</code>.
		 */
		public var sortOnProps:Array = ["y", "x", "z"];
		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderScene (scene:IIsoScene):void
		{
			var children:Array = scene.displayListChildren.slice();
			children.sortOn(sortOnProps, Array.NUMERIC);
			
			var child:IIsoDisplayObject;
			
			var i:uint;
			var m:uint = children.length;
			while (i < m)
			{
				child = IIsoDisplayObject(children[i]);
				if (child.depth != i)
					scene.setChildIndex(child, i);
				
				i++;
			}
		}
		
		/////////////////////////////////////////////////////////////////
		//	COLLISION DETECTION
		/////////////////////////////////////////////////////////////////
		
		private var collisionDetectionFunc:Function = null;
		
		/**
		 * @inheritDoc
		 */
		public function get collisionDetection ():Function
		{
			return collisionDetectionFunc;
		}
		
		/**
		 * @private
		 */
		public function set collisionDetection (value:Function):void
		{
			collisionDetectionFunc = value;
		}	
	}
}