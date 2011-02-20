package  {
	
import flash.display.MovieClip;
	
	public class Enemy extends Target {
		
		public function Enemy(main:Main) {
			this.main = main;
			mySound = Sounds.pingMine;
		}
	}
	
}