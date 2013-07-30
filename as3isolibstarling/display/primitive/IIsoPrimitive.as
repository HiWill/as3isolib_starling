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
package as3isolibstarling.display.primitive
{
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.graphics.IFill;
	import as3isolibstarling.graphics.IStroke;
	
	/**
	 * The IIsoPrimitive interface defines methods for any IIsoDisplayObject class that is utilizing Flash's drawing API.
	 */
	public interface IIsoPrimitive extends IIsoDisplayObject
	{
		//////////////////////////////////////////////////////////////////
		//	STYLES
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get styleType ():String;
		
		/**
		 * For IIsoDisplayObjects that make use of Flash's drawing API, it is necessary to develop render logic corresponding to the
		 * varios render style types.
		 * 
		 * @see as3isolibstarling.enum.RenderStyleType
		 */
		function set styleType (value:String):void;
		
		/**
		 * @private
		 */
		function get fill ():IFill;
		
		/**
		 * The primary fill used to draw the faces of this object.  This overwrites any values in the fills array.
		 */
		function set fill (value:IFill):void;
		
		/**
		 * @private
		 */
		function get fills ():Array;
		
		/**
		 * An array of IFill objects used to apply material fills to the faces of the primitive object.
		 * 
		 * @see as3isolibstarling.graphics.IFill
		 */
		function set fills (value:Array):void;
		
		/**
		 * @private
		 */
		function get stroke ():IStroke;
		
		/**
		 * The primary stroke used to draw the edges of this object.  This overwrites any values in the strokes array.
		 */
		function set stroke (value:IStroke):void;
		
		/**
		 * @private
		 */
		function get strokes ():Array;
		
		/**
		 * An array of IStroke objects used to apply line styles to the face edges of the primitive object.
		 * 
		 * @see as3isolibstarling.graphics.IFill
		 */
		function set strokes (value:Array):void;
		
		//////////////////////////////////////////////////////////////////
		//	INVALIDATION
		//////////////////////////////////////////////////////////////////
		
		/**
		 * Invalidates the styles of the  IIsoDisplayObject.
		 */
		function invalidateStyles ():void;	
	}
}