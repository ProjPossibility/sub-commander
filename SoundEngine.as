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
		//private var channelPanDict:Dictionary = new Dictionary();
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
			loadSound("Audio/Sound/Sonar/Sonar01.mp3");//Sounds.Ping = 1
			loadSound("Audio/Sound/Underwater/Underwater04.mp3");//Sounds.Underwater = 2
			loadSound("Audio/Sound/Engine/dieselEngine01.mp3");//Sounds.engine = 3
			loadSound("Audio/Sound/Alarm/Klaxon01.mp3");//Sounds.klaxon = 4
			loadSound("Audio/Sound/Explosion/waterExplosion01.mp3");//Sounds.explosion = 5
			loadSound("Audio/Sound/Torpedo/torpedo01.mp3");//Sounds.torpedoLaunch
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
			trace("Sound loaded: " + finalURL);
			if(finalURL  == bgmusicFileName){
				//playSound(Sounds.waves);
				playSoundPositional(Sounds.waves, .3, 0, 500);//skipping a half second of delay at the start
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
		
		/*function onPlaybackComplete(event:Event):void 
		{ 
			//trace("playback complete");
		}*/
		
		//soundEnum is like Sounds.___, plays it globally and flat
		public function playSound(soundEnum:int):void{
			sounds[soundEnum].clone().sound.play();
		}
		
		//soundEnum is like Sounds.___
		//volume 1 is full, 0 is muted
		//panning must be a Number between -1 (left) and 1 (right) for the pan value
		//startTime is the number of millis it skips at the start of the sound (if you want to start in the middle of the sound)
		//loops is the number of times it loops the sound (0 to play once)
		public function playSoundPositional(soundEnum:int, volume:Number = 1, panning:Number = 0,
											startTime:Number = 0, loops:int = 0):void{
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
		}
		//soundEnum is like Sounds.___
		//volume 1 is full, 0 is muted
		//panFunc must return a Number between -1 (left) and 1 (right) for the pan value
		//startTime is the number of millis it skips at the start of the sound (if you want to start in the middle of the sound)
		//loops is the number of times it loops the sound (0 to play once)
		public function playSoundPositionalUpdate(soundEnum:int, volume:Number, panFunc:Function, 
												  startTime:Number = 0, loops:int = 0):void{
			var newSound:MySound = sounds[soundEnum].clone();
			var trans:SoundTransform;
			trans = new SoundTransform(volume, panFunc()); 
			var channel:SoundChannel = newSound.sound.play(startTime, loops);
			channel.soundTransform = trans;
			//channel.addEventListener(Event.ENTER_FRAME, channelPanUpdate);
			//channel.addEventListener(Event.SOUND_COMPLETE, onChannelPanComplete);
			//channelPanDict[channel] = panFunc;
			//newSound.soundTransform = trans;
			newSound.setChannel(channel);
			newSound.registerPanUpdate(panFunc);
			//activePositionalSounds
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
