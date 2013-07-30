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
	import as3isolibstarling.enum.IsoOrientation;
	import as3isolibstarling.utils.IsoDrawingUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;

	public class BitmapFill implements IBitmapFill
	{
		///////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 * 
		 * @param source The target that serves as the context for the fill. Any assignment to a BitmapData, DisplayObject, Class, and String (as a fully qualified class path) are valid.
		 * @param orientation The expect orientation of the fill.  Valid values relate to the IsoOrientation constants.
		 * @param matrix A user defined matrix for custom transformations.
		 * @param colorTransform Used to assign additional custom color transformations to the fill.
		 * @param repeat Flag indicating whether to repeat the fill.  If this is false, then the fill will be stretched.
		 * @param smooth Flag indicating whether to smooth the fill.
		 */
		public function BitmapFill (source:Object, orientation:Object = null, matrix:Matrix = null, colorTransform:ColorTransform = null, repeat:Boolean = true, smooth:Boolean = false)
		{
			this.source = source;
			this.orientation = orientation;
			
			if (matrix)
				this.matrix = matrix;
			
			this.colorTransform = colorTransform;
			this.repeat = repeat;
			this.smooth = smooth;
		}
		
		///////////////////////////////////////////////////////////
		//	SOURCE
		///////////////////////////////////////////////////////////
		
		private var bitmapData:BitmapData;
		private var sourceObject:Object;
		
		/**
		 * @private
		 */
		public function get source ():Object
		{
			return sourceObject;
		}
		
		/**
		 * The source object for the bitmap fill.
		 */
		public function set source (value:Object):void
		{
			sourceObject = value;
			
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			
			var tempSprite:DisplayObject;
			
			if (value is BitmapData)
			{
				bitmapData = BitmapData(value);
				return;
			}
			
			if (value is Class)
			{
				var classInstance:Class = Class(value);
				if (getQualifiedSuperclassName(classInstance) == "flash.display::BitmapData")
				{
					bitmapData = new classInstance(1, 1);
					return;
				}
					
				else
					tempSprite = new classInstance();
			}
			
			else if (value is Bitmap)
				bitmapData = Bitmap(value).bitmapData;
			
			else if (value is DisplayObject)
				tempSprite = DisplayObject(value);
			
			else if (value is String)
			{
				classInstance = Class(getDefinitionByName(String(value)));
				if (classInstance)
					tempSprite = new classInstance();
			}
			
			else
				return;
				
			if (!bitmapData && tempSprite)
			{
				if (tempSprite.width > 0 && tempSprite.height > 0)
				{
					bitmapData = new BitmapData(tempSprite.width, tempSprite.height);
					bitmapData.draw(tempSprite, new Matrix(), cTransform);
				}
			}
			
			if (cTransform)
				bitmapData.colorTransform(bitmapData.rect, cTransform);
		}
		
		///////////////////////////////////////////////////////////
		//	ORIENTATION
		///////////////////////////////////////////////////////////
		
		private var _orientation:Object;
		
		/**
		 * @private
		 */
		public function get orientation ():Object
		{
			return _orientation;
		}
		
		private var _orientationMatrix:Matrix;
		
		/**
		 * The planar orientation of fill relative to an isometric face.  This can either be a string value enumerated in the IsoOrientation or a matrix.
		 */
		public function set orientation (value:Object):void
		{
			_orientation = value;
			
			if (!value)
				return;
			
			if (value is String)
			{
				if (value == IsoOrientation.XY || value == IsoOrientation.XZ || value == IsoOrientation.YZ)
					_orientationMatrix = IsoDrawingUtil.getIsoMatrix(value as String);
				
				else
					_orientationMatrix = null;
			}
				
			else if (value is Matrix)
				_orientationMatrix = Matrix(value);
			
			else
				throw new Error("value is not of type String or Matrix");
		}
		
		///////////////////////////////////////////////////////////
		//	props
		///////////////////////////////////////////////////////////
		
		private var cTransform:ColorTransform;
		
		/**
		 * @private
		 */
		public function get colorTransform ():ColorTransform
		{
			return cTransform;
		}
		
		/**
		 * A color transformation applied to the source object.
		 */
		public function set colorTransform (value:ColorTransform):void
		{
			cTransform = value;
			
			if (bitmapData && cTransform)
				bitmapData.colorTransform(bitmapData.rect, cTransform);
		}
		
		private var matrixObject:Matrix;
		
		/**
		 * The transformation matrix applied to the source relative to the isometric face.  This matrix is applied before the orientation adjustments.
		 */
		public function get matrix ():Matrix
		{
			return matrixObject;
		}
		
		/**
		 * @private
		 */
		public function set matrix (value:Matrix):void
		{
			matrixObject = value;
		}
		
		private var bRepeat:Boolean;
		
		/**
		 * A flag indicating whether the bitmap is repeated to fill the area.
		 */
		public function get repeat ():Boolean
		{
			return bRepeat;
		}
		
		/**
		 * @private
		 */
		public function set repeat (value:Boolean):void
		{
			bRepeat = value;
		}
		
		/**
		 * A flag indicating whether to smooth the bitmap data when filling with it.
		 */
		public var smooth:Boolean;
		
		///////////////////////////////////////////////////////////
		//	IFILL
		///////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function begin (target:Graphics):void
		{
			var m:Matrix = new Matrix();
			if (_orientationMatrix)
				m.concat(_orientationMatrix);
				
			if (matrix)
				m.concat(matrix);
			
			target.beginBitmapFill(bitmapData, m, repeat, smooth);
		}
		
		/**
		 * @inheritDoc
		 */
		public function end (target:Graphics):void
		{
			target.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone ():IFill
		{
			return new BitmapFill(source, orientation, matrix, colorTransform, repeat, smooth);
		}
	}
}