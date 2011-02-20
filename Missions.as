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
				position,
				mine_with_instruction,
				mine
			];
		}
		
		public function init():void {
			currentIndex = 0;
		}
		
		public function advance():void {
			currentMission = missions[currentIndex];
			trace("Position: " + position);
			trace("Current Mission: " + currentMission);
			switch(currentMission) {
				//0 is case for Position
				case 0:
					//trace("plaing");
					//trace("second");
					// spawn a new position target
					spawnPosition();
					break;
				//1 is case for mine_instruction
				case 1:
					spawnMine();
					break;
				//2 is case for mine
				case 2:
					var mine:Mine = new Mine(main);
					main.targets.push( mine );
					main.addChild( mine );
					break;
				default:
					trace("default");
			}
			
			currentIndex++;
		}
		
		public function spawnPosition():void {
			//How far away you want the targets to spawn
			var dist:Number = main.stage.stageHeight/2 ;
			var position:Position = new Position(main);
			
			var x:Number;
			var y:Number;
			var angle:Number;
			angle = Math.random() * 2 * Math.PI;
			//trace("angle: " + angle);
			x = (Math.cos(angle) * dist) + main.submarine.x;
			y = (Math.sin(angle) * dist) + main.submarine.y;
			position.x = x;
			position.y = y;
			
			main.targets.push( position );
			main.addChild( position );
		}
		
		public function spawnMine():void {
			//How far away you want the targets to spawn
			var dist:Number = main.stage.stageHeight/2 ;
			var mine:Mine = new Mine(main);
			
			var x:Number;
			var y:Number;
			var angle:Number;
			angle = Math.random() * 2 * Math.PI;
			//trace("angle: " + angle);
			x = (Math.cos(angle) * dist) + main.submarine.x;
			y = (Math.sin(angle) * dist) + main.submarine.y;
			mine.x = x;
			mine.y = y;
			
			main.targets.push( mine );
			main.addChild( mine );
		}

	}
	
}
