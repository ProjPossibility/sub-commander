package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Submarine extends MovieClip
	{

		public var main:Main;
		public var vX:Number;
		public var vY:Number;

		public var spinSpeed:Number;
		public var maxSpinSpeed:Number;
		public var speed:Number;
		public var maxSpeed:Number;
		public var acceleration:Number;
		public var engineVol:Number =0.02;

		public var downRight:Boolean;
		public var downLeft:Boolean;
		public var downUp:Boolean;
		public var downSpace:Boolean;

		public var oldX:Number;

		public var fireTimer:Timer;
		public var explodeTimer:Timer;
		private var canFire:Boolean = true;
	
		private var count:int = 0;

		public function Submarine(main:Main)
		{
			this.main = main;
		}

		public function init():void
		{
			vX = 0;
			vY = 0;

			speed = 0;
			maxSpeed = 2;
			acceleration = 1;

			oldX = 0;
			spinSpeed = 0;
			maxSpinSpeed = 4;

			fireTimer = new Timer(400,1);
			explodeTimer = new Timer(150,1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler, false, 0, true);
			explodeTimer.addEventListener(TimerEvent.TIMER, explodeTimerHandler, false, 0, true);

			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyReleased );
			SoundEngine.getInstance().playSoundPositionalUpdate(Sounds.engine, getEngineVol, getZero, 0, int.MAX_VALUE);

			//stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoved );


			//SoundEngine.getInstance().playSoundPositional(Sounds.ping,1,0,0,999999);
		}

		public function update():void
		{
			doRotation();
			doAcceleration();
			checkTargets();
			count++;
		}
		
		public function getEngineVol(): Number
		{
			return engineVol;
		}
		
		public function getZero() : Number //because I can
		{
			return 0;
		}

		public function checkTargets():void
		{
			//loop through targets
			var myRotation:Number = rotation;
			if (myRotation < 0)
			{
				myRotation *=  -1;
			}
			else
			{
				myRotation = 360 - myRotation;
			}
			for (var i:int = main.targets.length - 1; i >= 0; i--)
			{
				var target:Target = main.targets[i];
				var tempAngle:Number = myRotation - target.angleFS;
				if (tempAngle < 0)
				{
					tempAngle *=  -1;
				}
				else
				{
					tempAngle = 360 - tempAngle;
				}
				target.hearingAngleFS = 360 - tempAngle;
				// hearing angle is the angle for "hearing" 0 - 360
				// 0   - 90  = mostly right ear
				// 90  - 180 = all right ear
				// 180 - 270 = all left ear
				// 270 - 360 = mostly left ear
			}
		}

		public function doRotation():void
		{
			if (downRight && ! downLeft)
			{
				spinSpeed = maxSpinSpeed;
			}
			else if (downLeft && !downRight)
			{
				spinSpeed =  -  maxSpinSpeed;
			}
			else
			{
				if (spinSpeed != 0)
				{
					spinSpeed -=  Math.abs(spinSpeed) / spinSpeed / 2;
				}
				else if (Math.abs(spinSpeed) < 1)
				{
					spinSpeed = 0;
				}
			}
			rotation +=  spinSpeed;
		}

		public function doAcceleration():void
		{
			if (downUp)
			{
				speed +=  acceleration;
				if (speed > maxSpeed)
				{
					speed = maxSpeed;
				}
				engineVol+=0.005;
				if(engineVol > 0.08)
				{
					engineVol = 0.08;
				}
			}
			else
			{
				speed -=  acceleration / 3;
				if (speed < 0)
				{
					speed = 0;
				}
				engineVol-=0.005;
				if(engineVol < 0.02)
				{
					engineVol = 0.02;
				}
			}
			vX = Math.cos(rotation * Math.PI / 180) * speed;
			vY = Math.sin(rotation * Math.PI / 180) * speed;
			x +=  vX;
			y +=  vY;
		}

		public function keyPressed( e:KeyboardEvent ):void
		{
			if (e.keyCode == 39)
			{
				downRight = true;
			}
			else if (e.keyCode == 37)
			{
				downLeft = true;
			}
			else if (e.keyCode == 38)
			{
				downUp = true;
			}
			else if (e.keyCode == 32)
			{
				fire();
			}
		}

		public function keyReleased( e:KeyboardEvent ):void
		{
			if (e.keyCode == 39)
			{
				downRight = false;
			}
			else if (e.keyCode == 37)
			{
				downLeft = false;
			}
			else if (e.keyCode == 38)
			{
				downUp = false;
			}
			else if (e.keyCode == 32)
			{
				downSpace = false;
			}
		}

		public function mouseMoved(e:MouseEvent):void
		{
			/*
			Movement with mouse
			Problem: Can go off screen
			
			var deltaX:Number = stage.mouseX - oldX;
			rotation += deltaX;
			oldX = stage.mouseX;
			*/
		}

		public function fire()
		{
			if (canFire)
			{
				main.soundEngine.playSoundPositional(Sounds.torpedoLaunch, 0.1, 0);
				explodeTimer.start();
				canFire = false;
				fireTimer.start();
			}
		}

		public function fireTimerHandler(e:TimerEvent):void
		{
			canFire = true;
		}
		public function explodeTimerHandler(e:TimerEvent):void
		{
			for (var i:int = main.targets.length-1; i>=0; i--)
			{
				//trace(main.targets[i].getPan());
				if (main.targets[i].getPan() > -0.15 && main.targets[i].getPan() < 0.15)
				{
					main.soundEngine.playSoundPositional(Sounds.explosion, main.targets[i].getVolume(), main.targets[i].getPan());
					if (main.contains(main.targets[i]))
					{
						main.removeChild(main.targets[i]);
					}
					main.targets.splice(i,1);
				}
			}
			explodeTimer.stop();
		}
	}

}