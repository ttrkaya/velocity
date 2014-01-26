package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Level7 extends LevelBase
	{
		private var _angle:Number;
		
		private var _wheel:MovieClip;
		private var _wheelMoving:MovieClip;
		
		private const CENTER:Point = new Point(400, -600);
		private const R:Number = 150;
		private const W:Number = 60;
		private const H:Number = 10;
		
		public function Level7(main:Main)
		{
			var i:int;
			
			super(main);
			parseLevelFromSwcWithID(7);
			
			_wheel = new Wheel();
			_camera.addChild(_wheel);
			
			_wheelMoving = new WheelMoving();
			_wheelMoving.x = 400;
			_wheelMoving.y = -600;
			_camera.addChild(_wheelMoving);
			_camera.setChildIndex(_wheelMoving, 0);
			_camera.setChildIndex(_wheel, 0);
			
			_rotatingPlatformBodies = new Vector.<b2Body>;
			_rotatingPlatformViews = new Vector.<MovieClip>;
			
			_angle = 0;
			for(i=0; i<6; i++)
			{
				var angle:Number = 2*Math.PI*i/6;
				var px:Number = Math.cos(angle) * R + CENTER.x;
				var py:Number = Math.sin(angle) * R + CENTER.y;
				
				var movingPlatformBody:b2Body = _physicsManager.createKinematicRectangle(
					px, py, W/2, H/2, 0, 3);
				_rotatingPlatformBodies.push(movingPlatformBody);
				var movingPlatformView:MovieClip = new MovingPlatformerView();
				movingPlatformView.x = px;
				movingPlatformView.y = py;
				movingPlatformView.width = W*2;
				movingPlatformView.height = H*3;
				_rotatingPlatformViews.push(movingPlatformView);
				_camera.addChild(movingPlatformView);
			}
		}
		
		public override function update(dt:Number):void
		{	
			var i:int;
			
			baseUpdate(dt);
			
			_angle += dt * 0.4;
			for(i=0; i<6; i++)
			{
				var angle:Number = 2*Math.PI*i/6 + _angle;
				var px:Number = Math.cos(angle) * R + CENTER.x;
				var py:Number = Math.sin(angle) * R + CENTER.y;
				
				_rotatingPlatformBodies[i].SetLinearVelocity(new b2Vec2(
					(px/PhysicsManager.RATIO - _rotatingPlatformBodies[i].GetPosition().x) / dt,
					(py/PhysicsManager.RATIO - _rotatingPlatformBodies[i].GetPosition().y) / dt));
				
				_rotatingPlatformViews[i].x = px;
				_rotatingPlatformViews[i].y = py;
			}
			
			var cameraTargetY:Number = 500 - _avatarBody.GetPosition().y * PhysicsManager.RATIO;
			if(cameraTargetY < 0) cameraTargetY = 0;
			_camera.y += (cameraTargetY - _camera.y) * dt;
			
			_wheel.alpha = _staticAlpha;
			_wheelMoving.alpha = 1 - _wheel.alpha;
		}
	}
}