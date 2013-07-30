////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package as3isolibstarling.core
{
	import flash.events.IEventDispatcher;
	
	import mx.core.ClassFactory;
	import mx.core.IMXMLObject;
	
	/**
	 *  A ClassFactory instance is a "factory object" which Flex uses
	 *  to generate instances of another class, each with identical properties.
	 *
	 *  <p>You specify a <code>generator</code> class when you construct
	 *  the factory object.
	 *  Then you set the <code>properties</code> property on the factory object.
	 *  Flex uses the factory object to generate instances by calling
	 *  the factory object's <code>newInstance()</code> method.</p>
	 *
	 *  <p>The <code>newInstance()</code> method creates a new instance
	 *  of the <code>generator</code> class, and sets the properties specified
	 *  by <code>properties</code> in the new instance.
	 *  If you need to further customize the generated instances,
	 *  you can override the <code>newInstance()</code> method.</p>
	 *
	 *  <p>The ClassFactory class implements the IFactory interface.
	 *  Therefore it lets you create objects that can be assigned to properties 
	 *  of type IFactory.</p>
	 */
	public class ClassFactory extends mx.core.ClassFactory implements IMXMLObject
	{
		/**
		 * Constructor
		 * 
		 * @param generator The class reference used to instantiate a new instance.
		 */
		public function ClassFactory (generator:Class = null)
		{
			super(generator);
		}
		
		[Inspectable(environment="Flash")]
		[ArrayElementType("as3isolibstarling.core.EventListenerDescriptor")]
		/**
		 * A collection of event listener descriptors used to assign eventListeners to each instance created by <code>newInstance()</code>.
		 */
		public var eventListenerDescriptors:Array;
		
		/**
		 * The MXML document that created this object.
		 */
		public var document:Object;
		
		/**
		 * The identifier used by <code>document</code> to refer to this object. If the object is a deep property on <code>document</code>, <code>id</code> is null.
		 */
		public var id:String;
		
		/**
		 * @inheritDoc
		 */
		public function initialized (document:Object, id:String):void
		{
			this.document = document;
			this.id = id;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function newInstance ():*
		{
			var instance:* = super.newInstance();
			if (instance is IEventDispatcher)
			{
				var descriptor:EventListenerDescriptor;
				for each (descriptor in eventListenerDescriptors)
					IEventDispatcher(instance).addEventListener(descriptor.type, descriptor.listener, descriptor.useCapture, descriptor.priority, descriptor.useWeakReference);
			}
			
			return instance;
		}
	}
}