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
	import as3isolibstarling.bounds.IBounds;
	import as3isolibstarling.bounds.PrimitiveBounds;
	import as3isolibstarling.bounds.SceneBounds;
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.core.IsoDisplayObject;
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.display.renderers.ISceneLayoutRenderer;
	import as3isolibstarling.display.renderers.SimpleSceneLayoutRenderer;
	import as3isolibstarling.display.scene.IIsoScene;
	import starling.display.DisplayObjectContainer;
	
	
	use namespace as3isolib_internal;
	
	public class IsoGroup extends IsoDisplayObject implements IIsoScene
	{
		///////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoGroup( descriptor:Object = null )
		{
			super( descriptor );
		}
		
		///////////////////////////////////////////////////////////////////////
		//	I ISO SCENE
		///////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get hostContainer():DisplayObjectContainer
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function set hostContainer( value:DisplayObjectContainer ):void
		{
			//do nothing
		}
		
		/**
		 * @inheritDoc
		 */
		public function get invalidatedChildren():Array
		{
			var a:Array;
			
			var child:IIsoDisplayObject;
			
			for each ( child in children )
			{
				if ( child.isInvalidated )
					a.push( child );
			}
			
			return a;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isoBounds():IBounds
		{
			return bSizeSetExplicitly ? new PrimitiveBounds( this ) : new SceneBounds( this );
		}
		
		///////////////////////////////////////////////////////////////////////
		//	WIDTH LENGTH HEIGHT
		///////////////////////////////////////////////////////////////////////
		
		private var bSizeSetExplicitly:Boolean;
		
		/**
		 * @inheritDoc
		 */
		override public function set width( value:Number ):void
		{
			super.width = value;
			
			bSizeSetExplicitly = !isNaN( value );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set length( value:Number ):void
		{
			super.length = value;
			
			bSizeSetExplicitly = !isNaN( value );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height( value:Number ):void
		{
			super.height = value;
			
			bSizeSetExplicitly = !isNaN( value );
		}
		
		///////////////////////////////////////////////////////////////////////
		//	ISO GROUP
		///////////////////////////////////////////////////////////////////////
		
		public var renderer:ISceneLayoutRenderer = new SimpleSceneLayoutRenderer();
		
		/**
		 * @inheritDoc
		 */
		override protected function renderLogic( recursive:Boolean = true ):void
		{
			super.renderLogic( recursive );
			
			if ( bIsInvalidated )
			{
				if ( !bSizeSetExplicitly )
					calculateSizeFromChildren();
				
				if ( !renderer )
					renderer = new SimpleSceneLayoutRenderer();
				
				renderer.renderScene( this );
				
				bIsInvalidated = false;
			}
		}
		
		/**
		 * @private
		 */
		protected function calculateSizeFromChildren():void
		{
			var b:IBounds = new SceneBounds( this );
			
			isoWidth = b.width;
			isoLength = b.length;
			isoHeight = b.height;
		}
	}
}