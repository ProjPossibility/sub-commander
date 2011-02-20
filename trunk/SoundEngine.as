package  {
	import flash.events.Event; 
	import flash.media.Sound; 
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform; 
	import flash.media.SoundMixer; 
	import flash.net.URLRequest; 
	import flash.net.FileReference;
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
			doneRequestingSounds = true;
		}
		
		private function loadSound(fileLoc:String){
			var snd:Sound = new Sound();
			var req:URLRequest = new URLRequest(fileLoc); 
			snd.addEventListener(Event.COMPLETE, doLoadComplete);
			snd.load(req);
			sounds[sounds.length] = snd;
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
				playSoundPositional(Sounds.waves, 1, 0, 500);//skipping a half second of delay at the start
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
		
		public function playSound(soundEnum:int):void{
			//soundEnum is like Sounds.___, plays it globally and flat
			sounds[soundEnum].play();
		}
		
		public function playSoundPositional(soundEnum:int, volume:Number = 1, panning:Number = 0, startTime:Number = 0, loops:int = 0):void{
			//soundEnum is like Sounds.___, plays it globally and flat
			//always making a soundTransform when playing a sound may be inefficient
			var trans:SoundTransform;
			trans = new SoundTransform(volume, panning); 
			var channel:SoundChannel = sounds[soundEnum].play(startTime, loops);
			channel.soundTransform = trans;
			//should potentially be updating the channel with new trans data based on movement in update
			//channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete); 
		}
	}
}
