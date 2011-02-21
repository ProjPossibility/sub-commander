package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Overlay extends MovieClip {

		public var backGround:Sprite;
		public var waves1:Waves;
		public var waves2:Waves;
		public var subWindow:SubWindow;
		
		public var bubblePool:Vector.<Bubble>;
		public var bubbleLayer:MovieClip;
		public var bubbleTimer:int = 20;
		public var bubbleRate:int = 3;
		
		public static var READYTOPLAY:int = 5;
		public static var SUBMERGE:int = 0;
		public static var IDLE:int = 1;
		public static var GAME:int = 2;
		public static var SURFACE:int = 3;
		public static var BUBBLES:int = 4;
		
		public var myState:int;
		
		public var timer:int;
		
		public var readyToSurface:Boolean = false;
		
		public var main:Main;
		
		public var menuTimer:Timer;
		public var counter:int = 0;
		public var playingTutorial:Boolean = false;
		
		public function Overlay(main:Main) {
			this.main = main;
			backGround = new Sprite();
			
			backGround.graphics.beginFill(0x3E4DFF);
			backGround.graphics.drawRect(0,0,550,400);
			backGround.graphics.endFill();
			
			this.addChild(backGround);
			
			waves1 = new Waves(0);
			waves2 = new Waves(-waves1.width);
			subWindow = new SubWindow();

			bubblePool = new Vector.<Bubble>();
			bubbleLayer = new MovieClip();

			this.addChild(waves1);
			this.addChild(waves2);
			this.addChild(bubbleLayer);
			this.addChild(subWindow);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			main.soundEngine.playSound(Sounds.voiceIntro);
			
			menuTimer = new Timer(500,1);
			menuTimer.addEventListener(TimerEvent.TIMER, menuTimerHandler, false, 0, true);
			menuTimer.start();
			
			
			timer = 0;
			
		}
		
		public function init():void {
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
		}
		
		public function submerge():void {
			myState = SUBMERGE;
			timer = 150;
			beginDescentSounds();
		}
		
		public function beginDescentSounds():void{
			SoundEngine.getInstance().stopWaveSound();//dive, diveDepths, diveDepthReached
			//soundEngine.playSoundVoice(Sounds.voiceCommenceDescent, diveSoundEnd);
			//SoundEngine.getInstance().playSoundPositional(Sounds.voiceCommenceDescent, 1, SoundEngine.anoopPan, 0, 0, diveSoundEnd, 2000);
			//SoundEngine.getInstance().playSoundPositional(Sounds.voiceCommenceDescent, 1, SoundEngine.anoopPan, 0, 0, diveSoundEnd, 2000);
			SoundEngine.getInstance().playVoiceAggressive(Sounds.voiceCommenceDescent, 1, SoundEngine.anoopPan, 0, 0, diveSoundEnd, 2000);
		}
		
		public function diveSoundEnd():void{
			//soundEngine.playSoundVoice(Sounds.voiceDepthMeters, diveDepthReached);
			SoundEngine.getInstance().playSoundPositional(Sounds.voiceDepthMeters, 1, SoundEngine.anoopPan, 0, 0, diveDepthReached, 1000);
		}
		
		public function diveDepthReached():void{
			//soundEngine.playSoundVoice(Sounds.voiceOptimalDepthReached, beginMission);
			SoundEngine.getInstance().playSoundPositional(Sounds.voiceOptimalDepthReached, 1, SoundEngine.anoopPan, 0, 0, beginMission);
		}
		public function beginMission():void{
			SoundEngine.getInstance().playSoundPositional(Sounds.voiceInitialBriefing, 1, SoundEngine.patrickPan, 0, 0);
		}
		public function surface():void {
			waves1.deepBlue.gotoAndPlay("surface");
			waves2.deepBlue.gotoAndPlay("surface");
			waves1.play();
			waves2.play();
			myState = SURFACE;
			readyToSurface = false;
		}
		
		public function update(e:Event):void {
			if(playingTutorial)
			{
				counter++;
				if(counter >5000)
				{
					playingTutorial = false;
					submerge();
				}
			}
			if(myState == SUBMERGE && timer > 0) {
				timer--;
				waves1.y -= 3;
				waves2.y -= 3;
				
				if(timer==0) {
					myState = BUBBLES;
					waves1.stop();
					waves2.stop();
					waves1.deepBlue.gotoAndPlay("submerge");
					waves2.deepBlue.gotoAndPlay("submerge");
				}
			} else if(myState == SURFACE && timer > 0) {
				timer--;
				waves1.y += 3;
				waves2.y += 3;
				
				if(timer==0) {
					myState = READYTOPLAY;
				}
			}
			
			if(myState == BUBBLES && waves1.deepBlue.currentFrameLabel == "endSubmerge" ) {
				myState = GAME;
				main.beginGame();
			}
			if(myState == SURFACE && waves1.deepBlue.currentFrameLabel == "endSurface" ) {
				timer = 150;
				readyToSurface = true;
			}
			
			handleBubbles();
		}
		
		public function handleBubbles():void {
			if( myState == Overlay.BUBBLES || myState == Overlay.GAME || myState == Overlay.SUBMERGE ) {
				bubbleTimer--;
			}
			if( myState == Overlay.GAME ) {
				bubbleRate = 4;
			} else {
				bubbleRate = 3;
			}
			if(bubbleTimer < 0) {
				bubbleTimer = this.bubbleRate;
				if(bubblePool.length == 0) {
					bubblePool.push( new Bubble() );
				}
				var bubble:Bubble = bubblePool.pop();
				if( myState == Overlay.GAME ) {
					bubble.x = Math.random()*700 - 75;
				} else {
					bubble.x = Math.random()*550;
				}
				bubble.y = 350+Math.random()*30;
				bubble.scaleX = bubble.scaleY = Math.random()*.5 + .5;
				bubbleLayer.addChild(bubble);
			}
			for( var t:int = bubbleLayer.numChildren-1; t > 0; t-- ) {
				var bubs:Bubble = bubbleLayer.getChildAt(t) as Bubble;
				if(myState == Overlay.GAME) {
					bubs.y -= 3;
				} else {	
					bubs.y -= 8;
				}
				bubs.x -= main.submarine.spinSpeed * 2;
				//
				if(bubs.x > 550/2) {
					//push right
					bubs.x += main.submarine.speed;
				} else {
					bubs.x -= main.submarine.speed;
				}
				if(bubs.y < 0) {
					bubblePool.push(bubs);
					bubbleLayer.removeChild(bubs);
				}
			}
		}
		
		public function fillBubbles():void {
			for(var p:int = 0; p < 100; p++) {
				var bubble:Bubble = new Bubble();
				bubblePool.push(bubble);
			}
		}
		public function keyPressed( e:KeyboardEvent ):void
		{
			if(myState == READYTOPLAY) {
				if (e.keyCode == 39)
				{
					submerge();
				}
				else if (e.keyCode == 37)
				{
					tutorial();
				}
			}
		}
		public function menuTimerHandler(e:TimerEvent):void
		{
			myState = READYTOPLAY;
		}
		public function tutorial() :void
		{
			playingTutorial = true;
			main.soundEngine.playSoundPositional(Sounds.voicetutorial1, 1, 0, 0, 0, tutorialPingPosition);
		}
		//all these functions were used to ensure proper timing of dialogue and the radar pings
		public function tutorialPingPosition():void{
			SoundEngine.getInstance().playSoundPositional(Sounds.pingPosition, 1, 0, 0, 0, tutorial2);
		}
		
		public function tutorial2():void{
			main.soundEngine.playSoundPositional(Sounds.voicetutorial2, 1, 0);
			SoundEngine.getInstance().playSoundPositional(Sounds.voicetutorial3, 1, 0, 0, 0, tutorialPingMine);
		}
		
		public function tutorialPingMine():void{
			SoundEngine.getInstance().playSoundPositional(Sounds.pingMine, 1, 0, 0, 0, tutorial4);
		}
		
		public function tutorial4():void{
			SoundEngine.getInstance().playSoundPositional(Sounds.voicetutorial4, 1, 0, 0, 0, tutorialPingEnemy);
		}
		public function tutorialPingEnemy():void{
			SoundEngine.getInstance().playSoundPositional(Sounds.pingEnemy, 1, 0, 0, 0, tutorial5);
		}
		public function tutorial5():void{
			SoundEngine.getInstance().playSoundPositional(Sounds.voicetutorial5, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorialLeft, 1, -1);
			main.soundEngine.playSoundPositional(Sounds.voicetutorialRight, 1, 1);
			main.soundEngine.playSoundPositional(Sounds.voicetutorialFront, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorialBehind, 0.8, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorialClose, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorialFinal, 1, 0);
		}
	}
}