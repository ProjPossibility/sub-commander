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
		
		private var voiceSounds:Array = new Array();
		
		public static var anoopPan:Number = 0; //pan values for speakers
		public static var patrickPan:Number = .7;
		public static var alexPan:Number = -.7;
		
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
			loadSound("Audio/Sound/Sonar/Sonar03.mp3");//Sounds.pingEnemy = 3
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
			//Re-record this one below
			loadSound("Audio/Voice/weaponsFired.mp3");//Sounds.voice
			//End of voices
			loadSound("Audio/Sound/Animals/dolphin01.mp3");//Sounds.dolphin = 42
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
		//delay in millis
		public function playSound(soundEnum:int, callback:Function = null, delay:int = 0):MySound{
			var newSound:MySound = sounds[soundEnum].clone();
			newSound.setChannel(new SoundChannel());
			newSound.setCallback(callback);
			newSound.setDelay(delay);
			newSound.playSound();
			newSound.setSoundEnum(soundEnum);
			return newSound;
		}
		
		//soundEnum is like Sounds.___
		//volume 1 is full, 0 is muted
		//panning must be a Number between -1 (left) and 1 (right) for the pan value
		//startTime is the number of millis it skips at the start of the sound (if you want to start in the middle of the sound)
		//loops is the number of times it loops the sound (0 to play once)
		//delay in millis
		public function playSoundPositional(soundEnum:int, volume:Number = 1, panning:Number = 0,
											startTime:Number = 0, loops:int = 0, callback:Function = null, delay:int = 0):MySound{
			//soundEnum is like Sounds.___, plays it globally and flat
			//always making a soundTransform when playing a sound may be inefficient
			//trace("original mySound: " + sounds[soundEnum]);
			var newSound:MySound = sounds[soundEnum].clone();
			//var newSound:MySound = (clone(sounds[soundEnum])) as MySound;
			//trace("newSound: " + newSound);
			//trace("sound: " + newSound.sound);
			var trans:SoundTransform;
			trans = new SoundTransform(volume, panning); 
			//var channel:SoundChannel = 
			newSound.playSound(startTime, loops, trans);
			//channel.soundTransform = trans;
			//newSound.soundTransform = trans;
			//newSound.setChannel(channel);
			newSound.setCallback(callback);
			newSound.setDelay(delay);
			newSound.setSoundEnum(soundEnum);
			return newSound;
		}
		//soundEnum is like Sounds.___
		//volume 1 is full, 0 is muted
		//panFunc must return a Number between -1 (left) and 1 (right) for the pan value
		//startTime is the number of millis it skips at the start of the sound (if you want to start in the middle of the sound)
		//loops is the number of times it loops the sound (0 to play once)
		//delay in millis
		public function playSoundPositionalUpdate(soundEnum:int, volFunc:Function, panFunc:Function, 
												  startTime:Number = 0, loops:int = 0, callback:Function = null, delay:int = 0):MySound{
			var newSound:MySound = sounds[soundEnum].clone();
			var trans:SoundTransform;
			trans = new SoundTransform(volFunc(), panFunc()); 
			/*var channel:SoundChannel = */
			newSound.playSound(startTime, loops, trans);
			//channel.soundTransform = trans;
			//channel.addEventListener(Event.ENTER_FRAME, channelPanUpdate);
			//channel.addEventListener(Event.SOUND_COMPLETE, onChannelPanComplete);
			//channelPanDict[channel] = panFunc;
			//newSound.soundTransform = trans;
			//newSound.setChannel(channel);
			newSound.setCallback(callback);
			newSound.setDelay(delay);
			newSound.registerPanUpdate(panFunc);
			newSound.registerVolUpdate(volFunc);
			newSound.setSoundEnum(soundEnum);
			return newSound;
		}
		
		//only plays if this voice is not already playing
		public function playVoicePassive(soundEnum:int, volume:Number = 1, panning:Number = 0,
											startTime:Number = 0, loops:int = 0, callback:Function = null, delay:int = 0):MySound{
			for(var i:int = 0; i < voiceSounds.length; i++){
				if(voiceSounds.length > 0){
					//if there is another voice sound, don't add me
					return null;
				}
			}
			return playSoundPositional(soundEnum, volume, panning, startTime, loops, callback, delay);
		}
		
		//only plays if this voice is not already playing
		public function playVoicePassiveUpdate(soundEnum:int, volFunc:Function, panFunc:Function, 
												  startTime:Number = 0, loops:int = 0, callback:Function = null, delay:int = 0):MySound{
			for(var i:int = 0; i < voiceSounds.length; i++){
				if(voiceSounds.length > 0){
					//if there is another voice sound, don't add me
					return null;
				}
			}
			return playSoundPositionalUpdate(soundEnum, volFunc, panFunc, startTime, loops, callback, delay);
		}
		
		//cancels all other voice sounds
		public function playVoiceAggressive(soundEnum:int, volume:Number = 1, panning:Number = 0,
											startTime:Number = 0, loops:int = 0, callback:Function = null, delay:int = 0):MySound{
			for(var i:int = 0; i < voiceSounds.length; i++){
				if(voiceSounds.length > 0){
					//if there is another voice sound, don't add me
					return null;
				}
			}
			return playSoundPositional(soundEnum, volume, panning, startTime, loops, callback, delay);
		}
		
		//cancels all other voice sounds
		public function playVoiceAgressiveUpdate(soundEnum:int, volFunc:Function, panFunc:Function, 
												  startTime:Number = 0, loops:int = 0, callback:Function = null, delay:int = 0):MySound{
			for(var i:int = 0; i < voiceSounds.length; i++){
				if(voiceSounds.length > 0){
					//if there is another voice sound, don't add me
					return null;
				}
			}
			return playSoundPositionalUpdate(soundEnum, volFunc, panFunc, startTime, loops, callback, delay);
		}
		
		public function playSoundOClockPosition(angle:Number, pan:Number, callback:Function = null, delay:int = 0):MySound{
			var oclockPos:int = ((angle-15)/360)*12;
			if(oclockPos <= 0){
				oclockPos = 12;
			}
			var soundEnum:int;
			switch(oclockPos){
				case 1:
					soundEnum = Sounds.voice1oClockPosition;
					break;
				case 2:
					soundEnum = Sounds.voice2oClockPosition;
					break;
				case 3:
					soundEnum = Sounds.voice3oClockPosition;
					break;
				case 4:
					soundEnum = Sounds.voice4oClockPosition;
					break;
				case 5:
					soundEnum = Sounds.voice5oClockPosition;
					break;
				case 6:
					soundEnum = Sounds.voice6oClockPosition;
					break;
				case 7:
					soundEnum = Sounds.voice7oClockPosition;
					break;
				case 8:
					soundEnum = Sounds.voice8oClockPosition;
					break;
				case 9:
					soundEnum = Sounds.voice9oClockPosition;
					break;
				case 10:
					soundEnum = Sounds.voice10oClockPosition;
					break;
				case 11:
					soundEnum = Sounds.voice11oClockPosition;
					break;
				case 12:
					soundEnum = Sounds.voice12oClockPosition;
					break;
				default:
					break;
			}
			return playSoundPositional(soundEnum, 1, pan, 0, 0, callback, delay);
		}
		
		public function queueVoiceSound(snd:MySound){
			for(var i:int = 0; i < voiceSounds.length; i++){
				if((voiceSounds[i] as MySound).getSoundEnum() == snd.getSoundEnum()){
					//if we are the same sound, don't add me
					snd.terminate();
					return;
				}
			}
			trace("enqueue sound: " + snd.getSoundEnum());
			voiceSounds.push(snd);
			if(voiceSounds.length > 1){
				snd.pause();
				trace("pause sound: " + snd.getSoundEnum());
			}
		}
		
		public function voiceSoundEnded(snd:MySound){
			trace("dequeue sound: " + snd.getSoundEnum());
			if(voiceSounds[0] != snd){
				trace("THESE SHOULD BE EQUAL, SOMETHING BAD HAPPENED IN SOUNDENGINE voiceSoundEnded");
			}
			voiceSounds.shift();
			if(voiceSounds.length > 0){
				voiceSounds[0].resume();
			}
		}
		
		/*public function playSoundVoice(soundEnum:int, callback:Function = null):MySound{
			//return playSoundPositional(soundEnum, 1, anoopPan, 0, 0, callback);
			if(soundEnum == Sounds.SOMEANOOPTALK){
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
			}
		//}
		
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
