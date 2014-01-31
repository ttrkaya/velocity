package levels
{
		import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	
	public class Level0 extends LevelBase
	{
		public function Level0(main:Main)
		{

			super(main);
			parseLevelFromSwcWithID(0);
			
			for(var i:int=0; i<_staticPlatformViews.length; i++)
			{
				_camera.removeChild(_staticPlatformViews[i]);
			}
			
			_bgMoving = new BackGroundMoving1();
			this.addChild(_bgMoving);
			_bgStatic = new BackGroundStatic1();
			this.addChild(_bgStatic);
			
			this.setChildIndex(_camera, this.numChildren-1);
			_platformsView = new LevelOverlay0();
			_camera.addChild(_platformsView);
			_foreGround = new ForeGroundMoving1();
			_camera.addChild(_foreGround);
			_camera.setChildIndex(_avatarView, _camera.numChildren-1);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);

		}
	}
}