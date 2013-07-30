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
	import as3isolibstarling.core.IsoDisplayObject;
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.display.scene.IIsoScene;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	use namespace as3isolib_internal;
	
	/**
	 * The DefaultSceneLayoutRenderer is the default renderer responsible for performing the isometric position-based depth sorting on the child objects of the target IIsoScene. 
	 */
	public class DefaultSceneLayoutRenderer implements ISceneLayoutRenderer
	{		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderScene (scene:IIsoScene):void
		{
			this.scene = scene;
			var startTime:uint = getTimer();
			
			// Rewrite #2 by David Holz, dependency version (naive for now)
			
			
			// TODO - cache dependencies between frames, only adjust invalidated objects, keeping old ordering as best as possible
			// IIsoDisplayObject -> [obj that should be behind the key]
			dependency = new Dictionary();
			
			// For now, use the non-rearranging display list so that the dependency sort will tend to create similar output each pass
			var children:Array = scene.displayListChildren;
			
			// Full naive cartesian scan, see what objects are behind child[i]
			// TODO - screen space subdivision to limit dependency scan
			var max:uint = children.length;
			for (var i:uint = 0; i < max; ++i)
			{
				var behind:Array = [];
				
				var objA:IsoDisplayObject = children[i];

				// TODO - direct access ("public var isoX" instead of "function get x") of the object's fields is a TON faster.
				//   Even "final function get" doesn't inline it to direct access, yielding the same speed as plain "function get".
				//   use namespaces to provide raw access?
				//   rename interface class = IsoDisplayObject, concrete class = IsoDisplayObject_impl with public fields?
				
				//var rightA:Number = objA.isoX + objA.isoWidth;
				//var frontA:Number = objA.isoY + objA.isoLength;
				//var topA:Number = objA.isoZ + objA.isoHeight;

				// TODO - getting bounds objects REALLY slows us down, too.  It creates a new one every time you ask for it!
				var rightA:Number = objA.x + objA.width;
				var frontA:Number = objA.y + objA.length;
				var topA:Number = objA.z + objA.height;
				
				for (var j:uint = 0; j < max; ++j)
				{
					var objB:IsoDisplayObject = children[j];
					
					if (collisionDetectionFunc != null)
						collisionDetectionFunc.call(null, objA, objB);
					
					// See if B should go behind A
					// simplest possible check, interpenetrations also count as "behind", which does do a bit more work later, but the inner loop tradeoff for a faster check makes up for it
					if ((objB.x < rightA) &&
					    (objB.y < frontA) &&
						(objB.z < topA) &&
						(i !== j))
					{
						behind.push(objB);
					}
				}
				
				dependency[objA] = behind;
			}
			
			//trace("dependency scan time", getTimer() - startTime, "ms");
			
			// TODO - set the invalidated children first, then do a rescan to make sure everything else is where it needs to be, too?  probably need to order the invalidated children sets from low to high index
			
			// Set the childrens' depth, using dependency ordering
			depth = 0;
			for each (var obj:IsoDisplayObject in children)
				if (true !== visited[obj])
					place(obj);
			
			// Clear out temporary dictionary so we're not retaining memory between calls
			visited = new Dictionary();
			
			// DEBUG OUTPUT
			
			//trace("--------------------");
			//for (i = 0; i < max; ++i)
			//	trace(dumpBounds(sortedChildren[i].isoBounds), dependency[sortedChildren[i]].length);
			
			//trace("scene layout render time", getTimer() - startTime, "ms (manual sort)");
		}
		
		// It's faster to make class variables & a method, rather than to do a local function closure
		private var depth:uint;
		private var visited:Dictionary = new Dictionary();
		private var scene:IIsoScene;
		private var dependency:Dictionary;
		
		/**
		 * Dependency-ordered depth placement of the given objects and its dependencies.
		 */
		private function place(obj:IsoDisplayObject):void
		{
			visited[obj] = true;
			
			for each(var inner:IsoDisplayObject in dependency[obj])
				if(true !== visited[inner])
					place(inner);
			
			if (depth != obj.depth)
			{
				scene.setChildIndex(obj, depth);
				//trace(".");
			}
			
			++depth;
		};
		
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
