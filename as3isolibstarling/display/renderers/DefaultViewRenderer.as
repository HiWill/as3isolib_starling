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
	import as3isolibstarling.display.IIsoView;
	import as3isolibstarling.display.scene.IIsoScene;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * The DefaultViewRenderer iterates through the target view's scene's child objects and determines if they reside within the visible area.
	 */
	public class DefaultViewRenderer implements IViewRenderer
	{
		////////////////////////////////////////////////////
		//	SCENES
		////////////////////////////////////////////////////
		
		private var scenesArray:Array = [];
		
		/**
		 * @private
		 */
		public function get scenes():Array
		{
			return scenesArray;
		}
		
		/**
		 * An array of target scenes to be rendered.  If this value's length is 0, then the target view's scenes are used.
		 */
		public function set scenes( value:Array ):void
		{
			scenesArray = value;
		}
		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderView( view:IIsoView ):void
		{
			var targetScenes:Array = ( scenesArray && scenesArray.length >= 1 ) ? scenesArray : view.scenes;
			if ( targetScenes.length < 1 )
				return;
			
			var v:Sprite = Sprite( view );
			var rect:Rectangle = new Rectangle( 0, 0, v.width, v.height );
			var bounds:Rectangle;
			
			var child:IIsoDisplayObject;
			var children:Array = [];
			
			//aggregate child objects
			var scene:IIsoScene;
			for each ( scene in targetScenes )
				children = children.concat( scene.children );
			
			for each ( child in children )
			{
				bounds = child.getBounds( v );
				bounds.width *= view.currentZoom;
				bounds.height *= view.currentZoom;
				
				//this may be causing run-time error out of bounds exceptions, moving to visible = internally on includeInLayout change
				child.includeInLayout = rect.intersects( bounds );
			}
		}
	}
}