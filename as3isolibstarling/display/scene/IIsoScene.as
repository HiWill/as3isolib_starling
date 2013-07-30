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
package as3isolibstarling.display.scene
{
	import as3isolibstarling.bounds.IBounds;
	import as3isolibstarling.core.IIsoContainer;
	import starling.display.DisplayObjectContainer;
	
	
	/**
	 * The IIsoScene interface defines methods for scene-based classes that expect to group and control child objects in a similar fashion.
	 */
	public interface IIsoScene extends IIsoContainer
	{
		/**
		 * The IBounds for the displayable content in 3D isometric space.
		 */
		function get isoBounds ():IBounds;
		
		/**
		 * An array of all invalidated children.
		 */
		function get invalidatedChildren ():Array;
		
		/**
		 * @private
		 */
		function get hostContainer ():DisplayObjectContainer;
		
		/**
		 * The host container which will contain the display list of the isometric display list.
		 * 
		 * @param value The host container.
		 */
		function set hostContainer (value:DisplayObjectContainer):void;
	}
}