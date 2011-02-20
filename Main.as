package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Main extends MovieClip {
		public var soundEngine:SoundEngine;
		public var submarine:Submarine;
		public var enemy:Enemy;	
		
		public var targets:Vector.<Target>;
		public var missions:Missions;
		
		public var radarTimer:Timer;
		public var oldRadar:Number;
		public var newRadar:Number;
		
		public function Main() {
			soundEngine = SoundEngine.getInstance();
			soundEngine.loadAll(soundsLoaded);
			StageClass.setStage(stage);
			
			submarine = new Submarine(this);
			enemy = new Enemy(this, 50, 100);
			
			targets = new Vector.<Target>();
			var mine:Mine = new Mine(this);
			targets.push(mine);
			targets.push(enemy);
			
			this.addChild(submarine);
			this.addChild(mine);
			this.addChild(enemy);
			
			mine.x = Math.random()*stage.stageWidth;
			mine.y = Math.random()*stage.stageHeight;
			
			submarine.init();
			submarine.x = stage.stageWidth/2;
			submarine.y = stage.stageHeight/2;
			
			missions = new Missions(this);
			missions.init();
			//missions.advance();
			
			radarTimer = new Timer(80,1);
			radarTimer.addEventListener(TimerEvent.TIMER, radarTimerHandler, false, 0, true);
			oldRadar = 0;
			newRadar = 0;
			radarTimer.start();
			
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
			radarTimer.start();
		}
		
		public function soundsLoaded():void{
			trace("sounds loaded, allow game to start!");
			//soundEngine.playSoundPositional(Sounds.ping, 0.5, -.5);
		}
		public function radarTimerHandler(e:TimerEvent):void
		{
			trace(oldRadar);
			oldRadar = newRadar;
			newRadar+=18;
			if(newRadar ==378)
			{
				oldRadar = 0;
				newRadar =18;
			}
			for(var i:int = targets.length-1; i>=0; i--)
			{
				if(targets[i].angleFS > oldRadar && targets[i].angleFS <= newRadar)
				{
					//trace("ping!");
					soundEngine.playSoundPositional(targets[i].getSound(), targets[i].getVolume(), targets[i].getPan());
				}
			}
		}
		
		public function checkCollisions():void {
			for (var i:int = targets.length-1; i >= 0; i--) {
				
			}
		}
	}
}
