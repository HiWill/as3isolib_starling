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
package as3isolibstarling.errors
{
	public class IsoError extends Error
	{
		//////////////////////////////////////////////////////////////////////
		//	CONST
		//////////////////////////////////////////////////////////////////////
		
		/*
		throw new Error("parameter child does not implement IContainer.");
		throw new Error("parameter child is not found within node structure.");
		throw new Error("validation of geometry failed.");
		throw new Error("cellSize must be a positive value greater than 2");
		throw new Error ("parameter child is not of type IIsoDisplayObject");
		throw new Error("skin asset is not of the following types: DisplayObject or Class cast as DisplayOject.");
		throw new Error("IsoView instance already contains parameter scene");
		*/
		
		//////////////////////////////////////////////////////////////////////
		//	PROPS
		//////////////////////////////////////////////////////////////////////
		
		/**
		 * The additional information (if any) for this error.
		 */
		public var info:String;
		
		/**
		 * The data associated with this error.
		 */
		public var data:Object;
		
		//////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		//////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 * 
		 * @param message The message associated with this error.
		 * @param info The specific information associated with this error.
		 * @param data The data associated with this error.
		 */
		public function IsoError (message:String, info:String = "", data:Object = null)
		{
			super(message);
			
			this.info = info;
			this.data = data;
		}
	}
}