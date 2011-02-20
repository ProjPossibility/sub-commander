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
		public var bubbleTimer:int = 0;
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
				if(counter >500)
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
				bubbleRate = 6;
			} else {
				bubbleRate = 4;
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
				bubble.y = 400+Math.random()*30;
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
			main.soundEngine.playSoundPositional(Sounds.voicetutorial1, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.pingPosition, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorial2, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorial3, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.pingMine, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorial4, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.pingEnemy, 1, 0);
			main.soundEngine.playSoundPositional(Sounds.voicetutorial5, 1, 0);
		}
	}
}
