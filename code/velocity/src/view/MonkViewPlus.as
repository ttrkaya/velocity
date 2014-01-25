package view
{
	public class MonkViewPlus extends MonkView
	{
		public function MonkViewPlus()
		{
			super();
		}
		
		public function idle():void
		{
			if(this.currentFrame != 1) this.gotoAndStop(1);
		}
		
		public function walk():void
		{
			if(this.currentFrame != 2) this.gotoAndStop(2);
		}
		
		public function run():void
		{
			if(this.currentFrame != 3) this.gotoAndStop(3);
		}
		
		public function jump():void
		{
			if(this.currentFrame != 4) this.gotoAndStop(4);
		}
		
		public function hurt():void
		{
			if(this.currentFrame != 5) this.gotoAndStop(5);
		}
	}
}