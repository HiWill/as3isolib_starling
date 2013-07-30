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
package as3isolibstarling.geom
{
	/*
	http://www.compuphase.com/axometr.htm - axometric projection references
	*/
	
	import as3isolibstarling.geom.transformations.DefaultIsometricTransformation;
	import as3isolibstarling.geom.transformations.IAxonometricTransformation;
	
	/**
	 * IsoMath provides functions for converting pts back and forth between 3D isometric space and cartesian coordinates.
	 */
	public class IsoMath
	{
		/////////////////////////////////////////////////////////////////////
		//	TRANSFORMATION OBJECT
		/////////////////////////////////////////////////////////////////////
		
		static private var transformationObj:IAxonometricTransformation = new DefaultIsometricTransformation();
		
		static public function get transformationObject ():IAxonometricTransformation
		{
			return transformationObj;
		}
		
		/**
		 * @private
		 */
		static public function set transformationObject (value:IAxonometricTransformation):void
		{
			if (value)
				transformationObj = value;
			
			else
				transformationObj = new new DefaultIsometricTransformation();
		}
		
		/////////////////////////////////////////////////////////////////////
		//	TRANSFORMATION METHODS
		/////////////////////////////////////////////////////////////////////
		
		/**
		 * Converts a given pt in cartesian coordinates to 3D isometric space.
		 * 
		 * @param screenPt The pt in cartesian coordinates.
		 * @param createNew Flag indicating whether to affect the provided pt or to return a converted copy.
		 * @return pt A pt in 3D isometric space.
		 */
		static public function screenToIso (screenPt:Pt, createNew:Boolean = false):Pt
		{
			var isoPt:Pt = transformationObject.screenToSpace(screenPt);
			
			if (createNew)
				return isoPt;
			
			else
			{
				screenPt.x = isoPt.x;
				screenPt.y = isoPt.y;
				screenPt.z = isoPt.z;
				
				return screenPt;
			}
		}
		
		/**
		 * Converts a given pt in 3D isometric space to cartesian coordinates.
		 * 
		 * @param isoPt The pt in 3D isometric space.
		 * @param createNew Flag indicating whether to affect the provided pt or to return a converted copy.
		 * @return pt A pt in cartesian coordinates.
		 */
		static public function isoToScreen (isoPt:Pt, createNew:Boolean = false):Pt
		{
			var screenPt:Pt = transformationObject.spaceToScreen(isoPt);
			
			if (createNew)
				return screenPt;
			
			else
			{
				isoPt.x = screenPt.x;
				isoPt.y = screenPt.y;
				isoPt.z = screenPt.z;
				
				return isoPt;
			}
		}
	}
}