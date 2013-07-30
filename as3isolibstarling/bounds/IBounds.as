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
	import as3isolibstarling.geom.Pt;
	
	/**
	 * The IBounds interface defines the interface that all classes used bound-type information objects should use.
	 * 
	 * Properties of IBounds implementors will refer to properties in isometric space.
	 */
	public interface IBounds
	{
		///////////////////////////////////////////////////////////
		//	WIDTH / LENGTH / HEIGHT
		///////////////////////////////////////////////////////////
		
		/**
		 * The difference of the left and right properties.
		 */
		function get width ():Number;
		
		/**
		 * The difference of the back and front properties.
		 */
		function get length ():Number;
		
		/**
		 * The difference of the top and bottom properties.
		 */
		function get height ():Number;
		
		///////////////////////////////////////////////////////////
		//	LEFT / RIGHT
		///////////////////////////////////////////////////////////
		
		/**
		 * The left most coordinate. Most often this cooresponds to the x position of the IBounds' target.
		 */
		function get left ():Number;
		
		/**
		 * The right most coordinate. Cooresponds to the x + width of the IBounds' target.
		 */
		function get right ():Number;
		
		///////////////////////////////////////////////////////////
		//	BACK / FRONT
		///////////////////////////////////////////////////////////
		
		/**
		 * The back most coordinate. Most often this cooresponds to the y position of the IBounds' target.
		 */
		function get back ():Number;
		
		/**
		 * The front most coordinate. Cooresponds to the y + length of the IBounds' target.
		 */
		function get front ():Number;
		
		///////////////////////////////////////////////////////////
		//	TOP / BOTTOM
		///////////////////////////////////////////////////////////
		
		/**
		 * The bottom most coordinate. Most often this cooresponds to the z position of the IBounds' target.
		 */
		function get bottom ():Number;
		
		/**
		 * The top most coordinate. Cooresponds to the z + height of the IBounds' target.
		 */
		function get top ():Number;
		
		///////////////////////////////////////////////////////////
		//	PTS
		///////////////////////////////////////////////////////////
		
		/**
		 * Represents the center pt of the IBounds object in 3D isometric space
		 */
		function get centerPt ():Pt;
		
		/**
		 * Returns an array of all the vertices of the IBounds' target.
		 * 
		 * @returns Array An array of vertices of the target object.
		 */
		function getPts ():Array;
		
		///////////////////////////////////////////////////////////
		//	INTERSECTS
		///////////////////////////////////////////////////////////
		
		/**
		 * Determines if the IBounds oject has a 3D isometric intersection with the target IBounds.
		 * 
		 * @param bounds The IBounds object to test for an intersection against.
		 * 
		 * @returns Boolean Returns true if an intersection occured, else false.
		 */
		function intersects (bounds:IBounds):Boolean;
		
		/**
		 * Determines if the IBounds oject contains the target Pt.
		 * 
		 * @param bounds The Pt object to test for an intersection against.
		 * 
		 * @returns Boolean Returns true if it contains the Pt, else false.
		 */
		function containsPt (target:Pt):Boolean;
	}
}