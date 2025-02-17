﻿package {
	
	import flash.display.MovieClip;
	
	public class Target extends MovieClip {

		//FS = from submarine
		public var distanceFS:Number;
		public var angleFS:Number;
		public var hearingAngleFS:Number;
		public var hearingVolume:Number;
		public var mySound:int;
		public var objectName:String;
		
		public var main:Main;

		public function Target() {
			distanceFS = 0; // distance is not square rooted for efficiency
			angleFS = 0;
			hearingAngleFS = 0;
			hearingVolume = 0;
		}
		
		public function getSound(): int
		{
			return mySound;
		}
		
		public function getVolume():Number{
			if (distanceFS <= 360000)
			{
				hearingVolume = (360000-distanceFS)/3600000;
				if(hearingAngleFS >= 0 && hearingAngleFS < 90)
					hearingVolume+=(90-hearingAngleFS)/1800;
				else if(hearingAngleFS >= 90 && hearingAngleFS < 180)
					hearingVolume+=(90-hearingAngleFS)/1800;
				else if(hearingAngleFS >= 180 && hearingAngleFS < 270)
					hearingVolume +=(180-hearingAngleFS)/1800;
				else if(hearingAngleFS >= 270)
					//return (hearingAngleFS - 360)/90;
					hearingVolume +=(hearingAngleFS - 270)/1800;
				//trace(hearingVolume);
				return hearingVolume + .4;
			}
			else
				return 0;
		}
		
		public function getPan():Number {
			// returns -1 through 1
			if(hearingAngleFS >= 0 && hearingAngleFS < 90)
				return hearingAngleFS/90;
			else if(hearingAngleFS >= 90 && hearingAngleFS < 180)
				return 1;
				//return (180-hearingAngleFS)/90;
			else if(hearingAngleFS >= 180 && hearingAngleFS < 270)
				return -1;
				//return (180-hearingAngleFS)/90;
			else if(hearingAngleFS >= 270)
				return (hearingAngleFS - 360)/90;
			return 0;
		}
		
		public function getObjectName():String {
			return objectName;
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
