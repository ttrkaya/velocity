package
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import com.greensock.TweenMax;


	public class SoundManager
	{
		[Embed(source='snd/LevelStart.mp3') ]	private static const StartSound:Class;
		[Embed(source='snd/MovingMusic.mp3')]	private static const MovingMusic:Class;
		[Embed(source='snd/StaticMusic.mp3')]	private static const StaticMusic:Class;
		
		private static var _sounChannel:SoundChannel;
		private static var _musicMovingChannel:SoundChannel;
		private static var _musicStaticChannel:SoundChannel;
		
		public static function playMusic():void
		{
			var music:Sound = new StaticMusic();
			_musicStaticChannel = StaticMusic.play(0,int.MAX_VALUE,new SoundTransform(0));
			TweenMax.to(_musicStaticChannel, 1, {volume: 1});
			var music:Sound = new MovingMusic();
			_musicMovingChannel = MovingMusic.play(0,int.MAX_VALUE,new SoundTransform(0));

		}
		public static function playStartLevelSound():void
		{
			var music:Sound = new StartSound();
			_musicMovingChannel = StartSound.play(0,int.MAX_VALUE);
		}
		public static function playMovingMusic():void	
		{
			TweenMax.to(_musicMovingChannel, 1, {volume: 1});
		}
		public static function fadeOutMovingMusic():void	
		{
			TweenMax.to(_musicMovingChannel, 1, {volume: 0});
		}
	}
}