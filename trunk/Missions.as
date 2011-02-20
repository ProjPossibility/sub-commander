package  {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Missions {
		
		public var missions:Array;
		
		public static var tutorial:int = 0;
		public static var descent:int = 1;
		public static var position:int = 2;
		public static var mine:int = 3;
		public static var twoMines:int = 4;
		public static var enemySub:int = 5;
		
		public var currentMission:int;
		public var currentIndex:int;
		
		//Timer for when game ends
		public var gameTimer:Timer;
		
		public var main:Main;
		
		public function Missions(main:Main) {
			this.main = main;
			
			missions = new Array();
			missions =
			[
			 	tutorial,
				descent,
				position,
				mine,
				twoMines, 
				enemySub
			];
		}
		
		public function init():void {
			currentIndex = 0;
			//4 minute timer
			gameTimer = new Timer(240000, 0);
			gameTimer.addEventListener(TimerEvent.TIMER, gameOver, false, 0, true);
		}
		
		public function startGame():void {
			gameTimer.start();
		}
		
		public function advance():void {
			currentMission = missions[currentIndex];
			//trace("Position: " + position);
			//trace("Current Mission: " + currentMission);
			switch(currentMission) {
				//0 is case for tutorial
				case 0:
					tutorial();
					break;
				//1 is case for descent
				case 1:
					descent();
					break;
				//2 is case for Position
				case 2:
					//trace("plaing");
					//trace("second");
					// spawn a new position target
					spawnPosition(200, 200);
					break;
				//3 is case for mine
				case 3:
					mine();
					break;
				//4 is case for twoMines
				case 4:
					twoMines();
					break;
				//5 is for enemySub
				case 5:
					enemySub();
					break;
				default:
					trace("default");
					win();
					break;
			}
			
			currentIndex++;
		}
		
		public function tutorial():void {
			
		}
		
		public function descent():void {
			beginDescent();
		}
		
		public function mine():void {
			spawnMine(200, 200);
			main.soundEngine.playSoundPositional(Sounds.voiceMineFieldWithinRange, 1, SoundEngine.patrickPan, 0, 0, commenceMineFieldDestruction, 1000);
		}
		
		public function twoMines():void {
			spawnMine(200, 300);
			spawnMine(300, 400);
		}
		
		public function enemySub():void {
			spawnEnemy(500, 600);
		}
		
		public function win():void {
			
		}
		
		public function gameOver():void {
			
		}
		
		public function spawnPosition(minDist:Number, maxDist:Number):void {
			//How far away you want the targets to spawn
			//var dist:Number = main.stage.stageHeight/2 ;
			var position:Position = new Position(main);
			
			var x:Number;
			var y:Number;
			var angle:Number;
			angle = Math.random() * 2 * Math.PI;
			//trace("angle: " + angle);
			x = (Math.cos(angle) * randNumber(minDist, maxDist) ) + main.submarine.x;
			y = (Math.sin(angle) * randNumber(minDist, maxDist) ) + main.submarine.y;
			position.x = x;
			position.y = y;
			
			main.targets.push( position );
			main.addChild( position );
		}
		
		public function spawnMine(minDist:Number, maxDist:Number):void {
			//How far away you want the targets to spawn
			//var dist:Number = main.stage.stageHeight/2 ;
			var mine:Mine = new Mine(main);
			
			var x:Number;
			var y:Number;
			var angle:Number;
			angle = Math.random() * 2 * Math.PI;
			//trace("angle: " + angle);
			x = (Math.cos(angle) * randNumber(minDist, maxDist) ) + main.submarine.x;
			y = (Math.sin(angle) * randNumber(minDist, maxDist) ) + main.submarine.y;
			mine.x = x;
			mine.y = y;
			
			main.targets.push( mine );
			main.addChild( mine );
		}
		
		public function spawnEnemy(minDist:Number, maxDist:Number):void {
			//var dist:Number = main.stage.stageHeight/2 ;
			var enemy = new Enemy(main, 50, 100);
			
			var x:Number;
			var y:Number;
			var angle:Number;
			angle = Math.random() * 2 * Math.PI;
			//trace("angle: " + angle);
			x = (Math.cos(angle) * randNumber(minDist, maxDist) ) + main.submarine.x;
			y = (Math.sin(angle) * randNumber(minDist, maxDist) ) + main.submarine.y;
			enemy.x = x;
			enemy.y = y;
			
			main.targets.push( enemy );
			main.addChild( enemy );
		}
		
		public function randNumber(low:Number, high:Number):Number {
			var num:Number;
			
			num = (Math.random() * (high-low)) + low;
			
			return num;
		}
		
		public function beginDescent():void{
			main.soundEngine.stopWaveSound();//dive, diveDepths, diveDepthReached
			//soundEngine.playSoundVoice(Sounds.voiceCommenceDescent, diveSoundEnd);
			main.soundEngine.playSoundPositional(Sounds.voiceCommenceDescent, 1, SoundEngine.anoopPan, 0, 0, diveSoundEnd, 2000);
		}
		
		public function diveSoundEnd():void{
			//soundEngine.playSoundVoice(Sounds.voiceDepthMeters, diveDepthReached);
			main.soundEngine.playSoundPositional(Sounds.voiceDepthMeters, 1, SoundEngine.anoopPan, 0, 0, diveDepthReached, 1000);
		}
		
		public function diveDepthReached():void{
			//soundEngine.playSoundVoice(Sounds.voiceOptimalDepthReached, beginMission);
			main.soundEngine.playSoundPositional(Sounds.voiceOptimalDepthReached, 1, SoundEngine.anoopPan, 0, 0, main.beginMission);
		}
		
		public function commenceMineFieldDestruction():void {
			main.soundEngine.playSoundPositional(Sounds.voiceCommenceDestructionOfMineField, 1, SoundEngine.patrickPan, 0, 0, null, 0);
		}
		
	}
	
}
