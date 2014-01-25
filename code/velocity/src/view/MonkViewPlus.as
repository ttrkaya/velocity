package view
{
	public class MonkViewPlus extends MonkView
	{
		public var isHurt:Boolean;
		public var isInNirvana:Boolean;
		
		public function MonkViewPlus()
		{
			isHurt = false;
			isInNirvana = false;
		}
		
		public function idle():void
		{
			if (this.currentFrame != 1) 
			{
				SoundManager.playLandSound();
				this.gotoAndStop(1);
			}
		}
		
		public function walk():void
		{
			if (this.currentFrame != 2) 
			{
				SoundManager.playLandSound();
				this.gotoAndStop(2);
			}
		}
		
		public function run():void
		{
			if(this.currentFrame != 3) this.gotoAndStop(3);
		}
		
		public function jump():void
		{
			if (this.currentFrame != 4) 
			{
				SoundManager.playJumpSound();
				this.gotoAndStop(4);
			}
		}
		
		public function hurt():void
		{
			isHurt = true;
			if(this.currentFrame != 5) this.gotoAndStop(5);
		}
		
		public function nirvana():void
		{
			isInNirvana = true;
			if(this.currentFrame != 6) this.gotoAndStop(6);
		}
	}
}