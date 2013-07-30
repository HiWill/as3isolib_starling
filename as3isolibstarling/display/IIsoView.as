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
package as3isolibstarling.display
{
	import as3isolibstarling.core.IInvalidation;
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.events.IEventDispatcher;
	import as3isolibstarling.geom.Pt;
	import starling.display.Sprite;
	
	import flash.geom.Point;
	
	/**
	 * The IIsoView interface defines methods necessary to properly perform panning, zooming and other display task for a given IIsoScene.
	 * The implementor normally wraps an IIsoScene with layout constraints.
	 */
	public interface IIsoView extends IEventDispatcher, IInvalidation
	{
		/**
		 * An array of all child scenes.
		 */
		function get scenes():Array;
		
		/**
		 * The number of scenes.
		 */
		function get numScenes():uint;
		
		/**
		 * This point is the coordinate position visually located at the center of the IIsoView relative to the scenes' host containers.
		 */
		function get currentPt():Pt;
		
		/**
		 * @private
		 */
		function get currentX():Number;
		
		/**
		 * The current x value of the coordintate position visually located at the center of the IIsoView relative to the scenes' host containers.
		 * This property is useful for targeting by tween engines.
		 *
		 * @see #currentPt
		 */
		function set currentX( value:Number ):void;
		
		/**
		 * @private
		 */
		function get currentY():Number;
		
		/**
		 * The current y value of the coordintate position visually located at the center of the IIsoView relative to the scenes' host containers.
		 * This property is useful for targeting by tween engines.
		 *
		 * @see #currentPt
		 */
		function set currentY( value:Number ):void;
		
		function localToIso( localPt:Point ):Pt;
		
		function isoToLocal( isoPt:Pt ):Point;
		
		/**
		 * Centers the IIsoView on a given pt within the current child scene objects.
		 *
		 * @param pt The pt to pan and center on.
		 * @param isIsometric A flag indicating wether the pt parameter represents a pt in 3D isometric space or screen coordinates.
		 */
		function centerOnPt( pt:Pt, isIsometric:Boolean = true ):void;
		
		/**
		 * Centers the IIsoView on a given IIsoDisplayObject within the current child scene objects.
		 *
		 * @param iso The IIsoDisplayObject to pan and center on.
		 */
		function centerOnIso( iso:IIsoDisplayObject ):void;
		
		/**
		 * This method has been deprecated.  Please use the panBy and panTo APIs.
		 *
		 * @see panBy
		 * @see panTo
		 */
		function pan( px:Number, py:Number ):void;
		
		/**
		 * Pans the iso view by a given amount relative to the current position.
		 *
		 * @param px The x value to pan by.
		 * @param py the y value to pan by.
		 *
		 * @see panTo
		 */
		function panBy( xBy:Number, yBy:Number ):void;
		
		/**
		 * Pans the iso view to the current x and y position
		 *
		 * @param px The x value to pan to.
		 * @param py the y value to pan to.
		 *
		 * @see panBy
		 */
		function panTo( xTo:Number, yTo:Number ):void;
		
		/**
		 * The current zoom factor applied to the child scene objects.
		 */
		function get currentZoom():Number
		
		/**
		 * Zooms the child scene objects by a given amount.
		 *
		 * @param zFactor The positive non-zero value to scale the child scene objects by.  This corresponds to the child scene objects' containers' scaleX and scaleY properties.
		 */
		function zoom( zFactor:Number ):void;
		
		/**
		 * Resets the child scene objects to be centered within the IIsoView and returns the zoom factor back to a normal value.
		 */
		function reset():void;
		
		/**
		 * Executes positional changes for background, scene and foreground objects.
		 *
		 * @param recursive Flag indicating if child scenes render on the view's validation.  Default value is <code>false</code>.
		 */
		function renderIsoView( recursive:Boolean = false ):void;
		
		function get width():Number;
		
		function get height():Number;
		
		/**
		 * @private
		 */
		function get mainContainer():Sprite;
	}
}