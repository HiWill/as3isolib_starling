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
	import eDpLibstarling.events.IEventDispatcherProxy;
	
	public interface INode extends IEventDispatcherProxy
	{
		////////////////////////////////////////////////
		//	ID
		////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get id():String;
		
		/**
		 * The identifier string.
		 */
		function set id( value:String ):void;
		
		////////////////////////////////////////////////
		//	NAME
		////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get name():String;
		
		/**
		 * An additional identifier string.
		 */
		function set name( value:String ):void;
		
		////////////////////////////////////////////////
		//	DATA
		////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get data():Object;
		
		/**
		 * A generic data storage property.
		 */
		function set data( value:Object ):void;
		
		//////////////////////////////////////////////////////////////////
		//	OWNER
		//////////////////////////////////////////////////////////////////
		
		/**
		 * The owner of this INode.  By default this is the parent object, however more abstract relationships may exist.
		 */
		function get owner():Object;
		
		////////////////////////////////////////////////
		//	PARENT
		////////////////////////////////////////////////
		
		/**
		 * The parent INode within the node heirarchy structure.
		 */
		function get parent():INode;
		
		/**
		 * A flag indicating if this INode has a parent node.
		 */
		function get hasParent():Boolean;
		
		/**
		 * Retrieves the top-most INode within this node hierarchy.
		 *
		 * @returns INode The top-most INode.
		 */
		function getRootNode():INode;
		
		/**
		 * Retrieves the furthest descendant nodes within the node hierarchy.
		 *
		 * @param includeBranches Flag indicating that during each point of recursion adds descendant nodes.  If false, only leaf nodes are returned.
		 * @return Array A flat array consisting of all possible descendant nodes.
		 */
		function getDescendantNodes( includeBranches:Boolean = false ):Array;
		
		////////////////////////////////////////////////
		//	CHILD METHODS
		////////////////////////////////////////////////
		
		/**
		 * Determines if a particular INodes is an immediate child of this INode.
		 *
		 * @param value The INode to check for.
		 * @returns Boolean Returns true if this INode contains the given value as a child INode, false otherwise.
		 */
		function contains( value:INode ):Boolean;
		
		/**
		 * An array representing the immediate child INodes.
		 */
		function get children():Array;
		
		/**
		 * Indicates how many child nodes fall underneath this node within a particular heirarchical structure.
		 */
		function get numChildren():uint;
		
		/**
		 * Adds a child at the end of the display list.
		 *
		 * @param child The INode to add this node's heirarchy.
		 */
		function addChild( child:INode ):void;
		
		/**
		 * Adds a child to the display list at the specified index.
		 *
		 * @param child The INode to add this node's heirarchy.
		 * @param index The target index to add the child.
		 */
		function addChildAt( child:INode, index:uint ):void;
		
		/**
		 * Returns the index of a given child node or -1 if the child doesn't exist within the node's hierarchy.
		 *
		 * @param child The INdode whose index is to be retreived.
		 * @return int The child index or -1 if the child's parent is null.
		 */
		function getChildIndex( child:INode ):int;
		
		/**
		 * Returns the child node at the given index.
		 *
		 * @param index The index of the child to retrieve.
		 * @returns INode The child at the given index.
		 */
		function getChildAt( index:uint ):INode;
		
		/**
		 * Returns the child node with the given id.
		 *
		 * @param id The id of the child to retrieve.
		 * @returns INode The child at with the given id.
		 */
		function getChildByID( id:String ):INode;
		
		/**
		 * Moves a child node to the provided index
		 *
		 * @param child The child node whose index is to be changed.
		 * @param index The destination index to move the child node to.
		 */
		function setChildIndex( child:INode, index:uint ):void;
		
		/**
		 * Removes the specified child.
		 *
		 * @param child The INode to remove from the children hierarchy.
		 * @return INode The child that was removed.
		 */
		function removeChild( child:INode ):INode;
		
		/**
		 * Removes the child at the specified index.
		 *
		 * @param index The INode's index to remove from the children hierarchy.
		 * @return INode The child that was removed.
		 */
		function removeChildAt( index:uint ):INode;
		
		/**
		 * Removes the child with the specified id.
		 *
		 * @param id The INode's id to remove from the children hierarchy.
		 * @return INode The child that was removed.
		 */
		function removeChildByID( id:String ):INode;
		
		/**
		 * removes all child INodes.
		 */
		function removeAllChildren():void;
	}
}