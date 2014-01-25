package
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;


	public class SoundManager
	{
		[Embed(source='../sounds/LevelStart.mp3') ]	private static const StartSound:Class;
		[Embed(source='../sounds/Koto beat loop.mp3')]	private static const MovingMusic:Class;
		[Embed(source='../sounds/Koto solo loop.mp3')]	private static const StaticMusic:Class;
		[Embed(source = '../sounds/Koto beat start.mp3')]	private static const MovingMusicStart:Class;
		
		private static var _sounChannel:SoundChannel;
		private static var _musicMovingChannel:SoundChannel;
		private static var _musicStaticChannel:SoundChannel;
		
		public static function playMusic():void
		{
			var staticMusic:Sound = new StaticMusic();
			_musicStaticChannel = staticMusic.play(0, int.MAX_VALUE, new SoundTransform(1));
			var startingBeat:Sound = new MovingMusicStart();
			_musicMovingChannel = startingBeat.play(0,int.MAX_VALUE,new SoundTransform(0));
			_musicMovingChannel.addEventListener(Event.SOUND_COMPLETE, onBeatComplete);
		}
		
		static private function onBeatComplete(e:Event):void 
		{
			var movingMusic:Sound = new MovingMusic();
			_musicMovingChannel = movingMusic.play(_musicStaticChannel.position,int.MAX_VALUE,new SoundTransform(_musicMovingChannel.soundTransform.volume));
		}
		public static function playStartLevelSound():void
		{
			var startSound:Sound = new StartSound();
			_musicMovingChannel = startSound.play(0,int.MAX_VALUE);
		}
		public static function playMovingMusic():void	
		{
			_musicMovingChannel.soundTransform = new SoundTransform();
		}
		public static function fadeOutMovingMusic():void	
		{
			_musicMovingChannel.soundTransform = new SoundTransform(0);
		}
		
		public static function syncMusic():void
		{
			var movingMusic:Sound = new MovingMusic();
			_musicMovingChannel = movingMusic.play(_musicStaticChannel.position,int.MAX_VALUE,new SoundTransform(0));
		}
	}
}