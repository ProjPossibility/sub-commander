package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	
	public class Overlay extends MovieClip {

		public var backGround:Sprite;
		public var waves1:Waves;
		public var waves2:Waves;
		public var subWindow:SubWindow;
		
		public static var READYTOPLAY:int = 5;
		public static var SUBMERGE:int = 0;
		public static var IDLE:int = 1;
		public static var GAME:int = 2;
		public static var SURFACE:int = 3;
		public static var BUBBLES:int = 4;
		
		public var myState:int;
		
		public var timer:int;
		
		public var readyToSurface:Boolean = false;
		
		public function Overlay() {
			backGround = new Sprite();
			
			backGround.graphics.beginFill(0x3E4DFF);
			backGround.graphics.drawRect(0,0,550,400);
			backGround.graphics.endFill();
			
			this.addChild(backGround);
			
			waves1 = new Waves(0);
			waves2 = new Waves(-waves1.width);
			subWindow = new SubWindow();

			this.addChild(waves1);
			this.addChild(waves2);
			this.addChild(subWindow);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			myState = READYTOPLAY;
			
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
				trace("start game");
				surface();			
			}
			if(myState == SURFACE && waves1.deepBlue.currentFrameLabel == "endSurface" ) {
				timer = 150;
				readyToSurface = true;
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
					submerge();
				}
			}
		}
	}
	
}
