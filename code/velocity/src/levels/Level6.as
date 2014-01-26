package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;

	public class Level6 extends LevelBase
	{
		
		public function Level6(main:Main)
		{
			super(main);
			parseLevelFromSwcWithID(6);
			
			for(var i:int=0; i<_staticPlatformViews.length; i++)
			{
				_camera.removeChild(_staticPlatformViews[i]);
			}
			
			_bgMoving = new BackGroundMoving6();
			this.addChild(_bgMoving);
			_bgStatic = new BackGroundStatic6();
			this.addChild(_bgStatic);
			
			this.setChildIndex(_camera, this.numChildren-1);
			_platformsView = new LevelOverlay6();
			_camera.addChild(_platformsView);
			_foreGround = new ForeGroundMoving6();
			_camera.addChild(_foreGround);
			_camera.setChildIndex(_avatarView, _camera.numChildren-1);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}