package 
{

	import flash.display.MovieClip;

	public class Enemy extends Target
	{

		public var counter:int = 0;
		public var ySpeed:int = 2;
		public var xSpeed:int = 2;
		public var speed:int = 2;
		public var dirNum:int = 0;
		
		public var yPos:int;
		public var xPos:int;
		

		public function Enemy(main:Main, xPos:int, yPos:int)
		{
			this.main = main;
			x = xPos;
			x = yPos;
			this.xPos = xPos;
			this.yPos = yPos;
			mySound = Sounds.pingEnemy;
			objectName = "Enemy";
		}

		public override function update():void
		{
			super.update();
			if (counter % 15 == 0)
			{
				var randomAction = Math.floor(Math.random() * 3); //helpds decide on a new random direction
				switch (randomAction)
				{
					case 0 :
						dirNum++;
						break;
					case 1 :
						dirNum--;
						break;
					default :
						break;
				}
				if (dirNum > 7) //ensures that the movement is smooth, ie no sudden changes in directions
				{
					dirNum = 0;
				}
				if (dirNum == 0)
				{
					gotoAndStop("downRight");
					xSpeed = speed;
					ySpeed = speed;
				}
				else if (dirNum == 1)
				{
					gotoAndStop("down");
					xSpeed = 0;
					ySpeed = speed;
				}
				else if (dirNum  == 2)
				{
					gotoAndStop("downLeft");
					xSpeed =  -  speed;
					ySpeed = speed;
				}
				else if (dirNum  == 3)
				{
					gotoAndStop("left");
					xSpeed =  -  speed;
					ySpeed = 0;
				}
				else if (dirNum  == 4)
				{
					gotoAndStop("upLeft");
					xSpeed =  -  speed;
					ySpeed =  -  speed;
				}
				else if (dirNum  == 5)
				{
					gotoAndStop("up");
					xSpeed = 0;
					ySpeed =  -  speed;
				}
				else if (dirNum  == 6)
				{
					gotoAndStop("upRight");
					xSpeed = speed;
					ySpeed =  -  speed;
				}
				else if (dirNum  == 7)
				{
					gotoAndStop("right");
					xSpeed = speed;
					ySpeed = 0;
				}

				//make sure the enemy subs only travels within a constricted predetermined area
				if ((this.x + xSpeed) <= (xPos-100))
				{
					xSpeed = speed;
				}
				else if ((this.x + xSpeed) >= (xPos+100))
				{
					xSpeed =  - speed;
				}

				if ((this.y + ySpeed) <= (yPos-100))
				{
					ySpeed = speed;
				}
				else if ((this.y + ySpeed) >= (yPos+100))
				{
					ySpeed =  -  speed;
				}
			}
			this.x +=  xSpeed;
			this.y +=  ySpeed;
			counter++;
		}
	}
}