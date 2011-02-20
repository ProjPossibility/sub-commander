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
				playSound(Sounds.waves, 500);//skipping a half second of delay at the start
			}
			//CAN'T UNLOAD ACTION LISTENER, POSSIBLY INEFFICIENT BUT ONLY ONCE FOR EACH SOUND
			totalSoundsLoaded++;
			if(doneRequestingSounds){
				if(totalSoundsLoaded == sounds.length){
					//we've requested all the sounds and loaded all of them
					doneLoadingSounds = true;
					trace("done loading sounds");
					loadDoneCallback();
					//playSound(Sounds.ambient);
					//playSound(Sounds.ping);
				}
			}
			//trace("Song loaded.");
			//var trans:SoundTransform; 
			//trans = new SoundTransform(1, 0); 
			//var channel:SoundChannel = sounds[0].play(0, 20); 
			//channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete); 
			//sounds[0].play(0, 20);
		}
		
		function onPlaybackComplete(event:Event):void 
		{ 
			//trace("playback complete");
		}
		
		public function playSound(soundEnum:int, startTime:Number = 0, loops:int = 0):void{
			//soundEnum is like Sounds.ping, this plays it globally and flat
			//trace("awooga: " + soundEnum);
			//trace(sounds[soundEnum]);
			sounds[soundEnum].play(startTime, loops);
		}
	}
}
