package  {
	
	import flash.display.MovieClip;
	
	public class Target extends MovieClip {

		//FS = from submarine
		public var distanceFS:Number;
		public var angleFS:Number;
		public var hearingAngleFS:Number;
		
		public var main:Main;

		public function Target() {
			distanceFS = 0; // distance is not square rooted for efficiency
			angleFS = 0;
			hearingAngleFS = 0;
		}
		
		public function update():void {			
			var dX:Number = this.x - main.submarine.x;
			var dY:Number = this.y - main.submarine.y;
			
			// calculate distance (without square root)
			distanceFS = dX*dX + dY*dY;
			
			// calculate angle
			angleFS = Math.atan2(dY,dX)*180/Math.PI;
			if(angleFS < 0) {
				angleFS *= -1;
			} else {
				angleFS = 360 - angleFS;
			}
			
			// hearing angle calculated in Submarine
			
		}

	}
	
}
