package  {
	import flash.events.Event; 
	import flash.media.Sound; 
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform; 
	import flash.media.SoundMixer; 
	import flash.net.URLRequest; 
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	// Singleton class:
	public class SoundEngine {
		private static var instance:SoundEngine;
		private static var allowInstantiation:Boolean = false;
		private var sounds:Array;
		private var bgmusicFileName:String;
		public var totalSoundsLoaded:int = 0;
		public var doneRequestingSounds:Boolean = false;
		public var doneLoadingSounds:Boolean = false;
		public var loadDoneCallback:Function;
		public var waveSound:MySound;
		
		public var anoopPan:Number = 0; //pan values for speakers
		public var patrickPan:Number = .7;
		public var alexPan:Number = -.7;
		
		public static function getInstance():SoundEngine {
			if (instance == null) {
				allowInstantiation = true;
				instance = new SoundEngine();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function SoundEngine():void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
			}
			sounds = new Array();
			//loadSounds();
		}
		
		public function loadAll(callback:Function){
			loadDoneCallback = callback;
			loadSounds();
		}
		
		private function loadSounds(){
			loadSound("Audio/Sound/Waves/waves01.mp3");//Sounds.Waves = 0
			bgmusicFileName = "waves01.mp3";
			loadSound("Audio/Sound/Sonar/Sonar01.mp3");//Sounds.PingPosition = 1
			loadSound("Audio/Sound/Sonar/Sonar02.mp3");//Sounds.pingMine = 2
			loadSound("Audio/Sound/Sonar/Sonar02.mp3");//Sounds.pingEnemy = 3
			loadSound("Audio/Sound/Underwater/Underwater04.mp3");//Sounds.Underwater = 4
			loadSound("Audio/Sound/Engine/dieselEngine01.mp3");//Sounds.engine = 5
			loadSound("Audio/Sound/Alarm/Klaxon01.mp3");//Sounds.klaxon = 6
			loadSound("Audio/Sound/Explosion/waterExplosion01.mp3");//Sounds.explosion = 7
			loadSound("Audio/Sound/Torpedo/torpedo03.mp3");//Sounds.torpedoLaunch = 8
			//Voice files
			loadSound("Audio/Voice/ClockPositions/1oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/2oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/3oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/4oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/5oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/6oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/7oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/8oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/9oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/10oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/11oClockPosition.mp3");//Sounds.voice1oClockPosition
			loadSound("Audio/Voice/ClockPositions/12oClockPosition.mp3");//Sounds.voice1oClockPosition
			
			loadSound("Audio/Voice/100MtoTarget.mp3");//Sounds.voice
			loadSound("Audio/Voice/anotherMine.mp3");//Sounds.voice
			loadSound("Audio/Voice/commenceDescent.mp3");//Sounds.voice
			loadSound("Audio/Voice/commenceDestructionOfMineField.mp3");//Sounds.voice
			loadSound("Audio/Voice/depthMeters.mp3");//Sounds.voice
			loadSound("Audio/Voice/enemySubSighted.mp3");//Sounds.voice
			loadSound("Audio/Voice/initialBriefing.mp3");//Sounds.voice
			loadSound("Audio/Voice/leftFullRudder.mp3");//Sounds.voice
			loadSound("Audio/Voice/maxSpeedReached.mp3");//Sounds.voice
			loadSound("Audio/Voice/minefieldWithinRange.mp3");//Sounds.voice
			loadSound("Audio/Voice/moreMines.mp3");//Sounds.voice
			loadSound("Audio/Voice/noRange.mp3");//Sounds.voice
			loadSound("Audio/Voice/optimalDepthReached.mp3");//Sounds.voice
			loadSound("Audio/Voice/rightFullRudder.mp3");//Sounds.voice
			loadSound("Audio/Voice/targetDirectlyAhead.mp3");//Sounds.voice
			loadSound("Audio/Voice/targetHit.mp3");//Sounds.voice
			loadSound("Audio/Voice/targetInRange.mp3");//Sounds.voice
			loadSound("Audio/Voice/targetMissed.mp3");//Sounds.voice
			loadSound("Audio/Voice/tubesReadytoFire.mp3");//Sounds.voice
			loadSound("Audio/Voice/weaponsArmed.mp3");//Sounds.voice
			loadSound("Audio/Voice/weaponsFired.mp3");//Sounds.voice
			doneRequestingSounds = true;
		}
		
		private function loadSound(fileLoc:String){
			var snd:Sound = new Sound();
			var req:URLRequest = new URLRequest(fileLoc); 
			snd.addEventListener(Event.COMPLETE, doLoadComplete);
			snd.load(req);
			var mySound:MySound = new MySound(snd);
			sounds.push(mySound);
			//trace("Mysound in loadSound: " + mySound);
		}
		
		public function update():void{
			//trace("soundsup");
		}
		 
		function doLoadComplete(evt:Event):void
		{
			var sndURL:String =(evt.target as Sound).url;
			//trace("sound.url: " + sndURL);
			var finalURL:String = sndURL.substr(sndURL.lastIndexOf("/") + 1, sndURL.length);//bgmusicFileName.length);
			if(finalURL  == bgmusicFileName){
				//playSound(Sounds.waves);
				waveSound = playSoundPositional(Sounds.waves, .3, 0, 500);//skipping a half second of delay at the start
			}
			//CAN'T UNLOAD ACTION LISTENER, POSSIBLY INEFFICIENT BUT ONLY ONCE FOR EACH SOUND
			totalSoundsLoaded++;
			if(doneRequestingSounds){
				if(totalSoundsLoaded == sounds.length){
					//we've requested all the sounds and loaded all of them
					doneLoadingSounds = true;
					//trace("done loading sounds");
					loadDoneCallback();
				}
			}
		}
		
		public function stopWaveSound(){
			if(waveSound){
				waveSound.stop();
			}
		}
		
		/*function onPlaybackComplete(event:Event):void 
		{ 
			//trace("playback complete");
		}*/
		
		//soundEnum is like Sounds.___, plays it globally and flat
		public function playSound(soundEnum:int, callback:Function = null):MySound{
			var newSound:MySound = sounds[soundEnum].clone();
			newSound.setChannel(new SoundChannel());
			newSound.setCallback(callback);
			newSound.sound.play();
			return newSound;
		}
		
		//soundEnum is like Sounds.___
		//volume 1 is full, 0 is muted
		//panning must be a Number between -1 (left) and 1 (right) for the pan value
		//startTime is the number of millis it skips at the start of the sound (if you want to start in the middle of the sound)
		//loops is the number of times it loops the sound (0 to play once)
		public function playSoundPositional(soundEnum:int, volume:Number = 1, panning:Number = 0,
											startTime:Number = 0, loops:int = 0, callback:Function = null):MySound{
			//soundEnum is like Sounds.___, plays it globally and flat
			//always making a soundTransform when playing a sound may be inefficient
			//trace("original mySound: " + sounds[soundEnum]);
			var newSound:MySound = sounds[soundEnum].clone();
			//var newSound:MySound = (clone(sounds[soundEnum])) as MySound;
			//trace("newSound: " + newSound);
			//trace("sound: " + newSound.sound);
			var trans:SoundTransform;
			trans = new SoundTransform(volume, panning); 
			var channel:SoundChannel = newSound.sound.play(startTime, loops);
			channel.soundTransform = trans;
			//newSound.soundTransform = trans;
			newSound.setChannel(channel);
			newSound.setCallback(callback);
			return newSound;
		}
		//soundEnum is like Sounds.___
		//volume 1 is full, 0 is muted
		//panFunc must return a Number between -1 (left) and 1 (right) for the pan value
		//startTime is the number of millis it skips at the start of the sound (if you want to start in the middle of the sound)
		//loops is the number of times it loops the sound (0 to play once)
		public function playSoundPositionalUpdate(soundEnum:int, volFunc:Function, panFunc:Function, 
												  startTime:Number = 0, loops:int = 0, callback:Function = null):MySound{
			var newSound:MySound = sounds[soundEnum].clone();
			var trans:SoundTransform;
			trans = new SoundTransform(volFunc(), panFunc()); 
			var channel:SoundChannel = newSound.sound.play(startTime, loops);
			channel.soundTransform = trans;
			//channel.addEventListener(Event.ENTER_FRAME, channelPanUpdate);
			//channel.addEventListener(Event.SOUND_COMPLETE, onChannelPanComplete);
			//channelPanDict[channel] = panFunc;
			//newSound.soundTransform = trans;
			newSound.setChannel(channel);
			newSound.setCallback(callback);
			newSound.registerPanUpdate(panFunc);
			newSound.registerVolUpdate(volFunc);
			return newSound;
		}
		
		public function playSoundVoice(soundEnum:int, callback:Function = null):MySound{
			return playSoundPositional(soundEnum, 1, anoopPan, 0, 0, callback);
			/*if(soundEnum == Sounds.SOMEANOOPTALK){
				return playSoundPositional(soundEnum, 1, anoopPan, 0, 0, null);
			} else if(soundEnum == Sounds.SOMEANOOPTALK2){
				return playSoundPositional(soundEnum, 1, anoopPan, 0, 0, null);
			}
			
			switch(soundEnum){
				case Sounds.SOMEANOOPTALK:
				case Sounds.SOMEANOOPTALK2:
				case Sounds.SOMEANOOPTALK3:
					return playSoundPositional(soundEnum, 1, anoopPan, 0, 0, null);
					break;
				case Sounds.SOMEPATRICKTALK:
					return playSoundPositional(soundEnum, 1, patrickPan, 0, 0, null);
					break;
					case Sounds.SOMEALEXTALK:
					return playSoundPositional(soundEnum, 1, alexPan, 0, 0, null);
					break;
				default:
					break;
			}*/
		}
		
		//public function channelPanUpdate(evt:Event):void{
			//(channelPanDict[channel] as Function)()
		//}
		
		/*function clone(source:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}*/
	}
}
