package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Main extends MovieClip {
		public var soundEngine:SoundEngine;
		public var submarine:Submarine;
		public var mine:Mine;
		
		public function Main() {
			soundEngine = SoundEngine.getInstance();
			submarine = new Submarine(this);
			mine = new Mine(this);
			
			this.addChild(submarine);
			this.addChild(mine);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			//soundEngine.playSound(Sounds.ping);
		}
		
		public function update(e:Event):void {
			//trace("sup");
			soundEngine.update();
			//soundEngine.playSound(Sounds.ping);
		}
	}
	
}
