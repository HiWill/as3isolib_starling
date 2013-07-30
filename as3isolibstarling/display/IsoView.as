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
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.display.renderers.IViewRenderer;
	import as3isolibstarling.display.scene.IIsoScene;
	import as3isolibstarling.events.IsoEvent;
	import as3isolibstarling.geom.IsoMath;
	import as3isolibstarling.geom.Pt;
	import starling.display.DisplayObject;
	import starling.display.Sprite; 
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;  
	
	import mx.core.IFactory;
	
	use namespace as3isolib_internal;
	
	[Event( name="as3isolib_move", type="as3isolibstarling.events.IsoEvent" )]
	
	/**
	 * IsoView is a default view port that provides basic panning and zooming functionality on a given IIsoScene.
	 */
	public class IsoView extends Sprite implements IIsoView
	{
		///////////////////////////////////////////////////////////////////////////////
		//	PRECISION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if coordinate values are rounded to the nearest whole number or not.
		 */
		public var usePreciseValues:Boolean = false;
		
		///////////////////////////////////////////////////////////////////////////////
		//	CURRENT PT
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 *
		 * The targeted point to perform calculations on.
		 */
		protected var targetScreenPt:Pt = new Pt();
		
		/**
		 * @private
		 */
		protected var currentScreenPt:Pt = new Pt();
		
		/**
		 * @inheritDoc
		 */
		[Bindable( "as3isolib_move" )]
		public function get currentPt():Pt
		{
			return currentScreenPt.clone() as Pt;
		}
		
		//	CURRENT X
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function get currentX():Number
		{
			return currentScreenPt.x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set currentX( value:Number ):void
		{
			if ( currentScreenPt.x != value )
			{
				if ( !targetScreenPt )
					targetScreenPt = currentScreenPt.clone() as Pt;
				
				targetScreenPt.x = usePreciseValues ? value : Math.round( value );
				
				bPositionInvalidated = true;
				
				if ( autoUpdate )
					renderIsoView();
			}
		}
		
		//	CURRENT Y
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function get currentY():Number
		{
			return currentScreenPt.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set currentY( value:Number ):void
		{
			if ( currentScreenPt.y != value )
			{
				if ( !targetScreenPt )
					targetScreenPt = currentScreenPt.clone() as Pt;
				
				targetScreenPt.y = usePreciseValues ? value : Math.round( value );
				
				bPositionInvalidated = true;
				
				if ( autoUpdate )
					renderIsoView();
			}
		}
		
		public function localToIso( localPt:Point ):Pt
		{
			localPt = localToGlobal( localPt );
			localPt = mainContainer.globalToLocal( localPt );
			
			return IsoMath.screenToIso( new Pt( localPt.x, localPt.y, 0 ));
		}
		
		public function isoToLocal( isoPt:Pt ):Point
		{
			isoPt = IsoMath.isoToScreen( isoPt );
			
			var temp:Point = new Point( isoPt.x, isoPt.y );
			temp = mainContainer.localToGlobal( temp );
			return globalToLocal( temp );
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	INVALIDATION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var bPositionInvalidated:Boolean = false;
		
		/**
		 * Flag indicating if the view is invalidated.  If true, validation will when explicity called.
		 */
		public function get isInvalidated():Boolean
		{
			return bPositionInvalidated;
		}
		
		/**
		 * Flags the view as needing validation.
		 */
		public function invalidatePosition():void
		{
			bPositionInvalidated = true;
		}
		
		/**
		 * Convenience method for determining which scenes are invalidated.
		 */
		public function getInvalidatedScenes():Array
		{
			var a:Array = [];
			var scene:IIsoScene;
			
			for each ( scene in scenesArray )
			{
				if ( scene.isInvalidated )
					a.push( scene );
			}
			
			return a;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	VALIDATION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderIsoView( recursive:Boolean = false ):void
		{
			preRenderLogic();
			renderLogic( recursive );
			postRenderLogic();
		}
		
		/**
		 * Performs any logic prior to executing actual rendering logic on the view.
		 */
		protected function preRenderLogic():void
		{
			dispatchEvent( new IsoEvent( IsoEvent.RENDER ));
		}
		
		/**
		 * Performs actual rendering logic on the view.
		 *
		 * @param recursive Flag indicating if child scenes render on the view's validation.  Default value is <code>false</code>.
		 */
		protected function renderLogic( recursive:Boolean = false ):void
		{
			if ( bPositionInvalidated )
			{
				validatePosition();
				bPositionInvalidated = false;
			}
			
			if ( recursive )
			{
				var scene:IIsoScene;
				
				for each ( scene in scenesArray )
					scene.render( recursive );
			}
			
			if ( viewRenderers && numScenes > 0 )
			{
				var viewRenderer:IViewRenderer;
				var factory:IFactory;
				
				for each ( factory in viewRendererFactories )
				{
					viewRenderer = factory.newInstance();
					viewRenderer.renderView( this );
				}
			}
		}
		
		/**
		 * Performs any logic after executing actual rendering logic on the view.
		 */
		protected function postRenderLogic():void
		{
			dispatchEvent( new IsoEvent( IsoEvent.RENDER_COMPLETE ));
		}
		
		/**
		 * Calculates the positional changes and repositions the <code>container</code>.
		 */
		protected function validatePosition():void
		{
			var dx:Number = currentScreenPt.x - targetScreenPt.x;
			var dy:Number = currentScreenPt.y - targetScreenPt.y;
			
			if ( limitRangeOfMotion && romTarget )
			{
				var ndx:Number = 0;
				var ndy:Number = 0;
				
				var rect:Rectangle = romTarget.getBounds( this );
				var isROMBigger:Boolean = !romBoundsRect.containsRect( rect );
				
				if ( isROMBigger )
				{
					if ( dx > 0 )
						ndx = Math.min( dx, Math.abs( rect.left ));
					
					else
						ndx = -1 * Math.min( Math.abs( dx ), Math.abs( rect.right - romBoundsRect.right ));
					
					if ( dy > 0 )
						ndy = Math.min( dy, Math.abs( rect.top ));
					
					else
						ndy = -1 * Math.min( Math.abs( dy ), Math.abs( rect.bottom - romBoundsRect.bottom ));
				}
				
				targetScreenPt.x = targetScreenPt.x + dx - ndx;
				targetScreenPt.y = targetScreenPt.y + dy - ndy;
				
				dx = ndx;
				dy = ndy;
			}
			
			mContainer.x += dx;
			mContainer.y += dy;
			
			var evt:IsoEvent = new IsoEvent( IsoEvent.MOVE );
			evt.propName = "currentPt";
			evt.oldValue = currentScreenPt;
			
			//store the new value now
			currentScreenPt = targetScreenPt.clone() as Pt;
			
			evt.newValue = currentScreenPt;
			dispatchEvent( evt );
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CENTER
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if property changes immediately trigger validation.
		 */
		public var autoUpdate:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function centerOnPt( pt:Pt, isIsometrc:Boolean = true ):void
		{
			var target:Pt = Pt( pt.clone());
			
			if ( isIsometrc )
				IsoMath.isoToScreen( target );
			
			if ( !usePreciseValues )
			{
				target.x = Math.round( target.x );
				target.y = Math.round( target.y );
				target.z = Math.round( target.z );
			}
			
			targetScreenPt = target;
			
			bPositionInvalidated = true;
			renderIsoView();
		}
		
		/**
		 * @inheritDoc
		 */
		public function centerOnIso( iso:IIsoDisplayObject ):void
		{
			centerOnPt( iso.isoBounds.centerPt );
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	PAN
		///////////////////////////////////////////////////////////////////////////////
		
		[Deprecated( "please use panBy and panTo APIs" )]
		/**
		 * @inheritDoc
		 */
		public function pan( px:Number, py:Number ):void
		{
			panBy( px, py );
		}
		
		/**
		 * @inheritDoc
		 */
		public function panBy( xBy:Number, yBy:Number ):void
		{
			targetScreenPt = currentScreenPt.clone() as Pt;
			targetScreenPt.x += xBy;
			targetScreenPt.y += yBy;
			
			bPositionInvalidated = true;
			renderIsoView();
		}
		
		/**
		 * @inheritDoc
		 */
		public function panTo( xTo:Number, yTo:Number ):void
		{
			targetScreenPt = new Pt( xTo, yTo );
			
			bPositionInvalidated = true;
			renderIsoView();
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	ZOOM
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get currentZoom():Number
		{
			return zoomContainer.scaleX;
		}
		
		/**
		 * @private
		 */
		public function set currentZoom( value:Number ):void
		{
			zoomContainer.scaleX = zoomContainer.scaleY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function zoom( zFactor:Number ):void
		{
			zoomContainer.scaleX = zoomContainer.scaleY = zFactor;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	RESET
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			zoomContainer.scaleX = zoomContainer.scaleY = 1;
			setSize( _w, _h );
			
			mContainer.x = 0;
			mContainer.y = 0;
			
			currentScreenPt = new Pt();
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	VIEW RENDERER
		///////////////////////////////////////////////////////////////////////////////
		
		private var viewRendererFactories:Array = [];
		
		/**
		 * An array of view renderers to affect each scene during the render phase.
		 */
		public function get viewRenderers():Array
		{
			return viewRendererFactories;
		}
		
		/**
		 * @private
		 */
		public function set viewRenderers( value:Array ):void
		{
			if ( value )
			{
				var temp:Array = [];
				var obj:Object;
				
				for each ( obj in value )
				{
					if ( obj is IFactory )
						temp.push( obj );
				}
				
				viewRendererFactories = temp;
				
				bPositionInvalidated = true;
				
				if ( autoUpdate )
					renderIsoView();
			}
			
			else
				viewRendererFactories = [];
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	SCENE METHODS
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var scenesArray:Array = [];
		
		/**
		 * @inheritDoc
		 */
		public function get scenes():Array
		{
			return scenesArray;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numScenes():uint
		{
			return scenesArray.length;
		}
		
		/**
		 * Adds a scene to the scene container.
		 *
		 * @param scene The scene to add.
		 */
		public function addScene( scene:IIsoScene ):void
		{
			addSceneAt( scene, scenesArray.length );
		}
		
		/**
		 * Adds a scene to the scene container at the given index.
		 *
		 * @param scene The scene to add.
		 * @param index The index which is assigned to the scene in the scene container.
		 */
		public function addSceneAt( scene:IIsoScene, index:int ):void
		{
			if ( !containsScene( scene ))
			{
				scenesArray.splice( index, 0, scene );
				
				scene.hostContainer = null;
				sceneContainer.addChildAt( scene.container, index );
			}
			
			else
				throw new Error( "IsoView instance already contains parameter scene" );
		}
		
		/**
		 * Determines if a scene is contained within the scene container.
		 *
		 * @param scene The scene to check for.
		 *
		 * @return Boolean returns true if the scene is contained within the scene container, false otherwise.
		 */
		public function containsScene( scene:IIsoScene ):Boolean
		{
			var childScene:IIsoScene;
			
			for each ( childScene in scenesArray )
			{
				if ( scene == childScene )
					return true;
			}
			
			return false;
		}
		
		/**
		 * Finds a scene by the target's id.
		 *
		 * @param id The target scene's id.
		 *
		 * @return IIsoScene If the target scene is found it will be returned.
		 */
		public function getSceneByID( id:String ):IIsoScene
		{
			var scene:IIsoScene;
			
			for each ( scene in scenesArray )
			{
				if ( scene.id == id )
					return scene;
			}
			
			return null;
		}
		
		/**
		 * Removes a target scene from the scenes container.
		 *
		 * @param scene The target scene to remove.
		 * @return IIsoScene If the target scene is successfully removed, it will be returned, otherwise null is returned.
		 */
		public function removeScene( scene:IIsoScene ):IIsoScene
		{
			if ( containsScene( scene ))
			{
				var i:int = scenesArray.indexOf( scene );
				scenesArray.splice( i, 1 );
				sceneContainer.removeChild( scene.container );
				
				return scene;
			}
			
			else
				return null;
		}
		
		/**
		 * Removes all scenes from the scenes container.
		 */
		public function removeAllScenes():void
		{
			var scene:IIsoScene;
			
			for each ( scene in scenesArray )
			{
				if ( sceneContainer.contains( scene.container ))
				{
					sceneContainer.removeChild( scene.container );
					scene.hostContainer = null;
				}
			}
			
			scenesArray = [];
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	SIZE
		///////////////////////////////////////////////////////////////////////////////
		
		private var _w:Number;
		private var _h:Number;
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return _w;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return _h;
		}
		
		/**
		 * The current size of the IsoView.
		 * Returns a Point whose x corresponds to the width and y corresponds to the height.
		 */
		public function get size():Point
		{
			return new Point( _w, _h );
		}
		
		/**
		 * Set the size of the IsoView and repositions child scene objects, masks and borders (where applicable).
		 *
		 * @param w The width to resize to.
		 * @param h The height to resize to.
		 */
		public function setSize( w:Number, h:Number ):void
		{
			_w = Math.round( w );
			_h = Math.round( h );
			
			romBoundsRect = new Rectangle( 0, 0, _w + 1, _h + 1 );
			//this.scrollRect = _clipContent ? romBoundsRect : null;
			
			zoomContainer.x = _w / 2;
			zoomContainer.y = _h / 2;
			//_zoomContainer.mask = _clipContent ? _mask : null;
			
			/* _mask.graphics.clear();
			   if (_clipContent)
			   {
			   _mask.graphics.beginFill(0);
			   _mask.graphics.drawRect(0, 0, _w, _h);
			   _mask.graphics.endFill();
			 } */
			
			drawBorder();
		
			//for testing only - adds crosshairs to view border
		/* _border.graphics.moveTo(0, 0);
		   _border.graphics.lineTo(_w, _h);
		   _border.graphics.moveTo(_w, 0);
		 _border.graphics.lineTo(0, _h); */
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CLIP CONTENT
		///////////////////////////////////////////////////////////////////////////////
		
		private var _clipContent:Boolean = true;
		
		/**
		 * @private
		 */
		public function get clipContent():Boolean
		{
			return _clipContent;
		}
		
		/**
		 * Flag indicating where to allow content to visibly extend beyond the boundries of this IsoView.
		 */
		public function set clipContent( value:Boolean ):void
		{
			if ( _clipContent != value )
			{
				_clipContent = value;
				reset();
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	RANGE OF MOTION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var romTarget:DisplayObject;
		
		/**
		 * @private
		 */
		protected var romBoundsRect:Rectangle;
		
		/**
		 * @private
		 */
		public function get rangeOfMotionTarget():DisplayObject
		{
			return romTarget;
		}
		
		/**
		 * The target used to determine the range of motion when moving the <code>container</code>.
		 *
		 * @see #limitRangeOfMotion
		 */
		public function set rangeOfMotionTarget( value:DisplayObject ):void
		{
			romTarget = value;
			limitRangeOfMotion = romTarget ? true : false;
		}
		
		/**
		 * Flag to limit the range of motion.
		 *
		 * @see #rangeOfMotionTarget
		 */
		public var limitRangeOfMotion:Boolean = true;
		
		///////////////////////////////////////////////////////////////////////////////
		//	CONTAINER STRUCTURE
		///////////////////////////////////////////////////////////////////////////////
		
		private var zoomContainer:Sprite;
		
		//	MAIN CONTAINER
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var mContainer:starling.display.Sprite;
		
		/**
		 * The main container whose children include the background container, the iso object container and the foreground container.
		 *
		 * An IsoView's container structure is as follows:
		 * * IsoView
		 * 		* zoom container
		 * 			* main container
		 * 				* background container
		 * 				* iso scenes container
		 * 				* foreground container
		 */
		public function get mainContainer():starling.display.Sprite
		{
			return mContainer;
		}
		
		//	BACKGROUND CONTAINER
		///////////////////////////////////////////////////////////////////////////////
		
		private var bgContainer:Sprite;
		
		/**
		 * The container for background elements.
		 */
		public function get backgroundContainer():Sprite
		{
			if ( !bgContainer )
			{
				bgContainer = new Sprite();
				mContainer.addChildAt( bgContainer, 0 );
			}
			
			return bgContainer;
		}
		
		//	FOREGROUND CONTAINER
		///////////////////////////////////////////////////////////////////////////////
		
		private var fgContainer:Sprite;
		
		/**
		 * The container for foreground elements.
		 */
		public function get foregroundContainer():Sprite
		{
			if ( !fgContainer )
			{
				fgContainer = new Sprite();
				mContainer.addChild( fgContainer );
			}
			
			return fgContainer;
		}
		
		//	BOUNDS & SCENE CONTAINER
		///////////////////////////////////////////////////////////////////////////////
		
		private var sceneContainer:Sprite;
		 
		
		/////////////////////////////////////////////////////////////////
		//	SHOW BORDER
		/////////////////////////////////////////////////////////////////
		
		private var _showBorder:Boolean = true;
		
		/**
		 * @private
		 */
		[Bindable( "showBorderChanged" )]
		public function get showBorder():Boolean
		{
			return _showBorder;
		}
		
		/**
		 * Flag indicating if the view's border is visible.
		 */
		public function set showBorder( value:Boolean ):void
		{
			if ( _showBorder != value )
			{
				_showBorder = value;
				drawBorder();
			}
		}
		
		/**
		 * @private
		 */
		protected function drawBorder():void
		{
			 
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoView()
		{
			super();
			
			sceneContainer = new Sprite();
			
			mContainer = new Sprite();
			mContainer.addChild( sceneContainer );
			
			zoomContainer = new Sprite();
			zoomContainer.addChild( mContainer );
			addChild( zoomContainer );
			 
			
			setSize( 400, 250 );
		
			//viewRenderer = new ClassFactory(DefaultViewRenderer);
		}
	}
}