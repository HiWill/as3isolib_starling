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
package as3isolibstarling.data
{
	import __AS3__.vec.Vector;
	
	import as3isolibstarling.core.as3isolib_internal;
	import as3isolibstarling.events.IsoEvent;
	
	import eDpLibstarling.events.EventDispatcherProxy;
	
	use namespace as3isolib_internal;
	
	/**
	 * A base hierachical data structure class.
	 */
	public class Node extends EventDispatcherProxy implements INode
	{
		////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function Node()
		{
			super();
		}
		
		////////////////////////////////////////////////////////////////////////
		//	ID
		////////////////////////////////////////////////////////////////////////
		
		static private var _IDCount:uint = 0;
		
		/**
		 * @private
		 */
		public const UID:uint = _IDCount++;
		
		/**
		 * @private
		 */
		protected var setID:String;
		
		/**
		 * @private
		 */
		public function get id():String
		{
			return ( setID == null || setID == "" ) ?
				"node" + UID.toString() :
				setID;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set id( value:String ):void
		{
			setID = value;
		}
		
		////////////////////////////////////////////////
		//	NAME
		////////////////////////////////////////////////
		
		private var _name:String;
		
		/**
		 * @private
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	DATA
		////////////////////////////////////////////////////////////////////////
		
		private var _data:Object;
		
		/**
		 * @private
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set data( value:Object ):void
		{
			_data = value;
		}
		
		//////////////////////////////////////////////////////////////////
		//	OWNER
		//////////////////////////////////////////////////////////////////
		
		as3isolib_internal var ownerObject:Object;
		
		/**
		 * @inheritDoc
		 */
		public function get owner():Object
		{
			return ownerObject ? ownerObject : parentNode;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	PARENT
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			return parentNode ? true : false;
		}
		
		/**
		 * @private
		 */
		as3isolib_internal var parentNode:INode;
		
		/**
		 * @inheritDoc
		 */
		[ClassUtil( ignore = "true" )]
		public function get parent():INode
		{
			return parentNode;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	ROOT NODE
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function getRootNode():INode
		{
			var p:INode = this;
			
			while ( p.hasParent )
				p = p.parent;
			
			return p;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDescendantNodes( includeBranches:Boolean = false ):Array
		{
			var descendants:Array = [];
			
			var child:INode;
			
			for each ( child in childrenArray )
			{
				if ( child.children.length > 0 )
				{
					descendants = descendants.concat( child.getDescendantNodes( includeBranches ));
					
					if ( includeBranches )
						descendants.push( child );
				}
				
				else
					descendants.push( child );
			}
			
			return descendants;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CHILD METHODS
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function contains( value:INode ):Boolean
		{
			if ( value.hasParent )
				return value.parent == this;
			
			else
			{
				var child:INode;
				
				for each ( child in childrenArray )
				{
					if ( child == value )
						return true;
				}
				
				return false;
			}
		}
		
		as3isolib_internal var childrenArray:Array = [];
		
		/**
		 * @inheritDoc
		 */
		public function get children():Array
		{
			return childrenArray;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numChildren():uint
		{
			return childrenArray.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addChild( child:INode ):void
		{
			addChildAt( child, numChildren );
		}
		
		/**
		 * @inheritDoc
		 */
		public function addChildAt( child:INode, index:uint ):void
		{
			//if it already exists here, do nothing
			if ( getChildByID( child.id ))
				return;
			
			//if it has another parent, then remove it there
			if ( child.hasParent )
			{
				var parent:INode = child.parent;
				parent.removeChildByID( child.id );
			}
			
			Node( child ).parentNode = this;
			childrenArray.splice( index, 0, child );
			
			var evt:IsoEvent = new IsoEvent( IsoEvent.CHILD_ADDED );
			evt.newValue = child;
			
			dispatchEvent( evt );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getChildAt( index:uint ):INode
		{
			if ( index >= numChildren )
				throw new Error( "" );
			
			else
				return INode( childrenArray[ index ]);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getChildIndex( child:INode ):int
		{
			var i:int;
			
			while ( i < numChildren )
			{
				if ( child == childrenArray[ i ])
					return i;
				
				i++;
			}
			
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setChildIndex( child:INode, index:uint ):void
		{
			var i:int = getChildIndex( child );
			
			// Don't bother if it's already at this index
			if ( i == index )
				return;
			
			if ( i > -1 )
			{
				childrenArray.splice( i, 1 ); //remove it form the array
				
				//now let's check to see if it really did remove the correct choice - this may not be necessary but I get OCD about crap like this
				var c:INode;
				var notRemoved:Boolean = false;
				
				for each ( c in childrenArray )
				{
					if ( c == child )
						notRemoved = true;
				}
				
				if ( notRemoved )
				{
					throw new Error( "" );
					return;
				}
				
				if ( index >= numChildren )
					childrenArray.push( child );
				
				else
					childrenArray.splice( index, 0, child );
			}
			
			else
				throw new Error( "" );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeChild( child:INode ):INode
		{
			return removeChildByID( child.id );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeChildAt( index:uint ):INode
		{
			var child:INode;
			
			if ( index >= numChildren )
				return null;
			
			else
				child = INode( childrenArray[ index ]);
			
			return removeChildByID( child.id );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeChildByID( id:String ):INode
		{
			var child:INode = getChildByID( id );
			
			if ( child )
			{
				//remove parent ref
				Node( child ).parentNode = null;
				
				//remove from children array
				var i:uint;
				
				for ( i; i < childrenArray.length; i++ )
				{
					if ( child == childrenArray[ i ])
					{
						childrenArray.splice( i, 1 );
						break;
					}
				}
				
				var evt:IsoEvent = new IsoEvent( IsoEvent.CHILD_REMOVED );
				evt.newValue = child;
				
				dispatchEvent( evt );
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllChildren():void
		{
			var child:INode;
			
			for each ( child in childrenArray )
				Node( child ).parentNode = null;
			
			childrenArray.length = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getChildByID( id:String ):INode
		{
			var childID:String;
			var child:INode;
			
			for each ( child in childrenArray )
			{
				childID = child.id;
				
				if ( childID == id )
					return child;
			}
			
			return null;
		}
	}
}
