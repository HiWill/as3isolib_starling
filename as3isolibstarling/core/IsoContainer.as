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
	import __AS3__.vec.Vector;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import as3isolibstarling.data.INode;
	import as3isolibstarling.data.Node;
	import as3isolibstarling.events.IsoEvent;
	
	import eDpLibstarling.events.ProxyEvent;
	
	
	use namespace as3isolib_internal;
	
	/**
	 * IsoContainer is the base class that any isometric object must extend in order to be shown in the display list.
	 * Developers should not instantiate this class directly but rather extend it.
	 */
	public class IsoContainer extends Node implements IIsoContainer
	{
		//////////////////////////////////////////////////////////////////
		//	INCLUDE IN LAYOUT
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var bIncludeInLayout:Boolean = true;
		
		/**
		 * @private
		 */
		protected var includeInLayoutChanged:Boolean = false;
		
		/**
		 * @private
		 */
		public function get includeInLayout():Boolean
		{
			return bIncludeInLayout;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set includeInLayout( value:Boolean ):void
		{
			if ( bIncludeInLayout != value )
			{
				bIncludeInLayout = value;
				includeInLayoutChanged = true;
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	DISPLAY LIST CHILDREN
		////////////////////////////////////////////////////////////////////////
		
		protected var displayListChildrenArray:Vector.<IIsoContainer> = new Vector.<IIsoContainer>();
		
		/**
		 * @inheritDoc
		 */
		public function get displayListChildren():Array
		{
			var temp:Array = [];
			var child:IIsoContainer;
			
			for each ( child in displayListChildrenArray )
				temp.push( child );
			
			return temp;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CHILD METHODS
		////////////////////////////////////////////////////////////////////////
		
		//	ADD
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt( child:INode, index:uint ):void
		{
			var container:DisplayObjectContainer = mainContainer as DisplayObjectContainer;
			if (container == null)
			{
				throw new Error( "mainContainer is not a DisplayObjectContainer" );
				return;
			}
			if (child is IIsoContainer )
			{
				super.addChildAt( child, index );
				
				if ( IIsoContainer( child ).includeInLayout )
				{
					displayListChildrenArray.push( child );
					
					if ( index > container.numChildren )
						index = container.numChildren;
					
					//referencing explicit removal of child RTE - http://life.neophi.com/danielr/2007/06/rangeerror_error_2006_the_supp.html
					var p:DisplayObjectContainer = IIsoContainer( child ).container.parent;
					
					if ( p && p != mainContainer )
						p.removeChild( IIsoContainer( child ).container );
					
					container.addChildAt( IIsoContainer( child ).container, index );
				}
			}
			
			else
				throw new Error( "parameter child does not implement IContainer." );
		}
		
		//	SWAP
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function setChildIndex( child:INode, index:uint ):void
		{
			var container:DisplayObjectContainer = mainContainer as DisplayObjectContainer;
			if (container == null)
			{
				throw new Error( "mainContainer is not a DisplayObjectContainer" );
				return;
			}
			
			if ( !child is IIsoContainer )
				throw new Error( "parameter child does not implement IContainer." );
			
			else if ( !child.hasParent || child.parent != this )
				throw new Error( "parameter child is not found within node structure." );
			
			else
			{
				super.setChildIndex( child, index );
				container.setChildIndex( IIsoContainer( child ).container, index );
			}
		}
		
		//	REMOVE
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildByID( id:String ):INode
		{
			var container:DisplayObjectContainer = mainContainer as DisplayObjectContainer;
			if (container == null)
			{
				throw new Error( "mainContainer is not a DisplayObjectContainer" );
				return;
			}
			
			var child:IIsoContainer = IIsoContainer( super.removeChildByID( id ));
			
			if ( child && child.includeInLayout )
			{
				var i:int = displayListChildrenArray.indexOf( child );
				
				if ( i > -1 )
					displayListChildrenArray.splice( i, 1 );
				
				container.removeChild( IIsoContainer( child ).container );
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllChildren():void
		{
			var container:DisplayObjectContainer = mainContainer as DisplayObjectContainer;
			if (container == null)
			{
				throw new Error( "mainContainer is not a DisplayObjectContainer" );
				return;
			}
			
			var child:IIsoContainer;
			
			for each ( child in children )
			{
				if ( child.includeInLayout )
					container.removeChild( child.container );
			}
			
			displayListChildrenArray = new Vector.<IIsoContainer>();
			
			super.removeAllChildren();
		}
		
		//	CREATE
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initialization method to create the child IContainer objects.
		 */
		protected function createChildren():void
		{
			//overriden by subclasses
			mainContainer = new Sprite();
			attachMainContainerEventListeners();
		    //mainContainer.flatten();
			//mainContainer.cacheAsBitmap = true;		
		}
		
		/**
		 * Attaches certain listener logic for adding and removing the main container from the stage and display list.
		 * Subclasses of IsoContainer that explicitly set/override the mainContainer (e.g. IsoSprite) should call this class afterwards.
		 */
		protected function attachMainContainerEventListeners():void
		{
			if ( mainContainer )
			{
				mainContainer.addEventListener( Event.ADDED, mainContainer_addedHandler );
				mainContainer.addEventListener( Event.ADDED_TO_STAGE, mainContainer_addedToStageHandler );
				mainContainer.addEventListener( Event.REMOVED, mainContainer_removedHandler );
				mainContainer.addEventListener( Event.REMOVED_FROM_STAGE, mainContainer_removedFromStageHandler );
			}
		}
		
		///////////////////////////////////////////////////////////////////////
		//	DISPLAY LIST & STAGE LOGIC
		///////////////////////////////////////////////////////////////////////
		
		private var bAddedToDisplayList:Boolean;
		
		private var bAddedToStage:Boolean;
		
		public function get isAddedToDisplay():Boolean
		{
			return bAddedToDisplayList;
		}
		
		public function get isAddedToStage():Boolean
		{
			return bAddedToStage;
		}
		
		private function mainContainer_addedHandler( evt:Event ):void
		{
			bAddedToDisplayList = true;
		}
		
		private function mainContainer_addedToStageHandler( evt:Event ):void
		{
			bAddedToStage = true;
		}
		
		private function mainContainer_removedHandler( evt:Event ):void
		{
			bAddedToDisplayList = false;
		}
		
		private function mainContainer_removedFromStageHandler( evt:Event ):void
		{
			bAddedToStage = false;
		}
		
		/////////////////////////////////////////////////////////////////
		//	IS INVALIDATED
		/////////////////////////////////////////////////////////////////
		
		as3isolib_internal var bIsInvalidated:Boolean;
		
		/**
		 * @inheritDoc
		 */
		public function get isInvalidated():Boolean
		{
			return bIsInvalidated;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	RENDER
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function render( recursive:Boolean = true ):void
		{
			preRenderLogic();
			renderLogic( recursive );
			postRenderLogic();
		}
		
		/**
		 * Performs any logic prior to executing actual rendering logic on the IIsoContainer.
		 */
		protected function preRenderLogic():void
		{
			dispatchEvent( new IsoEvent( IsoEvent.RENDER ));
		}
		
		/**
		 * Performs actual rendering logic on the IIsoContainer.
		 *
		 * @param recursive Flag indicating if child objects render upon validation.  Default value is <code>true</code>.
		 */
		protected function renderLogic( recursive:Boolean = true ):void
		{
			if ( includeInLayoutChanged && parentNode )
			{
				var p:IIsoContainer = IIsoContainer( parentNode );
				var i:int = p.displayListChildren.indexOf( this );
				
				if ( bIncludeInLayout )
				{
					if ( i == -1 )
						p.displayListChildren.push( this );
				}
				
				else if ( !bIncludeInLayout )
				{
					if ( i >= 0 )
						p.displayListChildren.splice( i, 1 );
				}
				
				mainContainer.visible = bIncludeInLayout; //rather than removing or adding to display list, we leave it be and just leave it to the flash player to maintain
				
				includeInLayoutChanged = false;
			}
			
			if ( recursive )
			{
				var child:IIsoContainer;
				
				for each ( child in children )
					renderChild( child );
			}
		}
		
		/**
		 * Performs any logic after executing actual rendering logic on the IIsoContainer.
		 */
		protected function postRenderLogic():void
		{
			dispatchEvent( new IsoEvent( IsoEvent.RENDER_COMPLETE ));
		}
		
		protected function renderChild( child:IIsoContainer ):void
		{
			child.render( true );
		}
		
		protected function child_changeHandler( evt:Event ):void
		{
			bIsInvalidated = true;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	EVENT DISPATCHER PROXY
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function dispatchEvent( event:Event ):void
		{
			//so we can make use of the bubbling events via the display list
			if ( event.bubbles )
				return proxyTarget.dispatchEvent( new ProxyEvent( this, event ));
			
			else
				return super.dispatchEvent( event );
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CONTAINER STRUCTURE
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var mainContainer:DisplayObject;
		
		/**
		 * @inheritDoc
		 */
		public function get depth():int
		{
			if ( mainContainer.parent )
				return mainContainer.parent.getChildIndex( mainContainer );
			
			else
				return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get container():DisplayObject
		{
			return mainContainer;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoContainer()
		{
			super();
			addEventListener( IsoEvent.CHILD_ADDED, child_changeHandler );
			addEventListener( IsoEvent.CHILD_REMOVED, child_changeHandler );
			
			createChildren();
			
			proxyTarget = mainContainer;
		}
	}
}