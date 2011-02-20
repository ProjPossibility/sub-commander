﻿package {
	
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
		
		public var gameStart:Boolean = false;
		
		public var overlay:Overlay;
		
		public var gameLayer:MovieClip = new MovieClip();
		
		public function Main() {
			addChild(gameLayer);
			soundEngine = SoundEngine.getInstance();
			soundEngine.loadAll(soundsLoaded);
			StageClass.setStage(stage);
			init();
			missions = new Missions(this);
			missions.init();
		}
		
		public function init():void
		{
			submarine = new Submarine(this);
			gameLayer.addChild(submarine);
			targets = new Vector.<Target>();
			/*
			enemy = new Enemy(this, 50, 100);
			var mine:Mine = new Mine(this);
			
			targets.push(mine);
			targets.push(enemy);
			
			this.addChild(mine);
			this.addChild(enemy);
			
			mine.x = Math.random()*stage.stageWidth;
			mine.y = Math.random()*stage.stageHeight;
			*/
			submarine.init();
			submarine.x = stage.stageWidth/2;
			submarine.y = stage.stageHeight/2;
			
			
			//missions.currentIndex = 2;
			//missions.advance();
			
			radarTimer = new Timer(100,int.MAX_VALUE);
			radarTimer.addEventListener(TimerEvent.TIMER, radarTimerHandler, false, 0, true);
			oldRadar = 0;
			newRadar = 0;
			radarTimer.start();
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			// overlay
			overlay = new Overlay(this);
			this.addChild(overlay);
			overlay.init();
			//uncomment to use debug
			//overlay.visible = false;
		}
		
		public function remove() :void
		{
			for(var i:int = targets.length-1; i>=0; i--) {
				this.removeChild(targets[i]);
				targets.splice(i,1);
			}
			radarTimer.stop();
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		public function update(e:Event):void {
			//trace("sup");
			soundEngine.update();
			//soundEngine.playSound(Sounds.ping);
			missions.update();
			//if the game has started, update all game objects
			if(gameStart) {
				submarine.update();
				for(var i:int = targets.length-1; i>=0; i--) {
					targets[i].update();
				}
				radarTimer.start();
			}
		}
		public function beginGame():void {
			this.gameStart = true;
			//missions.advance();
			missions.startGame();
		}
		public function soundsLoaded():void{
			trace("sounds loaded, allow game to start!");
			//soundEngine.playSoundPositional(Sounds.ping, 0.5, -.5);
			//beginDescent();
			//oClockTest()
		}
		
		public function oClockTest():void{
			soundEngine.playSoundOClockPosition((targets[0] as Target).hearingAngleFS, (targets[0] as Target).getPan(), oClockTest);
		}
		
		public function beginDescent():void{
			soundEngine.stopWaveSound();//dive, diveDepths, diveDepthReached
			//soundEngine.playSoundVoice(Sounds.voiceCommenceDescent, diveSoundEnd);
			soundEngine.playSoundPositional(Sounds.voiceCommenceDescent, 1, SoundEngine.anoopPan, 0, 0, diveSoundEnd, 2000);
		}
		
		public function diveSoundEnd():void{
			//soundEngine.playSoundVoice(Sounds.voiceDepthMeters, diveDepthReached);
			soundEngine.playSoundPositional(Sounds.voiceDepthMeters, 1, SoundEngine.anoopPan, 0, 0, diveDepthReached, 1000);
		}
		
		public function diveDepthReached():void{
			//soundEngine.playSoundVoice(Sounds.voiceOptimalDepthReached, beginMission);
			soundEngine.playSoundPositional(Sounds.voiceOptimalDepthReached, 1, SoundEngine.anoopPan, 0, 0, beginMission);
		}
		
		public function beginMission():void{
			
		}
		
		public function radarTimerHandler(e:TimerEvent):void
		{
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
	}
}
