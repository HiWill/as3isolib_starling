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
package as3isolibstarling.graphics
{
	import flash.display.Graphics;
	
	/**
	 * The Stroke class defines the properties for a line.
	 */
	public class Stroke implements IStroke
	{
		/**
		 * The line weight, in pixels.
		 */
		public var weight:Number;
		
		/**
		 * The line color.
		 */
		public var color:uint;
		
		/**
		 * The transparency of the line.
		 */
		public var alpha:Number;
		
		/**
		 * Specifies whether to hint strokes to full pixels.
		 */
		public var usePixelHinting:Boolean;
		
		/**
		 * Specifies how to scale a stroke.
		 */
		public var scaleMode:String;
		
		/**
		 * Specifies the type of caps at the end of lines.
		 */
		public var caps:String;
		
		/**
		 * Specifies the type of joint appearance used at angles.
		 */
		public var joints:String;
		
		/**
		 * Indicates the limit at which a miter is cut off.
		 */
		public var miterLimit:Number;
		
		/**
		 * Constructor
		 */
		public function Stroke (weight:Number,
								color:uint,
								alpha:Number = 1,
								usePixelHinting:Boolean = false,
								scaleMode:String = "normal",
								caps:String = null,
								joints:String = null,
								miterLimit:Number = 0)
		{
			this.weight = weight;
			this.color = color;
			this.alpha = alpha;
			
			this.usePixelHinting = usePixelHinting;
			
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		/**
		 * @inheritDoc
		 */
		public function apply (target:Graphics):void
		{
			target.lineStyle(weight, color, alpha, usePixelHinting, scaleMode, caps, joints, miterLimit);
		}
	}
}