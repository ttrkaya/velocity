package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;

	public class Level1 extends LevelBase
	{
		private var _platformsView:MovieClip;
		
		public function Level1(main:Main)
		{
			super(main);
			
			//This level is a Flash MovieClip testing level, that can be loaded from Flash
			//This is done to enable rapid level prototyping for level designers

			//While leveldesigning: start editing here;
			////These following  movieclips need to be changed to match the name of the level that you are designing
			
			//This is your design, this contains all your beautifull green platforms and red enemies
			var levelDefinition:MovieClip = new NieuwLevel();
			parseLevelFromMovieClip(levelDefinition);			
			
			//this is your artistic view that the player sees instead of ugly green platforms. In order to leave empty, use: _platformsView = new MovieClip()
			_platformsView = new LevelOverlayLevel1();
			
			//this is the layer of fog that lies before the platforms in the level
			_foreGround = new ForegroundMovingLevel1();
			
			//This is the background layer that the player sees when he is moving around in the level, with the trippy mountains. Comment out this line to use the standard background
			_bgMoving = new BackgroundMovingLevel1();
			
			//This is the standard layer that the player sees when he is not moving around, with very sober mountains. Comment out to use the standard background.
			_bgStatic = new BackgroundStaticLevel1();
			

			
			for(var i:int=0; i<_staticPlatformViews.length; i++)
			{
				//If you still want to see the platforms when you are playing, comment out this line
				//_camera.removeChild(_staticPlatformViews[i]);
			}
			
			//end editing here!
			
			
			_camera.addChild(_platformsView);
			_camera.addChild(_foreGround);
			_camera.setChildIndex(_avatarView, _camera.numChildren-1);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
			//TODO: move this to base class?
			_platformsView.alpha = _staticAlpha;
			_foreGround.alpha = 1 - _platformsView.alpha;
		}
	}
}