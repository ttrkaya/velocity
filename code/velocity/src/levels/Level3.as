package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class Level3 extends LevelBase
	{
		
		
		public function Level3(main:Main)
		{
			super(main);
			parseLevelFromSwcWithID(3);
			
			for(var i:int=0; i<_staticPlatformViews.length; i++)
			{
				_camera.removeChild(_staticPlatformViews[i]);
			}
			
			_bgMoving = new BackGroundMoving3();
			this.addChild(_bgMoving);
			_bgStatic = new BackGroundStatic3();
			this.addChild(_bgStatic);
			
			this.setChildIndex(_camera, this.numChildren-1);
			_platformsView = new LevelOverlay3();
			_camera.addChild(_platformsView);
			_foreGround = new ForeGroundMoving3();
			_camera.addChild(_foreGround);
			_camera.setChildIndex(_avatarView, _camera.numChildren-1);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}