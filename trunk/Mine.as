package  {
	
	import flash.display.MovieClip;
	
	public class Mine extends Target {
		
		public function Mine(main:Main) {
			this.main = main;
			mySound = Sounds.pingMine;
		}
	}
	
}
