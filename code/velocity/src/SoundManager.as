package
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundManager
	{
		[Embed(source='../sounds/LevelStart.mp3')]
		private static const EndSound:Class;
		[Embed(source='../sounds/Koto beat loop.mp3')]
		private static const MovingMusic:Class;
		[Embed(source='../sounds/Koto solo loop.mp3')]
		private static const StaticMusic:Class;
		[Embed(source='../sounds/Koto beat start.mp3')]
		private static const MovingMusicStart:Class;
		[Embed(source='../sounds/SoundEffects/GhostPassingShort.mp3')]
		private static const GhostPassingSound:Class;
		[Embed(source='../sounds/SoundEffects/GhostPassingLong.mp3')]
		private static const GhostPassingSoundLong:Class;
		[Embed(source='../sounds/SoundEffects/MonkJump.mp3')]
		private static const MonkJumpSound:Class;
		[Embed(source='../sounds/SoundEffects/MonkLand.mp3')]
		private static const MonkLandSound:Class;
		
		private static var _soundChannel:SoundChannel;
		private static var _enemySoundChannel:SoundChannel;
		private static var _musicMovingChannel:SoundChannel;
		private static var _musicStaticChannel:SoundChannel;
		
		private static var enemySoundIsPlaying:Boolean = false;
		
		public static function playMusic():void
		{
			return;
			
			var staticMusic:Sound = new StaticMusic();
			_musicStaticChannel = staticMusic.play(0, 0, new SoundTransform(1));
			
			//this here is added to start the music with a different beat. Unfortunately, it does not work.
			var startingBeat:Sound = new MovingMusicStart();
			_musicMovingChannel = startingBeat.play(0, 0, new SoundTransform(0));
			_musicMovingChannel.addEventListener(Event.SOUND_COMPLETE, onBeatComplete);
			
			var movingMusic:Sound = new MovingMusic();
			_musicMovingChannel = movingMusic.play(0, 0, new SoundTransform(0));
		
		}
		
		static private function onBeatComplete(e:Event):void
		{
			_musicMovingChannel.removeEventListener(Event.SOUND_COMPLETE, onBeatComplete);
			_musicMovingChannel.stop();
			_musicStaticChannel.stop();
			
			var staticMusic:Sound = new StaticMusic();
			_musicStaticChannel = staticMusic.play(0, 0, new SoundTransform(1));
			
			var startingBeat:Sound = new MovingMusicStart();
			_musicMovingChannel = startingBeat.play(0,0,new SoundTransform(0));
			_musicMovingChannel.addEventListener(Event.SOUND_COMPLETE, onBeatComplete);
		}
		
		public static function playLevelEndSound():void
		{
			var startSound:Sound = new EndSound();
			_soundChannel = startSound.play(0, 1);
		}
		
		public static function playJumpSound():void
		{
			var jumpSound:Sound = new MonkJumpSound();
			_soundChannel = jumpSound.play(0, 1);
		}
		
		public static function playLandSound():void
		{
			var landSound:Sound = new MonkLandSound();
			_soundChannel = landSound.play(0, 1);
		}
		
		public static function playGhostSound():void
		{
			if (!enemySoundIsPlaying)
			{ 
				var ghostSound:Sound = Math.random() < 0.5 ? new GhostPassingSound() : new GhostPassingSoundLong();
				_enemySoundChannel =  ghostSound.play(0, 1, new SoundTransform(3));
				_enemySoundChannel.addEventListener(Event.SOUND_COMPLETE, onEnemySoundComplete);
				enemySoundIsPlaying = true;
			}
		}
		
		static private function onEnemySoundComplete(e:Event):void
		{
			enemySoundIsPlaying = false
		}
		
		public static function playMovingMusic():void
		{
			if (_musicMovingChannel != null)
				TweenMax.to(_musicMovingChannel, 1, {volume: 1});
		}
		
		public static function fadeOutMovingMusic():void
		{
			if (_musicMovingChannel != null)
				TweenMax.to(_musicMovingChannel, 1, {volume: 0});
		}
		
		public static function syncMusic():void
		{
			//Syncing makes the game crash
			//var movingMusic:Sound = new MovingMusic();
			//var oldVolume:Number = _musicMovingChannel.soundTransform.volume;
			//_musicMovingChannel = movingMusic.play(_musicStaticChannel.position, int.MAX_VALUE, new SoundTransform(oldVolume));
		
		}
	
	}
}