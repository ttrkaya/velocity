package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;

	public class Level2 extends LevelBase
	{
		private var _platformsView:MovieClip;
		
		public function Level2()
		{
			super();
			parse(1);
			
			for(var i:int=0; i<_staticPlatformViews.length; i++)
			{
				_camera.removeChild(_staticPlatformViews[i]);
			}
			_platformsView = new LevelOverlay();
			_camera.addChild(_platformsView);
			_foreGround = new ForeGroundMoving();
			_camera.addChild(_foreGround);
			_camera.setChildIndex(_avatarView, _camera.numChildren-1);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
			_platformsView.alpha = _staticAlpha;
			_foreGround.alpha = 1 - _platformsView.alpha;
		}
	}
}