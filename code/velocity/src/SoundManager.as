package
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;


	public class SoundManager
	{
		[Embed(source='../sounds/LevelStart.mp3') ]	private static const StartSound:Class;
		[Embed(source='../sounds/Koto beat loop.mp3')]	private static const MovingMusic:Class;
		[Embed(source='../sounds/Koto solo loop.mp3')]	private static const StaticMusic:Class;
		
		private static var _sounChannel:SoundChannel;
		private static var _musicMovingChannel:SoundChannel;
		private static var _musicStaticChannel:SoundChannel;
		
		public static function playMusic():void
		{
			var staticMusic:Sound = new StaticMusic();
			_musicStaticChannel = staticMusic.play(0,int.MAX_VALUE,new SoundTransform(1));
			var movingMusic:Sound = new MovingMusic();
			_musicMovingChannel = movingMusic.play(0,int.MAX_VALUE,new SoundTransform(0));

		}
		public static function playStartLevelSound():void
		{
			var startSound:Sound = new StartSound();
			_musicMovingChannel = startSound.play(0,int.MAX_VALUE);
		}
		public static function playMovingMusic():void	
		{
			_musicMovingChannel.soundTransform = new SoundTransform();
			//TweenMax.to(_musicMovingChannel, 1, {volume: 1});
		}
		public static function fadeOutMovingMusic():void	
		{
			_musicMovingChannel.soundTransform = new SoundTransform(0);
			//TweenMax.to(_musicMovingChannel, 1, {volume: 0});
		}
	}
}