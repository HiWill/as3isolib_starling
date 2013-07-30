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
		public function IsoImage(descriptor:Object = null ) 
		{
			super(descriptor);
		}
		public function get image():Image
		{
			return mainContainer as Image;
		}
		public function set image(vImage:Image):void
		{
			if (mainContainer == null)
			{
				updateImage(vImage);
			}
			else if (mainContainer && vImage != mainContainer)
			{
				if (mainContainer.parent)
				{
					var temp:DisplayObjectContainer = mainContainer.parent;
					var tempIndex:int = temp.getChildIndex(mainContainer);
					temp.removeChild(mainContainer);
					vImage.x = mainContainer.x;
					vImage.y = mainContainer.y;
					temp.addChildAt(vImage, tempIndex); 
				} 
				updateImage(vImage);
			}
		}
		private function updateImage(vImage:Image):void
		{
			mainContainer = vImage;
			createChildren();
			proxyTarget = mainContainer;
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			attachMainContainerEventListeners();
		}
	}

}
