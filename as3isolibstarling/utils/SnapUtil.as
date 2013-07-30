package as3isolibstarling.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author yf
	 */
	public class SnapUtil 
	{
		
		public function SnapUtil() 
		{
			
		}
		
		static public function snapClip(clip:DisplayObject):BitmapData
		{  
			var bd:BitmapData;
			var realBounds:Rectangle = getRealBounds(clip,clip.parent);
			var bitmap:BitmapData = new BitmapData(realBounds.width, realBounds.height, true, 0);
			var mat:Matrix = clip.transform.matrix;
			mat.translate(-realBounds.x , -realBounds.y ); 
			bitmap.draw(clip, mat);
			//remove alpha frame
			var rect:Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x00000000, false) ;
			if (rect.width != bitmap.width || rect.height != bitmap.height)
			{
				bd = new BitmapData(rect.width, rect.height, true, 0);
				bd.copyPixels(bitmap, rect, new Point(0, 0));
			}
			else
			{
				bd = bitmap;
			} 
			
			return bd;
		}
		
		static public function getRealBounds(clip:DisplayObject,parent:DisplayObject):Rectangle
			{ 
				var bounds:Rectangle = clip.getBounds(parent); 
				if (clip.width == 0 || clip.height == 0)
				{
					return new Rectangle(0, 0, 0, 0);
				}
				bounds.x = Math.floor(bounds.x);
				bounds.y = Math.floor(bounds.y);
				bounds.height = Math.ceil(bounds.height);
				bounds.width = Math.ceil(bounds.width);
				var realBounds:Rectangle = new Rectangle(0, 0, bounds.width , bounds.height ); 
				if (clip.filters.length > 0)
				{
					var j:int = 0;
					var clipFilters:Array = clip.filters;
					var clipFiltersLength:int = clipFilters.length;
					var tmpBData:BitmapData;
					var filterRect:Rectangle;
					
					tmpBData = new BitmapData(realBounds.width, realBounds.height, false);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					
					while (++j < clipFiltersLength)
					{
						filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
						realBounds = realBounds.union(filterRect); 
					}
					tmpBData.dispose();
				}
				realBounds.offset(bounds.x, bounds.y);
				realBounds.width = Math.max(realBounds.width, 1);
				realBounds.height = Math.max(realBounds.height, 1);
				
				if (clip is DisplayObjectContainer)
				{
					var container:DisplayObjectContainer = clip as DisplayObjectContainer;
					for (var i:int = 0; i < container.numChildren; i++)
					{
						var tempBounds:Rectangle = getRealBounds(container.getChildAt(i),parent);
						realBounds = realBounds.union(tempBounds);
					}
				}
				tmpBData = null;
				return realBounds;
			} 
	}

}