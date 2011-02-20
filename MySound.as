package  {
	import flash.media.Sound; 
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform; 
	import flash.utils.ByteArray;
	import flash.events.Event;
	public class MySound extends Sound{

		public var sound:Sound;
		//public var soundTransform:SoundTransform;
		public var channel:SoundChannel;
		private var panFunc:Function;
		
		public function MySound(s:Sound) {
			// constructor code
			sound = s;
			//trace("sound in Mysound: " + sound);
		}
		
		public function registerPanUpdate(panFunction:Function){
			panFunc = panFunction;
			channel.addEventListener(Event.ENTER_FRAME, panUpdate);
			channel.addEventListener(Event.SOUND_COMPLETE, onPanComplete);
		}
		
		public function panUpdate(evt:Event){
			channel.soundTransform.pan = panFunc();
		}
		
		public function onPanComplete(evt:Event){
			channel.removeEventListener(Event.ENTER_FRAME, panUpdate);
			channel.removeEventListener(Event.SOUND_COMPLETE, onPanComplete);
		}
		
		function clone(): MySound {
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
