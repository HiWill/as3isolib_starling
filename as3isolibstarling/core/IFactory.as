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
	import mx.core.IFactory;
	
	[Deprecated(replacement="mx.core.IFactory")]
	/**
	 * This interface is now deprecated.  This is an exact duplicate of mx.core.IFactory located in the Flex SDK by Adobe.
	 * Developers are incouraged to use the mx.core.IFactory instead.
	 * 
	 * The IFactory interface defines the interface that factory classes such as ClassFactory must implement.
	 * An object of type IFactory is a "factory object" which Flex uses to generate multiple instances of another class,
	 * each with identical properties. 
	 */
	public interface IFactory extends mx.core.IFactory
	{
	}
}