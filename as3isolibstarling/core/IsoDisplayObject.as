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
	import as3isolibstarling.bounds.IBounds;
	import as3isolibstarling.bounds.PrimitiveBounds;
	import as3isolibstarling.data.RenderData;
	import as3isolibstarling.events.IsoEvent;
	import as3isolibstarling.geom.IsoMath;
	import as3isolibstarling.geom.Pt;
	import starling.display.DisplayObject;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	use namespace as3isolib_internal;
	
	/**
	 * IsoDisplayObject is the base class that all primitive and complex isometric display objects should extend.
	 * Developers should not instantiate this class but rather extend it.
	 */
	public class IsoDisplayObject extends IsoContainer implements IIsoDisplayObject
	{
		//////////////////////////////////////////////////////////////////
		//	GET RENDER DATA
		//////////////////////////////////////////////////////////////////
		
		private var cachedRenderData:RenderData;
		
		
		
		////////////////////////////////////////////////////////////////////////
		//	IS ANIMATED
		////////////////////////////////////////////////////////////////////////
		
		private var _isAnimated:Boolean = false;
		
		/**
		 * @private
		 */
		public function get isAnimated():Boolean
		{
			return _isAnimated;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set isAnimated( value:Boolean ):void
		{
			_isAnimated = value;
			//mainContainer.cacheAsBitmap = value;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	BOUNDS
		////////////////////////////////////////////////////////////////////////
		
		protected var isoBoundsObject:IBounds;
		
		/**
		 * @inheritDoc
		 */
		public function get isoBounds():IBounds
		{
			if ( !isoBoundsObject || isInvalidated )
				isoBoundsObject = new PrimitiveBounds( this );
			
			return isoBoundsObject;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get screenBounds():Rectangle
		{
			var screenBounds:Rectangle = mainContainer.getBounds( mainContainer );
			screenBounds.x += mainContainer.x;
			screenBounds.y += mainContainer.y;
			
			return screenBounds;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBounds( targetCoordinateSpace:DisplayObject ):Rectangle
		{
			var rect:Rectangle = screenBounds;
			
			var pt:Point = new Point( rect.x, rect.y );
			pt = IIsoContainer( parent ).container.localToGlobal( pt );
			pt = targetCoordinateSpace.globalToLocal( pt );
			
			rect.x = pt.x;
			rect.y = pt.y;
			
			return rect;
		}
		
		public function get inverseOriginX():Number
		{
			return IsoMath.isoToScreen( new Pt( x + width, y + length, z ) ).x;
		}
		
		public function get inverseOriginY():Number
		{
			return IsoMath.isoToScreen( new Pt( x + width, y + length, z ) ).y;
		}
		
		/////////////////////////////////////////////////////////
		//	POSITION
		/////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////
		//	X, Y, Z
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function moveTo( x:Number, y:Number, z:Number ):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * @inheritDoc
		 */
		public function moveBy( x:Number, y:Number, z:Number ):void
		{
			this.x += x;
			this.y += y;
			this.z += z;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	USE PRECISE VALUES
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if positional and dimensional values are rounded to the nearest whole number or not.
		 */
		public var usePreciseValues:Boolean = false;
		
		////////////////////////////////////////////////////////////////////////
		//	X
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 *
		 * The positional value based on the isometric x-axis.
		 */
		as3isolib_internal var isoX:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldX:Number;
		
		/**
		 * @private
		 */
		[Bindable( "move" )]
		public function get x():Number
		{
			return isoX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set x( value:Number ):void
		{
			if ( !usePreciseValues )
				value = Math.round( value );
			
			if ( isoX != value )
			{
				oldX = isoX;
				
				isoX = value;
				invalidatePosition();
				
				if ( autoUpdate )
					render();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get screenX():Number
		{
			return IsoMath.isoToScreen( new Pt( x, y, z ) ).x;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	Y
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		as3isolib_internal var isoY:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldY:Number;
		
		/**
		 * @private
		 */
		[Bindable( "move" )]
		public function get y():Number
		{
			return isoY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set y( value:Number ):void
		{
			if ( !usePreciseValues )
				value = Math.round( value );
			
			if ( isoY != value )
			{
				oldY = isoY;
				
				isoY = value;
				invalidatePosition();
				
				if ( autoUpdate )
					render();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get screenY():Number
		{
			return IsoMath.isoToScreen( new Pt( x, y, z ) ).y
		}
		
		////////////////////////////////////////////////////////////////////////
		//	Z
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		as3isolib_internal var isoZ:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldZ:Number;
		
		/**
		 * @private
		 */
		[Bindable( "move" )]
		public function get z():Number
		{
			return isoZ;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set z( value:Number ):void
		{
			if ( !usePreciseValues )
				value = Math.round( value );
			
			if ( isoZ != value )
			{
				oldZ = isoZ;
				
				isoZ = value;
				invalidatePosition();
				
				if ( autoUpdate )
					render();
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	WIDTH
		////////////////////////////////////////////////////////////////////////
		
		private var dist:Number;
		
		public function get distance():Number
		{
			return dist;
		}
		
		public function set distance( value:Number ):void
		{
			dist = value;
		}
		
		/////////////////////////////////////////////////////////
		//	GEOMETRY
		/////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function setSize( width:Number, length:Number, height:Number ):void
		{
			this.width = width;
			this.length = length;
			this.height = height;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	WIDTH
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		as3isolib_internal var isoWidth:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldWidth:Number;
		
		/**
		 * @private
		 */
		[Bindable( "resize" )]
		public function get width():Number
		{
			return isoWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set width( value:Number ):void
		{
			if ( !usePreciseValues )
				value = Math.round( value );
			
			value = Math.abs( value );
			
			if ( isoWidth != value )
			{
				oldWidth = isoWidth;
				
				isoWidth = value;
				invalidateSize();
				
				if ( autoUpdate )
					render();
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	LENGTH
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		as3isolib_internal var isoLength:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldLength:Number;
		
		/**
		 * @private
		 */
		[Bindable( "resize" )]
		public function get length():Number
		{
			return isoLength;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set length( value:Number ):void
		{
			if ( !usePreciseValues )
				value = Math.round( value );
			
			value = Math.abs( value );
			
			if ( isoLength != value )
			{
				oldLength = isoLength;
				
				isoLength = value;
				invalidateSize();
				
				if ( autoUpdate )
					render();
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	HEIGHT
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		as3isolib_internal var isoHeight:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldHeight:Number;
		
		/**
		 * @private
		 */
		[Bindable( "resize" )]
		public function get height():Number
		{
			return isoHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set height( value:Number ):void
		{
			if ( !usePreciseValues )
				value = Math.round( value );
			
			value = Math.abs( value );
			if ( isoHeight != value )
			{
				oldHeight = isoHeight;
				
				isoHeight = value;
				invalidateSize();
				
				if ( autoUpdate )
					render();
			}
		}
		
		/////////////////////////////////////////////////////////
		//	RENDER AS ORPHAN
		/////////////////////////////////////////////////////////
		
		private var bRenderAsOrphan:Boolean = false;
		
		/**
		 * @private
		 */
		public function get renderAsOrphan():Boolean
		{
			return bRenderAsOrphan;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set renderAsOrphan( value:Boolean ):void
		{
			bRenderAsOrphan = value;
		}
		
		/////////////////////////////////////////////////////////
		//	RENDERING
		/////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating whether a property change will automatically trigger a render phase.
		 */
		public var autoUpdate:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override protected function renderLogic( recursive:Boolean = true ):void
		{
			if ( !hasParent && !renderAsOrphan )
				return;
			
			if ( bPositionInvalidated )
			{
				validatePosition();
				bPositionInvalidated = false;
			}
			
			if ( bSizeInvalidated )
			{
				validateSize();
				bSizeInvalidated = false;
			}
			
			//set the flag back for the next time we invalidate the object
			bInvalidateEventDispatched = false;
			
			super.renderLogic( recursive );
		}
		
		////////////////////////////////////////////////////////////////////////
		//	INCLUDE LAYOUT
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		/* override public function set includeInLayout (value:Boolean):void
		   {
		   super.includeInLayout = value;
		   if (includeInLayoutChanged)
		   {
		   if (!bInvalidateEventDispatched)
		   {
		   dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
		   bInvalidateEventDispatched = true;
		   }
		   }
		 } */
		
		/////////////////////////////////////////////////////////
		//	VALIDATION
		/////////////////////////////////////////////////////////
		
		/**
		 * Takes the given 3D isometric coordinates and positions them in cartesian coordinates relative to the parent container.
		 */
		protected function validatePosition():void
		{
			var pt:Pt = new Pt( x, y, z );
			IsoMath.isoToScreen( pt );
			
			mainContainer.x = pt.x;
			mainContainer.y = pt.y;
			
			var evt:IsoEvent = new IsoEvent( IsoEvent.MOVE, true );
			evt.propName = "position";
			evt.oldValue = { x:oldX, y:oldY, z:oldZ };
			evt.newValue = { x:isoX, y:isoY, z:isoZ };
			
			dispatchEvent( evt );
		}
		
		/**
		 * Takes the given 3D isometric sizes and performs the necessary rendering logic.
		 */
		protected function validateSize():void
		{
			var evt:IsoEvent = new IsoEvent( IsoEvent.RESIZE, true );
			evt.propName = "size";
			evt.oldValue = { width:oldWidth, length:oldLength, height:oldHeight };
			evt.newValue = { width:isoWidth, length:isoLength, height:isoHeight };
			
			dispatchEvent( evt );
		}
		
		/////////////////////////////////////////////////////////
		//	INVALIDATION
		/////////////////////////////////////////////////////////
		
		/**
		 * @private
		 *
		 * Flag indicated that an IsoEvent.INVALIDATE has already been dispatched, negating the need to dispatch another.
		 */
		as3isolib_internal var bInvalidateEventDispatched:Boolean = false;
		
		/**
		 * @private
		 */
		as3isolib_internal var bPositionInvalidated:Boolean = false;
		
		/**
		 * @private
		 */
		as3isolib_internal var bSizeInvalidated:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function invalidatePosition():void
		{
			bPositionInvalidated = true;
			
			if ( !bInvalidateEventDispatched )
			{
				dispatchEvent( new IsoEvent( IsoEvent.INVALIDATE ) );
				bInvalidateEventDispatched = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateSize():void
		{
			bSizeInvalidated = true;
			
			if ( !bInvalidateEventDispatched )
			{
				dispatchEvent( new IsoEvent( IsoEvent.INVALIDATE ) );
				bInvalidateEventDispatched = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isInvalidated():Boolean
		{
			return ( bPositionInvalidated || bSizeInvalidated );
		}
		
		/////////////////////////////////////////////////////////
		//	CREATE CHILDREN
		/////////////////////////////////////////////////////////
		
		override protected function createChildren():void
		{
			super.createChildren();
			//mainContainer.flatten();
			//mainContainer.cacheAsBitmap = _isAnimated;
		}
		
		/////////////////////////////////////////////////////////
		//	CLONE
		/////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function clone():*
		{
			var CloneClass:Class = getDefinitionByName( getQualifiedClassName( this ) ) as Class;
			
			var cloneInstance:IIsoDisplayObject = new CloneClass();
			cloneInstance.setSize( isoWidth, isoLength, isoHeight );
			
			return cloneInstance;
		}
		
		/////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		/////////////////////////////////////////////////////////
		
		private function createObjectFromDescriptor( descriptor:Object ):void
		{
			var prop:String;
			for ( prop in descriptor )
			{
				if ( this.hasOwnProperty( prop ) )
					this[ prop ] = descriptor[ prop ];
			}
		}
		
		/**
		 * Constructor
		 */
		public function IsoDisplayObject( descriptor:Object = null )
		{
			super();
			
			if ( descriptor )
				createObjectFromDescriptor( descriptor );
		}
	}
}