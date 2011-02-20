package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Main extends MovieClip {
		public var soundEngine:SoundEngine;
		public var submarine:Submarine;
		public var targets:Vector.<Target>;
		public var missions:Missions;
		
		public var oldRadar:Number;
		public var newRadar:Number;
		
		public function Main() {
			soundEngine = SoundEngine.getInstance();
			soundEngine.loadAll(soundsLoaded);
			submarine = new Submarine(this);
			targets = new Vector.<Target>();
			var mine:Mine = new Mine(this);
			targets.push(mine);
			
			this.addChild(submarine);
			this.addChild(mine);
			
			mine.x = Math.random()*stage.stageWidth;
			mine.y = Math.random()*stage.stageHeight;
			
			submarine.init();
			submarine.x = stage.stageWidth/2;
			submarine.y = stage.stageHeight/2;
			
			missions = new Missions(this);
			missions.init();
			//missions.advance();
			oldRadar = 0;
			newRadar = 0;
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function update(e:Event):void {
			//trace("sup");
			soundEngine.update();
			//soundEngine.playSound(Sounds.ping);
			submarine.update();
			for(var i:int = targets.length-1; i>=0; i--) {
				targets[i].update();
			}
			radar();
		}
		
		public function soundsLoaded():void{
			trace("sounds loaded, allow game to start!");
			//soundEngine.playSoundPositional(Sounds.ping, 0.5, -.5);
		}
		public function radar()
		{
			oldRadar = newRadar;
			newRadar+=18;
			if(newRadar ==360)
			{
				newRadar =0;
			}
			for(var i:int = targets.length-1; i>=0; i--)
			{
				if(targets[i].angleFS > oldRadar && targets[i].angleFS <= newRadar)
				{
					//trace("ping!");
					soundEngine.playSoundPositionalUpdate(Sounds.ping, 1, targets[i].getPan);
				}
			}
		}
	}
}
