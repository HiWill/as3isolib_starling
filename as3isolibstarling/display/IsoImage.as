package as3isolibstarling.display 
{
	import as3isolibstarling.core.IsoDisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author yf
	 */
	public class IsoImage extends IsoDisplayObject 
	{
		public function IsoImage(vImage:Image,descriptor:Object = null ) 
		{
			mainContainer = vImage;
			super(descriptor);
		}
		public function get image():Image
		{
			return mainContainer as Image;
		}
		public function set image(vImage:Image):void
		{
			if (mainContainer && mainContainer.parent )
			{
				if ( vImage != mainContainer)
				{
					var temp:DisplayObjectContainer = mainContainer.parent;
					var tempIndex:int = temp.getChildIndex(mainContainer);
				    temp.removeChild(mainContainer);
					vImage.x = mainContainer.x;
					vImage.y = mainContainer.y;
					mainContainer = vImage;
					temp.addChildAt(mainContainer, tempIndex); 
				} 
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if (mainContainer == null)
			{
				throw new Error( "mainContainer is null" );
			}
			attachMainContainerEventListeners();
		}
	}

}