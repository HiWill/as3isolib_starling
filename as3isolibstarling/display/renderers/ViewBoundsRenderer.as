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
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ViewBoundsRenderer is used to draw bounding rectangles to a target graphics object based on the location of the IIsoView's scene's child object relative to the IIsoView.
	 */
	public class ViewBoundsRenderer implements IViewRenderer
	{
		/**
		 * Flag indicating if all children or only those present in the display list has their bounds drawn.
		 */
		public var drawAll:Boolean = true;
		
		/**
		 * The target graphics to draw the IIsoView's scene's child objects.  Default value is <code>null</code>.
		 */
		public var targetGraphics:Graphics;
		
		/**
		 * The line thickness of the bounding rectangles being drawn.  Default value is 0.
		 */
		public var lineThickness:Number = 0;
		
		/**
		 * The line color of the bounding rectangles being drawn.  Default value is 0xFF0000.
		 */
		public var lineColor:uint = 0xff0000;
		
		/**
		 * The line alpha of the bounding rectangles being drawn.  Default value is 1.
		 */
		public var lineAlpha:Number = 1.0;
		
		/**
		 *
		 */
		public var targetScenes:Array;
		
		/**
		 * @inheritDoc
		 */
		public function renderView (view:IIsoView):void
		{
			if (!targetScenes || targetScenes.length < 1)
				targetScenes = view.scenes;
							
			var v:Sprite = Sprite(view);
			
			var g:Graphics = targetGraphics ? targetGraphics : v.graphics;
			g.clear();
			g.lineStyle(lineThickness, lineColor, lineAlpha);
			
			var bounds:Rectangle;
			var child:IIsoDisplayObject;
			var children:Array = [];
			
			//aggregate child objects
			var scene:IIsoScene;
			for each (scene in targetScenes)
				children = children.concat(scene.children);
				
			for each (child in children)
			{
				if (drawAll || child.includeInLayout)
				{
					bounds = child.getBounds(v);
					bounds.width *= view.currentZoom;
					bounds.height *= view.currentZoom;
					
					g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				}
			}
		}
	}
}