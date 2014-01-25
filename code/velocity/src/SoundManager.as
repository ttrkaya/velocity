package
{,
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundManager
	{
		[Embed(source='assets/sound/music.mp3')]
		private static const Music:Class;
		private static var _musicChannel:SoundChannel;
		
		public static function playMusic():void
		{
			var music:Sound = new Music();
			_musicChannel = music.play(0,int.MAX_VALUE);
		}
	}
}