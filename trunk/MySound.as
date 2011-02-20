package  {
	import flash.media.Sound; 
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform; 
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	public class MySound extends Sound{

		public var sound:Sound;
		//public var soundTransform:SoundTransform;
		private var channel:SoundChannel;
		private var panFunc:Function;
		
		public function MySound(s:Sound) {
			// constructor code
			sound = s;
			//trace("sound in Mysound: " + sound);
		}
		
		public function registerPanUpdate(panFunction:Function){
			panFunc = panFunction;
			//trace("pan register");
			StageClass.getStage().addEventListener(Event.ENTER_FRAME, panUpdate);
			channel.addEventListener(Event.SOUND_COMPLETE, onPanComplete);
		}
		
		public function panUpdate(evt:Event){
			//trace("old Pan: " + channel.soundTransform.pan + " new pan: " + panFunc());
			//channel.soundTransform.pan = panFunc();
			channel.soundTransform = new SoundTransform(channel.soundTransform.volume, panFunc());
		}
		
		public function onPanComplete(evt:Event){
			//trace("pan complete");
			channel.removeEventListener(Event.ENTER_FRAME, panUpdate);
			channel.removeEventListener(Event.SOUND_COMPLETE, onPanComplete);
		}
		
		public function setChannel(chan:SoundChannel){
			channel = chan;
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
