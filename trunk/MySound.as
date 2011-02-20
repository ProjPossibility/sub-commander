package  {
	import flash.media.Sound; 
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform; 
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;

	public class MySound extends Sound{

		public var sound:Sound;
		//public var soundTransform:SoundTransform;
		private var channel:SoundChannel = null;
		private var panFunc:Function = null;
		private var volFunc:Function = null;
		private var callback:Function = null;
		private var delay:int = 0;
		private var soundEnum:int = -1;
		private var startTime:Number = 0;
		private var loops:int = 0;
		private var t:Timer;
		private var pausePos:int = 0;
		private var paused = false;
		
		public function MySound(s:Sound) {
			// constructor code
			sound = s;
			//trace("sound in Mysound: " + sound);
		}
		
		public function stop(){
			channel.stop();
			returnToCallback(null);
		}
		
		public function terminate(){
			channel.stop();
			doCallback();
		}
		
		public function pause(){
			pausePos = channel.position;
			channel.stop();
			//trace("stopped channel of sound: " + soundEnum);
			paused = true;
		}
		
		public function resume(){
			if(sound == null){
				trace("WHY IS THE SOUND NULL?");
			}
			//trace("resumed channel of sound: " + soundEnum);
			if(channel == null){
				channel = sound.play(pausePos + startTime, loops);
			} else {
				channel = sound.play(pausePos + startTime, loops, channel.soundTransform);
			}
			channel.addEventListener(Event.SOUND_COMPLETE, returnToCallback);
			pausePos = -1;
			paused = false;
		}
		
		public function playSound(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):MySound{
			this.startTime = startTime;
			this.loops = loops;
			/*if(sndTransform == null){
				channel = new SoundChannel();
				channel.soundTransform = new SoundTransform(1, 0);
			} else {
				channel = new SoundChannel();
				channel.soundTransform = sndTransform;
			}*/
			channel = sound.play(startTime, loops, sndTransform);
			channel.addEventListener(Event.SOUND_COMPLETE, returnToCallback);
			return this;
		}
		
		public function isVoiceSound(){
			if(soundEnum >= Sounds.voice1oClockPosition && soundEnum <= Sounds.voiceWeaponsFired){
				return true;
			} else {
				return false;
			}
		}
		
		public function setSoundEnum(s:int){
			soundEnum = s;
			if(isVoiceSound()){
				SoundEngine.getInstance().queueVoiceSound(this);
			}
		}
		
		public function getSoundEnum(){
			return soundEnum;
		}
		
		public function setDelay(d:int){
			delay = d;
		}
		
		public function setCallback(cb:Function){
			if(cb == null){
				return;
			}
			callback = cb;
			channel.addEventListener(Event.SOUND_COMPLETE, returnToCallback);
		}
		
		public function returnToCallback(evt:Event){
			if(isVoiceSound()){
				SoundEngine.getInstance().voiceSoundEnded(this);
			}
			
			doCallback();
			
		}
		
		public function doCallback(){
			if(callback == null){
				return;
			}
			channel.removeEventListener(Event.SOUND_COMPLETE, returnToCallback);
			t = new Timer(delay);
			t.start();
			t.addEventListener(TimerEvent.TIMER, callbackDelayComplete);
		}
		
		public function callbackDelayComplete(evt:Event){
			t.removeEventListener(TimerEvent.TIMER, callbackDelayComplete);
			callback();
		}
		
		public function registerPanUpdate(panFunction:Function){
			panFunc = panFunction;
			//trace("pan register");
			StageClass.getStage().addEventListener(Event.ENTER_FRAME, panUpdate);
			channel.addEventListener(Event.SOUND_COMPLETE, onPanComplete);
		}
		
		public function panUpdate(evt:Event){
			if(paused){
				return;
			}
			//trace("old Pan: " + channel.soundTransform.pan + " new pan: " + panFunc());
			//channel.soundTransform.pan = panFunc();
			//trace("channel: " + channel + " panFunc: " + panFunc);
			channel.soundTransform = new SoundTransform(channel.soundTransform.volume, panFunc());
		}
		
		public function onPanComplete(evt:Event){
			//trace("pan complete");
			channel.removeEventListener(Event.ENTER_FRAME, panUpdate);
			channel.removeEventListener(Event.SOUND_COMPLETE, onPanComplete);
		}
		
		public function registerVolUpdate(volFunction:Function){
			volFunc = volFunction;
			//trace("pan register");
			StageClass.getStage().addEventListener(Event.ENTER_FRAME, volUpdate);
			channel.addEventListener(Event.SOUND_COMPLETE, onVolComplete);
		}
		
		public function volUpdate(evt:Event){
			if(paused){
				return;
			}
			//trace("old Pan: " + channel.soundTransform.pan + " new pan: " + panFunc());
			//channel.soundTransform.pan = panFunc();
			channel.soundTransform = new SoundTransform(volFunc(), channel.soundTransform.pan);
		}
		
		public function onVolComplete(evt:Event){
			//trace("pan complete");
			channel.removeEventListener(Event.ENTER_FRAME, volUpdate);
			channel.removeEventListener(Event.SOUND_COMPLETE, onVolComplete);
		}
		
		public function setChannel(chan:SoundChannel){
			channel = chan;
		}
		
		public function getChannel():SoundChannel{
			return channel;
		}
		
		function clone(): MySound {
			//trace("clone'd");
			var s:Sound = cloneData(sound) as Sound;
			var c:SoundChannel = cloneData(channel) as SoundChannel;
			var newSound:MySound = new MySound(sound);
			newSound.channel = channel;
			return newSound;
		}
		
		function cloneData(source:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}
		

	}
	
}
