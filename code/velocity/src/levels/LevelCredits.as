package levels
{
	
	/**
	 * this level only holds a congratulations screen
	 * @author Paul Brinkkemper
	 */
	import com.greensock.TweenMax;

	
	import flash.display.MovieClip;

	public class LevelCredits extends LevelBase
	{
		public function LevelCredits(main:Main)
		{
			super(main);
			
			//this.setChildIndex(_camera, this.numChildren-1);
			//_platformsView = new EndScreen();
			//_camera.addChild(_platformsView);
			var endScreen:MovieClip = new EndScreen();
			endScreen.alpha = 0;
			this.addChild(endScreen);
			TweenMax.to(endScreen, 1, { alpha: 1 } );
		}
		
		public override function update(dt:Number):void
		{	
			//baseUpdate(dt);
		}
	}
}