package  {
	
	public class Missions {
		
		public var missions:Array;
		
		public static var position:int = 0;
		public static var mine_with_instruction:int = 1;
		public static var mine:int = 2;
		
		public var currentMission:int;
		public var currentIndex:int;
		
		public var main:Main;
		
		public function Missions(main:Main) {
			this.main = main;
			
			missions = new Array();
			missions =
			[
			 "position",
			 "mine_with_instruction",
			 "mine"
			];
		}
		
		public function init():void {
			currentIndex = 0;
		}
		
		public function advance():void {
			currentMission = missions[currentIndex];
			
			switch(currentMission) {
				case position:
					// spawn a new position target
					var position:Position = new Position(main);
					main.targets.push( position );
					main.addChild( position );
					break;
			}
			
			currentIndex++;
		}
		
		

	}
	
}
