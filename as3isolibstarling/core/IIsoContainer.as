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
package as3isolibstarling.core
{
	import as3isolibstarling.data.INode;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	
	/**
	 * The IContainer interface defines the methods necessary for display visual content associated with a particular data node.
	 */
	public interface IIsoContainer extends INode, IInvalidation
	{
		//////////////////////////////////////////////////////////////////
		//	INCLUDE IN LAYOUT
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get includeInLayout ():Boolean;
		
		/**
		 * Flag indicating whether the <code>container</code> is included in the display list.
		 * The allows child objects to persist in memory while being removed from the display list.
		 */
		function set includeInLayout (value:Boolean):void;
		
		/**
		 * An array of all children whose <code>container</code> is present within the display list.
		 * 
		 * @see #includeInLayout
		 */
		function get displayListChildren ():Array;
		
		//////////////////////////////////////////////////////////////////
		//	CONTAINER
		//////////////////////////////////////////////////////////////////
		
		/**
		 * The depth of the <code>container</code> relative to its parent container.
		 * If the <code>container</code> is orphaned, then -1 is returned.
		 */
		function get depth ():int;
		
		/**
		 * The sprite that contains the visual assets.
		 */
		function get container ():DisplayObject;
		
		//////////////////////////////////////////////////////////////////
		//	RENDER
		//////////////////////////////////////////////////////////////////
		
		/**
		 * Initiates the various validation processes in order to display the IPrimitive.
		 * 
		 * @param recursive If true will tell child nodes to render through the display list.
		 */
		function render (recursive:Boolean = true):void;
	}
}