package  {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class Missions {
		
		public var missions:Array;
		
		public static var tutorial:int = 0;
		//public static var descent:int = 1;
		public static var position:int = 1;
		public static var mine:int = 2;
		public static var twoMines:int = 3;
		public static var enemySub:int = 4;
		
		public var currentMission:int;
		public var currentIndex:int;
		
		public var gameIsOver:Boolean = false;
		
		public var canAdvance:Boolean = true;
		
		//Timer for when game ends
		public var gameTimer:Timer;
		
		public var main:Main;
		
		public function Missions(main:Main) {
			this.main = main;
			
			missions = new Array();
			missions =
			[
			 	tutorial,
				//descent,
				position,
				mine,
				twoMines, 
				enemySub
			];
		}
		
		public function init():void {
			currentIndex = 0;
			gameIsOver = false;
			//4 minute timer
			gameTimer = new Timer(60000*4, 0);
			gameTimer.addEventListener(TimerEvent.TIMER, gameOver);
		}
		
		public function startGame():void {
			currentIndex = 1;
			gameTimer.start();
		}
		
		public function playTutorial():void {
			
		}
		
		public function advance():void {
			if(!gameIsOver) {
				currentMission = missions[currentIndex];
				//trace("Position: " + position);
				trace("Current Mission: " + currentMission);
				trace("Current index: " + currentIndex);
				switch(currentIndex) {
					//0 is case for tutorial
					case 0:
						tutorial();
						//advance();
						break;
					//1 is case for descent
					/*
					case 1:
						descent();
						break;
					*/
					//2 is case for Position
					case 1:
						//trace("plaing");
						//trace("second");
						// spawn a new position target
						trace("Advance position");
						spawnPosition(200, 200);
						break;
					//3 is case for mine
					case 2:
						mine();
						trace("Advance mine");
						break;
					//4 is case for twoMines
					case 3:
						twoMines();
						trace("Advance mine2");
						break;
					//5 is for enemySub
					case 4:
						trace("Advance enemySub");
						enemySub();
						break;
					default:
						trace("default");
						win();
						break;
				}
				currentIndex++;
				trace("Index increased now is: " + currentIndex);
			}
		}
		
		public function update():void {
			if (currentIndex >= position) {
				if (main.targets.length == 0) {
					advance();
					trace("Target length = 0, advancing");
				}
			}
		}
		
		public function tutorial():void {
			
		}
		
		public function descent():void {
			beginDescent();
		}
		
		public function mine():void {
			spawnMine(200, 200);
			trace("Spawn 1st mine");
			main.soundEngine.playSoundPositional(Sounds.voiceMineFieldWithinRange, 1, SoundEngine.patrickPan, 0, 0, commenceMineFieldDestruction, 1000);
			main.soundEngine.playSoundPositional(Sounds.voiceCommenceDestructionOfMineField, 3, SoundEngine.patrickPan, 0, 0);
		}
		
		public function twoMines():void {
			main.soundEngine.playSoundPositional(Sounds.voiceMoreMines, 1, SoundEngine.patrickPan, 0, 0);
			spawnMine(200, 300);
			spawnMine(300, 400);
		}
		
		public function enemySub():void {
			main.soundEngine.playSoundPositional(Sounds.voiceEnemySubSighted, 1, SoundEngine.patrickPan, 0, 0);
			spawnEnemy(500, 600);
		}
		
		public function win():void {
			trace("You win");
			done();
		}
		
		public function gameOver(e:TimerEvent):void {
			done();
			trace("Game over, player ran out of time");
		}
		
		public function done():void {
			currentIndex = 0;
			main.overlay.surface();
			gameIsOver = true;
			main.gameStart = false;
			gameTimer.stop();
			main.submarine.resetValues();
			//delete any remaining targets
			for(var u:int = main.targets.length - 1; u >= 0; u--) {
				main.gameLayer.removeChild(main.targets[u]);
				main.targets.splice(u,1);
			}
			
			main.missions.init();
			
			//main.remove();
			//main.init();
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
			main.gameLayer.addChild( position );
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
			trace(main.targets.length);
			main.gameLayer.addChild( mine );
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
			main.gameLayer.addChild( enemy );
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
			//main.soundEngine.playSoundPositionalUpdate(Sounds.
			main.soundEngine.playSoundPositional(Sounds.voiceDepthMeters, 1, SoundEngine.anoopPan, 0, 0, diveDepthReached, 1000);
			//main.soundEngine.playSoundPositionalUpdate(Sounds.dolphin, 1, 
		}
		
		public function diveDepthReached():void{
			//soundEngine.playSoundVoice(Sounds.voiceOptimalDepthReached, beginMission);
			main.soundEngine.playSoundPositional(Sounds.voiceOptimalDepthReached, 1, SoundEngine.anoopPan, 0, 0, main.beginMission);
		}
		
		public function commenceMineFieldDestruction():void {
			main.soundEngine.playSoundPositional(Sounds.voiceCommenceDestructionOfMineField, 1 , SoundEngine.patrickPan, 0, 0, null, 0);
		}
		
	}
	
}
