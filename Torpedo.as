package
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
 
	public class Torpedo extends MovieClip
	{
		private var main:Main
		private var startX:int;
		private var startY:int;
 		private var speed:Number = 4;
		private var xSpeed: Number;
		private var ySpeed: Number;
		private var sub:Submarine;
		
		public var asset:MovieClip;
 
		public function Torpedo(main:Main, sub:Submarine, startX:int, startY:int) : void
		{
			this.main = main;
			this.sub = sub;
			this.x = startX;
			this.y = startY;
			this.startX = startX;
			this.startY = startY;
			
			this.rotation = sub.rotation;			
			xSpeed = speed*Math.cos(sub.rotation*Math.PI/180);
			ySpeed = speed*Math.sin(sub.rotation*Math.PI/180);
			
			main.gameLayer.addChild(this);
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
 
		private function loop(e:Event) : void
		{
			x += xSpeed;
			y += ySpeed;
			if (x > (startX+300) || x < (startX-300))
			{
				main.soundEngine.playSound(Sounds.voiceTargetMissed);
				removeSelf();
			}
			else if (y > (startY+300) || y < (startY-300))
			{
				main.soundEngine.playSound(Sounds.voiceTargetMissed);
				removeSelf();
			}
			else
			{
				for (var i:int = main.targets.length-1; i>=0; i--)
				{
					if (hitTestObject(main.targets[i]) && (main.targets[i].getObjectName() == "Mine" || main.targets[i].getObjectName() == "Enemy") )
					{
						main.soundEngine.playSoundPositional(Sounds.explosion, main.targets[i].getVolume(), main.targets[i].getPan());
						if (main.contains(main.targets[i]))
						{
							main.gameLayer.removeChild(main.targets[i]);
						}
						main.targets.splice(i,1);
						removeSelf();
						main.soundEngine.playSound(Sounds.voiceTargetHit);
					}
				}
			}
		}
 
		private function removeSelf() : void
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			if (main.gameLayer.contains(this))
				main.gameLayer.removeChild(this);
		}
	}
}