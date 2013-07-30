package as3isolibstarling.geom.transformations
{
	import as3isolibstarling.geom.Pt;
	
	/**
	 * @private
	 */
	public class DimetricTransformation implements IAxonometricTransformation
	{
		public function DimetricTransformation ()
		{
		}

		public function screenToSpace (screenPt:Pt):Pt
		{
			return null;
		}
		
		public function spaceToScreen (spacePt:Pt):Pt
		{
			/* if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * axialProjection;
				spacePt.y = spacePt.y * axialProjection;
			} */		
			
			var z:Number = spacePt.z;
			var y:Number = spacePt.y / 4 - spacePt.z;
			var x:Number = spacePt.x - spacePt.y / 2;
			
			return new Pt(x, y, z);
		}
		
	}
}