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
package as3isolibstarling.display.scene
{
	
	import as3isolibstarling.bounds.IBounds;
	import as3isolibstarling.bounds.SceneBounds;
	import as3isolibstarling.core.IIsoDisplayObject;
	import as3isolibstarling.core.IsoContainer;
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.data.INode;
	import as3isolibstarling.display.renderers.DefaultSceneLayoutRenderer;
	import as3isolibstarling.display.renderers.ISceneLayoutRenderer;
	import as3isolibstarling.display.renderers.ISceneRenderer;
	import as3isolibstarling.events.IsoEvent;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;

	use namespace as3isolib_internal;
	
	/**
	 * IsoScene is a base class for grouping and rendering IIsoDisplayObject children according to their isometric position-based depth.
	 */
	public class IsoScene extends IsoContainer implements IIsoScene
	{		
		///////////////////////////////////////////////////////////////////////////////
		//	BOUNDS
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _isoBounds:IBounds;
		
		/**
		 * @inheritDoc
		 */
		public function get isoBounds ():IBounds
		{
			/* if (!_isoBounds || isInvalidated)
				_isoBounds =  */
			
			return new SceneBounds(this);
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	HOST CONTAINER
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var host:DisplayObjectContainer;
		
		as3isolib_internal
		
		/**
		 * @private
		 */
		public function get hostContainer ():DisplayObjectContainer
		{
			return host;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set hostContainer (value:DisplayObjectContainer):void
		{
			if (value && host != value)
			{
				if (host && host.contains(container))
				{
					host.removeChild(container);
					ownerObject = null;
				}
				
				else if (hasParent)
					parent.removeChild(this);
				
				host = value;
				if (host)
				{
					host.addChild(container);
					ownerObject = host;
					parentNode = null;
				}
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	INVALIDATE CHILDREN
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 * 
		 * Array of invalidated children.  Each child dispatches an IsoEvent.INVALIDATION event which notifies 
		 * the scene that that particular child is invalidated and subsequentally the scene is also invalidated.
		 */
		protected var invalidatedChildrenArray:Array = [];
		
		/**
		 * @inheritDoc
		 */
		public function get invalidatedChildren ():Array
		{
			return invalidatedChildrenArray;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	OVERRIDES
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt (child:INode, index:uint):void
		{
			if (child is IIsoDisplayObject)
			{
				super.addChildAt(child, index);
				child.addEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
				
				bIsInvalidated = true; //since the child most likely had fired an invalidation event prior to being added, manually invalidate the scene
			}
				
			else
				throw new Error ("parameter child is not of type IIsoDisplayObject");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setChildIndex (child:INode, index:uint):void
		{
			super.setChildIndex(child, index);
			bIsInvalidated = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildByID (id:String):INode
		{
			var child:INode = super.removeChildByID(id);
			if (child)
			{
				child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
				bIsInvalidated = true;
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllChildren ():void
		{			
			var child:INode
			for each (child in children)
				child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			
			super.removeAllChildren();
			bIsInvalidated = true;
		}
		
		/**
		 * Renders the scene as invalidated if a child object is invalidated.
		 * 
		 * @param evt The IsoEvent dispatched from the invalidated child.
		 */
		protected function child_invalidateHandler (evt:IsoEvent):void
		{
			var child:Object = evt.target;
			if (invalidatedChildrenArray.indexOf(child) == -1)
				invalidatedChildrenArray.push(child);
			
			bIsInvalidated = true;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	LAYOUT RENDERER
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flags the scene for possible layout rendering.
		 * If false, child objects are sorted by the order they were added rather than by their isometric depth.
		 */
		public var layoutEnabled:Boolean = true;
		
		private var bLayoutIsFactory:Boolean = true;//flag telling us whether we decided to persist an ISceneLayoutRenderer or using a Factory each time.
		private var layoutObject:Object;
		
		/**
		 * The object used to layout a scene's children.  This value can be either an IFactory or ISceneLayoutRenderer.
		 * If the value is an IFactory, then a renderer is created and discarded on each render pass.  
		 * If the value is an ISceneLayoutRenderer, then a renderer is created and stored.
		 * This option infrequently rendered scenes to free up memeory by releasing the factory instance.
		 * If this IsoScene is expected be invalidated frequently, then persisting an instance in memory might provide better performance.
		 */
		public function get layoutRenderer ():Object
		{
			return layoutObject;
		}
		
		/**
		 * @private
		 */
		public function set layoutRenderer (value:Object):void
		{
			if (!value)
			{
				layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
				
				bLayoutIsFactory = true;
				bIsInvalidated = true;
			}
			
			if (value && layoutObject != value)
			{
				if (value is IFactory)
					bLayoutIsFactory = true;
				
				else if (value is ISceneLayoutRenderer)
					bLayoutIsFactory = false;
				
				else
					throw new Error("value for layoutRenderer is not of type IFactory or ISceneLayoutRenderer");
				
				layoutObject = value;				
				bIsInvalidated = true;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	STYLE RENDERERS
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flags the scene for possible style rendering.
		 */
		public var stylingEnabled:Boolean = true;
		
		private var styleRendererFactories:Vector.<IFactory> = new Vector.<IFactory>();
		
		/**
		 * @private
		 */
		public function get styleRenderers ():Array
		{
			var temp:Array = [];
			var factory:IFactory;
			for each (factory in styleRendererFactories)
				temp.push(factory);
			
			return temp;
		}
		
		/**
		 * An array of IFactories whose class generators are ISceneRenderer.
		 * If any value contained within the array is not of type IFactory, it will be ignored.
		 */
		public function set styleRenderers (value:Array):void
		{
			if (value)
				styleRendererFactories = Vector.<IFactory>(value);
			
			else
				styleRendererFactories = null;
			
			bIsInvalidated = true;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	INVALIDATION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flags the scene as invalidated during the rendering process
		 */
		public function invalidateScene ():void
		{
			bIsInvalidated = true;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	RENDER
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override protected function renderLogic (recursive:Boolean = true):void
		{
			super.renderLogic(recursive); //push individual changes thru, then sort based on new visible content of each child
			
			if (bIsInvalidated)
			{
				//render the layout first
				if (layoutEnabled)
				{
					var sceneLayoutRenderer:ISceneLayoutRenderer;
					if (bLayoutIsFactory)
						sceneLayoutRenderer = IFactory(layoutObject).newInstance();
					
					else
						sceneLayoutRenderer = ISceneLayoutRenderer(layoutObject);
					
					if (sceneLayoutRenderer)
						sceneLayoutRenderer.renderScene(this);
				}
				
				//fix for bug #20 - http://code.google.com/p/as3isolib/issues/detail?id=20
				var sceneRenderer:ISceneRenderer;
				var factory:IFactory
				if (stylingEnabled && styleRendererFactories.length > 0)
				{
					//mainContainer.graphics.clear();
											
					for each (factory in styleRendererFactories)
					{
						sceneRenderer = factory.newInstance();
						if (sceneRenderer)
							sceneRenderer.renderScene(this);
					}
				}
				
				bIsInvalidated = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function postRenderLogic ():void
		{
			invalidatedChildrenArray = [];
			
			super.postRenderLogic();
			//should we still call sceneRendered()?
			sceneRendered();
		}
		
		/**
		 * This function has been deprecated.  Please refer to postRenderLogic.
		 */
		protected function sceneRendered ():void
		{
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoScene ()
		{
			super();
			
			layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
		}
		override protected function createChildren():void
		{
			//overriden by subclasses
			mainContainer = new Sprite();
			attachMainContainerEventListeners();		
		}
	}
}