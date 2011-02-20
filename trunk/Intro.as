package{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Intro extends MovieClip {
		public var waves1:Waves;
		public var waves2:Waves;
		public var subWindow:SubWindow;
		
		public function Intro() {
			waves1 = new Waves(0);
			waves2 = new Waves(-waves1.width);
			subWindow = new SubWindow();

			this.addChild(waves1);
			this.addChild(waves2);
			this.addChild(subWindow);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		public function update(e:Event):void {
		}
	}
}