package {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Waves extends MovieClip
	{
		public var stageRef:Stage;
		public var speed:int = 4;
		public var newScreen:Boolean;
		public var startX: Number;

		public function Waves(startX: Number)
		{
			this.startX = startX;
			this.x = startX;
			this.y = 200;
			newScreen = false;
			this.stageRef = stageRef;
			

			addEventListener(Event.ENTER_FRAME, loop);
		}
 
		private function loop(e:Event) : void
		{
			this.x += speed;
			if(this.x >=this.width)
			{
				this.x-=this.width*2;
				this.x+=10;
				this.y-=10;
			}
		}
	}
}
